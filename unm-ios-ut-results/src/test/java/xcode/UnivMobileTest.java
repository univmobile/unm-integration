package xcode;

import static org.apache.commons.lang3.CharEncoding.UTF_8;
import static org.junit.Assert.fail;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.eclipse.jgit.api.errors.GitAPIException;
import org.eclipse.jgit.lib.ObjectId;
import org.eclipse.jgit.revwalk.RevCommit;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import fr.univmobile.ios.ut.JGitHelper;
import fr.univmobile.ios.ut.TestCaseResult;
import fr.univmobile.ios.ut.TestResultLoader;
import fr.univmobile.ios.ut.TestSuiteResult;

/**
 * Load in memory some test results committed in "
 * <code>./data/xcodebuild_test.log</code>" (not always the last test results
 * fetched by git, but can fetch more ancien test results in source control, see
 * below). <br>
 * Then, run some parameterized Java tests based on the Xcode test results found
 * in the "<code>./data/xcodebuild_test.log</code>" and returning the same
 * result (success | failure | error). <br>
 * If no tag was previously set in git on the committed test result file, this
 * class sets a tag on the file, preventing it to be selected again a next time
 * it is run.
 * <p>
 * If after the "tag" step, there is still be some non-tagged commits of the "
 * <code>./data/xcodebuild_test.log</code>" file, this class creates a dummy
 * commit and pushes it to the remote git repository so nex time Jenkins polls
 * the SCM, it reloads it and reruns this test class, incrementing what "
 * <code>./data/xcodebuild_test.log</code>" commits are being processed and
 * tagged.
 * <p>
 * By default, this class actually performs the following algorithm:
 * <ul>
 * <li>If the last commit (HEAD) on master has already a tag, useit.
 * <li>Otherwise, look at the previous commit on master. If this previous commit
 * has no tag, iterate (look at the previous commit of this previous commit,
 * etc.). Otherwise, stop, and take the current commit with no tag.
 * <li>If no commit on master has already a tag, take the most ancient.
 * </ul>
 * You can override this behaviour by passing a "
 * <code>testResultsCommitId</code>" (= 40-char git commit ID) variable in the
 * Sytem properties.
 * <p>
 * By default, this class sets a git tag (if not already present) on the commit
 * it worked on. You can override this behaviour by setting a "
 * <code>tagCommitAfterLaunch</code>" System-property to <code>FALSE</code>.
 * <p>
 * By default, if there remain some non-tagged commits for the "
 * <code>./data/xcodebuild_test.log</code>" in git after setting current
 * commit’s tag, this class commits a (dummy) change on another file, so Jenkins
 * reloads it and launches it on next poll. You can override this behaviour by
 * setting a "<code>relaunchByCommitting</code>" System-property to
 * <code>FALSE</code>.
 */
@RunWith(Parameterized.class)
public class UnivMobileTest {

	@Parameters(name = "{0}.{1}")
	public static Iterable<Object[]> parameters() throws Exception {

		final JGitHelper jgitHelper = new JGitHelper(new File("../.git"));
		try {

			return parameters(jgitHelper);

		} finally {
			jgitHelper.close();
		}
	}

	private static Collection<Object[]> parameters(final JGitHelper jgitHelper)
			throws Exception {

		final String testResultsCommitId;

		if (isEnvSet("testResultsCommitId")) {

			testResultsCommitId = System.getProperty("testResultsCommitId");

		} else {

			testResultsCommitId = findOldestCommitWithoutTag(jgitHelper);
		}

		final boolean tagCommitAfterLaunch = loadEnv("tagCommitAfterLaunch",
				false);

		final boolean relaunchByCommitting = loadEnv("relaunchByCommitting",
				true);

		final ObjectId revFileId = jgitHelper.getRevFileIdInCommit(
				"unm-ios-ut-results/data/xcodebuild_test.log",
				jgitHelper.getCommitById(testResultsCommitId));

		final byte[] bytes = jgitHelper.loadRevFileContent(revFileId);

		System.out.println("Loading test results at commit="
				+ testResultsCommitId + "...");

		System.out.println("bytes: " + bytes.length);

		final TestResultLoader testResultsLoader = new TestResultLoader(bytes);

		if (testResultsLoader.rootTestSuiteResult == null) {
			System.out.println( //
					"** The Test Result File doesn't contain any Test Suite. -- Dumping...");
			System.out.println(new String(bytes, UTF_8));
		} else {
			System.out.println("Loaded test results: "
					+ testResultsLoader.rootTestSuiteResult.sizeOfTests());
		}

		System.out.println();

		System.out.println("Xcode Test Results -- "
				+ "(git repository is: \"unm-ios-ut-results\")");
		System.out.println("  Git Commit: " + testResultsCommitId + " ("
				+ isEnvSet_toText("testResultsCommitId") + ")");
		System.out.println("  Tag After: " + tagCommitAfterLaunch + " ("
				+ isEnvSet_toText("tagCommitAfterLaunch") + ")");
		System.out.println("  Relaunch: " + relaunchByCommitting + " ("
				+ isEnvSet_toText("relaunchByCommitting") + ")");

		System.out.println();

		System.out
				.println("Xcode Execution -- (git repository is: \"unm-ios\")");
		System.out.println("  Begin Date: " + testResultsLoader.beginDate);
		System.out.println("  Git Commit: " + testResultsLoader.gitCommit);

		System.out.println();

		if (tagCommitAfterLaunch) {

			final String tagName = "processedTestResults/"
					+ testResultsCommitId;

			System.out.println("tagCommitAfterLaunch is set:");

			try {

				if (jgitHelper.hasTag(tagName)) {

					System.out.println("tag: " + tagName + " already exists.");

				} else {

					System.out.println("Adding tag: " + tagName
							+ " to commit: " + testResultsCommitId + "...");

					jgitHelper.addTagToCommit(tagName, testResultsCommitId,
							"Set by UnivMobileTest.java");
				}

				System.out.println("Pushing tags...");

				jgitHelper.pushTags();

			} catch (final Exception e) {

				e.printStackTrace();

				throw e;
			}

			System.out.println();
		}

		if (testResultsLoader.rootTestSuiteResult == null) {

			throw new IllegalStateException(
					"Error: The Test Result File doesn't contain any Test Suite.");
		}

		final List<Object[]> parameters = new ArrayList<Object[]>();

		loadInitParameters(parameters, testResultsLoader.rootTestSuiteResult);

		return parameters;
	}

	private static void loadInitParameters(
			final Collection<Object[]> parameters,
			final TestSuiteResult testSuiteResult) {

		for (final TestCaseResult testCaseResult : testSuiteResult
				.getTestCaseResults()) {

			parameters.add(new Object[] { testSuiteResult, testCaseResult });
		}

		for (final TestSuiteResult subTestSuiteResults : testSuiteResult
				.getSubTestSuiteResults()) {

			loadInitParameters(parameters, subTestSuiteResults);
		}
	}

	private static String findOldestCommitWithoutTag(final JGitHelper jgitHelper)
			throws IOException, GitAPIException {

		final RevCommit[] commits = jgitHelper
				.getAllCommitsForFileFromHead("unm-ios-ut-results/data/xcodebuild_test.log");

		// 1. FIRST COMMIT IS TAGGED? USE IT.

		final String commitId0 = commits[0].getName();

		if (jgitHelper.hasTag("processedTestResults/" + commitId0)) {
			return commitId0;
		}

		// 2. USE COMMIT WITH TAGGED PARENT AND NO TAGGED DESCENDANT

		String commitIdWithoutTag = commitId0;

		for (int i = 0; i < commits.length; ++i) {

			final String commitId = commits[i].getName();

			if (jgitHelper.hasTag("processedTestResults/" + commitId)) {
				return commitIdWithoutTag;
			}

			commitIdWithoutTag = commitId;
		}

		// 3. USE LAST COMMIT, NOT TAGGED

		return commitIdWithoutTag;
	}

	public UnivMobileTest(final TestSuiteResult testSuiteResult,
			final TestCaseResult testCaseResult) {

		this.testCaseResult = testCaseResult;
	}

	private final TestCaseResult testCaseResult;

	@Test
	public void xcodebuild() throws Exception {

		final long start = System.currentTimeMillis();

		final String message = testCaseResult.getMessage();

		for (final String line : testCaseResult.getOutputLines()) {

			System.out.println(line);
		}

		final long elapsedTimeMs = System.currentTimeMillis() - start;

		final long sleepTime = testCaseResult.getElapsedTimeMs()
				- elapsedTimeMs;

		if (sleepTime > 0) {

			// Thread.sleep(sleepTime);
		}

		if (testCaseResult.isError()) {
			throw new Exception(message);
		}

		if (testCaseResult.isFailure()) {
			fail(message);
		}
	}

	private static boolean loadEnv(final String propertyName,
			final boolean defaultValue) {

		final String systemPropertyValue = System.getProperty(propertyName);

		return systemPropertyValue == null //
		? defaultValue
				: Boolean.parseBoolean(systemPropertyValue);
	}

	/*
	 * @Nullable private static boolean loadEnvString(final String propertyName)
	 * {
	 * 
	 * final String systemPropertyValue = System.getProperty(propertyName);
	 * 
	 * return systemPropertyValue == null // ? defaultValue :
	 * Boolean.parseBoolean(systemPropertyValue); }
	 */

	/*
	 * private static String loadEnv(final String propertyName, final String
	 * defaultValue) {
	 * 
	 * final String systemPropertyValue = System.getProperty(propertyName);
	 * 
	 * return systemPropertyValue == null // ? defaultValue :
	 * systemPropertyValue; }
	 */

	private static String isEnvSet_toText(final String propertyName) {

		if (isEnvSet(propertyName)) {

			return "forced by env var: " + propertyName;

		} else {

			return propertyName + " env var is not set";
		}
	}

	private static boolean isEnvSet(final String propertyName) {

		return System.getProperty(propertyName) != null;
	}
}

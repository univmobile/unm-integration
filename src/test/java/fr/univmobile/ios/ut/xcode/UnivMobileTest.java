package fr.univmobile.ios.ut.xcode;

import static org.junit.Assert.fail;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

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
 * You can override this behaviour by passing a "<code>commitId</code>" (=
 * 40-char git commit ID) variable in the Sytem properties.
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
	public static Iterable<Object[]> parameters() throws IOException {

		final List<Object[]> parameters = new ArrayList<Object[]>();

		final TestResultLoader loader = new TestResultLoader(new File(
				"data/xcodebuild_test.log"));

		loadInitParameters(parameters, loader.rootTestSuiteResult);

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

	public UnivMobileTest(final TestSuiteResult testSuiteResult,
			final TestCaseResult testCaseResult) {

		this.testCaseResult = testCaseResult;
	}

	private final TestCaseResult testCaseResult;

	@Test
	public void xcodebuild() throws Exception {

		final long start = System.currentTimeMillis();
		
		final String message = testCaseResult.getMessage();
		
		for (final String line: testCaseResult.getOutputLines()) {
			
			System.out.flush();
			System.err.flush();
			
			if (message != null && line.contains(message)) {

				System.err.println(line);

			} else {
				
				System.out.println(line);
			}
		}
		
		final long elapsedTimeMs = System.currentTimeMillis() - start;		
		
		Thread.sleep(testCaseResult.getElapsedTimeMs() - elapsedTimeMs);
		
		if (testCaseResult.isError()) {
			throw new Exception(message);
		}

		if (testCaseResult.isFailure()) {
			fail(message);
		}
	}
}

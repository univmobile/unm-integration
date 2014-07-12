package fr.univmobile.ios.ut;

import static org.apache.commons.lang3.CharEncoding.UTF_8;
import static org.apache.commons.lang3.StringUtils.substringAfter;
import static org.apache.commons.lang3.StringUtils.substringAfterLast;
import static org.apache.commons.lang3.StringUtils.substringBetween;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Nullable;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class TestResultLoader {

	public final DateTime beginDate;

	@Nullable
	public final DateTime testDate;

	@Nullable
	public final DateTime endDate;

	public final String gitCommit;

	public final boolean buildSucceeded;

	public final boolean testSucceeded;

	private final List<String> lines;

	@Nullable
	public String user;

	@Nullable
	public String getUser() {

		return user;
	}

	@Nullable
	public final TestSuiteResult rootTestSuiteResult;

	public TestResultLoader(final File file) throws IOException {

		this(FileUtils.readFileToByteArray(file));
	}

	public TestResultLoader(final byte[] bytes) throws IOException {

		final InputStream is = new ByteArrayInputStream(bytes);
		try {

			this.lines = IOUtils.readLines(is, UTF_8);

		} finally {
			is.close();
		}

		this.beginDate = loadDateFromLineWithPrefix("Begin Date: ");

		this.testDate = loadDateFromLineWithPrefix("Test Date: ");

		this.endDate = loadDateFromLineWithPrefix("End Date: ");

		this.gitCommit = loadStringFromLineWithPrefix("Git Commit: ");

		this.buildSucceeded = hasLine("Build succeeded.");

		this.testSucceeded = hasLine("** TEST SUCCEEDED **");

		TestSuiteResult rootTestSuiteResult = null;

		for (final Iterator<String> it = lines.iterator(); it.hasNext();) {

			final String line = it.next();

			// "Test Suite 'All tests' started at 2014-07-10 08:40:30 +0000"

			if (line.startsWith("Test Suite 'All tests' started at ")) {

				if (rootTestSuiteResult != null) {
					throw new IllegalStateException(
							"Duplicate root Test Suite: 'All tests'");
				}

				rootTestSuiteResult = new TestSuiteResult("All tests",
						loadTestDate(line));

				parseTestSuiteResult(it, rootTestSuiteResult);
			}
		}

		this.rootTestSuiteResult = rootTestSuiteResult;
	}

	private static void parseTestSuiteResult(final Iterator<String> it,
			final TestSuiteResult testSuiteResult) throws IOException {

		final String name = testSuiteResult.name;

		while (it.hasNext()) {

			final String line = it.next();

			// "Test Suite 'UnivMobileTests.xctest' started at 2014-07-10 08:40:30 +0000"

			if (line.startsWith("Test Suite '")
					&& line.contains("' started at ")) {

				final String testSuiteName = substringBetween(line, "'", "'");

				final TestSuiteResult subTestSuiteResult = new TestSuiteResult(
						testSuiteName, loadTestDate(line));

				testSuiteResult.addSubTestSuiteResult(subTestSuiteResult);

				parseTestSuiteResult(it, subTestSuiteResult);

			} else if (line.startsWith("Test Case '-[" + name + " ")
					&& line.endsWith("' started.")) {

				final String testCaseId = substringBetween(line, "'", "'");

				final TestCaseResult testCaseResult = new TestCaseResult(
						testCaseId);

				testCaseResult.addOutputLine(line);

				testSuiteResult.addTestCaseResult(testCaseResult);

				parseTestCaseResult(it, testCaseResult);

			} else if (line
					.startsWith("Test Suite '" + name + "' finished at ")) {

				testSuiteResult.setFinishedAt(loadTestDate(line));

				return; // end the TestSuiteResult
			}
		}
	}

	private static void parseTestCaseResult(final Iterator<String> it,
			final TestCaseResult testCaseResult) throws IOException {

		final String id = testCaseResult.id;

		while (it.hasNext()) {

			final String line = it.next();

			testCaseResult.addOutputLine(line);

			if (line.startsWith("Test Case '" + id + "' ")) {

				if (line.contains("' passed (")) {

					testCaseResult.setPassed();

					testCaseResult.setElapsedTimeMs(loadTestElapsedTime(line));

					return; // end the TestCaseResult

				} else if (line.contains("' failed (")) {

					testCaseResult.setFailed();

					testCaseResult.setElapsedTimeMs(loadTestElapsedTime(line));

					return; // end the TestCaseResult

				} else {

					throw new IOException("Unknown TestCase status: " + line);
				}

			} else if (line.contains("error: " + id + " : ")) {

				final String message = substringAfter(line, "error: " + id
						+ " : ");

				testCaseResult.setMessage(message);

				if (line.startsWith("<unknown>:0:")) {

					testCaseResult.setError();

				} else {

					testCaseResult.setFailed();
				}
			}
		}
	}

	private static int loadTestElapsedTime(final String line) {

		// "Test Case '-[xxx xxx]' passed (0.001 seconds)."

		final String valueAsString = substringBetween(line, " (", " seconds).");

		final float valueAsFloat = Float.parseFloat(valueAsString);

		return (int) (valueAsFloat * 1000);
	}

	@Nullable
	private DateTime loadDateFromLineWithPrefix(final String prefix) {

		// e.g. "Thu 10 Jul 2014 10:40:22 CEST"

		final DateTimeFormatter formatter1 = DateTimeFormat
				.forPattern("EEE dd MMM YYYY HH:mm:ss");

		// e.g. "Fri Jul 11 01:09:57 CEST 2014"

		final DateTimeFormatter formatter2 = DateTimeFormat
				.forPattern("EEE MMM dd HH:mm:ss YYYY");

		for (final String line : lines) {

			if (line.startsWith(prefix)) {

				final String value = substringAfter(line, prefix);

				try {

					return formatter1.parseDateTime(value.substring(0, 24));

				} catch (final IllegalArgumentException e) {

					// do nothing: Try the other formatter
				}

				return formatter2.parseDateTime(value.substring(0, 20)
						+ value.substring(value.length() - 4));
			}
		}

		return null;
	}

	@Nullable
	private String loadStringFromLineWithPrefix(final String prefix) {

		for (final String line : lines) {

			if (line.startsWith(prefix)) {

				final String value = substringAfter(line, prefix);

				return value;
			}
		}

		return null;
	}

	private boolean hasLine(final String text) {

		for (final String line : lines) {

			if (line.equals(text)) {

				return true;
			}
		}

		return false;
	}

	private static DateTime loadTestDate(final String line) {

		// e.g. "xxx started at 2014-07-10 08:40:30 +0000"
		// e.g. "xxx finished at 2014-07-10 08:40:38 +0000."

		final String dateAsString = line.endsWith(".") //
		? substringBetween(line, " at ", ".")
				: substringAfterLast(line, " at ");

		final DateTimeFormatter formatter = DateTimeFormat
				.forPattern("YYYY-MM-dd HH:mm:ss Z");

		return formatter.parseDateTime(dateAsString);
	}
}

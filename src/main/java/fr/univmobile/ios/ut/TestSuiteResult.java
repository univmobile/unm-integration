package fr.univmobile.ios.ut;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Nullable;

import org.joda.time.DateTime;

import com.google.common.collect.Iterables;

public class TestSuiteResult {

	private interface TestCaseResultAdder {

		int add(TestCaseResult testCaseResult);
	}

	private int sum(final TestCaseResultAdder adder) {

		int total = 0;

		for (final TestSuiteResult subTestSuiteResult : subTestSuiteResults) {

			total += subTestSuiteResult.sum(adder);
		}

		for (final TestCaseResult testCaseResult : testCaseResults) {

			total += adder.add(testCaseResult);
		}

		return total;
	}

	public int sizeOfTests() {

		return sum(new TestCaseResultAdder() {

			@Override
			public int add(final TestCaseResult testCaseResult) {

				return 1;
			}
		});
	}

	public int sizeOfSuccess() {

		return sum(new TestCaseResultAdder() {

			@Override
			public int add(final TestCaseResult testCaseResult) {

				return testCaseResult.isSuccess() ? 1 : 0;
			}
		});
	}

	public int sizeOfFailures() {

		return sum(new TestCaseResultAdder() {

			@Override
			public int add(final TestCaseResult testCaseResult) {

				return testCaseResult.isFailure() ? 1 : 0;
			}
		});
	}

	public int sizeOfErrors() {

		return sum(new TestCaseResultAdder() {

			@Override
			public int add(final TestCaseResult testCaseResult) {

				return testCaseResult.isError() ? 1 : 0;
			}
		});
	}

	public TestSuiteResult[] getSubTestSuiteResults() {

		return Iterables.toArray(subTestSuiteResults, TestSuiteResult.class);
	}

	public TestCaseResult[] getTestCaseResults() {

		return Iterables.toArray(testCaseResults, TestCaseResult.class);
	}

	public final String name;

	public DateTime getStartedAt() {

		return startedAt;
	}

	@Nullable
	public DateTime getFinishedAt() {

		return finishedAt;
	}

	public void setFinishedAt(final DateTime finishedAt) {

		this.finishedAt = finishedAt;
	}

	public TestSuiteResult(final String name, final DateTime startedAt) {

		this.name = name;
		this.startedAt = startedAt;
	}

	private final DateTime startedAt;

	private DateTime finishedAt;

	public void addSubTestSuiteResult(final TestSuiteResult testSuiteResult) {

		subTestSuiteResults.add(testSuiteResult);
	}

	private final List<TestSuiteResult> subTestSuiteResults = new ArrayList<TestSuiteResult>();

	public void addTestCaseResult(final TestCaseResult testCaseResult) {

		testCaseResults.add(testCaseResult);
	}

	private final List<TestCaseResult> testCaseResults = new ArrayList<TestCaseResult>();
	
	@Override
	public String toString() {
		
		return name;
	}
}

package fr.univmobile.ios.ut;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Before;
import org.junit.Test;

public class TestResultLoader_20140711_010931_Test {

	@Before
	public void setUp() throws Exception {

		loader = new TestResultLoader(new File(
				"src/test/test-results/xcodebuild_test.log-20140711-010931"));
	}

	protected TestResultLoader loader;

	@Test
	public void test_beginDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 11, 1, 9, 31), loader.beginDate);
	}

	@Test
	public void test_testDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 11, 1, 9, 57), loader.testDate);
	}

	@Test
	public void test_endDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 11, 1, 10, 5), loader.endDate);
	}

	@Test
	public void test_gitCommitIsXxx() throws Exception {

		assertEquals("675789b0183ff12d5440c99d46418ff4a704c4a5",
				loader.gitCommit);
	}

	@Test
	public void test_buildSucceeded() throws Exception {

		assertTrue(loader.buildSucceeded);
	}

	@Test
	public void test_testFailed() throws Exception {

		assertFalse(loader.testSucceeded);
	}

	@Test
	public void test_rootTestSuite_sizeOfTestsIs16() throws Exception {

		assertEquals(16, loader.rootTestSuiteResult.sizeOfTests());
	}

	@Test
	public void test_rootTestSuite_sizeOfSuccessIs14() throws Exception {

		assertEquals(14, loader.rootTestSuiteResult.sizeOfSuccess());
	}

	@Test
	public void test_rootTestSuite_sizeOfFailuresIs1() throws Exception {

		assertEquals(1, loader.rootTestSuiteResult.sizeOfFailures());
	}

	@Test
	public void test_rootTestSuite_sizeOfErrorsIs1() throws Exception {

		assertEquals(1, loader.rootTestSuiteResult.sizeOfErrors());
	}
}

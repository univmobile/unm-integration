package fr.univmobile.ios.ut;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Before;
import org.junit.Test;

public class TestResultLoader_20140710_104022_Test {

	@Before
	public void setUp() throws Exception {

		loader = new TestResultLoader(new File(
				"src/test/test-results/xcodebuild_test.log-20140710-104022"));
	}

	private TestResultLoader loader;

	@Test
	public void test_beginDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 10, 10, 40, 22), loader.beginDate);
	}

	@Test
	public void test_testDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 10, 10, 40, 26), loader.testDate);
	}

	@Test
	public void test_endDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 10, 10, 40, 30), loader.endDate);
	}

	@Test
	public void test_gitCommitIsXxx() throws Exception {

		assertEquals("e02792fada0708096e306542fd8204641d23a4be",
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
	public void test_rootTestSuite_sizeOfTestsIs17() throws Exception {

		assertEquals(17, loader.rootTestSuiteResult.sizeOfTests());
	}

	@Test
	public void test_rootTestSuite_sizeOfSuccessIs16() throws Exception {

		assertEquals(16, loader.rootTestSuiteResult.sizeOfSuccess());
	}

	@Test
	public void test_rootTestSuite_sizeOfFailuresIs1() throws Exception {

		assertEquals(1, loader.rootTestSuiteResult.sizeOfFailures());
	}

	@Test
	public void test_rootTestSuite_sizeOfErrorsIs0() throws Exception {

		assertEquals(0, loader.rootTestSuiteResult.sizeOfErrors());
	}

	@Test
	public void test_rootTestSuite_sizeOfSubTestSuitesIs1() throws Exception {

		assertEquals(1,
				loader.rootTestSuiteResult.getSubTestSuiteResults().length);
	}

	@Test
	public void test_rootTestSuiteSub0_sizeOfSubTestSuitesIs2()
			throws Exception {

		assertEquals(2,
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults().length);
	}

	@Test
	public void test_rootTestSuiteSub0_nameIsUnivMobileTestsXctest()
			throws Exception {

		assertEquals("UnivMobileTests.xctest",
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0].name);
	}

	@Test
	public void test_rootTestSuiteSub0Sub0_nameIsUNMAppLayerTests()
			throws Exception {

		assertEquals("UNMAppLayerTests",
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[0].name);
	}

	@Test
	public void test_rootTestSuiteSub0Sub1_nameIs1UnivMobileTestsXctest()
			throws Exception {

		assertEquals("UnivMobileTests",
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[1].name);
	}

	@Test
	public void test_rootTestSuiteSub0Sub0_sizeOfTestCasesIs16()
			throws Exception {

		assertEquals(
				16,
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[0].getTestCaseResults().length);
	}

	@Test
	public void test_rootTestSuiteSub0Sub1_sizeOfTestCasesIs1()
			throws Exception {

		assertEquals(
				1,
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[1].getTestCaseResults().length);
	}

	@Test
	public void test_rootTestSuiteSub0Sub1Case0_messageIs() throws Exception {

		assertEquals(
				"failed - No implementation for \"-[UnivMobileTests testExample_x_x]\"",
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[1].getTestCaseResults()[0]
						.getMessage());
	}

	@Test
	public void test_rootTestSuiteSub0Sub1Case0_sizeOfOutputLinesIs21() throws Exception {

		assertEquals(1,				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[1].getTestCaseResults()[0]
						.getOutputLines().length);
	}

	@Test
	public void test_rootTestSuiteSub0Sub1Case0_isFailure() throws Exception {

		assertTrue(loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
				.getSubTestSuiteResults()[1].getTestCaseResults()[0]
				.isFailure());
	}

	@Test
	public void test_rootTestSuiteSub0Sub1Case0_isNotSuccess() throws Exception {

		assertFalse(loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
				.getSubTestSuiteResults()[1].getTestCaseResults()[0]
				.isSuccess());
	}

	@Test
	public void test_rootTestSuiteSub0Sub1Case0_isNotErrro() throws Exception {

		assertFalse(loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
				.getSubTestSuiteResults()[1].getTestCaseResults()[0].isError());
	}

	@Test
	public void test_rootTestSuiteSub0Sub0Case12_nameIsXxx() throws Exception {

		assertEquals(
				"testAppLayer_refreshRegionsData_sizeOfRegionsIs3",
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[0].getTestCaseResults()[12].name);
	}

	@Test
	public void test_rootTestSuiteSub0Sub0Case12_sizeOfOutputLinesIs0() throws Exception {

		assertEquals(0,
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[0].getTestCaseResults()[12].getOutputLines().length);
	}

	@Test
	public void test_rootTestSuiteSub0Sub0Case12_isSuccess() throws Exception {

		assertTrue(
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[0].getTestCaseResults()[12].isSuccess());
	}

	@Test
	public void test_rootTestSuiteSub0Sub0Case12_isNotFailure() throws Exception {

		assertFalse(
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[0].getTestCaseResults()[12].isFailure());
	}

	@Test
	public void test_rootTestSuiteSub0Sub0Case12_isNotError() throws Exception {

		assertFalse(
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[0].getTestCaseResults()[12].isError());
	}

	@Test
	public void test_rootTestSuite_nameIsAllTest() throws Exception {

		assertEquals("All tests", loader.rootTestSuiteResult.name);
	}

	@Test
	public void test_rootTestSuite_startedAtXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 10, 8 + 2, 40, 30),
				loader.rootTestSuiteResult.getStartedAt());
	}

	@Test
	public void test_rootTestSuite_finishedAtXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 10, 8 + 2, 40, 30),
				loader.rootTestSuiteResult.getFinishedAt());
	}
}

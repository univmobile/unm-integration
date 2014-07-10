package fr.univmobile.ios.ut;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Before;
import org.junit.Test;

public class TestResultLoader_20140710_113034_Test {

	@Before
	public void setUp() throws Exception {

		loader = new TestResultLoader(new File(
				"src/test/test-results/xcodebuild_test.log-20140710-113034"));
	}

	private TestResultLoader loader;

	@Test
	public void test_beginDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 10, 11, 30, 34), loader.beginDate);
	}

	@Test
	public void test_testDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 10, 11, 30, 55), loader.testDate);
	}

	@Test
	public void test_endDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 10, 11, 31,2), loader.endDate);
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
	public void test_rootTestSuite_sizeOfSuccessIs14() throws Exception {

		assertEquals(14, loader.rootTestSuiteResult.sizeOfSuccess());
	}

	@Test
	public void test_rootTestSuite_sizeOfFailuresIs2() throws Exception {

		assertEquals(2, loader.rootTestSuiteResult.sizeOfFailures());
	}

	@Test
	public void test_rootTestSuite_sizeOfErrorsIs1() throws Exception {

		assertEquals(1, loader.rootTestSuiteResult.sizeOfErrors());
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
	public void test_rootTestSuiteSub0Sub1_sizeOfTestCasesIs11()
			throws Exception {

		assertEquals(
				1,
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[1].getTestCaseResults().length);
	}

	@Test
	public void test_rootTestSuiteSub0Sub0Case12_nameIsXxx() throws Exception {

		assertEquals(
				"testAppLayer_refreshRegionsData_sizeOfRegionsIs3",
				loader.rootTestSuiteResult.getSubTestSuiteResults()[0]
						.getSubTestSuiteResults()[0].getTestCaseResults()[12].name);
	}

	@Test
	public void test_rootTestSuite_nameIsAllTest() throws Exception {

		assertEquals("All tests", loader.rootTestSuiteResult.name);
	}

	@Test
	public void test_rootTestSuite_startedAtXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 10, 9 + 2, 31, 2),
				loader.rootTestSuiteResult.getStartedAt());
	}

	@Test
	public void test_rootTestSuite_finishedAtXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 10, 9 + 2, 31, 2),
				loader.rootTestSuiteResult.getFinishedAt());
	}
}

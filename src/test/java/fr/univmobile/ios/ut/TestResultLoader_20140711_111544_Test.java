package fr.univmobile.ios.ut;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Before;
import org.junit.Test;

public class TestResultLoader_20140711_111544_Test {

	@Before
	public void setUp() throws Exception {

		loader = new TestResultLoader(new File(
				"src/test/test-results/xcodebuild_test.log-20140711-111544"));
	}

	protected TestResultLoader loader;

	@Test
	public void test_beginDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 11, 11, 15, 00), loader.beginDate);
	}

	@Test
	public void test_userIsNull() throws Exception {
		
		assertNull(loader.getUser());
	}
	
	@Test
	public void test_testDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 11, 11, 15, 29), loader.testDate);
	}

	@Test
	public void test_endDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 7, 11, 11, 15, 44), loader.endDate);
	}

	@Test
	public void test_gitCommitIsXxx() throws Exception {

		assertEquals("1e4ba31266c1fd2db238aa8047b0c5bfd1c27418",
				loader.gitCommit);
	}

	@Test
	public void test_buildSucceeded() throws Exception {

		assertTrue(loader.buildSucceeded);
	}

	@Test
	public void test_testFailed() throws Exception {

		assertTrue(loader.testSucceeded);
	}

	@Test
	public void test_rootTestSuite_isNull() throws Exception {

		assertNull(loader.rootTestSuiteResult);
	}
}

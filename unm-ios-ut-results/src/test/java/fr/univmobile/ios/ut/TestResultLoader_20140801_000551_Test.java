package fr.univmobile.ios.ut;

import static org.junit.Assert.assertEquals;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Before;
import org.junit.Test;

public class TestResultLoader_20140801_000551_Test {

	@Before
	public void setUp() throws Exception {

		loader = new TestResultLoader(new File(
				"src/test/test-results/xcodebuild_test.log-20140801-000551"));
	}

	protected TestResultLoader loader;

	@Test
	public void test_beginDateIsXxx() throws Exception {

		assertEquals(new DateTime(2014, 8, 1, 0, 5, 9), loader.beginDate);
	}
}

package fr.univmobile.ios.ut;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.junit.Before;

public class TestResultLoaderBytes_20140710_113034_Test extends
		TestResultLoader_20140710_113034_Test {

	@Before
	public void setUp() throws Exception {

		super.setUp(); // actually ignore the result

		final byte[] bytes = FileUtils.readFileToByteArray(new File(
				"src/test/test-results/xcodebuild_test.log-20140710-113034"));

		loader = new TestResultLoader(bytes);
	}
}

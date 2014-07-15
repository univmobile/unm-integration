package fr.univmobile.it;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Test;

import fr.univmobile.it.cidump.ContinuousIntegrationDumper;
import fr.univmobile.testutil.Dumper;
import fr.univmobile.testutil.XMLDumper;

public class UnivMobileDevelCiTest {

	/**
	 * Fetch all development + continuous integration information from various
	 * resources:
	 * <ul>
	 * <li>Jenkins
	 * <li>GitHub
	 * </ul>
	 * Emit an XML file: unm-ci-dump.xml
	 */
	@Test
	public void fetchCiResources() throws Exception {

		// 1. FETCH REMOTE RESOURCES

		final Dumper dumper = XMLDumper.newXMLDumper("unm-ci-dump", new File(
				"target/unm-ci-dump.xml"));

		dumper.addAttribute("date", new DateTime());

		try {

			final ContinuousIntegrationDumper ci = new ContinuousIntegrationDumper(
					dumper);

			ci.dumpGitCommitsForRepo("unm-ios", 20);

			ci.dumpJenkinsBuildsForJob("unm-ios_xcode", 50);

			ci.dumpJenkinsBuildsForJob("unm-ios-ut-results", 50);

			ci.dumpJenkinsBuildsForJob("unm-ios-it", 50);

			ci.dumpJenkinsBuildsForJob("unm-ios-it_ios6", 50);

		} finally {
			dumper.close();
		}

		// 2. ANT

		AntUtils.executeTarget("generate-unm-ci-dump");
	}
}

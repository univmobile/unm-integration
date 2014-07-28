package fr.univmobile.it;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Test;

import fr.univmobile.it.cidump.ContinuousIntegrationDumper;
import fr.univmobile.it.cidump.DumpedBuild;
import fr.univmobile.testutil.Dumper;
import fr.univmobile.testutil.XMLDumper;

public class UnivMobileWebItScenariosFetchTest extends
		AbstractUnivMobileItScenariosFetchTest {

	/**
	 * Fetch all screenshots and XML log files emitted by JUnit tests in
	 * unm-mobileweb-it which use Appium, then emit an XML file:
	 * unm-mobileweb-it-scenarios-dump.xml.
	 */
	@Test
	public void fetchUnmMobileWebItScenarios() throws Exception {

		final String requiredAppCommitId = System.getProperty("appCommitId");

		final String ios6jobName = requiredAppCommitId == null //
		? "unm-mobileweb-it_ios6"
				: "unm-mobileweb-it_ios6_release";

		final String ios7jobName = requiredAppCommitId == null //
		? "unm-mobileweb-it_ios7"
				: "unm-mobileweb-it_ios7_release";

		System.out.println("requiredAppCommitId: " + requiredAppCommitId);
		System.out.println("ios7jobName: " + ios7jobName);
		System.out.println("ios6jobName: " + ios6jobName);

		// 1. FETCH REMOTE RESOURCES

		final Dumper dumper = XMLDumper.newXMLDumper(
				"unm-mobileweb-it-scenarios-dump", new File(
						"target/unm-mobileweb-it-scenarios-dump.xml"));
		try {

			dumper.addAttribute("date", new DateTime());

			// 1.1. DUMP BOTH UNM-MOBILEWEB-IT JOBS

			final ContinuousIntegrationDumper ci = new ContinuousIntegrationDumper(
					dumper);

			final DumpedBuild[] builds_ios7 = ci.dumpJenkinsBuildsForJob(
					ios7jobName, 50);

			final DumpedBuild[] builds_ios6 = ci.dumpJenkinsBuildsForJob(
					ios6jobName, 50);

			// 1.2. FIND AN APP COMMIT ID COMMON TO BOTH UNM-MOBILEWEB-IT JOBS

			final DumpedBuild[] builds = findBuildsWithSamAppCommitId(
					requiredAppCommitId, builds_ios7, builds_ios6);

			final DumpedBuild build_ios7 = builds[0];
			final DumpedBuild build_ios6 = builds[1];

			ci.dumpItScenarios("iOS_7.1", "iOS7", build_ios7);
			// TODO ci.dumpItScenarios("iOS_7.1", "iOS7", build_ios6);

			// TODO : not 7.1, but 6.0
			ci.dumpItScenarios("iOS_6.1", "iOS6", build_ios6);

		} finally {
			dumper.close();
		}

		// 2. ANT

		AntUtils.executeTarget("generate-unm-mobileweb-it-scenarios-dump");
	}
}

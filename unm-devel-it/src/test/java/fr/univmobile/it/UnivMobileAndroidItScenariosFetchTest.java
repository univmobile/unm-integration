package fr.univmobile.it;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Test;

import fr.univmobile.it.cidump.ContinuousIntegrationDumper;
import fr.univmobile.it.cidump.DumpedBuild;
import fr.univmobile.testutil.Dumper;
import fr.univmobile.testutil.XMLDumper;

public class UnivMobileAndroidItScenariosFetchTest extends
		AbstractUnivMobileItScenariosFetchTest {

	/**
	 * Fetch all screenshots and XML log files emitted by JUnit tests in
	 * unm-android-it which use Appium, then emit an XML file:
	 * unm-android-it-scenarios-dump.xml.
	 */
	@Test
	public void fetchUnmAndroidItScenarios() throws Exception {

		final String requiredAppCommitId = System.getProperty("appCommitId");

		final String jobName = requiredAppCommitId == null //
		? "unm-android-it"
				: "unm-android-it_release";

		System.out.println("requiredAppCommitId: " + requiredAppCommitId);
		System.out.println("jobName: " + jobName);

		// 1. FETCH REMOTE RESOURCES

		final Dumper dumper = XMLDumper.newXMLDumper(
				"unm-android-it-scenarios-dump", new File(
						"target/unm-android-it-scenarios-dump.xml"));
		try {

			dumper.addAttribute("date", new DateTime());

			// 1.1. DUMP UNM-ANDROID-IT JOBS

			final ContinuousIntegrationDumper ci = new ContinuousIntegrationDumper(
					dumper);

			final DumpedBuild[] builds_it = ci.dumpJenkinsBuildsForJob(jobName,
					50);

			System.out.println(builds_it[0].commitId);
			// 1.2. FIND AN APP COMMIT ID COMMON TO UNM-ANDROID-IT JOBS

			final DumpedBuild[] builds = findBuildsWithSameAppCommitId(
					requiredAppCommitId, builds_it);

			final DumpedBuild build_it = builds[0];

			ci.dumpItScenarios("Android_XXX", "Android", build_it);
			// TODO ci.dumpItScenarios("iOS_7.1", "iOS7", build_ios6);

			// TODO : not 7.1, but 6.0
			// ci.dumpItScenarios("iOS_6.1", "iOS6", build_ios6);

		} finally {
			dumper.close();
		}

		// 2. ANT

		AntUtils.executeTarget("generate-unm-android-it-scenarios-dump");
	}
}

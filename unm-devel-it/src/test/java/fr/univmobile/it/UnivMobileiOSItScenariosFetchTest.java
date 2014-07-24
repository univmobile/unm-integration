package fr.univmobile.it;

import static fr.univmobile.it.cidump.DumpedBuild.getLatestSuccessfulBuildForAppCommitId;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Test;

import fr.univmobile.it.cidump.ContinuousIntegrationDumper;
import fr.univmobile.it.cidump.DumpedBuild;
import fr.univmobile.testutil.Dumper;
import fr.univmobile.testutil.XMLDumper;

public class UnivMobileiOSItScenariosFetchTest {

	/**
	 * Fetch all screenshots and XML log files emitted by JUnit tests in
	 * unm-ios-it which use Appium, then emit an XML file:
	 * unm-ios-it-scenarios-dump.xml.
	 */
	@Test
	public void fetchUnmIosItScenarios() throws Exception {

		// 1. FETCH REMOTE RESOURCES

		final Dumper dumper = XMLDumper.newXMLDumper(
				"unm-ios-it-scenarios-dump", new File(
						"target/unm-ios-it-scenarios-dump.xml"));
		try {

			dumper.addAttribute("date", new DateTime());

			// 1.1. DUMP BOTH UNM-IOS-IT JOBS

			final ContinuousIntegrationDumper ci = new ContinuousIntegrationDumper(
					dumper);

			final DumpedBuild[] builds = ci.dumpJenkinsBuildsForJob(
					"unm-ios-it", 50);

			final DumpedBuild[] builds_ios6 = ci.dumpJenkinsBuildsForJob(
					"unm-ios-it_ios6", 50);

			// 1.2. FIND AN APP COMMIT ID COMMON TWO BOTH UNM-IOS-IT JOBS

			DumpedBuild build_ios6 = null;

			for (final DumpedBuild build : builds) {

				if (!build.isSuccess || build.appCommitId == null) {
					continue;
				}

				build_ios6 = getLatestSuccessfulBuildForAppCommitId(
						builds_ios6, build.appCommitId);

				if (build_ios6 != null) {
					break;
				}
			}

			if (build_ios6 != null) {

				final DumpedBuild build = getLatestSuccessfulBuildForAppCommitId(
						builds, build_ios6.appCommitId);

				ci.dumpItScenarios("iOS_7.1", "iOS7", build);
				// TODO ci.dumpItScenarios("iOS_7.1", "iOS7", build_ios6);

				// TODO : not 7.1, but 6.0
				ci.dumpItScenarios("iOS_6.1", "iOS6", build_ios6);
			}

		} finally {
			dumper.close();
		}

		// 2. ANT

		AntUtils.executeTarget("generate-unm-ios-it-scenarios-dump");
	}
}

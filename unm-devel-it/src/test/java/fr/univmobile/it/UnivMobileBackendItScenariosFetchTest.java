package fr.univmobile.it;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Test;

import fr.univmobile.it.cidump.ContinuousIntegrationDumper;
import fr.univmobile.it.cidump.DumpedBuild;
import fr.univmobile.testutil.Dumper;
import fr.univmobile.testutil.XMLDumper;

public class UnivMobileBackendItScenariosFetchTest extends
		AbstractUnivMobileItScenariosFetchTest {

	/**
	 * Fetch all screenshots and XML log files emitted by JUnit tests in
	 * unm-backend-it which use Selenium, then emit an XML file:
	 * unm-backend-it-scenarios-dump.xml.
	 */
	@Test
	public void fetchUnmMobileBackendItScenarios() throws Exception {

		final String requiredAppCommitId = System.getProperty("appCommitId");

		final String macosJobName = requiredAppCommitId == null //
		? "unm-backend-it_macos"
				: "unm-backend-it_macos_release";

		final String debianJobName = requiredAppCommitId == null //
		? "unm-backend-it"
				: "unm-backend-it_release";

		System.out.println("requiredAppCommitId: " + requiredAppCommitId);
		System.out.println("debianJobName: " + debianJobName);
		System.out.println("macosJobName: " + macosJobName);

		// 1. FETCH REMOTE RESOURCES

		final Dumper dumper = XMLDumper.newXMLDumper(
				"unm-backend-it-scenarios-dump", new File(
						"target/unm-backend-it-scenarios-dump.xml"));
		try {

			dumper.addAttribute("date", new DateTime());

			// 1.1. DUMP BOTH UNM-BACKEND-IT JOBS

			final ContinuousIntegrationDumper ci = new ContinuousIntegrationDumper(
					dumper);

			final DumpedBuild[] builds_debian = ci.dumpJenkinsBuildsForJob(
					debianJobName, 50);

			final DumpedBuild[] builds_macos = ci.dumpJenkinsBuildsForJob(
					macosJobName, 50);

			// 1.2. FIND AN APP COMMIT ID COMMON TO BOTH UNM-DEBIAN-IT JOBS

			final DumpedBuild[] builds = findBuildsWithSameAppCommitId(
					requiredAppCommitId, builds_debian, builds_macos);

			final DumpedBuild build_debian = builds[0];
			final DumpedBuild build_macos = builds[1];

			ci.dumpItScenarios("Debian_3.2.0-4-amd64", "Debian", build_debian);

			ci.dumpItScenarios("Mac_OS_X_10.9.5", "MacOS", build_macos);

		} finally {
			dumper.close();
		}

		// 2. ANT

		AntUtils.executeTarget("generate-unm-backend-it-scenarios-dump");
	}
}

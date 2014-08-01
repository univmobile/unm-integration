package fr.univmobile.it;

import java.io.File;

import org.joda.time.DateTime;
import org.junit.Test;

import fr.univmobile.it.cidump.ContinuousIntegrationDumper;
import fr.univmobile.testutil.Dumper;
import fr.univmobile.testutil.XMLDumper;

public class UnivMobileBackendDevelCiTest extends AbstractUnivMobileCiTest {

	/**
	 * Fetch all development + continuous integration information from various
	 * resources:
	 * <ul>
	 * <li>Jenkins
	 * <li>GitHub
	 * </ul>
	 * Emit an XML file: unm-backend-ci-dump.xml
	 */
	@Test
	public void fetchCiResources() throws Exception {

		final String suffix = calcJobSuffix(branch);

		// 1. FETCH REMOTE RESOURCES

		final Dumper dumper = XMLDumper.newXMLDumper("unm-backend-ci-dump",
				new File("target/unm-backend-ci-dump.xml"));
		try {

			dumper.addAttribute("date", new DateTime());

			final ContinuousIntegrationDumper ci = new ContinuousIntegrationDumper(
					dumper);

			ci.dumpGitCommitsForRepo("unm-backend", branch, 20);

			ci.dumpJenkinsBuildsForJob("unm-backend-app" + suffix, 50);

			ci.dumpJenkinsBuildsForJob("unm-backend-app-noshib" + suffix, 50);

			ci.dumpJenkinsBuildsForJob("unm-backend-it" + suffix, 50);

			ci.dumpJenkinsBuildsForJob("unm-backend-it_macos" + suffix, 50);

		} finally {
			dumper.close();
		}

		// 2. ANT

		AntUtils.executeTarget("generate-unm-backend-ci-dump");
	}
}

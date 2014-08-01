package fr.univmobile.it.cidump;

import static com.google.common.base.Preconditions.checkNotNull;
import static org.apache.commons.lang3.CharEncoding.UTF_8;
import static org.apache.commons.lang3.StringUtils.split;
import static org.apache.commons.lang3.StringUtils.substringAfter;
import static org.apache.commons.lang3.StringUtils.substringBefore;
import static org.apache.commons.lang3.StringUtils.substringBetween;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Nullable;

import net.avcompris.binding.annotation.XPath;
import net.avcompris.binding.dom.helper.DomBinderUtils;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.URI;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthScope;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.eclipse.jgit.lib.PersonIdent;
import org.eclipse.jgit.revwalk.RevCommit;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;

import com.google.common.collect.Iterables;

import fr.univmobile.it.cidump.Scenarios.ScenariosClass;
import fr.univmobile.it.cidump.Scenarios.ScenariosClass.Device;
import fr.univmobile.it.cidump.Scenarios.ScenariosClass.ScenarioMethod;
import fr.univmobile.it.commons.JGitHelper;
import fr.univmobile.testutil.Dumper;
import fr.univmobile.testutil.PropertiesUtils;

public class ContinuousIntegrationDumper {

	public ContinuousIntegrationDumper(final Dumper dumper) throws IOException {

		this.dumper = checkNotNull(dumper, "dumper");

		final String host = PropertiesUtils //
				.getTestProperty("jenkins.host"); // e.g. "univmobile.vswip.com"
		final int port = Integer.parseInt(PropertiesUtils //
				.getTestProperty("jenkins.port")); // e.g. 80

		baseURL = "http://" + host + (port == 80 ? "" : (":" + port)) + "/";

		// 1. SET HTTP AUTHENTICATION

		client = new HttpClient();

		final String username = "dandriana";
		final String apiToken = PropertiesUtils
				.getTestProperty("jenkins.apiToken");

		client.getState().setCredentials(new AuthScope(host, port, "realm"),
				new UsernamePasswordCredentials(username, apiToken));

		client.getParams().setAuthenticationPreemptive(true);
	}

	private final String baseURL;
	private final HttpClient client;
	private final Dumper dumper;

	public void dumpGitCommitsForRepo(final String repoName,
			final String branch, final int max) throws Exception {

		final JGitHelper jgitHelper;

		final File repoDir = new File("target/" + repoName);

		if (repoDir.exists()) {
			FileUtils.deleteDirectory(repoDir);
		}

		jgitHelper = JGitHelper.cloneRepo("https://github.com/univmobile/"
				+ repoName, branch, repoDir);

		// jgitHelper = new JGitHelper(new File(repoDir, ".git"));

		final RevCommit[] commits = jgitHelper.getCommitsFromHead(100);

		final Dumper commitsElement = dumper.addElement("commits") //
				.addAttribute("repository", repoName);

		for (final RevCommit commit : commits) {

			final PersonIdent authorIdent = commit.getAuthorIdent();

			final Date authorDate = authorIdent.getWhen();

			final String authorName = authorIdent.getName();

			final String shortMessage = commit.getShortMessage();

			// final String fullMessage = commit.getFullMessage();

			final String commitDate = new DateTime(authorDate)
					.toString(DateTimeFormat.forPattern("YYYY-MM-d HH:mm:ss"));

			final Dumper commitElement = commitsElement.addElement("commit") //
					.addAttribute("id", commit.getId().getName()) //
					.addAttribute("date", commitDate) //
					.addAttribute("author", authorName) //
					.addAttribute("shortMessage", shortMessage);

			// commitElement.addAttribute("fullMessage", fullMessage);

			for (final RevCommit parent : commit.getParents()) {

				commitElement.addElement("parent").addAttribute("id",
						parent.getId().getName());
			}
		}
	}

	public void saveJobBuildConsole(final File outFile, final String jobName,
			final int buildNumber) throws IOException {

		final File consoleFile = saveTextContent(baseURL + "job/" + jobName
				+ "/" + buildNumber + "/consoleText");

		FileUtils.copyFile(consoleFile, outFile);
	}

	public HudsonJobs dumpAllJenkinsJobs() throws Exception {

		final String hudsonUrl = baseURL + "api/xml";

		final HudsonJobs jobs = loadXMLContent(hudsonUrl, HudsonJobs.class);

		if (jobs == null) {
			throw new FileNotFoundException(
					"Cannot read Hudson config at URL: " + hudsonUrl);
		}

		final Dumper hudsonDumper = dumper.addElement("hudson");

		for (final JenkinsJob job : jobs.getJobs()) {

			hudsonDumper.addElement("job") //
					.addAttribute("name", job.getName()) //
					.addAttribute("url", job.getUrl());
		}

		return jobs;

	}

	public DumpedBuild[] dumpJenkinsBuildsForJob(final String jobName,
			final int max) throws Exception {

		// 1. GET JOB STATUS

		final String jobUrl = baseURL + "job/" + jobName + "/api/xml";

		final JenkinsJob job = loadXMLContent(jobUrl, JenkinsJob.class);

		if (job == null) {
			throw new FileNotFoundException("Cannot read Jenkins job at URL: "
					+ jobUrl);
		}

		final Dumper jobDumper = dumper.addElement("jenkinsJob") //
				.addAttribute("name", job.getName()) //
				.addAttribute("type", job.getType());

		// 2. GET BUILDS

		final List<DumpedBuild> dumpedBuilds = new ArrayList<DumpedBuild>();

		final List<JenkinsBuild> builds = new ArrayList<JenkinsBuild>();

		int count = 0;

		for (final JenkinsJob.Build jobBuild : job.getBuilds()) {

			if (count >= max) {
				break;
			}

			++count;

			final int buildNumber = jobBuild.getNumber();

			final Dumper buildDumper = jobDumper.addElement("build") //
					.addAttribute("number", buildNumber);

			final JenkinsBuild build = loadXMLContent(baseURL + "job/"
					+ jobName + "/" + buildNumber + "/api/xml",
					JenkinsBuild.class);

			buildDumper.addAttribute("type", build.getType()) //
					.addAttribute("commitId", build.getCommitId()) //
					.addAttribute("result", build.getResult()) //
					.addAttribute("id", build.getId());

			// 2.5. SPECIAL CASE: unm-ios-ut: Tests an actual UnivMobile.app
			// with embedded commitId (the one used to build the app).

			final String appCommitId;

			// if ("unm-ios-it".equals(jobName)
			// || "unm-ios-it_ios6".equals(jobName)) {
			if (jobName.startsWith("unm-ios-it")) {

				// e.g.
				// http://univmobile.vswip.com/job/unm-ios-it/35/artifact/unm-ios-it/target/screenshots/pageSource.xml

				final AppiumIOSPageSource pageSource = loadXMLContent(baseURL
						+ "job/" + jobName + "/" + buildNumber
						+ "/artifact/unm-ios-it/target/screenshots"
						+ "/pageSource.xml", AppiumIOSPageSource.class);

				if (pageSource == null) { // Not found.
					continue;
				}

				final String buildInfo = pageSource.getBuildInfo();

				// System.out.println("buildInfo: " + buildInfo);

				appCommitId = substringAfter(buildInfo,
						"https://github.com/univmobile/unm-ios").trim();

			} else if (jobName.startsWith("unm-mobileweb-it_ios")) {

				final File htmlAboutFile = saveTextContent(baseURL + "job/"
						+ jobName + "/" + buildNumber
						+ "/artifact/unm-mobileweb-it/target/screenshots"
						+ "/about.html");

				if (htmlAboutFile == null) { // Not found.
					continue;
				}

				final String htmlAbout = FileUtils.readFileToString(
						htmlAboutFile, UTF_8);

				appCommitId = substringBetween(
						substringAfter(substringBetween(//
								htmlAbout, "id=\"div-info\">", "</div>"),
								"https://github.com/univmobile/unm-mobileweb"),
						"-->", "</p>").trim();

			} else if (jobName.startsWith("unm-android-it")) {

				final AppiumAndroidPageSource pageSource = loadXMLContent(
						baseURL
								+ "job/"
								+ jobName
								+ "/"
								+ buildNumber
								+ "/artifact/unm-android-it/target/screenshots"
								+ "/Android_XXX/Android_Emulator/Scenarios001/sc001" // ???
								+ "/pageAbout.xml",
						AppiumAndroidPageSource.class);

				if (pageSource == null) { // Not found.
					continue;
				}

				appCommitId = pageSource.getGitCommitId();

			} else if (jobName.startsWith("unm-backend-it")) {

				final File htmlAboutFile = saveTextContent(baseURL + "job/"
						+ jobName + "/" + buildNumber
						+ "/artifact/unm-backend-it/target/screenshots"
						+ "/pageHome.html");

				if (htmlAboutFile == null) { // Not found.
					continue;
				}

				final String htmlAbout = FileUtils.readFileToString(
						htmlAboutFile, UTF_8);

				final String[] s = split(substringBefore(substringBetween(//
						htmlAbout, "<h1", "</h1>"), "\">"));

				if (s == null) { // Not found.
					continue;
				}

				appCommitId = s[s.length - 1];

			} else {

				appCommitId = null;
			}

			if (appCommitId != null) {
				buildDumper.addAttribute("appCommitId", appCommitId);
			}

			dumpedBuilds.add(new DumpedBuild(jobName, buildNumber, //
					"SUCCESS".equals(build.getResult()), //
					build.getCommitId(), appCommitId));

			builds.add(build);
		}

		jobDumper.close();

		// 3. SPECIAL CASE: unm-ios-ut-results => unm-ios-ut

		if ("unm-ios-ut-results".equals(jobName)) {

			/*
			 * <jenkinsJob name="unm-ios-ut-results" type="mavenModuleSet">
			 * <build number="51" type="mavenModuleSetBuild"
			 * commitId="d4ce1153c0901eb272eaddaaec51871a8e887c0e"
			 * result="SUCCESS" id="2014-07-12_23-22-11"/> <build number="50"
			 * type="mavenModuleSetBuild"
			 * commitId="704fbf1cbd0b4c3556fdfcee4caea7c4ee3d4187"
			 * result="SUCCESS" id="2014-07-12_22-29-50"/>
			 */

			final Dumper fakeJob = dumper
					.addElement("jenkinsJob")
					//
					.addAttribute("name", "unm-ios-ut")
					//
					.addAttribute("type",
							"(inferred from unm-ios-ut-results logs)");

			for (final JenkinsBuild build : builds) {

				final int buildNumber = build.getNumber();

				final File file = saveTextContent(baseURL + "job/" + jobName
						+ "/" + buildNumber + "/consoleText");

				final Dumper fakeBuild = fakeJob
						.addElement("build")
						.addAttribute("number", build.getNumber())
						.addAttribute("result", build.getResult())
						.addAttribute("href",
								"http://univmobile.vswip.com/job/" //
										+ jobName + "/" + buildNumber + "/");

				String iosCommitId = null;
				String testBeginDate = null;

				boolean interesting = false;

				for (final String line : FileUtils.readLines(file, UTF_8)) {

					if (interesting) {

						if (line.contains("Git Commit: ")) {

							iosCommitId = substringAfter(line, "Git Commit: ");

							if (testBeginDate != null) {
								break;
							}
						}

						if (line.contains("Begin Date: ")) {

							testBeginDate = substringBetween(line,
									"Begin Date: ", ".");

							if (iosCommitId != null) {
								break;
							}
						}

					} else if (line.startsWith("Xcode Execution")) {

						interesting = true;
					}
				}

				fakeBuild.addAttribute("commitId", iosCommitId);

				if (testBeginDate != null) {
					fakeBuild.addAttribute("id",
							testBeginDate.replace('T', ' '));
				}
			}
		}

		// 9. END

		return Iterables.toArray(dumpedBuilds, DumpedBuild.class);
	}

	@Nullable
	private <T> T loadXMLContent(final String url, final Class<T> clazz)
			throws IOException {

		System.out.println("Loading XML from: " + url + "...");

		final HttpMethod method = new GetMethod(url);

		method.setDoAuthentication(true);

		client.executeMethod(method);

		if (method.getStatusCode() == 404) {

			System.err.println("** Could not load XML from: " + url);

			return null;
		}

		checkHttpResult(method);

		final byte[] bytes;

		final InputStream is = method.getResponseBodyAsStream();
		try {

			bytes = IOUtils.toByteArray(is);

		} finally {
			is.close();
		}

		final File xmlFile = new File("target", //
				substringAfter(substringAfter(url, "://"), "/") //
						.replace("/", "_") //
						.replace("_xml", ".xml"));

		FileUtils.writeByteArrayToFile(xmlFile, bytes);

		return DomBinderUtils.xmlContentToJava(xmlFile, clazz);
	}

	@Nullable
	private File saveTextContent(final String url) throws IOException {

		System.out.println("Saving text from: " + url + "...");

		final HttpMethod method = new GetMethod(url);

		method.setDoAuthentication(true);

		client.executeMethod(method);

		if (method.getStatusCode() == 404) {

			System.err.println("** Could not load text content from: " + url);

			return null;
		}

		checkHttpResult(method);

		final byte[] bytes;

		final InputStream is = method.getResponseBodyAsStream();
		try {

			bytes = IOUtils.toByteArray(is);

		} finally {
			is.close();
		}

		final File textFile = new File("target", //
				substringAfter(substringAfter(url, "://"), "/") //
						.replace("/", "_"));

		FileUtils.writeByteArrayToFile(textFile, bytes);

		return textFile;
	}

	private static void checkHttpResult(final HttpMethod method)
			throws IOException {

		final int resultCode = method.getStatusCode();

		final URI uri = method.getURI();

		if (resultCode / 100 != 2) {
			throw new IOException("HTTP result code: " + resultCode
					+ " for URI: " + uri);
		}
	}

	public void dumpItScenarios(final String subDirName, //
			final String iosLabel, final DumpedBuild build) throws Exception {

		checkNotNull(build, "build");
		checkNotNull(build.appCommitId, "build.appCommitId");

		System.out.println( //
				"build: " + build.jobName + " #" + build.buildNumber);

		if (!build.isSuccess) {
			throw new IllegalArgumentException("!build.isSuccess");
		}

		final Dumper scenariosDumper = dumper.addElement("scenarios")
				.addAttribute("subDirName", subDirName)
				.addAttribute("iosLabel", iosLabel)
				.addAttribute("jobName", build.jobName)
				.addAttribute("buildNumber", build.buildNumber)
				.addAttribute("appCommitId", build.appCommitId);

		// 1. GET JOB STATUS

		final String scenariosURL = baseURL + "job/" + build.jobName
				+ "/"
				+ build.buildNumber //
				+ "/artifact/" + getMavenProjectForJob(build.jobName)
				+ "/target/screenshots/scenarios.xml";

		final Scenarios scenarios = loadXMLContent(scenariosURL,
				Scenarios.class);

		if (scenarios == null) { // Not found.
			throw new FileNotFoundException("Cannot read scenarios at URL: "
					+ scenariosURL);
		}

		for (final ScenariosClass scenariosClass : scenarios
				.getScenariosClasses()) {

			final Dumper scenarioDumper = scenariosDumper
					.addElement("scenariosClass")
					.addAttribute("className", scenariosClass.getClassName())
					.addAttribute("classSimpleName",
							scenariosClass.getClassSimpleName())
					.addAttribute("scenariosLabel",
							scenariosClass.getScenariosLabel());

			for (final Device device : scenariosClass.getDevices()) {

				scenarioDumper
						.addElement("device")
						.addAttribute("deviceName", device.getDeviceName())
						.addAttribute("normalizedDeviceName",
								device.getNormalizedDeviceName());
			}

			for (final ScenarioMethod scenarioMethod : scenariosClass
					.getScenarioMethods()) {

				final Dumper methodDumper = scenarioDumper
						.addElement("scenarioMethod")
						.addAttribute("methodName",
								scenarioMethod.getMethodName())
						.addAttribute("methodFullName",
								scenariosClass.getClassName() //
										+ '.' + scenarioMethod.getMethodName())
						.addAttribute("scenarioLabel",
								scenarioMethod.getScenarioLabel());

				dumpItScenario(methodDumper, subDirName, build, scenarioMethod);
			}
		}
	}

	private void dumpItScenario(final Dumper dumper, final String subDirName,
			final DumpedBuild build, final ScenarioMethod scenarioMethod)
			throws IOException {

		/*
		 * http://univmobile.vswip.com/job/unm-ios-it_ios6/
		 * /target/screenshots/iOS_7.1/iPhone_Retina_3.5-inch/
		 * UnivMobileScenarios001/sc001/checked.xml
		 */

		final ScenariosClass scenariosClass = scenarioMethod.getParent();

		for (final Device device : scenariosClass.getDevices()) {

			final String normalizedDeviceName = device
					.getNormalizedDeviceName();

			final String checkedURL = baseURL + "job/" + build.jobName + "/"
					+ build.buildNumber + "/artifact/"
					+ getMavenProjectForJob(build.jobName)
					+ "/target/screenshots/" //
					+ subDirName // e.g."iOS_7.1"
					+ "/" //
					+ normalizedDeviceName // e.g. "iPhone_Retina_3.5-inch"
					+ "/" + scenariosClass.getClassSimpleName() //
					+ "/" + scenarioMethod.getMethodName() //
					+ "/checked.xml";

			final File xmlFile = saveTextContent(checkedURL);

			dumper.addXMLFragment(xmlFile);
		}
	}

	private static String getMavenProjectForJob(final String jobName) {

		if (jobName.startsWith("unm-ios-it")) {

			return "unm-ios-it";

		} else if (jobName.startsWith("unm-mobileweb-it_")) {

			return "unm-mobileweb-it";

		} else if (jobName.startsWith("unm-android-it")) {

			return "unm-android-it";

		} else if (jobName.startsWith("unm-backend-it")) {

			return "unm-backend-it";

		} else {

			throw new IllegalArgumentException("jobName: " + jobName);
		}
	}
}

@XPath("/scenarios")
interface Scenarios {

	@XPath("scenariosClass")
	ScenariosClass[] getScenariosClasses();

	interface ScenariosClass {

		@XPath("@className")
		String getClassName();

		@XPath("@classSimpleName")
		String getClassSimpleName();

		@XPath("@scenariosLabel")
		String getScenariosLabel();

		@XPath("device")
		Device[] getDevices();

		interface Device {

			@XPath("@deviceName")
			String getDeviceName();

			@XPath("@normalizedDeviceName")
			String getNormalizedDeviceName();
		}

		@XPath("scenarioMethod")
		ScenarioMethod[] getScenarioMethods();

		interface ScenarioMethod {

			@XPath("@methodName")
			String getMethodName();

			@XPath("@scenarioLabel")
			String getScenarioLabel();

			@XPath("parent::scenariosClass")
			ScenariosClass getParent();
		}
	}
}

@XPath("/checked")
interface Checked {

}
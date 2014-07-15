package fr.univmobile.it;

import static org.apache.commons.lang3.CharEncoding.UTF_8;
import static org.apache.commons.lang3.StringUtils.substringAfter;
import static org.apache.commons.lang3.StringUtils.substringBetween;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.avcompris.binding.dom.helper.DomBinderUtils;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.URI;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthScope;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.tools.ant.DefaultLogger;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.ProjectHelper;
import org.eclipse.jgit.lib.PersonIdent;
import org.eclipse.jgit.revwalk.RevCommit;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.junit.Test;
import fr.univmobile.testutil.*;
import fr.univmobile.ios.ut.JGitHelper;
import fr.univmobile.testutil.PropertiesUtils;

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

			dumpGitCommitsForRepo(dumper, "unm-ios", 20);

			dumpJenkinsBuildsForJob(dumper, "unm-ios_xcode", 50);

			dumpJenkinsBuildsForJob(dumper, "unm-ios-ut-results", 50);

			dumpJenkinsBuildsForJob(dumper, "unm-ios-it", 50);

			dumpJenkinsBuildsForJob(dumper, "unm-ios-it_ios6", 50);

		} finally {
			dumper.close();
		}

		// 2. ANT

		final File buildFile = new File("build.xml");

		System.out.println("Running Ant file: " + buildFile.getCanonicalPath()
				+ "...");

		final Project project = new Project();

		ProjectHelper.configureProject(project, buildFile);

		final DefaultLogger consoleLogger = new DefaultLogger();

		consoleLogger.setErrorPrintStream(System.err);
		consoleLogger.setOutputPrintStream(System.out);
		consoleLogger.setMessageOutputLevel(Project.MSG_INFO);

		project.addBuildListener(consoleLogger);

		project.init();

		project.executeTarget("generate-unm-ci-dump");
	}

	private static void dumpGitCommitsForRepo(final Dumper dumper,
			final String repoName, final int max) throws Exception {

		final JGitHelper jgitHelper;

		final File repoDir = new File("target/" + repoName);

		if (repoDir.exists()) {
			FileUtils.deleteDirectory(repoDir);
		}

		jgitHelper = JGitHelper.cloneRepo("https://github.com/univmobile/"
				+ repoName, repoDir);

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

	private static void dumpJenkinsBuildsForJob(final Dumper dumper,
			final String jobName, final int max) throws Exception {

		// 1. SET HTTP AUTHENTICATION

		final HttpClient client = new HttpClient();

		final String host = PropertiesUtils //
				.getTestProperty("jenkins.host"); // e.g. "univmobile.vswip.com"
		final int port = Integer.parseInt(PropertiesUtils //
				.getTestProperty("jenkins.port")); // e.g. 80

		final String baseURL = "http://" + host
				+ (port == 80 ? "" : (":" + port)) + "/";

		final String username = "dandriana";
		final String apiToken = PropertiesUtils
				.getTestProperty("jenkins.apiToken");

		client.getState().setCredentials(new AuthScope(host, port, "realm"),
				new UsernamePasswordCredentials(username, apiToken));

		client.getParams().setAuthenticationPreemptive(true);

		// 2. GET JOB STATUS

		final String jobUrl = baseURL + "job/" + jobName + "/api/xml";

		final JenkinsJob job = loadXMLContent(client, jobUrl, JenkinsJob.class);

		if (job == null) {
			throw new FileNotFoundException("Cannot read Jenkins job at URL: "
					+ jobUrl);
		}

		final Dumper jobDumper = dumper.addElement("jenkinsJob") //
				.addAttribute("name", job.getName()) //
				.addAttribute("type", job.getType());

		// 3. GET BUILDS

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

			final JenkinsBuild build = loadXMLContent(client, baseURL + "job/"
					+ jobName + "/" + buildNumber + "/api/xml",
					JenkinsBuild.class);

			buildDumper.addAttribute("type", build.getType()) //
					.addAttribute("commitId", build.getCommitId()) //
					.addAttribute("result", build.getResult()) //
					.addAttribute("id", build.getId());

			// 3.5. SPECIAL CASE: unm-ios-ut: Tests an actual UnivMobile.app
			// with embedded commitId (the one used to build the app).

			if ("unm-ios-it".equals(jobName)
					|| "unm-ios-it_ios6".equals(jobName)) {

				// e.g.
				// http://univmobile.vswip.com/job/unm-ios-it/35/artifact/unm-ios-it/target/screenshots/pageSource.xml

				final AppiumPageSource pageSource = loadXMLContent(client,
						baseURL + "job/" + jobName + "/" + buildNumber
								+ "/artifact/unm-ios-it/target/screenshots"
								+ "/pageSource.xml", AppiumPageSource.class);

				if (pageSource == null) { // Not found.
					continue;
				}

				final String buildInfo = pageSource.getBuildInfo();

				// System.out.println(buildInfo);

				final String appCommitId = substringAfter(buildInfo,
						"https://github.com/univmobile/unm-ios").trim();

				buildDumper.addAttribute("appCommitId", appCommitId);
			}

			builds.add(build);
		}

		jobDumper.close();

		// 4. SPECIAL CASE: unm-ios-ut-results => unm-ios-ut

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

				final File file = saveTextContent(client, baseURL + "job/"
						+ jobName + "/" + buildNumber + "/consoleText");

				final Dumper fakeBuild = fakeJob.addElement("build")
						//
						.addAttribute("number", build.getNumber())
						//
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
	}

	private static <T> T loadXMLContent(final HttpClient client,
			final String url, final Class<T> clazz) throws IOException {

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

	private static File saveTextContent(final HttpClient client,
			final String url) throws IOException {

		System.out.println("Saving text from: " + url + "...");

		final HttpMethod method = new GetMethod(url);

		method.setDoAuthentication(true);

		client.executeMethod(method);

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
}

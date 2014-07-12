package fr.univmobile.it;

import static org.apache.commons.lang3.StringUtils.substringAfter;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;

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
import org.junit.Test;

import fr.univmobile.ios.ut.JGitHelper;

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

		final Dumper dumper = XMLDumper.newXMLDumper("unm-ci-dump", new File(
				"target/unm-ci-dump.xml"));
		try {

			dumpGitCommitsForRepo(dumper, "unm-ios", 20);

			dumpJenkinsBuildsForJob(dumper, "unm-ios_xcode", 20);

			dumpJenkinsBuildsForJob(dumper, "unm-ios-ut-results", 20);

			dumpJenkinsBuildsForJob(dumper, "unm-ios-it", 20);

		} finally {
			dumper.close();
		}
	}

	private static void dumpGitCommitsForRepo(final Dumper dumper,
			final String repoName, final int max) throws Exception {

		final JGitHelper jgitHelper;

		final File repoDir = new File("target/" + repoName);

		/*
		 * if (repoDir.exists()) { FileUtils.deleteDirectory(repoDir); }
		 * 
		 * jgitHelper = JGitHelper.cloneRepo( "https://github.com/univmobile/" +
		 * repoName, repoDir);
		 */
		jgitHelper = new JGitHelper(new File(repoDir, ".git"));

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

		final String baseURL = "http://univmobile.vswip.com/";

		final String username = "dandriana";
		final String apiToken = "135c8b3c35c120652e5dc488997ef8ec";

		client.getState().setCredentials(
				new AuthScope("univmobile.vswip.com", 80, "realm"),
				new UsernamePasswordCredentials(username, apiToken));

		client.getParams().setAuthenticationPreemptive(true);

		// 2. GET JOB STATUS

		final JenkinsJob job = loadXMLContent(client, baseURL + "job/"
				+ jobName + "/api/xml", JenkinsJob.class);

		final Dumper jobDumper = dumper.addElement("jenkinsJob") //
				.addAttribute("name", job.getName()) //
				.addAttribute("type", job.getType());

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

		}
	}

	private static <T> T loadXMLContent(final HttpClient client,
			final String url, final Class<T> clazz) throws IOException {

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

		final File xmlFile = new File( //
				substringAfter(substringAfter(url, "://"), "/") //
						.replace("/", "_") //
						.replace("_xml", ".xml"));

		FileUtils.writeByteArrayToFile(xmlFile, bytes);

		return DomBinderUtils.xmlContentToJava(xmlFile, clazz);
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

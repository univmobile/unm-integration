package fr.univmobile.ios.ut;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.revwalk.RevCommit;
import org.eclipse.jgit.revwalk.RevTag;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class JGitHelperTest {

	@Before
	public void setUp() throws Exception {

		jgitHelper = new JGitHelper(new File("../.git"));
	}

	private JGitHelper jgitHelper;

	@After
	public void tearDown() throws Exception {

		jgitHelper.close();
	}

	@Test
	public void testMostAncientCommit_isXxx() throws Exception {

		final RevCommit[] commits = jgitHelper.getCommitsFromHead(10000);

		assertEquals("c9f193dd53322d9f4fbfbb3e2cd04bd033d8b5ce",
				commits[commits.length - 1].getId().name());
	}

	@Test
	public void testAllCommitsForFile() throws Exception {

		final RevCommit[] commits = jgitHelper.getCommitsForFileFromHead(
				"unm-ios-ut-results/data/xcodebuild_test.log", 100);

		final String[] refCommitIds = new String[] {

		"b9fa7c6530814a6163ad4b09c33a05e265b2b07d",

				// 704fbf1cbd0b4c3556fdfcee4caea7c4ee3d4187
				// a211dc0c436ea00edd14a4e2a6a4f85c98b95ad6
				// 355f383e0b53e6b70a5ac4355838e14ef8793f60
				// 871efd3541db36f7a65de2855c1547cdd40867cb
				// ba163c953dd223f3294e3fc2bcfcf9ccb94226e3

				"2d8d173c0458b5d7b06d9ff1bd50cb9843b4905b",

				"3d0da8f49b185aa6e23ee61fe6e56c79d0ce794c",

				"b7d4fe2432fd2b0298e8fbae989aaecc0c321a62",

				"70595ef66410e8d536e3250bd39817465a404c94",

				"080175a1a0f6a26f0370878e0ffdff4c4efd14ac",

				// ef834928d9e5c4a5ecb2e538fd96d253ad342d7d
				// fe4593bd9b2123c29cc5bedd9f2153c2c33bd820

				"db5ec2674610d5ccb18fe083168dd0f97c5f0574",

				// a7712a74965a9f72225b7ac039ef7ecdd726a900

				"31ded68e65278a24222041d67c0b6a94cd1fd45d"

		// ba59887d7353bdf0c71e54e5f21873145f07cb10
		};

		final String[] refRevFileIds = new String[] {
				"a5587b0944306b3f17a410a3893155ddede0c6f1",
				"2598e1c9ce05d615f287746c05a2037a5c9637b1",
				"96b37875aaa2cd4382f79d09ac1f2c28affa79a4",
				"c8395be3c77084a7d52e7df8682a8ba2ae996695",
				"1f8f84a941b8984336d727e396ccbeae01dd2ea4",
				"4718fe7ee02a82d01f0f8405d056403dd6d719b2",
				"4da0450f95a89fa13c8f6496564136731664db4d",
				"1bb048f52abf5443fd94d7d3e5c2304a5f696cfc" };

		assertTrue(commits.length >= 8);

		for (int i = 0; i < 8; ++i) {

			final RevCommit commit = commits[commits.length - 8 + i];

			assertEquals("commitIds[" + i + "]", refCommitIds[i], commit
					.getId().getName());

			assertEquals(
					"revFileIds[" + i + "]",
					refRevFileIds[i],
					jgitHelper.getRevFileIdInCommit(
							"unm-ios-ut-results/data/xcodebuild_test.log",
							commit).name());

		}
	}

	@Test
	public void testGetCommitById() throws Exception {

		assertEquals("224b6168efa98f870cd3851ad33be22fe48fbcc2", jgitHelper
				.getCommitById("224b6168efa98f870cd3851ad33be22fe48fbcc2")
				.getId().getName());
	}

	@Test
	public void testTag() throws Exception {

		final Git git = new Git(jgitHelper.repo);

		final String TAG_NAME = "toto";

		final RevTag tag0 = jgitHelper.getTag(TAG_NAME);

		if (tag0 != null) {
			throw new Exception("Tag already exists: " + TAG_NAME);
		}

		assertFalse(jgitHelper.hasTag(TAG_NAME));

		git.tag()
				.setName(TAG_NAME)
				// name
				.setObjectId(
						jgitHelper
								.getCommitById("92ec7ab785ac35b739007ee94a88526880011cbd")) // commit
				.setMessage("Set by JGitHelperTest.java") //
				.call();

		final RevTag tag1 = jgitHelper.getTag(TAG_NAME);

		assertNotNull("tag1, after creation", tag1);

		assertTrue(jgitHelper.hasTag(TAG_NAME));

		git.tagDelete().setTags(TAG_NAME).call();

		final RevTag tag2 = jgitHelper.getTag(TAG_NAME);

		assertNull("tag2, after deletion", tag2);

		assertFalse(jgitHelper.hasTag(TAG_NAME));
	}

	@Test
	public void testCloneRepo() throws Exception {

		final String PROJECT_NAME = "unm-integration";

		final File dir = new File("target/" + PROJECT_NAME);

		if (dir.exists()) {
			FileUtils.deleteDirectory(dir);
		}

		final File pomFile = new File(dir, "unm-ios-ut-results/pom.xml");

		assertFalse(pomFile.exists());

		final JGitHelper jgitHelper = JGitHelper.cloneRepo(
				"https://github.com/univmobile/" + PROJECT_NAME, dir);

		assertTrue(pomFile.exists());

		final RevCommit[] commits = jgitHelper.getCommitsForFileFromHead(
				"unm-ios-ut-results/data/xcodebuild_test.log", 100);

		assertTrue(commits.length > 8);
	}
}

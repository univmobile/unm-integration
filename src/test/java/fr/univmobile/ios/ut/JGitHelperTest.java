package fr.univmobile.ios.ut;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.io.File;

import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.revwalk.RevCommit;
import org.eclipse.jgit.revwalk.RevTag;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class JGitHelperTest {

	@Before
	public void setUp() throws Exception {

		jgitHelper = new JGitHelper(new File("./.git"));
	}

	private JGitHelper jgitHelper;

	@After
	public void tearDown() throws Exception {

		jgitHelper.close();
	}

	@Test
	public void testMostAncientCommit_isXxx() throws Exception {

		final RevCommit[] commits = jgitHelper.getAllCommitsFromHead();

		assertEquals("c9f193dd53322d9f4fbfbb3e2cd04bd033d8b5ce",
				commits[commits.length - 1].getId().name());
	}

	@Test
	public void testAllCommitsForFile() throws Exception {

		final RevCommit[] commits = jgitHelper
				.getAllCommitsForFileFromHead("data/xcodebuild_test.log");

		final String[] refCommitIds = new String[] {

				// Has the same file as f60bed6f380d97b8b17660df102be6483caac6b3
				// "8c1a1f53e80e31258a11ea71cd87b4b9b0fbe2ce",

				// Has the same file as f60bed6f380d97b8b17660df102be6483caac6b3
				// "6ab76cecd6ee834cb3fee0037434856aea6f82f7",

				// Has the same file as f60bed6f380d97b8b17660df102be6483caac6b3
				// Has two parents:
				// 1. 140415f233973ad9dbe58cd54d7fd18ac60802f2
				// 2. f60bed6f380d97b8b17660df102be6483caac6b3
				// "3461962b9ba07b0fb2e6c84b57a7ef183a1dfceb",

				// Has the same file as 56f4865d0a703a9f1ee03005f10a1bb18461dfec
				// "140415f233973ad9dbe58cd54d7fd18ac60802f2",

				"f60bed6f380d97b8b17660df102be6483caac6b3",

				"c6b3ec0649f8909350fe05a55dafbbec89f95c1e",

				"37dd921fee7e0d5477387fd389cf171c6beb5387",

				"224b6168efa98f870cd3851ad33be22fe48fbcc2",

				"92ec7ab785ac35b739007ee94a88526880011cbd",

				"94ea8a8999399aa4b15cd9206726931563902cb1",

				"aa88a62a984a2add51190d74f9eed92191800c7e",

				// Has two children:
				// 1. 140415f233973ad9dbe58cd54d7fd18ac60802f2
				// 2. aa88a62a984a2add51190d74f9eed92191800c7e
				"56f4865d0a703a9f1ee03005f10a1bb18461dfec" };

		final String[] refRevFileIds = new String[] {
				"0ee4312200bc6b3154bbe6c40d6de138f47fc196",
				"bee4268ed3e3874171a3bdc987f9afdb7feba412",
				"61d96ca16cc3a563c4d0e16a44ea145ef7d0aa35",
				"2d9f47d13bc8d0a085fdfa31bdd609f4d86a7686",
				"2dcb39883bc269e7ceba018d7591005f3e33bd5c",
				"d7c6b35547cd91558f507273e1c7e66be6d6a061",
				"a51a8e53da32afdd5f583decf5a602bfc695bd67",
				"daa3a453420c622cbd6a16091e65b726f1213abe" };

		assertTrue(commits.length >= 8);

		for (int i = 0; i < 8; ++i) {

			final RevCommit commit = commits[commits.length - 8 + i];

			assertEquals("commitIds[" + i + "]", refCommitIds[i], commit
					.getId().getName());

			assertEquals("revFileIds[" + i + "]", refRevFileIds[i], jgitHelper
					.getRevFileIdInCommit("data/xcodebuild_test.log", commit)
					.name());

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
}

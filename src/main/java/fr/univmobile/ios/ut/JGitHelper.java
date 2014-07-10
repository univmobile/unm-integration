package fr.univmobile.ios.ut;

import static com.google.common.base.Preconditions.checkNotNull;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.eclipse.jgit.lib.Constants;
import org.eclipse.jgit.lib.ObjectId;
import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.revwalk.RevCommit;
import org.eclipse.jgit.revwalk.RevWalk;
import org.eclipse.jgit.storage.file.FileRepositoryBuilder;
import org.eclipse.jgit.treewalk.CanonicalTreeParser;
import org.eclipse.jgit.treewalk.TreeWalk;

import com.google.common.collect.Iterables;

public class JGitHelper {

	/**
	 * @parameter gitDir the local directory named ".git"
	 */
	public JGitHelper(final File gitDir) throws IOException {

		checkNotNull(gitDir, "gitDir");

		if (!".git".equals(gitDir.getName())) {

			throw new IllegalArgumentException(
					"gitDir should be of the form /my/path/.git");
		}

		if (!gitDir.isDirectory()) {

			throw new FileNotFoundException("gitDir is not a directory: "
					+ gitDir.getPath());
		}

		this.gitDir = gitDir;

		final FileRepositoryBuilder builder = new FileRepositoryBuilder();

		repo = builder.setGitDir(gitDir).readEnvironment().findGitDir().build();

	}

	public final File gitDir;

	public final Repository repo;

	public void close() {

		repo.close();
	}

	public RevCommit[] getAllCommitsFromHead() throws IOException {

		final ObjectId head = repo.resolve(Constants.HEAD);

		final RevWalk walk = new RevWalk(repo);

		final RevCommit root = walk.parseCommit(head);

		walk.markStart(root);

		// revWalk.setRetainBody(false);

		final List<RevCommit> commits = new ArrayList<RevCommit>();

		for (final RevCommit commit : walk) {

			commits.add(commit);
		}

		return Iterables.toArray(commits, RevCommit.class);
	}

	/*
	 * public RevCommit getRevCommit(final ObjectId commitId) throws IOException
	 * {
	 * 
	 * final ObjectId head = repo.resolve(Constants.HEAD);
	 * 
	 * final RevWalk walk = new RevWalk(repo);
	 * 
	 * final RevCommit root = walk.parseCommit(head);
	 * 
	 * walk.markStart(root);
	 * 
	 * // revWalk.setRetainBody(false);
	 * 
	 * final List<ObjectId> commitIds = new ArrayList<ObjectId>();
	 * 
	 * for (final RevCommit commit : walk) {
	 * 
	 * if (commitId.equals(commit.getId())) {
	 * 
	 * return commit; } }
	 * 
	 * return null; }
	 */

	public ObjectId getRevFileIdInCommit(final String filePath,
			final RevCommit commit) throws IOException {

		final TreeWalk treeWalk = TreeWalk.forPath(repo,
				"data/xcodebuild_test.log", commit.getTree());

		if (treeWalk == null) {
			return null;
		}

		treeWalk.setRecursive(true);

		final CanonicalTreeParser canonicalTreeParser = treeWalk.getTree(0,
				CanonicalTreeParser.class);

		if (!canonicalTreeParser.eof()) {

			// System.out
			// .println("   " + canonicalTreeParser.getEntryPathString());

			return canonicalTreeParser.getEntryObjectId();

			/*
			 * // if the filename matches, we have a match, so set teh byte
			 * array to return if (canonicalTreeParser.getEntryPathString() ==
			 * relativeFilePath) { ObjectLoader objectLoader =
			 * repository.open(canonicalTreeParser.getEntryObjectId()) bytes =
			 * objectLoader.bytes }
			 */
		}

		return null;
	}

	public RevCommit[] getAllCommitsForFileFromHead(final String filePath)
			throws IOException {

		final RevCommit[] allCommits = getAllCommitsFromHead();

		final Set<ObjectId> revFileIds = new HashSet<ObjectId>();

		final List<RevCommit> commits = new ArrayList<RevCommit>();

		for (int i = 0; i < allCommits.length; ++i) {

			final RevCommit commit = allCommits[allCommits.length - 1 - i];

			final ObjectId revFileId = getRevFileIdInCommit(filePath, commit);

			if (revFileId == null || revFileIds.contains(revFileId)) {
				continue;
			}

			revFileIds.add(revFileId);

			commits.add(0, commit);
		}

		return Iterables.toArray(commits, RevCommit.class);
	}
}

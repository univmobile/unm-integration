package fr.univmobile.ios.ut;

import static com.google.common.base.Preconditions.checkNotNull;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.errors.GitAPIException;
import org.eclipse.jgit.lib.Constants;
import org.eclipse.jgit.lib.ObjectId;
import org.eclipse.jgit.lib.ObjectLoader;
import org.eclipse.jgit.lib.Ref;
import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.revwalk.RevCommit;
import org.eclipse.jgit.revwalk.RevTag;
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

		if (canonicalTreeParser.eof()) {
			return null;
		}

		return canonicalTreeParser.getEntryObjectId();
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

	public RevCommit getCommitById(final String commitId) throws IOException {

		final RevWalk walk = new RevWalk(repo);

		final RevCommit commit = walk
				.parseCommit(ObjectId.fromString(commitId));

		return commit;
	}

	public byte[] loadRevFileContent(final ObjectId revFileId)
			throws IOException {

		final ObjectLoader loader = repo.open(revFileId);

		return loader.getBytes();
	}

	public RevTag getTag(final String tagName) throws IOException,
			GitAPIException {

		final String fullName = "refs/tags/" + tagName;

		final Git git = new Git(repo);

		for (final Ref ref : git.tagList().call()) {

			if (fullName.equals(ref.getName())) {

				final ObjectId objectId = ref.getObjectId();

				final RevWalk walk = new RevWalk(repo);

				return walk.parseTag(objectId);
			}
		}

		return null;
	}

	public boolean hasTag(final String tagName) throws IOException,
			GitAPIException {

		return getTag(tagName) != null;
	}
}

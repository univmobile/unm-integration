package fr.univmobile.it.cidump;

import static com.google.common.base.Preconditions.checkNotNull;

import javax.annotation.Nullable;

public class DumpedBuild {

	public final String jobName;

	public final int buildNumber;

	public final boolean isSuccess;

	@Nullable
	public final String appCommitId;
	
	public final String commitId;

	DumpedBuild(final String jobName, final int buildNumber, //
			final boolean isSuccess, //
			final String commitId, //
			@Nullable final String appCommitId) {

		this.jobName = checkNotNull(jobName, "jobName");
		this.commitId = checkNotNull(commitId, "commitId");
		this.buildNumber = buildNumber;
		this.isSuccess = isSuccess;
		this.appCommitId = appCommitId;
	}

	@Override
	public String toString() {

		return "[" + jobName + ":" + buildNumber + " " + isSuccess + "]";
	}

	@Nullable
	public static DumpedBuild getLatestSuccessfulBuildForAppCommitId(
			final DumpedBuild[] builds, final String appCommitId) {

		checkNotNull(builds, "builds");
		
		checkNotNull(appCommitId, "appCommitId");

		for (final DumpedBuild build : builds) {

			if (build.isSuccess && appCommitId.equals(build.appCommitId)) {

				return build;
			}
		}

		return null;
	}
}

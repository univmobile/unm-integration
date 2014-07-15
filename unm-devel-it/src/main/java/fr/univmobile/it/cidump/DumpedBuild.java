package fr.univmobile.it.cidump;

import static com.google.common.base.Preconditions.checkNotNull;

import javax.annotation.Nullable;

public class DumpedBuild {

	public final String jobName;

	public final int buildNumber;

	public boolean isSuccess;

	@Nullable
	public final String appCommitId;

	DumpedBuild(final String jobName, final int buildNumber, //
			final boolean isSuccess, //
			@Nullable final String appCommitId) {

		this.jobName = checkNotNull(jobName, "jobName");
		this.buildNumber = buildNumber;
		this.isSuccess = isSuccess;
		this.appCommitId = appCommitId;
	}
}
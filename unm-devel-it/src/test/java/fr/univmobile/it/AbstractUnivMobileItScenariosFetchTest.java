package fr.univmobile.it;

import static fr.univmobile.it.cidump.DumpedBuild.getLatestSuccessfulBuildForAppCommitId;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Nullable;

import fr.univmobile.it.cidump.DumpedBuild;

public abstract class AbstractUnivMobileItScenariosFetchTest {

	/**
	 * Find an appCommitId common to several Jenkins jobs.
	 */
	protected static final DumpedBuild[] findBuildsWithSamAppCommitId(
			@Nullable String requiredAppCommitId,
			final DumpedBuild[]... buildArrays) {

		final DumpedBuild[] builds = new DumpedBuild[buildArrays.length];

		// 1. In case appCommitId is already required, find it.

		if (requiredAppCommitId != null) {

			for (int i = 0; i < buildArrays.length; ++i) {

				final DumpedBuild build = getLatestSuccessfulBuildForAppCommitId(
						buildArrays[i], requiredAppCommitId);

				if (build == null) {

					dumpBuildArrays(buildArrays, 10);

					throw new IllegalStateException("At least one of the "
							+ buildArrays.length
							+ " jobs has no successful build for appCommitId: "
							+ requiredAppCommitId);
				}

				builds[i] = build;
			}

			return builds;
		}

		// 2. Otherwise, first find a common appCommitId

		final List<String> appCommitIds = new ArrayList<String>();

		for (final DumpedBuild build : buildArrays[0]) {

			if (!build.isSuccess || build.appCommitId == null) {
				continue;
			}

			appCommitIds.add(build.appCommitId);
		}

		appCommitIds: for (final String appCommitId : appCommitIds) {

			buildArrays: for (final DumpedBuild[] buildArray : buildArrays) {

				for (final DumpedBuild build : buildArray) {

					if (!build.isSuccess || build.appCommitId == null) {
						continue;
					}

					if (build.appCommitId.equals(appCommitId)) {

						continue buildArrays; // This build matches, find next
					}
				}

				continue appCommitIds; // Not the right appCommitId
			}

			return findBuildsWithSamAppCommitId(appCommitId, buildArrays);
		}

		// 9. Too bad we didn’t find anything

		dumpBuildArrays(buildArrays, 10);

		throw new IllegalStateException(
				"No common appCommitId could be found for the "
						+ buildArrays.length + " jobs.");
	}

	private static void dumpBuildArrays(final DumpedBuild[][] buildArrays,
			final int max) {

		for (final DumpedBuild[] buildArray : buildArrays) {

			for (final DumpedBuild build : buildArray) {

				System.out.println(build.appCommitId + " " + build.isSuccess
						+ " #" + build.buildNumber);
			}

			System.out.println();
		}
	}
}

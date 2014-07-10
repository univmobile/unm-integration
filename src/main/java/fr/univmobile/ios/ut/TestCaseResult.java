package fr.univmobile.ios.ut;

import static org.apache.commons.lang3.StringUtils.substringBetween;

public class TestCaseResult {

	/**
	 * e.g.
	 * "-[UNMAppLayerTests testAppLayer_refreshRegionsData_sizeOfRegionsIs3]"
	 */
	public final String id;

	/**
	 * e.g. "testAppLayer_refreshRegionsData_sizeOfRegionsIs3"
	 */
	public final String name;

	public TestCaseResult(final String id) {

		this.id = id;

		this.name = substringBetween(id, " ", "]");
	}

	public void setFailed() {

		checkStateIsNotSet();

		failure = true;
	}

	public void setPassed() {

		checkStateIsNotSet();

		success = true;
	}

	public void setError() {

		checkStateIsNotSet();

		error = true;
	}

	public void setElapsedTimeMs(final int ms) {

		this.elapsedTimeMs = ms;
	}

	public int getElapsedTimeMs() {

		return elapsedTimeMs;
	}

	private int elapsedTimeMs = -1;

	private boolean stateIsSet = false;

	private boolean success = false;
	private boolean failure = false;
	private boolean error = false;

	public boolean isSuccess() {

		checkStateIsSet();

		return success;
	}

	public boolean isFailure() {

		checkStateIsSet();

		return failure;
	}

	private void checkStateIsSet() {

		if (!stateIsSet) {
			throw new IllegalStateException(
					"TestCaseResult.state has not been set.");
		}
	}

	private void checkStateIsNotSet() {

		if (stateIsSet) {
			throw new IllegalStateException(
					"TestCaseResult.state is already set.");
		}

		stateIsSet = true;
	}

	public boolean isError() {

		checkStateIsSet();

		return error;
	}
}

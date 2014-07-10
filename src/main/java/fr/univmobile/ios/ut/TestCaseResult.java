package fr.univmobile.ios.ut;

import static com.google.common.base.Preconditions.checkNotNull;
import static org.apache.commons.lang3.StringUtils.substringBetween;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Nullable;

import com.google.common.collect.Iterables;

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

		if (message == null) {
			throw new IllegalStateException(
					"TestCaseResult.message has not been set.");
		}

		if (!failure && !error) {

			checkStateIsNotSet();

			failure = true;
		}
	}

	public void setPassed() {

		if (!success) {

			checkStateIsNotSet();

			success = true;
		}
	}

	public void setError() {

		if (message == null) {
			throw new IllegalStateException(
					"TestCaseResult.message has not been set.");
		}

		if (!error) {

			checkStateIsNotSet();

			error = true;
		}
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

	@Nullable
	public String getMessage() {

		/*
		if (message == null) {
			throw new IllegalStateException(
					"TestCaseResult.message has not been set.");
		}
		*/

		return message;
	}

	private String message;

	public void setMessage(final String message) {

		if (this.message != null) {
			throw new IllegalStateException(
					"TestCaseResult.message is already set.");
		}

		this.message = checkNotNull(message, "message");
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

	@Override
	public String toString() {

		return name;
	}

	public String[] getOutputLines() {

		return Iterables.toArray(outputLines, String.class);
	}

	private final List<String> outputLines = new ArrayList<String>();

	public void addOutputLine(final String outputLine) {

		outputLines.add(outputLine);
	}
}

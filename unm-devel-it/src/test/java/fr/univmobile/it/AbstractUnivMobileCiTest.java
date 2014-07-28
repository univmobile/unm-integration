package fr.univmobile.it;

import java.io.IOException;

import org.junit.Before;

public abstract class AbstractUnivMobileCiTest {

	@Before
	public final void setUp() throws IOException {

		branch = "develop";
	}

	protected String branch;

	protected static String calcJobSuffix(final String branch) {

		if ("develop".equals(branch)) {

			return ""; // no suffix

		} else if ("master".equals(branch)) {

			return "_release";

		} else {

			throw new IllegalStateException("Unknown branch: " + branch);
		}
	}
}

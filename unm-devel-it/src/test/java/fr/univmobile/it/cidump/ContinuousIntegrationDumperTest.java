package fr.univmobile.it.cidump;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class ContinuousIntegrationDumperTest {

	@Test
	public void testEscapeURL() throws Exception {

		assertEquals("http://myjob/Choix_de_r%C3%A9gion_000.xml",
				ContinuousIntegrationDumper
						.escapeURL("http://myjob/Choix_de_région_000.xml"));
	}
}

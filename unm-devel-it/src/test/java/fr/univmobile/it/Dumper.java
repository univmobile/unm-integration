package fr.univmobile.it;

import java.io.IOException;

interface Dumper {

	Dumper addElement(String name) throws IOException;

	Dumper addAttribute(String name, Object value) throws IOException;

	Dumper close() throws IOException;
}

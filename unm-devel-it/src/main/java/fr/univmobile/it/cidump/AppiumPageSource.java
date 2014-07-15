package fr.univmobile.it.cidump;

import net.avcompris.binding.annotation.XPath;

@XPath("/AppiumAUT")
public interface AppiumPageSource {

	@XPath("descendant::UIATextView[contains(@value, 'https://github.com')]/@value")
	String getBuildInfo();
}

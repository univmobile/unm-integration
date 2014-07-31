package fr.univmobile.it.cidump;

import net.avcompris.binding.annotation.XPath;

@XPath("/AppiumAUT")
public interface AppiumIOSPageSource {

	@XPath("descendant::UIATextView[contains(@value, 'https://github.com')]/@value")
	String getBuildInfo();
}

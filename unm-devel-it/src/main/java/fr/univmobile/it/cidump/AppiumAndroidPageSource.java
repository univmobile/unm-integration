package fr.univmobile.it.cidump;

import net.avcompris.binding.annotation.XPath;

@XPath("/hierarchy")
public interface AppiumAndroidPageSource {

	@XPath("//*[@resource-id = 'org.unpidf.univmobile:id/gitCommit']/@text")
	String getGitCommitId();
}

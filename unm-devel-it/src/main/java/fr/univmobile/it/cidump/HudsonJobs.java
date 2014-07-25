package fr.univmobile.it.cidump;

import net.avcompris.binding.annotation.XPath;

@XPath("/hudson")
public interface HudsonJobs {

	@XPath("job")
	JenkinsJob[] getJobs();
}

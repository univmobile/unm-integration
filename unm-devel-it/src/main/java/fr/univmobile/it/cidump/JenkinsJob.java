package fr.univmobile.it.cidump;

import net.avcompris.binding.annotation.XPath;

@XPath("/*")
interface JenkinsJob {

	@XPath(value = ".", function = "name()")
	String getType();

	@XPath("name")
	String getName();

	@XPath("url")
	String getUrl();

	@XPath("build")
	Build[] getBuilds();

	interface Build {

		@XPath("number")
		int getNumber();

		@XPath("url")
		String getUrl();
	}
}

@XPath("/*")
interface JenkinsBuild {

	@XPath(value = ".", function = "name()")
	String getType();

	@XPath("number")
	int getNumber();

	@XPath("action/buildsByBranchName/originmaster/marked/SHA1")
	String getCommitId();
	
	@XPath("result")
	String getResult();
	
	// @XPath("result = 'SUCCESS'")
	// boolean isSuccess();
	
	@XPath("id")
	String getId();
}

<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="defs-it-scenarios-dump.html.xsl"/>
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:variable name="release">
<xsl:if test="/*/scenarios[contains(@jobName, '_release')]">_release</xsl:if>
</xsl:variable>

<xsl:template match="/unm-ios-it-scenarios-dump">
<html lang="fr" dir="ltr">

<xsl:call-template name="html-head"/>

<body>

<xsl:call-template name="div-detail"/>

<!-- 
<div class="nav">
<a href="{$mvn-generated-site}">Back to the Maven Generated Site</a>
</div>
-->

<div class="nav">
<a href="http://univmobile.vswip.com/">Jenkins — Intégration continue</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-ci-dump.html">
UnivMobile iOS — Intégration continue
</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/ios/">UnivMobile iOS — Installations ad hoc</a>
</div>

<h1>UnivMobile iOS — Scénarios</h1>

<xsl:variable name="buildNumber_ios7"
	select="/*/scenarios[@jobName = 'unm-ios-it']/@buildNumber"/>
<xsl:variable name="buildNumber_ios6"
	select="/*/scenarios[@jobName = 'unm-ios-it_ios6']/@buildNumber"/>

<div id="div-appCommitId">
appCommitId:
<xsl:value-of select="/*/scenarios/@appCommitId"/>;
<a href="http://univmobile.vswip.com/job/unm-ios-it{$release}/">
	unm-ios-it<xsl:value-of select="$release"/></a>:
	<a href="http://univmobile.vswip.com/job/unm-ios-it{$release}/{$buildNumber_ios7}">Build
	#<xsl:value-of select="$buildNumber_ios7"/></a>;
<a href="http://univmobile.vswip.com/job/unm-ios-it_ios6{$release}/">
	unm-ios-it_ios6<xsl:value-of select="$release"/></a>:
	<a href="http://univmobile.vswip.com/job/unm-ios-it_ios6{$release}/{$buildNumber_ios6}">Build
	#<xsl:value-of select="$buildNumber_ios6"/></a>;
	
</div>

<xsl:call-template name="scenarios"/>

</body>
</html>
</xsl:template>



</xsl:stylesheet>
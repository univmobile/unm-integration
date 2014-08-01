<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="defs-it-scenarios-dump.html.xsl"/>
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:template match="/unm-backend-it-scenarios-dump">
<html lang="fr" dir="ltr">

<xsl:call-template name="html-head"/>

<body id="body-backend">

<xsl:call-template name="div-detail-backend"/>

<!-- 
<div class="nav">
<a href="{$mvn-generated-site}">Back to the Maven Generated Site</a>
</div>
-->

<div class="nav">
<a href="http://univmobile.vswip.com/">Jenkins — Intégration continue</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-backend-ci-dump.html">
UnivMobile backend — Intégration continue
</a>
</div>

<h1>UnivMobile backend — Scénarios</h1>

<xsl:variable name="buildNumber_it"
	select="/*/scenarios[starts-with(@jobName, 'unm-backend-it')]/@buildNumber"/>
<xsl:variable name="jobName"
	select="/*/scenarios[starts-with(@jobName, 'unm-backend-it')]/@jobName"/>
<xsl:variable name="buildNumber_it_macos"
	select="/*/scenarios[starts-with(@jobName, 'unm-backend-it_macos')]/@buildNumber"/>
<xsl:variable name="jobName_macos"
	select="/*/scenarios[starts-with(@jobName, 'unm-backend-it_macos')]/@jobName"/>

<div id="div-appCommitId">
<xsl:value-of select="/*/scenarios/@appCommitId"/>
<br/>
<a href="http://univmobile.vswip.com/job/{$jobName}/">
<xsl:value-of select="$jobName"/>
</a>:
	<a href="http://univmobile.vswip.com/job/{$jobName}/{$buildNumber_it}">Build
	#<xsl:value-of select="$buildNumber_it"/></a>
—
<a href="http://univmobile.vswip.com/job/{$jobName_macos}/">
<xsl:value-of select="$jobName_macos"/>
</a>:
	<a href="http://univmobile.vswip.com/job/{$jobName_macos}/{$buildNumber_it_macos}">Build
	#<xsl:value-of select="$buildNumber_it_macos"/></a>
	
</div>

<xsl:call-template name="scenarios">
<!--  
<xsl:with-param name="grid" select="document('')//xsl:variable[@name = 'grid']"/>
-->
</xsl:call-template>

</body>
</html>
</xsl:template>

</xsl:stylesheet>
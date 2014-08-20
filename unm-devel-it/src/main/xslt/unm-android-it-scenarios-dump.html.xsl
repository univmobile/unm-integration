<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="defs-it-scenarios-dump.html.xsl"/>
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<!-- 
<xsl:variable name="grid">
	<platform name="Android_XXX">
		<device name="Android_Emulator"/>
	</platform>
</xsl:variable>
-->

<xsl:template match="/unm-android-it-scenarios-dump">
<html lang="fr" dir="ltr">

<xsl:call-template name="html-head"/>

<body>

<xsl:call-template name="div-detail-android"/>

<!-- 
<div class="nav">
<a href="{$mvn-generated-site}">Back to the Maven Generated Site</a>
</div>
-->

<div class="nav">
<a href="http://univmobile.vswip.com/">Jenkins — Intégration continue</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-android-ci-dump.html">
UnivMobile Android — Intégration continue
</a>
</div>

<h1>UnivMobile Android — Scénarios</h1>

<xsl:variable name="buildNumber_it"
	select="/*/scenarios[starts-with(@jobName, 'unm-android-it')]/@buildNumber"/>
<xsl:variable name="jobName"
	select="/*/scenarios[starts-with(@jobName, 'unm-android-it')]/@jobName"/>

<div id="div-appCommitId">
<xsl:value-of select="/*/scenarios/@appCommitId"/>
<br/>
<xsl:call-template name="scenariosDate"/>
<a href="http://univmobile.vswip.com/job/{$jobName}/">
<xsl:value-of select="$jobName"/>
</a>:
	<a href="http://univmobile.vswip.com/job/{$jobName}/{$buildNumber_it}">Build
	#<xsl:value-of select="$buildNumber_it"/></a>
	
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
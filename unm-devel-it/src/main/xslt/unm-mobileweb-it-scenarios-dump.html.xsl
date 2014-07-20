<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:import href="defs-it-scenarios-dump.html.xsl"/>

<xsl:template match="unm-mobileweb-it-scenarios-dump">
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
<a href="http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-mobileweb-ci-dump.html">
UnivMobile mobile web — Intégration continue
</a>
</div>

<h1>UnivMobile mobile web — Scénarios</h1>

<xsl:variable name="buildNumber_ios7"
	select="/*/scenarios[@jobName = 'unm-mobileweb-it_ios7']/@buildNumber"/>
<xsl:variable name="buildNumber_ios6"
	select="/*/scenarios[@jobName = 'unm-mobileweb-it_ios6']/@buildNumber"/>

<div id="div-appCommitId">
appCommitId:
<xsl:value-of select="/*/scenarios/@appCommitId"/>;
<a href="http://univmobile.vswip.com/job/unm-mobileweb-it_ios7/">unm-mobileweb-it_ios7</a>:
	<a href="http://univmobile.vswip.com/job/unm-mobileweb-it_ios7/{$buildNumber_ios7}">Build
	#<xsl:value-of select="$buildNumber_ios7"/></a>;
<a href="http://univmobile.vswip.com/job/unm-mobileweb-it_ios6/">unm-mobileweb-it_ios6</a>:
	<a href="http://univmobile.vswip.com/job/unm-mobileweb-it_ios6/{$buildNumber_ios6}">Build
	#<xsl:value-of select="$buildNumber_ios6"/></a>;
	
</div>

<xsl:call-template name="scenarios"/>

</body>
</html>
</xsl:template>

</xsl:stylesheet>
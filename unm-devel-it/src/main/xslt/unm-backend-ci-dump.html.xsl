<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="defs-ci-dump.html.xsl"/>
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:template match="/unm-backend-ci-dump">
<html lang="fr" dir="ltr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Content-Language" content="fr"/>
<title>UnivMobile backend — Intégration continue</title>
<xsl:call-template name="style-css"/>
</head>
<body>
<div class="body">

<div class="nav">
<a href="http://univmobile.vswip.com/">Jenkins — Intégration continue</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-backend-it-scenarios-dump.html">
UnivMobile backend — Scénarios
</a>
</div>

<h1>UnivMobile backend — Intégration continue</h1>

<div id="div-dumpDate">
Dump at:
<xsl:call-template name="format-date">
<xsl:with-param name="date" select="@date"/>
</xsl:call-template>
</div>

<xsl:variable name="jenkinsJobs" select="jenkinsJob"/>

<xsl:for-each select="commits[@repository = 'unm-backend']">

<table>
<!--  
<caption>
	Git Repository: 
	http://github.com/univmobile/<xsl:value-of select="@repository"/>
</caption>
-->
<thead>
<tr>
<th class="commitId">
	<a href="https://github.com/univmobile/unm-backend/commits/develop">
		unm-backend: commits
	</a>
	<span class="description">Code source Java</span>
</th>
<th colspan="2" class="unm-backend-app">
	<a href="http://univmobile.vswip.com/job/unm-backend-app/">
		unm-backend-app
	</a>
	<span class="description">Construction de l’archive .war</span>
</th>
<th colspan="2" class="unm-backend-app-noshib">
	<a href="http://univmobile.vswip.com/job/unm-backend-app-noshib/">
		unm-backend-app-noshib
	</a>
	<span class="description">.war + bypass Shibboleth</span>
</th>
<th colspan="2" class="unm-backend-it unm-backend-it_macos">
	<a href="http://univmobile.vswip.com/job/unm-backend-it/">
		unm-backend-it
	</a>
	<span class="description">Tests d’intégration Debian
		<!-- JUnit + Selenium -->
	</span>
</th>
<th colspan="2" class="unm-backend-it unm-backend-it_macos">
	<a href="http://univmobile.vswip.com/job/unm-backend-it_macos/">
		unm-backend-it_macos
	</a>
	<span class="description">Tests d’intégration Mac OS 
		<!-- JUnit + Selenium -->
	</span>
</th>
</tr>
</thead>
<tbody>
<xsl:for-each select="commit">
<xsl:variable name="commitId" select="@id"/>
<xsl:variable name="jenkinsBuilds"
	select="$jenkinsJobs/build[(@commitId = $commitId and not(@appCommitId))
		or @appCommitId = $commitId]"/>
	
<xsl:variable name="jenkinsBuilds-unm-backend-app"
	select="$jenkinsBuilds[../@name = 'unm-backend-app']"/>
<xsl:variable name="jenkinsBuilds-unm-backend-app-noshib"
	select="$jenkinsBuilds[../@name = 'unm-backend-app-noshib']"/>
<xsl:variable name="jenkinsBuilds-unm-backend-it"
	select="$jenkinsBuilds[../@name = 'unm-backend-it']"/>
<xsl:variable name="jenkinsBuilds-unm-backend-it_macos"
	select="$jenkinsBuilds[../@name = 'unm-backend-it_macos']"/>
	
<xsl:variable name="sizeOfBuilds-unm-backend-app"
	select="count($jenkinsBuilds-unm-backend-app)"/>
<xsl:variable name="sizeOfBuilds-unm-backend-app-noshib"
	select="count($jenkinsBuilds-unm-backend-app-noshib)"/>
<xsl:variable name="sizeOfBuilds-unm-backend-it"
	select="count($jenkinsBuilds-unm-backend-it)"/>
<xsl:variable name="sizeOfBuilds-unm-backend-it_macos"
	select="count($jenkinsBuilds-unm-backend-it_macos)"/>
	
<xsl:variable name="rowCount">
<xsl:choose>
<xsl:when test="$sizeOfBuilds-unm-backend-app &gt;= $sizeOfBuilds-unm-backend-app-noshib
		and $sizeOfBuilds-unm-backend-app &gt;= $sizeOfBuilds-unm-backend-it
		and $sizeOfBuilds-unm-backend-app &gt;= $sizeOfBuilds-unm-backend-it_macos">
	<xsl:value-of select="$sizeOfBuilds-unm-backend-app"/>
</xsl:when>
<xsl:when test="$sizeOfBuilds-unm-backend-app-noshib &gt;= $sizeOfBuilds-unm-backend-app
		and $sizeOfBuilds-unm-backend-app-noshib &gt;= $sizeOfBuilds-unm-backend-it
		and $sizeOfBuilds-unm-backend-app-noshib &gt;= $sizeOfBuilds-unm-backend-it_macos">
	<xsl:value-of select="$sizeOfBuilds-unm-backend-app-noshib"/>
</xsl:when>
<xsl:when test="$sizeOfBuilds-unm-backend-it &gt;= $sizeOfBuilds-unm-backend-app
		and $sizeOfBuilds-unm-backend-it &gt;= $sizeOfBuilds-unm-backend-app-noshib
		and $sizeOfBuilds-unm-backend-it &gt;= $sizeOfBuilds-unm-backend-it_macos">
	<xsl:value-of select="$sizeOfBuilds-unm-backend-it"/>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="$sizeOfBuilds-unm-backend-it_macos"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<tr>
<td>
<xsl:attribute name="class">
	commitId
	<xsl:if test="$jenkinsBuilds-unm-backend-app/@result = 'SUCCESS'
		and $jenkinsBuilds-unm-backend-app-noshib/@result = 'SUCCESS'
		and $jenkinsBuilds-unm-backend-it[@appCommitId]/@result = 'SUCCESS'
		and $jenkinsBuilds-unm-backend-it_macos[@appCommitId]/@result = 'SUCCESS'">
			SUCCESS</xsl:if>
	<xsl:if test="$jenkinsBuilds/@result = 'FAILURE'"> FAILURE</xsl:if>
	<xsl:if test="$jenkinsBuilds/@result = 'UNSTABLE'"> UNSTABLE</xsl:if>
</xsl:attribute>
<xsl:choose>
<xsl:when test="$rowCount &gt; 1">
<xsl:attribute name="rowspan">
	<xsl:value-of select="$rowCount"/>
</xsl:attribute>
</xsl:when>
</xsl:choose>
	<span title="{@date}&#10;{@shortMessage}">
	<xsl:value-of select="$commitId"/>
	</span>
</td>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-backend-app'"/>
	<xsl:with-param name="index" select="1"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-backend-app-noshib'"/>
	<xsl:with-param name="index" select="1"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-backend-it'"/>
	<xsl:with-param name="index" select="1"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-backend-it_macos'"/>
	<xsl:with-param name="index" select="1"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

</tr>
<xsl:for-each select="$jenkinsBuilds[position() &lt; $rowCount]">
<xsl:variable name="index" select="2
	+ count(preceding::build[(@commitId = $commitId and not(@appCommitId))
		or @appCommitId = $commitId])"/>
<tr>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-backend-app'"/>
	<xsl:with-param name="index" select="$index"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-backend-app-noshib'"/>
	<xsl:with-param name="index" select="$index"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-backend-it'"/>
	<xsl:with-param name="index" select="$index"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-backend-it_macos'"/>
	<xsl:with-param name="index" select="$index"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

</tr>
</xsl:for-each>
</xsl:for-each>
</tbody>
</table>

</xsl:for-each>

<!-- 
<xsl:for-each select="jenkinsJob">

<table>
<caption>
	<xsl:value-of select="@name"/>
</caption>
<tbody>
<xsl:for-each select="build">
<tr>
<td>
Build #<xsl:value-of select="@number"/>
</td>
</tr>
</xsl:for-each>
</tbody>
</table>

</xsl:for-each> 
-->

</div>
</body>
</html>

</xsl:template>

</xsl:stylesheet>
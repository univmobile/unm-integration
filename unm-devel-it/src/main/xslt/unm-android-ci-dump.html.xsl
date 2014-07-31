<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="defs-ci-dump.html.xsl"/>
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:template match="/unm-android-ci-dump">
<html lang="fr" dir="ltr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Content-Language" content="fr"/>
<title>UnivMobile Android — Intégration continue</title>
<xsl:call-template name="style-css"/>
</head>
<body>
<div class="body">

<div class="nav">
<a href="http://univmobile.vswip.com/">Jenkins — Intégration continue</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-android-it-scenarios-dump.html">
UnivMobile Android — Scénarios
</a>
</div>

<h1>UnivMobile Android — Intégration continue</h1>

<div id="div-dumpDate">
Dump at:
<xsl:call-template name="format-date">
<xsl:with-param name="date" select="@date"/>
</xsl:call-template>
</div>

<xsl:variable name="jenkinsJobs" select="jenkinsJob"/>

<xsl:for-each select="commits[@repository = 'unm-android']">

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
	<a href="https://github.com/univmobile/unm-android/commits/develop">
		unm-mobileweb: android
	</a>
	<span class="description">Code source Java</span>
</th>
<th colspan="2" class="Android-UnivMobile">
	<a href="http://univmobile.vswip.com/job/Android-UnivMobile/">
		Android-UnivMobile
	</a>
	<span class="description">Construction .apk par Ant</span>
</th>
<th colspan="2" class="Android-UnivMobile">
	<a href="http://univmobile.vswip.com/job/Android-UnivMobile_gradle/">
		Android-UnivMobile_gradle
	</a>
	<span class="description">Construction .apk par Gradle</span>
</th>
<th colspan="2" class="unm-android-it">
	<a href="http://univmobile.vswip.com/job/unm-android-it/">
		unm-android-it
	</a>
	<span class="description">Tests d’intégration Android Emulator 
		<!-- JUnit + Appium -->
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
	
<xsl:variable name="jenkinsBuilds-Android-UnivMobile"
	select="$jenkinsBuilds[../@name = 'Android-UnivMobile']"/>
<xsl:variable name="jenkinsBuilds-Android-UnivMobile_gradle"
	select="$jenkinsBuilds[../@name = 'Android-UnivMobile_gradle']"/>
<xsl:variable name="jenkinsBuilds-unm-android-it"
	select="$jenkinsBuilds[../@name = 'unm-android-it']"/>
	
<xsl:variable name="sizeOfBuilds-Android-UnivMobile"
	select="count($jenkinsBuilds-Android-UnivMobile)"/>
<xsl:variable name="sizeOfBuilds-Android-UnivMobile_gradle"
	select="count($jenkinsBuilds-Android-UnivMobile_gradle)"/>
<xsl:variable name="sizeOfBuilds-unm-android-it"
	select="count($jenkinsBuilds-unm-android-it)"/>
	
<xsl:variable name="rowCount">
<xsl:choose>
<xsl:when test="$sizeOfBuilds-Android-UnivMobile &gt;= $sizeOfBuilds-Android-UnivMobile_gradle
		and $sizeOfBuilds-Android-UnivMobile &gt;= $sizeOfBuilds-unm-android-it">
	<xsl:value-of select="$sizeOfBuilds-Android-UnivMobile"/>
</xsl:when>
<xsl:when test="$sizeOfBuilds-Android-UnivMobile_gradle &gt;= $sizeOfBuilds-Android-UnivMobile
		and $sizeOfBuilds-Android-UnivMobile_gradle &gt;= $sizeOfBuilds-unm-android-it">
	<xsl:value-of select="$sizeOfBuilds-Android-UnivMobile_gradle"/>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="$sizeOfBuilds-unm-android-it"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<tr>
<td>
<xsl:attribute name="class">
	commitId
	<xsl:if test="$jenkinsBuilds-Android-UnivMobile/@result = 'SUCCESS'
		and $jenkinsBuilds-Android-UnivMobile_gradle/@result = 'SUCCESS'
		and $jenkinsBuilds-unm-android-it/@result = 'SUCCESS'">
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
	<xsl:with-param name="jobName" select="'Android-UnivMobile'"/>
	<xsl:with-param name="index" select="1"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'Android-UnivMobile_gradle'"/>
	<xsl:with-param name="index" select="1"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-android-it'"/>
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
	<xsl:with-param name="jobName" select="'Android-UnivMobile'"/>
	<xsl:with-param name="index" select="$index"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'Android-UnivMobile_gradle'"/>
	<xsl:with-param name="index" select="$index"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-android-it'"/>
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
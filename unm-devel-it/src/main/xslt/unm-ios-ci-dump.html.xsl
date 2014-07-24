<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="defs-ci-dump.html.xsl"/>
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:template match="unm-ios-ci-dump">
<html lang="fr" dir="ltr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Content-Language" content="fr"/>
<title>UnivMobile iOS — Intégration continue</title>
<xsl:call-template name="style-css"/>
</head>
<body>
<div class="body">

<div class="nav">
<a href="http://univmobile.vswip.com/">Jenkins — Intégration continue</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-ios-it-scenarios-dump.html">
UnivMobile iOS — Scénarios
</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/ios/">UnivMobile iOS — Installations ad hoc</a>
</div>

<h1>UnivMobile iOS — Intégration continue</h1>

<div id="div-dumpDate">
Dump at:
<xsl:call-template name="format-date">
<xsl:with-param name="date" select="@date"/>
</xsl:call-template>
</div>

<xsl:variable name="jenkinsJobs" select="jenkinsJob"/>

<xsl:for-each select="commits[@repository = 'unm-ios']">

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
	<a href="https://github.com/univmobile/unm-ios/commits/master">
		unm-ios: commits
	</a>
	<span class="description">Code source Objective-C</span>
</th>
<th colspan="2" class="unm-ios_xcode">
	<a href="http://univmobile.vswip.com/job/unm-ios_xcode/">
		unm-ios_xcode
	</a>
	<span class="description">Construction de l’archive .ipa</span>
</th>
<th colspan="2" class="unm-ios-ut">
	<a href="http://univmobile.vswip.com/job/unm-ios-ut-results/">
		unm-ios-ut
	</a>
	<span class="description">Tests unitaires XCTest</span>
</th>
<th colspan="2" class="unm-ios-it">
	<a href="http://univmobile.vswip.com/job/unm-ios-it/">
		unm-ios-it
	</a>
	<span class="description">Tests d’intégration iOS 7 
		<!-- JUnit + Appium -->
	</span>
</th>
<th colspan="2" class="unm-ios-it unm-ios-it_ios6">
	<a href="http://univmobile.vswip.com/job/unm-ios-it_ios6/">
		unm-ios-it_ios6
	</a>
	<span class="description">Tests d’intégration iOS 6 
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
	
<xsl:variable name="jenkinsBuilds-unm-ios_xcode"
	select="$jenkinsBuilds[../@name = 'unm-ios_xcode']"/>
<xsl:variable name="jenkinsBuilds-unm-ios-ut"
	select="$jenkinsBuilds[../@name = 'unm-ios-ut']"/>
<xsl:variable name="jenkinsBuilds-unm-ios-it"
	select="$jenkinsBuilds[../@name = 'unm-ios-it']"/>
<xsl:variable name="jenkinsBuilds-unm-ios-it_ios6"
	select="$jenkinsBuilds[../@name = 'unm-ios-it_ios6']"/>
	
<xsl:variable name="sizeOfBuilds-unm-ios_xcode"
	select="count($jenkinsBuilds-unm-ios_xcode)"/>
<xsl:variable name="sizeOfBuilds-unm-ios-ut"
	select="count($jenkinsBuilds-unm-ios-ut)"/>
<xsl:variable name="sizeOfBuilds-unm-ios-it"
	select="count($jenkinsBuilds-unm-ios-it)"/>
<xsl:variable name="sizeOfBuilds-unm-ios-it_ios6"
	select="count($jenkinsBuilds-unm-ios-it_ios6)"/>
	
<xsl:variable name="rowCount">
<xsl:choose>
<xsl:when test="$sizeOfBuilds-unm-ios_xcode &gt;= $sizeOfBuilds-unm-ios-ut
		and $sizeOfBuilds-unm-ios_xcode &gt;= $sizeOfBuilds-unm-ios-it
		and $sizeOfBuilds-unm-ios_xcode &gt;= $sizeOfBuilds-unm-ios-it_ios6">
	<xsl:value-of select="$sizeOfBuilds-unm-ios_xcode"/>
</xsl:when>
<xsl:when test="$sizeOfBuilds-unm-ios-ut &gt;= $sizeOfBuilds-unm-ios_xcode
		and $sizeOfBuilds-unm-ios-ut &gt;= $sizeOfBuilds-unm-ios-it
		and $sizeOfBuilds-unm-ios-ut &gt;= $sizeOfBuilds-unm-ios-it_ios6">
	<xsl:value-of select="$sizeOfBuilds-unm-ios-ut"/>
</xsl:when>
<xsl:when test="$sizeOfBuilds-unm-ios-it &gt;= $sizeOfBuilds-unm-ios_xcode
		and $sizeOfBuilds-unm-ios-it &gt;= $sizeOfBuilds-unm-ios-ut
		and $sizeOfBuilds-unm-ios-it &gt;= $sizeOfBuilds-unm-ios-it_ios6">
	<xsl:value-of select="$sizeOfBuilds-unm-ios-it"/>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="$sizeOfBuilds-unm-ios-it_ios6"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<tr>
<td>
<xsl:attribute name="class">
	commitId
	<xsl:if test="$jenkinsBuilds-unm-ios_xcode/@result = 'SUCCESS'
		and $jenkinsBuilds-unm-ios-ut/@result = 'SUCCESS'
		and $jenkinsBuilds-unm-ios-it[@appCommitId]/@result = 'SUCCESS'
		and $jenkinsBuilds-unm-ios-it_ios6[@appCommitId]/@result = 'SUCCESS'">
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
	<xsl:with-param name="jobName" select="'unm-ios_xcode'"/>
	<xsl:with-param name="index" select="1"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-ios-ut'"/>
	<xsl:with-param name="index" select="1"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-ios-it'"/>
	<xsl:with-param name="index" select="1"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-ios-it_ios6'"/>
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
	<xsl:with-param name="jobName" select="'unm-ios_xcode'"/>
	<xsl:with-param name="index" select="$index"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-ios-ut'"/>
	<xsl:with-param name="index" select="$index"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-ios-it'"/>
	<xsl:with-param name="index" select="$index"/>
	<xsl:with-param name="rowCount" select="$rowCount"/>
	</xsl:call-template>

	<xsl:call-template name="td-build">
	<xsl:with-param name="jenkinsBuilds" select="$jenkinsBuilds"/>
	<xsl:with-param name="jobName" select="'unm-ios-it_ios6'"/>
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
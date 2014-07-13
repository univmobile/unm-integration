<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:template match="unm-ci-dump">
<html lang="fr" dir="ltr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Content-Language" content="fr"/>
<title>UnivMobile iOS — Intégration continue</title>
<style type="text/css">
h1 {
	xtext-align: center;
	font-family: Arial, Helvetica, sans-serif;
	margin-bottom: 0;
	margin-top: 0.2em;
}
div.body {
	display: table;
	margin: auto;
}
table {
	border-collapse: collapse;
}
thx {
	border-bottom: 1px solid #000;
	border-top: 1px solid #000;
}
td,
th {
	white-space: nowrap;
}
th span.description {
	display: block;
	font-weight: normal;
	font-size: small;
	font-family: Arial, sans-serif;
}
tbody,
td.commitId,
td.build.first {
	border-top: 1px solid #fff;
}
tbody,
td.commitId,
td.build.last {
	border-bottom: 1px solid #fff;
}
td {
	background-color: #eee;
}
td.commitId {
	background-color: #ccc;
	vertical-align: top;
	color: #666;
}
td.build.SUCCESS,
td.commitId.SUCCESS {
	background-color: #cfc;
}
td.build.FAILURE {
	background-color: #f99;
}
td.build.UNSTABLE {
	background-color: #fc9;
}
td.build.number {
	border-right: none;
}
td.build.date {
	border-left: none;
}
td {
	padding: 0 4px;
	font-family: monospace;
}
td.build.number,
td.commitId {
	padding-left: 8px;
}
td.build.date,
td.commitId {
	padding-right: 8px;
}
a {
	text-decoration: none;
}
td.commitId span:hover {
	color: #996;
}
td.commitId.SUCCESS span:hover {
	color: #090;
}
td.build a:hover {
	color: #00f;
	background-color: #eef;
}
td.unm-ios-it.appCommitId {
	xfont-weight: bold;
}
td.unm-ios-it {
	opacity: 0.2;
}
td.unm-ios-it.appCommitId,
td.unm-ios-it.empty {
	opacity: 1.0;
}
#div-dumpDate {
	font-family: Arial, Helvetica, sans-serif;
	font-size: small;
	color: #999;
	margin: 0 0 1.5em;
}
div.nav a {
	font-family: Arial, Helvetica, sans-serif;
	font-size: small;
	text-decoration: none;
}
</style>
</head>
<body>
<div class="body">

<div class="nav">
<a href="http://univmobile.vswip.com/">Jenkins — Intégration continue</a>
</div>

<h1>UnivMobile iOS — Intégration continue</h1>

<div id="div-dumpDate">
Dump at:
<xsl:value-of select="translate(substring(@date, 1, 19), 'T', ' ')"/>
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
	unm-ios: commits
	<span class="description">Code source Objective-C</span>
</th>
<th colspan="2" class="unm-ios_xcode">
	unm-ios_xcode
	<span class="description">Construction de l’archive .ipa</span>
</th>
<th colspan="2" class="unm-ios-ut">
	unm-ios-ut
	<span class="description">Tests unitaires XCTest</span>
</th>
<th colspan="2" class="unm-ios-it">
	unm-ios-it
	<span class="description">Test d’intégration JUnit + Appium</span>
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
	
<xsl:variable name="sizeOfBuilds-unm-ios_xcode"
	select="count($jenkinsBuilds-unm-ios_xcode)"/>
<xsl:variable name="sizeOfBuilds-unm-ios-ut"
	select="count($jenkinsBuilds-unm-ios-ut)"/>
<xsl:variable name="sizeOfBuilds-unm-ios-it"
	select="count($jenkinsBuilds-unm-ios-it)"/>
	
<xsl:variable name="rowCount">
<xsl:choose>
<xsl:when test="$sizeOfBuilds-unm-ios_xcode &gt;= $sizeOfBuilds-unm-ios-ut
		and $sizeOfBuilds-unm-ios_xcode &gt;= $sizeOfBuilds-unm-ios-it">
	<xsl:value-of select="$sizeOfBuilds-unm-ios_xcode"/>
</xsl:when>
<xsl:when test="$sizeOfBuilds-unm-ios-ut &gt;= $sizeOfBuilds-unm-ios_xcode
		and $sizeOfBuilds-unm-ios-ut &gt;= $sizeOfBuilds-unm-ios-it">
	<xsl:value-of select="$sizeOfBuilds-unm-ios-ut"/>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="$sizeOfBuilds-unm-ios-it"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<tr>
<td>
<xsl:attribute name="class">
	commitId
	<xsl:if test="$jenkinsBuilds-unm-ios_xcode/@result = 'SUCCESS'
		and $jenkinsBuilds-unm-ios-ut/@result = 'SUCCESS'
		and $jenkinsBuilds-unm-ios-it[@appCommitId]/@result = 'SUCCESS'">
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

<xsl:template name="td-build">
<xsl:param name="jenkinsBuilds"/>
<xsl:param name="jobName" select="'unm-ios_xcode'"/>
<xsl:param name="index" select="1"/>
<xsl:param name="rowCount" select="1"/>

<xsl:variable name="commitId" select="$jenkinsBuilds[1]
	[not(@appCommitId)]/@commitId | $jenkinsBuilds[1]/@appCommitId"/>

<xsl:variable name="jenkinsBuild" select="$jenkinsBuilds
	[../@name = $jobName
		and $index = 1 + count(preceding::build[
			../@name = $jobName and ((@commitId = $commitId
				and not(@appCommitId)) or @appCommitId = $commitId)])]"/>

<xsl:variable name="buildNumber" select="$jenkinsBuild/@number"/>

<xsl:variable name="href">
<xsl:choose>
<xsl:when test="$jenkinsBuild/@href">
	<xsl:value-of select="$jenkinsBuild/@href"/>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="concat(
		'http://univmobile.vswip.com/job/', $jobName, '/', $buildNumber, '/')"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:variable name="couldNotFindAppCommitId"
	select="$jobName = 'unm-ios-it' and not(@appCommitId)"/>
<xsl:variable name="couldNotFindAppCommitId-title"
	select="concat('(Could not find commit id in app’s Build Info,&#10;only in ',
		$jobName, ' Jenkins logs.)')"/>
	
<td>
<xsl:attribute name="class">
	build number
	<xsl:value-of select="concat($jobName, ' ', $jenkinsBuild/@result)"/>
	<xsl:if test="$index = 1"> first</xsl:if>
	<xsl:if test="$index = $rowCount"> last</xsl:if>
	<xsl:if test="$jenkinsBuild/@appCommitId"> appCommitId</xsl:if>
	<xsl:if test="not($jenkinsBuild)"> empty</xsl:if>
</xsl:attribute>
	
	<xsl:if test="$jenkinsBuild">
	
	<a href="{$href}">
	<xsl:if test="$couldNotFindAppCommitId">
	<xsl:attribute name="title">
		<xsl:value-of select="$couldNotFindAppCommitId-title"/>
	</xsl:attribute>
	</xsl:if>
	<!--  
	<xsl:value-of select="$jenkinsBuild/../@name"/>:
	-->
	Build #<xsl:value-of select="$buildNumber"/>
	</a>
	
	</xsl:if>

</td>

<td>
<xsl:attribute name="class">
	build date
	<xsl:value-of select="concat($jobName, ' ', $jenkinsBuild/@result)"/>
	<xsl:if test="$index = 1"> first</xsl:if>
	<xsl:if test="$index = $rowCount"> last</xsl:if>
	<xsl:if test="$jenkinsBuild/@appCommitId"> appCommitId</xsl:if>
	<xsl:if test="not($jenkinsBuild)"> empty</xsl:if>
</xsl:attribute>
	
	<xsl:if test="$jenkinsBuild">
	
	<!--  
	<xsl:value-of select="$jenkinsBuild/../@name"/>:
	-->
	<a href="{$href}">
	<xsl:if test="$couldNotFindAppCommitId">
	<xsl:attribute name="title">
		<xsl:value-of select="$couldNotFindAppCommitId-title"/>
	</xsl:attribute>
	</xsl:if>
	<xsl:value-of select="$jenkinsBuild/@id"/>
	</a>
	
	</xsl:if>

</td>

</xsl:template>


</xsl:stylesheet>
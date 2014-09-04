<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="style-css">
<style type="text/css">
h1 {
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
td.unm-ios-it.appCommitId,
td.unm-ios-it_ios6.appCommitId {

}
td.unm-ios-it,
td.unm-ios-it_ios6,
td.unm-android-it,
td.unm-backend-it,
td.unm-backend-it_macos,
td.unm-mobileweb-it_ios7,
td.unm-mobileweb-it_ios6 {
	opacity: 0.2;
}
td.unm-ios-it.appCommitId,
td.unm-ios-it_ios6.appCommitId,
td.unm-ios-it.empty,
td.unm-ios-it_ios6.empty,
td.unm-android-it.appCommitId,
td.unm-android-it.empty,
td.unm-backend-it.appCommitId,
td.unm-backend-it_macos.appCommitId,
td.unm-backend-it.empty,
td.unm-backend-it_macos.empty,
td.unm-mobileweb-it_ios7.appCommitId,
td.unm-mobileweb-it_ios6.appCommitId,
td.unm-mobileweb-it_ios7.empty,
td.unm-mobileweb-it_ios6.empty {
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
div.nav {
	display: inline;
	margin-right: 2em;
}
</style>
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
	select="($jobName = 'unm-ios-it'
			or $jobName = 'unm-ios-it_ios6'
			or $jobName = 'unm-android-it'
			or $jobName = 'unm-mobileweb-it_ios6'
			or $jobName = 'unm-mobileweb-it_ios7')
		and not($jenkinsBuild/@appCommitId)"/>
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
	<xsl:call-template name="format-date">
	<xsl:with-param name="date" select="$jenkinsBuild/@id"/>
	</xsl:call-template>
	</a>
	
	</xsl:if>

</td>

</xsl:template>

<xsl:template name="format-date">
<xsl:param name="date" select="'YYYY-MM-DD HH:mm:ss'"/>

<xsl:value-of select="concat(substring($date, 1, 4),
	'-', substring($date, 6, 2), '-', substring($date, 9, 2),
	' ', substring($date, 12, 2), ':', substring($date, 15, 2),
	':', substring($date, 18, 2))"/>
	
</xsl:template>

</xsl:stylesheet>
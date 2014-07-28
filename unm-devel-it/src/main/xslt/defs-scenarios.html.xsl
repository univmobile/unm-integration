<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="appCommitId"/>

<xsl:template name="html-head">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Content-Language" content="fr"/>
<title>UnivMobile iOS — Scénarios</title>
<style type="text/css">
body {
	position: relative;
}
h1,
h2,
h3 {
	font-family: Arial, Helvetica, sans-serif;
}
h1 {
	margin-top: 0.2em;
	margin-bottom: 0;
}
#div-detail {
	position: fixed;
	top: 8px;
	right: 8px;
	width: 640px;
	height: 1136px;
	text-align: right;
}
div.device {
	position: relative;
	width: 80px;
	height: 164px;
}
div.device img.screenshot {
	width: 64px;
	height: 113.6px;
	position: absolute;
	top: 25px;
	left: 8px;
}
div.device.smaller img.screenshot {
	width: 32px;
	height: 56.8px;
}
div.device div.iPod {
	position: absolute;
	top: 2px;
	left: 2px;
	xbackground-image: url('img/iPod_touch_Vert_Blu_sRGB.png');
	background-image: url('http://univmobile.vswip.com/nexus/content/sites/pub/unm-ios/0.0.1-SNAPSHOT/img/iPod_touch_Vert_Blu_sRGB.png');
	background-size: 91px 175px;
	background-repeat: no-repeat;
	background-position: -8px -8px;
	width: 76px;
	height: 160px;
}
table {
	border-collapse: collapse;
	border: none;
}
div.scenario table td {
	vertical-align: top;
}
div.step,
div.transition {
	display: inline-block;
}
div.shortLabel {
	text-align: center;
	font-family: Arial, Helvetica, sans-serif;
	font-size: small;
}
div.transition div.shortLabel {
	font-style: italic;
}
div.transition {
	opacity: 0.3;
	margin: 0 0 0 1em;
}
div.arrow.dimmed {
	opacity: 0.0;
}
div.arrow {
	display: inline-block;
	margin: 0;
	position: relative;
	top: -90px;
}
#div-detail table {
	border-collapse: collapse;
	position: absolute;
	right: 0;
}
#div-detail table td {
	padding-left: 2em;
	padding-bottom: 1.2em;
}
#div-detail .screen_4_inch img {
	width: 192px;
	height: 340.8px;
}
#div-detail .screen_3_5_inch img {
	width: 192px;
	height: 288px;
}
#div-detail div.label {
	background-color: #000;
	color: #fff;
	display: inline-block;
	padding: 0px 3px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: x-small;
	border: 1px solid #000;
}
#div-detail div.img {
	background-color: #ccc;
	border: 1px solid #000;
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
#div-toc {
	font-family: Arial, Helvetica, sans-serif;
	background-color: #eee;
	padding: 0.4em 1em;
	display: table;
}
#div-toc a {
	text-decoration: none;
}
#div-toc h2,
#div-toc h3 {
	margin-top: 0;
	margin-bottom: 0.4em;
}
#div-toc ul.scenarioMethods {
	margin-top: 0.4em;
	margin-bottom: 0;
	font-size: small;
}
#div-toc div.scenariosClasses {
	margin-bottom: 0;
}
#div-appCommitId {
	font-family: Arial, Helvetica, sans-serif;
	font-size: small;
	color: #999;
	margin: 0 0 1.5em;
}
#div-appCommitId a {
	text-decoration: none;
}
div.scenariosClass div.label {
	font-family: Arial, Helvetica, sans-serif;
	font-size: small;
	font-style: italic;
	margin-top: 0.4em;
	margin-bottom: 1.2em;
}
div.scenariosClass h2 {
	margin-bottom: 0.2em;
}
div.scenariosClass h3 {
	margin-bottom: 0.6em;
}
div.scenariosClass h3 {
	border-top: 1px dashed #000;
	padding-top: 1em;
}
#div-detail-menu {
	position: fixed;
	top: 8px;
	right: 462px;
	xbackground-color: #ff0;
	xwidth: 400px;
	xheight: 100px;
}
#div-detail-menu div.detail-menu {
	margin-left: 40px;
	xwidth: 50px;
	xheight: 80px;
	xbackground-color: #090;
	display: inline-block;
	position: relative;
}
#div-detail-menu table {
	border-collapse: separate;
	border: 1px solid transparent;
}
#div-detail-menu div.detail-menu.selected table {
	border: 1px solid #000;
}
#div-detail #div-detail-menu td {
	border-spacing: 4px;
	padding: 0;
	margin: 0;
}
#div-detail #div-detail-menu td div {
	width: 12.8px;
	background-color: #ddd;
	color: #fff;
	padding: 0;
	margin: 0;
	vertical-align: middle;
	display: table;
	text-align: center;
	font-family: Arial, Helvetica, sans-serif;
	font-size: x-small;	
}
#div-detail #div-detail-menu td.screen_4_inch div {
	height: 25px;
}
#div-detail #div-detail-menu td.screen_3_5_inch div {
	height: 14px;
}
#div-detail #div-detail-menu div.detail-menu.top td {
	vertical-align: top;
}
#div-detail #div-detail-menu div.detail-menu.middle td {
	vertical-align: middle;
}
#div-detail #div-detail-menu div.detail-menu.bottom td {
	vertical-align: bottom;
}
table.table-detail {
	display: none;
}
table.table-detail.selected {
	display: table;
}
table.table-detail.top td {
	vertical-align: top;
}
table.table-detail.middle td {
	vertical-align: middle;
}
table.table-detail.bottom td {
	vertical-align: bottom;
}
</style>
<script language="javascript">

var buildNumber_ios7 = <xsl:value-of
	select="/*/scenarios[not(contains(@jobName, '-it_ios6'))]/@buildNumber"/>;
	
var buildNumber_ios6 = <xsl:value-of
	select="/*/scenarios[contains(@jobName, '-it_ios6')]/@buildNumber"/>;

<xsl:variable name="jobName_ios7">
	<xsl:choose>
	<xsl:when test="/*/scenarios/@jobName = 'unm-ios-it_ios6'">unm-ios-it</xsl:when>
	<xsl:when test="/*/scenarios/@jobName = 'unm-ios-it_ios6_release'">unm-ios-it</xsl:when>
	<xsl:otherwise>unm-mobileweb-it_ios7</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="contains(/*/scenarios/@jobName, '_release')">_release</xsl:if>
</xsl:variable>

<xsl:variable name="jobName_ios6">
	<xsl:choose>
	<xsl:when test="/*/scenarios/@jobName = 'unm-ios-it_ios6'">unm-ios-it_ios6</xsl:when>
	<xsl:when test="/*/scenarios/@jobName = 'unm-ios-it_ios6_release'">unm-ios-it_ios6</xsl:when>
	<xsl:otherwise>unm-mobileweb-it_ios6</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="contains(/*/scenarios/@jobName, '_release')">_release</xsl:if>
</xsl:variable>

<xsl:variable name="mavenProject">
	<xsl:choose>
	<xsl:when test="/*/scenarios/@jobName = 'unm-ios-it_ios6'">unm-ios-it</xsl:when>
	<xsl:when test="/*/scenarios/@jobName = 'unm-ios-it_ios6_release'">unm-ios-it</xsl:when>
	<xsl:otherwise>unm-mobileweb-it</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

function displayDetail(scenariosClassSimpleName, scenarioMethodName, filename) {
	
	var imgs = document.getElementsByClassName('img-detail-iOS7-4inch');
	for (var i = 0; i &lt; imgs.length; ++i) imgs[i].src =
		'http://univmobile.vswip.com/job/<xsl:value-of
			select="$jobName_ios7"/>/' + buildNumber_ios7
		+ '/artifact/<xsl:value-of
			select="$mavenProject"/>/target/screenshots/iOS_7.1/iPhone_Retina_4-inch/'
		+ scenariosClassSimpleName + '/' + scenarioMethodName + '/' + filename;
	
	var imgs = document.getElementsByClassName('img-detail-iOS6-4inch');
	for (var i = 0; i &lt; imgs.length; ++i) imgs[i].src =
		'http://univmobile.vswip.com/job/<xsl:value-of
			select="$jobName_ios6"/>/' + buildNumber_ios6
		+ '/artifact/<xsl:value-of
			select="$mavenProject"/>/target/screenshots/iOS_6.1/iPhone_Retina_4-inch/'
		+ scenariosClassSimpleName + '/' + scenarioMethodName + '/' + filename;

	var imgs = document.getElementsByClassName('img-detail-iOS7-3_5inch');
	for (var i = 0; i &lt; imgs.length; ++i) imgs[i].src =
		'http://univmobile.vswip.com/job/<xsl:value-of
			select="$jobName_ios7"/>/' + buildNumber_ios7
		+ '/artifact/<xsl:value-of
			select="$mavenProject"/>/target/screenshots/iOS_7.1/iPhone_Retina_3.5-inch/'
		+ scenariosClassSimpleName + '/' + scenarioMethodName + '/' + filename;

	var imgs = document.getElementsByClassName('img-detail-iOS6-3_5inch');
	for (var i = 0; i &lt; imgs.length; ++i) imgs[i].src =
		'http://univmobile.vswip.com/job/<xsl:value-of
			select="$jobName_ios6"/>/' + buildNumber_ios6
		+ '/artifact/<xsl:value-of
			select="$mavenProject"/>/target/screenshots/iOS_6.1/iPhone_Retina_3.5-inch/'
		+ scenariosClassSimpleName + '/' + scenarioMethodName + '/' + filename;
}

function selectDetailMenu(item) {

	var menus = document.getElementsByClassName('detail-menu');
	var tables  = document.getElementsByClassName('table-detail');
	
	for (var i = 0; i &lt; menus.length; ++i) {

		var menu = menus[i];
		
		if (menu.className.indexOf(item) == -1) {
			if (menu.className.indexOf('selected') != -1) {
				menu.className = menu.className.replace(/\sselected/, '');
			}
		} else {
			if (menu.className.indexOf('selected') == -1) {
				menu.className += ' selected';
			}
		} 
		
		var table = tables[i];
		
		if (table.className.indexOf(item) == -1) {
			if (table.className.indexOf('selected') != -1) {
				table.className = table.className.replace(/\sselected/, '');
			}
		} else {
			if (table.className.indexOf('selected') == -1) {
				table.className += ' selected';
			}
		} 
	}
}

window.onload = function() {

	displayDetail('Scenarios001', 'sc001', 'home.png');
};

</script>
</head>
</xsl:template>

<!-- 
<body>

<div id="div-detail">
<table>
<tr>
<td class="iOS7 screen_4_inch">
<div class="label">
	Retina 4-inch iOS 7.0
</div>
<div class="img">
	<img id="img-detail-iOS7-4inch" src="img/blank.png"/>	
</div>
</td>
<td class="iOS6 screen_4_inch">
<div class="label">
	Retina 4-inch iOS 6.1
</div>
<div class="img">
	<img id="img-detail-iOS6-4inch" src="img/blank.png"/>	
</div>
</td>
</tr>
<tr>
<td class="iOS7 screen_3_5_inch">
<div class="label">
	Retina 3.5-inch iOS 7.0
</div>
<div class="img">
	<img id="img-detail-iOS7-3_5inch" src="img/blank.png"/>	
</div>
</td>
<td class="iOS6 screen_3_5_inch">
<div class="label">
	Retina 3.5-inch iOS 6.1
</div>
<div class="img">
	<img id="img-detail-iOS6-3_5inch" src="img/blank.png"/>	
</div>
</td>
</tr>
</table>
<img id="img-detail" src="img/blank.png"/>
</div>

<div class="nav">
<a href="index.html">Back to the Maven Generated Site</a>
</div>

<h1>UnivMobile iOS — Scénarios</h1>
<div id="div-scenarios">
<xsl:for-each select="scenario">

<h2>
	<xsl:value-of select="@id"/>.
	<xsl:value-of select="@title"/>
</h2>

<div class="scenario">
<table>
<tbody>
<tr>
<td>
<div class="begin step">

<xsl:for-each select="begin">

	<xsl:call-template name="device">
		<xsl:with-param name="screenshot" select="@screenshot"/>
	</xsl:call-template>

	<xsl:call-template name="shortLabel"/>

</xsl:for-each>

</div>
</td>
<td>

<xsl:for-each select="next">

<xsl:if test="@transitionScreenshot or @transitionLabel">
	
	<div class="arrow">→</div>
	
	<div class="transition">
	
	<xsl:if test="@transitionScreenshot">
		<xsl:call-template name="device">
			<xsl:with-param name="screenshot" select="@transitionScreenshot"/>
		</xsl:call-template>
	</xsl:if>

	<xsl:call-template name="shortLabel">
		<xsl:with-param name="shortLabel" select="@transitionShortLabel"/>
	</xsl:call-template>
	
	</div>
</xsl:if>

<div class="arrow">…</div>

<div class="step">

	<xsl:call-template name="device">
		<xsl:with-param name="screenshot" select="@screenshot"/>
	</xsl:call-template>

	<xsl:call-template name="shortLabel"/>

</div>

</xsl:for-each>

</td>
</tr>
</tbody>
</table>

</div>

</xsl:for-each>

</div>

</body>
</html>
</xsl:template>

<xsl:template name="device">
<xsl:param name="screenshot" select="'001.png'"/>

<div class="device" onclick="displayDetail('{$screenshot}');">
	<img class="screenshot" src="img/iOS_7.0/Retina_4-inch/{$screenshot}"/>
	<div class="iPod"/>
</div>

</xsl:template>

<xsl:template name="shortLabel">
<xsl:param name="shortLabel" select="@shortLabel"/>

<xsl:if test="$shortLabel">
<div class="shortLabel">
	<xsl:choose>
	<xsl:when test="name($shortLabel) = 'transitionShortLabel'">
		(<xsl:value-of select="$shortLabel"/>)
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$shortLabel"/>
	</xsl:otherwise>
	</xsl:choose>
</div>
</xsl:if>

</xsl:template>

-->
 
</xsl:stylesheet>
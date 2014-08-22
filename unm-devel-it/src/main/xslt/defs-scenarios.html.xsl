<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="appCommitId"/>

<xsl:template name="html-head">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Content-Language" content="fr"/>
<title>UnivMobile 
	<xsl:choose>
	<xsl:when test="//scenarios[contains(@jobName, 'unm-ios-it')]">
		iOS
	</xsl:when>
	<xsl:when test="//scenarios[contains(@jobName, 'unm-mobileweb-it')]">
		mobile web
	</xsl:when>
	<xsl:when test="//scenarios[contains(@jobName, 'unm-android-it')]">
		Android
	</xsl:when>
	<xsl:when test="//scenarios[contains(@jobName, 'unm-backend-it')]">
		backend
	</xsl:when>
	</xsl:choose>
— Scénarios</title>
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
div.detailBottom {
	xbackground-color: #ff0;
	xdisplay: inline;
	xdisplay: none;
}
div.detailBottom {
	width: 40px;
	xbackground-color: #ff0;
	white-space: nowrap;
	overflow: visible;
}
div.detailBottom h3 {
	white-space: nowrap;
	overflow: visible;
	margin: 0 0 8px;
	font-weight: normal;
	font-size: small;
}
div.detailBottom h3 a {
	color: #000;
}
div.detailBottom span {
	font-size: small;
}
div.detailBottom a {
	text-decoration: none;
	color: #009;
	font-family: Arial, Helvetica, sans-serif;
}
div.device {
	position: relative;
	width: 80px;
	height: 164px;
}
#body-backend div.device {
	position: relative;
	width: 126px;
	height: 100px;
}
div.device img.screenshot {
	width: 64px;
	position: absolute;
	top: 25px;
	left: 8px;
}
div.device.iPod img.screenshot {
	height: 113.6px;
}
div.device.Android img.screenshot {
	height: 106.7px;
}
div.device.backend img.screenshot {
	width: 110px;
	border: 1px solid transparent;
}
div.device.smaller img.screenshot {
	width: 32px;
	height: 56.8px;
}
div.device.iPod div {
	position: absolute;
	top: 2px;
	left: 2px;
	background-image: url('http://univmobile.vswip.com/nexus/content/sites/pub/unm-devel-it/0.0.4-SNAPSHOT/img/iPod_touch_Vert_Blu_sRGB.png');
	background-size: 91px 175px;
	background-repeat: no-repeat;
	background-position: -8px -8px;
	width: 76px;
	height: 160px;
}
div.device.Android div {
	position: absolute;
	top: 2px;
	left: 2px;
	background-image: url('http://univmobile.vswip.com/nexus/content/sites/pub/unm-devel-it/0.0.4-SNAPSHOT/img/red480x800.png');
	background-size: 99px 173px;
	background-repeat: no-repeat;
	background-position: -11.5px -9px;
	width: 76px;
	height: 160px;
}
div.device.backend div {
	position: absolute;
	top: 5px;
	left: 4.5px;
	xbackground-image: url('../src/site/img/firefox-window-1024x574.png');
	background-image: url('http://univmobile.vswip.com/nexus/content/sites/pub/unm-devel-it/0.0.4-SNAPSHOT/img/firefox-window-1024x574.png');
	background-size: 121px 81px;
	background-repeat: no-repeat;
	background-position: -1px 10px;
	width: 120px;
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
#body-backend div.arrow {
	top: -50px;
	margin-right: -11px;
}
#xbody-backend div.arrow,
#body-backend div.transition {
	display: none;
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
#div-detail .screen_480x800 img {
	width: 192px;
	height: 320px;
}
#div-detail .screen_1280 div.img {
	width: 320px;
	height: 219px;
	overflow: scroll;
}
#div-detail .screen_1024 div.img {
	width: 320px;
	height: 179px;
	overflow: scroll;
}
#div-detail .screen_1280 img {
	width: 320px;
	xheight: 219px;
	background-color: #ff0;
}
#div-detail .screen_1024 img {
	width: 320px;
	xheight: 179px;
	background-color: #f00;
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
	xborder-top: 1px dashed #000;
	padding-top: 1em;
}
#div-detail-menu {
	position: fixed;
	top: 8px;
	right: 462px;
}
#div-detail-menu div.detail-menu {
	margin-left: 40px;
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
div.shortLabel span {
	padding: 0 4px;
}
div.shortLabel.selected span,
div.detailBottom span a {
	background-color: #eee;
	border-bottom: 1px solid #ddd;
}
#div-scenarios {
	xbackground-color: #ff0;
}
#table-scenarios {
	width: 100%;
	border-collapse: collapse;
}
#table-scenarios td.filler {
	width: 420px;
}
div.scenario div.summary {
	background-color: #eee;
	border-bottom: 1px solid #999;
	border-right: 1px solid #ccc;
	float: left;
	padding: 4px 8px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: small;
	margin-right: 1em;
}
div.scenario div.summary ol {
	margin: 0;
	padding: 0 0 0 1.6em;
}
div.scenario div.summary li.action {
	color: #bbb;
	font-style: italic;
	list-style-type: none;
}
div.scenario div.summary li.action.number {
	list-style-type: decimal;
}
div.div-shortLabel span span.filename {
	display: none;
}
div.device.backend span.layout {
	display: block;
	background-color: #ff0;
	xborder: 1px solid #f00;
	width: 110px;
	height: 70px;
	overflow: hidden;
	position: absolute;
	top: 25px;
	left: 8px;
}
div.device.backend img.screenshot {
	xwidth: 64px;
	position: relative;
	top: 0;
	left: 0;
}
#body-backend table-detail div.img {
	xoverflow: hidden;
}
span.scenariosDate {
	color: #000;
}
</style>
<script language="javascript">

<xsl:variable name="ios" select="/*/scenarios[contains(@jobName, '_ios6')]"/>
<xsl:variable name="android" select="/*/scenarios[contains(@jobName, '-android')]"/>

<xsl:choose>
<xsl:when test="$ios">

var buildNumber_ios7 = <xsl:value-of
	select="/*/scenarios[not(contains(@jobName, '-it_ios6'))]/@buildNumber"/>;
	
var buildNumber_ios6 = <xsl:value-of
	select="/*/scenarios[contains(@jobName, '-it_ios6')]/@buildNumber"/>;

</xsl:when>
<xsl:when test="$android">

var buildNumber_android = <xsl:value-of
	select="/*/scenarios[contains(@jobName, 'unm-android-it')]/@buildNumber"/>;

</xsl:when>	
<xsl:otherwise>

var buildNumber_backend_Debian = <xsl:value-of
	select="/*/scenarios[not(contains(@jobName, 'unm-backend-it_macos'))]/@buildNumber"/>;
var buildNumber_backend_MacOS = <xsl:value-of
	select="/*/scenarios[contains(@jobName, 'unm-backend-it_macos')]/@buildNumber"/>;

</xsl:otherwise>	
</xsl:choose>

<xsl:variable name="jobName_ios7">
	<xsl:choose>
	<xsl:when test="/*/scenarios[contains(@jobName, 'unm-ios-it_ios6')]">unm-ios-it</xsl:when>
	<xsl:when test="/*/scenarios[contains(@jobName, 'unm-mobileweb-it_ios6')]">unm-mobileweb-it_ios7</xsl:when>
	<xsl:when test="$android">unm-android-it</xsl:when>
	<xsl:otherwise>unm-backend-it_macos</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="contains(/*/scenarios/@jobName, '_release')">_release</xsl:if>
</xsl:variable>

<xsl:variable name="jobName_ios6">
	<xsl:choose>
	<xsl:when test="/*/scenarios[contains(@jobName, 'unm-ios-it_ios6')]">unm-ios-it_ios6</xsl:when>
	<xsl:when test="/*/scenarios[contains(@jobName, 'unm-mobileweb-it_ios6')]">unm-mobileweb-it_ios6</xsl:when>
	<xsl:when test="$android">unm-android-it</xsl:when>
	<xsl:otherwise>unm-backend-it</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="contains(/*/scenarios/@jobName, '_release')">_release</xsl:if>
</xsl:variable>

<xsl:variable name="mavenProject">
	<xsl:choose>
	<xsl:when test="/*/scenarios[contains(@jobName, 'unm-ios-it_ios6')]">unm-ios-it</xsl:when>
	<xsl:when test="/*/scenarios[contains(@jobName, 'unm-mobileweb-it_ios6')]">unm-mobileweb-it</xsl:when>
	<xsl:when test="$android">unm-android-it</xsl:when>
	<xsl:otherwise>unm-backend-it</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

function displayDetail(
	scenariosClassSimpleName, scenarioMethodName, filename, index
) {

selectShortLabel(scenariosClassSimpleName + '.' + scenarioMethodName + '.' + index);
	
<xsl:choose>
<xsl:when test="$ios">

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

</xsl:when>
<xsl:when test="$android">

	var imgs = document.getElementsByClassName('img-detail-Android-480x800');
	for (var i = 0; i &lt; imgs.length; ++i) imgs[i].src =
		'http://univmobile.vswip.com/job/<xsl:value-of
			select="$jobName_ios6"/>/' + buildNumber_android
		+ '/artifact/<xsl:value-of
			select="$mavenProject"/>/target/screenshots/Android_XXX/Android_Emulator/'
		+ scenariosClassSimpleName + '/' + scenarioMethodName + '/' + filename;

</xsl:when>
<xsl:otherwise>

	var imgs = document.getElementsByClassName('img-detail-backend-Debian');
	for (var i = 0; i &lt; imgs.length; ++i) imgs[i].src =
		'http://univmobile.vswip.com/job/<xsl:value-of
			select="$jobName_ios6"/>/' + buildNumber_backend_Debian
		+ '/artifact/<xsl:value-of
			select="$mavenProject"/>/target/screenshots/Debian_3.2.0-4-amd64/Firefox/'
		+ scenariosClassSimpleName + '/' + scenarioMethodName + '/' + filename;

	var imgs = document.getElementsByClassName('img-detail-backend-MacOS');
	for (var i = 0; i &lt; imgs.length; ++i) imgs[i].src =
		'http://univmobile.vswip.com/job/<xsl:value-of
			select="$jobName_ios7"/>/' + buildNumber_backend_MacOS
		+ '/artifact/<xsl:value-of
			select="$mavenProject"/>/target/screenshots/Mac_OS_X_10.8.5/Firefox/'
		+ scenariosClassSimpleName + '/' + scenarioMethodName + '/' + filename;
			
</xsl:otherwise>
</xsl:choose>
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

function selectShortLabel(id) {

	var divs = document.getElementsByClassName('div-shortLabel');
	
	var selectedDiv = null;
	
	for (var i = 0; i &lt; divs.length; ++i) {
	
		var div = divs[i];
		
		if (div.id != 'div-shortLabel-' + id) {
			if (div.className.indexOf('selected') != -1) {
				div.className = div.className.replace(/\sselected/, '');
			}
		} else {
			if (div.className.indexOf('selected') == -1) {
				div.className += ' selected';
			}
			selectedDiv = div;
		} 
	}
	
	var h3 = null;
	
	if (selectedDiv != null) {
		
		var scenarioMethodDiv = null;
		
		for (var p = selectedDiv.parentNode; p != null; p = p.parentNode) {
		
			if (p.className == 'scenarioMethod') {
				h3 = p.getElementsByTagName('h3')[0];
				break;
			}
		}
	}
	
	var detailBottoms = document.getElementsByClassName('detailBottom');
	
	for (var i = 0; i &lt; detailBottoms.length; ++i) {
	
		var detailBottom = detailBottoms[i];
	
		if (selectedDiv == null) {
			detailBottom.innerHTML = '';
		} else {
			var shortLabel = selectedDiv.innerHTML;
			// selectedDiv.get
			detailBottom.innerHTML =
				'&lt;h3&gt;&lt;a href="#a-div-shortLabel-' + id + '"&gt;'
					+ h3.innerHTML.replace('\n', ' ') + '&lt;/a&gt;&lt;/h3&gt;'
				+ '&lt;span&gt;&lt;a href="#a-div-shortLabel-' + id + '"&gt;'
					+ shortLabel + '&lt;/a&gt;&lt;/span&gt;';
		}
	}
}

window.onload = function() {

	<xsl:variable name="firstScenariosClass" select="//scenariosClass[1]"/>
	<xsl:variable name="firstScenarioMethod" select="$firstScenariosClass/scenarioMethod[1]"/>
	<xsl:variable name="firstScreenshot" select="$firstScenarioMethod//screenshot[1]"/>
		
	displayDetail(
		'<xsl:value-of select="$firstScenariosClass/@classSimpleName"/>',
		'<xsl:value-of select="$firstScenarioMethod/@methodName"/>',
		'<xsl:value-of select="$firstScreenshot/@filename"/>', 1
	);
};

</script>
</head>
</xsl:template>
 
<xsl:template name="scenariosDate">
<xsl:for-each select="//scenario/@date">
<xsl:sort select="." order="descending"/>

<xsl:if test="position() = 1">
<span class="scenariosDate">
	<xsl:value-of select="translate(substring(., 1, 19), 'T', ' ')"/>
	—
</span>
</xsl:if>

</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
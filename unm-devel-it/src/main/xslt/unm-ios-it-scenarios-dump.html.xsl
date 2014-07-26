<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="defs-it-scenarios-dump.html.xsl"/>
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:template match="/unm-ios-it-scenarios-dump">
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
<a href="http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-ci-dump.html">
UnivMobile iOS — Intégration continue
</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/ios/">UnivMobile iOS — Installations ad hoc</a>
</div>

<h1>UnivMobile iOS — Scénarios</h1>

<xsl:variable name="buildNumber_ios7"
	select="/*/scenarios[@jobName = 'unm-ios-it']/@buildNumber"/>
<xsl:variable name="buildNumber_ios6"
	select="/*/scenarios[@jobName = 'unm-ios-it_ios6']/@buildNumber"/>

<div id="div-appCommitId">
appCommitId:
<xsl:value-of select="/*/scenarios/@appCommitId"/>;
<a href="http://univmobile.vswip.com/job/unm-ios-it/">unm-ios-it</a>:
	<a href="http://univmobile.vswip.com/job/unm-ios-it/{$buildNumber_ios7}">Build
	#<xsl:value-of select="$buildNumber_ios7"/></a>;
<a href="http://univmobile.vswip.com/job/unm-ios-it_ios6/">unm-ios-it_ios6</a>:
	<a href="http://univmobile.vswip.com/job/unm-ios-it_ios6/{$buildNumber_ios6}">Build
	#<xsl:value-of select="$buildNumber_ios6"/></a>;
	
</div>

<xsl:variable name="scenariosClasses" select="scenarios[1]/scenariosClass"/>
<!-- 
	[not(@className = preceding::scenariosClass/@className)]"/>
-->

<xsl:variable name="scenarioMethods"
	select="$scenariosClasses/scenarioMethod
		[not(@methodFullName = preceding::scenarioMethod/@methodFullName)]"/>

<div id="div-toc">
<h3>
Table des matières
</h3>
<div div="div-scenariosClasses">
<xsl:for-each select="$scenariosClasses">
<xsl:variable name="className" select="@className"/>
<div class="scenariosClass">
	<a>
	<xsl:attribute name="href">
	<xsl:text>#</xsl:text>
	<xsl:call-template name="anchorId"/>
	</xsl:attribute>
	<xsl:value-of select="@classSimpleName"/> —
	<xsl:value-of select="@scenariosLabel"/>
	</a>
<ul class="scenarioMethods">
<xsl:for-each select="$scenarioMethods[../@className = $className]">
<li class="scenarioMethod">
	<a>
	<xsl:attribute name="href">
	<xsl:text>#</xsl:text>
	<xsl:call-template name="anchorId"/>
	</xsl:attribute>
	<xsl:value-of select="@methodName"/> —
	<xsl:value-of select="@scenarioLabel"/>
	</a>
</li>
</xsl:for-each>
</ul>
</div>
</xsl:for-each>
</div>
</div>

<div id="div-scenarios">

<xsl:for-each select="$scenariosClasses">
<xsl:variable name="className" select="@className"/>

<xsl:variable name="scenariosAnchorId">
	<xsl:call-template name="anchorId"/>
</xsl:variable>

<div class="scenariosClass">
<a name="{$scenariosAnchorId}" id="{$scenariosAnchorId}">
<h2>
	<xsl:value-of select="@classSimpleName"/> —
	<xsl:value-of select="@scenariosLabel"/>
</h2>
</a>

<!--  
<div class="scenariosClass label">
<xsl:value-of select="@scenariosLabel"/>
</div>
-->

<xsl:for-each select="$scenarioMethods[../@className = $className]">

<xsl:variable name="scenarioAnchorId">
	<xsl:call-template name="anchorId"/>
</xsl:variable>

<div class="scenarioMethod">
<a name="{$scenarioAnchorId}" id="{$scenarioAnchorId}">
<h3>
	<xsl:value-of select="@methodName"/> —
	<xsl:value-of select="@scenarioLabel"/>
</h3>
</a>

<!--  
<div class="scenarioMethod label">
<xsl:value-of select="@scenarioLabel"/>
</div>
-->

<div class="scenario">
<table>
<tbody>
<tr>
<td>
<div class="begin step">

<xsl:for-each select="scenario[1]/screenshot[1]">

	<xsl:call-template name="device"/>

	<xsl:call-template name="shortLabel">
		<xsl:with-param name="shortLabel" select="@filename"/>
	</xsl:call-template>

</xsl:for-each>

</div>
</td>
<td>

<xsl:for-each select="scenario[1]/screenshot[not(position() = 1)]">

<xsl:choose>
<xsl:when test="@ms">
	
	<div class="arrow">→</div>
	
	<div class="transition">
	
	<xsl:call-template name="device"/>

	<xsl:variable name="followingScreenshotCount"
		select="count(following-sibling::screenshot)"/>
	<xsl:variable name="followingActions" select="following-sibling::action
		[count(following-sibling::screenshot) = $followingScreenshotCount]"/>

	<xsl:call-template name="shortLabel-fromActions">
		<xsl:with-param name="actions" select="$followingActions"/>
	</xsl:call-template>
	
	</div>

</xsl:when>
<xsl:otherwise>

	<xsl:variable name="precedingScreenshotCount"
		select="count(preceding-sibling::screenshot)"/>
	<xsl:variable name="precedingActions" select="preceding-sibling::action
		[count(preceding-sibling::screenshot) = $precedingScreenshotCount]"/>

	<xsl:choose>
	<xsl:when test="not(preceding-sibling::screenshot[@ms and
		count(preceding-sibling::screenshot) + 1 = $precedingScreenshotCount])">
	
	<div class="arrow">→</div>
	<!--  
	<div class="arrow">&#160;</div>
	-->
	
	<div class="transition">
	
	<xsl:call-template name="shortLabel-fromActions">
		<xsl:with-param name="actions" select="$precedingActions"/>
	</xsl:call-template>
	
	</div>

	<div class="arrow dimmed">→</div>
	<!--  
	<div class="arrow">&#160;</div>
	-->
	
	</xsl:when>
	<xsl:otherwise>
	
		<div class="arrow">…</div>
	
	</xsl:otherwise>
	</xsl:choose>	
	
	<div class="step">

	<xsl:call-template name="device"/>

	<xsl:call-template name="shortLabel">
		<xsl:with-param name="shortLabel" select="@filename"/>
	</xsl:call-template>
	
	</div>

</xsl:otherwise>
</xsl:choose>

</xsl:for-each>

</td>
</tr>
</tbody>
</table>

</div>
</div>

</xsl:for-each>

</div>

</xsl:for-each>

</div>

</body>
</html>
</xsl:template>

<xsl:template name="anchorId">
	<xsl:value-of select="ancestor-or-self::scenariosClass/@classSimpleName"/>
	<xsl:if test="self::scenarioMethod">
		<xsl:value-of select="concat('.', @classSimpleName)"/>
	</xsl:if>
</xsl:template>

<xsl:template name="device">
<xsl:param name="screenshot" select="self::screenshot"/>

<xsl:variable name="scenariosClassSimpleName"
	select="parent::scenario/parent::scenarioMethod/parent::scenariosClass/@classSimpleName"/>
<xsl:variable name="scenarioMethodName"
	select="parent::scenario/@scenarioMethod"/>
	
<xsl:variable name="buildNumber_ios7"
	select="/*/scenarios[@jobName = 'unm-ios-it']/@buildNumber"/>
<xsl:variable name="buildNumber_ios6"
	select="/*/scenarios[@jobName = 'unm-ios-it_ios6']/@buildNumber"/>
<!--  
<xsl:variable name="buildNumber_ios7"
	select="/*/scenarios[@iosLabel = 'iOS7']/@buildNumber"/>
<xsl:variable name="buildNumber_ios6"
	select="/*/scenarios[@iosLabel = 'iOS6']/@buildNumber"/>
-->

<div class="device" onclick="displayDetail(
			'{$scenariosClassSimpleName}', '{$scenarioMethodName}',
			'{@filename}');"		
		xtitle="{@filename}">
	<img class="screenshot" src="{concat(
			'http://univmobile.vswip.com/job/unm-ios-it/',
			$buildNumber_ios7,
			'/artifact/unm-ios-it/target/screenshots',
			'/iOS_7.1/iPhone_Retina_4-inch/',
			$scenariosClassSimpleName, '/', $scenarioMethodName, 
			'/', @filename)}"/>
	<div class="iPod"/>
</div>

</xsl:template>

<xsl:template name="shortLabel">
<xsl:param name="shortLabel" select="@shortLabel"/>

<div class="shortLabel">
	<xsl:choose>
	<xsl:when test="name($shortLabel) = 'transitionShortLabel'">
		(<xsl:value-of select="$shortLabel"/>)
	</xsl:when>
	<xsl:when test="name($shortLabel) = 'filename'">
		<xsl:value-of select="substring-before($shortLabel, '.png')"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$shortLabel"/>
	</xsl:otherwise>
	</xsl:choose>
</div>

</xsl:template>

<xsl:template name="shortLabel-fromActions">
<xsl:param name="actions"/>

<div class="shortLabel">
	<xsl:choose>
	<xsl:when test="$actions[@label = 'swipe']">(swipe)</xsl:when>
	<xsl:when test="$actions[starts-with(@label, 'click:')]">(click)</xsl:when>
	</xsl:choose>
</div>

</xsl:template>

<xsl:template name="detail-td-iOS7-screen_4_inch">
<td class="iOS7 screen_4_inch">
<div class="label">
	iOS 7 Retina 4-inch 
</div>
<div class="img">
	<img class="img-detail-iOS7-4inch" src="{$img-blank.png}"/>	
</div>
</td>
</xsl:template>

<xsl:template name="detail-td-iOS6-screen_4_inch">
<td class="iOS6 screen_4_inch">
<div class="label">
	iOS 6 — Retina 4-inch 
</div>
<div class="img">
	<img class="img-detail-iOS6-4inch" src="{$img-blank.png}"/>	
</div>
</td>
</xsl:template>

<xsl:template name="detail-td-iOS7-screen_3_5_inch">
<td class="iOS7 screen_3_5_inch">
<div class="label">
	iOS 7 — Retina 3.5-inch 
</div>
<div class="img">
	<img class="img-detail-iOS7-3_5inch" src="{$img-blank.png}"/>	
</div>
</td>
</xsl:template>

<xsl:template name="detail-td-iOS6-screen_3_5_inch">
<td class="iOS6 screen_3_5_inch">
<div class="label">
	iOS 6 — Retina 3.5-inch 
</div>
<div class="img">
	<img class="img-detail-iOS6-3_5inch" src="{$img-blank.png}"/>	
</div>
</td>
</xsl:template>

<xsl:template name="div-detail-menu">
<div id="div-detail-menu">
	<div id="div-detail-menu-top" class="detail-menu top"
		onclick="selectDetailMenu('top');">
	<table>
	<tbody>
	<tr>
	<td class="iOS7 screen_4_inch"><div>7</div></td>
	<td class="iOS7 screen_3_5_inch"><div>7</div></td>
	</tr>
	<tr>
	<td class="iOS6 screen_4_inch"><div>6</div></td>
	<td class="iOS6 screen_3_5_inch"><div>6</div></td>
	</tr>
	</tbody>
	</table>		
	</div>
	<div id="div-detail-menu-middle" class="detail-menu middle"
		onclick="selectDetailMenu('middle');">
	<table>
	<tbody>
	<tr>
	<td class="iOS7 screen_4_inch"><div>7</div></td>
	<td class="iOS7 screen_3_5_inch"><div>7</div></td>
	</tr>
	<tr>
	<td class="iOS6 screen_4_inch"><div>6</div></td>
	<td class="iOS6 screen_3_5_inch"><div>6</div></td>
	</tr>
	</tbody>
	</table>		
	</div>
	<div id="div-detail-menu-bottom" class="detail-menu bottom"
		onclick="selectDetailMenu('bottom');">
	<table>
	<tbody>
	<tr>
	<td class="iOS7 screen_4_inch"><div>7</div></td>
	<td class="iOS7 screen_3_5_inch"><div>7</div></td>
	</tr>
	<tr>
	<td class="iOS6 screen_4_inch"><div>6</div></td>
	<td class="iOS6 screen_3_5_inch"><div>6</div></td>
	</tr>
	</tbody>
	</table>		
	</div>
	<div id="div-detail-menu-default" class="detail-menu default selected"
		onclick="selectDetailMenu('default');">
	<table>
	<tbody>
	<tr>
	<td class="iOS7 screen_4_inch"><div>7</div></td>
	<td class="iOS6 screen_4_inch"><div>6</div></td>
	</tr>
	<tr>
	<td class="iOS7 screen_3_5_inch"><div>7</div></td>
	<td class="iOS6 screen_3_5_inch"><div>6</div></td>
	</tr>
	</tbody>
	</table>		
	</div>
</div>
</xsl:template>

</xsl:stylesheet>
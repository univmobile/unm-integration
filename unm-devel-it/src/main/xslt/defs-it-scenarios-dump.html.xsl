<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="defs-scenarios.html.xsl"/>

<!--  
<xsl:variable name="grid">
	<platform name="iOS_7.1">
		<device name="iPhone_Retina_3.5-inch"/>
		<device name="iPhone_Retina_4-inch"/>
	</platform>
	<platform name="iOS_6.1">
		<device name="iPhone_Retina_3.5-inch"/>
		<device name="iPhone_Retina_4-inch"/>
	</platform>
</xsl:variable>
-->

<xsl:variable name="img-blank.png" select="concat(
	'http://univmobile.vswip.com/nexus/content/sites/pub/',
	'unm-ios/0.0.1-SNAPSHOT/img/blank.png')"/>

<xsl:template name="div-detail-ios">
<div id="div-detail">
<xsl:call-template name="div-detail-menu"/>
<table id="table-detail-default" class="table-detail top">
<tr>
<xsl:call-template name="detail-td-iOS7-screen_4_inch"/>
<xsl:call-template name="detail-td-iOS7-screen_3_5_inch"/>
</tr>
<tr>
<xsl:call-template name="detail-td-iOS6-screen_4_inch"/>
<xsl:call-template name="detail-td-iOS6-screen_3_5_inch"/>
</tr>
<tr>
<td colspan="2">
<div class="detailBottom"></div>
</td>
</tr>
</table>
<table id="table-detail-default" class="table-detail middle">
<tr>
<xsl:call-template name="detail-td-iOS7-screen_4_inch"/>
<xsl:call-template name="detail-td-iOS7-screen_3_5_inch"/>
</tr>
<tr>
<xsl:call-template name="detail-td-iOS6-screen_4_inch"/>
<xsl:call-template name="detail-td-iOS6-screen_3_5_inch"/>
</tr>
<tr>
<td colspan="2">
<div class="detailBottom"></div>
</td>
</tr>
</table>
<table id="table-detail-default" class="table-detail bottom">
<tr>
<xsl:call-template name="detail-td-iOS7-screen_4_inch"/>
<xsl:call-template name="detail-td-iOS7-screen_3_5_inch"/>
</tr>
<tr>
<xsl:call-template name="detail-td-iOS6-screen_4_inch"/>
<xsl:call-template name="detail-td-iOS6-screen_3_5_inch"/>
</tr>
<tr>
<td colspan="2">
<div class="detailBottom"></div>
</td>
</tr>
</table>
<table id="table-detail-default" class="table-detail default selected">
<tr>
<xsl:call-template name="detail-td-iOS7-screen_4_inch"/>
<xsl:call-template name="detail-td-iOS6-screen_4_inch"/>
</tr>
<tr>
<xsl:call-template name="detail-td-iOS7-screen_3_5_inch"/>
<xsl:call-template name="detail-td-iOS6-screen_3_5_inch"/>
</tr>
<tr>
<td colspan="2">
<div class="detailBottom"></div>
</td>
</tr>
</table>
<!-- 
<div id="div-detailBottom">
toto
</div>
-->
</div> <!-- end of #div-detail -->
</xsl:template>

<xsl:template name="div-detail-android">
<div id="div-detail">
<table id="table-detail-default" class="table-detail default selected">
<tr>
<xsl:call-template name="detail-td-Android-screen_480x800"/>
</tr>
<tr>
<td colspan="1">
<div class="detailBottom"></div>
</td>
</tr>
</table>
</div>
</xsl:template>

<xsl:template name="div-detail-backend">
<div id="div-detail">
<table id="table-detail-default" class="table-detail default selected">
<tr>
<xsl:call-template name="detail-td-Debian"/>
</tr>
<tr>
<xsl:call-template name="detail-td-MacOS"/>
</tr>
<tr>
<td colspan="2">
<div class="detailBottom"></div>
</td>
</tr>
</table>
</div>
</xsl:template>

<xsl:template name="scenarios">
<!--  
<xsl:param name="grid" select="document('')//xsl:variable[@name = 'grid']"/>
-->

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
<xsl:sort select="@methodName"/>
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

<table id="table-scenarios">
<tbody>
<tr>
<td class="scenarios">
<div id="div-scenarios">

<xsl:for-each select="$scenariosClasses">
<xsl:variable name="className" select="@className"/>

<xsl:variable name="scenariosAnchorId">
	<xsl:call-template name="anchorId"/>
</xsl:variable>

<xsl:variable name="scenariosClassSimpleName" select="@classSimpleName"/> —

<div class="scenariosClass">
<a name="{$scenariosAnchorId}" id="{$scenariosAnchorId}">
<h2>
	<xsl:value-of select="$scenariosClassSimpleName"/> —
	<xsl:value-of select="@scenariosLabel"/>
</h2>
</a>

<!--  
<div class="scenariosClass label">
<xsl:value-of select="@scenariosLabel"/>
</div>
-->

<xsl:for-each select="$scenarioMethods[../@className = $className]">
<xsl:sort select="@methodName"/>

<xsl:variable name="scenarioAnchorId">
	<xsl:call-template name="anchorId"/>
</xsl:variable>

<xsl:variable name="scenarioMethodName" select="@methodName"/>

<div class="scenarioMethod">
<a name="{$scenarioAnchorId}" id="{$scenarioAnchorId}">
<h3>
	<xsl:value-of select="$scenarioMethodName"/> —
	<xsl:value-of select="@scenarioLabel"/>
</h3>
</a>

<!--  
<div class="scenarioMethod label">
<xsl:value-of select="@scenarioLabel"/>
</div>
-->

<div class="scenario">
<div class="summary">
<ol>
<xsl:for-each select="scenario[1]/screenshot[1]">
	<li style="cursor: pointer" onclick="displayDetail(
		'{$scenariosClassSimpleName}',
		'{$scenarioMethodName}',
		'{@filename}', 1)">
	<xsl:value-of select="substring-before(@filename, '.png')"/>
	</li>
</xsl:for-each>
<xsl:for-each select="scenario[1]/screenshot[not(position() = 1)]">
<xsl:variable name="index"
	select="count(ancestor-or-self::screenshot/preceding-sibling::screenshot)"/>
<xsl:choose>
<xsl:when test="@ms">
	<xsl:variable name="followingScreenshotCount"
		select="count(following-sibling::screenshot)"/>
	<xsl:variable name="followingActions" select="following-sibling::action
		[count(following-sibling::screenshot) = $followingScreenshotCount]"/>
	<li value="{$index + 1}" class="action number"
		style="cursor: pointer" onclick="displayDetail(
		'{$scenariosClassSimpleName}',
		'{$scenarioMethodName}',
		'{@filename}', {$index + 1})">
		<xsl:for-each select="$followingActions/self::action">
			<xsl:if test="not(position() = 1)">, </xsl:if>
			<xsl:value-of select="@label"/>
		</xsl:for-each>
	</li>
</xsl:when>
<xsl:otherwise>
	<xsl:variable name="precedingScreenshotCount"
		select="count(preceding-sibling::screenshot)"/>
	<xsl:variable name="precedingActions" select="preceding-sibling::action
		[count(preceding-sibling::screenshot) = $precedingScreenshotCount]"/>
	<xsl:choose>
	<xsl:when test="not(preceding-sibling::screenshot[@ms and
		count(preceding-sibling::screenshot) + 1 = $precedingScreenshotCount])">
	<li value="{$index}" class="action">
		<xsl:for-each select="$precedingActions/self::action">
			<xsl:if test="not(position() = 1)">, </xsl:if>
			<xsl:value-of select="@label"/>
		</xsl:for-each>
	</li>
	</xsl:when>
	</xsl:choose>	
	
	<li value="{$index + 1}" style="cursor: pointer" onclick="displayDetail(
		'{$scenariosClassSimpleName}',
		'{$scenarioMethodName}',
		'{@filename}', {$index + 1})">
	<xsl:value-of select="substring-before(@filename, '.png')"/>
	</li>

</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</ol>
</div>

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
	
	<!-- 
	<div class="transition">
	
	<xsl:call-template name="shortLabel-fromActions">
		<xsl:with-param name="actions" select="$precedingActions"/>
	</xsl:call-template>
	
	</div>
 	-->
 
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

</div> <!-- end of #div-scenarios -->
</td>
<td class="filler">
</td>
</tr>
</tbody>
</table> <!--  end of #table-scenarios -->

</xsl:template>

<xsl:template name="anchorId">
	<xsl:value-of select="ancestor-or-self::scenariosClass/@classSimpleName"/>
	<xsl:if test="self::scenarioMethod">
		<xsl:value-of select="concat('.', @methodName)"/>
	</xsl:if>
</xsl:template>

<xsl:template name="device">
<xsl:param name="screenshot" select="self::screenshot"/>

<xsl:variable name="scenariosClassSimpleName"
	select="parent::scenario/parent::scenarioMethod/parent::scenariosClass/@classSimpleName"/>
<xsl:variable name="scenarioMethodName"
	select="parent::scenario/@scenarioMethod"/>
	
<xsl:variable name="buildNumber_ios7"
	select="/*/scenarios[not(contains(@jobName, '-it_ios6'))]/@buildNumber"/>
<xsl:variable name="buildNumber_ios6"
	select="/*/scenarios[contains(@jobName, '-it_ios6')]/@buildNumber"/>
<xsl:variable name="buildNumber_android"
	select="/*/scenarios[contains(@jobName, 'android-it')]/@buildNumber"/>
<xsl:variable name="buildNumber_backend"
	select="/*/scenarios[contains(@jobName, 'backend-it_macos')]/@buildNumber"/>
<!--  
<xsl:variable name="buildNumber_ios7"
	select="/*/scenarios[@iosLabel = 'iOS7']/@buildNumber"/>
<xsl:variable name="buildNumber_ios6"
	select="/*/scenarios[@iosLabel = 'iOS6']/@buildNumber"/>
-->

<xsl:variable name="ios" select="/*/scenarios[contains(@jobName, '_ios6')]"/>
<xsl:variable name="android" select="/*/scenarios[contains(@jobName, '-android')]"/>

<xsl:variable name="jobName_ios7">
	<xsl:choose>
	<xsl:when test="/*/scenarios[contains(@jobName, 'unm-ios-it_ios6')]">unm-ios-it</xsl:when>
	<xsl:when test="/*/scenarios[contains(@jobName, 'unm-mobileweb-it_ios6')]">unm-mobileweb-it_ios7</xsl:when>
	<xsl:when test="$android">unm-android-it</xsl:when>
	<xsl:otherwise>unm-backend-it_macos</xsl:otherwise>
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

<xsl:variable name="jobName">
<xsl:choose>
<xsl:when test="$ios">
	<xsl:value-of select="$jobName_ios7"/>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="$jobName_ios7"/> <!-- TODO -->
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:variable name="buildNumber">
<xsl:choose>
<xsl:when test="$ios">
	<xsl:value-of select="$buildNumber_ios7"/>
</xsl:when>
<xsl:when test="$android">
	<xsl:value-of select="$buildNumber_android"/>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="$buildNumber_backend"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:variable name="subDir">
<xsl:choose>
<xsl:when test="$ios">/iOS_7.1/iPhone_Retina_4-inch/</xsl:when>
<xsl:when test="$android">/Android_XXX/Android_Emulator/</xsl:when>
<xsl:otherwise>/Mac_OS_X_10.8.5/Firefox/</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:variable name="index" select="1 + count(
	ancestor-or-self::screenshot/preceding-sibling::screenshot
)"/>

<!--  
<xsl:variable name="id" select="concat(
	ancestor::scenariosClass/@classSimpleName, '.',
	ancestor::scenarioMethod/@methodName, '.',
	count(ancestor-or-self::screenshot/preceding-sibling::screenshot) + 1
)"/>
-->
<a name="{concat('a-device-',
	$scenariosClassSimpleName, '.',
	$scenarioMethodName, '.',
	$index
)}">
<div style="cursor: pointer" onclick="displayDetail(
			'{$scenariosClassSimpleName}', '{$scenarioMethodName}',
			'{@filename}', {$index});"		
		xtitle="{@filename}">
<xsl:attribute name="class">device<xsl:choose>
	<xsl:when test="$ios"> iPod</xsl:when>
	<xsl:when test="$android"> Android</xsl:when>
	<xsl:otherwise> backend</xsl:otherwise>
	</xsl:choose>
</xsl:attribute>
	<span class="layout">
	<img class="screenshot" src="{concat(
			'http://univmobile.vswip.com/job/', $jobName, '/',
			$buildNumber,
			'/artifact/', $mavenProject, '/target/screenshots',
			$subDir,
			$scenariosClassSimpleName, '/', $scenarioMethodName, 
			'/', @filename)}"/>
	</span>	
	<div/>

</div>
</a>

</xsl:template>

<xsl:template name="shortLabel">
<xsl:param name="shortLabel" select="@shortLabel"/>

<xsl:variable name="index"
	select="count(ancestor-or-self::screenshot/preceding-sibling::screenshot) + 1"/>
	
<xsl:variable name="id" select="concat(
	ancestor::scenariosClass/@classSimpleName, '.',
	ancestor::scenarioMethod/@methodName, '.',
	$index
)"/>

<a name="a-div-shortLabel-{$id}" id="a-div-shortLabel-{$id}">
<div class="shortLabel div-shortLabel" id="div-shortLabel-{$id}"
	style="cursor: pointer" onclick="displayDetail(
		'{ancestor::scenariosClass/@classSimpleName}',
		'{ancestor::scenarioMethod/@methodName}',
		'{@filename}',
		{$index}
	)">
<span>
	<xsl:value-of select="1
		+ count(ancestor-or-self::screenshot/preceding-sibling::screenshot)"/>
	<span class="filename">.
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
	</span>
</span>
</div>
</a>

</xsl:template>

<xsl:template name="shortLabel-fromActions">
<xsl:param name="actions"/>

<xsl:variable name="id" select="concat(
	ancestor::scenariosClass/@classSimpleName, '.',
	ancestor::scenarioMethod/@methodName, '.',
	count(ancestor-or-self::screenshot/preceding-sibling::screenshot) + 1
)"/>

<a name="a-div-shortLabel-{$id}" id="a-div-shortLabel-{$id}">
<div class="shortLabel div-shortLabel" id="div-shortLabel-{$id}">
<span>
	<xsl:value-of select="1
		+ count(ancestor-or-self::screenshot/preceding-sibling::screenshot)"/>.
	<xsl:choose>
	<xsl:when test="$actions[@label = 'swipe']">(swipe)</xsl:when>
	<xsl:when test="$actions[starts-with(@label, 'click:')]">(click)</xsl:when>
	</xsl:choose>
</span>
</div>
</a>

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

<xsl:template name="detail-td-Android-screen_480x800">
<td class="Android screen_480x800">
<div class="label">
	Android — 480x800
</div>
<div class="img">
	<img class="img-detail-Android-480x800" src="{$img-blank.png}"/>	
</div>
</td>
</xsl:template>

<xsl:template name="detail-td-Debian">
<td class="Debian screen_1280">
<div class="label">
	Debian 1280x876
</div>
<div class="img">
	<img class="img-detail-backend-Debian" src="{$img-blank.png}"/>	
</div>
</td>
</xsl:template>

<xsl:template name="detail-td-MacOS">
<td class="MacOS screen_1024">
<div class="label">
	Mac OS X 1024x674
</div>
<div class="img">
	<img class="img-detail-backend-MacOS" src="{$img-blank.png}"/>	
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
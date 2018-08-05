<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                exclude-result-prefixes="xs dita-ot dita2html ditamsg">

<!-- =========== FIGURE =========== -->
<xsl:template match="*[contains(@class, ' topic/fig ')]" name="topic.fig">
  <xsl:variable name="default-fig-class">
    <xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
  </xsl:variable>
  <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
  <figure>
    <xsl:if test="$default-fig-class != ''">
      <xsl:attribute name="class" select="$default-fig-class"/>
    </xsl:if>
    <xsl:call-template name="commonattributes">
      <xsl:with-param name="default-output-class" select="$default-fig-class"/>
    </xsl:call-template>
    <xsl:call-template name="setscale"/>
    <xsl:call-template name="setidaname"/>
    <xsl:apply-templates select="node() except *[contains(@class, ' topic/title ') or contains(@class, ' topic/desc ')]"/>
  </figure>
  <div>
  <xsl:call-template name="place-fig-lbl"/>
  </div>
  <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  <xsl:value-of select="$newline"/>
</xsl:template>

<!-- Determine the default XHTML class attribute for a figure -->
<xsl:template match="*" mode="dita2html:get-default-fig-class">
  <xsl:choose>
    <xsl:when test="@frame = 'all'">figborder</xsl:when>
    <xsl:when test="@frame = 'sides'">figsides</xsl:when>
    <xsl:when test="@frame = 'top'">figtop</xsl:when>
    <xsl:when test="@frame = 'bottom'">figbottom</xsl:when>
    <xsl:when test="@frame = 'topbot'">figtopbot</xsl:when>
    <xsl:otherwise>fignone</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- should not need priority, default is low enough; was set to 1 -->
<xsl:template match="*[contains(@class, ' topic/figgroup ')]" name="topic.figgroup">
  <!-- Figgroup can contain blocks, maybe this should be a div?
       Changing to <div> with DITA-OT 2.3 -->
  <div>
    <xsl:call-template name="commonattributes"/>
    <xsl:call-template name="setidaname"/>
    <!-- Allow title to fallthrough -->
    <xsl:apply-templates/>
  </div>
</xsl:template>


<!-- Figure caption -->
<xsl:template name="place-fig-lbl">
<xsl:param name="stringName"/>
  <!-- Number of fig/title's including this one -->
  <xsl:variable name="fig-count-actual" select="count(preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')])+1"/>
  <xsl:variable name="ancestorlang">
    <xsl:call-template name="getLowerCaseLang"/>
  </xsl:variable>
  <xsl:choose>
    <!-- title -or- title & desc -->
    <xsl:when test="*[contains(@class, ' topic/title ')]">
      <span class="figcap">
       <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="figtitle"/>
       <xsl:if test="*[contains(@class, ' topic/desc ')]">
         <xsl:text>. </xsl:text>
       </xsl:if>
      </span>
      <xsl:for-each select="*[contains(@class, ' topic/desc ')]">
       <span class="figdesc">
         <xsl:call-template name="commonattributes"/>
         <xsl:apply-templates select="." mode="figdesc"/>
       </span>
      </xsl:for-each>
    </xsl:when>
    <!-- desc -->
    <xsl:when test="*[contains(@class, ' topic/desc ')]">
      <xsl:for-each select="*[contains(@class, ' topic/desc ')]">
       <span class="figdesc">
         <xsl:call-template name="commonattributes"/>
         <xsl:apply-templates select="." mode="figdesc"/>
       </span>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]" mode="figtitle">
 <xsl:apply-templates/>
</xsl:template>
<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/desc ')]" mode="figdesc">
 <xsl:apply-templates/>
</xsl:template>
<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/desc ')]" mode="get-output-class">figdesc</xsl:template>

<!-- These 2 rules are not actually used, but could be picked up by an override -->
<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]" name="topic.fig_title">
  <span><xsl:apply-templates/></span>
</xsl:template>
<!-- These rules are not actually used, but could be picked up by an override -->
<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/desc ')]" name="topic.fig_desc">
  <span><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/figgroup ')]/*[contains(@class, ' topic/title ')]" name="topic.figgroup_title">
 <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>

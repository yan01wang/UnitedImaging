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
				
<!-- list item -->
<xsl:template match="*[contains(@class, ' topic/li ')]" name="topic.li">
<xsl:param name="p_level"/>
<xsl:param name="v_li_type"/>
<xsl:variable name="v_leve_type">
			<xsl:choose><!--Unicode Character 'BLACK rhombus ' -->
			    <xsl:when test="$p_level='Y'">
				     <xsl:value-of select="normalize-space('&#9830;&#160;')"/> 
				</xsl:when>
				<xsl:when test="$p_level='N'"><!--Unicode Character 'BLACK SQUARE ' -->   
					<!-- <xsl:value-of select="normalize-space('&#9632;&#160;')"/> -->
					<xsl:value-of select="'square'"/>
				</xsl:when>
				<xsl:otherwise>
				<xsl:value-of select="'square'"/>
				</xsl:otherwise>
			</xsl:choose>
</xsl:variable>
<xsl:choose>
<!-- ol list item is the default style -->
<xsl:when test="$v_li_type = 'ol'">
<li>
  <xsl:choose>
    <xsl:when test="parent::*/@compact = 'no'">
      <xsl:attribute name="class">liexpand</xsl:attribute>
      <!-- handle non-compact list items -->
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="'liexpand'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="commonattributes"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="setidaname"/>
 <xsl:apply-templates/>
</li>
</xsl:when>
<!--  ul list item is the customize style -->
<xsl:otherwise>
<li>
<xsl:choose>
    <xsl:when test="parent::*/@compact = 'no'">
      <xsl:attribute name="class">liexpand</xsl:attribute>
      <!-- handle non-compact list items -->
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="'liexpand'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="commonattributes"/>
    </xsl:otherwise>
</xsl:choose>
<xsl:choose>
<!-- list item BLACK SQUARE -->
<xsl:when test="$v_leve_type = 'square'">
  <xsl:call-template name="setidaname"/>
  <xsl:apply-templates/>
</xsl:when>
<!-- sublist item BLACK rhombus -->
<xsl:otherwise>
<div style="width:100%;padding-right:5pt;">
  <xsl:call-template name="setidaname"/>
  <div class="sublistIcon"><!-- style="float:left;width:10pt;text-align:left;vertical-align:middle;" -->
  <xsl:value-of select="normalize-space($v_leve_type)"/></div>
  <div style="float:left;line-height:13pt;padding-right:10pt;"><xsl:apply-templates/></div></div>
</xsl:otherwise>
</xsl:choose>
</li>
</xsl:otherwise>
</xsl:choose>
<xsl:value-of select="$newline"/>
</xsl:template>
</xsl:stylesheet>
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
				
<xsl:template match="*[contains(@class, ' topic/ul ')]" name="topic.ul">
   <xsl:param name="p_level">
		   <xsl:choose>
		       <xsl:when test="parent::ul or ancestor::ul">
			      <xsl:value-of select="'Y'"/>
			   </xsl:when>
			   <xsl:otherwise>
			      <xsl:value-of select="'N'"/>
			   </xsl:otherwise>
		   </xsl:choose>
   </xsl:param>
   <xsl:param name="v_noteType"/>
  <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
  <xsl:call-template name="setaname"/>
  <ul>
  <xsl:choose>
  <xsl:when test="$p_level = 'N'">
  <xsl:call-template name="style">
  <xsl:with-param name="contents"><xsl:text>margin-left:12pt;</xsl:text></xsl:with-param>
  </xsl:call-template>
  </xsl:when>
  </xsl:choose>
    <xsl:call-template name="commonattributes"/>
    <xsl:apply-templates select="@compact"/>
    <xsl:call-template name="setid"/>
    <xsl:apply-templates>
			   <xsl:with-param name="p_level" select="$p_level"/>
	</xsl:apply-templates>
  </ul>
  <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  <xsl:value-of select="$newline"/>
</xsl:template>
</xsl:stylesheet>
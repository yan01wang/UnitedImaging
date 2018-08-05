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



<!-- Left for users who call this template in an override -->
<xsl:template name="note">
  <xsl:apply-templates select="." mode="process.note"/>
</xsl:template>

<!-- Fixed SF Bug 1405184 "Note template for XHTML should be easier to override" -->
<!-- RFE 2703335 reduces duplicated code by adding common processing rules.
     To override all notes, match the note element's class attribute directly, as in this rule.
     To override a single note type, match the class with mode="process.note.(selected-type)"
     To override all notes except danger and caution, match the class with mode="process.note.common-processing" -->
<xsl:template match="*[contains(@class, ' topic/note ')]" name="topic.note">
  <xsl:call-template name="spec-title"/>
  <xsl:choose>
    <xsl:when test="@type = 'note'">
      <xsl:apply-templates select="." mode="process.note"/>
    </xsl:when>
	<xsl:when test="@type = 'caution'">
      <xsl:apply-templates select="." mode="process.note.caution"/>
    </xsl:when>
    <xsl:when test="@type = 'danger'">
      <xsl:apply-templates select="." mode="process.note.danger"/>
    </xsl:when>
    <xsl:when test="@type = 'warning'">
	<xsl:apply-templates select="." mode="process.note.warning"/>
    </xsl:when>
	<xsl:when test="@type = 'other'">
      <xsl:apply-templates select="." mode="process.note.other"/>
    </xsl:when>
<!--	以下为不常用的note类型样式
    <xsl:when test="@type = 'tip'">
      <xsl:apply-templates select="." mode="process.note.tip"/>
    </xsl:when>
    <xsl:when test="@type = 'fastpath'">
      <xsl:apply-templates select="." mode="process.note.fastpath"/>
    </xsl:when>
    <xsl:when test="@type = 'important'">
      <xsl:apply-templates select="." mode="process.note.important"/>
    </xsl:when>
    <xsl:when test="@type = 'remember'">
      <xsl:apply-templates select="." mode="process.note.remember"/>
    </xsl:when>
    <xsl:when test="@type = 'restriction'">
      <xsl:apply-templates select="." mode="process.note.restriction"/>
    </xsl:when>
    <xsl:when test="@type = 'attention'">
      <xsl:apply-templates select="." mode="process.note.attention"/>
    </xsl:when>  
    <xsl:when test="@type = 'trouble'">
      <xsl:apply-templates select="." mode="process.note.trouble"/>
    </xsl:when>
    -->
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="process.note"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template match="*" mode="process.note.common-processing">
  <xsl:param name="type" select="@type"/>
  <xsl:param name="title">
    <xsl:call-template name="getVariable">
      <!-- For the parameter, turn "note" into "Note", caution => Caution, etc -->
      <xsl:with-param name="id"
           select="concat(upper-case(substring($type, 1, 1)),
                          substring($type, 2))"/>
    </xsl:call-template>
  </xsl:param>
  <table style="border:0.5pt solid black;">
    <xsl:call-template name="commonattributes">
      <xsl:with-param name="default-output-class" select="$type"/>
    </xsl:call-template>
    <xsl:call-template name="setidaname"/>
    <!-- Normal flags go before the generated title; revision flags only go on the content. -->
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
    <tr class="{$type}title" >
     <td>
	 <xsl:if test="$type = 'danger'">
	 <img style="height:15pt;width:15pt;vertical-align:middle;margin-bottom:2pt;" src="{$PATH2PROJ}artwork/note.gif"/>
	 </xsl:if>
	 <xsl:if test="$type = 'caution'">
	 <img style="height:15pt;width:15pt;vertical-align:middle;margin-bottom:2pt;" src="{$PATH2PROJ}artwork/note.gif"/>
	 </xsl:if>
	 <xsl:if test="$type = 'warning'">
	 <img style="height:15pt;width:15pt;vertical-align:middle;margin-bottom:2pt;" src="{$PATH2PROJ}artwork/note.gif"/>
	 </xsl:if>
	 <xsl:value-of select="$title"/>
	 </td>
    </tr>
	<tr>
	<td  style="padding:0.5em;"><xsl:text> </xsl:text>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
    <xsl:apply-templates/>
    <!-- Normal end flags and revision end flags both go out after the content. -->
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/></td>
	</tr>
  </table>
</xsl:template>

<xsl:template match="*" mode="process.note">
  <xsl:apply-templates select="." mode="process.note.common-processing">
    <!-- Force the type to note, in case new unrecognized values are added
         before translations exist (such as Warning) -->
    <xsl:with-param name="type" select="'note'"/>
  </xsl:apply-templates>
</xsl:template>
<xsl:template match="*" mode="process.note.warning">
  <xsl:apply-templates select="." mode="process.note.common-processing"/>
</xsl:template>
<xsl:template match="*" mode="process.note.caution">
   <xsl:apply-templates select="." mode="process.note.common-processing"/>
</xsl:template>
<xsl:template match="*" mode="process.note.danger">
 <xsl:apply-templates select="." mode="process.note.common-processing"/>
</xsl:template>
<!-- other use a single tr, so  do not
     use the common note processing template. -->
<xsl:template match="*" mode="process.note.other">
  <xsl:param name="type" select="@type"/>
  <xsl:param name="title">
    <xsl:call-template name="getVariable">
      <!-- For the parameter, turn "note" into "Note", caution => Caution, etc -->
      <xsl:with-param name="id"
           select="concat(upper-case(substring($type, 1, 1)),
                          substring($type, 2))"/>
      </xsl:call-template>
  </xsl:param>
  <table border="0">
    <xsl:call-template name="commonattributes">
      <xsl:with-param name="default-output-class" select="$type"/>
    </xsl:call-template>
    <xsl:call-template name="setidaname"/>
    <!-- Normal flags go before the generated title; revision flags only go on the content. -->
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
    <tr class="{$type}title" >
     <td width="10%;"><img src="{$PATH2PROJ}artwork/Helpinfo.gif"></img>
	 </td>
	 <td><xsl:text> </xsl:text>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
    <xsl:apply-templates>
	<xsl:with-param name="v_noteType" select="'note'"/>
	</xsl:apply-templates>
    <!-- Normal end flags and revision end flags both go out after the content. -->
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/></td>
	</tr>
  </table>
</xsl:template>

<!-- 以下为不常用note type的模板
<xsl:template match="*" mode="process.note.tip">
  <xsl:apply-templates select="." mode="process.note.common-processing"/>
</xsl:template>

<xsl:template match="*" mode="process.note.fastpath">
  <xsl:apply-templates select="." mode="process.note.common-processing"/>
</xsl:template>

<xsl:template match="*" mode="process.note.important">
  <xsl:apply-templates select="." mode="process.note.common-processing"/>
</xsl:template>

<xsl:template match="*" mode="process.note.remember">
  <xsl:apply-templates select="." mode="process.note.common-processing"/>
</xsl:template>

<xsl:template match="*" mode="process.note.restriction">
  <xsl:apply-templates select="." mode="process.note.common-processing"/>
</xsl:template>
<xsl:template match="*" mode="process.note.attention">
  <xsl:apply-templates select="." mode="process.note.common-processing"/>
</xsl:template>
  
<xsl:template match="*" mode="process.note.trouble">
  <xsl:apply-templates select="." mode="process.note.common-processing"/>
</xsl:template>
-->

</xsl:stylesheet>
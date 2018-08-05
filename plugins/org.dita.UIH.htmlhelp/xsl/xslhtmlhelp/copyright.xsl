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
				
<xsl:template match="/dita | *[contains(@class, ' topic/topic ')]">
   <xsl:variable name="v_type" select="child::*[contains(@class, ' topic/title ')]"/>
   <!-- 其他语言新增判断条件即可 -->
  <xsl:choose>
    <xsl:when test="$v_type='版权所有' or lower-case($v_type) = 'copyright'">
	<xsl:apply-templates select="." mode="copyright_element"/>
    </xsl:when>
	<xsl:when test="not(parent::*) and $v_type != '版权所有' and $v_type != 'copyright'">
      <xsl:apply-templates select="." mode="root_element"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="child.topic"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="copyright_element">
  <xsl:call-template name="copyright-setup"/>
</xsl:template>

<xsl:template name="copyright-setup">
<html>
  <xsl:call-template name="setTopicLanguage"/>
  <xsl:value-of select="$newline"/>
  <xsl:call-template name="chapterHead"/>
  <xsl:call-template name="copyrightBody"/> 
</html>
</xsl:template>

 <xsl:template name="copyrightBody">
    <xsl:apply-templates select="." mode="copyrightBody"/>
  </xsl:template>
  
<xsl:template match="*" mode="copyrightBody">
    <body class="outer_body" style="margin-top:20pt;">
      <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
      <xsl:call-template name="setaname"/>  <!-- For HTML4 compatibility, if needed -->
      <xsl:value-of select="$newline"/>
      <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>

      <!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
      <xsl:call-template name="gen-user-sidetoc"/>

      <xsl:apply-templates select="." mode="addcopyrightContentToHtmlBodyElement"/>
      <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/> 
    </body>
    <xsl:value-of select="$newline"/>
</xsl:template>

  <xsl:template match="*" mode="addcopyrightContentToHtmlBodyElement">
    <main role="main">
      <article role="article">
        <xsl:attribute name="aria-labelledby">
          <xsl:apply-templates select="*[contains(@class,' topic/title ')] |
                                       self::dita/*[1]/*[contains(@class,' topic/title ')]" mode="return-aria-label-id"/>
        </xsl:attribute>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
		<!--  NOT OUTPUT TITLE  -->
		<hr/>
		<table class="copyrightTable">
		<tr>
		<td class="copyrightImg">
		<xsl:apply-templates select="*[contains(@class, ' topic/body ')]/*[contains(@class,' topic/image')]"/>
		</td>
		<td>
		<xsl:apply-templates select="*[contains(@class, ' topic/body ')]/*[contains(@class,' topic/p')]"/>
		</td>
		</tr>
		</table>         
        <xsl:call-template name="gen-endnotes"/>    <!-- include footnote-endnotes -->
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
      </article>
    </main>
  </xsl:template>
</xsl:stylesheet>
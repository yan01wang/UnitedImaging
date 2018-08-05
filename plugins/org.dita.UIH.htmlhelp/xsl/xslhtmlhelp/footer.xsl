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
				
<xsl:template match="/|node()|@*" mode="gen-user-footer">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- it will be placed in the running footing section of the XHTML. -->
  <!-- 获得版权信息 -->
  <span class="footer">
  <xsl:variable name="v_currentLang">
  <xsl:value-of select="dita-ot:get-current-language(.)"/>
  </xsl:variable>
  <table>
  <tr>
  <td style="text-align:left;border-top:0.5pt solid grey;">
   <xsl:call-template name="getVariable">
      <xsl:with-param name="id" select="'Body footer'"/>
  </xsl:call-template>
  </td>
  <td style="text-align:right;padding-top:5pt;border-top:0.5pt solid grey;">
  <!-- 获得UIH LOGO -->
  <xsl:choose>
  <xsl:when test="contains($v_currentLang,'zh')">
   <img align="right" src="{$PATH2PROJ}artwork/UIH_Logo_zh.jpg"></img> 
  </xsl:when>
  <xsl:otherwise>
   <img align="right" src="{$PATH2PROJ}artwork/UIH_Logo_en.jpg"></img>
  </xsl:otherwise>
  </xsl:choose>
  </td>
  </tr>
  </table>
  </span>
</xsl:template>
</xsl:stylesheet>
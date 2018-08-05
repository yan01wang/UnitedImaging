<?xml version="1.0" ?>

<!--
Copyright 2008 by XyEnterprise Inc. All rights reserved.

 XyEnterprise is a registered trademark of XyEnterprise Inc.

XYENTERPRISE INC. HAS CONTRIBUTED THE SOFTWARE "AS IS," WITH
ABSOLUTELY NO WARRANTIES WHATSOEVER, WHETHER EXPRESS OR IMPLIED, AND
XYENTERPRISE INC. DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE AND WARRANTY OF NON-INFRINGEMENT. XYENTERPRISE INC. SHALL NOT
BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, COVER, PUNITIVE, EXEMPLARY,
RELIANCE, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF
ANTICIPATED PROFIT), ARISING FROM ANY CAUSE UNDER OR RELATED TO OR ARISING
OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF XYENTERPRISE INC.
HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

XyEnterprise Inc. and its licensors shall not be liable for any
damages suffered by any person as a result of using and/or modifying the
Software or its derivatives.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output encoding="UTF-8"
            indent="no"
            method="xml"
         />

   <xsl:template match="/">
         <xsl:apply-templates />
   </xsl:template>

   <xsl:template match="*[contains(@class,' map/topicref ')]">
      <xsl:choose>
         <xsl:when test="@href">
            <xsl:variable name="newref">
               <xsl:value-of select="substring-after(@href,'#')"/>
            </xsl:variable>
            <xsl:variable name="topictype">
               <xsl:value-of select="name(//*[contains(@class,' topic/topic ')][@id=$newref])"/>
            </xsl:variable>
            <xsl:element name="{$topictype}">
               <xsl:copy-of select="//*[contains(@class,' topic/topic ')][@id=$newref]/@*[local-name()!=('xtrf')][local-name()!=('xtrc')]"/>
               <xsl:apply-templates select="//*[contains(@class,' topic/topic ')][@id=$newref]/*"/>
               <xsl:apply-templates />
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*[local-name()!=('xtrf')][local-name()!=('xtrc')]"/>
               <xsl:apply-templates/>
            </xsl:copy>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*|@*|processing-instruction()|text()">
      <xsl:copy>
         <xsl:copy-of select="@*[local-name()!=('xtrf')][local-name()!=('xtrc')]"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="/dita-merge/*[not(contains(@class,' map/map '))]"/>

   <xsl:template match="topicref/topicmeta"/>

</xsl:stylesheet>

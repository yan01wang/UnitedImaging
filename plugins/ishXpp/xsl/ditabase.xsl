<?xml version="1.0" encoding="UTF-8" ?>

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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:import href="../../../xsl/common/output-message.xsl"/>
   <!-- Define the error message prefix identifier -->
   <xsl:variable name="msgprefix">DOTX</xsl:variable>

<!--
   <xsl:output encoding="UTF-8"
               indent="yes"
               method="xml"
               doctype-public="-//OASIS//DTD DITA Composite//EN"
               doctype-system="ditabase.dtd"
            />
-->
   <xsl:output encoding="UTF-8"
               indent="yes"
               method="xml"
            />

   <xsl:template match="/dita-merge">
      <xsl:element name="dita">
        <xsl:apply-templates select="*"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="/dita-merge/map/linktext"/>

   <xsl:template match="/dita-merge/map/shortdesc"/>

   <xsl:template match="topicmeta"/>

   <xsl:template match="topicref">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="*[contains(@class,' map/map ')]">
      <xsl:variable name="mapTitle"><xsl:value-of select="@title"/></xsl:variable>
      <xsl:if test="$mapTitle!=''">
         <xsl:processing-instruction name="arttitle">title="<xsl:value-of select="$mapTitle" />"</xsl:processing-instruction>
      </xsl:if>
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
     <xsl:variable name="mapTitle2"><xsl:value-of select="."/></xsl:variable>
     <xsl:processing-instruction name="arttitle">title="<xsl:value-of select="$mapTitle2" />"</xsl:processing-instruction>
   </xsl:template>

   <xsl:template match="*[contains(@class,' topic/topic ')]">
      <xsl:copy>
         <xsl:copy-of select="@*[local-name() != ('refclass')][local-name() != ('oid')]"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="*[contains(@class,' topic/link ')]">
      <xsl:copy>
         <xsl:copy-of select="@*[local-name() != ('mapclass')][local-name() != ('ohref')]"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="*[contains(@class,' topic/xref ')]">
      <xsl:element name="{local-name()}">
         <xsl:copy-of select="@*[local-name() != ('ohref')]"/>
         <xsl:apply-templates/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="*|@*|processing-instruction()|text()">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
  
</xsl:stylesheet>

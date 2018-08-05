<?xml version='1.0'?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    exclude-result-prefixes="opentopic"
    version="2.0">
	
    <xsl:template name="processTopicPreface">
         <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="page-sequence.preface">
             <!--<xsl:call-template name="insertPrefaceStaticContents"/>-->
             <fo:flow flow-name="xsl-region-body">
                 <fo:block xsl:use-attribute-sets="topic">
                     <xsl:call-template name="commonattributes"/>
                     <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
                         <fo:marker marker-class-name="current-topic-number">
                             <xsl:number format="1"/>
                         </fo:marker>
                         <xsl:apply-templates select="." mode="insertTopicHeaderMarker"/>
                     </xsl:if>
                     <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>
					 <fo:block start-indent="3.0cm">
					    <xsl:call-template name="insertChapterFirstpageStaticContent">
							 <xsl:with-param name="type" select="'preface'"/>
						 </xsl:call-template>
					 </fo:block>
                     <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
                 </fo:block>
             </fo:flow>
         </fo:page-sequence>
    </xsl:template>
	


</xsl:stylesheet>
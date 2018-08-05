<?xml version='1.0'?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    exclude-result-prefixes="opentopic"
    version="2.0">
	
    <xsl:template match="*[contains(@class, ' bookmap/frontmatter ')]/*[contains(@class, ' map/topicref ')][1]" mode="generatePageSequences" priority="0">
		<xsl:for-each select="key('topic-id', @id)">
			<xsl:call-template name="processTopiccopyright"/>
		</xsl:for-each>
	</xsl:template>
  
    <xsl:template name="processTopiccopyright">
	    <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="page-sequence.copyright">
            <!--<xsl:call-template name="insertPrefaceStaticContents"/>-->
             <fo:flow flow-name="xsl-region-body">
                 <fo:block xsl:use-attribute-sets="topic" margin-top="6.5in">
                     <!--<xsl:call-template name="insertChapterFirstpageStaticContent">
                         <xsl:with-param name="type" select="'copyright'"/>
                     </xsl:call-template>  -->                
                    <!-- <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>-->
					 <fo:table width="100%">
					   <fo:table-column column-number="1" column-width="20%"/>
					   <fo:table-column column-number="2" column-width="80%"/>
						<fo:table-body>
							<fo:table-row>
							    <fo:table-cell text-align="center" display-align="top">
								    <fo:block><xsl:apply-templates select="body/image"/></fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="left" display-align="top">
								    <fo:block font-size="9pt">
									    <xsl:for-each select="body/p">
										    <fo:block margin-bottom="10pt">
											    <xsl:apply-templates/>
											</fo:block>
										</xsl:for-each>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>	
						</fo:table-body>		
					 </fo:table>
                 </fo:block>
             </fo:flow>
        </fo:page-sequence>
	 
	</xsl:template>
	
</xsl:stylesheet>
<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    <!--===================================================
	    chapter toc header/footer
	    ===================================================-->
    <xsl:template name="insert_chapter_StaticContents">
	    <xsl:param name="p_chapter_number"/>
        <xsl:call-template name="insert_chapter_OddFooter">
		    <xsl:with-param name="p_chapter_number" select="$p_chapter_number"/>
		</xsl:call-template>
        <xsl:call-template name="insert_chapter_EvenFooter">
		     <xsl:with-param name="p_chapter_number" select="$p_chapter_number"/>
		</xsl:call-template>
        <xsl:call-template name="insert_chapter_EvenHeader"/>
        <xsl:call-template name="insert_chapter_OddHeader"/>
    </xsl:template>

	<!--===================================================
	     book toc/header/footer
	    ===================================================-->
    <xsl:template name="insertTocStaticContents">
	    <xsl:param name="p_chapter_number"/>
		<xsl:param name="p_manual_name"/>
        <xsl:call-template name="insertTocoddfooter"/>		   
		<xsl:call-template name="insertTocevenfooter"/>	
        <xsl:call-template name="insertTocOddHeader"/>
        <xsl:call-template name="insertTocEvenHeader"/>
    </xsl:template>

    <xsl:template name="insert_chapter_OddHeader">
        <fo:static-content flow-name="odd-body-header">
            <fo:block border-bottom="0.5pt solid black" padding-bottom="5pt" text-align="right">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body odd header'"/>
                    <xsl:with-param name="params">
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insert_chapter_EvenHeader">
        <fo:static-content flow-name="even-body-header">
            <fo:block border-bottom="0.5pt solid black" padding-bottom="5pt" text-align="left">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body even header'"/>
                    <xsl:with-param name="params">
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>
   
    <xsl:template name="insert_chapter_OddFooter">
	    <xsl:param name="p_chapter_number"/>
        <fo:static-content flow-name="odd-body-footer">
			<fo:table font-size="9pt">
				<fo:table-column column-number="1" column-width="70%"/>
				<fo:table-column column-number="2" column-width="30%"/>
				<fo:table-body>
					<fo:table-row border-top="0.5pt solid black">
						<fo:table-cell text-align="left" padding-top="5pt">
							<fo:block>
							<fo:inline font-size="125%" baseline-shift="-25%"><xsl:value-of select="'&#xa9;'"/></fo:inline>
							<xsl:call-template name="getVariable">
								<xsl:with-param name="id" select="'Body footer'"/>
								<xsl:with-param name="params">    
								   <heading>
										<fo:inline xsl:use-attribute-sets="__body__odd__footer__heading">
											<fo:retrieve-marker retrieve-class-name="current-header"/>
										</fo:inline>
									</heading>
								</xsl:with-param>
							</xsl:call-template>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="right" padding-top="5pt">
							<fo:block><xsl:value-of select="$p_chapter_number"/>-<fo:page-number/></fo:block>
						</fo:table-cell>
					</fo:table-row>		
				</fo:table-body>	
			</fo:table>	
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insert_chapter_EvenFooter">
	    <xsl:param name="p_chapter_number"/>
        <fo:static-content flow-name="even-body-footer">
			<fo:table font-size="9pt">
				<fo:table-column column-number="1" column-width="50%"/>
				<fo:table-column column-number="2" column-width="50%"/>
				<fo:table-body>
					<fo:table-row border-top="0.5pt solid black">
						<fo:table-cell text-align="left" padding-top="5pt">
						   <fo:block><xsl:value-of select="$p_chapter_number"/>-<fo:page-number/></fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="right" padding-top="5pt">
							<fo:block><xsl:value-of select="$p_manual_type"/><xsl:text> </xsl:text><xsl:value-of select="$p_manual_name"/></fo:block>
						</fo:table-cell>
					</fo:table-row>		
				</fo:table-body>	
			</fo:table>	
        </fo:static-content>
    </xsl:template>
    
	<xsl:template name="insertTocOddHeader">
        <fo:static-content flow-name="odd-toc-header">
            <fo:block border-bottom="0.5pt solid black" padding-bottom="5pt" text-align="right">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc odd header'"/>
                    <xsl:with-param name="params">
                        
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocEvenHeader">
        <fo:static-content flow-name="even-toc-header">
            <fo:block border-bottom="0.5pt solid black" padding-bottom="5pt" text-align="left">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc even header'"/>
                    <xsl:with-param name="params">
                      
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                       
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>
	
	<xsl:template name="insertTocoddfooter">
	<fo:static-content flow-name="odd-toc-footer">
		<fo:table font-size="9pt">
			<fo:table-column column-number="1" column-width="70%"/>
			<fo:table-column column-number="2" column-width="30%"/>
			<fo:table-body>
				<fo:table-row border-top="0.5pt solid black">
					<fo:table-cell text-align="left" padding-top="5pt">
						<fo:block>
						<fo:inline font-size="125%" baseline-shift="-25%"><xsl:value-of select="'&#xa9;'"/></fo:inline>
						<xsl:call-template name="getVariable">
							<xsl:with-param name="id" select="'Body footer'"/>
							<xsl:with-param name="params">    
							   <heading>
									<fo:inline xsl:use-attribute-sets="__body__odd__footer__heading">
										<fo:retrieve-marker retrieve-class-name="current-header"/>
									</fo:inline>
								</heading>
							</xsl:with-param>
						</xsl:call-template>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell text-align="right" padding-top="5pt">
						<fo:block><fo:page-number/></fo:block>
					</fo:table-cell>
				</fo:table-row>		
			</fo:table-body>	
		</fo:table>	
	</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertTocevenfooter">
	<fo:static-content flow-name="even-toc-footer">
		<fo:table font-size="9pt">
			<fo:table-column column-number="1" column-width="50%"/>
			<fo:table-column column-number="2" column-width="50%"/>
			<fo:table-body>
				<fo:table-row border-top="0.5pt solid black">
					<fo:table-cell text-align="left" padding-top="5pt">
					   <fo:block><fo:page-number/></fo:block>
					</fo:table-cell>
					<fo:table-cell text-align="right" padding-top="5pt">
						<fo:block><xsl:value-of select="$p_manual_type"/><xsl:text> </xsl:text><xsl:value-of select="$p_manual_name"/></fo:block>
					</fo:table-cell>
				</fo:table-row>		
			</fo:table-body>	
		</fo:table>	
	</fo:static-content>
    </xsl:template>
	
	<!--===================================================
	     book index/header/footer
	    ===================================================-->
	<xsl:template name="insertIndexStaticContents">
        <xsl:call-template name="insertIndexOddHeader"/>
        <xsl:call-template name="insertIndexEvenHeader"/>
		<xsl:call-template name="insertIndexEvenfooter"/>
        <xsl:call-template name="insertIndexOddfooter"/>
    </xsl:template>
	
	<xsl:template name="insertIndexOddHeader">
        <fo:static-content flow-name="odd-index-header">
            <fo:block border-bottom="0.5pt solid black" padding-bottom="5pt" text-align="right" font-size="10pt" xsl:use-attribute-sets="__index__odd__header">
                <xsl:call-template name="getVariable">
					<xsl:with-param name="id" select="'Index'"/>
				</xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertIndexEvenHeader">
        <fo:static-content flow-name="even-index-header">
            <fo:block border-bottom="0.5pt solid black" padding-bottom="5pt" text-align="left" font-size="10pt" xsl:use-attribute-sets="__index__even__header">
                <xsl:call-template name="getVariable">
					<xsl:with-param name="id" select="'Index'"/>
				</xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>
	
	<xsl:template name="insertIndexEvenfooter">
        <fo:static-content flow-name="even-index-footer">
			<fo:table font-size="9pt">
				<fo:table-column column-number="1" column-width="50%"/>
				<fo:table-column column-number="2" column-width="50%"/>
				<fo:table-body>
					<fo:table-row border-top="0.5pt solid black">
						<fo:table-cell text-align="left" padding-top="5pt">
						   <fo:block><fo:page-number/></fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="right" padding-top="5pt">
							<fo:block><xsl:value-of select="$p_manual_type"/><xsl:text> </xsl:text><xsl:value-of select="$p_manual_name"/></fo:block>
						</fo:table-cell>
					</fo:table-row>		
				</fo:table-body>	
			</fo:table>	
		</fo:static-content>	
    </xsl:template>
	
	<xsl:template name="insertIndexOddfooter">
	    <fo:static-content flow-name="odd-index-footer">
			<fo:table font-size="9pt">
				<fo:table-column column-number="1" column-width="70%"/>
				<fo:table-column column-number="2" column-width="30%"/>
				<fo:table-body>
					<fo:table-row border-top="0.5pt solid black">
						<fo:table-cell text-align="left" padding-top="5pt">
							<fo:block>
							<fo:inline font-size="125%" baseline-shift="-25%"><xsl:value-of select="'&#xa9;'"/></fo:inline>
							<xsl:call-template name="getVariable">
								<xsl:with-param name="id" select="'Body footer'"/>
								<xsl:with-param name="params">    
								   <heading>
										<fo:inline xsl:use-attribute-sets="__body__odd__footer__heading">
											<fo:retrieve-marker retrieve-class-name="current-header"/>
										</fo:inline>
									</heading>
								</xsl:with-param>
							</xsl:call-template>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="right" padding-top="5pt">
							<fo:block><fo:page-number/></fo:block>
						</fo:table-cell>
					</fo:table-row>		
				</fo:table-body>	
			</fo:table>	
		</fo:static-content>
	</xsl:template>
 
</xsl:stylesheet>
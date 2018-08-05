<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    exclude-result-prefixes="dita-ot ot-placeholder opentopic opentopic-index opentopic-func dita2xslfo xs"
    version="2.0">
	
	<!--======================================================
	    fig keep-together.within-page
	==========================================================-->
	<xsl:template match="*[contains(@class,' topic/fig ')]">
        <fo:block xsl:use-attribute-sets="fig">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setFrame"/>
            <xsl:call-template name="setExpanse"/>
            <xsl:if test="not(@id)">
              <xsl:attribute name="id">
                <xsl:call-template name="get-id"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
            <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
        </fo:block>
    </xsl:template>
	
	<!--======================================================
	    images inline/block
	==========================================================-->
	<xsl:template match="*[contains(@class,' topic/image ')]">
	    <xsl:variable name="v_id" select="@id"/>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
        <xsl:choose>
            <xsl:when test="empty(@href)"/>
            <xsl:when test="@placement = 'break'">
                    <fo:block xsl:use-attribute-sets="image__block">
					    <xsl:attribute name="margin-left">
							<xsl:choose>
								<xsl:when test="parent::*[contains(@class,' topic/fig ')]/parent::*[contains(@class,' topic/li ')]">
								   <xsl:value-of select="'-5mm'"/>
								</xsl:when>
								<xsl:when test="parent::*[contains(@class,' topic/fig ')]/parent::*[contains(@class,' task/info ')]">
								   <xsl:value-of select="'-5mm'"/>
								</xsl:when>
								<xsl:otherwise>
								
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
                        <xsl:call-template name="commonattributes"/>
                        <xsl:apply-templates select="." mode="placeImage">
                            <xsl:with-param name="imageAlign" select="@align"/>
                            <xsl:with-param name="href" select="if (@scope = 'external' or opentopic-func:isAbsolute(@href)) then @href else concat($input.dir.url, @href)"/>
                            <xsl:with-param name="height" select="@height"/>
                            <xsl:with-param name="width" select="@width"/>
                        </xsl:apply-templates>
                    </fo:block>
                    <xsl:if test="$artLabel='yes'">
                      <fo:block>
                        <xsl:apply-templates select="." mode="image.artlabel"/>
                      </fo:block>
                    </xsl:if><!-- remove @id from here. modified by minnie2018/08/01-->
					<!--<fo:block font-size="7pt" font-weight="bold">
						<xsl:attribute name="text-align">
							<xsl:value-of select="'right'"/>
						</xsl:attribute>	
					    <xsl:value-of select="$v_id"/>
					</fo:block>-->
            </xsl:when>
            <xsl:when test="@placement = 'inline'">
			    <fo:inline margin-left="3.5pt" margin-right="2.5pt" margin-bottom="5pt">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="." mode="placeImage">
                        <xsl:with-param name="imageAlign" select="@align"/>
                        <xsl:with-param name="href" select="if (@scope = 'external' or opentopic-func:isAbsolute(@href)) then @href else concat($input.dir.url, @href)"/>
                        <xsl:with-param name="height" select="@height"/>
                        <xsl:with-param name="width" select="@width"/>
                    </xsl:apply-templates>
                </fo:inline>
                <xsl:if test="$artLabel='yes'">
                  <xsl:apply-templates select="." mode="image.artlabel"/>
                </xsl:if>
			</xsl:when>
			<xsl:otherwise>
                <fo:inline margin-bottom="5pt">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="." mode="placeImage">
                        <xsl:with-param name="imageAlign" select="@align"/>
                        <xsl:with-param name="href" select="if (@scope = 'external' or opentopic-func:isAbsolute(@href)) then @href else concat($input.dir.url, @href)"/>
                        <xsl:with-param name="height" select="@height"/>
                        <xsl:with-param name="width" select="@width"/>
                    </xsl:apply-templates>
                </fo:inline>
                <xsl:if test="$artLabel='yes'">
                  <xsl:apply-templates select="." mode="image.artlabel"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>
	
	<!--======================================================
	    figure title font-weight=normal
	==========================================================-->
	<xsl:template match="*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')]">
        <fo:block space-before="0pt" space-after="3.5pt">
		    <xsl:attribute name="margin-left">
				<xsl:choose>
					<xsl:when test="parent::*[contains(@class,' topic/fig ')]/parent::*[contains(@class,' topic/li ')]">
					   <xsl:value-of select="'-5mm'"/>
					</xsl:when>
					<xsl:when test="parent::*[contains(@class,' topic/fig ')]/parent::*[contains(@class,' task/info ')]">
					   <xsl:value-of select="'-5mm'"/>
					</xsl:when>
					<xsl:otherwise>
					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Figure.title'"/>
                <xsl:with-param name="params">
                    <number>
                        <xsl:value-of select="ancestor::*[contains (@class, ' topic/topic ')][1]/@chapter_number"/>-<xsl:apply-templates select="." mode="fig.title-number"/>
                    </number>
                    <title>
                        <xsl:apply-templates/>
                    </title>
                </xsl:with-param>
            </xsl:call-template>
        </fo:block>
    </xsl:template>
	
</xsl:stylesheet>	
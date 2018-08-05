<?xml version='1.0'?>

<!--=========================================================================
	This file is part of the DITA Open Toolkit project hosted on Sourceforge.net. 
	See the accompanying license.txt file for applicable licenses.
	=========================================================================-->

<!-- Elements for steps have been relocated to task-elements.xsl -->
<!-- Templates for <dl> are in tables.xsl -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

	<xsl:strip-space elements="ul ol li" />
	
<!--===============================================================
	unordered Lists
	===============================================================-->
    <xsl:template match="*[contains(@class, ' topic/ul ')]">
	    <xsl:param name="p_level">
		   <xsl:choose>
		       <xsl:when test="parent::li or ancestor::li">
			      <xsl:value-of select="'Y'"/>
			   </xsl:when>
			   <xsl:otherwise>
			      <xsl:value-of select="'N'"/>
			   </xsl:otherwise>
		   </xsl:choose>
		</xsl:param>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
        <fo:list-block xsl:use-attribute-sets="ul">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates>
			   <xsl:with-param name="p_level" select="$p_level"/>
			</xsl:apply-templates>
			
        </fo:list-block>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>
  
    <xsl:template match="*[contains(@class, ' topic/ul ')]/*[contains(@class, ' topic/li ')]">
	    <xsl:param name="p_level"/>
	    <xsl:variable name="v_leve_type">
			<xsl:choose><!--Unicode Character 'BLACK rhombus ' -->
			    <xsl:when test="$p_level='Y'">
				     <xsl:value-of select="normalize-space('&#9830;')"/> 
				</xsl:when>
				<xsl:otherwise><!--Unicode Character 'BLACK SQUARE ' -->   
					 <xsl:value-of select="normalize-space('&#9632;')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
        <fo:list-item xsl:use-attribute-sets="ul.li">
            <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="flag-attributes"/>
            <fo:list-item-label  xsl:use-attribute-sets="ul.li__label">
                <fo:block font-weight="normal" font-style="normal"><fo:inline><xsl:value-of select="normalize-space($v_leve_type)"/></fo:inline></fo:block>
            </fo:list-item-label>
            <fo:list-item-body xsl:use-attribute-sets="ul.li__body">
                <fo:block xsl:use-attribute-sets="ul.li__content">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>
<!--===============================================================
	ordered Lists
	===============================================================-->    
    <xsl:template match="*[contains(@class, ' topic/ol ')]">
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
        <fo:list-block xsl:use-attribute-sets="ol">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:list-block>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>
      
    <xsl:template match="*[contains(@class, ' topic/ol ')]/*[contains(@class, ' topic/li ')]">
        <fo:list-item xsl:use-attribute-sets="ol.li">
          <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="flag-attributes"/>
            <fo:list-item-label xsl:use-attribute-sets="ol.li__label">
                <fo:block xsl:use-attribute-sets="ol.li__label__content">
                    <fo:inline>
                        <xsl:call-template name="commonattributes"/>
                    </fo:inline>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Ordered List Number'"/>
                        <xsl:with-param name="params">
                            <number>
                                <xsl:choose>
                                    <xsl:when test="parent::*[contains(@class, ' topic/ol ')]/parent::*[contains(@class, ' topic/li ')]/parent::*[contains(@class, ' topic/ol ')]">
                                        <xsl:number format="a"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:number/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </number>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body xsl:use-attribute-sets="ol.li__body">
                <fo:block xsl:use-attribute-sets="ol.li__content">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>
  
</xsl:stylesheet>
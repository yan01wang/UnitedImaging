<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic-mapmerge="http://www.idiominc.com/opentopic/mapmerge"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="dita-ot opentopic-mapmerge opentopic-func related-links xs"
    version="2.0">
	
	
    <xsl:template match="*[contains(@class,' topic/xref ')]" name="topic.xref">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
      
		<xsl:variable name="destination" select="opentopic-func:getDestinationId(@href)"/>
		<xsl:variable name="element" select="key('key_anchor',$destination, $root)[1]"/>

		<xsl:variable name="referenceTitle" as="node()*">
		  <xsl:apply-templates select="." mode="insertReferenceTitle">
			<xsl:with-param name="href" select="@href"/>
			<xsl:with-param name="titlePrefix" select="''"/>
			<xsl:with-param name="destination" select="$destination"/>
			<xsl:with-param name="element" select="$element"/>
		  </xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="v_id" select="@href"/>	
		
		<xsl:variable name="v_targetid" select="substring-after($v_id,'#')"/>
		
		<xsl:variable name="v_value">
		    <xsl:choose>
		        <xsl:when test="contains($v_targetid,'/')">
				    <xsl:value-of select="substring-before($v_targetid,'/')"/>
				</xsl:when>
				<xsl:otherwise>
				    <xsl:value-of select="$v_targetid"/>
				</xsl:otherwise>
		    </xsl:choose> 
	    </xsl:variable>
		 
		<xsl:variable name="v_chapnbr">
		    <xsl:value-of select="/*//*[contains(@class,' topic/topic ')][@id=$v_value]/@chapter_number"/>
		</xsl:variable>

		<fo:basic-link xsl:use-attribute-sets="xref">
		  <xsl:call-template name="buildBasicLinkDestination">
			<xsl:with-param name="scope" select="@scope"/>
			<xsl:with-param name="format" select="@format"/>
			<xsl:with-param name="href" select="@href"/>
			<xsl:with-param name="chapnbr" select="$v_chapnbr"/>
		  </xsl:call-template>
          <xsl:apply-templates/>
		  <!--<xsl:choose>
			<xsl:when test="not(@scope = 'external' or not(empty(@format) or  @format = 'dita')) and exists($referenceTitle)">
			  <xsl:copy-of select="$referenceTitle"/>
			</xsl:when>
			<xsl:when test="not(@scope = 'external' or not(empty(@format) or  @format = 'dita'))">
			  <xsl:call-template name="insertPageNumberCitation">
				<xsl:with-param name="isTitleEmpty" select="true()"/>
				<xsl:with-param name="destination" select="$destination"/>
				<xsl:with-param name="element" select="$element"/>
			  </xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:choose>
				<xsl:when test="*[not(contains(@class,' topic/desc '))] | text()">
				  <xsl:apply-templates select="*[not(contains(@class,' topic/desc '))] | text()" />
				</xsl:when>
				<xsl:otherwise>
				  <xsl:value-of select="@href"/>
				</xsl:otherwise>
			  </xsl:choose>
			</xsl:otherwise>
		  </xsl:choose>-->
		</fo:basic-link>
    </xsl:template>

    <!-- xref to footnote makes a callout. -->
    <xsl:template match="*[contains(@class,' topic/xref ')][@type='fn']" priority="2">
        <xsl:variable name="href-fragment" select="substring-after(@href, '#')"/>
        <xsl:variable name="elemId" select="substring-after($href-fragment, '/')"/>
        <xsl:variable name="topicId" select="substring-before($href-fragment, '/')"/>
        <xsl:variable name="footnote-target" select="key('fnById', $elemId)[ancestor::*[contains(@class, ' topic/topic ')][1]/@id = $topicId]"/>
        <xsl:apply-templates select="$footnote-target" mode="footnote-callout"/>
    </xsl:template>
	
	<xsl:template name="buildBasicLinkDestination">
        <xsl:param name="scope" select="@scope"/>
        <xsl:param name="format" select="@format"/>
        <xsl:param name="href" select="@href"/>
		<xsl:param name="chapnbr"/>
        <xsl:choose>
            <xsl:when test="(contains($href, '://') and not(starts-with($href, 'file://')))
            or starts-with($href, '/') or $scope = 'external' or not(empty($format) or  $format = 'dita')">
                <xsl:attribute name="external-destination">
                    <xsl:text>url('</xsl:text>
                    <xsl:value-of select="$href"/>
                    <xsl:text>')</xsl:text>
                </xsl:attribute>
            </xsl:when>
          <xsl:when test="$scope = 'peer'">
            <xsl:attribute name="internal-destination">
              <xsl:value-of select="$href"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="contains($href, '#')">
		    <xsl:variable name="v_id">
			    <xsl:value-of select="opentopic-func:getDestinationId($href)"/>
			</xsl:variable>
            <xsl:attribute name="internal-destination">
              <xsl:value-of select="opentopic-func:getDestinationId($href)"/>
            </xsl:attribute>
			<xsl:call-template name="getVariable">
				<xsl:with-param name="id" select="'On the page'"/>
				<xsl:with-param name="params">
					<pagenum>
						<fo:inline>
							<xsl:value-of select="$chapnbr"/>-<fo:page-number-citation ref-id="{$v_id}"/>
						</fo:inline>
					</pagenum>
				</xsl:with-param>
			</xsl:call-template><xsl:text> </xsl:text><xsl:text> </xsl:text>
			 <!--第<fo:page-number-citation ref-id="{$v_id}"/>页-->
          </xsl:when>         
            <xsl:otherwise>
              <!-- Appears that topicmerge updates links so that this section will never be triggered; 
                   keeping $href as backup value in case something goes wrong. -->
              <xsl:attribute name="internal-destination">
                <xsl:value-of select="$href"/>
              </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="insertPageNumberCitation">
        <xsl:param name="isTitleEmpty" as="xs:boolean" select="false()"/>
        <xsl:param name="destination" as="xs:string"/>
        <xsl:param name="element" as="element()?"/>

        <xsl:choose>
            <xsl:when test="not($element) or ($destination = '')"/>
            <xsl:when test="$isTitleEmpty">
                <fo:inline>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Page'"/>
                        <xsl:with-param name="params">
                            <pagenum>
                                <fo:inline>
                                    <fo:page-number-citation ref-id="{$destination}"/>
                                </fo:inline>
                            </pagenum>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:inline>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'On the page'"/>
                        <xsl:with-param name="params">
                            <pagenum>
                                <fo:inline>
                                    <fo:page-number-citation ref-id="{$destination}"/>
                                </fo:inline>
                            </pagenum>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:inline>
				
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/related-links ')]"></xsl:template>
	
	<xsl:template match="*[contains(@class,' topic/link ')]"></xsl:template>

</xsl:stylesheet>
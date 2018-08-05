<?xml version='1.0'?>

<!--======================================================
	This file is part of the DITA Open Toolkit project. 
	Indexlist 
	======================================================-->

<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:comparer="com.idiominc.ws.opentopic.xsl.extension.CompareStrings"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    exclude-result-prefixes="xs opentopic-index comparer opentopic-func ot-placeholder">

  <xsl:variable name="index.continued-enabled" select="true()"/>
    <!-- *************************************************************** -->
    <!-- Create index templates                                          -->
    <!-- *************************************************************** -->  
	<xsl:template match="/" mode="index-postprocess">
	    <fo:block id="{$id.index}">
		    <xsl:apply-templates select="//opentopic-index:index.groups" mode="index-postprocess"/>
		</fo:block>	
	</xsl:template>
	
	<xsl:template match="opentopic-index:index.groups" mode="index-postprocess">
		<xsl:apply-templates mode="index-postprocess"/>
	</xsl:template>

    <xsl:template match="opentopic-index:index.group[opentopic-index:index.entry]" mode="index-postprocess">
		<fo:block xsl:use-attribute-sets="index.entry" >
		  <xsl:apply-templates mode="index-postprocess"/>
		</fo:block>
    </xsl:template>

	<xsl:template match="/*//topic//opentopic-index:index.entry" mode="test">
	    <xsl:param name="p_index_entry" select="//opentopic-index:index.groups//opentopic-index:index.entry/@value"/>
		<xsl:param name="p_label" select="ancestor::*[contains(@class, ' topic/topic ')]/@chapter_number"/>
		<xsl:variable name="value" select="@value"/>
		<fo:block>	   
		   <xsl:value-of select="$p_label"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="opentopic-index:formatted-value" mode="test">
	
	</xsl:template>
	
	<xsl:template match="opentopic-index:index.entry" mode="index-postprocess"> 
		<xsl:param name="value" select="child::opentopic-index:refID/@value"/>
        <xsl:param name="p_chapnbr">   
			<xsl:value-of select="/*//*[contains(@class,' topic/topic ')][descendant::opentopic-index:index.entry/opentopic-index:refID/@value=$value]/@chapter_number"/>	
		</xsl:param>	
		<xsl:variable name="v_string" select="substring(normalize-space($p_chapnbr),1,1)"/>
		<xsl:variable name="markerName" as="xs:string"
		   select="concat('index-continued-', count(ancestor-or-self::opentopic-index:index.entry))"/>	
        		   
		<xsl:choose>
		  <xsl:when test="opentopic-index:index.entry">
			<fo:table>
			  <xsl:if test="$index.continued-enabled">
				<fo:table-header>
				  <fo:retrieve-table-marker retrieve-class-name="{$markerName}"
					  retrieve-position-within-table="last-starting"
				  />
				</fo:table-header>
			  </xsl:if>
			  <fo:table-body>
				<xsl:if test="$index.continued-enabled">
				  <fo:marker marker-class-name="{$markerName}"/>
				</xsl:if>
				<fo:table-row>
				  <fo:table-cell>
					<fo:block xsl:use-attribute-sets="index-indents" keep-with-next="always">
					  <xsl:if test="count(ancestor::opentopic-index:index.entry) > 0">
						<xsl:attribute name="keep-together.within-page">always</xsl:attribute>
					  </xsl:if>
					  <xsl:variable name="following-idx" select="following-sibling::opentopic-index:index.entry[@value = $value and opentopic-index:refID]"/>
					  <xsl:if test="count(preceding-sibling::opentopic-index:index.entry[@value = $value]) = 0">
						<xsl:variable name="page-setting" select=" (ancestor-or-self::opentopic-index:index.entry/@no-page | ancestor-or-self::opentopic-index:index.entry/@start-page)[last()]"/>
						<xsl:variable name="isNoPage" select=" $page-setting = 'true' and name($page-setting) = 'no-page' "/>
						<xsl:variable name="refID" select="opentopic-index:refID/@value"/>
						<xsl:choose>
						  <xsl:when test="$following-idx">
							<xsl:apply-templates select="." mode="make-index-ref">
							  <xsl:with-param name="idxs" select="opentopic-index:refID"/>
							  <xsl:with-param name="inner-text" select="opentopic-index:formatted-value"/>
							  <xsl:with-param name="no-page" select="$isNoPage"/>
				
							</xsl:apply-templates>
						  </xsl:when>
						  <xsl:otherwise>
							<xsl:variable name="isNormalChilds">
							  <xsl:for-each select="descendant::opentopic-index:index.entry">
								<xsl:variable name="currValue" select="@value"/>
								<xsl:variable name="currRefID" select="opentopic-index:refID/@value"/>
								<xsl:if test="opentopic-func:getIndexEntry($currValue,$currRefID)">
								  <xsl:text>true </xsl:text>
								</xsl:if>
							  </xsl:for-each>
							</xsl:variable>
							<xsl:if test="contains($isNormalChilds,'true ')">
							  <xsl:apply-templates select="." mode="make-index-ref">
								<xsl:with-param name="inner-text" select="opentopic-index:formatted-value"/>
								<xsl:with-param name="no-page" select="$isNoPage"/>
		
							  </xsl:apply-templates>
							</xsl:if>
						  </xsl:otherwise>
						</xsl:choose>
					  </xsl:if>
					</fo:block>
				  </fo:table-cell>
				</fo:table-row>
			  </fo:table-body>
			  <fo:table-body>
				<xsl:if test="$index.continued-enabled">
				  <fo:marker marker-class-name="{$markerName}">
					<fo:table-row>
					  <fo:table-cell>
						<fo:block xsl:use-attribute-sets="index-indents" keep-together="always">
						  <xsl:if test="true() or count(preceding-sibling::opentopic-index:index.entry[@value = $value]) = 0">
							<xsl:apply-templates select="opentopic-index:formatted-value/node()"/>
							<fo:inline font-style="italic">
							  <xsl:text> (</xsl:text>
							  <xsl:value-of select="$continuedValue"/>
							  <xsl:text>)</xsl:text>
							</fo:inline>
						  </xsl:if>
						</fo:block>
					  </fo:table-cell>
					</fo:table-row>
				  </fo:marker>
				</xsl:if>
				<fo:table-row>
				  <fo:table-cell>
					<fo:block xsl:use-attribute-sets="index.entry__content">
					  <xsl:apply-templates mode="index-postprocess"/>
					</fo:block>
				  </fo:table-cell>
				</fo:table-row>
			  </fo:table-body>
			</fo:table>
		  </xsl:when>
		  <xsl:otherwise>
			<fo:block xsl:use-attribute-sets="index-indents">
			  <xsl:if test="parent::opentopic-index:index.entry">
				<xsl:attribute name="start-indent">20mm</xsl:attribute>
			  </xsl:if>
			  <xsl:if test="count(ancestor::opentopic-index:index.entry) > 0">
				<xsl:attribute name="keep-together.within-page">always</xsl:attribute>
			  </xsl:if>
			  <xsl:variable name="following-idx" select="following-sibling::opentopic-index:index.entry[@value = $value and opentopic-index:refID]"/>
			  <xsl:if test="count(preceding-sibling::opentopic-index:index.entry[@value = $value]) = 0">
				<xsl:variable name="page-setting" select=" (ancestor-or-self::opentopic-index:index.entry/@no-page | ancestor-or-self::opentopic-index:index.entry/@start-page)[last()]"/>
				<xsl:variable name="isNoPage" select=" $page-setting = 'true' and name($page-setting) = 'no-page' "/>
				<xsl:apply-templates select="." mode="make-index-ref">
				  <xsl:with-param name="idxs" select="opentopic-index:refID"/>
				  <xsl:with-param name="inner-text" select="opentopic-index:formatted-value"/>
				  <xsl:with-param name="no-page" select="$isNoPage"/>
				  <xsl:with-param name="p_number" select="$v_string"/>
				</xsl:apply-templates>
			  </xsl:if>
			</fo:block>
			<fo:block xsl:use-attribute-sets="index.entry__content">
			  <xsl:apply-templates mode="index-postprocess"/>
			</fo:block>
		  </xsl:otherwise>
		</xsl:choose> 
    </xsl:template>

  <xsl:template name="make-index-ref">
    <xsl:param name="idxs" select="()"/>
    <xsl:param name="inner-text" select="()"/>
    <xsl:param name="no-page"/>
	<xsl:param name="p_number"/>
    <xsl:call-template name="output-message">
      <xsl:with-param name="id" select="'DOTX066W'"/>
      <xsl:with-param name="msgparams">%1=make-index-ref</xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="." mode="make-index-ref">
      <xsl:with-param name="idxs" select="$idxs"/>
      <xsl:with-param name="inner-text" select="$inner-text"/>
      <xsl:with-param name="no-page" select="$no-page"/>
	  <xsl:with-param name="p_number" select="$p_number"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*" mode="make-index-ref">
    
    <xsl:param name="idxs" select="()"/>
    <xsl:param name="inner-text" select="()"/>
    <xsl:param name="no-page"/>
	<xsl:param name="p_number"/>
	
    <fo:block id="{generate-id(.)}" xsl:use-attribute-sets="index.term">
      <xsl:if test="empty(preceding-sibling::opentopic-index:index.entry)">
        <xsl:attribute name="keep-with-previous">always</xsl:attribute>
      </xsl:if>
      <fo:inline>
        <xsl:apply-templates select="$inner-text/node()"/>
      </fo:inline>
      <!-- XXX: XEP has this, should base too? -->
      <!--
      <xsl:if test="$idxs">
        <xsl:for-each select="$idxs">
          <fo:inline id="{@value}"/>
        </xsl:for-each>
      </xsl:if>
      -->
      <xsl:if test="not($no-page)">
        <xsl:if test="$idxs">
          <xsl:copy-of select="$index.separator"/>
          <fo:index-page-citation-list>
            <xsl:for-each select="$idxs">
              <fo:index-key-reference ref-index-key="'{@value}'" font-style="italic" xsl:use-attribute-sets="__index__page__link">
			      <fo:index-page-number-prefix><fo:inline><xsl:value-of select="$p_number"/>-</fo:inline>
				  </fo:index-page-number-prefix>
			  </fo:index-key-reference>
            </xsl:for-each>
          </fo:index-page-citation-list>
        </xsl:if>
      </xsl:if>
      <xsl:if test="@no-page = 'true'">
        <xsl:apply-templates select="opentopic-index:see-childs" mode="index-postprocess"/>
      </xsl:if>
      <xsl:if test="empty(opentopic-index:index.entry)">
        <xsl:apply-templates select="opentopic-index:see-also-childs" mode="index-postprocess"/>
      </xsl:if>
    </fo:block>
  </xsl:template>
	
    <xsl:template name="createIndex">
        <xsl:if test="(//opentopic-index:index.groups//opentopic-index:index.entry) and (count($index-entries//opentopic-index:index.entry) &gt; 0)">
            <xsl:variable name="index">
                <xsl:choose>
                    <xsl:when test="$map//*[contains(@class,' bookmap/indexlist ')][@href]"/>
                    <xsl:when test="$map//*[contains(@class,' bookmap/indexlist ')]">
                        <xsl:apply-templates select="/" mode="index-postprocess"/>
                    </xsl:when>
                    <xsl:when test="/*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                        <xsl:apply-templates select="/" mode="index-postprocess"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="count($index/*) > 0">
                <fo:page-sequence master-reference="index-sequence" format="I" initial-page-number="1" xsl:use-attribute-sets="page-sequence.index">
                    <fo:static-content flow-name="even-blank-body-header">
						 <fo:block border-bottom="0.5pt solid black" padding-bottom="5pt" text-align="left" font-size="10pt">
							<xsl:call-template name="getVariable">
								<xsl:with-param name="id" select="'Index'"/>
							</xsl:call-template>
						</fo:block>
						<fo:block space-before="2.5cm" text-align-last="center" font-size="12pt">
						    <xsl:call-template name="getVariable">
								<xsl:with-param name="id" select="'Blank page text'"/>
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
                    <xsl:call-template name="insertIndexStaticContents"/>
                    <fo:static-content flow-name="even-blank-body-footer">
						<fo:table font-size="9pt" xsl:use-attribute-sets="note__table">
							<fo:table-column column-number="1" column-width="50%"/>
							<fo:table-column column-number="2" column-width="50%"/>
							<fo:table-body>
								<fo:table-row border-top="1pt solid black">
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
                    <fo:flow flow-name="xsl-region-body">
                        <!--<fo:marker marker-class-name="current-header">
                          <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Index'"/>
                          </xsl:call-template>
                        </fo:marker>-->
                        <xsl:copy-of select="$index"/>
                    </fo:flow>

                </fo:page-sequence>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>    
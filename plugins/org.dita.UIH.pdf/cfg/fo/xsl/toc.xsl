<?xml version='1.0'?>

<!--toc.xsl file handle table -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    exclude-result-prefixes="xs opentopic opentopic-func ot-placeholder opentopic-index"
    version="2.0">
  
    <xsl:variable name="map" select="//opentopic:map"/>

    <xsl:template name="createTocHeader">
        <fo:block xsl:use-attribute-sets="__toc__header" id="{$id.toc}">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Table of Contents'"/>
            </xsl:call-template>
        </fo:block>
    </xsl:template>
	
<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="toc">
        <xsl:param name="include"/>		
		<xsl:param name="mapTopicref" select="key('map-id', @id)[1]"/>	
		<xsl:param name="v_chap_num">
			 <!--<xsl:apply-templates select="$mapTopicref" mode="tocPrefix"/>-->
			 <xsl:value-of select="count(ancestor::*[contains(@class, ' topic/topic ')]/preceding-sibling::*[contains(@class, ' topic/topic ')])-1"/>
			 <!--<xsl:number match="." format="1"/>-->
		</xsl:param> 
        <xsl:param name="v_w" select="count(preceding-sibling::*[contains(@class, ' topic/topic ')])+1"/>
		
        <xsl:variable name="topicLevel" as="xs:integer">
          <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>	
		
        <xsl:if test="$topicLevel &lt; $tocMaximumLevel">
            <xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
            <xsl:choose>
              <!-- In a future version, suppressing Notices in the TOC should not be hard-coded. -->
              <xsl:when test="$retain-bookmap-order and $mapTopicref/self::*[contains(@class, ' bookmap/notices ')]"/>
              <xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] and not(contains($mapTopicref,'版权') or contains($mapTopicref,'CopyRight'))">			
				
				<fo:block>
                    <xsl:attribute name="margin-left">
						<xsl:choose>
						   <xsl:when test="$topicLevel eq 1">2cm</xsl:when>
						   <xsl:otherwise>3cm</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:variable name="tocItemContent">
					  <fo:basic-link xsl:use-attribute-sets="__toc__link">
						<xsl:attribute name="internal-destination">
						  <xsl:call-template name="generate-toc-id"/>
						</xsl:attribute>
						<fo:list-block provisional-distance-between-start="45">
						    <fo:list-item>
							    <fo:list-item-label>
									<fo:block><!-- output chapter label -->
										<xsl:if test="$topicLevel eq 1">
											<xsl:variable name="topicref" select="key('map-id', ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id)"/>
											  <xsl:for-each select="$topicref">
												<xsl:apply-templates select="." mode="topicTitleNumber"/>
											  </xsl:for-each>
										</xsl:if>
										<xsl:if test="parent::*[contains(@class, ' topic/topic ')]">
										   <xsl:value-of select="$v_chap_num"/>.<xsl:value-of select="$v_w"/>
										</xsl:if>
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
								    <fo:block>
									    <xsl:choose>
										    <xsl:when test="$topicLevel eq 1">
											    <xsl:call-template name="getNavTitle" />
                                                <fo:leader leader-pattern="none"/>												
											</xsl:when>
											<xsl:otherwise>
											    <xsl:call-template name="getNavTitle" />
												<fo:leader xsl:use-attribute-sets="__toc__leader"/>
												<xsl:if test="$topicLevel eq 2">
												<xsl:value-of select="$v_chap_num"/><xsl:text>-</xsl:text>
												</xsl:if>
												<fo:page-number-citation>
												  <xsl:attribute name="ref-id">
													<xsl:call-template name="generate-toc-id"/>
												  </xsl:attribute>
												</fo:page-number-citation>
											</xsl:otherwise>
										</xsl:choose>										
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
					</fo:basic-link>
					</xsl:variable>
					<xsl:choose>
					  <xsl:when test="not($mapTopicref)">
						<xsl:apply-templates select="." mode="tocText">
						  <xsl:with-param name="tocItemContent" select="$tocItemContent"/>
						  <xsl:with-param name="currentNode" select="."/>

						</xsl:apply-templates>
					  </xsl:when>
					  <xsl:otherwise>
						<xsl:apply-templates select="$mapTopicref" mode="tocText">
						  <xsl:with-param name="tocItemContent" select="$tocItemContent"/>
						  <xsl:with-param name="currentNode" select="."/>
                         <!-- <xsl:with-param name="v_w" select="concat($v_chap_num,'.',$v_w)"/>-->
						</xsl:apply-templates>
					  </xsl:otherwise>
					</xsl:choose>
				</fo:block>
				
				<xsl:apply-templates mode="toc">
					<xsl:with-param name="include" select="'true'"/>	             		
				</xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="toc">
                     <xsl:with-param name="include" select="'true'"/>
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/chapter ')] |
                         *[contains(@class, ' bookmap/bookmap ')]/opentopic:map/*[contains(@class, ' map/topicref ')]" mode="tocPrefix" priority="-1">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Chapter'"/>
            <xsl:with-param name="params">
                <number>
                    <xsl:apply-templates select="." mode="topicTitleNumber"/>
                </number>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' bookmap/appendix ')]" mode="tocPrefix">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Appendix'"/>
            <xsl:with-param name="params">
                <number>
                    <xsl:apply-templates select="." mode="topicTitleNumber"/>
                </number>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' bookmap/part ')]" mode="tocPrefix">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Part'"/>
            <xsl:with-param name="params">
                <number>
                    <xsl:apply-templates select="." mode="topicTitleNumber"/>
                </number>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' bookmap/preface ')]" mode="tocPrefix">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Preface'"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' bookmap/notices ')]" mode="tocPrefix">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Notices'"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="node()" mode="tocPrefix" priority="-10"/>
  
    <!-- book toc chapter title -->
    <xsl:template match="*[contains(@class, ' bookmap/chapter ')] |
                         opentopic:map/*[contains(@class, ' map/topicref ')]" mode="tocText" priority="-1">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
        <xsl:for-each select="$currentNode">
          <fo:block xsl:use-attribute-sets="__chaptertoc__content">
              <xsl:copy-of select="$tocItemContent"/>
          </fo:block>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' bookmap/appendix ')]" mode="tocText">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
        <xsl:for-each select="$currentNode">
          <fo:block xsl:use-attribute-sets="__toc__appendix__content">
              <xsl:copy-of select="$tocItemContent"/>
          </fo:block>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' bookmap/part ')]" mode="tocText">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
        <xsl:for-each select="$currentNode">
          <fo:block xsl:use-attribute-sets="__toc__part__content">
              <xsl:copy-of select="$tocItemContent"/>
          </fo:block>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' bookmap/preface ')]" mode="tocText">
 
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' bookmap/notices ')]" mode="tocText">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
        <xsl:for-each select="$currentNode">
          <fo:block xsl:use-attribute-sets="__toc__notices__content">
              <xsl:copy-of select="$tocItemContent"/>
          </fo:block>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="node()" mode="tocText" priority="-10">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
        <xsl:for-each select="$currentNode">
          <fo:block xsl:use-attribute-sets="__toc__topic__content">
              <xsl:copy-of select="$tocItemContent"/>
          </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="node()" mode="toc">
        <xsl:param name="include"/>
        <xsl:apply-templates mode="toc">
            <xsl:with-param name="include" select="$include"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template name="createToc">
	    <xsl:param name="p_chapter_number"/>
	    <xsl:param name="p_manual_name" select="//opentopic:map/title"/>
      <xsl:if test="$generate-toc">
        <xsl:variable name="toc">
            <xsl:choose>
                <xsl:when test="$map//*[contains(@class,' bookmap/toc ')][@href]"/>
                <xsl:when test="$map//*[contains(@class,' bookmap/toc ')]">
                    <xsl:apply-templates select="/" mode="toc"/>
                </xsl:when>
                <xsl:when test="/*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                    <xsl:apply-templates select="/" mode="toc"/>
                    <xsl:call-template name="toc.index"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="count($toc/*) > 0">
            <fo:page-sequence master-reference="toc-sequence" format="I" initial-page-number="1" xsl:use-attribute-sets="page-sequence.toc" id="{$id.toc}">
                <fo:static-content flow-name="even-blank-body-header">
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
				<xsl:call-template name="insertTocStaticContents">		     
				   <xsl:with-param name="p_chapter_number" select="$p_chapter_number"/>
				   <xsl:with-param name="p_manual_name" select="$p_manual_name"/>
				</xsl:call-template>
				<fo:static-content flow-name="even-blank-body-footer">
					<fo:table>
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
                    <!--<xsl:call-template name="createTocHeader"/>-->
                    <fo:block>
                        <fo:marker marker-class-name="current-header">
                          <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Table of Contents'"/>
                          </xsl:call-template>
                        </fo:marker>
                        <xsl:copy-of select="$toc"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </xsl:if>
      </xsl:if>
    </xsl:template>

    <xsl:template name="processTocList">
	    <xsl:param name="p_chapter_number"/>
		<xsl:param name="p_manual_name"/>
        <fo:page-sequence master-reference="toc-sequence" xsl:use-attribute-sets="page-sequence.toc">
            <xsl:call-template name="insertTocStaticContents">
			    <xsl:with-param name="p_chapter_number" select="$p_chapter_number"/>
				<xsl:with-param name="p_manual_name" select="$p_manual_name"/>
			</xsl:call-template>
				
            <fo:flow flow-name="xsl-region-body">
                <xsl:call-template name="createTocHeader"/>
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

  <xsl:template match="ot-placeholder:toc[$retain-bookmap-order]">
    <xsl:call-template name="createToc"/>
  </xsl:template>
  

</xsl:stylesheet>

<?xml version='1.0'?>

<!--
This file is part of the DITA Open Toolkit project. 
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:opentopic="http://www.idiominc.com/opentopic"
                xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
                xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
                xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
                exclude-result-prefixes="xs opentopic-index opentopic opentopic-func ot-placeholder"
                version="2.0">
    <xsl:variable name="map" select="//opentopic:map"/>

	<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="bookmark">
	    <xsl:param name="v_number">
		   <xsl:value-of select="count(preceding-sibling::*[contains(@class, 'topic/topic')])-1"/>
		</xsl:param>
        <xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
		<xsl:variable name="topicType">
		     <xsl:call-template name="determineTopicType"/>
		</xsl:variable>
		
        <xsl:variable name="topicLevel" as="xs:integer">
          <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
	    
        <xsl:variable name="topicTitle">
            <xsl:call-template name="getNavTitle"/>
        </xsl:variable>
	    <xsl:if test="$topicLevel &lt; $p_book_Level">
        <xsl:choose>
          <xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] and not(contains($mapTopicref,'版权') or contains($mapTopicref,'CopyRight'))">
		    <xsl:choose>
			    <xsl:when test="parent::*[contains(@class, ' bookmap/bookmap ')]">				   
				    <fo:bookmark>
						<xsl:attribute name="internal-destination">
							<xsl:call-template name="generate-toc-id"/>
						</xsl:attribute>
							<xsl:if test="$bookmarkStyle!='EXPANDED'">
								<xsl:attribute name="starting-state">hide</xsl:attribute>
							</xsl:if>
						<fo:bookmark-title>
						<xsl:if test="not($topicType='topicPreface')">
							<xsl:value-of select="$v_number"/><xsl:text> </xsl:text>
						</xsl:if>	
							<xsl:value-of select="normalize-space($topicTitle)"/>
						</fo:bookmark-title>
						<xsl:apply-templates mode="bookmark">
						   <xsl:with-param name="v_number" select="$v_number"/>
						</xsl:apply-templates>
					</fo:bookmark>
				</xsl:when>
                <xsl:otherwise>		
				    <xsl:variable name="v_topic_num">
					     <xsl:value-of select="count(preceding-sibling::*[contains(@class, 'topic/topic')])+1"/>
					</xsl:variable>
					<fo:bookmark>
						<xsl:attribute name="internal-destination">
							<xsl:call-template name="generate-toc-id"/>
						</xsl:attribute>
							<xsl:if test="$bookmarkStyle!='EXPANDED'">
								<xsl:attribute name="starting-state">hide</xsl:attribute>
							</xsl:if>
						<fo:bookmark-title>					
							<!--<xsl:value-of select="$vv"/>--><xsl:value-of select="$v_number"/>.<xsl:value-of select="$v_topic_num"/><xsl:text> </xsl:text>
							<xsl:value-of select="normalize-space($topicTitle)"/>
						</fo:bookmark-title>
						<xsl:apply-templates mode="bookmark">
						   <xsl:with-param name="v_number" select="concat($v_number,'.',$v_topic_num)"/>
						</xsl:apply-templates>
					</fo:bookmark>
				</xsl:otherwise>		
			</xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="bookmark"/>
          </xsl:otherwise>
        </xsl:choose>
		</xsl:if>
    </xsl:template>
	
    <xsl:template name="createBookmarks">
      <xsl:variable name="bookmarks" as="element()*">
        <xsl:choose>
          <xsl:when test="$retain-bookmap-order">
            <xsl:apply-templates select="/" mode="bookmark"/>
          </xsl:when>
          <xsl:otherwise> 
		    <!-- handling preface -->
            <xsl:for-each select="/*/*[contains(@class, ' topic/topic ')]">
              <xsl:variable name="topicType">
                <xsl:call-template name="determineTopicType"/>
              </xsl:variable>
              <xsl:if test="$topicType = 'topicPreface'">
                <xsl:apply-templates select="." mode="bookmark"/>
              </xsl:if>
            </xsl:for-each>	  
			<!-- handling toc -->
            <xsl:choose>
                <xsl:when test="$map//*[contains(@class,' bookmap/toc ')][@href]"/>
                <xsl:when test="$map//*[contains(@class,' bookmap/toc ')]
                              | /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                    <fo:bookmark internal-destination="{$id.toc}">
                        <fo:bookmark-title>
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Table of Contents'"/>
                            </xsl:call-template>
                        </fo:bookmark-title>
                    </fo:bookmark>
                </xsl:when>
            </xsl:choose>
            <!-- handling tablelist/figurelist/chapter items  -->
            <xsl:for-each select=" /*/*[contains(@class, ' topic/topic ')]|
			                      /*/ot-placeholder:glossarylist |
                                  /*/ot-placeholder:tablelist |
                                  /*/ot-placeholder:figurelist">
              <xsl:variable name="topicType">
                <xsl:call-template name="determineTopicType"/>
              </xsl:variable>		
			  <xsl:if test="not($topicType = 'topicNotices') and not($topicType = 'topicPreface') and not($topicType = 'copyright')">
				<xsl:apply-templates select="." mode="bookmark"/>
			  </xsl:if>			  
            </xsl:for-each>
            <xsl:apply-templates select="/*" mode="bookmark-index"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="exists($bookmarks)">
        <fo:bookmark-tree>
          <xsl:copy-of select="$bookmarks"/>
        </fo:bookmark-tree>
      </xsl:if>
    </xsl:template>

    <xsl:template match="ot-placeholder:toc[$retain-bookmap-order]" mode="bookmark">
        <fo:bookmark internal-destination="{$id.toc}">
            <xsl:if test="$bookmarkStyle!='EXPANDED'">
                <xsl:attribute name="starting-state">hide</xsl:attribute>
            </xsl:if>
            <fo:bookmark-title>
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Table of Contents'"/>
                </xsl:call-template>
            </fo:bookmark-title>
        </fo:bookmark>
    </xsl:template>
    
    <xsl:template match="ot-placeholder:indexlist[$retain-bookmap-order]" mode="bookmark">
        <fo:bookmark internal-destination="{$id.index}">
            <xsl:if test="$bookmarkStyle!='EXPANDED'">
                <xsl:attribute name="starting-state">hide</xsl:attribute>
            </xsl:if>
            <fo:bookmark-title>
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Index'"/>
                </xsl:call-template>
            </fo:bookmark-title>
        </fo:bookmark>
    </xsl:template>
    
    <xsl:template match="ot-placeholder:glossarylist" mode="bookmark">
        <fo:bookmark internal-destination="{$id.glossary}">
            <xsl:if test="$bookmarkStyle!='EXPANDED'">
                <xsl:attribute name="starting-state">hide</xsl:attribute>
            </xsl:if>
            <fo:bookmark-title>
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'11Glossary'"/>
                </xsl:call-template>
            </fo:bookmark-title>
            
            <xsl:apply-templates mode="bookmark"/>
        </fo:bookmark>
    </xsl:template>
    
    <xsl:template match="ot-placeholder:tablelist" mode="bookmark">
        <xsl:if test="//*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ' )]">
            <fo:bookmark internal-destination="{$id.lot}">
                <xsl:if test="$bookmarkStyle!='EXPANDED'">
                    <xsl:attribute name="starting-state">hide</xsl:attribute>
                </xsl:if>
                <fo:bookmark-title>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'List of Tables'"/>
                    </xsl:call-template>
                </fo:bookmark-title>
                
                <xsl:apply-templates mode="bookmark"/>
            </fo:bookmark>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ot-placeholder:figurelist" mode="bookmark">
        <xsl:if test="//*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ' )]">
            <fo:bookmark internal-destination="{$id.lof}">
                <xsl:if test="$bookmarkStyle!='EXPANDED'">
                    <xsl:attribute name="starting-state">hide</xsl:attribute>
                </xsl:if>
                <fo:bookmark-title>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'List of Figures'"/>
                    </xsl:call-template>
                </fo:bookmark-title>               
                <xsl:apply-templates mode="bookmark"/>
            </fo:bookmark>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="bookmark-index">
      <xsl:if test="//opentopic-index:index.groups//opentopic-index:index.entry">
          <xsl:choose>
              <xsl:when test="$map//*[contains(@class,' bookmap/indexlist ')][@href]"/>
              <xsl:when test="$map//*[contains(@class,' bookmap/indexlist ')]
                            | /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                  <fo:bookmark internal-destination="{$id.index}" starting-state="hide">
                      <fo:bookmark-title>
                          <xsl:call-template name="getVariable">
                              <xsl:with-param name="id" select="'Index'"/>
                          </xsl:call-template>
                      </fo:bookmark-title>
                      <xsl:if test="$bookmarks.index-group-size !=0 and 
                                    count(//opentopic-index:index.groups//opentopic-index:index.entry) &gt; $bookmarks.index-group-size">
                        <xsl:apply-templates select="//opentopic-index:index.groups" mode="bookmark-index"/>
                      </xsl:if>
                  </fo:bookmark>
              </xsl:when>
          </xsl:choose>
      </xsl:if>
    </xsl:template>

    <xsl:template match="opentopic-index:index.groups" mode="bookmark-index">
      <xsl:apply-templates select="opentopic-index:index.group" mode="bookmark-index"/>
    </xsl:template>
    <xsl:template match="opentopic-index:index.group" mode="bookmark-index">
      <xsl:apply-templates select="opentopic-index:label" mode="bookmark-index"/>
    </xsl:template>
    <xsl:template match="opentopic-index:label" mode="bookmark-index">
      <!-- Letter headings in index are always collapsed, regardless of bookmarkStyle. -->
      <fo:bookmark internal-destination="{generate-id(.)}" starting-state="hide">
          <fo:bookmark-title>
            <xsl:value-of select="."/>
          </fo:bookmark-title>
      </fo:bookmark>
    </xsl:template>
	

</xsl:stylesheet>
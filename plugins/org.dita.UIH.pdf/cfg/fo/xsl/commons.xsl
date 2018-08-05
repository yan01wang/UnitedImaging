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
	  topic
	==========================================================-->
	<xsl:template match="*[contains(@class, ' topic/topic ')]">
	    <xsl:param name="p_chapter_title"/>
		<xsl:param name="p_chapter_number"/>
	    <xsl:param name="p_label" select="count(parent::*[contains(@class, ' topic/topic ')]/preceding-sibling::*[contains(@class,' topic/topic ')])-1"/>
		<xsl:variable name="topicType" as="xs:string">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$topicType = 'topicChapter'">
                <xsl:call-template name="processTopicChapter"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicAppendix'">
                <xsl:call-template name="processTopicAppendix"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicAppendices'">
                <xsl:call-template name="processTopicAppendices"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicPart'">
                <xsl:call-template name="processTopicPart"/>
            </xsl:when>
			<xsl:when test="$topicType = 'copyright'">
                <xsl:call-template name="processTopiccopyright"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicPreface'">
                <xsl:call-template name="processTopicPreface"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicNotices'">
                <xsl:if test="$retain-bookmap-order">
                  <xsl:call-template name="processTopicNotices"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$topicType = 'topicTocList'">
              <xsl:call-template name="processTocList"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicIndexList'">
              <xsl:call-template name="processIndexList"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicSimple'">
			  <xsl:variable name="v_label" select="count(preceding-sibling::*[contains(@class,' topic/topic ')])+1"/>
              <xsl:call-template name="processTopicSimple">
			     <xsl:with-param name="p_label" select="concat($p_label,'.',$v_label)"/>
				 <xsl:with-param name="p_chapter_title" select="$p_chapter_title"/>
				 <xsl:with-param name="p_chapter_number" select="$p_chapter_number"/>
			  </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                 <xsl:apply-templates select="." mode="processTopic"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]">
        <xsl:param name="p_label"/>
        <xsl:variable name="topicType" as="xs:string">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>
        <xsl:choose>
            <!--  Disable chapter title processing when mini TOC is created -->
            <xsl:when test="(topicType = 'topicChapter') or (topicType = 'topicAppendix')" />
            <!--   Normal processing         -->
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="processTopicTitle">
                    <xsl:with-param name="p_label" select="$p_label"/>
				</xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="processTopicTitle">
	    <xsl:param name="p_label"/>
        <xsl:variable name="level" as="xs:integer">
          <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
	
		<fo:block> 	    
            <xsl:attribute name="font-size">
				<xsl:choose>
				   <xsl:when test="$level = 2">
					   <xsl:value-of select="'15pt'"/>
				   </xsl:when>
				   <xsl:when test="$level = 3">
					  <xsl:value-of select="'14pt'"/>
				   </xsl:when>
				   <xsl:when test="$level = 4">
					  <xsl:value-of select="'12pt'"/>
				   </xsl:when>
				   <xsl:otherwise>
					  <xsl:value-of select="'10pt'"/>
				   </xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
            
            <xsl:attribute name="space-before">
				<xsl:choose>
				   <xsl:when test="$level = 2">
					   <xsl:value-of select="'20pt'"/>
				   </xsl:when>
				   <xsl:when test="$level = 3">
					  <xsl:value-of select="'20pt'"/>
				   </xsl:when>
				   <xsl:when test="$level = 4">
					  <xsl:value-of select="'16pt'"/>
				   </xsl:when>
				   <xsl:otherwise>
					  <xsl:value-of select="'15pt'"/>
				   </xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:attribute name="space-after">
				<xsl:choose>
				   <xsl:when test="$level = 2">
					   <xsl:value-of select="'10pt'"/>
				   </xsl:when>
				   <xsl:when test="$level = 3">
					  <xsl:value-of select="'10pt'"/>
				   </xsl:when>
				   <xsl:when test="$level = 4">
					  <xsl:value-of select="'9pt'"/>
				   </xsl:when>
				   <xsl:otherwise>
					  <xsl:value-of select="'5pt'"/>
				   </xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			 <xsl:attribute name="line-height">
				<xsl:choose>
				   <xsl:when test="$level = 2">
					   <xsl:value-of select="'25pt'"/>
				   </xsl:when>
				   <xsl:when test="$level = 3">
					  <xsl:value-of select="'20pt'"/>
				   </xsl:when>
				   <xsl:when test="$level = 4">
					  <xsl:value-of select="'20pt'"/>
				   </xsl:when>
				   <xsl:otherwise>					
				   </xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
            <fo:wrapper id="{parent::node()/@id}"/>
			<fo:wrapper>
				<xsl:attribute name="id">
					<xsl:call-template name="generate-toc-id">
						<xsl:with-param name="element" select=".."/>
					</xsl:call-template>
				</xsl:attribute>
			</fo:wrapper>		
			<fo:list-block provisional-distance-between-starts="17mm">
				<fo:list-item>
					<fo:list-item-label>
						<fo:block>
						   <xsl:value-of select="$p_label"/>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block> 
							<xsl:apply-templates select="." mode="getTitle"/><xsl:call-template name="pullPrologIndexTerms"/>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
    </xsl:template>

	<xsl:template match="*" mode="processUnknowTopic"
                name="processTopicSimple">
    <xsl:param name="topicType"/>
	<xsl:param name="p_label"/> 
    <xsl:param name="p_chapter_title"/>	
	<xsl:param name="p_chapter_number"/>
	<xsl:variable name="topicLevel" as="xs:integer">
	  <xsl:apply-templates select="." mode="get-topic-level"/>
	</xsl:variable>	 
	
	
    <xsl:variable name="page-sequence-reference" select="if ($mapType = 'bookmap') then 'body-sequence' else 'ditamap-body-sequence'"/>
	    <xsl:choose>
		    <xsl:when test="$topicLevel eq 2">			    
			    <fo:page-sequence master-reference="{$page-sequence-reference}" initial-page-number="auto">
                    <xsl:if test="following-sibling::*[contains(@class, ' topic/topic ')]">
					    <xsl:attribute name="force-page-count">
						      <xsl:value-of select="'no-force'"/>
						</xsl:attribute>
					</xsl:if>
					<fo:static-content flow-name="even-blank-body-header">
					    <fo:block border-bottom="0.5pt solid black" padding-bottom="5pt" text-align="left">
							<fo:inline font-size="10pt"><xsl:value-of select="$p_chapter_title"/></fo:inline><xsl:text> </xsl:text>|<xsl:text> </xsl:text><fo:inline font-size="9pt"><xsl:value-of select="child::title"/></fo:inline>								
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
				    <fo:static-content flow-name="odd-body-header">
						<fo:block border-bottom="0.5pt solid black" padding-bottom="5pt" text-align="right">
						     <fo:inline font-size="9pt"><xsl:value-of select="child::title"/></fo:inline><fo:inline color="#051C24"><xsl:text> </xsl:text>|<xsl:text> </xsl:text></fo:inline><fo:inline font-size="10pt"><xsl:value-of select="$p_chapter_title"/></fo:inline>								
						</fo:block>				
					</fo:static-content>
					<fo:static-content flow-name="even-body-header">
						<fo:block border-bottom="0.5pt solid black" padding-bottom="5pt" text-align="left">
							 <fo:inline font-size="10pt"><xsl:value-of select="$p_chapter_title"/></fo:inline><fo:inline color="#051C24"><xsl:text> </xsl:text>|<xsl:text> </xsl:text></fo:inline><fo:inline font-size="9pt"><xsl:value-of select="child::title"/></fo:inline>								
						</fo:block>
					</fo:static-content>
					<fo:static-content flow-name="odd-body-footer">
						<fo:table font-size="9pt">
							<fo:table-column column-number="1" column-width="70%"/>
							<fo:table-column column-number="2" column-width="30%"/>
							<fo:table-body>
								<fo:table-row border-top="0.5pt solid black">
									<fo:table-cell text-align="left" padding-top="5pt">
									    <fo:block>
										<fo:inline baseline-shift="-25%" font-size="125%"><xsl:value-of select="'&#xa9;'"/></fo:inline>
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
                    <fo:static-content flow-name="even-body-footer">
						<fo:table font-size="9pt" xsl:use-attribute-sets="note__table">
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
                    <fo:static-content flow-name="even-blank-body-footer">
						<fo:table font-size="9pt" xsl:use-attribute-sets="note__table">
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
				    <fo:flow flow-name="xsl-region-body">                       				
						<fo:block start-indent="12mm" id="@id">							    
							<xsl:apply-templates>
							   <xsl:with-param name="p_label" select="$p_label"/>
							</xsl:apply-templates>
						</fo:block>
				    </fo:flow>
				</fo:page-sequence>
			</xsl:when>
			<xsl:otherwise>
			    <xsl:apply-templates>
				     <xsl:with-param name="p_label" select="$p_label"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>			
  </xsl:template>
  
    <xsl:template match="*" mode="commonTopicProcessing">
        <xsl:apply-templates select="*[contains(@class, ' topic/title ')]"/>
       <!-- <xsl:apply-templates select="*[contains(@class, ' topic/prolog ')]"/>
        <xsl:apply-templates select="*[not(contains(@class, ' topic/title ')) and
                                       not(contains(@class, ' topic/prolog ')) and
                                       not(contains(@class, ' topic/topic '))]"/>-->
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
        <xsl:apply-templates select="." mode="topicEpilog"/>
    </xsl:template>
	
	
	<!--======================================================
	  frontmatter
	==========================================================-->
	<xsl:template match="*[contains(@class, ' bookmap/frontmatter ')]/*[contains(@class, ' topic/topic ')][1]" mode="determineTopicType">
        <xsl:text>copyright</xsl:text>
    </xsl:template>
	
	<!--======================================================
	  chapter toc processing  added by minnie 2015-05-03
	==========================================================-->
    <xsl:template match="*[contains(@class, ' bookmap/chapter ')]" mode="generatePageSequences">
	    <xsl:param name="p_id" select="key('topic-id', @id)"/>
	    <xsl:param name="chapter_number" select="count(preceding-sibling::*[contains(@class, ' bookmap/chapter ')])+1"/>
 
		<xsl:param name="p_chapter_title">
		    <xsl:choose>
			    <xsl:when test="@navtitle">
				    <xsl:value-of select="@navtitle"/>
				</xsl:when>
				<xsl:otherwise>	     	
					<xsl:value-of select="child::*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]"/>
				</xsl:otherwise>				
			</xsl:choose>
		</xsl:param>
		<xsl:for-each select="key('topic-id', @id)">
		     <xsl:call-template name="processChapterToc">
			     <xsl:with-param name="p_number" select="$chapter_number"/>
				 <xsl:with-param name="p_title" select="$p_chapter_title"/>
			 </xsl:call-template>
			<!--<fo:page-sequence master-reference="body-sequence" initial-page-number="auto" force-page-count="end-on-even">
                    <fo:static-content flow-name="even-last-body-header">
					    <fo:block border-bottom="1.0pt solid black" text-align="left">
							<fo:inline font-weight="bold"><xsl:value-of select="$p_chapter_title"/></fo:inline><xsl:text> </xsl:text>|<xsl:text> </xsl:text><xsl:value-of select="child::title"/>								
						</fo:block>
						<fo:block space-before="2.5cm" text-align-last="center" font-weight="bold" font-size="12pt"> 此页有意留为空白。</fo:block>
					</fo:static-content> 
				    <fo:static-content flow-name="even-last-body-footer">
						<fo:table xsl:use-attribute-sets="note__table">
							<fo:table-column column-number="1" column-width="50%"/>
							<fo:table-column column-number="2" column-width="50%"/>
							<fo:table-body>
								<fo:table-row border-top="1pt solid black">
									<fo:table-cell text-align="left" padding-top="3pt">
									   <fo:block><xsl:value-of select="$chapter_number"/>-<fo:page-number/></fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="right" padding-top="3pt">
									    <fo:block><xsl:value-of select="$p_manual_name"/></fo:block>
									</fo:table-cell>
								</fo:table-row>		
							</fo:table-body>	
						</fo:table>	
					</fo:static-content>					
				    <fo:flow flow-name="xsl-region-body">-->
					 <xsl:call-template name="processTopicChapter">
						 <xsl:with-param name="p_chapter_title" select="$p_chapter_title"/>
						 <xsl:with-param name="p_chapter_number" select="$chapter_number"/>
					 </xsl:call-template>
                   <!-- </fo:flow>					 
			</fo:page-sequence> -->
		</xsl:for-each>
	</xsl:template>

	<!--======================================================
	  topic/body
	==========================================================-->
	<xsl:template match="*[contains(@class,' topic/body ')]">
        <xsl:variable name="level" as="xs:integer">
          <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
        <xsl:choose>
                <xsl:when test="$level = 1">
                    <xsl:choose>
                        <xsl:when test="not(node())">
					    </xsl:when>
						<xsl:otherwise>
						    <fo:block xsl:use-attribute-sets="body__toplevel">
								<xsl:apply-templates/>
							</fo:block>
						</xsl:otherwise>
					</xsl:choose>	
                </xsl:when>
                <xsl:when test="$level = 2">
				    <xsl:choose>
                        <xsl:when test="not(node())">
					    </xsl:when>
						<xsl:otherwise>
						    <fo:block xsl:use-attribute-sets="body__secondLevel">
								<xsl:apply-templates/>
							</fo:block>
						</xsl:otherwise>
					</xsl:choose>                     
                </xsl:when>
                <xsl:otherwise>
				    <xsl:choose>
                        <xsl:when test="not(node())">
					    </xsl:when>
						<xsl:otherwise>
                            <fo:block xsl:use-attribute-sets="body">
								<xsl:apply-templates/>
							</fo:block>
						</xsl:otherwise>
					</xsl:choose>                     
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
	
	<!--======================================================
	 concept/conbody
	==========================================================-->
	<xsl:template match="*[contains(@class, ' concept/conbody ')]">
      <xsl:variable name="level" as="xs:integer">
        <xsl:apply-templates select="." mode="get-topic-level"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="not(node())"/>
        <xsl:when test="$level = 1">
		    <xsl:choose>
				<xsl:when test="not(node())">
				</xsl:when>
				<xsl:otherwise>
					<fo:block xsl:use-attribute-sets="body__toplevel conbody">
						<xsl:call-template name="commonattributes"/>
						<xsl:apply-templates/>
                    </fo:block>
				</xsl:otherwise>
			</xsl:choose>          
        </xsl:when>
        <xsl:when test="$level = 2">
		    <xsl:choose>
				<xsl:when test="not(node())">
				</xsl:when>
				<xsl:otherwise>
					<fo:block xsl:use-attribute-sets="body__secondLevel conbody">
						<xsl:call-template name="commonattributes"/>
						<xsl:apply-templates/>
					</fo:block>
				</xsl:otherwise>
			</xsl:choose>   
        </xsl:when>
        <xsl:otherwise>
		    <xsl:choose>
				<xsl:when test="not(node())">
				</xsl:when>
				<xsl:otherwise>
					<fo:block xsl:use-attribute-sets="conbody">
						<xsl:call-template name="commonattributes"/>
						<xsl:apply-templates/>
					</fo:block>
				</xsl:otherwise>
			</xsl:choose> 
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
	
	<!--======================================================
	 Bookmap Chapter processing
	==========================================================-->
    <xsl:template name="processTopicChapter">
	    <xsl:param name="p_chapter_number"/>
	    <xsl:param name="p_chapter_title"/>
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]">
		    <xsl:with-param name="p_chapter_title" select="$p_chapter_title"/>
			<xsl:with-param name="p_chapter_number" select="$p_chapter_number"/>
		</xsl:apply-templates>
		
    </xsl:template>
	
	<xsl:template name="processChapterToc">
	    <xsl:param name="p_number"/>
		<xsl:param name="p_title"/>
		<xsl:variable name="v_id">
		   <xsl:call-template name="generate-toc-id"/>
		</xsl:variable>
	    <fo:page-sequence master-reference="body-sequence" initial-page-number="1" force-page-count="auto" id="{$v_id}">
            <xsl:call-template name="insert_chapter_StaticContents">
			     <xsl:with-param name="p_chapter_number" select="$p_number"/>
			</xsl:call-template>		
			<fo:flow flow-name="xsl-region-body">		
				<xsl:apply-templates select="." mode="insertTopicHeaderMarker"/>
				<xsl:choose>
				  <xsl:when test="$chapterLayout='BASIC'">
					  <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
														 contains(@class, ' topic/prolog '))]"/>
					  <!--xsl:apply-templates select="." mode="buildRelationships"/-->
				  </xsl:when>
				  <xsl:otherwise>
					  <fo:block xsl:use-attribute-sets="chaptertoc_header">
						<fo:list-block start-indent="15mm" provisional-distance-between-starts="10mm">
						    <fo:list-item>
							    <fo:list-item-label>
								   <fo:block><xsl:value-of select="$p_number"/></fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
								   <fo:block><xsl:value-of  select="$p_title"/></fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block> 
					  </fo:block>
					  <xsl:apply-templates select="." mode="createMiniToc">
						 <xsl:with-param name="p_number" select="$p_number"/>
                         <xsl:with-param name="p_toc_number" select="$p_number"/>
						 <xsl:with-param name="p_chapter_number" select="$p_number"/>
					  </xsl:apply-templates>   
				  </xsl:otherwise>
				</xsl:choose>
			</fo:flow>
		</fo:page-sequence>	
	</xsl:template>
	
	<!--======================================================
	  Chapter toc processing
	==========================================================-->
	<xsl:template match="*" mode="createMiniToc">	
	    <xsl:param name="p_number"/>
		<xsl:param name="p_toc_number"/>
		<fo:block xsl:use-attribute-sets="chaptertoc_content">	    
			<xsl:apply-templates select="*[contains(@class, ' topic/topic ')]" mode="in-this-chapter-list">
			    <xsl:with-param name="p_number" select="$p_number"/>
				<xsl:with-param name="p_toc_number" select="$p_toc_number"/>
			</xsl:apply-templates>
		</fo:block>
    </xsl:template>
	
	<xsl:template name="generate-toc-id">
      <xsl:param name="element" select="."/>
      <xsl:value-of select="concat('_OPENTOPIC_TOC_PROCESSING_', generate-id($element))"/>
    </xsl:template>
	
	<xsl:template name="insertChapterFirstpageStaticContent">
        <xsl:param name="type" as="xs:string"/>
        <fo:block>
            <xsl:attribute name="id">
                <xsl:call-template name="generate-toc-id"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="$type = 'chapter'">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Chapter with number'"/>
                            <xsl:with-param name="params">
                                <number>
                                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                        <xsl:apply-templates select="key('map-id', @id)[1]" mode="topicTitleNumber"/>
                                    </fo:block>
                                </number>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>
                <xsl:when test="$type = 'appendix'">
                        <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Appendix with number'"/>
                                <xsl:with-param name="params">
                                    <number>
                                        <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                            <xsl:apply-templates select="key('map-id', @id)[1]" mode="topicTitleNumber"/>
                                        </fo:block>
                                    </number>
                                </xsl:with-param>
                            </xsl:call-template>
                        </fo:block>
                </xsl:when>
              <xsl:when test="$type = 'appendices'">
                <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                  <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Appendix with number'"/>
                    <xsl:with-param name="params">
                      <number>
                        <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                          <xsl:text>&#xA0;</xsl:text>
                        </fo:block>
                      </number>
                    </xsl:with-param>
                  </xsl:call-template>
                </fo:block>
              </xsl:when>
                <xsl:when test="$type = 'part'">
                        <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Part with number'"/>
                                <xsl:with-param name="params">
                                    <number>
                                        <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                            <xsl:apply-templates select="key('map-id', @id)[1]" mode="topicTitleNumber"/>
                                        </fo:block>
                                    </number>
                                </xsl:with-param>
                            </xsl:call-template>
                        </fo:block>
                </xsl:when>
				<xsl:when test="$type = 'copyright'">
                        <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'copyright'"/>
                            </xsl:call-template>
                        </fo:block>
                </xsl:when>
                <xsl:when test="$type = 'preface'">
                        <fo:block xsl:use-attribute-sets="preface.title">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Preface title'"/>
                            </xsl:call-template>
                        </fo:block>
                </xsl:when>
                <xsl:when test="$type = 'notices'">
                        <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Notices title'"/>
                            </xsl:call-template>
                        </fo:block>
                </xsl:when>
            </xsl:choose>
        </fo:block>
    </xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="in-this-chapter-list">
	     <xsl:param name="p_number"/>
		 <xsl:param name="p_toc_number"/>
		 <xsl:param name="include"/>
		 <xsl:param name="p_topicnumber" select="count(preceding-sibling::*[contains(@class, ' topic/topic ')])+1"/>
	
		 
		 <xsl:variable name="topicref" select="key('map-id', @id)[1]"/>
		
        <xsl:variable name="topicLevel" as="xs:integer">
          <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
        <xsl:if test="$topicLevel &lt; $chaptertocMaximumLevel">
            <xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
            <xsl:choose>
              <!-- In a future version, suppressing Notices in the TOC should not be hard-coded. -->
              <xsl:when test="$retain-bookmap-order and $mapTopicref/self::*[contains(@class, ' bookmap/notices ')]"/>
              <xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] or
                              (not($mapTopicref) and $include = 'true')">						  
                    <fo:block>					 				    
                        <xsl:variable name="tocItemContent">
                        <fo:basic-link xsl:use-attribute-sets="__toc__link">
                            <xsl:attribute name="internal-destination">
                              <xsl:call-template name="generate-toc-id"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="$mapTopicref" mode="tocPrefix"/>							
							<fo:list-block xsl:use-attribute-sets="chapter_toc2_toc3">
      							<fo:list-item>
									<fo:list-item-label>
									   <fo:block><xsl:value-of select="concat($p_number,'.',$p_topicnumber)"/></fo:block>
									</fo:list-item-label>
									<fo:list-item-body start-indent="body-start()">
									   <fo:block>
									        <xsl:call-template name="getNavTitle" />
									        <fo:inline xsl:use-attribute-sets="__toc__page-number">
												<fo:leader xsl:use-attribute-sets="__toc__leader"/>
												<xsl:value-of select="$p_toc_number"/>-<fo:page-number-citation>
												  <xsl:attribute name="ref-id">
													<xsl:call-template name="generate-toc-id"/>
												  </xsl:attribute>
												</fo:page-number-citation>
											</fo:inline>
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
                            </xsl:apply-templates>
                          </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                    <xsl:apply-templates mode="in-this-chapter-list">
                        <xsl:with-param name="include" select="'true'"/>
						<xsl:with-param name="p_number" select="concat($p_number,'.',$p_topicnumber)"/>
						<xsl:with-param name="p_toc_number" select="$p_toc_number"/>
                    </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="in-this-chapter-list">
                        <xsl:with-param name="include" select="'true'"/>
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
		 
    </xsl:template>
	
	<xsl:template match="node()" mode="in-this-chapter-list">
        <xsl:param name="include"/>
        <xsl:apply-templates mode="toc">
            <xsl:with-param name="include" select="$include"/>
        </xsl:apply-templates>
    </xsl:template>
	
	<xsl:template match="ot-placeholder:indexlist" mode="in-this-chapter-list" name="toc.index">
    
    </xsl:template>
    
    <xsl:template match="ot-placeholder:glossarylist" mode="in-this-chapter-list">
       
    </xsl:template>
    
    <xsl:template match="ot-placeholder:tablelist" mode="in-this-chapter-list">
       
    </xsl:template>
    
    <xsl:template match="ot-placeholder:figurelist" mode="in-this-chapter-list">
        
    </xsl:template>

    <xsl:template match="*[contains(@class, ' glossentry/glossentry ')]" mode="in-this-chapter-list" priority="10"/>
	
	<!--======================================================
	    note=danger/warning/caution/note/...
	    ==========================================================-->
	<xsl:template match="*[contains(@class,' topic/note ')]">
        <xsl:variable name="noteImagePath">
            <xsl:apply-templates select="." mode="setNoteImagePath"/>
        </xsl:variable>
		<xsl:variable name="v_overflow" select="@spectitle"/>
		<xsl:variable name="v_note_type">
		   <xsl:choose>
		       <xsl:when test="@type='danger'">
			       <xsl:value-of select="'Y'"/>
			   </xsl:when>
			   <xsl:when test="@type='warning'">
			       <xsl:value-of select="'Y'"/>
			   </xsl:when>
			    <xsl:when test="@type='caution'">
			       <xsl:value-of select="'Y'"/>
			   </xsl:when>
			    <xsl:when test="@type='note'">
			       <xsl:value-of select="'Y'"/>
			   </xsl:when>
			   <xsl:when test="@type='other'">
			       <xsl:value-of select="'other'"/>
			   </xsl:when>
			   <xsl:otherwise>
			       <xsl:value-of select="'N'"/>
			   </xsl:otherwise>
		   </xsl:choose>
		</xsl:variable>
		<xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/li ')])"/>
		<xsl:variable name="V_LANGUAGE">
			<xsl:choose>
				<xsl:when test="$DEFAULTLANG='en-US'">
					 <xsl:value-of select="'Y'"/>
				</xsl:when>
				<xsl:when test="$DEFAULTLANG='en-UK'">
					 <xsl:value-of select="'Y'"/>
				</xsl:when>
				<xsl:when test="$DEFAULTLANG='en'">
					 <xsl:value-of select="'Y'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>	
	<fo:block color="black">
	    <xsl:if test="preceding-sibling::note">
		    <xsl:attribute name="margin-top">
			    <xsl:value-of select="'10pt'"/>
			</xsl:attribute>
		</xsl:if>
	    <xsl:attribute name="margin-left">
		    <xsl:choose><!-- level1 列表内的note -->
				<xsl:when test="$level = 1">
			       <xsl:value-of select="'-5mm'"/>
			    </xsl:when><!-- level2 列表内的note -->
				<xsl:when test="$level = 2">
			       <xsl:value-of select="'-10mm'"/>
			    </xsl:when><!-- level3 列表内的note -->
				<xsl:when test="$level = 3">
			       <xsl:value-of select="'-15mm'"/>
			    </xsl:when> <!--task/step内的note -->
				<xsl:when test="parent::*[contains(@class,' task/info ')]/parent::*[contains(@class,' task/step ')]">
			       <xsl:value-of select="'-5mm'"/>
			    </xsl:when><!-- task/step/substep内的note -->
				<xsl:when test="parent::*[contains(@class,' task/info ')]/parent::*[contains(@class,' task/substep ')]">
			       <xsl:value-of select="'-5mm'"/>
			    </xsl:when>
				<xsl:otherwise>
				
				</xsl:otherwise>
		    </xsl:choose>
		</xsl:attribute>
        <xsl:choose>
            <xsl:when test="$v_note_type='Y'">
			    <fo:block>
				    <xsl:attribute name="margin-top">
					    <xsl:choose><!-- 2.3.1.2 -->
						    <xsl:when test="parent::li">
							    <xsl:value-of select="'-5pt'"/>
							</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					
				    <xsl:if test="$v_overflow='overflow'">
					    <xsl:attribute name="break-before">page</xsl:attribute>
					</xsl:if>			
                <fo:table border="1pt solid black">
                    <fo:table-column column-number="1" column-width="100%"/>
                    <fo:table-body start-indent="0">
                        <fo:table-row border-bottom="1pt solid black">    
                                <fo:table-cell relative-align="baseline" text-align="center" display-align="center" padding-top="5pt" padding-bottom="5pt" padding-right="5pt" padding-left="5pt">
								    <xsl:attribute name="background-color">
									   <xsl:choose>
										  <xsl:when test="@type='danger'">
											  <xsl:value-of select="'#E11A22'"/>
										  </xsl:when>
										  <xsl:when test="@type='caution'">
											  <xsl:value-of select="'#FFE600'"/>
										  </xsl:when>
										  <xsl:when test="@type='warning'">
											  <xsl:value-of select="'#FAA61A'"/>
										  </xsl:when>
										  <xsl:when test="@type='note'">
											  <xsl:value-of select="'#007AC0'"/>
										  </xsl:when>
										  <xsl:otherwise>
											   <xsl:value-of select="'withe'"/>
										  </xsl:otherwise>
									   </xsl:choose>
									</xsl:attribute>
                                    <fo:block text-align="center" font-size="12pt">
									    <!-- 处理C/W/N/D的粗体 -->
									    <xsl:if test="$V_LANGUAGE='Y'">
										    <xsl:attribute name="font-weight">
											    <xsl:value-of select="'bold'"/>
											</xsl:attribute>										
										</xsl:if>										    											
										<xsl:if test="@type !='note'">
											<fo:inline baseline-shift="12%"><fo:external-graphic content-width="6mm" content-height="6mm" src="url('{concat($artworkPrefix, $noteImagePath)}')" xsl:use-attribute-sets="image"/></fo:inline>
										</xsl:if>	
									
										<fo:inline>
											<xsl:choose>
												<xsl:when test="@type='note' or not(@type)">
													<fo:inline font-style="italic" color="white">													   
														<xsl:call-template name="getVariable">
															<xsl:with-param name="id" select="'Note'"/>
														</xsl:call-template>
													</fo:inline>
												</xsl:when>
												<xsl:when test="@type='caution'">
													<fo:inline>												    
														<xsl:call-template name="getVariable">
															<xsl:with-param name="id" select="'Caution'"/>
														</xsl:call-template>
													</fo:inline>
												</xsl:when>
												<xsl:when test="@type='danger'">
													<fo:inline>													    
														<xsl:call-template name="getVariable">
															<xsl:with-param name="id" select="'Danger'"/>
														</xsl:call-template>
													</fo:inline>
												</xsl:when>
												<xsl:when test="@type='warning'">												    
													<fo:inline>														
														<xsl:call-template name="getVariable">
															<xsl:with-param name="id" select="'Warning'"/>
														</xsl:call-template>
													</fo:inline>
												</xsl:when>												              												
											</xsl:choose>
										</fo:inline>
									</fo:block>
                                </fo:table-cell>     
                        </fo:table-row>
						<fo:table-row>
						    <fo:table-cell text-align="left" padding-top="5pt" padding-bottom="5pt" padding-right="5pt" padding-left="3pt">
							   <fo:block><xsl:apply-templates/></fo:block> 
							</fo:table-cell>
						</fo:table-row>
                    </fo:table-body>
                </fo:table>
                </fo:block>
		    </xsl:when>
            <xsl:when test="$v_note_type='other'">
			    <xsl:variable name="v_type">
				    <xsl:call-template name="getVariable">
						<xsl:with-param name="id" select="concat('other', ' Note Image Path')"/>
					</xsl:call-template>
				</xsl:variable>
					
				<fo:block margin-top="10pt" margin-bottom="10pt">
				    <xsl:if test="$v_overflow='overflow'">
					    <xsl:attribute name="break-before">page</xsl:attribute>
					</xsl:if>					
                <fo:table border="0" width="100%" background-color="#B0C6CD">
                    <fo:table-column column-number="1" column-width="9%"/>
					<fo:table-column column-number="2" column-width="91%"/>
                    <fo:table-body start-indent="0">
                        <fo:table-row>
						    <fo:table-cell text-align="left" display-align="center" padding-top="3pt" padding-bottom="3pt" padding-right="3pt" padding-left="3pt">
							    <fo:block>
							         <fo:external-graphic content-width="10mm" content-height="10mm" src="url('{concat($artworkPrefix, $v_type)}')" xsl:use-attribute-sets="image"/> 			
							   </fo:block>
							</fo:table-cell>
						    <fo:table-cell text-align="left" display-align="center" padding-top="3pt" padding-bottom="3pt" padding-right="3pt" padding-left="3pt">
					           <fo:block>  
                                <!-- 处理helpinfo的内容粗体 -->							   
							    <xsl:if test="$V_LANGUAGE='Y'">
								    <xsl:attribute name="font-weight">
									    <xsl:value-of select="'bold'"/>
									</xsl:attribute>
								</xsl:if>
							    <xsl:apply-templates/>
							   </fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>	
                </fo:block>
			</xsl:when>
			<xsl:otherwise>
			     <xsl:apply-templates mode="placeNoteContent"/>
			</xsl:otherwise>		
        </xsl:choose>	
	</fo:block>		
    </xsl:template>

	<xsl:template match="*" mode="placeNoteContent">
        <fo:block xsl:use-attribute-sets="note">
            <xsl:call-template name="commonattributes"/>
            <fo:inline xsl:use-attribute-sets="note__label">
                <xsl:choose>
                    <xsl:when test="@type='note' or not(@type)">
                        <fo:inline xsl:use-attribute-sets="note__label__note">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Note'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='notice'">
                        <fo:inline xsl:use-attribute-sets="note__label__notice">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Notice'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='tip'">
                        <fo:inline xsl:use-attribute-sets="note__label__tip">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Tip'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='fastpath'">
                        <fo:inline xsl:use-attribute-sets="note__label__fastpath">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Fastpath'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='restriction'">
                        <fo:inline xsl:use-attribute-sets="note__label__restriction">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Restriction'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='important'">
                        <fo:inline xsl:use-attribute-sets="note__label__important">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Important'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='remember'">
                        <fo:inline xsl:use-attribute-sets="note__label__remember">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Remember'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='attention'">
                        <fo:inline xsl:use-attribute-sets="note__label__attention">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Attention'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='caution'">
                        <fo:inline xsl:use-attribute-sets="note__label__caution">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Caution'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='danger'">
                        <fo:inline xsl:use-attribute-sets="note__label__danger">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Danger'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='warning'">
                        <fo:inline xsl:use-attribute-sets="note__label__danger">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Warning'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="@type='trouble'">
                      <fo:inline xsl:use-attribute-sets="note__label__trouble">
                        <xsl:call-template name="getVariable">
                          <xsl:with-param name="id" select="'Trouble'"/>
                        </xsl:call-template>
                      </fo:inline>
                    </xsl:when>                  
                    <xsl:when test="@type='other'">
                        <fo:inline xsl:use-attribute-sets="note__label__other">
                            <xsl:choose>
                                <xsl:when test="@othertype">
                                    <xsl:value-of select="@othertype"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>[</xsl:text>
                                    <xsl:value-of select="@type"/>
                                    <xsl:text>]</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:inline>
                    </xsl:when>
                </xsl:choose>
                <xsl:call-template name="getVariable">
                  <xsl:with-param name="id" select="'#note-separator'"/>
                </xsl:call-template>
            </fo:inline>
            <xsl:text>  </xsl:text>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
	
	<!--======================================================
	  tablelist/figurelist TOC
	==========================================================-->
	<xsl:template match="ot-placeholder:tablelist" name="createTableList">
		<xsl:if test="//*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ' )]">
		  <!--exists tables with titles-->
		  <fo:page-sequence master-reference="toc-sequence" format="I" initial-page-number="auto" xsl:use-attribute-sets="page-sequence.lot">
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
		    <xsl:call-template name="insertTocStaticContents"/>
		    <fo:static-content flow-name="even-blank-body-footer">
                <fo:table font-size="9pt" xsl:use-attribute-sets="note__table">
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
			<fo:flow flow-name="xsl-region-body">
			  <fo:block start-indent="0in">
				<xsl:call-template name="createLOTHeader"/>				
				<xsl:apply-templates select="//*[contains (@class, ' topic/table ')][child::*[contains(@class, ' topic/title ' )]]" mode="list.of.tables"/>
			  </fo:block>
			</fo:flow>
			
		  </fo:page-sequence>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ot-placeholder:figurelist" name="createFigureList">
      <xsl:if test="//*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ' )]">
        <!--exists figures with titles-->
        <fo:page-sequence master-reference="toc-sequence" format="I" initial-page-number="auto" xsl:use-attribute-sets="page-sequence.lof">
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
            <xsl:call-template name="insertTocStaticContents"/>
		    <fo:static-content flow-name="even-blank-body-footer">
                <fo:table xsl:use-attribute-sets="note__table">
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
          <fo:flow flow-name="xsl-region-body">
            <fo:block start-indent="0in">
              <xsl:call-template name="createLOFHeader"/>

              <xsl:apply-templates select="//*[contains (@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ' )]]" mode="list.of.figures"/>
            </fo:block>
          </fo:flow>

        </fo:page-sequence>
      </xsl:if>
    </xsl:template>
		
	<xsl:template match="*[contains (@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ' )]]" mode="list.of.figures"> 
    <!--<xsl:variable name="v_chapter_number">
	    <xsl:call-template name="getVariable">
		  <xsl:with-param name="id" select="'Figure.title'"/>
		  <xsl:with-param name="params">
			<title>
			  <xsl:apply-templates select="./*[contains(@class, ' topic/title ')]" mode="insert-text"/>
			</title>
		  </xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="v_string_before" select="substring-before($v_chapter_number,'-')"/>
	
	<xsl:variable name="v_string_after" select="substring-after($v_string_before,' ')"/>-->

    <fo:block xsl:use-attribute-sets="__lotf__indent">
      <fo:block xsl:use-attribute-sets="__lotf__content">
        <fo:basic-link xsl:use-attribute-sets="__toc__link">
          <xsl:attribute name="internal-destination">
            <xsl:call-template name="get-id"/>
          </xsl:attribute>
          
          <fo:inline xsl:use-attribute-sets="__lotf__title">
            <xsl:call-template name="getVariable">
              <xsl:with-param name="id" select="'Figure.title'"/>
              <xsl:with-param name="params">
			    <number>
				     <xsl:value-of select="ancestor::*[contains (@class, ' topic/topic ')][1]/@chapter_number"/>-<xsl:apply-templates select="child::title" mode="fig.title-number"/> <xsl:text>&#xA0;</xsl:text><xsl:text>&#xA0;</xsl:text>
				</number>
                <title>
                     <xsl:apply-templates select="./*[contains(@class, ' topic/title ')]" mode="insert-text"/>
                </title>
              </xsl:with-param>
            </xsl:call-template>
          </fo:inline>
          
          <fo:inline xsl:use-attribute-sets="__lotf__page-number">
            <fo:leader xsl:use-attribute-sets="__lotf__leader"/>
            <xsl:value-of select="ancestor::*[contains (@class, ' topic/topic ')][1]/@chapter_number"/>-<fo:page-number-citation>
              <xsl:attribute name="ref-id">
                <xsl:call-template name="get-id"/>
              </xsl:attribute>
            </fo:page-number-citation>
          </fo:inline>
          
        </fo:basic-link>
      </fo:block>
    </fo:block>
    </xsl:template>	

	<xsl:template match="*[contains (@class, ' topic/table ')][child::*[contains(@class, ' topic/title ' )]]" mode="list.of.tables">	
		<xsl:variable name="v_preceding" select="count(ancestor::*[contains (@class, ' topic/topic ')][@level='1']/preceding-sibling::*[contains (@class, ' topic/topic ')][@level='1']//table[child::title])"/>
		<xsl:variable name="v_position" select="position()"/>
		<xsl:variable name="v_value" select="number($v_position)- number($v_preceding)"/>
		<!--<xsl:variable name="v_first_node">
		   <xsl:value-of select="count(ancestor::*[contains (@class, ' topic/topic ')][@level='1']//table[child::title])"></xsl:value-of>
		</xsl:variable>
		
		<xsl:variable name="v_current_position">
		   <xsl:choose>
		      <xsl:when test="$v_first_node!='1'">
			    <xsl:value-of select="count(preceding-sibling::table[child::title])+1"/>
			  </xsl:when>
			  <xsl:otherwise><xsl:value-of select="$v_first_node"/></xsl:otherwise>
		   </xsl:choose>
		</xsl:variable>
		<xsl:variable name="v_preceding_position" select="number($v_current_position)-1"/>
		<xsl:variable name="v_current_number">
		<xsl:choose>
		    <xsl:when test="$v_level='1' and $v_chapnbr!=$v_preced_chapnbr">
			  <xsl:value-of select="number($v_current_position)-number($v_preceding_position)"/>
			</xsl:when>
			<xsl:otherwise>
			  
			</xsl:otherwise>
		</xsl:choose>	
		</xsl:variable>-->
		
		<fo:block xsl:use-attribute-sets="__lotf__indent">
		  <fo:block xsl:use-attribute-sets="__lotf__content">
		    
			<fo:basic-link xsl:use-attribute-sets="__toc__link">
			  <xsl:attribute name="internal-destination">
				<xsl:call-template name="get-id"/>
			  </xsl:attribute>
			  
			  <fo:inline xsl:use-attribute-sets="__lotf__title">
				<xsl:call-template name="getVariable">
				  <xsl:with-param name="id" select="'Table.title'"/>
				  <xsl:with-param name="params">  
				    <number>
				    @<xsl:value-of select="$v_value"/>@<xsl:value-of select="ancestor::*[contains (@class, ' topic/topic ')][1]/@chapter_number"/>-<xsl:value-of select="position()"/><xsl:text>&#xA0;</xsl:text><xsl:text>&#xA0;</xsl:text>
                    </number>
					<space> <xsl:text> </xsl:text> </space>
					<title>
					  <xsl:apply-templates select="./*[contains(@class, ' topic/title ')]" mode="insert-text"/>
					</title>
				  </xsl:with-param>
				</xsl:call-template>
			  </fo:inline>
			  
			  <fo:inline xsl:use-attribute-sets="__lotf__page-number">
				<fo:leader xsl:use-attribute-sets="__lotf__leader"/>
				<xsl:value-of select="ancestor::*[contains (@class, ' topic/topic ')][1]/@chapter_number"/>-<fo:page-number-citation>
				  <xsl:attribute name="ref-id">
					<xsl:call-template name="get-id"/>
				  </xsl:attribute>
				</fo:page-number-citation>
			  </fo:inline>
			  
			</fo:basic-link>
			<!--<xsl:for-each select="/bookmap/topic//table">
				<xsl:sort select="."/>
				<fo:inline color="red">
				  <xsl:number value="position()" format="1. "/>
				</fo:inline>
			</xsl:for-each>-->
		  </fo:block>
		</fo:block>
    </xsl:template>
	
	<xsl:template name="createLOFHeader">
		<fo:block xsl:use-attribute-sets="__lotf__heading" id="{$id.lof}">
		  <fo:marker marker-class-name="current-header">
			<xsl:call-template name="getVariable">
			  <xsl:with-param name="id" select="'List of Figures'"/>
			</xsl:call-template>
		  </fo:marker>
		</fo:block>
	</xsl:template>
  
    <xsl:template name="createLOTHeader">
		<fo:block xsl:use-attribute-sets="__lotf__heading" id="{$id.lot}">
		  <fo:marker marker-class-name="current-header">
			<xsl:call-template name="getVariable">
			  <xsl:with-param name="id" select="'List of Tables'"/>
			</xsl:call-template>
		  </fo:marker>
		</fo:block>
	</xsl:template>
	
	<!--======================================================
	    First page 
	==========================================================-->
	<xsl:template name="createFrontMatter">
      <xsl:if test="$generate-front-cover">
        <fo:page-sequence master-reference="front-matter" xsl:use-attribute-sets="page-sequence.cover">
		    <!-- remove this header from here -->
            <!--<xsl:call-template name="insertFrontMatterStaticContents"/>-->
            <fo:flow flow-name="xsl-region-body">
              <fo:block-container xsl:use-attribute-sets="__frontmatter">
                <xsl:call-template name="createFrontCoverContents"/>
              </fo:block-container>
            </fo:flow>
        </fo:page-sequence>
      </xsl:if>
    </xsl:template>
	
	<xsl:template name="createFrontCoverContents">
        <!-- set the title -->
		<fo:block xsl:use-attribute-sets="__frontmatter__title">
		  <xsl:choose>
			<xsl:when test="$map/*[contains(@class,' topic/title ')][1]">
			<!-- add model for first page -->
			  <xsl:value-of select="@type"/>
			  <xsl:apply-templates select="$map/*[contains(@class,' topic/title ')][1]"/>
			</xsl:when>
			<xsl:when test="$map//*[contains(@class,' bookmap/mainbooktitle ')][1]">
			  <xsl:apply-templates select="$map//*[contains(@class,' bookmap/mainbooktitle ')][1]"/>
			</xsl:when>
			<xsl:when test="//*[contains(@class, ' map/map ')]/@title">
			  <xsl:value-of select="//*[contains(@class, ' map/map ')]/@title"/>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="/descendant::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')]"/>
			</xsl:otherwise>
		  </xsl:choose>
		</fo:block>
        <!-- set the subtitle -->
		<xsl:apply-templates select="$map//*[contains(@class,' bookmap/booktitlealt ')]"/>
		<fo:block xsl:use-attribute-sets="__frontmatter__owner">
		  <xsl:apply-templates select="$map//*[contains(@class,' bookmap/bookmeta ')]"/>
		</fo:block>
    </xsl:template>
		
	<!--======================================================
	    section line-height=14pt
	==========================================================-->
	<xsl:template match="*[contains(@class,' topic/section ')]">
        <fo:block xsl:use-attribute-sets="section">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates select="." mode="dita2xslfo:section-heading"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
	
	<xsl:template match="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]">
		<xsl:variable name="v_type">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class,' topic/body ')]/parent::*[contains(@class,' topic/topic')]/*[contains(@class,' topic/title')]='前言'">
					<xsl:value-of select="'Yes'"/>
				</xsl:when>
				<xsl:when test="ancestor::*[contains(@class,' topic/body ')]/parent::*[contains(@class,' topic/topic')]/*[contains(@class,' topic/title')]='preface'">
					<xsl:value-of select="'Yes'"/>
				</xsl:when>
				<xsl:when test="ancestor::*[contains(@class,' topic/body ')]/parent::*[contains(@class,' topic/topic')]/*[contains(@class,' topic/title')]='foreword'">
					<xsl:value-of select="'Yes'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'No'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	    <xsl:choose>
            <xsl:when test="$v_type='Yes'"><!-- preface title font-size:11pt -->
			    <fo:block font-size="11pt" xsl:use-attribute-sets="section.title">
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates select="." mode="getTitle"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
			    <fo:block xsl:use-attribute-sets="section_title">
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates select="." mode="getTitle"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>     
		
    </xsl:template>
	
	<!--======================================================
	    example line-height=14pt
	==========================================================-->
	<xsl:template match="*[contains(@class,' topic/example ')]">
        <fo:block xsl:use-attribute-sets="example">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
	
	<!--======================================================
	    para line-height=14pt
	==========================================================-->
	<xsl:template match="*[contains(@class, ' topic/p ')]">
        <fo:block xsl:use-attribute-sets="p">
		    <!--<xsl:if test="not(parent::*[contains(@class, ' topic/entry ')])">
				<xsl:attribute name="margin-bottom">
				    <xsl:value-of select="'5pt'"/>
				</xsl:attribute>
			</xsl:if>-->
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
	
	<!--======================================================
	    shortdesc line-height=14pt
	==========================================================-->
	<xsl:template match="*[contains(@class,' topic/shortdesc ')]">
        <xsl:variable name="format-as-block" as="xs:boolean">
            <xsl:choose>
                <xsl:when test="not(parent::*[contains(@class,' topic/abstract ')])">
                  <xsl:sequence select="true()"/>
                </xsl:when>
                <xsl:when test="preceding-sibling::*[contains(@class,' topic/p ') or contains(@class,' topic/dl ') or
                                         contains(@class,' topic/fig ') or contains(@class,' topic/lines ') or
                                         contains(@class,' topic/lq ') or contains(@class,' topic/note ') or
                                         contains(@class,' topic/ol ') or contains(@class,' topic/pre ') or
                                         contains(@class,' topic/simpletable ') or contains(@class,' topic/sl ') or
                                         contains(@class,' topic/table ') or contains(@class,' topic/ul ')]">
                  <xsl:sequence select="true()"/>
                </xsl:when>
                <xsl:when test="following-sibling::*[contains(@class,' topic/p ') or contains(@class,' topic/dl ') or
                                         contains(@class,' topic/fig ') or contains(@class,' topic/lines ') or
                                         contains(@class,' topic/lq ') or contains(@class,' topic/note ') or
                                         contains(@class,' topic/ol ') or contains(@class,' topic/pre ') or
                                         contains(@class,' topic/simpletable ') or contains(@class,' topic/sl ') or
                                         contains(@class,' topic/table ') or contains(@class,' topic/ul ')]">
                  <xsl:sequence select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:sequence select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$format-as-block">
                <xsl:apply-templates select="." mode="format-shortdesc-as-block"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="format-shortdesc-as-inline"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="*" mode="format-shortdesc-as-block">
        <!--compare the length of shortdesc with the got max chars-->
        <fo:block line-height="14pt" xsl:use-attribute-sets="topic__shortdesc">
            <xsl:call-template name="commonattributes"/>
            <!-- If the shortdesc is sufficiently short, add keep-with-next. -->
            <xsl:if test="string-length(.) lt $maxCharsInShortDesc">
                <!-- Low-strength keep to avoid conflict with keeps on titles. -->
                <xsl:attribute name="keep-with-next.within-page">5</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
	
	
	<xsl:template match="*[contains(@class,' hi-d/sup ')]">
      <fo:inline baseline-shift="-25%" font-size="125%">
        <xsl:call-template name="commonattributes"/>
        <xsl:apply-templates/>
      </fo:inline>
    </xsl:template>

	<xsl:template match="*[contains(@class,' sw-d/msgblock ')]">
      <fo:block font-size="10pt" color="black">
        <xsl:apply-templates/>
      </fo:block>
    </xsl:template>
	
	
</xsl:stylesheet>	
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.1">
  <!-- ============================================================== -->
  <!-- Revision History
       1/ Initial version
       2/ 20070809 RS: Changed cellpadding cell-attribute into padding cell-attribute
  -->
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/table ')]/*[contains(@class,' topic/xtitle ')]" priority="2"/>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/table ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:block>
		  <xsl:choose>
		    <xsl:when test="@pgwidth = '1'">
		      <xsl:attribute name="span">all</xsl:attribute>
		    </xsl:when>
		    <xsl:when test="string-length(ancestor-or-self::*/@outputclass) > 0">
		    	<xsl:call-template name="add.style">
						<xsl:with-param name="style" select="ancestor-or-self::*/@outputclass"/>
            <xsl:with-param name="language" select="$language"/>
					</xsl:call-template>
		    </xsl:when>
		  </xsl:choose>		
			<xsl:apply-templates/>
			<!-- Relocated footnote generation process to table-footer spanned row in order to keep them together with the table -->
			<!-- Original code: TO BE REPLACED BY FUNCTION THAT ONLY SHOWS UNIQUE FOOTNOTES INSTEAD OF ALL OF THEM -->			
			<!-- show footnotes used within table beneath the table itself instead of at the bottom of the page -->
<!--			<xsl:for-each select=".//*[contains(@class,' topic/fn ')]">
        <xsl:if test="string-length(.) > 0">
          <fo:block>
        			<xsl:if test="@id">
        				<fo:inline font-style="italic">
        					<xsl:text>[Footnote: </xsl:text>
        					<xsl:value-of select="@id"/>
        					<xsl:text>]</xsl:text>
        				</fo:inline>
        			</xsl:if>
     		  		<fo:inline baseline-shift="super" font-size="75%">
          			<xsl:choose>
            			<xsl:when test="@callout">
        		  			<xsl:value-of select="@callout"/>
        					< ! - -xsl:number level="multiple" count="//fn"  format="1 "/ - - >
        			    </xsl:when>
        		  	  <xsl:otherwise>
        	  				<xsl:number level="multiple" count="//fn"  format="1 "/>
          			  </xsl:otherwise>
          			</xsl:choose>
       				</fo:inline>    			
        			<xsl:apply-templates/>
       		</fo:block>
        </xsl:if>
			</xsl:for-each>		-->	
		</fo:block>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="default-colwidth">
		<!--fo:table-column column-width="150pt"/-->
		<xsl:for-each select="row[1]/entry">
			<fo:table-column>
				<!-- compute even columns (creates valid processing, but all columns are even width) -->
				<xsl:attribute name="column-width"><xsl:value-of select="floor(@width div 72)"/>in</xsl:attribute>
				<!-- TBD: get this value directly from markup, if possible, for adjusted overrides -->
			</fo:table-column>
		</xsl:for-each>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/spanspec ')]">
		<!--  <xsl:call-template name="att-align"/> -->
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/colspec ')]">
		<fo:table-column>
			<xsl:call-template name="att-align"/>
			<xsl:attribute name="column-number"><xsl:number count="colspec"/></xsl:attribute>
			<xsl:attribute name="column-width"><xsl:call-template name="xcalc.column.width"><xsl:with-param name="colwidth"><xsl:value-of select="@colwidth"/></xsl:with-param></xsl:call-template></xsl:attribute>
		</fo:table-column>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/tgroup ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:choose>
			<xsl:when test="xtitle">
				<!-- renamed for now to NOT trigger on title; testing the "otherwise" code -->
				<fo:block>
					<xsl:call-template name="add.style">
						<xsl:with-param name="style" select="'block'"/>
						<xsl:with-param name="language" select="$language"/>
					</xsl:call-template>			
					<fo:table-and-caption>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'table.data frameall'"/>
							<xsl:with-param name="language" select="$language"/>
						</xsl:call-template>			
						<fo:table-caption>
							<fo:block>
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'table.data.caption'"/>
									<xsl:with-param name="language" select="$language"/>
								</xsl:call-template>			
								<xsl:value-of select="title"/>
							</fo:block>
						</fo:table-caption>
						<fo:table>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'table.data frameall block'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>			
							<xsl:if test="string(@id)">
								<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
							</xsl:if>
							<!-- column specifications or default colwidths if not colspec elements found -->
							<xsl:choose>
								<xsl:when test="count(*[contains(@class,' topic/colspec ')]) > 0">
									<xsl:apply-templates select="*[contains(@class,' topic/colspec ')]" />																							
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="default-colwidth"/>
								</xsl:otherwise>
							</xsl:choose>
							<!-- header and footer sections -->
							<xsl:apply-templates select="*[contains(@class,' topic/thead ')]"/>
							<xsl:apply-templates select="*[contains(@class,' topic/tfoot ')]"/>
							<xsl:if test="not(./*[contains(@class,' topic/tfoot ')])">
								<fo:table-footer>
									<fo:table-row>
										<fo:table-cell>
											<xsl:call-template name="showTableFootnotes">
												<xsl:with-param name="tableNode" select="." />
											</xsl:call-template>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-footer>
							</xsl:if>
							<!-- table body section -->
							<xsl:apply-templates select="*[contains(@class,' topic/tbody ')]"/>
						</fo:table>
					</fo:table-and-caption>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:call-template name="add.style">
						<xsl:with-param name="style" select="'block'"/>
						<xsl:with-param name="language" select="$language"/>
					</xsl:call-template>			
					<fo:table>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'table.data frameall'"/>
							<xsl:with-param name="language" select="$language"/>
						</xsl:call-template>			
						<!--xsl:if test="string(@id)"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if-->
						<!-- column specifications or default colwidths if not colspec elements found -->
						<xsl:choose>
							<xsl:when test="count(*[contains(@class,' topic/colspec ')]) > 0">
								<xsl:apply-templates select="*[contains(@class,' topic/colspec ')]" />																							
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="default-colwidth"/>
							</xsl:otherwise>
						</xsl:choose>
						<!-- TBD: apply tblatts and place-tbl-width here -->
						<!-- header and footer sections -->						
						<xsl:apply-templates select="*[contains(@class,' topic/thead ')]"/>
						<xsl:apply-templates select="*[contains(@class,' topic/tfoot ')]"/>
						<xsl:if test="not(*[contains(@class,' topic/tfoot ')]) and count(.//*[contains(@class,' topic/fn ')])>0">
							<fo:table-footer>
								<fo:table-row>
									<fo:table-cell>
										<xsl:call-template name="add.style">
											<xsl:with-param name="style" select="'table.footer.cell table.footer.cell.footnotes'"/>
											<xsl:with-param name="language" select="$language"/>						
										</xsl:call-template>									
										<xsl:call-template name="spanOverAllCells" />									
										<xsl:call-template name="showTableFootnotes">
											<xsl:with-param name="tableNode" select="." />
										</xsl:call-template>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-footer>
						</xsl:if>
						<!-- table body section -->
						<xsl:apply-templates select="*[contains(@class,' topic/tbody ')]"/>
					</fo:table>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/thead ')]">
		<fo:table-header>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'table.data.row'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>				
			<xsl:call-template name="att-valign"/>
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/tfoot ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>	
		<fo:table-footer>
			<xsl:call-template name="att-valign"/>
			<xsl:apply-templates/>
			<xsl:if test="count(parent::*[contains(@class,' topic/tgroup ')]//*[contains(@class,' topic/fn ')])>0">
				<fo:table-row>
					<fo:table-cell>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'table.footer.cell table.footer.cell.footnotes'"/>
							<xsl:with-param name="language" select="$language"/>						
						</xsl:call-template>
						<xsl:call-template name="spanOverAllCells" />
						<xsl:call-template name="showTableFootnotes">
							<xsl:with-param name="tableNode" select="parent::*" />
						</xsl:call-template>
					</fo:table-cell>
				</fo:table-row>			
			</xsl:if>
		</fo:table-footer>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/tbody ')]">
		<fo:table-body>
			<xsl:call-template name="att-valign"/>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/tnote ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:table-row>
			<fo:table-cell start-indent="2pt" background-color="#E0E0F0">
				<xsl:call-template name="add.style">
					<xsl:with-param name="style" select="'table.data.td'"/>
					<xsl:with-param name="language" select="$language"/>
				</xsl:call-template>
				<fo:block>
  				<xsl:if test="$insert.elementlabels = '[param not found]' or $insert.elementlabels = 'yes'">					
  					<fo:inline font-weight="bold">
  						<xsl:call-template name="getString">
  							<xsl:with-param name="stringName" select="'Note'"/>
  							<xsl:with-param name="language" select="$language"/>
  						</xsl:call-template>
  						<xsl:text>: </xsl:text>
  					</fo:inline>
  				</xsl:if>					
					<xsl:apply-templates/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/row ')]">
		<fo:table-row>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'table.data.row'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>	
			<xsl:call-template name="att-valign"/>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/thead ')]/*[contains(@class,' topic/row ')]/*[contains(@class,' topic/entry ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:table-cell start-indent="2pt" background-color="silver" padding="2pt" text-align="center" font-weight="bold">
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'frameall'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>		
			<xsl:call-template name="entryatts"/>
			<fo:block>
				<xsl:call-template name="fillit"/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/tfoot ')]/*[contains(@class,' topic/row ')]/*[contains(@class,' topic/entry ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:table-cell start-indent="2pt">
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'table.data.tf frameall'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:call-template name="entryatts"/>
			<fo:block>
				<xsl:call-template name="fillit"/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="get-colnumval">
		<xsl:param name="entry"/>
		<xsl:param name="colname"/>
		<xsl:choose>
			<!-- if colname is defined find corresponding colspec -->
			<xsl:when test="@colname">
				<xsl:value-of select="count($entry/ancestor::tgroup/colspec[@colname=$colname]/preceding-sibling::*)+1"/>
			</xsl:when>
			<!-- if colnum is defined -->
			<xsl:when test="@colnum">
				<xsl:value-of select="@colnum"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- improve -->
				<xsl:number count="entry"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/tbody ')]/*[contains(@class,' topic/row ')]/*[contains(@class,' topic/entry ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:variable name="colnumval">
			<xsl:call-template name="get-colnumval">
				<xsl:with-param name="entry">
					<xsl:value-of select="."/>
				</xsl:with-param>
				<xsl:with-param name="colname">
					<xsl:value-of select="@colname"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<fo:table-cell start-indent="2pt" background-color="#faf4fa" padding="2pt">
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'frameall'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:call-template name="entryatts"/>
			<fo:block>
				<xsl:call-template name="fillit"/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- ============================================================== -->
	<!-- named templates -->
	<xsl:template name="fillit">
		<xsl:choose>
			<!-- test to see if the cell contains any text or other element -->
			<xsl:when test="not(text()[normalize-space(.)] | *)">
				<xsl:text>&#160;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================================================== -->
	<!-- table "macros" -->
	<xsl:template name="entryatts">
		<xsl:call-template name="att-valign"/>
		<xsl:call-template name="att-align"/>
		<xsl:if test="string(@colsep)">
			<xsl:if test="@colsep='1'">
			  <!-- 20070809 RS: Removed cellpadding upon DDM's request
			                    in order to have clear AH output.
			                    Padding already defined on cell creation. -->
				<!--<xsl:attribute name="cellpadding">10</xsl:attribute>-->
			</xsl:if>
		</xsl:if>
		<!-- row spanning -->
		<xsl:if test="@morerows">
			<xsl:attribute name="number-rows-spanned"><xsl:value-of select="@morerows+1"/></xsl:attribute>
		</xsl:if>
		<!-- column spanning -->
		<xsl:if test="string(@namest)">
			<xsl:variable name="namest">
				<xsl:value-of select="@namest"/>
			</xsl:variable>
			<xsl:variable name="nameend">
				<xsl:value-of select="@nameend"/>
			</xsl:variable>
			<xsl:variable name="colst" select="count(ancestor::tgroup/colspec[@colname=$namest]/preceding-sibling::*)+1"/>
			<xsl:variable name="colend" select="count(ancestor::tgroup/colspec[@colname=$nameend]/preceding-sibling::*)+1"/>
			<xsl:attribute name="number-columns-spanned"><xsl:value-of select="$colend - $colst + 1"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="att-valign">
		<xsl:if test="string(@valign)">
			<xsl:choose>
				<xsl:when test="@valign='middle'">
					<xsl:attribute name="display-align">center</xsl:attribute>
				</xsl:when>
				<xsl:when test="@valign='top'">
					<xsl:attribute name="display-align">before</xsl:attribute>
				</xsl:when>
				<xsl:when test="@valign='bottom'">
					<xsl:attribute name="display-align">after</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="display-align"><xsl:value-of select="@valign"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="att-align">
		<xsl:if test="string(@align)">
			<xsl:attribute name="text-align"><xsl:value-of select="normalize-space(@align)"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<!-- ============================================================== -->
	<!-- table support based on examples in the XSL spec -->
	<!-- see original support comments in the XSL spec, source of this fragment -->
	<xsl:template name="calc.column.width">
		<xsl:param name="colwidth">1*</xsl:param>
		<!-- Ok, the colwidth could have any one of the following forms: -->
		<!--        1*       = proportional width -->
		<!--     1unit       = 1.0 units wide -->
		<!--         1       = 1pt wide -->
		<!--  1*+1unit       = proportional width + some fixed width -->
		<!--      1*+1       = proportional width + some fixed width -->
		<!-- If it has a proportional width, translate it to XSL -->
		<xsl:if test="contains($colwidth, '*')">
			<!-- modified to handle "*" as input -->
			<xsl:variable name="colfactor">
				<xsl:value-of select="substring-before($colwidth, '*')"/>
			</xsl:variable>
			<xsl:text>proportional-column-width(</xsl:text>
			<xsl:choose>
				<xsl:when test="not($colfactor = '')">
					<xsl:value-of select="$colfactor"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
			<xsl:text>)</xsl:text>
		</xsl:if>
		<!-- Now get the non-proportional part of the specification -->
		<xsl:variable name="width-units">
			<xsl:choose>
				<xsl:when test="contains($colwidth, '*')">
					<xsl:value-of select="normalize-space(substring-after($colwidth, '*'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($colwidth)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Now the width-units could have any one of the following forms: -->
		<!--                 = <empty string> -->
		<!--     1unit       = 1.0 units wide -->
		<!--         1       = 1pt wide -->
		<!-- with an optional leading sign -->
		<!-- Get the width part by blanking out the units part and discarding -->
		<!-- white space. -->
		<xsl:variable name="width" select="normalize-space(translate($width-units,
                            '+-0123456789.abcdefghijklmnopqrstuvwxyz',
                            '+-0123456789.'))"/>
		<!-- Get the units part by blanking out the width part and discarding -->
		<!-- white space. -->
		<xsl:variable name="units" select="normalize-space(translate($width-units,
                            'abcdefghijklmnopqrstuvwxyz+-0123456789.',
                            'abcdefghijklmnopqrstuvwxyz'))"/>
		<!-- Output the width -->
		<xsl:value-of select="$width"/>
		<!-- Output the units, translated appropriately -->
		<xsl:choose>
			<xsl:when test="$units = 'pi'">pc</xsl:when>
			<xsl:when test="$units = '' and $width != ''">pt</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$units"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="xcalc.column.width">
		<!-- see original support comments in the XSL spec, source of this fragment -->
		<xsl:param name="colwidth">1*</xsl:param>
		<!-- Ok, the colwidth could have any one of the following forms: -->
		<!--        1*       = proportional width -->
		<!--     1unit       = 1.0 units wide -->
		<!--         1       = 1pt wide -->
		<!--  1*+1unit       = proportional width + some fixed width -->
		<!--      1*+1       = proportional width + some fixed width -->
		<!-- If it has a proportional width, translate it to XSL -->
		<xsl:if test="contains($colwidth, '*')">
			<xsl:variable name="colfactor">
				<xsl:value-of select="substring-before($colwidth, '*')"/>
			</xsl:variable>
			<xsl:text>proportional-column-width(</xsl:text>
			<xsl:choose>
				<xsl:when test="not($colfactor = '')">
					<xsl:value-of select="$colfactor"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
			<xsl:text>)</xsl:text>
		</xsl:if>
		<!-- Now get the non-proportional part of the specification -->
		<xsl:variable name="width-units">
			<xsl:choose>
				<xsl:when test="contains($colwidth, '*')">
					<xsl:value-of select="normalize-space(substring-after($colwidth, '*'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($colwidth)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Now the width-units could have any one of the following forms: -->
		<!--                 = <empty string> -->
		<!--     1unit       = 1.0 units wide -->
		<!--         1       = 1pt wide -->
		<!-- with an optional leading sign -->
		<!-- Get the width part by blanking out the units part and discarding -->
		<!-- whitespace. -->
		<xsl:variable name="width" select="normalize-space(translate($width-units,
                                           '+-0123456789.abcdefghijklmnopqrstuvwxyz',
                                           '+-0123456789.'))"/>
		<!-- Get the units part by blanking out the width part and discarding -->
		<!-- whitespace. -->
		<xsl:variable name="units" select="normalize-space(translate($width-units,
                                           'abcdefghijklmnopqrstuvwxyz+-0123456789.',
                                           'abcdefghijklmnopqrstuvwxyz'))"/>
		<!-- Output the width -->
		<xsl:value-of select="$width"/>
		<!-- Output the units, translated appropriately -->
		<xsl:choose>
			<xsl:when test="$units = 'pi'">pc</xsl:when>
			<xsl:when test="$units = '' and $width != ''">pt</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$units"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="showTableFootnotes">
		<xsl:param name="tableNode" select="." />
		<xsl:message>Fill footnote cell using table with id: <xsl:value-of select="$tableNode/../@id" /></xsl:message>
		<!-- show footnotes used within table beneath the table itself instead of at the bottom of the page -->
		
		<xsl:variable name="uniqueTableFootnotes" select="$tableNode//*[contains(@class,' topic/fn ') and not(.=preceding::*[contains(@class,' topic/fn ')][ancestor::*[contains(@class, ' topic/tgroup ')]=$tableNode])]"/>
		<!--<xsl:variable name="uniqueTableFootnotes" select="child::$tableNode[contains(@class,' topic/fn ') and not(.=preceding::*[contains(@class,' topic/fn ')])]"/>-->
		<xsl:message>Number of footnotes found in table: <xsl:value-of select="count($uniqueTableFootnotes)" /></xsl:message>
		<xsl:if test="count($uniqueTableFootnotes) > 0">
			<fo:block-container keep-with-previous.within-column="always">
				<xsl:for-each select="$uniqueTableFootnotes">
					<fo:block>
						<xsl:if test="@id">
							<fo:inline font-style="italic">
								<xsl:text>[Footnote: </xsl:text>
								<xsl:value-of select="@id"/>
								<xsl:text>]</xsl:text>
							</fo:inline>
						</xsl:if>
						<fo:inline baseline-shift="super" font-size="75%">
							<xsl:choose>
								<xsl:when test="@callout">
									<xsl:value-of select="@callout"/>
									<!-- xsl:number level="multiple" count="//fn"  format="1 "/ -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="position()" />
									<!--<xsl:number level="multiple" count="//fn"  format="1 "/>-->
								</xsl:otherwise>
							</xsl:choose>
						</fo:inline>:    			
						<xsl:apply-templates/>
					</fo:block>
				</xsl:for-each>
			</fo:block-container>
		</xsl:if>						
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="spanOverAllCells">	
		<xsl:attribute name="number-columns-spanned"><xsl:value-of select="count(ancestor-or-self::*[contains(@class,' topic/tgroup ')]//*[contains(@class,' topic/colspec ')])" /></xsl:attribute>	
	</xsl:template>	
	<!-- ============================================================== -->
</xsl:stylesheet>

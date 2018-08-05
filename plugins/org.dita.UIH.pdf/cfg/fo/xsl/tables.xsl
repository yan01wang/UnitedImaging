<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  exclude-result-prefixes="opentopic-func xs dita2xslfo dita-ot"
  version="2.0">

    <xsl:variable name="tableAttrs" select="'../../cfg/fo/attrs/tables-attr.xsl'"/>
    <!-- XML Exchange Table Model Document Type Definition default is all -->
    <xsl:variable name="table.frame-default" select="'none'"/>
	<!--===================================================================
	    handle table
	    ===================================================================-->
    <xsl:template match="*[contains(@class, ' topic/table ')]">
      <!-- FIXME, empty value -->
        <xsl:variable name="scale" as="xs:string?">
            <xsl:call-template name="getTableScale"/>
        </xsl:variable>

		<fo:block xsl:use-attribute-sets="table">
		    <xsl:attribute name="margin-left">
				<xsl:choose><!-- 列表内的note -->
					<xsl:when test="parent::*[contains(@class,' topic/li ')]">
					   <xsl:value-of select="'-5mm'"/>
					</xsl:when>
					
					<xsl:otherwise>
					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		
			<xsl:call-template name="commonattributes"/>
			<xsl:if test="not(@id)">
			  <xsl:attribute name="id">
				<xsl:call-template name="get-id"/>
			  </xsl:attribute>
			</xsl:if>
			<xsl:if test="exists($scale)">
				<xsl:attribute name="font-size" select="concat($scale, '%')"/>
			</xsl:if>
			<xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
			<xsl:apply-templates/>
			<xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
		</fo:block>
    </xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]">
        <fo:block xsl:use-attribute-sets="table_title">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Table.title'"/>
                <xsl:with-param name="params">
                    <number>
                      <xsl:value-of select="ancestor::*[contains (@class, ' topic/topic ')][1]/@chapter_number"/>-<xsl:apply-templates select="." mode="table.title-number"/><xsl:text>&#xA0;</xsl:text><xsl:text>&#xA0;</xsl:text>
                    </number>
                    <title>
                        <xsl:apply-templates/>
                    </title>
                </xsl:with-param>
            </xsl:call-template>
        </fo:block>
    </xsl:template>

	<xsl:template match="*[contains(@class, ' topic/thead ')]">
        <fo:table-header xsl:use-attribute-sets="tgroup.thead">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:table-header>
    </xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/tbody ')]">
        <fo:table-body xsl:use-attribute-sets="tgroup.tbody">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:table-body>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/thead ')]/*[contains(@class, ' topic/row ')]">
        <fo:table-row xsl:use-attribute-sets="thead.row">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:table-row>
    </xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/tbody ')]/*[contains(@class, ' topic/row ')]">
        <fo:table-row xsl:use-attribute-sets="tbody.row">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/thead ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')]">
	    <xsl:variable name="v_colsep" select="@colsep"/>
		<xsl:variable name="v_rowsep" select="@rowsep"/>
        <fo:table-cell background-color="#B0C6CD" xsl:use-attribute-sets="thead.row.entry">
		    <xsl:if test="$v_colsep='0'">
			    <xsl:attribute name="border-right">
				    <xsl:value-of select="'0.5pt solid white'"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$v_rowsep='0'">
			    <xsl:attribute name="border-bottom">
				    <xsl:value-of select="'0.5pt solid white'"/>
				</xsl:attribute>
			</xsl:if>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="applySpansAttrs"/>
            <xsl:call-template name="applyHeadAlignAttrs"/>
            <xsl:call-template name="generateTableEntryBorder"/>
            <fo:block>
                <xsl:apply-templates select="." mode="ancestor-start-flag"/>
                <xsl:call-template name="processEntryContent"/>
                <xsl:apply-templates select="." mode="ancestor-end-flag"/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/tbody ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')]">
        <xsl:variable name="v_rowsep" select="@rowsep"/>
		<xsl:choose>
            <xsl:when test="ancestor::*[contains(@class, ' topic/table ')][1]/@rowheader = 'firstcol'
                        and empty(preceding-sibling::*[contains(@class, ' topic/entry ')])">
                <fo:table-cell xsl:use-attribute-sets="tbody.row.entry__firstcol">
				    <xsl:if test="$v_rowsep='0'">
						<xsl:attribute name="border-bottom">
							<xsl:value-of select="'0.5pt solid white'"/>
						</xsl:attribute>
					</xsl:if> 
                    <xsl:apply-templates select="." mode="processTableEntry"/>
                </fo:table-cell>
            </xsl:when>
            <xsl:otherwise>
                <fo:table-cell padding-left="5pt" padding-right="5pt">
				    <xsl:if test="$v_rowsep='0'">
						<xsl:attribute name="border-bottom">
							<xsl:value-of select="'0.5pt solid white'"/>
						</xsl:attribute>
					</xsl:if>
                    <xsl:apply-templates select="." mode="processTableEntry"/>
                </fo:table-cell>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="*" mode="processTableEntry">
        <xsl:call-template name="commonattributes"/>
        <xsl:call-template name="applySpansAttrs"/>
        <xsl:call-template name="applyHeadAlignAttrs"/>
        <xsl:call-template name="generateTableEntryBorder"/>
        <fo:block xsl:use-attribute-sets="table-cell.body.entry">
            <xsl:call-template name="processEntryContent"/>
        </fo:block>
    </xsl:template>

	
	<!--===================================================================
	    handle simpletable
	    ===================================================================-->
	 <!--  Simpletable processing  -->
    <xsl:template match="*[contains(@class, ' topic/simpletable ')]">
        <xsl:variable name="number-cells" as="xs:integer">
            <!-- Contains the number of cells in the widest row -->
            <xsl:apply-templates select="*[1]" mode="count-max-simpletable-cells"/>
        </xsl:variable>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
        <fo:table xsl:use-attribute-sets="simpletable">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="globalAtts"/>
            <xsl:call-template name="displayAtts">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>

            <xsl:if test="@relcolwidth">
                <xsl:variable name="fix-relcolwidth" as="xs:string">
                    <xsl:apply-templates select="." mode="fix-relcolwidth">
                        <xsl:with-param name="number-cells" select="$number-cells"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:call-template name="createSimpleTableColumns">
                    <xsl:with-param name="theColumnWidthes" select="$fix-relcolwidth"/>
                </xsl:call-template>
            </xsl:if>

            <!-- Toss processing to another template to process the simpletable
                 heading, and/or create a default table heading row. -->
            <xsl:apply-templates select="." mode="dita2xslfo:simpletable-heading">
                <xsl:with-param name="number-cells" select="$number-cells"/>
            </xsl:apply-templates>

            <fo:table-body xsl:use-attribute-sets="simpletable__body">
                <xsl:choose>
                  <xsl:when test="empty(*[contains(@class, ' topic/strow ')])">
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block/>
                        </fo:table-cell>
                    </fo:table-row>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="*[contains(@class, ' topic/strow ')]">
                        <xsl:with-param name="number-cells" select="$number-cells"/>
                    </xsl:apply-templates>
                  </xsl:otherwise>
                </xsl:choose>
            </fo:table-body>

        </fo:table>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>	
		
    <xsl:template match="*[contains(@class, ' topic/sthead ')]">
      <xsl:param name="number-cells" as="xs:integer">
            <xsl:apply-templates select="../*[1]" mode="count-max-simpletable-cells"/>
        </xsl:param>
        <fo:table-header xsl:use-attribute-sets="sthead">
            <xsl:call-template name="commonattributes"/>
            <fo:table-row xsl:use-attribute-sets="sthead__row">
                <xsl:apply-templates select="*[contains(@class, ' topic/stentry ')]"/>
                <xsl:variable name="row-cell-count" select="count(*[contains(@class, ' topic/stentry ')])" as="xs:integer"/>
                <xsl:if test="$row-cell-count &lt; $number-cells">
                    <xsl:apply-templates select="." mode="fillInMissingSimpletableCells">
                        <xsl:with-param name="fill-in-count" select="$number-cells - $row-cell-count"/>
                    </xsl:apply-templates>
                </xsl:if>
            </fo:table-row>
        </fo:table-header>
    </xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/sthead ')]/*[contains(@class, ' topic/stentry ')]">
        <fo:table-cell xsl:use-attribute-sets="sthead.stentry">
            <xsl:call-template name="commonattributes"/>
            <xsl:variable name="entryCol" select="count(preceding-sibling::*[contains(@class, ' topic/stentry ')]) + 1"/>
            <xsl:variable name="frame" as="xs:string">
                <xsl:variable name="f" select="ancestor::*[contains(@class, ' topic/simpletable ')][1]/@frame"/>
                <xsl:choose>
                    <xsl:when test="$f">
                        <xsl:value-of select="$f"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$table.frame-default"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="generateSimpleTableHorizontalBorders">
                <xsl:with-param name="frame" select="$frame"/>
            </xsl:call-template>
            <xsl:if test="$frame = 'all' or $frame = 'topbot' or $frame = 'top'">
                <xsl:call-template name="processAttrSetReflection">
                    <xsl:with-param name="attrSet" select="'__tableframe__top'"/>
                    <xsl:with-param name="path" select="$tableAttrs"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="following-sibling::*[contains(@class, ' topic/stentry ')]">
                <xsl:call-template name="generateSimpleTableVerticalBorders">
                    <xsl:with-param name="frame" select="$frame"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="number(ancestor::*[contains(@class, ' topic/simpletable ')][1]/@keycol) = $entryCol">
                    <fo:block xsl:use-attribute-sets="sthead.stentry__keycol-content">
                        <xsl:apply-templates select="." mode="ancestor-start-flag"/>
                        <xsl:apply-templates/>
                        <xsl:apply-templates select="." mode="ancestor-end-flag"/>
                    </fo:block>
                </xsl:when>
                <xsl:otherwise>
                    <fo:block xsl:use-attribute-sets="sthead.stentry__content">
                        <xsl:apply-templates select="." mode="ancestor-start-flag"/>
                        <xsl:apply-templates/>
                        <xsl:apply-templates select="." mode="ancestor-end-flag"/>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </fo:table-cell>
    </xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/strow ')]/*[contains(@class, ' topic/stentry ')]">
        <fo:table-cell xsl:use-attribute-sets="strow.stentry">
            <xsl:call-template name="commonattributes"/>
            <xsl:variable name="entryCol" select="count(preceding-sibling::*[contains(@class, ' topic/stentry ')]) + 1"/>
            <xsl:variable name="frame" as="xs:string">
                <xsl:variable name="f" select="ancestor::*[contains(@class, ' topic/simpletable ')][1]/@frame"/>
                <xsl:choose>
                    <xsl:when test="$f">
                        <xsl:value-of select="$f"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$table.frame-default"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:if test="../following-sibling::*[contains(@class, ' topic/strow ')]">
                <xsl:call-template name="generateSimpleTableHorizontalBorders">
                    <xsl:with-param name="frame" select="$frame"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="following-sibling::*[contains(@class, ' topic/stentry ')]">
                <xsl:call-template name="generateSimpleTableVerticalBorders">
                    <xsl:with-param name="frame" select="$frame"/>
                </xsl:call-template>
            </xsl:if>
			<xsl:variable name="allrow">
			 <xsl:value-of select="count(ancestor::*[contains(@class, ' topic/simpletable ')]//*[contains(@class, ' topic/strow ')])"/>
            </xsl:variable>
			<xsl:variable name="strow">
			 <xsl:value-of select="count(parent::*[contains(@class, ' topic/strow ')]/preceding-sibling::*[contains(@class, ' topic/strow ')])+1"/>
            </xsl:variable>
			<xsl:variable name="stentry">
			 <xsl:value-of select="count(preceding-sibling::*[contains(@class, ' topic/stentry ')])+1"/>
            </xsl:variable>
			
            <xsl:choose>
                <xsl:when test="number(ancestor::*[contains(@class, ' topic/simpletable ')][1]/@keycol) = $entryCol">
                    <fo:block xsl:use-attribute-sets="strow.stentry__keycol-content">
                        <xsl:apply-templates select="." mode="ancestor-start-flag"/>
                        <xsl:apply-templates/>
                        <xsl:apply-templates select="." mode="ancestor-end-flag"/>
                    </fo:block>
                </xsl:when>
                <xsl:otherwise>
                    <fo:block xsl:use-attribute-sets="strow.stentry__content">
                        <xsl:apply-templates select="." mode="ancestor-start-flag"/>
						<!-- added number for simpletable items .modified by minnie 2018/08/01
						     row = 1,2,3,4,5,6,7,8  please add 9,10,11..... if you need more rows.
						-->
                        <xsl:if test="$allrow='1'">
							<xsl:choose>
								<xsl:when test="$stentry='1'">
									<xsl:value-of select="'1.'"/>
								</xsl:when>
								<xsl:when test="$stentry='2'">									
									<xsl:if test="not(empty(child::text()))">
									  <xsl:value-of select="'2.'"/>
								    </xsl:if>
								</xsl:when>						 
							</xsl:choose>
						</xsl:if>
						<xsl:if test="$allrow='2'">
						<xsl:choose>
							<xsl:when test="$strow='1'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'1.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'3.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>	
							<xsl:when test="$strow='2'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'2.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:if test="not(empty(child::text()))">
										  <xsl:value-of select="'4.'"/>
									    </xsl:if>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
						</xsl:choose>	
						</xsl:if>	
						<xsl:if test="$allrow='3'">
						<xsl:choose>
							<xsl:when test="$strow='1'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'1.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'4.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>	
							<xsl:when test="$strow='2'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'2.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'5.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='3'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'3.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									<xsl:if test="not(empty(child::text()))">
									   <xsl:value-of select="'6.'"/>
									</xsl:if>   
									</xsl:when>						 									
								</xsl:choose>
							</xsl:when>
						</xsl:choose>	
						</xsl:if>
						<xsl:if test="$allrow='4'">
						<xsl:choose>
							<xsl:when test="$strow='1'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'1.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'5.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>	
							<xsl:when test="$strow='2'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'2.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'6.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='3'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'3.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'7.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='4'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'4.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									   <xsl:if test="not(empty(child::text()))">
										  <xsl:value-of select="'8.'"/>
									   </xsl:if>
									</xsl:when>					
								</xsl:choose>
							</xsl:when>
						</xsl:choose>	
						</xsl:if>
						<xsl:if test="$allrow='5'">
						<xsl:choose>
							<xsl:when test="$strow='1'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'1.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'6.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>	
							<xsl:when test="$strow='2'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'2.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'7.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='3'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'3.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'8.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='4'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'4.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'9.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='5'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'5.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									    <xsl:if test="not(empty(child::text()))">
										   <xsl:value-of select="'10.'"/>
										</xsl:if>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
						</xsl:choose>	
						</xsl:if>
						<xsl:if test="$allrow='6'">
						<xsl:choose>
							<xsl:when test="$strow='1'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'1.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'7.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>	
							<xsl:when test="$strow='2'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'2.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'8.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='3'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'3.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'9.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='4'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'4.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'10.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='5'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'5.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									    <xsl:value-of select="'11.'"/>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='6'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'6.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									    <xsl:if test="not(empty(child::text()))">
										   <xsl:value-of select="'12.'"/>
										</xsl:if>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
						</xsl:choose>	
						</xsl:if>
						<xsl:if test="$allrow='7'">
						<xsl:choose>
							<xsl:when test="$strow='1'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'1.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'8.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>	
							<xsl:when test="$strow='2'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'2.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'9.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='3'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'3.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'10.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='4'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'4.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'11.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='5'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'5.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									    <xsl:value-of select="'12.'"/>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='6'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'6.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									    <xsl:value-of select="'13.'"/>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='7'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'7.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									    <xsl:if test="not(empty(child::text()))">
									        <xsl:value-of select="'14.'"/>
										</xsl:if>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
						</xsl:choose>	
						</xsl:if>
						<xsl:if test="$allrow='8'">
						<xsl:choose>
							<xsl:when test="$strow='1'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'1.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'9.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>	
							<xsl:when test="$strow='2'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'2.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'10.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='3'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'3.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'11.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='4'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'4.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
										<xsl:value-of select="'12.'"/>
									</xsl:when>						 
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='5'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'5.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									    <xsl:value-of select="'13.'"/>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='6'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'6.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									    <xsl:value-of select="'14.'"/>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='7'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'7.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									     <xsl:value-of select="'15.'"/>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$strow='8'">
								<xsl:choose>
									<xsl:when test="$stentry='1'">
										<xsl:value-of select="'8.'"/>
									</xsl:when>
									<xsl:when test="$stentry='2'">
									    <xsl:if test="not(empty(child::text()))">
									        <xsl:value-of select="'16.'"/>
										</xsl:if>
									</xsl:when>						 
								</xsl:choose>
							</xsl:when>
						</xsl:choose>	
						</xsl:if>
						<xsl:apply-templates/>
                        <xsl:apply-templates select="." mode="ancestor-end-flag"/>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </fo:table-cell>
    </xsl:template>
	
	<xsl:template name="applyHeadAlignAttrs">
        <xsl:variable name="align" as="xs:string?">
            <xsl:choose>
                <xsl:when test="@align">
                    <xsl:value-of select="@align"/>
                </xsl:when>
                <xsl:when test="ancestor::*[contains(@class, ' topic/tbody ')][1][@align]">
                    <xsl:value-of select="ancestor::*[contains(@class, ' topic/tbody ')][1]/@align"/>
                </xsl:when>
                <xsl:when test="ancestor::*[contains(@class, ' topic/thead ')][1][@align]">
                    <xsl:value-of select="ancestor::*[contains(@class, ' topic/thead ')][1]/@align"/>
                </xsl:when>
                <xsl:when test="ancestor::*[contains(@class, ' topic/tgroup ')][1][@align]">
                    <xsl:value-of select="ancestor::*[contains(@class, ' topic/tgroup ')][1]/@align"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="valign" as="xs:string?">
            <xsl:choose>
                <xsl:when test="@valign">
                    <xsl:value-of select="@valign"/>
                </xsl:when>
                <xsl:when test="parent::*[contains(@class, ' topic/row ')][@valign]">
                    <xsl:value-of select="parent::*[contains(@class, ' topic/row ')]/@valign"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="not(normalize-space($align) = '')">
                <xsl:attribute name="text-align">
                    <xsl:value-of select="$align"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="text-align">center</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$valign='top'">
                <xsl:attribute name="display-align">
                    <xsl:value-of select="'before'"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$valign='middle'">
                <xsl:attribute name="display-align">
                    <xsl:value-of select="'center'"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$valign='bottom'">
                <xsl:attribute name="display-align">
                    <xsl:value-of select="'after'"/>
                </xsl:attribute>
            </xsl:when>
			<xsl:otherwise>
			    <xsl:attribute name="display-align">
                    <xsl:value-of select="'center'"/>
                </xsl:attribute>
			</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	
</xsl:stylesheet>
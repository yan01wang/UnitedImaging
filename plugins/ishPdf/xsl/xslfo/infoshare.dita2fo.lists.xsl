<?xml version="1.0"?>
<!DOCTYPE xsl:transform [
	<!-- entities for use in the generated output (must produce correctly in FO) -->
	<!ENTITY rbl "&#160;">
	<!ENTITY bullet "&#x2022;">
	<!--check these two for better assignments -->
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.1">
  <!-- ============================================================== -->
  <!-- Revision History
       2/ 20050927: list identation and inheritance
  -->
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/ul ')] | *[contains(@class,' topic/ol ')] | *[contains(@class,' topic/sl ')]">
		<xsl:variable name="list-level" select="count(ancestor-or-self::*[contains(@class,' topic/ul ')] | 
                  ancestor-or-self::*[contains(@class,' topic/dl ')] |
                  ancestor-or-self::*[contains(@class,' topic/sl ')] |
                  ancestor-or-self::*[contains(@class,' topic/ol ')] )"/>
 		<fo:list-block>
 		  <xsl:if test="parent::*[contains(@class,' topic/body ')] | parent::*[contains(@class,' topic/section ')]">
 		    <xsl:choose>
 		      <xsl:when test="$list-level = 1">
 		        <xsl:attribute name="start-indent"><xsl:value-of select="$indent.basic"/>pt</xsl:attribute>
 		      </xsl:when>
 		      <xsl:otherwise>
 		        <xsl:attribute name="start-indent"><xsl:value-of select="$indent.basic + (($list-level - 1) * $indent.extra)"/>pt</xsl:attribute>
 		      </xsl:otherwise>
 		    </xsl:choose>
 		  </xsl:if>
      <xsl:apply-templates/>
 		</fo:list-block>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/ul ')]/*[contains(@class,' topic/li ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:variable name="list-level" select="count(ancestor-or-self::*[contains(@class,' topic/ul ')] | 
                  ancestor-or-self::*[contains(@class,' topic/dl ')] |
                  ancestor-or-self::*[contains(@class,' topic/sl ')] |
                  ancestor-or-self::*[contains(@class,' topic/ol ')] )"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()" text-align="end">
				<fo:block>
					<xsl:choose>
						<xsl:when test="ancestor::*[contains(@class,' topic/entry ')]">
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'li.table'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>							
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'li'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<fo:inline>&#x2022;</fo:inline>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:choose>
						<xsl:when test="ancestor::*[contains(@class,' topic/entry ')]">
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'li.table'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>							
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'li'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
		<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/ol ')]/*[contains(@class,' topic/li ')]">
		<xsl:variable name="list-level" select="count(ancestor-or-self::*[contains(@class,' topic/ul ')] | 
                  ancestor-or-self::*[contains(@class,' topic/dl ')] |
                  ancestor-or-self::*[contains(@class,' topic/sl ')] |
                  ancestor-or-self::*[contains(@class,' topic/ol ')] )"/>
		<xsl:variable name="extra-list-indent"><xsl:value-of select="number($list-level)*16"/>pt</xsl:variable>
		<xsl:variable name="current-language"><xsl:call-template name="get.current.language"/></xsl:variable>
		<xsl:variable name="number"><xsl:number format="1" /></xsl:variable>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()" text-align="end">
				<fo:block>
				  <xsl:attribute name="language"><xsl:value-of select="$current-language" /></xsl:attribute>
					<xsl:choose>
						<xsl:when test="ancestor::*[contains(@class,' topic/entry ')]">
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'li.table'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>							
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'li'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>					
					<xsl:choose>
						<xsl:when test="($list-level mod 2) = 1">
							<xsl:call-template name="getNumber">
								<xsl:with-param name="language" select="$current-language"/>
								<xsl:with-param name="number" select="$number"/>
							</xsl:call-template>
    	      </xsl:when>
						<xsl:otherwise>
							<xsl:number format="a."/>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:choose>
						<xsl:when test="ancestor::*[contains(@class,' topic/entry ')]">
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'li.table'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>							
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'li'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>					
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
		<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/sl ')]/*[contains(@class,' topic/sli ')]">
		<xsl:variable name="list-level" select="count(ancestor-or-self::*[contains(@class,' topic/ul ')] | 
                  ancestor-or-self::*[contains(@class,' topic/dl ')] |
                  ancestor-or-self::*[contains(@class,' topic/sl ')] |
                  ancestor-or-self::*[contains(@class,' topic/ol ')] )"/>
		<xsl:variable name="extra-list-indent">
			<xsl:value-of select="number($list-level)*16"/>pt</xsl:variable>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()" text-align="end">
				<fo:block linefeed-treatment="ignore">
					<fo:inline>
						<xsl:text> </xsl:text>
					</fo:inline>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<!--xsl:attribute name="start-indent"><xsl:value-of select="$extra-list-indent"/></xsl:attribute-->
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
		<!-- ============================================================== -->
	<xsl:template name="li.name">
		<xsl:if test="string(@id)">
			<fo:inline id="{@id}"> </fo:inline>
		</xsl:if>
	</xsl:template>
		<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/itemgroup ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:inline>
			<!--
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'li'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			-->
			<xsl:apply-templates select="@compact"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/dl ')]">
		<xsl:variable name="list-level" select="count(ancestor-or-self::*[contains(@class,' topic/ul ')] | 
                  ancestor-or-self::*[contains(@class,' topic/dl ')] |
                  ancestor-or-self::*[contains(@class,' topic/sl ')] |
                  ancestor-or-self::*[contains(@class,' topic/ol ')] )"/>

<!--xsl:message>List-level: <xsl:value-of select="$list-level" /></xsl:message--> 		
		
		<fo:block>
		  <xsl:choose>
		  <xsl:when test="count(ancestor::*[contains(@class,' topic/entry ')]) > 0" />
		  <xsl:when test="$list-level = 1">
			   <xsl:call-template name="add.style">
				   <xsl:with-param name="style" select="'dl'"/>
				   <xsl:with-param name="language" select="$language"/>
			   </xsl:call-template>		
			</xsl:when>
			<xsl:otherwise>
			   <xsl:call-template name="add.style">
				   <xsl:with-param name="style" select="'dl.list'"/>
				   <xsl:with-param name="language" select="$language"/>
			   </xsl:call-template>					
			</xsl:otherwise>
			</xsl:choose>			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
		<!-- ============================================================== -->
	<xsl:template match="*[contains(@class, ' topic/dlhead ')]">
		<fo:block font-weight="bold" text-decoration="underline">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
		<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/dthd ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:block font-weight="bold">
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'dt'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:call-template name="apply-for-phrases"/>
		</fo:block>
	</xsl:template>
		<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/ddhd ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:block font-weight="bold">
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'dd'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:call-template name="apply-for-phrases"/>
		</fo:block>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/dlentry ')]">
                 	
		<fo:block>
			<xsl:call-template name="add.style">
			   <xsl:with-param name="style" select="'dlentry'"/>
			   <xsl:with-param name="language" select="$language"/>
			</xsl:call-template>				
			<xsl:if test="string(@id)"><fo:inline id="{@id}"/></xsl:if>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
		<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/dt ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'dt'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="*">
					<!-- tagged content - do not default to bold -->
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<fo:inline font-weight="bold">
						<xsl:call-template name="apply-for-phrases"/>
					</fo:inline>
					<!-- text only - bold it -->
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/dd ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:variable name="list-level" select="count(ancestor-or-self::*[contains(@class,' topic/ul ')] | 
                  ancestor-or-self::*[contains(@class,' topic/dl ')] |
                  ancestor-or-self::*[contains(@class,' topic/sl ')] |
                  ancestor-or-self::*[contains(@class,' topic/ol ')] )"/>
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'dd'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:attribute name="start-indent">
				<xsl:choose>
					<xsl:when test="count(ancestor::*[contains(@class,' topic/entry ')]) = 0">
					   <xsl:value-of select="concat(24 * ($list-level + 1),'pt')"/>
					</xsl:when>
					<xsl:otherwise>
					   <xsl:value-of select="concat(24 * ($list-level),'pt')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
		<!-- ============================================================== -->
	<!-- case of dl within a table cell 
	<xsl:template match="*[contains(@class,' topic/entry ')]//*[contains(@class,' topic/dd ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'dd.cell'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>-->
		<!-- ============================================================== -->
	<!-- case of dl within a simpletable cell -->
	<xsl:template match="*[contains(@class,' topic/stentry ')]//*[contains(@class,' topic/dd ')]" priority="2">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'dd.cell'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- =================== end of element rules ====================== -->
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="*[contains(@class,' apiref/paramlist ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'blocklabel'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:call-template name="getString">
				<xsl:with-param name="stringName" select="'Parameters'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<!--Parameters:-->
		</fo:block>
		<fo:block>
			<fo:table>
				<xsl:call-template name="add.style">
					<xsl:with-param name="style" select="'table.data frameall'"/>
					<xsl:with-param name="language" select="$language"/>
				</xsl:call-template>
				<fo:table-column column-width="25%"/>
				<fo:table-column column-width="15%"/>
				<fo:table-column column-width="15%"/>
				<fo:table-column column-width="45%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell start-indent="2pt" background-color="silver" padding="2pt" text-align="left" font-weight="bold">
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'frameall'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
							<fo:block>Name</fo:block>
						</fo:table-cell>
						<fo:table-cell start-indent="2pt" background-color="silver" padding="2pt" text-align="left" font-weight="bold">
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'frameall'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
							<fo:block>Type</fo:block>
						</fo:table-cell>
						<fo:table-cell start-indent="2pt" background-color="silver" padding="2pt" text-align="left" font-weight="bold">
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'frameall'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
							<fo:block>Direction</fo:block>
						</fo:table-cell>
						<fo:table-cell start-indent="2pt" background-color="silver" padding="2pt" text-align="left" font-weight="bold">
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'frameall'"/>
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
							<fo:block>Description</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<xsl:apply-templates/>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<xsl:template match="*[contains(@class,' apiref/param')][contains(@class,' topic/strow ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:param name="apiRefClassString" select="concat('apiref/param',substring-before(substring-after(@class,' apiref/param'),' '))"/>
		<xsl:param name="paramDirection">
			<xsl:choose>
				<xsl:when test="contains($apiRefClassString,'InOut')">InOut</xsl:when>
				<xsl:when test="contains($apiRefClassString,'Out')">Out</xsl:when>
				<xsl:when test="contains($apiRefClassString,'In')">In</xsl:when>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="paramType" select="substring-before(substring-after($apiRefClassString,'apiref/param'),$paramDirection)"/>
		<fo:table-row>
			<fo:table-cell start-indent="2pt" background-color="#fafafa" padding="2pt">
				<xsl:call-template name="add.style">
					<xsl:with-param name="style" select="'frameall'"/>
					<xsl:with-param name="language" select="$language"/>
				</xsl:call-template>
				<fo:block>
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:apply-templates select="*[contains(@class,' apiref/paramName ')]/text() | *[contains(@class,' apiref/paramName ')]/*"/>
				</fo:block>
			</fo:table-cell>
			<xsl:choose>
				<xsl:when test="$paramType = 'Enum'">
					<fo:table-cell start-indent="2pt" background-color="#fafafa" padding="2pt">
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'frameall'"/>
							<xsl:with-param name="language" select="$language"/>
						</xsl:call-template>
						<fo:block>
							<xsl:attribute name="font-size">9pt</xsl:attribute>
							<xsl:apply-templates select="*[contains(@class,' apiref/paramEnumName ')]/text() | *[contains(@class,' apiref/paramEnumName ')]/*"/>
						</fo:block>
					</fo:table-cell>
				</xsl:when>
				<xsl:otherwise>
					<fo:table-cell start-indent="2pt" background-color="#fafafa" padding="2pt">
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'frameall'"/>
							<xsl:with-param name="language" select="$language"/>
						</xsl:call-template>
						<fo:block>
							<xsl:attribute name="font-size">9pt</xsl:attribute>
							<xsl:value-of select="$paramType"/>
						</fo:block>
					</fo:table-cell>
				</xsl:otherwise>
			</xsl:choose>
			<fo:table-cell start-indent="2pt" background-color="#fafafa" padding="2pt">
				<xsl:call-template name="add.style">
					<xsl:with-param name="style" select="'frameall'"/>
					<xsl:with-param name="language" select="$language"/>
				</xsl:call-template>
				<fo:block>
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:value-of select="$paramDirection"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell start-indent="2pt" background-color="#fafafa" padding="2pt">
				<xsl:call-template name="add.style">
					<xsl:with-param name="style" select="'frameall'"/>
					<xsl:with-param name="language" select="$language"/>
				</xsl:call-template>
				<fo:block>
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:apply-templates select="*[contains(@class,' apiref/paramDesc ')]/text() | *[contains(@class,' apiref/paramDesc ')]/*"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	<xsl:template match="*[contains(@class,' apiref/remarks ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block id="{$id}">
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'blocklabel'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>		
			<xsl:call-template name="getString">
				<xsl:with-param name="stringName" select="'Remarks'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>		
			<!--<fo:block>Remarks:</fo:block>-->
		</fo:block>
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="*[contains(@class,' apiref/knownissues ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<fo:block>
		  <xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'blocklabel'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:call-template name="getString">
				<xsl:with-param name="stringName" select="'Known issues'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>	
		</fo:block>
		<fo:block>	
			<!--<fo:block>Known issues:</fo:block>-->
						
			<xsl:variable name="list-level" select="count(ancestor-or-self::*[contains(@class,' topic/ul ')] | 
                  ancestor-or-self::*[contains(@class,' topic/dl ')] |
                  ancestor-or-self::*[contains(@class,' topic/sl ')] |
                  ancestor-or-self::*[contains(@class,' topic/ol ')] )"/>
			<fo:list-block>
				<xsl:call-template name="add.style">
					<xsl:with-param name="style" select="'list'"/>
					<xsl:with-param name="language" select="$language"/>
				</xsl:call-template>			
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
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[contains(@class,' apiref/purpose ')]">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block id="{$id}">
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'block'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
		</fo:block>
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
</xsl:stylesheet>

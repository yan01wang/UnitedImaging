<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.1">
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' task/context ')]" priority="99">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:if test="$insert.elementlabels = '[param not found]' or $insert.elementlabels = 'yes'">				
  		<fo:block>
  			<xsl:call-template name="add.style">
  				<xsl:with-param name="style" select="'blocklabel'"/>
  				<xsl:with-param name="language" select="$language"/>
  			</xsl:call-template>		
  			<xsl:call-template name="getString">
  				<xsl:with-param name="stringName" select="'Context'"/>
  				<xsl:with-param name="language" select="$language"/>
  			</xsl:call-template>
  		</fo:block>
		</xsl:if>
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'block'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>				
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' task/prereq ')]" priority="99">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:if test="$insert.elementlabels = '[param not found]' or $insert.elementlabels = 'yes'">				
  		<fo:block>
  			<xsl:call-template name="add.style">
  				<xsl:with-param name="style" select="'blocklabel'"/>
  				<xsl:with-param name="language" select="$language"/>
  			</xsl:call-template>		
  			<xsl:call-template name="getString">
  				<xsl:with-param name="stringName" select="'Prerequisites'"/>
  				<xsl:with-param name="language" select="$language"/>
  			</xsl:call-template>
  		</fo:block>
		</xsl:if>
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'block'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>						
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' task/postreq ')]" priority="99">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:if test="$insert.elementlabels = '[param not found]' or $insert.elementlabels = 'yes'">				
  		<fo:block>
  			<xsl:call-template name="add.style">
  				<xsl:with-param name="style" select="'blocklabel'"/>
  				<xsl:with-param name="language" select="$language"/>
  			</xsl:call-template>				
  			<xsl:call-template name="getString">
  				<xsl:with-param name="stringName" select="'Postrequisites'"/>
  				<xsl:with-param name="language" select="$language"/>
  			</xsl:call-template>
  		</fo:block>
		</xsl:if>
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'block'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>						
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' task/result ')]" priority="99">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:if test="$insert.elementlabels = '[param not found]' or $insert.elementlabels = 'yes'">				
  		<fo:block>
  			<xsl:call-template name="add.style">
  				<xsl:with-param name="style" select="'blocklabel'"/>
  				<xsl:with-param name="language" select="$language"/>
  			</xsl:call-template>				
  			<xsl:call-template name="getString">
  				<xsl:with-param name="stringName" select="'Result'"/>
  				<xsl:with-param name="language" select="$language"/>
  			</xsl:call-template>
  		</fo:block>
    </xsl:if>
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'block'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>						
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' task/steps ')]" priority="99">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>
		<xsl:if test="$insert.elementlabels = '[param not found]' or $insert.elementlabels = 'yes'">				
  		<fo:block>
  			<xsl:call-template name="add.style">
  				<xsl:with-param name="style" select="'blocklabel'"/>
  				<xsl:with-param name="language" select="$language"/>
  			</xsl:call-template>				
  			<xsl:call-template name="getString">
  				<xsl:with-param name="stringName" select="'Steps'"/>
  				<xsl:with-param name="language" select="$language"/>
  			</xsl:call-template>
  		</fo:block>
		</xsl:if>
		<fo:list-block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'block'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>						
			<xsl:apply-templates/>
		</fo:list-block>
    <!-- TODO no numbering needs to be shown if only one step is involved
		<xsl:choose>
			<xsl:when test="count(*[contains(@class,' task/step ')]) = 1">
				<fo:block>
					<xsl:call-template name="add.style">
						<xsl:with-param name="style" select="'block'"/>
            <xsl:with-param name="language" select="$language"/>
					</xsl:call-template>								
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:list-block>
					<xsl:call-template name="add.style">
						<xsl:with-param name="style" select="'block'"/>
            <xsl:with-param name="language" select="$language"/>
					</xsl:call-template>								
					<xsl:apply-templates/>
				</fo:list-block>
			</xsl:otherwise>
		</xsl:choose>
		-->
	</xsl:template>
	<!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' task/choicetable ')]" priority="99">
		<xsl:param name="language"><xsl:call-template name="get.current.language"/></xsl:param>

		<fo:block>
			<fo:table>
				<xsl:call-template name="add.style">
					<xsl:with-param name="style" select="'choicetable frameall'"/>
					<xsl:with-param name="language" select="$language"/>
				</xsl:call-template>							
				<xsl:call-template name="semtbl-colwidth"/>
				<fo:table-body>
					<xsl:call-template name="gen-dflt-data-hdr">
						<xsl:with-param name="language" select="$language"/>
					</xsl:call-template>
					<xsl:apply-templates/>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<!-- ============================================================== -->
</xsl:stylesheet>

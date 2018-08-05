<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- ============================================================== -->
	<xsl:template name="filesystem.path.buildpath">
		<xsl:param name="path"/>
		<xsl:param name="name"/>
		<xsl:variable name="normalized.path">
			<xsl:choose>
				<xsl:when test="substring(translate(normalize-space($path),'\','/'),string-length(normalize-space($path)))='/'">
					<xsl:value-of select="substring(translate(normalize-space($path),'\','/'),0,string-length(normalize-space($path)))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate(normalize-space($path),'\','/')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="normalized.name">
			<xsl:choose>
				<xsl:when test="starts-with(translate(normalize-space($name),'\','/'),'/')">
					<xsl:value-of select="substring(translate(normalize-space($name),'\','/'),2)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate(normalize-space($name),'\','/')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($normalized.path,'/',$normalized.name)"/>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="filesystem.path.extractpath">
		<xsl:param name="path"/>
		<!-- file name with file path -->
		<xsl:param name="xml-path"/>
		<!-- used to extract the file path -->
		<xsl:param name="href"/>
		<xsl:choose>
			<xsl:when test="contains($path,'/')">
				<xsl:call-template name="filesystem.path.extractpath">
					<xsl:with-param name="path">
						<xsl:value-of select="substring-after($path,'/')"/>
					</xsl:with-param>
					<xsl:with-param name="xml-path">
						<xsl:value-of select="concat($xml-path,substring-before($path,'/'),'/')"/>
					</xsl:with-param>
					<xsl:with-param name="href">
						<xsl:value-of select="$href"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="href"><xsl:value-of select="concat($xml-path,$href)"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="filesystem.path.getbasepath">
		<xsl:param name="path"/>
		<xsl:choose>
			<xsl:when test="contains(normalize-space($path),'.')">
				<xsl:variable name="left">
					<xsl:value-of select="substring-before($path,'.')"/>
				</xsl:variable>
				<xsl:variable name="right">
					<xsl:call-template name="filesystem.path.getbasepath">
						<xsl:with-param name="path">
							<xsl:value-of select="substring-after($path,'.')"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat($left,$right)"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template name="filesystem.path.stripId">
		<xsl:param name="filename"/>
		<xsl:param name="filehead"/>
		<xsl:choose>
			<xsl:when test="contains($filename,'/')">
				<xsl:call-template name="filesystem.path.stripId">
					<xsl:with-param name="filename">
						<xsl:value-of select="substring-after($filename,'/')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($filename,'\')">
				<xsl:call-template name="filesystem.path.stripId">
					<xsl:with-param name="filename">
						<xsl:value-of select="substring-after($filename,'\')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($filename,'.')">
				<xsl:call-template name="filesystem.path.stripId">
					<xsl:with-param name="filename">
						<xsl:value-of select="substring-after($filename,'.')"/>
					</xsl:with-param>
					<xsl:with-param name="filehead">
						<xsl:value-of select="concat($filehead,'.',substring-before($filename,'.'))"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="string-length($filehead) = 0">
				<xsl:value-of select="$filename"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="filesystem.url.urlencode">
					<xsl:with-param name="url" select="substring-after($filehead,'.')"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="filesystem.url.urlencode">
		<xsl:param name="url"/>
		<xsl:choose>
			<xsl:when test="contains($url,&quot; &quot;)">
				<xsl:call-template name="filesystem.url.urlencode">
					<xsl:with-param name="url">
						<xsl:value-of select="concat(substring-before($url,&quot; &quot;), &quot;%20&quot;, substring-after($url,&quot; &quot;))"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$url"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================================================== -->
</xsl:stylesheet>

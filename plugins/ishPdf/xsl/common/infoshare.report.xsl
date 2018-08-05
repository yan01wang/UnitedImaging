<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- ==================================================================== -->
	<xsl:template name="report.getfilename">
		<xsl:param name="id"/>
		<xsl:param name="resolution"/>
		<xsl:variable name="combined.report.url">
			<xsl:call-template name="filesystem.path.buildpath">
				<xsl:with-param name="path" select="$url.export"/>
				<xsl:with-param name="name" select="$url.report"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="document($combined.report.url)//object-report[@ishref=$id][@resolution=$resolution][@status!='object-missing']/@filename"/>
	</xsl:template>
	<!-- ==================================================================== -->
	<xsl:template name="report.getmetadatafilename">
		<xsl:param name="id"/>
		<xsl:param name="resolution"/>
		<xsl:variable name="filename">
			<xsl:choose>
				<xsl:when test="contains($id,'.')">
					<xsl:value-of select="$id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="report.getfilename">
						<xsl:with-param name="id" select="$id"/>
						<xsl:with-param name="resolution" select="$resolution"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="basepath">
			<xsl:call-template name="filesystem.path.getbasepath">
				<xsl:with-param name="path" select="$filename"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="string-length($basepath) &gt; 0">
			<xsl:value-of select="concat($basepath, $ext.metadata)"/>
		</xsl:if>
	</xsl:template>
	<!-- ==================================================================== -->
</xsl:stylesheet>

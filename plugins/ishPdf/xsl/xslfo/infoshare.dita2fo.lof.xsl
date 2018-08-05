<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
  <!-- ============================================================== -->
	<!-- LIST OF FIGURES -->
	<!-- ============================================================== -->
	<xsl:template name="generate.lof">
		<xsl:param name="language"/>
		<xsl:for-each select="//*[contains(@class,' map/map ')]//*[contains(@class,' topic/image ')]">
			<fo:block>
				<xsl:call-template name="add.style">
					<xsl:with-param name="style" select="'toc2'"/>
					<xsl:with-param name="language" select="$language"/>
				</xsl:call-template>
				<xsl:call-template name="add.changebars">
					<xsl:with-param name="node" select="."/>
					<xsl:with-param name="type" select="'begin'"/>
					<xsl:with-param name="flag.comparison.result" select="'yes'"/>
					<xsl:with-param name="language" select="$language"/>
					<xsl:with-param name="placement" select="'break'"/>
				</xsl:call-template>
				<fo:basic-link internal-destination="{generate-id()}">
					<xsl:choose>
						<xsl:when test="string-length(@alt) > 0">
							<xsl:value-of select="@alt"/>
						</xsl:when>
						<!-- take title of topic -->
						<xsl:otherwise>
							<xsl:value-of select="ancestor::*[contains(@class,' topic/topic ')][1]/*[contains(@class,' topic/title ')]"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:leader leader-pattern="dots"/>
					<fo:page-number-citation ref-id="{generate-id()}"/>
				</fo:basic-link>
				<xsl:call-template name="add.changebars">
					<xsl:with-param name="node" select="."/>
					<xsl:with-param name="type" select="'end'"/>
					<xsl:with-param name="language" select="$language"/>
					<xsl:with-param name="placement" select="'break'"/>
				</xsl:call-template>
			</fo:block>
		</xsl:for-each>
	</xsl:template>
	<!-- ============================================================== -->
</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- ==================================================================== -->
	<xsl:template name="string.reverse">
		<xsl:param name="string"/>
		<xsl:param name="length"/>
		<xsl:if test="$length > 0">
			<xsl:value-of select="substring($string,$length,1)"/>
			<xsl:call-template name="string.reverse">
				<xsl:with-param name="string" select="$string"/>
				<xsl:with-param name="length" select="$length - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- ==================================================================== -->
	<xsl:template name="string.lcase">
		<xsl:param name="inputval"/>
		<xsl:value-of select="translate($inputval,'._-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+=!@#$%^&amp;*()[]{};:\/&lt;&gt;,~?','._-abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz+=!@#$%^&amp;*()[]{};:\/&lt;&gt;,~?')"/>
	</xsl:template>
	<!-- ==================================================================== -->
</xsl:stylesheet>

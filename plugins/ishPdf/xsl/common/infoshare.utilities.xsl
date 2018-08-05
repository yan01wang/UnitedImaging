<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
	<!-- ============================================================== -->
	<xsl:template match="preTranslation">
    <xsl:apply-templates select="*"/>
	</xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="set.anchor">
    <xsl:param name="element" select="."/>
    <xsl:if test="string-length($element/@id) > 0 and $DRAFT = 'yes'">
		  <img onClick="javascript:ToClipboard('{$element/@id}')">
			  <xsl:attribute name="src"><xsl:value-of select="concat($pe.configurationlocation, $img.dflt.path, 'anchor.png')"/></xsl:attribute>
		  </img>
		</xsl:if>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="set.docinfo">
		<xsl:if test="$draft = 'yes'">
		  <a href="{concat($url.documentinfo,ancestor::*[contains(@class, ' topic/topic ')]/@id)}"><img src="{concat($pe.configurationlocation, $img.dflt.path, 'docinfo.png')}" alt="document info"/></a>
    </xsl:if>
  </xsl:template>
	<!-- ============================================================== -->
</xsl:stylesheet>

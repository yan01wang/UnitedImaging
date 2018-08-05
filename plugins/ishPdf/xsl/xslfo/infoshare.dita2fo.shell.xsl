<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fox="http://xml.apache.org/fop/extensions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions">
	<!-- ============================================================== -->
  <!-- common routines -->
  <xsl:include href="../common/infoshare.array.xsl"/>
  <xsl:include href="../common/infoshare.I18N.xsl"/>  
  <xsl:include href="../common/infoshare.jobticket.xsl"/>
	<xsl:include href="../common/infoshare.string.xsl"/>
 	<xsl:include href="../common/infoshare.template.xsl"/>
	<xsl:include href="../common/infoshare.utilities.xsl"/>
	<!-- setup -->
 	<xsl:include href="infoshare.dita2fo.setup.xsl"/>
	<!-- ============================================================== -->
	<!-- get template -->
	<xsl:param name="template">
		<xsl:call-template name="get.template"/>
	</xsl:param>
	<!-- ============================================================== -->
	<xsl:template name="generate">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions">
			<xsl:call-template name="page.setup"/>
			<xsl:call-template name="insert.documentinfo"/>
			<xsl:call-template name="insert.coverpage"/>
			<xsl:call-template name="insert.toc"/>
			<!--xsl:call-template name="insert.report"/-->
			<xsl:call-template name="insert.chapters"/>
			<xsl:if test="$multilingual != 'yes'">
		    <xsl:call-template name="insert.index">
		      <xsl:with-param name="node" select="/*" />
		    </xsl:call-template>
		  </xsl:if>
			<xsl:call-template name="insert.lof"/>		  
		</fo:root>
	</xsl:template>
	<!-- ============================================================== -->
</xsl:stylesheet>
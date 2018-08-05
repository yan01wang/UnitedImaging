<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
	<!-- ============================================================== -->
  <xsl:param name="jobTicket" select="concat('file:///', $WORKDIR, '\', 'ishjobticket.xml')"/>
  <!-- ============================================================== -->
  <xsl:template name="getJobTicketParam">
  	<xsl:param name="varname" />
  	<xsl:param name="default" />
  	<xsl:choose>
			<xsl:when test="document($jobTicket,/)/job-specification/parameter[@name=$varname]">
				<xsl:value-of select="document($jobTicket,/)/job-specification/parameter[@name=$varname]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$default"/>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>  
  <!-- ============================================================== -->
  <xsl:template name="getJobTicketAttrib">
  	<xsl:param name="varname" />
  	<xsl:param name="default" />
  	<!--fo:block>JobTicket: <xsl:value-of select="$jobTicket"/></fo:block-->
  	<xsl:choose>
			<xsl:when test="document($jobTicket)/job-specification/@*[name()=$varname]">
				<xsl:value-of select="document($jobTicket)/job-specification/@*[name()=$varname]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$default"/>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>  
  <!-- ============================================================== -->
</xsl:stylesheet>

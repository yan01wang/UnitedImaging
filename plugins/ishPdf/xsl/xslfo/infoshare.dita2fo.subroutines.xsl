<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version='1.1'>
  <!-- ============================================================== -->  
  <!-- If the element has an ID, copy it through as an anchor. -->
  <xsl:template match="@id">
  <!-- Filler for A-name anchors (empty links)-->
    <xsl:variable name="afill"></xsl:variable>
    <fo:inline>
      <xsl:attribute name="id">
        <xsl:if test="ancestor::*[contains(@class,' topic/body ')]">
         <xsl:value-of select="ancestor::*[contains(@class,' topic/body ')]/parent::*/@id"/><xsl:text>__</xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
      </xsl:attribute>
    <xsl:value-of select="$afill"/></fo:inline>
  </xsl:template>
  <!-- ============================================================== -->    
  <!-- If the element has a compact=yes attribute, assert it in contextually correct form. -->
  <!-- (assumes that no compaction is default) -->
  <xsl:template match="@compact">
    <xsl:if test="@compact = 'yes'">
     <!--xsl:attribute name="compact">compact</xsl:attribute-->
     <!-- NOOP for FO for now; must use padding attributes in block context -->
    </xsl:if>
  </xsl:template>
  <!-- ============================================================== -->  
  <!-- setscale and setframe work are based on text properties. For display-atts
    used for other content, we'll need to develop content-specific attribute processors -->
  <!-- Process the scale attribute for text contexts -->
  <xsl:template name="setscale">
    <xsl:if test="@scale">
      <!-- For applications that do not yet take percentages. need to divide by 10 and use "pt" -->
      <xsl:attribute name="font-size"><xsl:value-of select="@scale div 10"/>pt</xsl:attribute>
    </xsl:if>
  </xsl:template>
  <!-- ============================================================== -->    
  <!-- Process the frame attribute -->
  <!-- frame styles (setframe) must be called within a block that defines the content being framed -->
  <xsl:template name="setframe">
      <!-- top | topbot -->
      <xsl:if test="contains(@frame,'top')">
        <xsl:attribute name="border-top-color">black</xsl:attribute>
        <xsl:attribute name="border-top-width">thin</xsl:attribute>
      </xsl:if>
      <!-- bot | topbot -->
      <xsl:if test="contains(@frame,'bot')">
        <xsl:attribute name="border-bottom-color">black</xsl:attribute>
        <xsl:attribute name="border-bottom-width">thin</xsl:attribute>
      </xsl:if>
      <!-- sides -->
      <xsl:if test="contains(@frame,'sides')">
        <xsl:attribute name="border-left-color">black</xsl:attribute>
        <xsl:attribute name="border-left-width">thin</xsl:attribute>
        <xsl:attribute name="border-right-color">black</xsl:attribute>
        <xsl:attribute name="border-right-width">thin</xsl:attribute>
      </xsl:if>
    <xsl:if test="contains(@frame,'all')">
      <xsl:attribute name="border-style">solid</xsl:attribute>
      <xsl:attribute name="border-color">black</xsl:attribute>
      <xsl:attribute name="border-width">thin</xsl:attribute>
    </xsl:if> 
  </xsl:template>
  <!-- ============================================================== -->  
	<xsl:template name="apply-for-phrases">
		<xsl:choose>
			<xsl:when test="not(text()[normalize-space(.)] | *)">
				<!--xsl:comment>null</xsl:comment-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  <!-- ============================================================== -->  
	<xsl:template name="generate.label">
		<xsl:if test="@spectitle">
			<fo:block font-weight="bold">
				<xsl:value-of select="@spectitle"/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- ============================================================== -->
	<!-- named templates that can be used anywhere -->
	<!-- this replaces newlines with the BR element, forcing non-concatenation even in flow contexts -->
	<xsl:template name="br-replace">
		<xsl:param name="word"/>
		<!-- capture an actual newline within the xsl:text element -->
		<xsl:variable name="cr">
			<xsl:text>
</xsl:text>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($word,$cr)">
				<xsl:value-of select="substring-before($word,$cr)"/>
				<!--br class="br"/-->
				<xsl:call-template name="br-replace">
					<xsl:with-param name="word" select="substring-after($word,$cr)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$word"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================================================== -->
</xsl:stylesheet>

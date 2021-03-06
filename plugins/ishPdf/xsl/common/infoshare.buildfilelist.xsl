<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
	<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
	<!ENTITY charsToEscape "'.?!,'">
	<!ENTITY charsEscaped  "'    '">
	<!ENTITY alphalist "ABCDEFGHIJKLMNOPQRSTUVWXYZ">
	<!ENTITY lngseparator "'#@#'">
	<!ENTITY sq "'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
  <!-- ============================================================== -->
  <!-- Revision History
       1/	20081205: Created - build text file including all files 
                    to be copy by infoshare.copy-files target in 
                    ANT (integrator.xml files of ish plugins)
  -->
  <!-- ============================================================== -->
	<xsl:param name="ISHILLUSTRATION">no</xsl:param><!-- "yes" and "no" are valid values -->
	<xsl:param name="ISHTEMPLATE" select="'no'"/>
	<xsl:param name="ISHMASTERDOC" select="'no'"/>
	<xsl:param name="ISHMODULE" select="'no'"/>
	<xsl:param name="ISHLIBRARY" select="'no'"/>
  <!-- ============================================================== -->
  <xsl:output method="text"
            encoding="UTF-8"
            indent="yes" 
            omit-xml-declaration="yes" />
  <!-- ============================================================== -->
	<xsl:template match="/">
		<xsl:text>xsl-infoshare-common-infoshare.buildfilelist.xsl generated the following file list:</xsl:text>
		<xsl:message>Include IMAGES: <xsl:value-of select="$ISHILLUSTRATION"/></xsl:message>
		<xsl:if test="$ISHILLUSTRATION = 'yes'">
			<xsl:for-each select="//object-report[contains(@ishtype,'ISHIllustration')]">
				<xsl:value-of select="@filename" /><xsl:text>
</xsl:text>
			</xsl:for-each>
		</xsl:if>

		<xsl:message>Include OTHER (Word, PDF): <xsl:value-of select="$ISHTEMPLATE"/></xsl:message>
		<xsl:if test="$ISHTEMPLATE = 'yes'">
			<xsl:for-each select="//object-report[contains(@ishtype,'ISHTemplate')]">
				<xsl:value-of select="@filename" /><xsl:text>
</xsl:text>
			</xsl:for-each>
		</xsl:if>		

		<xsl:message>Include MAPS: <xsl:value-of select="$ISHMASTERDOC"/></xsl:message>
		<xsl:if test="$ISHMASTERDOC = 'yes'">
			<xsl:for-each select="//object-report[contains(@ishtype,'ISHMasterDoc')]">
				<xsl:value-of select="@filename" /><xsl:text>
</xsl:text>
			</xsl:for-each>
		</xsl:if>

		<xsl:message>Include TOPICS: <xsl:value-of select="$ISHMODULE"/></xsl:message>
		<xsl:if test="$ISHMODULE = 'yes'">
			<xsl:for-each select="//object-report[contains(@ishtype,'ISHModule')]">
				<xsl:value-of select="@filename" /><xsl:text>
</xsl:text>
			</xsl:for-each>
		</xsl:if>
		
		<xsl:message>Include LIBRARY TOPICS: <xsl:value-of select="$ISHLIBRARY"/></xsl:message>		
		<xsl:if test="$ISHLIBRARY = 'yes'">
			<xsl:for-each select="//object-report[contains(@ishtype,'ISHLibrary')]">
				<xsl:value-of select="@filename" /><xsl:text>
</xsl:text>
			</xsl:for-each>
		</xsl:if>				
	</xsl:template>	
  <!-- ============================================================== -->
</xsl:stylesheet>

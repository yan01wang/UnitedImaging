<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                  xmlns:exsl="http://exslt.org/common"
                  extension-element-prefixes="exsl"
                  exclude-result-prefixes="exsl"
>

  <xsl:import href="plugin:org.dita.htmlhelp:xsl/map2hhp.xsl"/>
  
  <xsl:output method="text"/>
  
  <xsl:param name="REPORTFILE" select="''" />
  <xsl:param name="ARGSLANGUAGE" select="'en'" />
  
  <xsl:variable name="eol" select="'&#xA;'" />
  
  <!-- root template copied from map2hhpImpl.xsl and changed: 
        setup-options -> custom-setup-options 
        output-filenames -> custom-output-filenames 
        end-hhp -> custom-end-hhp 
        -->
  <!-- *********************************************************************************
     Set up the HHP file, and send filenames to the proper section.
     ********************************************************************************* -->
  <xsl:template match="/">
    <xsl:call-template name="custom-setup-options"/>
    <xsl:call-template name="custom-output-filenames"/>
    <xsl:call-template name="custom-end-hhp"/>
  </xsl:template>

  <!-- custom overrides -->
  <xsl:template name="custom-setup-options">
     <xsl:variable name="setup-options">
      <xsl:call-template name="setup-options">
        <xsl:with-param name="target-language" select="concat($ARGSLANGUAGE, '-')" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:text><!-- possible to add text --></xsl:text>
    <!-- possible to replace parts of the default generated setup-options -->
    <xsl:value-of select="$setup-options"/>
  </xsl:template>

  <xsl:template name="custom-output-filenames">
    <xsl:call-template name="output-filenames" />
  </xsl:template>

  <xsl:template name="custom-end-hhp">
    <!-- could be used to add included statement for Trisoft resource .h file -->
    <xsl:call-template name="end-hhp" />
  </xsl:template>

</xsl:stylesheet>

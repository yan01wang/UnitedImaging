<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<!-- ereview.xsl
 | DITA topic to HTML for ereview & webreview

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">

<!-- stylesheet imports -->
<!-- the main dita to xhtml converter -->
<xsl:import href="xslhtmlhelp/dita2htmlhelp.xsl"/>
<xsl:import href="xslhtmlhelp/note.xsl"/>
<xsl:import href="xslhtmlhelp/taskdisplay.xsl"/>
<xsl:import href="xslhtmlhelp/conceptdisplay.xsl"/>
<xsl:import href="xslhtmlhelp/refdisplay.xsl"/>

<xsl:import xmlns:dita="http://dita-ot.sourceforge.net" 
href="../../ishWebHelp/xsl/xslhtml/infoshare.dita2htm.diff.xsl"/>
<xsl:import href="../../ishApiRef/xsl/infoshare.dita2htm.elems.apiref.xsl"/>

<!-- the dita to xhtml converter for element reference documents - not used now -->
<!--<xsl:import href="elementrefdisp.xsl"/>-->

<xsl:output method="html"
            encoding="UTF-8"
            indent="no"
            doctype-system="http://www.w3.org/TR/html4/loose.dtd"
            doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
/>

  <!-- Set the A-NAME attr for NS -->
  <xsl:template name="setanametag">
    <xsl:param name="idvalue"/>
    <a>
      <xsl:attribute name="name">
        <xsl:if test="ancestor::*[contains(@class,' topic/body ')]">
          <xsl:value-of select="ancestor::*[contains(@class,' topic/body ')]/parent::*/@id"/><xsl:text>__</xsl:text>
        </xsl:if>
        <xsl:value-of select="$idvalue"/>
      </xsl:attribute>
      <xsl:value-of select="$afill"/><xsl:comment><xsl:text> </xsl:text></xsl:comment> <!-- fix for home page reader -->
    </a>
  </xsl:template> 

  <!-- root rule -->
 <xsl:template match="/">
	<xsl:apply-templates/>
 </xsl:template>  

</xsl:stylesheet>

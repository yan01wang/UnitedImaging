<?xml version="1.0"?>

<!-- 
This file is part of the DITA Open Toolkit project hosted on Sourceforge.net. 
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">
    <!-- FIXME: Incorrectly named, should be index.group -->
    <xsl:attribute-set name="index.entry">
        <xsl:attribute name="space-after">14pt</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="index-indents">
        <xsl:attribute name="end-indent">5pt</xsl:attribute>
        <xsl:attribute name="last-line-end-indent">0pt</xsl:attribute>
        <xsl:attribute name="start-indent">36pt</xsl:attribute>
        <xsl:attribute name="text-indent">-36pt</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>
	
    <xsl:attribute-set name="__index__page__link" use-attribute-sets="common.link">
        <xsl:attribute name="page-number-treatment">link</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>
  

</xsl:stylesheet>
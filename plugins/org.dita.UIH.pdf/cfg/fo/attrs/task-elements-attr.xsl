<?xml version='1.0'?>

<!--task attribute template-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <!--Substeps-->
    <xsl:attribute-set name="substeps" use-attribute-sets="ol">
        <xsl:attribute name="space-after">3pt</xsl:attribute>
        <xsl:attribute name="space-before">3pt</xsl:attribute>
		<xsl:attribute name="margin-left">13pt</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="substeps.substep">
	    <xsl:attribute name="space-after">1.5pt</xsl:attribute>
        <xsl:attribute name="space-before">1.5pt</xsl:attribute>
		<xsl:attribute name="margin-left">-5mm</xsl:attribute>
        <xsl:attribute name="relative-align">baseline</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>
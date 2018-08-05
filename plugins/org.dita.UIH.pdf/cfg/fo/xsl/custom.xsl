<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
	xmlns:opentopic="http://www.idiominc.com/opentopic"
	xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
	xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
	xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
	exclude-result-prefixes="xs dita-ot opentopic-index opentopic opentopic-func ot-placeholder"
	version="2.0">
    		
    <xsl:import href="bookmarks.xsl"/>
	<xsl:import href="toc.xsl"/>
	<xsl:import href="copyright.xsl"/>
	<xsl:import href="preface.xsl"/>
	<xsl:import href="commons.xsl"/>
	<xsl:import href="links.xsl"/>
	<xsl:import href="lists.xsl"/>
	<xsl:import href="graphics.xsl"/>
    <xsl:import href="tables.xsl"/>
	<xsl:import href="task-elements.xsl"/>
	<xsl:import href="static-content.xsl"/>
	<xsl:import href="index.xsl"/>
	<!--<xsl:import href="root-processing.xsl"/>-->
	<xsl:import href="../attrs/toc-attr.xsl"/>
	<xsl:import href="../attrs/basic-settings.xsl"/>
	<xsl:import href="../attrs/index-attr.xsl"/>
	<xsl:import href="../attrs/tables-attr.xsl"/>
	<xsl:import href="../attrs/lists-attr.xsl"/>
	<xsl:import href="../attrs/layout-masters-attr.xsl"/>
	<xsl:import href="../attrs/commons-attr.xsl"/>
    <xsl:import href="../attrs/index-attr.xsl"/>
	<xsl:import href="../attrs/task-elements-attr.xsl"/>
	
	<xsl:import href="../layout-masters.xsl"/>

	
    <xsl:param name="defaultLanguage" select="'en'" as="xs:string"/>
	
	<xsl:param name="p_manual_name" select="//opentopic:map/title"/>
	
	<xsl:param name="p_manual_type" select="/bookmap/@type"/>

    <xsl:param name="DEFAULTLANG" select="if (/*/@xml:lang) then /*/@xml:lang else $defaultLanguage" as="xs:string"/>
    
	<!--=========================================
	    p_fda='Y':Page 21.59cm x 27.94cm
	    p_fda='N':page 21.0cm x 29.7cm      
		==========================================-->
	<xsl:param name="p_fda" select="'N'"/>
	
	
</xsl:stylesheet>
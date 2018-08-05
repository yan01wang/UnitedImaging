<?xml version="1.0" encoding="utf-8"?>
<!-- This file is part of the DITA Open Toolkit project.
     See the accompanying license.txt file for applicable licenses. -->
<!-- (c) Copyright Suite Solutions -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="xs">


  <!--=============================================
       Handling frontmatter toc title level
	   tocMaximumLevel=2 display 1 level titles
	   tocMaximumLevel=3 display 2 level titles
	   tocMaximumLevel=4 display 3 level titles
	   default value as below:
    ==============================================-->
    <xsl:param name="tocMaximumLevel" select="3"/>
  
  <!--=============================================
       Handling BOOKMARK title level
	   p_book_Level=2 display 1 level titles
	   p_book_Level=3 display 2 level titles
	   p_book_Level=4 display 3 level titles
	   p_book_Level=5 display 4 level titles
	   default value as below:
    ==============================================-->
    <xsl:param name="p_book_Level" select="4"/>
  
  <!--================================================
       Handling chapter toc title level
	   chaptertocMaximumLevel=2 display 1 level titles
	   chaptertocMaximumLevel=3 display 2 level titles
	   chaptertocMaximumLevel=4 display 3 level titles
	   chaptertocMaximumLevel=5 display 4 level titles
    ==================================================-->
    <xsl:param name="chaptertocMaximumLevel" select="4"/>
  
  <!--===========================================
       page width and height
    ===========================================-->
    <xsl:variable name="page-width">
      <xsl:choose>
	    <xsl:when test="contains($DEFAULTLANG,'zh')">
		    <xsl:value-of select="'21.0cm'"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:choose>
				<xsl:when test="$p_fda='Y'">
                      <xsl:value-of select="'21.59cm'"/>
				</xsl:when>
				<xsl:otherwise>
				       <xsl:value-of select="'21.0cm'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>
	
    <xsl:variable name="page-height">
       <xsl:choose>
	    <xsl:when test="contains($DEFAULTLANG,'zh')">
		      <xsl:value-of select="'29.7cm'"/><!--28.5cm-->
		</xsl:when>
		<xsl:otherwise>
		    <xsl:choose>
				<xsl:when test="$p_fda='Y'">
                     <xsl:value-of select="'27.94cm'"/>
				</xsl:when>
				<xsl:otherwise>
				      <xsl:value-of select="'29.7cm'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	  </xsl:choose>
    </xsl:variable>


	<!-- Change these if your page has different margins on different sides. -->
	<xsl:variable name="page-margin-inside" select="'2.5cm'"/>
	<xsl:variable name="page-margin-outside" select="'2.0cm'"/>
	<xsl:variable name="page-margin-top" select="'2.5cm'"/>
	<xsl:variable name="page-margin-bottom" select="'2.2cm'"/>
	<xsl:variable name="page-region-top" select="'1.56cm'"/><!--1.2cm+0.36cm-->
	<xsl:variable name="page-region-bottom" select="'1.25cm'"/><!--2.2cm-0.95cm-->
 
    <!--=========================================================
      default value "true()" : display odd and even page
	  setting mirror-page-margins="false()" : display odd page
	  ========================================================-->
    <xsl:variable name="mirror-page-margins" select="true()"/>

  
    <!--=========================================================
      default value "true()" : display odd and even page
	  setting mirror-page-margins="false()" : display odd page
	  ========================================================-->
    <xsl:variable name="default-font-size">10pt</xsl:variable>
    <xsl:variable name="default-line-height">14pt</xsl:variable>
	
	<!--The side column width is the amount the body text is indented relative to the margin. -->
	<xsl:variable name="side-col-width">85pt</xsl:variable>

    <xsl:variable name="generate-front-cover" select="true()"/>
    <xsl:variable name="generate-back-cover" select="false()"/>
    <xsl:variable name="generate-toc" select="true()"/>
  
</xsl:stylesheet>

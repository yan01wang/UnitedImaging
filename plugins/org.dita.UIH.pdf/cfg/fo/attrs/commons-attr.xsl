<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    version="2.0">

  <!-- common attribute sets -->

    <xsl:attribute-set name="__fo__root" use-attribute-sets="base-font">
	    <!-- Sans/Serif/Monospaced -->
        <xsl:attribute name="font-family">Sans</xsl:attribute>
        <!-- TODO: https://issues.apache.org/jira/browse/FOP-2409 -->
        <xsl:attribute name="xml:lang" select="translate($locale, '_', '-')"/>
        <xsl:attribute name="writing-mode" select="$writing-mode"/>
    </xsl:attribute-set>

    <xsl:attribute-set name="base-font">
		<xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
		<xsl:attribute name="color"><xsl:value-of select="'#333333'"/></xsl:attribute><!-- 80% gray for font color -->
	</xsl:attribute-set>
  
    <xsl:attribute-set name="page-sequence.copyright" use-attribute-sets="__force__page__count">
       <xsl:attribute name="format">1</xsl:attribute>  
    </xsl:attribute-set>
	
	<xsl:attribute-set name="chaptertoc_header">
	   <xsl:attribute name="font-size">16pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="chaptertoc_content">
	    <xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="provisional-distance-between-starts">28pt</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">12pt</xsl:attribute>
        <xsl:attribute name="space-after">12pt</xsl:attribute>
        <xsl:attribute name="space-before">12pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="preface.title">
        <xsl:attribute name="border-after-width">3pt</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">16.8pt</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="padding-top">16.8pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="topic.topic.title">
        <xsl:attribute name="space-before">15pt</xsl:attribute>
        <xsl:attribute name="space-before">12pt</xsl:attribute>
        <xsl:attribute name="space-after">5pt</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">12pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="image">
	    <xsl:attribute name="content-width">60%</xsl:attribute>
		<xsl:attribute name="content-height">60%</xsl:attribute>
		<xsl:attribute name="alignment-baseline">middle</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="fig">
	      <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="fig.title" use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-weight">normall</xsl:attribute>
        <xsl:attribute name="space-before">5pt</xsl:attribute>
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="body__toplevel" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent"><xsl:value-of select="$side-col-width"/></xsl:attribute>
		<xsl:attribute name="space-before">7pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="body__secondLevel" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent"><xsl:value-of select="$side-col-width"/></xsl:attribute>
		<xsl:attribute name="space-before">8pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="body" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent"><xsl:value-of select="$side-col-width"/></xsl:attribute>
		<xsl:attribute name="space-before">8pt</xsl:attribute>
    </xsl:attribute-set>
    
	<xsl:attribute-set name="conbody" use-attribute-sets="body">
    </xsl:attribute-set>
	
	<xsl:attribute-set name="common.link">
    <xsl:attribute name="color">#0E34E5</xsl:attribute>
    <xsl:attribute name="font-style">normal</xsl:attribute>
    </xsl:attribute-set>
  
    <!-- table border color #B0C6CD -->
    <xsl:attribute-set name="common.border__top">
		<xsl:attribute name="border-before-style">solid</xsl:attribute>
		<xsl:attribute name="border-before-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-before-color">#B0C6CD</xsl:attribute>
	</xsl:attribute-set>

    <xsl:attribute-set name="common.border__bottom">
		<xsl:attribute name="border-after-style">solid</xsl:attribute>
		<xsl:attribute name="border-after-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-after-color">#B0C6CD</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="common.border__right">
		<xsl:attribute name="border-end-style">solid</xsl:attribute>
		<xsl:attribute name="border-end-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-end-color">#B0C6CD</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="common.border__left">
		<xsl:attribute name="border-start-style">solid</xsl:attribute>
		<xsl:attribute name="border-start-width">0.5pt</xsl:attribute>
		<xsl:attribute name="border-start-color">#B0C6CD</xsl:attribute>
    </xsl:attribute-set>
  
    <xsl:attribute-set name="section" use-attribute-sets="base-font">
        <xsl:attribute name="line-height"><xsl:value-of select="$default-line-height"/></xsl:attribute>
        <xsl:attribute name="space-before">0.6em</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="section_title" use-attribute-sets="common.title">
        <xsl:attribute name="font-weight">normall</xsl:attribute>
        <xsl:attribute name="space-before">15pt</xsl:attribute>
		<xsl:attribute name="space-after">5pt</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		
		    <xsl:attribute name="margin-bottom">
		        <xsl:if test="following-sibling::*[contains(@class,' topic/indexterm ')]">     
		            <xsl:value-of select="'-15mm'"/>
		        </xsl:if>   
		    </xsl:attribute>
			<xsl:attribute name="color">
		        <xsl:if test="following-sibling::*[contains(@class,' topic/indexterm ')]">     
		            <xsl:value-of select="'red'"/>
		        </xsl:if>   
		    </xsl:attribute>
		
    </xsl:attribute-set>
	
	<xsl:attribute-set name="example" use-attribute-sets="base-font common.border">
        <xsl:attribute name="line-height"><xsl:value-of select="$default-line-height"/></xsl:attribute>
        <xsl:attribute name="space-before">0.6em</xsl:attribute>
        <xsl:attribute name="start-indent">36pt + from-parent(start-indent)</xsl:attribute>
        <xsl:attribute name="end-indent">36pt</xsl:attribute>
        <xsl:attribute name="padding">5pt</xsl:attribute>
    </xsl:attribute-set>  
  
    <!-- paragraph-like blocks -->
	<xsl:attribute-set name="p" use-attribute-sets="common.block">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
		<xsl:attribute name="margin-top">5pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">
		    <xsl:choose>
			    <xsl:when test="parent::note">
				   <xsl:value-of select="'0pt'"/>
				</xsl:when>
				<xsl:otherwise>
				  <xsl:value-of select="'5pt'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="line-height">14pt</xsl:attribute>
    </xsl:attribute-set>
	
	<xsl:attribute-set name="common.block">
		<xsl:attribute name="space-before">5pt</xsl:attribute>
		<xsl:attribute name="space-after">5pt</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- table cell padding=0-->
	<xsl:attribute-set name="table-cell.body.entry">
		<xsl:attribute name="padding-before">0pt</xsl:attribute>	
		<xsl:attribute name="padding-after">0pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="table_title">
	    <xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="font-weight">normall</xsl:attribute>
		<xsl:attribute name="space-before">10pt</xsl:attribute>
		<xsl:attribute name="space-after">0pt</xsl:attribute>
		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="line-height">14pt</xsl:attribute>
    </xsl:attribute-set>
	
	<!--<xsl:attribute-set name="fig.title">
        <xsl:attribute name="font-weight">normall</xsl:attribute>
        <xsl:attribute name="space-before">4pt</xsl:attribute>
        <xsl:attribute name="space-after">4pt</xsl:attribute>
        <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
		<xsl:attribute name="line-height">12pt</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>-->
	
	<xsl:attribute-set name="prereq">
	    <xsl:attribute name="space-before">0pt</xsl:attribute>
		<xsl:attribute name="space-after">20pt</xsl:attribute>
    </xsl:attribute-set>

	<xsl:attribute-set name="section.title" use-attribute-sets="common.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-before">15pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>
	
	
</xsl:stylesheet>

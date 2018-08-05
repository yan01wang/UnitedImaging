<?xml version='1.0'?>

<!-- 
Copyright © 2004-2006 by Idiom Technologies, Inc. All rights reserved. 
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other 
trademarks are the property of their respective owners. 

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE "AS IS," WITH 
ABSOLUTELY NO WARRANTIES WHATSOEVER, WHETHER EXPRESS OR IMPLIED,  AND IDIOM
TECHNOLOGIES, INC. DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
PURPOSE AND WARRANTY OF NON-INFRINGEMENT. IDIOM TECHNOLOGIES, INC. SHALL NOT
BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, COVER, PUNITIVE, EXEMPLARY,
RELIANCE, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF 
ANTICIPATED PROFIT), ARISING FROM ANY CAUSE UNDER OR RELATED TO  OR ARISING 
OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF IDIOM
TECHNOLOGIES, INC. HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. 

Idiom Technologies, Inc. and its licensors shall not be liable for any
damages suffered by any person as a result of using and/or modifying the
Software or its derivatives. In no event shall Idiom Technologies, Inc.'s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project hosted on Sourceforge.net. 
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <xsl:variable name="toc.text-indent" select="'14pt'"/>
    <xsl:variable name="toc.toc-indent" select="'30pt'"/>

    <xsl:attribute-set name="__toc__header" use-attribute-sets="common.title">
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">8.5pt</xsl:attribute>
        <xsl:attribute name="font-size">20pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__link">
        <xsl:attribute name="line-height">150%</xsl:attribute>
        <!--xsl:attribute name="font-size">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:value-of select="concat(string(20 - number($level) - 4), 'pt')"/>
        </xsl:attribute-->
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content">
        <xsl:attribute name="last-line-end-indent">-22pt</xsl:attribute>
        <xsl:attribute name="end-indent">22pt</xsl:attribute>
        <xsl:attribute name="text-indent">-<xsl:value-of select="$toc.text-indent"/></xsl:attribute>
		<xsl:attribute name="line-height">13pt</xsl:attribute>
        <xsl:attribute name="text-align">start</xsl:attribute>
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
		<xsl:attribute name="space-after">6pt</xsl:attribute>
        <xsl:attribute name="space-before">4pt</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="color">
		    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
		    <xsl:choose>
				<xsl:when test="$level = 2">#333333</xsl:when>
				<xsl:when test="$level = 3">#333333</xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
		</xsl:attribute>
        <xsl:attribute name="font-weight">normal
            <!--<xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">bold</xsl:when>
                <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>-->
        </xsl:attribute>
    </xsl:attribute-set>
    
	<xsl:attribute-set name="chapter_toc2_toc3">
	    <xsl:attribute name="provisional-distance-between-starts">
			<xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
			<xsl:choose>
				<xsl:when test="$level = 2">11mm</xsl:when>
				<xsl:when test="$level = 3">12mm</xsl:when>
				<xsl:otherwise>15mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="provisional-label-separation">
		    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
			<xsl:choose>
				<xsl:when test="$level = 2">7mm</xsl:when>
				<xsl:when test="$level = 3">6mm</xsl:when>
				<xsl:otherwise>10mm</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="margin-left">
		    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
			<xsl:choose>
				<xsl:when test="$level eq 2">
				   <xsl:value-of select="'1.2in'"/>
				</xsl:when>
				<xsl:when test="$level eq 3">
				   <xsl:value-of select="'1.65in'"/>
				</xsl:when>
				<xsl:otherwise>
				  
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="line-height">
		    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
			<xsl:choose>
				<xsl:when test="$level eq 1">
				   <xsl:value-of select="'19pt'"/>
				</xsl:when>
		
				<xsl:otherwise>
				   <xsl:value-of select="'14pt'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="space-before">
		    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
			<xsl:choose>
				<xsl:when test="$level eq 2">
				   <xsl:value-of select="'8pt'"/>
				</xsl:when>
				<xsl:when test="$level eq 3">
				   <xsl:value-of select="'3pt'"/>
				</xsl:when>
				<xsl:otherwise> 
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="space-after">
		    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
			<xsl:choose>
				<xsl:when test="$level eq 2">
				   <xsl:value-of select="'3pt'"/>
				</xsl:when>
				<xsl:when test="$level eq 3">
				   <xsl:value-of select="'3pt'"/>
				</xsl:when>
				<xsl:otherwise> 
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
    </xsl:attribute-set>
	
    <xsl:attribute-set name="__chaptertoc__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">13pt</xsl:attribute>
        <xsl:attribute name="line-height">16pt</xsl:attribute>
		<xsl:attribute name="space-before">0pt</xsl:attribute>
		<xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__appendix__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">20pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__part__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">20pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__preface__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">20pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__notices__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">20pt</xsl:attribute>
    </xsl:attribute-set>

    <!-- Added for back compatibility since __toc__content was renamed into __toc__topic__content-->
    <xsl:attribute-set name="__toc__content" use-attribute-sets="__toc__topic__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__title">
      <xsl:attribute name="end-indent"><xsl:value-of select="$toc.text-indent"/></xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__page-number">
      <xsl:attribute name="start-indent">-<xsl:value-of select="$toc.text-indent"/></xsl:attribute>
      <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__leader">
        <xsl:attribute name="leader-pattern">dots</xsl:attribute>
    </xsl:attribute-set>
	
    <!--added by minnie-->
    <xsl:attribute-set name="__toc__indent">
        <xsl:attribute name="start-indent">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <!--<xsl:value-of select="concat($side-col-width, ' + (', string($level - 1), ' * ', $toc.toc-indent, ') + ', $toc.text-indent)"/>-->
			<xsl:value-of select="'20mm'"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini">
        <xsl:attribute name="font-size">10.5pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="end-indent">5pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__header" use-attribute-sets="__toc__mini common.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__list">
        <xsl:attribute name="provisional-distance-between-starts">18pt</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">12pt</xsl:attribute>
        <xsl:attribute name="space-after">9pt</xsl:attribute>
        <xsl:attribute name="space-before">9pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__label">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__body">
        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
    </xsl:attribute-set>

    <!-- SF Bug 1815571: page-break-after must be on fo:table rather than fo:table-body
                         in order to produce valid XSL-FO 1.1 output. -->
    <xsl:attribute-set name="__toc__mini__table">
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="page-break-after">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__body">
        <!-- SF Bug 1815571: moved page-break-after to __toc__mini__table -->
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__column_1">
        <xsl:attribute name="column-number">1</xsl:attribute>
        <xsl:attribute name="column-width">35%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__column_2">
        <xsl:attribute name="column-number">2</xsl:attribute>
        <xsl:attribute name="column-width">65%</xsl:attribute>
    </xsl:attribute-set>

     <xsl:attribute-set name="__toc__mini__summary" use-attribute-sets="common.border__left">
         <xsl:attribute name="padding-left">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content__booklist" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__indent__booklist" use-attribute-sets="__toc__indent">
        <xsl:attribute name="start-indent"><xsl:value-of select="$side-col-width"/> + <xsl:value-of select="$toc.text-indent"/></xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__topic__content__glossary" use-attribute-sets="__toc__topic__content__booklist">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__topic__content__lot" use-attribute-sets="__toc__topic__content__booklist">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__topic__content__lof" use-attribute-sets="__toc__topic__content__booklist">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__indent__glossary" use-attribute-sets="__toc__indent__booklist">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__indent__lot" use-attribute-sets="__toc__indent__booklist">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__indent__lof" use-attribute-sets="__toc__indent__booklist">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__item__right">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="start-indent">1pt</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>
<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
	<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
	<!ENTITY lngseparator "'#@#'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
  <!-- ============================================================== -->
  <!-- Revision History
       1/	20050727: Created - index generation mechanism
       2/ 20050927: Index terms separated using a comma
  -->
	<!-- ============================================================== -->
	<xsl:key name="letter" match="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm ')]) = 0]" use="translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;)"/>
	<xsl:key name="primary" match="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm ')]) = 0]" use="translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;)" />
	<xsl:key name="secondary" match="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm ')]) != 0]" use="translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,ancestor::*[contains(@class,' topic/indexterm ')]/text(),'#!#',ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;)" />
  <!-- ============================================================== -->
	<xsl:template name="generate.index">
	  <xsl:param name="language"/>
    <!--fo:flow flow-name="IndexColumns"-->
    <!--xsl:message>generate index started</xsl:message-->
    <xsl:choose>
      <xsl:when test="$multilingual = 'yes'">
      	<!--
        <xsl:message>when clause in index with language: <xsl:value-of select="$language" /> and referenced language value: <xsl:value-of select="ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang"/></xsl:message>      
        <xsl:message>first matching node: <xsl:value-of select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(substring(text(),1,1),&lowercase;,&uppercase;))[1]) = 1][$language = ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang][1]"/> </xsl:message>
    		<xsl:message>count matching nodes: <xsl:value-of select="count(//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0 and $language = ancestor-or-self::*/@xml:lang][count(.|key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;))[1]) = 1])"/> </xsl:message>
    		<xsl:message>language: <xsl:value-of select="ancestor-or-self::*/@xml:lang"/> - First Original nodes: <xsl:value-of select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(substring(text(),1,1),&lowercase;,&uppercase;))[1]) = 1][$language = ancestor-or-self::*/@xml:lang][1]"/> </xsl:message>
    		-->
    		
    		<xsl:apply-templates select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;))[1]) = 1][$language = ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang]" mode="index-div">
    			<xsl:with-param name="language" select="$language"/>
    		  <xsl:sort select="translate(.,&lowercase;,&uppercase;)" data-type="text" order="ascending"/>
  			</xsl:apply-templates>
  		</xsl:when>
  		<xsl:otherwise>
  		  <!--xsl:message>otherwise clause in index</xsl:message-->
  	  	<xsl:apply-templates select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;))[1]) = 1]" mode="index-div">
  	  		<xsl:with-param name="language" select="$language"/>
  		    <xsl:sort select="translate(.,&lowercase;,&uppercase;)" data-type="text" order="ascending"/>
  			</xsl:apply-templates>		
  		</xsl:otherwise>
		</xsl:choose>
			<!--/fo:flow-->		
	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template match="*[contains(@class, ' topic/indexterm ')]" mode="index-div">
		<xsl:param name="language"/>
		
	  <xsl:variable name="key" select="translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;)" />
	  <!--<xsl:message>generate index key <xsl:value-of select="$key"/> started</xsl:message>-->
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'blocklabel'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:value-of select="substring-after($key,&lngseparator;)" />
		</fo:block>
		<xsl:apply-templates select="key('letter', $key)[count(.|key('primary',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;))[1])=1]" mode="index-primary">
			<xsl:with-param name="language" select="$language"/>
			<xsl:sort select="translate(.,&lowercase;,&uppercase;)" data-type="text" order="ascending"/>
		</xsl:apply-templates>	
	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/indexterm ')]" mode="index-primary">
		<xsl:param name="language"/>
		
    <xsl:variable name="refs" select="key('primary',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;))" />
		<fo:block text-align="left" axf:suppress-duplicate-page-number="true" margin-left="5mm">
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'index'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:value-of select="./text()"/>
			<!--xsl:if test="$refs[not(current()/*[contains(@class,' topic/indexterm ')])]"-->
			<xsl:if test="$refs[not(./*[contains(@class,' topic/indexterm ')])]">, </xsl:if>
			<!-- print page references of only the primary index terms -->
			<!--xsl:for-each select="$refs[not(current()/*[contains(@class,' topic/indexterm ')])]"-->
			<xsl:for-each select="$refs[not(./*[contains(@class,' topic/indexterm ')])]">
				<fo:basic-link internal-destination="{generate-id()}">
					<fo:page-number-citation ref-id="{generate-id()}"/>
				</fo:basic-link>
				<xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if>
			</xsl:for-each>
		</fo:block>
		<xsl:apply-templates select="$refs/*[contains(@class,' topic/indexterm ')][count(.|key('secondary',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,ancestor::*[contains(@class,' topic/indexterm ')]/text(),'#!#',ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;))[1])=1]" mode="index-secondary">
			<xsl:with-param name="language" select="$language"/>
			<xsl:sort select="translate(.,&lowercase;,&uppercase;)" data-type="text" order="ascending"/>
		</xsl:apply-templates>
	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/indexterm ')]" mode="index-secondary">
		<xsl:param name="language"/>
		
		<xsl:param name="indentLevel">0</xsl:param>
		<xsl:variable name="refs" select="key('secondary',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,ancestor::*[contains(@class,' topic/indexterm ')]/text(),'#!#',ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;))" />
		<fo:block text-align="left" axf:suppress-duplicate-page-number="true" margin-left="{concat(string(10 + (number($indentLevel) * 5)),'mm')}">
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'index'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>
			<xsl:value-of select="./text()"/>
			<xsl:if test="$refs[not(./*[contains(@class,' topic/indexterm ')])]">, </xsl:if>
			<!-- print page references of only if no lowerlevel index terms -->
			<!--xsl:for-each select="$refs[not(current()/*[contains(@class,' topic/indexterm ')])]"-->
			<xsl:for-each select="$refs[not(./*[contains(@class,' topic/indexterm ')])]">
				<fo:basic-link internal-destination="{generate-id()}">
					<fo:page-number-citation ref-id="{generate-id()}"/>
				</fo:basic-link>
				<xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if>
			</xsl:for-each>
		</fo:block>
		<xsl:apply-templates select="$refs/*[contains(@class,' topic/indexterm ')][count(.|key('secondary',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,ancestor::*[contains(@class,' topic/indexterm ')]/text(),'#!#',ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;))[1])=1]" mode="index-secondary">
			<xsl:with-param name="language" select="$language"/>
			<xsl:sort select="translate(.,&lowercase;,&uppercase;)" data-type="text" order="ascending"/>
			<xsl:with-param name="indentLevel" select="number($indentLevel) + 1" />
		</xsl:apply-templates>		
	</xsl:template>	
  <!-- ============================================================== -->
	<!-- Uncomment incase of starting only index generation on a file
	<xsl:template match="/">
		<xsl:call-template name="generate.index"/>
	</xsl:template>
	-->
  <!-- ============================================================== -->
</xsl:stylesheet>

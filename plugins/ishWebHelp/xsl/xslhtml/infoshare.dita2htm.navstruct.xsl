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
       1/	20081203: Created - doc navigation mechanism
  -->
  <!-- ============================================================== -->
	<xsl:import href="../common/infoshare.params.xsl"></xsl:import>
	<xsl:import href="../common/infoshare.jobticket.xsl"></xsl:import>
	<xsl:import href="../common/infoshare.I18N.xsl"></xsl:import>
	<xsl:import href="infoshare.dita2htm.metadata.xsl"></xsl:import>
	<!-- ============================================================== -->
	<xsl:param name="OUTEXT" select="'.js'"/><!-- "htm" and "html" are valid values -->
	<xsl:param name="FILEEXT" select="'.html'"/>
	<xsl:param name="WORKDIR" />
	<xsl:param name="DITAEXT" select="'.xml'"/>
  <!-- ============================================================== -->
  <xsl:output method="text"
            encoding="UTF-8"
            indent="yes" 
            omit-xml-declaration="yes" />
  <!-- ============================================================== -->
	<xsl:template match="/">
		<xsl:message>Search generation. OUTEXT set to: [<xsl:value-of select="$OUTEXT"/>]</xsl:message>
		<xsl:call-template name="generate.navstructurelist">
			<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
		</xsl:call-template>
	</xsl:template>	
  <!-- ============================================================== -->  
	<xsl:template name="generate.navstructurelist">
	  <xsl:param name="language"/>
    <!--fo:flow flow-name="IndexColumns"-->
    <xsl:message>generate navigation structure started. Language set to: [<xsl:value-of select="$language"/>]</xsl:message>
    <xsl:choose>
      <xsl:when test="$multilingual = 'yes'">
      	<!--
        <xsl:message>when clause in index with language: <xsl:value-of select="$language" /> and referenced language value: <xsl:value-of select="ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang"/></xsl:message>      
        <xsl:message>first matching node: <xsl:value-of select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(substring(text(),1,1),&lowercase;,&uppercase;))[1]) = 1][$language = ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang][1]"/> </xsl:message>
    		<xsl:message>count matching nodes: <xsl:value-of select="count(//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0 and $language = ancestor-or-self::*/@xml:lang][count(.|key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;))[1]) = 1])"/> </xsl:message>
    		<xsl:message>language: <xsl:value-of select="ancestor-or-self::*/@xml:lang"/> - First Original nodes: <xsl:value-of select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(substring(text(),1,1),&lowercase;,&uppercase;))[1]) = 1][$language = ancestor-or-self::*/@xml:lang][1]"/> </xsl:message>
    		-->
    		<xsl:text>var FileSequence = [</xsl:text> 				
				<xsl:apply-templates select="//*[contains(@class,' topic/topic ')][$language = ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang]" mode="fileSequence">
					<xsl:with-param name="language" select="$language"/>
				</xsl:apply-templates>		
  			<xsl:text>];
  			
</xsl:text>
  		</xsl:when>
  		<xsl:otherwise>
    		<xsl:text>var FileSequence = [</xsl:text> 
				<xsl:apply-templates select="//*[contains(@class,' topic/topic ')]" mode="fileSequence">
					<xsl:with-param name="language" select="$language"/>
				</xsl:apply-templates>
  			<xsl:text>];

</xsl:text>
  		</xsl:otherwise>
		</xsl:choose>
			<!--/fo:flow-->		
	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="fileSequence">
		<xsl:param name="language"/>
		
	  <xsl:choose>
	  	<xsl:when test="string-length(@oid) > 0 and not(ancestor::*[contains(@class,' glossgroup/glossgroup ')])">
	  		<xsl:message>build plain structure list for included map/topic</xsl:message>
	  		
	  		<xsl:text>"</xsl:text><xsl:value-of select="concat(./@oid,$FILEEXT)"/><xsl:text>"</xsl:text><xsl:if test="position() != last()"><xsl:text>,
</xsl:text></xsl:if>	  		
	  	</xsl:when>
	  	<xsl:otherwise>
	  		<xsl:message>build plain structure list for included map/topic skipped due to missing href value (probably topichead element)</xsl:message>
	  	</xsl:otherwise>
	  </xsl:choose>
<!--		<xsl:message>build plain structure list for included map/topic</xsl:message>
	  
		<xsl:text>"</xsl:text><xsl:value-of select="concat(./@oid,$FILEEXT)"/><xsl:text>"</xsl:text><xsl:if test="position() != last()"><xsl:text>,
</xsl:text></xsl:if>		-->
	</xsl:template>
  <!-- ============================================================== -->
</xsl:stylesheet>

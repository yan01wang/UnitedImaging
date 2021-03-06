<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
	<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
	<!ENTITY charsToEscape "'.?!,\&amp;&lt;&gt;'">
	<!ENTITY charsEscaped  "'        '">
	<!ENTITY alphalist "ABCDEFGHIJKLMNOPQRSTUVWXYZ">
	<!ENTITY lngseparator "'#@#'">
	<!ENTITY sq "'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
  <!-- ============================================================== -->
  <!-- Revision History
       1/ 20080919: Created - search generation mechanism
       2/ 20090430: FC - Removed special characters from the index. 
						 Template to escape characters 'BuidJSSaveString' is currently not sufficient and can only handle one character. 
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
	<xsl:param name="FILEREF" select="'file://'"/>
	<xsl:param name="contenttarget" select="'contentwin'"/>
	<xsl:param name="CSS"/>
	<xsl:param name="CSSPATH"/>
	<xsl:param name="OUTPUTCLASS"/> 
  <!-- ============================================================== -->
  <xsl:output method="text"
            encoding="UTF-8"
            indent="yes" 
            omit-xml-declaration="yes"
/>
  <!-- ============================================================== -->
	<xsl:template match="/">
		<xsl:message>Search generation. OUTEXT set to: [<xsl:value-of select="$OUTEXT"/>]</xsl:message>
		<xsl:call-template name="generate.searchlist">
			<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
		</xsl:call-template>
	</xsl:template>	
  <!-- ============================================================== -->  
	<xsl:template name="generate.searchlist">
	  <xsl:param name="language"/>
    <!--fo:flow flow-name="IndexColumns"-->
    <xsl:message>generate search started. Language set to: [<xsl:value-of select="$language"/>]</xsl:message>
    <xsl:choose>
      <xsl:when test="$multilingual = 'yes'">
      	<!--
        <xsl:message>when clause in index with language: <xsl:value-of select="$language" /> and referenced language value: <xsl:value-of select="ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang"/></xsl:message>      
        <xsl:message>first matching node: <xsl:value-of select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(substring(text(),1,1),&lowercase;,&uppercase;))[1]) = 1][$language = ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang][1]"/> </xsl:message>
    		<xsl:message>count matching nodes: <xsl:value-of select="count(//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0 and $language = ancestor-or-self::*/@xml:lang][count(.|key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;))[1]) = 1])"/> </xsl:message>
    		<xsl:message>language: <xsl:value-of select="ancestor-or-self::*/@xml:lang"/> - First Original nodes: <xsl:value-of select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(substring(text(),1,1),&lowercase;,&uppercase;))[1]) = 1][$language = ancestor-or-self::*/@xml:lang][1]"/> </xsl:message>
    		-->
    		<xsl:text>var SearchFiles = [</xsl:text> 
	    		<xsl:apply-templates select="//*[contains(@class,' topic/topic ')][$language = ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang]" mode="searchfilenames">
	    			<xsl:with-param name="language" select="$language"/>
	  			</xsl:apply-templates>
  			<xsl:text>];
</xsl:text>
    		<xsl:text>var SearchTitles = [</xsl:text> 
	    		<xsl:apply-templates select="//*[contains(@class,' topic/topic ')][$language = ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang]" mode="searchtitles">
	    			<xsl:with-param name="language" select="$language"/>
	  			</xsl:apply-templates>
  			<xsl:text>];
</xsl:text>
    		<xsl:text>var SearchInfo = [</xsl:text> 
	    		<xsl:apply-templates select="//*[contains(@class,' topic/topic ')][$language = ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang]" mode="searchinfo">
	    			<xsl:with-param name="language" select="$language"/>
	  			</xsl:apply-templates>
  			<xsl:text>];
</xsl:text>
  			  			
  		</xsl:when>
  		<xsl:otherwise>
    		<xsl:text>var SearchFiles = [</xsl:text> 
	    		<xsl:apply-templates select="//*[contains(@class,' topic/topic ')]" mode="searchfilenames">
	    			<xsl:with-param name="language" select="$language"/>
	  			</xsl:apply-templates>
  			<xsl:text>];

</xsl:text>
    		<xsl:text>var SearchTitles = [</xsl:text> 
	    		<xsl:apply-templates select="//*[contains(@class,' topic/topic ')]" mode="searchtitles">
	    			<xsl:with-param name="language" select="$language"/>
	  			</xsl:apply-templates>
  			<xsl:text>];

</xsl:text>
    		<xsl:text>var SearchInfo = [</xsl:text> 
	    		<xsl:apply-templates select="//*[contains(@class,' topic/topic ')]" mode="searchinfo">
	    			<xsl:with-param name="language" select="$language"/>
	  			</xsl:apply-templates>
  			<xsl:text>];

</xsl:text>	
  		</xsl:otherwise>
		</xsl:choose>
			<!--/fo:flow-->		
	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="searchfilenames">
		<xsl:param name="language"/>
		
	  <xsl:message>build searchfilenames for topic</xsl:message>
	  
<!--		<fo:block>-->
<!--		<xsl:text>"</xsl:text><xsl:value-of select="concat(./@id,$FILEEXT)"/><xsl:text>"</xsl:text><xsl:if test="position() != last()"><xsl:text>,-->
		<xsl:text>"</xsl:text><xsl:value-of select="concat(./@oid,$FILEEXT)"/><xsl:text>"</xsl:text><xsl:if test="position() != last()"><xsl:text>,
</xsl:text></xsl:if>		
	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="searchtitles">
		<xsl:param name="language"/>
		
		<xsl:variable name="translatedText">
			<xsl:call-template name="BuidJSSaveString">
				<xsl:with-param name="textToEscape">
					<xsl:value-of select="translate(./*[contains(@class, ' topic/title ')],&charsToEscape;,&charsEscaped;)"/>
				</xsl:with-param>
				<xsl:with-param name="textEscaped"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
	  <xsl:message>build searchtitles for topic</xsl:message>
	  
		<xsl:text>"</xsl:text><xsl:value-of select="normalize-space($translatedText)"/><xsl:text>"</xsl:text><xsl:if test="position() != last()"><xsl:text>,
</xsl:text></xsl:if>	

	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="searchinfo">
		<xsl:param name="language"/>
		
<!--		<xsl:variable name="topicId"><xsl:value-of select="./@id" /></xsl:variable>-->
		<xsl:variable name="topicId"><xsl:value-of select="./@oid" /></xsl:variable>
	  <xsl:message>build searchinfo for topic</xsl:message>
	  
<!--		<xsl:text>" </xsl:text><xsl:apply-templates select="./*[ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id=$topicId][not(contains(@class, ' topic/topic '))]" mode="searchinfo">-->
		<xsl:text>" </xsl:text><xsl:apply-templates select="./*[ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@oid=$topicId][not(contains(@class, ' topic/topic '))]" mode="searchinfo">
		<xsl:with-param name="language" select="$language"/>
		<xsl:with-param name="topicId" select="$topicId"/>
		</xsl:apply-templates><xsl:text>"</xsl:text><xsl:if test="position() != last()"><xsl:text>,
</xsl:text></xsl:if>	

	</xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' map/topicref mapgroup-d/topichead ')]" mode="searchinfo">
  	<!-- null processor -->
	</xsl:template>  
  <!-- ============================================================== -->
	<xsl:template match="*[contains(@class, ' topic/indexterm ')] | *[contains(@class, ' topic/related-links ')]  | *[contains(@class, ' topic/prolog ')]" mode="searchinfo">
		<xsl:param name="topicId" />
		<xsl:param name="language" />
		
 		<xsl:message><xsl:value-of select="name(.)" /> skipped</xsl:message>
		<!--<xsl:apply-templates select=".//*[ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id=$topicId][not(contains(@class, ' topic/topic '))]" mode="searchinfo">
			<xsl:with-param name="language" select="$language"/>
			<xsl:with-param name="topicId" select="$topicId"/>
		</xsl:apply-templates>-->

	</xsl:template>	
  <!-- ============================================================== -->
	<xsl:template match="text()" mode="searchinfo">
		<xsl:param name="topicId" />
		<xsl:param name="language" />

		<!-- TO DO: implement a skiplist mechanism (by language) in order to restrict the number of searchable words.-->		
		<!-- Remove textual characters which identify end of sentences (reading-characters)-->		
		<!-- Remove " characters (JS-variables identified by ")-->
		<xsl:variable name="translatedText">
			<xsl:call-template name="BuidJSSaveString">
				<xsl:with-param name="textToEscape">
					<xsl:value-of select="translate(.,&charsToEscape;,&charsEscaped;)"/>
				</xsl:with-param>
				<xsl:with-param name="textEscaped"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>	
		<xsl:value-of select="normalize-space($translatedText)"/><xsl:text> </xsl:text><xsl:apply-templates select=".//*[ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id=$topicId][not(contains(@class, ' topic/topic '))]" mode="searchinfo">
			<xsl:with-param name="language" select="$language"/>
			<xsl:with-param name="topicId" select="$topicId"/>
		</xsl:apply-templates>
	</xsl:template>	
  <!-- ============================================================== -->
  <xsl:template name="BuidJSSaveString">
  	<xsl:param name="textToEscape" />
  	<xsl:param name="textEscaped" />
  	<xsl:variable name="quot">"</xsl:variable>
  	<xsl:choose>
  		<xsl:when test="contains($textToEscape,$quot)">
  			<xsl:call-template name="BuidJSSaveString">
					<xsl:with-param name="textToEscape">
						<xsl:value-of select="substring-after($textToEscape,$quot)"/>
					</xsl:with-param>
					<xsl:with-param name="textEscaped">
						<xsl:value-of select="concat($textEscaped, substring-before($textToEscape,$quot),'\',$quot)" />
					</xsl:with-param>
  			</xsl:call-template>
  		</xsl:when>
  		<xsl:otherwise>
  			<xsl:value-of select="concat($textEscaped,$textToEscape)" />
  		</xsl:otherwise>
  	</xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
</xsl:stylesheet>

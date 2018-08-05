<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
	<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
	<!ENTITY alphalist "ABCDEFGHIJKLMNOPQRSTUVWXYZ">
	<!ENTITY lngseparator "'#@#'">
	<!ENTITY sq "'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
  <!-- ============================================================== -->
  <!-- Revision History
       1/	20080919: Created - index generation mechanism based upon xslfo mechanism
  -->
  <!-- ============================================================== -->
	<xsl:import href="../common/infoshare.params.xsl"></xsl:import>
	<xsl:import href="../common/infoshare.jobticket.xsl"></xsl:import>
	<xsl:import href="../common/infoshare.I18N.xsl"></xsl:import>
	<xsl:import href="infoshare.dita2htm.metadata.xsl"></xsl:import>
	<!-- ============================================================== -->
	<xsl:param name="OUTEXT" select="'.html'"/><!-- "htm" and "html" are valid values -->
	<xsl:param name="WORKDIR" />
	<xsl:param name="DITAEXT" select="'.xml'"/>
	<xsl:param name="FILEREF" select="'file://'"/>
	<xsl:param name="contenttarget" select="'contentwin'"/>
	<xsl:param name="CSS"/>
	<xsl:param name="CSSPATH"/>
	<xsl:param name="OUTPUTCLASS"/> 
	<!-- ============================================================== -->
	<xsl:key name="letter" match="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm ')]) = 0]" use="translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;)"/>
	<xsl:key name="primary" match="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm ')]) = 0]" use="translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;)" />
	<xsl:key name="secondary" match="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm ')]) != 0]" use="translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,ancestor::*[contains(@class,' topic/indexterm ')]/text(),'#!#',ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;)" />
  <!-- ============================================================== -->
	<xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" />	
	<xsl:template match="/">
		<html>
			<head>
				<xsl:choose>
					<xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
						<title>
							<xsl:value-of select="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]"/>
						</title>
					</xsl:when>
					<xsl:when test="/*[contains(@class,' map/map ')]/@title">
						<title>
							<xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
						</title>
					</xsl:when>
					<xsl:otherwise><!-- null processor --></xsl:otherwise>
				</xsl:choose>
				<xsl:if test="string-length($contenttarget)>0 and $contenttarget!='NONE'">
					<base target="{$contenttarget}"/>
				</xsl:if>
				<link rel="stylesheet" type="text/css" href="webhelplayout.css"/>				
				<link rel="stylesheet" type="text/css" href="stylesheet.css" />
				<link rel="stylesheet" type="text/css" href="indexlist.css" />
				<script language="javascript" type="text/javascript" src="toc.js"></script>
				<script language="javascript" type="text/javascript" src="index.js"></script>				
			</head>
			<!--<body onload="open('tab.index.html','tab')">-->
			<body class="framelayout">
				<h1 class="heading1">
					<xsl:call-template name="getString">
						<xsl:with-param name="stringName" select="'Index'" />
						<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
					</xsl:call-template>
				</h1>
				<xsl:if test="string-length($OUTPUTCLASS) &gt; 0">
					<xsl:attribute name="class"><xsl:value-of select="$OUTPUTCLASS"/></xsl:attribute>
				</xsl:if>
				<!--
RS: I rather use div elements instead of tables. Easier to manipulate/customize using stylesheets.				
				<table cellpadding="0" cellspacing="0" border="0" width="100%">
					<tr>
						<td align="left" valign="top" nowrap="nowrap">
						-->
<!--
RS: Commented out due to fact that it is hard to generate correctly localized navigation lists.
						<div id="indexnavigationlist">
							<xsl:call-template name="generate.navigation.list">
								<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>							
							</xsl:call-template>
						</div>
-->
						<div id="indexlist">
							<xsl:call-template name="generate.index">
								<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
							</xsl:call-template>
						</div>
<!--							
						</td>
					</tr>
				</table>
-->				
			</body>
		</html>
	</xsl:template>	
  <!-- ============================================================== -->  
	<xsl:template name="generate.index">
	  <xsl:param name="language"/>
    <!--fo:flow flow-name="IndexColumns"-->
    <xsl:message>generate index started. Language set to: [<xsl:value-of select="$language"/>]</xsl:message>
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
  		  <xsl:message>otherwise clause in index</xsl:message>
  		  <xsl:message>apply-templates called for <xsl:value-of select="count(//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;))[1]) = 1])"/> objects</xsl:message>
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
	  <xsl:message>generate index key <xsl:value-of select="$key"/> started</xsl:message>
	  
<!--		<fo:block>-->
		<div class="IndexSection">
			<a name="{concat('_',substring-after($key,&lngseparator;))}" />
<!--			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'blocklabel'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>-->
			<xsl:value-of select="substring-after($key,&lngseparator;)" />
			
<!--		</fo:block>-->
		<xsl:apply-templates select="key('letter', $key)[count(.|key('primary',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;))[1])=1]" mode="index-primary">
			<xsl:with-param name="language" select="$language"/>
			<xsl:sort select="translate(.,&lowercase;,&uppercase;)" data-type="text" order="ascending"/>
		</xsl:apply-templates>	
		</div>		
	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/indexterm ')]" mode="index-primary">
		<xsl:param name="language"/>
		
    <xsl:variable name="refs" select="key('primary',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;))" />

<!--		<fo:block text-align="left" axf:suppress-duplicate-page-number="true" margin-left="5mm">-->
		<div class="PrimaryIndexTerm" style="margin-left: 5mm">
<!--			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'index'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>-->
			<!--xsl:if test="$refs[not(current()/*[contains(@class,' topic/indexterm ')])]"-->
			<!--<xsl:if test="$refs[not(./*[contains(@class,' topic/indexterm ')])]">, </xsl:if>-->
			<!-- print page references of only the primary index terms -->
			<!--xsl:for-each select="$refs[not(current()/*[contains(@class,' topic/indexterm ')])]"-->
			<xsl:choose>
				<xsl:when test="count($refs[not(./*[contains(@class,' topic/indexterm ')])])=1"><!-- index term has only one target -->
          <xsl:choose>
            <xsl:when test="count(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')])>0">
              <!--					<a  onclick="javascript:hideAllTargets();"  href="{concat(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/@id,$OUTEXT)}"><xsl:value-of select="./text()"/></a>-->
					    <a  onclick="javascript:hideAllTargets();"  href="{concat(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/@oid,$OUTEXT)}"><xsl:value-of select="./text()"/></a>
					  </xsl:when>
					  <xsl:otherwise>
					    <!--					<a  onclick="javascript:hideAllTargets();"  href="{concat(ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@id,$OUTEXT)}"><xsl:value-of select="./text()"/></a>-->
					    <a  onclick="javascript:hideAllTargets();"  href="{concat(ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@oid,$OUTEXT)}"><xsl:value-of select="./text()"/></a>
					  </xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="count($refs[not(./*[contains(@class,' topic/indexterm ')])])>1"><!-- index term has more than one target -->
					<a onclick="javascript:showTargets('{concat('pop',translate(./text(),' ',''))}');" target="_self" style="cursor:pointer"><xsl:value-of select="./text()"/></a>
					<div id="{concat('pop',translate(./text(),' ',''))}" style="display:none; z-index:999;" class="popupDiv">
					<div>
					<!--Select one of the available targets by clicking the link-->
					<xsl:call-template name="getString">
						<xsl:with-param name="stringName" select="'Select one'" />
						<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
					</xsl:call-template>
					</div>
					<div class="popupDivInner">
					<xsl:for-each select="$refs[not(./*[contains(@class,' topic/indexterm ')])]">
            <xsl:choose>
              <xsl:when test="count(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')])>0">
  <!--						<p><a href="{concat(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/@id,$OUTEXT)}" target="{$contenttarget}"><xsl:value-of select="ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/*[contains(@class,' topic/title ')]" /></a></p>-->
  						<p><a href="{concat(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/@oid,$OUTEXT)}" target="{$contenttarget}"><xsl:value-of select="ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/*[contains(@class,' topic/title ')]" /></a></p>
  					  </xsl:when>
  					  <xsl:otherwise>
  <!--						<p><a href="{concat(ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@id,$OUTEXT)}" target="{$contenttarget}"><xsl:value-of select="ancestor-or-self::*[contains(@class,' topic/topic ')][1]/*[contains(@class,' topic/title ')]" /></a></p>-->
  						<p><a href="{concat(ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@oid,$OUTEXT)}" target="{$contenttarget}"><xsl:value-of select="ancestor-or-self::*[contains(@class,' topic/topic ')][1]/*[contains(@class,' topic/title ')]" /></a></p>
  					  </xsl:otherwise>					
					  </xsl:choose>
					</xsl:for-each>
					</div>
					<div><input type="button" onclick="javascript:hideTargets('{concat('pop',translate(./text(),' ',''))}');">
						<xsl:attribute name="value">
							<xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'Close'" />
								<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
							</xsl:call-template>							
						</xsl:attribute>
					</input></div>
					</div>
				</xsl:when>
				<xsl:otherwise><!-- primary index term which has not target defined -->
					<xsl:value-of select="./text()"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Check for see and see-also references -->
			<!-- index-see references -->
			<xsl:if test="$refs[./*[contains(@class,' indexing-d/index-see ')]]">
				<xsl:text>, </xsl:text><i><!--see--><xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'see'" />
								<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
							</xsl:call-template></i><xsl:text> </xsl:text><xsl:value-of select="./*[contains(@class,' indexing-d/index-see ')]" />
			</xsl:if>
			<!-- index-see-also references -->
			<xsl:if test="$refs[./*[contains(@class,' indexing-d/index-see-also ')]]">
				<xsl:text>, </xsl:text><i><!--see also--><xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'see also'" />
								<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
							</xsl:call-template></i><xsl:text> </xsl:text><xsl:value-of select="./*[contains(@class,' indexing-d/index-see-also ')]" />			
			</xsl:if>			
			<!-- End of check for see and see-also references -->
			<!--</fo:block>-->
			<xsl:apply-templates select="$refs/*[contains(@class,' topic/indexterm ')][count(.|key('secondary',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,ancestor::*[contains(@class,' topic/indexterm ')]/text(),'#!#',ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;))[1])=1]" mode="index-secondary">
				<xsl:with-param name="language" select="$language"/>
				<xsl:sort select="translate(.,&lowercase;,&uppercase;)" data-type="text" order="ascending"/>
			</xsl:apply-templates>
		</div>	
	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' topic/indexterm ')]" mode="index-secondary">
		<xsl:param name="language"/>
		
		<xsl:param name="indentLevel">0</xsl:param>
		<xsl:variable name="refs" select="key('secondary',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,ancestor::*[contains(@class,' topic/indexterm ')]/text(),'#!#',ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;))" />
		<!--<fo:block text-align="left" axf:suppress-duplicate-page-number="true" margin-left="{concat(string(10 + (number($indentLevel) * 5)),'mm')}">-->
		<div class="SecondaryIndexTerm" style="margin-left: {concat(string(10 + (number($indentLevel) * 5)),'mm')}">
<!--			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'index'"/>
				<xsl:with-param name="language" select="$language"/>
			</xsl:call-template>-->
			<!--<xsl:value-of select="./text()"/>
			<xsl:if test="$refs[not(./*[contains(@class,' topic/indexterm ')])]">, </xsl:if>
			< ! - - print page references of only if no lowerlevel index terms - - >
			< ! - - xsl:for-each select="$refs[not(current()/*[contains(@class,' topic/indexterm ')])]" - - >
			<xsl:for-each select="$refs[not(./*[contains(@class,' topic/indexterm ')])]">
				<fo:basic-link internal-destination="{generate-id()}">
					<fo:page-number-citation ref-id="{generate-id()}"/>
				</fo:basic-link>
				<xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if>
			</xsl:for-each> -->
			<xsl:choose>
				<xsl:when test="count($refs[not(./*[contains(@class,' topic/indexterm ')])])=1"><!-- index term has only one target -->
          <xsl:choose>
            <xsl:when test="count(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')])>0">
<!--					<a onclick="javascript:hideAllTargets();"  href="{concat(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/@id,$OUTEXT)}"><xsl:value-of select="./text()"/></a> -->
					<a onclick="javascript:hideAllTargets();"  href="{concat(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/@oid,$OUTEXT)}"><xsl:value-of select="./text()"/></a>
					  </xsl:when>
					  <xsl:otherwise>
<!--					<a onclick="javascript:hideAllTargets();"  href="{concat(ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@id,$OUTEXT)}"><xsl:value-of select="./text()"/></a> -->
					<a onclick="javascript:hideAllTargets();"  href="{concat(ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@oid,$OUTEXT)}"><xsl:value-of select="./text()"/></a>
					  </xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="count($refs[not(./*[contains(@class,' topic/indexterm ')])])>1"><!-- index term has more than one target -->
					<a onclick="javascript:showTargets('{concat('pop',translate(./text(),' ',''))}');" target="_self" style="cursor:pointer"><xsl:value-of select="./text()"/></a>
					<div id="{concat('pop',translate(./text(),' ',''))}" style="display:none; z-index:999;" class="popupDiv">
					<div>
					<!--Select one of the available targets by clicking the link-->
					<xsl:call-template name="getString">
						<xsl:with-param name="stringName" select="'Select one'" />
						<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
					</xsl:call-template>
					</div>
					<div class="popupDivInner">
					<xsl:for-each select="$refs[not(./*[contains(@class,' topic/indexterm ')])]">
            <xsl:choose>
              <xsl:when test="count(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')])>0">
<!--						<p><a href="{concat(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/@id,$OUTEXT)}" target="{$contenttarget}"><xsl:value-of select="ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/*[contains(@class,' topic/title ')]" /></a></p>-->
						<p><a href="{concat(ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/@oid,$OUTEXT)}" target="{$contenttarget}"><xsl:value-of select="ancestor-or-self::*[contains(@class,' glossgroup/glossgroup ')][1]/*[contains(@class,' topic/title ')]" /></a></p>
  					  </xsl:when>
  					  <xsl:otherwise>
<!--						<p><a href="{concat(ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@id,$OUTEXT)}" target="{$contenttarget}"><xsl:value-of select="ancestor-or-self::*[contains(@class,' topic/topic ')][1]/*[contains(@class,' topic/title ')]" /></a></p>-->
						<p><a href="{concat(ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@oid,$OUTEXT)}" target="{$contenttarget}"><xsl:value-of select="ancestor-or-self::*[contains(@class,' topic/topic ')][1]/*[contains(@class,' topic/title ')]" /></a></p>
  					  </xsl:otherwise>
  					</xsl:choose>
					</xsl:for-each>
					</div>
					<div><input type="button" onclick="javascript:hideTargets('{concat('pop',translate(./text(),' ',''))}');">
						<xsl:attribute name="value">
							<xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'Close'" />
								<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
							</xsl:call-template>							
						</xsl:attribute>
					</input></div>
					</div>
				</xsl:when>
				<xsl:otherwise><!-- secondary index term which has not target defined -->
					<xsl:value-of select="./text()"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Check for see and see-also references -->
			<!-- index-see references -->
			<xsl:if test="$refs[./*[contains(@class,' indexing-d/index-see ')]]">
				<xsl:text>, </xsl:text><i><!--see--><xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'see'" />
								<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
							</xsl:call-template></i><xsl:text> </xsl:text><xsl:value-of select="./*[contains(@class,' indexing-d/index-see ')]" />
			</xsl:if>
			<!-- index-see-also references -->
			<xsl:if test="$refs[./*[contains(@class,' indexing-d/index-see-also ')]]">
				<xsl:text>, </xsl:text><i><!--see also--><xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'see also'" />
								<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
							</xsl:call-template></i><xsl:text> </xsl:text><xsl:value-of select="./*[contains(@class,' indexing-d/index-see-also ')]" />			
			</xsl:if>			
			<!-- End of check for see and see-also references -->			
		</div>
		<!--</fo:block>-->
		
		<xsl:apply-templates select="$refs/*[contains(@class,' topic/indexterm ')][count(.|key('secondary',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,ancestor::*[contains(@class,' topic/indexterm ')]/text(),'#!#',ancestor-or-self::*/@xml:lang,&lngseparator;,./text()),&lowercase;,&uppercase;))[1])=1]" mode="index-secondary">
			<xsl:with-param name="language" select="$language"/>
			<xsl:sort select="translate(.,&lowercase;,&uppercase;)" data-type="text" order="ascending"/>
			<xsl:with-param name="indentLevel" select="number($indentLevel) + 1" />
		</xsl:apply-templates>		
	</xsl:template>	
  <!-- ============================================================== -->
	<xsl:template name="generate.navigation.list">
	  <xsl:param name="language"/>
    <xsl:message>generate index navigation started. Language set to: [<xsl:value-of select="$language"/>]</xsl:message>

		<xsl:variable name="alphabeticlist">&alphalist;</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string-length($alphabeticlist) > 1">
				<xsl:message>alphabeticlist [<xsl:value-of select="$alphabeticlist"/>] found with (<xsl:value-of select="string-length($alphabeticlist)"/>) characters </xsl:message>
				<xsl:message>indexLetter set to [<xsl:value-of select="substring($alphabeticlist,1,1)"/>]</xsl:message>
				<xsl:message>indexList set to [<xsl:value-of select="substring($alphabeticlist,2,string-length($alphabeticlist)-1)" /> ]</xsl:message>
				<xsl:call-template name="generateNavigationList">
					<xsl:with-param name="language" select="$language"/>
					<xsl:with-param name="indexLetter" select="substring($alphabeticlist,1,1)"/>
					<xsl:with-param name="indexList" select="substring($alphabeticlist,2,string-length($alphabeticlist)-1)" />
				</xsl:call-template>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>alphabeticlist [<xsl:value-of select="$alphabeticlist"/>] found with (<xsl:value-of select="string-length($alphabeticlist)"/>) characters </xsl:message>
				<xsl:call-template name="generateNavigationElement">
					<xsl:with-param name="language" select="$language"/>
					<xsl:with-param name="indexLetter" select="$alphabeticlist"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
<!--
    <xsl:choose>
      <xsl:when test="$multilingual = 'yes'">
      	< ! - -
        <xsl:message>when clause in index with language: <xsl:value-of select="$language" /> and referenced language value: <xsl:value-of select="ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang"/></xsl:message>      
        <xsl:message>first matching node: <xsl:value-of select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(substring(text(),1,1),&lowercase;,&uppercase;))[1]) = 1][$language = ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang][1]"/> </xsl:message>
    		<xsl:message>count matching nodes: <xsl:value-of select="count(//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0 and $language = ancestor-or-self::*/@xml:lang][count(.|key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;))[1]) = 1])"/> </xsl:message>
    		<xsl:message>language: <xsl:value-of select="ancestor-or-self::*/@xml:lang"/> - First Original nodes: <xsl:value-of select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(substring(text(),1,1),&lowercase;,&uppercase;))[1]) = 1][$language = ancestor-or-self::*/@xml:lang][1]"/> </xsl:message>
    		- - >
    		
    		<xsl:apply-templates select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;))[1]) = 1][$language = ancestor-or-self::*[count(ancestor-or-self::*) = 2]/@xml:lang]" mode="index-navigation-div">
    			<xsl:with-param name="language" select="$language"/>
    		  <xsl:sort select="translate(.,&lowercase;,&uppercase;)" data-type="text" order="ascending"/>
  			</xsl:apply-templates>
  		</xsl:when>
  		<xsl:otherwise>
  		  <xsl:message>otherwise clause in index</xsl:message>
  		  <xsl:message>apply-templates called for <xsl:value-of select="count(//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;))[1]) = 1])"/> objects</xsl:message>
  	  	<xsl:apply-templates select="//*[contains(@class,' topic/indexterm ') and count(ancestor::*[contains(@class,' topic/indexterm')])=0][count(.|key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,substring(./text(),1,1)),&lowercase;,&uppercase;))[1]) = 1]" mode="index-navigation-div">
  	  		<xsl:with-param name="language" select="$language"/>
  		    <xsl:sort select="translate(.,&lowercase;,&uppercase;)" data-type="text" order="ascending"/>
  			</xsl:apply-templates>		
  		</xsl:otherwise>
		</xsl:choose>	  
-->		
	</xsl:template> 	
<!-- ============================================================== -->
	<xsl:template name="generateNavigationElement">
	  <xsl:param name="language"/>	
		<xsl:param name="indexLetter" />
		
		<xsl:message>generateNavigationElement - indexLetter [<xsl:value-of select="$indexLetter"/>]</xsl:message>
		<xsl:message>Key [<xsl:value-of select="key('letter',translate(concat($language,&lngseparator;,$indexLetter),&lowercase;,&uppercase;))"/>]</xsl:message>
		<xsl:choose>
			<xsl:when test="key('letter',translate(concat($language,&lngseparator;,$indexLetter),&lowercase;,&uppercase;))[count(.|key('primary',translate(concat($language,&lngseparator;,$indexLetter),&lowercase;,&uppercase;))[1])=1]">
				<!--xsl:when test="key('letter',translate(concat(ancestor-or-self::*/@xml:lang,&lngseparator;,$indexLetter),&lowercase;,&uppercase;))=1"-->
				
				<span class="indexNavigationItemAvailable"><a href="{concat('#_',$indexLetter)}" target="_self"><xsl:value-of select="$indexLetter"/></a></span>
			</xsl:when>
			<xsl:otherwise>
				<span class="indexNavigationItemNotAvailable"><xsl:value-of select="$indexLetter"/></span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!-- ============================================================== -->
	<xsl:template name="generateNavigationList">
	  <xsl:param name="language"/>	
		<xsl:param name="indexLetter" />
		<xsl:param name="indexList" />


<xsl:message>generateNavigationList - indexLetter [<xsl:value-of select="$indexLetter"/>]</xsl:message>
<xsl:message>generateNavigationList - indexList [<xsl:value-of select="$indexList"/>]</xsl:message>

			<xsl:call-template name="generateNavigationElement">
				<xsl:with-param name="language" select="$language"/>			
				<xsl:with-param name="indexLetter" select="$indexLetter" />
			</xsl:call-template>

			<xsl:choose>
				<xsl:when test="string-length($indexList) > 1">
					<xsl:message>alphabeticlist [<xsl:value-of select="$indexList"/>] found with (<xsl:value-of select="string-length($indexList)"/>) characters </xsl:message>
					<xsl:message>indexLetter set to [<xsl:value-of select="substring($indexList,1,1)"/>]</xsl:message>
					<xsl:message>indexList set to [<xsl:value-of select="substring($indexList,2,string-length($indexList)-1)" /> ]</xsl:message>				
					<xsl:call-template name="generateNavigationList">
						<xsl:with-param name="language" select="$language"/>
						<xsl:with-param name="indexLetter" select="substring($indexList,1,1)"/>
						<xsl:with-param name="indexList" select="substring($indexList,2,string-length($indexList)-1)" />
					</xsl:call-template>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="generateNavigationElement">
						<xsl:with-param name="language" select="$language"/>
						<xsl:with-param name="indexLetter" select="$indexList"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>		
		
	</xsl:template>	
<!-- ============================================================== -->
	<!-- Uncomment incase of starting only index generation on a file
	<xsl:template match="/">
		<xsl:call-template name="generate.index"/>
	</xsl:template>
	-->
  <!-- ============================================================== -->
</xsl:stylesheet>

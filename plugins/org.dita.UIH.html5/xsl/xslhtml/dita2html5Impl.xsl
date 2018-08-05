<?xml version="1.0" encoding="UTF-8"?>
<!-- This file is part of the DITA Open Toolkit project.
     See the accompanying license.txt file for applicable licenses. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
				xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
                version="2.0"
                exclude-result-prefixes="xs dita-ot"
				xmlns:exsl="http://exslt.org/common" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
				

	<xsl:import href="css-class.xsl"/>
	<xsl:import href="topic.xsl"/>
	<xsl:import href="task.xsl"/>
	<xsl:import href="reference.xsl"/>
	<xsl:import href="plugin:org.dita.xhtml:xsl/xslhtml/rel-links.xsl"/>
	
	<!-- Include error message template -->
    <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
    <xsl:import href="plugin:org.dita.base:xsl/common/dita-textonly.xsl"/>
	<xsl:import href="../../common/dita-utilities.xsl"/>
	
	<xsl:include href="rel-links.xsl"/>
	
	<xsl:param name="PATH2PROJ">
    <xsl:apply-templates select="/processing-instruction('path2project-uri')[1]" mode="get-path2project"/>
    </xsl:param>
	
	<xsl:param name="WORKDIR">
    <xsl:apply-templates select="/processing-instruction('workdir-uri')[1]" mode="get-work-dir"/>
  </xsl:param>
  
  <xsl:param name="UIH-dita-css" select="'UIHhtml5ltr.css'"/> <!-- left to right languages -->
  <xsl:param name="bidi-UIH-dita-css" select="'UIHhtml5rtl.css'"/> <!-- bidirectional languages -->
  
  <xsl:variable name="newline" select="()" as="xs:string?"/>
	<xsl:key name="enumerableByClass"
           match="*[contains(@class, ' topic/fig ')][*[contains(@class, ' topic/title ')]] |
                  *[contains(@class, ' topic/table ')][*[contains(@class, ' topic/title ')]] |
                  *[contains(@class,' topic/fn ') and empty(@callout)]"
            use="tokenize(@class, '\s+')"/>
			
	<xsl:template name="generateCharset">
		<meta charset="UTF-8"/>
	</xsl:template>  

	<xsl:template match="*[contains(@class,' topic/copyright ')]" mode="gen-metadata">
		<meta name="rights">
			<xsl:attribute name="content">
				<xsl:text>&#xA9; </xsl:text>
				<xsl:apply-templates select="*[contains(@class,' topic/copyryear ')][1]" mode="gen-metadata"/>
				<xsl:text> </xsl:text>
				<xsl:if test="*[contains(@class,' topic/copyrholder ')]">
					<xsl:value-of select="*[contains(@class,' topic/copyrholder ')]"/>
				</xsl:if>                
			</xsl:attribute>
		</meta>
	</xsl:template>
	<xsl:template match="*[contains(@class,' topic/copyryear ')]" mode="gen-metadata">
		<xsl:param name="previous" select="/.."/>
		<xsl:param name="open-sequence" select="false()"/>
		<xsl:variable name="next" select="following-sibling::*[contains(@class,' topic/copyryear ')][1]"/>
		<xsl:variable name="begin-sequence" select="@year + 1 = number($next/@year)"/>
		<xsl:choose>
			<xsl:when test="$begin-sequence">
				<xsl:if test="not($open-sequence)">
					<xsl:value-of select="@year"/>
					<xsl:text>&#x2013;</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$next">
				<xsl:value-of select="@year"/>
				<xsl:text>, </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@year"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="$next" mode="gen-metadata">
			<xsl:with-param name="previous" select="."/>
			<xsl:with-param name="open-sequence" select="$begin-sequence"/>
		</xsl:apply-templates>
	</xsl:template>


	<xsl:template match="*[contains(@class,' topic/title ')]" mode="gen-metadata"/>
	<xsl:template match="*[contains(@class,' topic/shortdesc ')]" mode="gen-metadata">
		<xsl:variable name="shortmeta">
			<xsl:apply-templates select="*|text()" mode="text-only"/>
		</xsl:variable>
		<meta name="description">
			<xsl:attribute name="content">
				<xsl:value-of select="normalize-space($shortmeta)"/>
			</xsl:attribute>
		</meta>
	</xsl:template>

	<!-- Notes -->

	<xsl:template match="*" mode="process.note.common-processing">
	
		<xsl:param name="type" select="@type"/>
		<xsl:param name="title">
			<xsl:call-template name="getUIHVariable">
				<xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
			</xsl:call-template>
		</xsl:param>
		<div>
			<!-- 转为表格 -->
			<xsl:call-template name="commonattributes">
				<xsl:with-param name="default-output-class" select="string-join(($type, concat('note_', $type)), ' ')"/>
			</xsl:call-template>
			<xsl:call-template name="setidaname"/>
			<!-- Normal flags go before the generated title; revision flags only go on the content. -->
			<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
			<table  style="border:1px solid black" cellpadding="2" cellspacing="0"  align="left" width="50%">
				<xsl:if test="$type = 'danger' ">
					<tr bgcolor="#e11a22">
						<td align="center" style="border:1px solid black;color:white;font-size:12pt;" height="40px">
						    <img src="{$PATH2PROJ}images/danger.png"/>
							<xsl:copy-of select="$title"/>
							</td>
					</tr>
					<tr>
						<td class="note_list">  
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
							<xsl:apply-templates/>
							<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="$type = 'other' ">
					<tr bgcolor="#B5C7CD" height="40px" style="border: 1px solid #B5C7CD;">
						<td align="center" style="border-right-color:B5C7CD;" width="20px;">
						<img src="{$PATH2PROJ}images/helpinfo.png"/>
						</td>
						<td class="note_list">  
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
							<xsl:apply-templates/>
							<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="$type = 'caution' " >
					<tr bgcolor="#ffe600"  height="40px">
						<td align="center" style="font-size:12pt;border:1px solid black;">
						 <img src="{$PATH2PROJ}images/caution.png"/>
						 <xsl:copy-of select="$title"/>
						</td>
					</tr>
					<tr>
						<td class="note_list">  
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
							<xsl:apply-templates/>
							<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="$type = 'warning' ">
					<tr bgcolor="#faa61a"  height="40px">
						<td align="center" style="font-size:12pt;border:1px solid black;">
						<img src="{$PATH2PROJ}images/warning.png"/>
							 <xsl:copy-of select="$title"/>
						</td>
					</tr>
					<tr>
						<td class="note_list">  
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
							<xsl:apply-templates/>
							<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="$type = 'note' ">
					<tr bgcolor="#436EEE" height="40px;">
						<td align="center" style="color:white;font-size:12pt;border:1px solid black;">
						<i><xsl:value-of select="$title"/></i>
						</td>
					</tr>
					<tr>
						<td class="note_list" style="font-size:10pt;">  
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
							<xsl:apply-templates/>
							<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
						</td>
					</tr>
				</xsl:if>
			</table>
		</div>
		<div style="clear:both;height:1px;width:100%; overflow:hidden; margin-top:-1px;"></div>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="*" mode="process.note.caution">
		<xsl:apply-templates select="." mode="process.note.common-processing"/>
	</xsl:template>

	<xsl:template match="*" mode="process.note.danger">
		<xsl:apply-templates select="." mode="process.note.common-processing"/>
	</xsl:template>

	<xsl:template match="*" mode="process.note.other">
       <xsl:apply-templates select="." mode="process.note.common-processing"/>
    </xsl:template>

	<!-- Figure -->

	<!-- Figure caption -->
	<xsl:template name="place-fig-lbl">
		<xsl:param name="stringName"/>
		<!-- Number of fig/title's including this one -->
		<xsl:variable name="fig-count-actual" select="count(preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')])+1"/>
		<xsl:variable name="ancestorlang">
			<xsl:call-template name="getLowerCaseLang"/>
		</xsl:variable>
		<xsl:choose>
			<!-- title -or- title & desc -->
			<xsl:when test="*[contains(@class, ' topic/title ')]">
				<figcaption>
					<span class="fig--title-label">
						<xsl:choose>
							<!-- Hungarian: "1. Figure " -->
							<xsl:when test="$ancestorlang = ('hu', 'hu-hu')">
								<xsl:value-of select="$fig-count-actual"/>
								<xsl:text>. </xsl:text>
								<xsl:call-template name="getVariable">
									<xsl:with-param name="id" select="'Figure'"/>
								</xsl:call-template>
								<xsl:text> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="getVariable">
									<xsl:with-param name="id" select="'Figure'"/>
								</xsl:call-template>
								<xsl:text> </xsl:text>
								<xsl:value-of select="$fig-count-actual"/>
								<xsl:text>. </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="figtitle"/>
					<xsl:if test="*[contains(@class, ' topic/desc ')]">
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:for-each select="*[contains(@class, ' topic/desc ')]">
						<span class="figdesc">
							<xsl:call-template name="commonattributes"/>
							<xsl:apply-templates select="." mode="figdesc"/>
						</span>
					</xsl:for-each>
				</figcaption>
			</xsl:when>
			<!-- desc -->
			<xsl:when test="*[contains(@class, ' topic/desc ')]">
				<xsl:for-each select="*[contains(@class, ' topic/desc ')]">
					<figcaption>
						<xsl:call-template name="commonattributes"/>
						<xsl:apply-templates select="." mode="figdesc"/>
					</figcaption>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="generate-table-header" priority="10"
    match="*[contains(@class, ' topic/simpletable ')]">
		<xsl:variable name="gen" as="element(gen)">
			<!--
      Generated header needs to be wrapped in gen element to allow correct
      language detection.
      -->
			<gen>
				<xsl:copy-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
				<xsl:next-match/>
			</gen>
		</xsl:variable>

		<xsl:apply-templates select="$gen/*"/>
	</xsl:template>

	<xsl:template match="*" mode="css-class" priority="100">
		<xsl:param name="default-output-class"/>

		<xsl:variable name="outputclass" as="attribute(class)">
			<xsl:apply-templates select="." mode="set-output-class">
				<xsl:with-param name="default" select="$default-output-class"/>
			</xsl:apply-templates>
		</xsl:variable>

		<xsl:variable name="class">
			<xsl:sequence select="data($outputclass)"/>
			<xsl:next-match/>
		</xsl:variable>

		<xsl:attribute name="class" select="string-join($class, ' ')"/>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/ul ')]" name="topic.ul">
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
		<xsl:call-template name="setaname"/>
		<ul  style="list-style-type:square;">
			<xsl:call-template name="commonattributes"/>
			<xsl:apply-templates select="@compact"/>
			<xsl:call-template name="setid"/>
			<xsl:apply-templates/>
		</ul>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]">
		<xsl:param name="headinglevel" as="xs:integer">
			<xsl:choose>
				<xsl:when test="count(ancestor::*[contains(@class, ' topic/topic ')]) > 6">6</xsl:when>
				<xsl:otherwise>
					<xsl:sequence select="count(ancestor::*[contains(@class, ' topic/topic ')])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<div  style="display:inline;"> 
		<img src="{$PATH2PROJ}images/logo.svg" />
		</div>
		<div  class="headertitle">
		<xsl:apply-templates/>
		</div> 
		<hr  align="left"/>
		<xsl:element name="h{$headinglevel}">
			<xsl:attribute name="class">topictitle<xsl:value-of select="$headinglevel"/>
			</xsl:attribute>
			<xsl:call-template name="commonattributes">
				<xsl:with-param name="default-output-class">topictitle<xsl:value-of select="$headinglevel"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:attribute name="id">
				<xsl:apply-templates select="." mode="return-aria-label-id"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	 
	<xsl:template match="*" mode="addContentToHtmlBodyElement">
    <main role="main">
      <article role="article">
        <xsl:attribute name="aria-labelledby">
          <xsl:apply-templates select="*[contains(@class,' topic/title ')] |
                                       self::dita/*[1]/*[contains(@class,' topic/title ')]" mode="return-aria-label-id"/>
        </xsl:attribute>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/> 
		<div class="headerdiv">
		<table>
		<tr>
		<td>
		 <a href="{$PATH2PROJ}index.html">
		  <img src="{$PATH2PROJ}images/toc.gif"/>
	     </a>
		 </td>
		 <td>
		 <xsl:apply-templates select="*[contains(@class, ' topic/related-links ')]" mode="header-next"/>
		 </td>
		 <td>
		 <!-- <a href="{$PATH2PROJ}index.html">
		  <img src="{$PATH2PROJ}images/index.gif"/>
	     </a> -->
		 </td>
		</tr>
		</table>  
		</div>
		<div></div>
        <xsl:apply-templates/> <!-- this will include all things within topic; therefore, -->
                               <!-- title content will appear here by fall-through -->
                               <!-- followed by prolog (but no fall-through is permitted for it) -->
                               <!-- followed by body content, again by fall-through in document order -->
                               <!-- followed by related links -->
                               <!-- followed by child topics by fall-through -->
		<xsl:call-template name="gen-endnotes"/>    <!-- include footnote-endnotes -->
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
      </article>
    </main>
  </xsl:template>
  
   <xsl:template name="generateCssLinks">
    <xsl:variable name="childlang">
      <xsl:choose>
        <!-- Update with DITA 1.2: /dita can have xml:lang -->
        <xsl:when test="self::dita[not(@xml:lang)]">
          <xsl:for-each select="*[1]"><xsl:call-template name="getLowerCaseLang"/></xsl:for-each>
        </xsl:when>
        <xsl:otherwise><xsl:call-template name="getLowerCaseLang"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="direction">
      <xsl:apply-templates select="." mode="get-render-direction">
        <xsl:with-param name="lang" select="$childlang"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="urltest" as="xs:boolean"> <!-- test for URL -->
      <xsl:call-template name="url-string">
        <xsl:with-param name="urltext" select="concat($CSSPATH, $CSS)"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$direction = 'rtl' and $urltest ">
        <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$bidi-UIH-dita-css}" />
      </xsl:when>
      <xsl:when test="$direction = 'rtl' and not($urltest)">
        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$bidi-UIH-dita-css}" />
      </xsl:when>
      <xsl:when test="$urltest">
        <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$UIH-dita-css}" />
      </xsl:when>
      <xsl:otherwise>
        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$UIH-dita-css}" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$newline"/>
    <!-- Add user's style sheet if requested to -->
    <xsl:if test="string-length($CSS) > 0">
      <xsl:choose>
        <xsl:when test="$urltest">
          <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$CSS}" />
        </xsl:when>
        <xsl:otherwise>
          <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$CSS}" />
        </xsl:otherwise>
      </xsl:choose><xsl:value-of select="$newline"/>
    </xsl:if>
    
  </xsl:template>
  
   <xsl:template match="backmatter">
       <xsl:apply-templates/>
   </xsl:template>
   
    <xsl:template match="indexlist">
       	<xsl:variable name="v_sorted_index_data">
			<xsl:apply-templates select="//indexterm" mode="gen_index">
				<xsl:sort select="index-sort-as"/>
			</xsl:apply-templates>
		</xsl:variable>
			
	<xsl:variable name="v_letters">
		<xsl:call-template name="f-get-letters">
			<xsl:with-param name="p_content" select="exsl:node-set($v_sorted_index_data)/indexterm"/>    
		</xsl:call-template>
	</xsl:variable>
	 
     <div>	 
		<xsl:for-each select="exsl:node-set($v_letters)/index_letter">
			<xsl:variable name="v_letter" select="."/>
			
			<div>
				<xsl:value-of select="$v_letter"/>
			</div>		
		</xsl:for-each>
	 </div>
	 
   </xsl:template>
   
   <xsl:template name="f-to-uppercase">
		<xsl:param name="p_string"/>
		<xsl:value-of select="translate($p_string,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
	</xsl:template>

   
   <xsl:template name="f-get-letters">
	<xsl:param name="p_content"/>
	<xsl:param name="p_letter" select="' '"/>
    
    <xsl:if test="count(exsl:node-set($p_content)) &gt; 0">
    	 <xsl:variable name="v_temp">
               <xsl:call-template name="f-to-uppercase">
                     <xsl:with-param name="p_string" select="substring(exsl:node-set($p_content)[1]/index-sort-as,1,1)"/>
            </xsl:call-template>
        </xsl:variable>
		
    	<xsl:if test="$v_temp != $p_letter">
        	<index_letter><xsl:value-of select="$v_temp"/></index_letter>
        </xsl:if>
		
        <xsl:call-template name="f-get-letters">
        	<xsl:with-param name="p_content" select="exsl:node-set($p_content)[position() != 1]"/>
            <xsl:with-param name="p_letter" select="$v_temp"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>
   
   <xsl:template match="*" mode="gen_index">
		  <xsl:apply-templates mode="gen_index"/>
	</xsl:template>
   
<xsl:template match="indexterm|index-sort-as" mode="gen_index">
	<xsl:element name="{name()}">
    	<xsl:apply-templates mode="gen_index"/>
    </xsl:element>
</xsl:template>	


<xsl:template match="/|node()|@*" mode="gen-user-scripts">
  <!-- to customize: copy this to your override transform, add the content you want. -->
  <!-- It will be placed before the ending HEAD tag -->
  <!-- see (or enable) the named template "script-sample" for an example -->
  <script language="javascript" type="text/javascript" src="{$PATH2PROJ}js/toc.js"></script>
</xsl:template>

	<xsl:include href="functions.xsl"/>
	<xsl:include href="nav.xsl"/>

</xsl:stylesheet>

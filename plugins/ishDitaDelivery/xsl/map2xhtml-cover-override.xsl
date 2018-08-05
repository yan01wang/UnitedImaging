<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
	xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
	exclude-result-prefixes="xs ditamsg dita-ot"
    version="2.0">

	<xsl:import href="plugin:trisoft.dita.delivery:xsl/map2xhtml-cover.xsl"/>
	
	<xsl:variable name="root" select="/" as="document-node()"/>

	<!-- Override of the replace-extension method to keep an href="GUID-X". Otherwise an href without an extension produces an empty href -->
	<xsl:template name="replace-extension" as="xs:string">
		<xsl:param name="filename" as="xs:string"/>
		<xsl:param name="extension" as="xs:string"/>
		<xsl:param name="ignore-fragment" select="false()"/>
		<xsl:variable name="f" as="xs:string">
			<xsl:value-of>
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="text">
						<xsl:choose>
							<xsl:when test="contains($filename, '#')">
								<xsl:value-of select="substring-before($filename, '#')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$filename"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="delim" select="'.'"/>
				</xsl:call-template>
			</xsl:value-of>
		</xsl:variable>
		<xsl:value-of>
			<xsl:choose>
				<xsl:when test="string($f)">
					<!-- filename is of the form "bc.xml#ID" or "bc.xml" -->
					<!-- so change it in next line to "bc.extension", e.g. "bc.html" -->
					<xsl:value-of select="concat($f, $extension)"/>  
					<!-- if has #, add # and part after it again -->
					<xsl:if test="not($ignore-fragment) and contains($filename, '#')">
						<xsl:value-of select="concat('#', substring-after($filename, '#'))"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<!-- filename is of the form "bc#ID" or "bc" -->
						<xsl:when test="contains($filename, '#')">
							<xsl:value-of select="concat(substring-before($filename, '#'), $extension)"/>
							<xsl:if test="not($ignore-fragment)">
								<xsl:value-of select="substring-after($filename, '#')"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($filename, $extension)"/>  
						</xsl:otherwise>			
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:value-of>
	</xsl:template>


  <!-- This template override the standard template defined in map2xhtml-cover.xsl, to keep the <tcdl:if> tags inside the titles -->
  <!-- The only difference with the standard template is that we replaced <xsl:value-of select="$title"/> with <xsl:copy-of select="$title"/> -->
  <xsl:template match="*[contains(@class, ' map/topicref ')]
							[not(@toc = 'no')]
							[not(@processing-role = 'resource-only')]"
					mode="toc">
		<xsl:param name="pathFromMaplist"/>
		<xsl:variable name="title">
			<xsl:apply-templates select="." mode="get-navtitle"/>
		</xsl:variable>		
		<xsl:choose>
			<xsl:when test="normalize-space($title)">
				<naventry>					
					<xsl:call-template name="commonattributes"/>
					<xsl:choose>
						<!-- If there is a reference to a DITA or HTML file, and it is not external: -->
						<xsl:when test="normalize-space(@href)">						
							<xsl:attribute name="ref">
								<xsl:choose>
									<xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and 
										(not(@format) or @format = 'dita' or @format = 'ditamap') ">
										<xsl:if test="not(@scope = 'external')">
											<xsl:value-of select="$pathFromMaplist"/>
										</xsl:if>
										<xsl:call-template name="replace-extension">
											<xsl:with-param name="filename" select="@copy-to"/>
											<xsl:with-param name="extension" select="$OUTEXT"/>
										</xsl:call-template>
										<xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
											<xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
										</xsl:if>
									</xsl:when>
									<xsl:when test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
										<xsl:if test="not(@scope = 'external')">
											<xsl:value-of select="$pathFromMaplist"/>
										</xsl:if>
										<xsl:call-template name="replace-extension">
											<xsl:with-param name="filename" select="@href"/>
											<xsl:with-param name="extension" select="$OUTEXT"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<!-- If non-DITA, keep the href as-is -->
										<xsl:if test="not(@scope = 'external')">
											<xsl:value-of select="$pathFromMaplist"/>
										</xsl:if>
										<xsl:value-of select="@href"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:if test="@scope = 'external' or not(not(@format) or @format = 'dita' or @format = 'ditamap')">
								<xsl:attribute name="target">_blank</xsl:attribute>
							</xsl:if>								
						</xsl:when>						
					</xsl:choose>
					<title>
						<xsl:copy-of select="$title"/>
					</title>
					<!-- If there are any children that should be in the TOC, process them -->
					<xsl:if test="descendant::*[contains(@class, ' map/topicref ')]
										 [not(@toc = 'no')]
										 [not(@processing-role = 'resource-only')]">
						<xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
							<xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
						</xsl:apply-templates>
					</xsl:if>
				</naventry>
			</xsl:when>
			<xsl:otherwise>
				<!-- if it is an empty topicref -->
				<xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
					<xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Make sure topicgroup elements end up in the normalized map nodes, so if they are conditional they can get processed by the conditional templates and get a tcdl:if later -->
	<xsl:template match="*[contains(@class, ' mapgroup-d/topicgroup ')]" mode="normalize-map" priority="9">	
		<xsl:copy>
			<xsl:apply-templates select="@* | node() except *[contains(@class, ' map/topicmeta ')]" mode="normalize-map"/>
		</xsl:copy>
	</xsl:template>

	<!-- Make sure topicgroup elements don't produce any output in the toc (except when conditional, then conditional overwrite rule handles this first) -->
	<xsl:template match="*[contains(@class, ' mapgroup-d/topicgroup ')]" mode="toc" priority="9">
		<xsl:apply-templates mode="toc"/>
	</xsl:template>

  <!-- Get the navtitle, but not only the textual representation, we want to keep all sub elements and attributes in it as well -->
	<xsl:template match="*" mode="get-navtitle">
    <xsl:choose>
      <!-- If navtitle is specified -->
      <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]">
        <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]"
                             mode="text-only-with-conditional-elements"/>
      </xsl:when>
      <xsl:when test="@navtitle">
        <xsl:value-of select="@navtitle"/>
      </xsl:when>
      <!-- If there is no title and none can be retrieved, check for <linktext> -->
      <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]">
        <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]"
                             mode="text-only-with-conditional-elements"/>
      </xsl:when>
      <!-- No local title, and not targeting a DITA file. Could be just a container setting
           metadata, or a file reference with no title. Issue message for the second case. -->
      <xsl:otherwise>
        <xsl:if test="normalize-space(@href)">
          <xsl:apply-templates select="." mode="ditamsg:could-not-retrieve-navtitle-using-fallback">
            <xsl:with-param name="target" select="@href"/>
            <xsl:with-param name="fallback" select="@href"/>
          </xsl:apply-templates>
          <xsl:value-of select="@href"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Get the element content, not only the textual representation, we want to keep all sub elements and attributes in it as well -->
  <xsl:template match="*" mode="text-only-with-conditional-elements">
	  <!-- Keep text only: <xsl:apply-templates select="." mode="dita-ot:text-only"/> -->
	  <xsl:apply-templates/>
  </xsl:template>    

  <!-- Overwrite for the standard rule match="*[contains(@class, ' topic/tm ')]" to always get a trademark symbol in the toc title -->
  <xsl:template match="*[contains(@class, ' topic/tm ')][ancestor::*[contains(@class, ' map/map ')]]">
    <xsl:apply-templates/> <!-- output the TM content -->
	  <!-- Test for TM area's language -->
	  <xsl:variable name="tmtest">
	    <xsl:call-template name="tm-area"/>
	  </xsl:variable>
	  <!-- If this language should get trademark markers, continue... -->
	  <xsl:if test="$tmtest = 'tm'">
	    <!--  output your favorite TM marker based on the attributes -->
		  <xsl:choose>  <!-- ignore @tmtype=service or anything else -->
		    <xsl:when test="@tmtype = 'tm'">&#x2122;</xsl:when>
		    <xsl:when test="@tmtype = 'reg'">&#174;</xsl:when>
		    <xsl:when test="@tmtype = 'service'">&#8480;</xsl:when>
		    <xsl:otherwise/>
		  </xsl:choose>
	  </xsl:if>
  </xsl:template>

</xsl:stylesheet>

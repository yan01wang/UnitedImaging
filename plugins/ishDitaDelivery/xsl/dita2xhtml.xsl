<?xml version="1.0" encoding="utf-8"?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2011 All Rights Reserved. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0">
					
	<xsl:import href="plugin:org.dita.xhtml:xsl/dita2html-base.xsl"/>

	<xsl:output method="xhtml"
              encoding="UTF-8"
              indent="yes"/>

	<xsl:include href="plugin:org.dita.xhtml:xsl/dita2xhtml-util.xsl"/>
  
	<!-- Add both lang and xml:lang attributes -->
	<xsl:template match="@xml:lang" name="generate-lang">
		<xsl:param name="lang" select="."/>
		<xsl:attribute name="xml:lang">
			<xsl:value-of select="$lang"/>
		</xsl:attribute>
		<xsl:attribute name="lang">
			<xsl:value-of select="$lang"/>
		</xsl:attribute>
	</xsl:template>
	
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


</xsl:stylesheet>

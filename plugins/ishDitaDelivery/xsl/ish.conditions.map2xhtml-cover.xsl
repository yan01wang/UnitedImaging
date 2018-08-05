<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
	xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
	xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
	xmlns:tcdl="http://www.sdl.com/web/DXA/Format" 
	exclude-result-prefixes="xs dita-ot dita2html ditamsg">

  <xsl:import href="plugin:trisoft.dita.delivery:xsl/map2xhtml-cover-override.xsl"/>
  
	<xsl:template name="tcdlifconditionattributes">
		<xsl:variable name="condition">
			<xsl:value-of select="@ishcondition"/>
		</xsl:variable>
		<xsl:if test="string-length(normalize-space($condition)) &gt; 0">
			<xsl:attribute name="condition">
				<xsl:value-of select="normalize-space($condition)"/>
			</xsl:attribute>
			<xsl:attribute name="type">ish:Condition</xsl:attribute>
		</xsl:if>
	</xsl:template>
		
	<xsl:template name="commonattributes">
		<xsl:param name="default-output-class"/>
		<xsl:apply-templates select="@xml:lang"/>
		<xsl:apply-templates select="@dir"/>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass" mode="add-ditaval-style"/>
		<xsl:apply-templates select="." mode="set-output-class">
		  <xsl:with-param name="default" select="$default-output-class"/>
		</xsl:apply-templates>
		<xsl:if test="exists($passthrough-attrs)">
		  <xsl:for-each select="@*">
			<xsl:if test="$passthrough-attrs[@att = name(current()) and (empty(@val) or (some $v in tokenize(current(), '\s+') satisfies $v = @val))]">
			  <xsl:attribute name="data-{name()}" select="."/>
			</xsl:if>
		  </xsl:for-each>
		</xsl:if>
		<!-- As topicgroups are not rendered, persist any condition on the topicgroup to it's child topicrefs -->
		<!-- As topicref (or one of it's specialisations) elements that do not have an href and have no title are not rendered, persist any condition on the topicref to it's child topicrefs -->
		<xsl:variable name="condition">
		  <xsl:for-each select=".[@ishcondition and @ishcondition!=''] | .[contains(@class, ' map/topicref ')]/ancestor::*[@ishcondition and @ishcondition!='' and (contains(@class, ' mapgroup-d/topicgroup ') or (contains(@class, ' map/topicref ') and not(@href) and not(*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ') or contains(@class, ' map/linktext ')]) and not(@navtitle)))]">
			(<xsl:value-of select="@ishcondition"/>)
			<xsl:if test="position() &lt; last()"> AND </xsl:if>
		  </xsl:for-each>
		</xsl:variable>
		<xsl:if test="string-length(normalize-space($condition)) &gt; 0">
		  <xsl:choose>
			  <!-- Put the condition in the condition attribute for naventry elements generated for map/topicrefs. So there is no need to convert them later -->
			  <xsl:when test=".[contains(@class, ' map/topicref ')]">
				  <xsl:attribute name="condition">
					<xsl:value-of select="normalize-space($condition)"/>
				  </xsl:attribute>		  
			  </xsl:when>
			  <!-- Put the condition in the ishcondition attribute for other elements, so they can later be converted to tcdl:If by a PublishPostProcess plugin -->
			  <xsl:otherwise>
				  <xsl:attribute name="ishcondition">
					<xsl:value-of select="normalize-space($condition)"/>
				  </xsl:attribute>
			  </xsl:otherwise>
		  </xsl:choose>
		</xsl:if>
	  </xsl:template>


	<xsl:template match="*[@ishcondition][ancestor::navtitle]" priority="1000" mode="dita-ot:text-only">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>
	
	<xsl:template match="*[@ishcondition][ancestor::navtitle][contains(@class, ' topic/data ')] | *[@ishcondition][ancestor::navtitle][contains(@class, ' topic/data-about ')][@ishcondition]">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template> 
		
	<xsl:template match="*[@ishcondition][ancestor::navtitle][contains(@class, ' topic/foreign ') or contains(@class, ' topic/unknown ')]">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template> 
	
	<xsl:template match="*[@ishcondition][ancestor::navtitle][contains(@class, ' topic/index-base ')]">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>
	
	<xsl:template match="*[@ishcondition][ancestor::navtitle][contains(@class, ' topic/text ')]">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/linktext ')][ancestor::navtitle]">
		<xsl:choose>
			<xsl:when test="@ishcondition">
				<tcdl:If>
					<xsl:call-template name="tcdlifconditionattributes"/>
					<xsl:apply-templates select="* | text()"/>
				</tcdl:If>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="* | text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  
	<xsl:template match="*[contains(@class, ' topic/link ')][ancestor::navtitle]/*[contains(@class, ' topic/desc ')]">
		<xsl:choose>
			<xsl:when test="@ishcondition">
				<tcdl:If>
					<xsl:call-template name="tcdlifconditionattributes"/>
					<xsl:apply-templates select="* | text()"/>
				</tcdl:If>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="* | text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<xsl:template match="*[contains(@class, ' topic/tm ')][@ishcondition][ancestor::navtitle]">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/dlentry ')][@ishcondition][ancestor::navtitle]">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/dlhead ')][@ishcondition][ancestor::navtitle]">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>			
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>

	
	<xsl:template match="*[contains(@class, ' topic/linkinfo ')][@ishcondition][ancestor::navtitle]">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/itemgroup ')][@ishcondition][ancestor::navtitle]">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>
		
	<xsl:template match="*[contains(@class, ' topic/colspec ')][@ishcondition][ancestor::navtitle]">
		<xsl:param name="totalwidth" as="xs:double"/>
		<xsl:variable name="width" as="xs:string?">
			<xsl:choose>
			  <xsl:when test="empty(@colwidth)"/>
			  <xsl:when test="contains(@colwidth, '*')">
				<xsl:value-of select="concat((xs:double(translate(@colwidth, '*', '')) div $totalwidth) * 100, '%')"/>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="@colwidth"/>
			  </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>	
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<col>
			<xsl:if test="exists($width)">
			  <xsl:attribute name="style" select="concat('width:', $width)"/>
			</xsl:if>
			</col>
		</tcdl:If>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/tgroup ')][@ishcondition][ancestor::navtitle]">	
		<tcdl:If>            
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>	
	
	
	
	
	<xsl:template match="*[contains(@class, ' topic/object ')]/*[contains(@class, ' topic/desc ')][@ishcondition][ancestor::navtitle]">
	 <span>
	  <xsl:copy-of select="@name | @id | @ishcondition | value"/>
	  <xsl:apply-templates/>
	 </span>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')][@ishcondition][ancestor::navtitle]">
	  <span><xsl:copy-of select="@ishcondition"/><xsl:apply-templates/></span>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/desc ')][@ishcondition][ancestor::navtitle]">
	  <span><xsl:copy-of select="@ishcondition"/><xsl:apply-templates/></span>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/desc ')][@ishcondition][ancestor::navtitle]" priority="-10">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-templates/>
		</tcdl:If>
	</xsl:template>

	
	<xsl:template match="*[contains(@class,' pr-d/syntaxdiagram ')][@ishcondition][ancestor::navtitle]">
		<tcdl:If>		
			<xsl:call-template name="tcdlifconditionattributes"/>			
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>

</xsl:stylesheet>
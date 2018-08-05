<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 		
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
	xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
	xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
	xmlns:tcdl="http://www.sdl.com/web/DXA/Format" 
	exclude-result-prefixes="xs dita-ot dita2html ditamsg">

	<xsl:import href="plugin:trisoft.dita.delivery:xsl/dita2xhtml.xsl"/>

	<xsl:template name="tcdlifconditionattributes">
		<xsl:variable name="condition">
			<xsl:for-each select=".[@ishcondition and @ishcondition!=''] | ancestor::*[@ishcondition and @ishcondition!='' and (contains(@class, ' mapgroup-d/topicgroup ') or contains(@class, ' topic/linkpool '))]">
				(<xsl:value-of select="@ishcondition"/>)
				<xsl:if test="position() &lt; last()"> AND </xsl:if>
			</xsl:for-each>
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
    <xsl:variable name="condition">
      <xsl:for-each select=".[@ishcondition and @ishcondition!=''] | ancestor::*[@ishcondition and @ishcondition!='' and (contains(@class, ' mapgroup-d/topicgroup ') or contains(@class, ' topic/linkpool '))]">
        (<xsl:value-of select="@ishcondition"/>)
        <xsl:if test="position() &lt; last()"> AND </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="string-length(normalize-space($condition)) &gt; 0">
      <xsl:attribute name="ishcondition">
        <xsl:value-of select="normalize-space($condition)"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <xsl:template match="@ishcondition" priority="1000" mode="#all">
		<xsl:attribute name="ishcondition">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="*[@ishcondition]" priority="1000" mode="dita-ot:text-only">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>
	
	<xsl:template match="*[@ishcondition][contains(@class,' task/steps ') or contains(@class,' task/steps-unordered ')]"
              mode="common-processing-within-steps">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template> 

	<xsl:template match="*[@ishcondition][contains(@class, ' topic/data ')] | *[@ishcondition][contains(@class, ' topic/data-about ')][@ishcondition]">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template> 
		
	<xsl:template match="*[@ishcondition][contains(@class, ' topic/foreign ') or contains(@class, ' topic/unknown ')]">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template> 
	
	<xsl:template match="*[@ishcondition][contains(@class, ' topic/index-base ')]">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>
	
	<xsl:template match="*[@ishcondition][contains(@class, ' topic/text ')]">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/linktext ')]" name="topic.linktext">
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
  
	<xsl:template match="*[contains(@class, ' topic/link ')]/*[contains(@class, ' topic/desc ')]" name="topic.link_desc">
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

	<!-- Special case: Move condition on root topic element inside the body element -->
	<xsl:template match="*[@ishcondition]" mode="chapterBody">  
		<body>
		  <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
		  <xsl:call-template name="setaname"/>  <!-- For HTML4 compatibility, if needed -->
		  <xsl:value-of select="$newline"/>		  
		  <tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>	
			<xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>
			<!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
			<xsl:call-template name="gen-user-sidetoc"/>
			<xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
			<xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
		  </tcdl:If>
		</body>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/tm ')][@ishcondition]">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/dlentry ')][@ishcondition]">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/dlhead ')][@ishcondition]">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>			
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>

	
	<xsl:template match="*[contains(@class, ' topic/linkinfo ')][@ishcondition]" name="topic.linkinfo">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/itemgroup ')][@ishcondition][not(contains(@class,' task/stepxmp '))][not(contains(@class,' task/stepresult '))][not(contains(@class,' task/info '))][not(contains(@class,' task/tutorialinfo '))]" name="topic.itemgroup">
		<tcdl:If>               
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>
		
	<xsl:template match="*[contains(@class, ' topic/colspec ')][@ishcondition]">
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

	<xsl:template match="*[contains(@class, ' topic/tgroup ')][@ishcondition]" name="topic.tgroup">	
		<tcdl:If>            
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>	
	
	
	<xsl:template match="*[contains(@class,' ut-d/imagemap ')]" name="topic.ut-d.imagemap">
	  <div>
		<xsl:call-template name="commonattributes"/>
		<xsl:call-template name="setidaname"/>
		<xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>

		<!-- the image -->
		<img usemap="#{generate-id()}">
		  <!-- Border attribute defaults to 0 -->
		  <xsl:apply-templates select="." mode="imagemap-border-attribute"/>
		  <!-- Process the 'normal' image attributes, using this special mode -->
		  <xsl:apply-templates select="*[contains(@class,' topic/image ')]" mode="imagemap-image"/>
		</img>
		<xsl:value-of select="$newline"/>

		<map name="{generate-id(.)}" id="{generate-id(.)}">

		  <xsl:for-each select="*[contains(@class,' ut-d/area ')]">
			<xsl:value-of select="$newline"/>
			<area>
				<!-- combine the condition on the ut-d/area with the one on the child topic/xref (if they have conditions) -->
				<xsl:variable name="condition">
					<xsl:for-each select=".[@ishcondition and @ishcondition!=''] | *[contains(@class, ' topic/xref ')][@ishcondition and @ishcondition!='']">
						(<xsl:value-of select="@ishcondition"/>)
						<xsl:if test="position() &lt; last()"> AND </xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:if test="string-length(normalize-space($condition)) &gt; 0">
					<xsl:attribute name="ishcondition">
						<xsl:value-of select="normalize-space($condition)"/>
					</xsl:attribute>
				</xsl:if>

			  <!-- if no xref/@href - error -->
			  <xsl:choose>
				<xsl:when test="*[contains(@class,' topic/xref ')]/@href">
				  <!-- special call to have the XREF/@HREF processor do the work -->
				  <xsl:apply-templates select="*[contains(@class, ' topic/xref ')]" mode="imagemap-xref"/>
				</xsl:when>
				<xsl:otherwise>
				  <xsl:apply-templates select="." mode="ditamsg:area-element-without-href-target"/>
				</xsl:otherwise>
			  </xsl:choose>

			  <!-- create ALT text from XREF content-->
			  <!-- if no XREF content, use @HREF, & put out a warning -->
			  <xsl:choose>
				<xsl:when test="*[contains(@class, ' topic/xref ')]">
				  <xsl:variable name="alttext"><xsl:apply-templates select="*[contains(@class, ' topic/xref ')]/node()[not(contains(@class, ' topic/desc '))]" mode="text-only"/></xsl:variable>
				  <xsl:attribute name="alt"><xsl:value-of select="normalize-space($alttext)"/></xsl:attribute>
				  <xsl:attribute name="title"><xsl:value-of select="normalize-space($alttext)"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
				  <xsl:apply-templates select="." mode="ditamsg:area-element-without-linktext"/>
				</xsl:otherwise>
			  </xsl:choose>

			  <!-- if not valid shape (blank, rect, circle, poly); Warning, pass thru the value -->
			  <xsl:variable name="shapeval"><xsl:value-of select="*[contains(@class,' ut-d/shape ')]"/></xsl:variable>
			  <xsl:attribute name="shape">
				<xsl:value-of select="$shapeval"/>
			  </xsl:attribute>
			  <xsl:variable name="shapetest"><xsl:value-of select="concat('-',$shapeval,'-')"/></xsl:variable>
			  <xsl:choose>
				<xsl:when test="contains('--rect-circle-poly-default-',$shapetest)"/>
				<xsl:otherwise>
				  <xsl:apply-templates select="." mode="ditamsg:area-element-unknown-shape">
					<xsl:with-param name="shapeval" select="$shapeval"/>
				  </xsl:apply-templates>
				</xsl:otherwise>
			  </xsl:choose>

			  <!-- if no coords & shape<>'default'; Warning, pass thru the value -->
			  <xsl:variable name="coordval"><xsl:value-of select="*[contains(@class,' ut-d/coords ')]"/></xsl:variable>
			  <xsl:choose>
				<xsl:when test="string-length($coordval)>0 and not($shapeval='default')">
				  <xsl:attribute name="coords">
					<xsl:value-of select="$coordval"/>
				  </xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
				  <xsl:apply-templates select="." mode="ditamsg:area-element-missing-coords"/>
				</xsl:otherwise>
			  </xsl:choose>

			</area>
		  </xsl:for-each>

		  <xsl:value-of select="$newline"/>
		</map>
		<xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
	  </div>
	</xsl:template>
	
	
	<xsl:template match="*[contains(@class, ' topic/object ')]/*[contains(@class, ' topic/desc ')][@ishcondition]" name="topic.object_desc">
	 <span>
	  <xsl:copy-of select="@name | @id | @ishcondition | value"/>
	  <xsl:apply-templates/>
	 </span>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')][@ishcondition]" name="topic.fig_title">
	  <span><xsl:copy-of select="@ishcondition"/><xsl:apply-templates/></span>
	</xsl:template>

	<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/desc ')][@ishcondition]" name="topic.fig_desc">
	  <span><xsl:copy-of select="@ishcondition"/><xsl:apply-templates/></span>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/desc ')][@ishcondition]" name="topic.desc" priority="-10">
		<tcdl:If>
			<xsl:call-template name="tcdlifconditionattributes"/>
			<xsl:apply-templates/>
		</tcdl:If>
	</xsl:template>

	
	<xsl:template match="*[contains(@class,' pr-d/syntaxdiagram ')][@ishcondition]">
		<tcdl:If>		
			<xsl:call-template name="tcdlifconditionattributes"/>			
			<xsl:apply-imports/>
		</tcdl:If>
	</xsl:template>
	
</xsl:stylesheet>
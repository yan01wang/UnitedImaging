<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.1" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- ============================================================== -->
	<!-- Revision History -->
	<!-- ============================================================== -->
	<!--
       1/ 20110705: Added null pointer templates to skip area elements 
                    of imagemaps area element.
  -->
  <!-- ============================================================== -->
  <!-- Start of UT domain -->
  <xsl:template match="*[contains(@class,' ut-d/area ')]" priority="99"/> <!-- null pointer to skip the area's for PDF -->
  <!-- End of UT domain -->
  <!-- Start of UI domain -->
  <xsl:template match="*[contains(@class,' ui-d/uicontrol ')]" priority="99">
    <!-- insert an arrow before all but the first uicontrol in a menucascade -->
    <xsl:if test="ancestor::*[contains(@class,' ui-d/menucascade ')]">
      <xsl:variable name="uicontrolcount"><xsl:number count="*[contains(@class,' ui-d/uicontrol ')]"/></xsl:variable>
      <xsl:if test="$uicontrolcount&gt;'1'">
        <xsl:text> --> </xsl:text>
      </xsl:if>
    </xsl:if>
    <fo:inline font-weight="bold">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->   
  <xsl:template match="*[contains(@class,' ui-d/wintitle ')]" priority="99">
    <fo:inline>
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' ui-d/menucascade ')]" priority="99">
    <fo:inline>
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->  
  <xsl:template match="*[contains(@class,' ui-d/shortcut ')]" priority="99">
    <fo:inline  text-decoration="underline">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' ui-d/screen ')]" priority="99">
    <xsl:call-template name="generate.label"/>
    <fo:block>
	  <xsl:call-template name="setscale"/>
      
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'pre'"/>
				<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates select="@id"/>      
  <!-- rules have to be applied within the scope of the PRE box; else they start from page margin! -->
      <xsl:if test="contains(@frame,'top')"><fo:block><fo:leader leader-pattern="rule" leader-length="5.65in" /></fo:block></xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="contains(@frame,'bot')"><fo:block><fo:leader leader-pattern="rule" leader-length="5.65in" /></fo:block></xsl:if>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- start of highlighting domain -->
  <xsl:template match="*[contains(@class,' hi-d/b ')]" priority="99">
    <fo:inline font-weight="bold">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' hi-d/i ')]" priority="99">
    <fo:inline font-style="italic">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' hi-d/u ')]" priority="99">
    <fo:inline text-decoration="underline">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' hi-d/tt ')]" priority="99">
    <fo:inline font-family="Courier New">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' hi-d/sup ')]" priority="99">
    <fo:inline baseline-shift="super" font-size="75%">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' hi-d/sub ')]" priority="99">
    <fo:inline baseline-shift="sub" font-size="75%">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- start of programming domain -->
  <xsl:template match="*[contains(@class,' pr-d/codeph ')]" priority="99">
    <fo:inline font-family="Courier New">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/codeblock ')]" priority="99">
    <xsl:call-template name="generate.label"/>
    <fo:block>
		<xsl:call-template name="setscale"/>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'pre'"/>
				<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
			</xsl:call-template>
      <xsl:apply-templates select="@id"/>      
  <!-- rules have to be applied within the scope of the PRE box; else they start from page margin! -->
      <xsl:if test="contains(@frame,'top')"><fo:block><fo:leader leader-pattern="rule" leader-length="5.65in" /></fo:block></xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="contains(@frame,'bot')"><fo:block><fo:leader leader-pattern="rule" leader-length="5.65in" /></fo:block></xsl:if>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/option ')]" priority="99">
    <fo:inline>
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/var ')]" priority="99">
    <fo:inline font-style="italic">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/parmname ')]" priority="99">
    <fo:inline>
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/synph ')]" priority="99">
    <fo:inline>
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/oper ')]" priority="99">
    <fo:inline font-family="Courier New">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/delim ')]" priority="99">
    <fo:inline font-family="Courier New">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/sep ')]" priority="99">
    <fo:inline font-family="Courier New">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/apiname ')]" priority="99">
    <fo:inline font-family="Courier New">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/parml ')]" priority="99">
    <xsl:call-template name="generate.label"/>
    <fo:block>
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/plentry ')]" priority="99">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/pt ')]" priority="99">
   <fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'dt'"/>
				<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
			</xsl:call-template>
      <xsl:apply-templates select="@id"/>
      <xsl:choose>
        <xsl:when test="*"> <!-- tagged content - do not default to bold -->
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <fo:inline font-weight="bold"><xsl:call-template name="apply-for-phrases"/></fo:inline> <!-- text only - bold it -->
        </xsl:otherwise>
      </xsl:choose>
   </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/pd ')]" priority="99">
    <fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'dd'"/>
				<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
			</xsl:call-template>
      <xsl:apply-templates select="@id"/>
     <xsl:apply-templates />
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- syntax diagram -->
  <xsl:template match="*[contains(@class,' pr-d/synblk ')]" priority="99">
    <fo:inline>
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="gen-synnotes">
    <fo:block font-weight="bold">Notes:</fo:block>
    <xsl:for-each select="//*[contains(@class,' pr-d/synnote ')]">
      <xsl:call-template name="dosynnt"/>
    </xsl:for-each>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="dosynnt"> <!-- creates a list of endnotes of synnt content -->
   <xsl:variable name="callout">
    <xsl:choose>
     <xsl:when test="@callout"><xsl:value-of select="@callout"/></xsl:when>
     <xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise>
    </xsl:choose>
   </xsl:variable>
   <fo:block><xsl:apply-templates/></fo:block>
  </xsl:template>
  <!-- ============================================================== -->  
  <xsl:template match="*[contains(@class,' pr-d/synnoteref ')]" priority="99">
  <fo:inline baseline-shift="super" font-size="75%">
      [<xsl:value-of select="@refid"/>]
  </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->  
  <xsl:template match="*[contains(@class,' pr-d/synnote ')]" priority="99">
  <fo:inline baseline-shift="super" font-size="75%">
    <xsl:choose>
      <xsl:when test="not(@id='')"> <!-- case of an explicit id -->
              <xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:when test="not(@callout='')"> <!-- case of an explicit callout (presume id for now) -->
              <xsl:value-of select="@callout"/>
      </xsl:when>
      <xsl:otherwise>
            <xsl:text>*</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/syntaxdiagram ')]" priority="99">
  <fo:block>
    <xsl:apply-templates/>
  </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/fragment ')]" priority="99">
  <fo:block>
    <xsl:value-of select="*[contains(@class,' topic/title ')]"/><xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- Title is optional-->
  <xsl:template match="*[contains(@class,' pr-d/syntaxdiagram ')]/*[contains(@class,' topic/title ')]" priority="99">
  <fo:block font-weight="bold">
    <xsl:value-of select="."/>
  </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- Basically, we want to hide his content. -->
  <xsl:template match="*[contains(@class,' pr-d/repsep ')]" priority="99"/>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/kwd ')]" priority="99">
  <fo:inline font-family="Courier New">
    <xsl:if test="parent::*[contains(@class,' pr-d/groupchoice ')]"><xsl:if test="count(preceding-sibling::*)!=0"> | </xsl:if></xsl:if>
    <xsl:if test="@importance='optional'"> [</xsl:if>
    <xsl:choose>
      <xsl:when test="@importance='default'"><fo:inline text-decoration="underline"><xsl:value-of select="."/></fo:inline></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@importance='optional'">] </xsl:if>
  </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->   
  <!-- This should test to see if there's a fragment with matching title 
  and if so, produce an associative link. -->
  <xsl:template match="*[contains(@class,' pr-d/fragref ')]" priority="100">
  <fo:inline font-family="Courier New">
        <!--a><xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute-->
    &lt;<xsl:value-of select="."/>&gt;<!--/a-->
  </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="var" priority="51">
   <fo:inline font-style="italic">
    <xsl:if test="parent::*[contains(@class,' pr-d/groupchoice ')]"> | </xsl:if>
    <xsl:if test="@importance='optional'"> [</xsl:if>
    <xsl:choose>
      <xsl:when test="@importance='default'"><fo:inline text-decoration="underline"><xsl:value-of select="."/></fo:inline></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@importance='optional'">] </xsl:if>
   </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/fragment ')]/*[contains(@class,' topic/title ')]" priority="99">
  	<fo:block font-weight="bold"><xsl:apply-templates/></fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/fragment ')]/*[contains(@class,' pr-d/groupcomp ')]|*[contains(@class,' pr-d/fragment ')]/*[contains(@class,' pr-d/groupchoice ')]|*[contains(@class,' pr-d/fragment ')]/*[contains(@class,' pr-d/groupseq ')]" priority="99">
  	<fo:block><!--indent this?-->
  	<xsl:call-template name="dogroup"/>
  	</fo:block>
  </xsl:template>
  <!-- ============================================================== -->  
  <xsl:template match="*[contains(@class,' pr-d/syntaxdiagram ')]/*[contains(@class,' pr-d/groupcomp ')]|*[contains(@class,' pr-d/syntaxdiagram ')]/*[contains(@class,' pr-d/groupseq ')]|*[contains(@class,' pr-d/syntaxdiagram ')]/*[contains(@class,' pr-d/groupchoice ')]" priority="99">
  	<xsl:call-template name="dogroup"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/groupcomp ')]/*[contains(@class,' pr-d/groupcomp ')]" priority="99">
  	<xsl:call-template name="dogroup"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/groupchoice ')]/*[contains(@class,' pr-d/groupchoice ')]" priority="99">
  	<xsl:call-template name="dogroup"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/groupseq ')]/*[contains(@class,' pr-d/groupseq ')]" priority="99">
  	<xsl:call-template name="dogroup"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/groupchoice ')]/*[contains(@class,' pr-d/groupcomp ')]" priority="99">
  	<xsl:call-template name="dogroup"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/groupchoice ')]/*[contains(@class,' pr-d/groupseq ')]" priority="99">
  	<xsl:call-template name="dogroup"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/groupcomp ')]/*[contains(@class,' pr-d/groupchoice ')]" priority="99">
  	<xsl:call-template name="dogroup"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/groupcomp ')]/*[contains(@class,' pr-d/groupseq ')]" priority="99">
  	<xsl:call-template name="dogroup"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' pr-d/groupseq ')]/*[contains(@class,' pr-d/groupchoice ')]" priority="99">
  	<xsl:call-template name="dogroup"/>
  </xsl:template>
  <!-- ============================================================== -->  
  <xsl:template match="*[contains(@class,' pr-d/groupseq ')]/*[contains(@class,' pr-d/groupcomp ')]" priority="99">
  	<xsl:call-template name="dogroup"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="dogroup">
  	<xsl:if test="parent::*[contains(@class,' pr-d/groupchoice ')]">
  		<xsl:if test="count(preceding-sibling::*)!=0"> | </xsl:if>
  	</xsl:if>
  	<xsl:if test="@importance='optional'">[</xsl:if>
  	<xsl:if test="name()='groupchoice'">{</xsl:if>
  	  <xsl:text> </xsl:text><xsl:apply-templates/><xsl:text> </xsl:text>
    <!-- repid processed here before -->
  	<xsl:if test="name()='groupchoice'">}</xsl:if>
  	<xsl:if test="@importance='optional'">]</xsl:if>
  </xsl:template>
  <!-- ============================================================== -->  
  <xsl:template match="*[contains(@class,' pr-d/groupcomp ')]/title|*[contains(@class,' pr-d/groupseq ')]/title|*[contains(@class,' pr-d/groupseq ')]/title" priority="99"/>  <!-- Consume title -->
  <!-- ============================================================== -->
  <!-- start of software domain elements -->
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' sw-d/msgph ')]" priority="99">
    <fo:inline font-family="Courier New">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' sw-d/msgblock ')]" priority="99">
    <xsl:if test="contains(@frame,'top')"><hr /></xsl:if>
    <xsl:call-template name="generate.label"/>
    <fo:block> <!-- use pre style -->
      <xsl:apply-templates select="@id"/>
      <xsl:if test="@scale">
        <!--xsl:attribute name="style">font-size: <xsl:value-of select="@scale"/>%;</xsl:attribute-->
      </xsl:if>
      <xsl:apply-templates/>
    </fo:block>
    <xsl:if test="contains(@frame,'bot')"><hr /></xsl:if>
  </xsl:template>
  <!-- ============================================================== --> 
  <xsl:template match="*[contains(@class,' sw-d/msgnum ')]" priority="99">
    <fo:inline>
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' sw-d/cmdname ')]" priority="99">
    <fo:inline>
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' sw-d/varname ')]" priority="99">
    <fo:inline font-style="italic">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' sw-d/filepath ')]" priority="99">
    <fo:inline font-family="Courier New">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' sw-d/userinput ')]" priority="99">
    <fo:inline font-family="Courier New">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' sw-d/systemoutput ')]" priority="99">
    <fo:inline font-family="Courier New">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="apply-for-phrases"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
</xsl:stylesheet>


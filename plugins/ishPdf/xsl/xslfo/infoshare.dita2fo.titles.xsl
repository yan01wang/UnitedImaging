<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
  <!-- ============================================================== -->
  <!-- Revision History -->
  <!-- ============================================================== -->
  <!--
       1/ Initial Version
       2/ 20070720: Added functionality to render topichead elements 
                    correctly within PDF
  -->
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]" mode="toc">
    <xsl:call-template name="get-title"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:variable name="outline.level">
      <xsl:call-template name="get-outline-level">
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="outline.number">
      <xsl:call-template name="get-outline-number">
        <xsl:with-param name="node" select=".."/>
        <xsl:with-param name="outline-level" select="$outline.level"/>
      </xsl:call-template>
    </xsl:variable>
    <fo:block axf:outline-level="{$outline.level}" axf:outline-expand="false">
      <xsl:copy-of select="@id"/>
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="concat('heading', $outline.level)"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>
      <fo:inline id="{generate-id(..)}"/>
      <!-- insert the indexterm ids here -->
      <xsl:for-each select="../*[contains(@class, ' topic/prolog ')]">
        <xsl:apply-templates select="descendant-or-self::*[contains(@class, ' topic/indexterm ') and not(ancestor::*[contains(@class, ' topic/indexterm ')])]"/>
      </xsl:for-each>
      
      <xsl:if test="$toc.numbering = 'yes'">
        <xsl:value-of select="$outline.number"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:call-template name="get-title"/>
      <!--
      <fo:inline id="{generate-id(ancestor-or-self::*[contains(@class,' topic/topic ')][1])}"/>
      <fo:inline id="{ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@id}"/>
      -->
     </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/navtitle ')]" mode="toc">
    <xsl:value-of select="."/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="@navtitle" mode="toc">
    <!--<xsl:call-template name="get-navtitle"/>-->
    <xsl:value-of select="."/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="@navtitle">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:variable name="outline.level">
      <xsl:call-template name="get-outline-level">
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="outline.number">
      <xsl:call-template name="get-outline-number">
        <xsl:with-param name="node" select=".."/>
        <xsl:with-param name="outline-level" select="$outline.level"/>
      </xsl:call-template>
    </xsl:variable>
    <fo:block id="{generate-id()}" axf:outline-level="{$outline.level}" axf:outline-expand="false">
      <xsl:copy-of select="../@id"/>
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="concat('heading', $outline.level)"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>
      <xsl:if test="$toc.numbering = 'yes'">
        <fo:inline-container width="15mm">
          <fo:block>
            <xsl:value-of select="$outline.number"/>
            <!--<xsl:text> </xsl:text>-->
          </fo:block>
        </fo:inline-container>
        <!--<xsl:value-of select="$outline.number"/><xsl:text> </xsl:text>-->
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="."/>
      <!--
      <fo:inline id="{generate-id(ancestor-or-self::*[contains(@class,' map/topicref ')][1])}"/>
      <fo:inline id="{ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@id}"/>
      -->
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- section/title handling -->
  <xsl:template match="*[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <fo:block id="{generate-id()}">
      <xsl:copy-of select="@id"/>
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'blocklabel'"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>      
      <xsl:if test="string-length(ancestor-or-self::*/@outputclass) > 0">
        <xsl:call-template name="add.style">
          <xsl:with-param name="style" select="ancestor-or-self::*/@outputclass"/>
          <xsl:with-param name="language" select="$language"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- example/title handing -->
  <xsl:template match="*[contains(@class, ' topic/example ')]/*[contains(@class, ' topic/title ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <fo:block id="{generate-id()}">
      <xsl:copy-of select="@id"/>
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'blocklabel'"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- table/title handling -->
  <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <fo:block id="{generate-id()}">
      <xsl:copy-of select="@id"/>
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'block'"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>
      <xsl:value-of select="."/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- fig/title handling -->
  <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:variable name="fig-pfx-txt">
      <xsl:call-template name="getString">
        <xsl:with-param name="stringName" select="'Figure'"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>
      <!--<xsl:number level="single" count="title" from="/"/>-->
      <xsl:number level="any" count="*[contains(@class, ' topic/fig ')]/title" from="/"/>
    </xsl:variable>
    <fo:block font-weight="bold" keep-with-previous.within-column="always">
      <!--fo:inline color="red"-->
      <fo:inline> <xsl:value-of select="$fig-pfx-txt"/>. </fo:inline>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="place-tbl-lbl">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:variable name="tbl-count">
      <!-- Number of table/title's before this one -->
      <xsl:number count="*/table/title" level="multiple"/>
      <!-- was ANY-->
    </xsl:variable>
    <xsl:variable name="tbl-count-actual">
      <!-- Number of table/title's including this one -->
      <xsl:choose>
        <xsl:when test="not($tbl-count > 0) and not($tbl-count = 0) and not($tbl-count &lt; 0)">1</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$tbl-count + 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="*[contains(@class, ' topic/title ')]">
        <fo:block>
          <fo:inline font-weight="bold"> <xsl:call-template name="getString"> <xsl:with-param name="stringName" select="'Table'"/> <xsl:with-param name="language" select="$language"/> </xsl:call-template> <xsl:text> </xsl:text> <xsl:value-of select="$tbl-count-actual"/>.<xsl:text> </xsl:text> <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="exhibittitle"/> </fo:inline>
          <xsl:if test="*[contains(@class, ' topic/desc ')]">
            <xsl:text>. </xsl:text>
            <xsl:apply-templates select="*[contains(@class, ' topic/desc ')]" mode="exhibitdesc"/>
          </xsl:if>
        </fo:block>
      </xsl:when>
      <xsl:when test="*[contains(@class, ' topic/desc ')]">
        <fo:block>****<xsl:value-of select="*[contains(@class, ' topic/desc ')]"/> </fo:block>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="place-fig-lbl">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:variable name="fig-count">
      <!-- Number of fig/title's before this one -->
      <xsl:number count="*/fig/title" level="multiple"/>
    </xsl:variable>
    <xsl:variable name="fig-count-actual">
      <!-- Number of fig/title's including this one -->
      <xsl:choose>
        <xsl:when test="not($fig-count > 0) and not($fig-count = 0) and not($fig-count &lt; 0)">1</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$fig-count + 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="*[contains(@class, ' topic/title ')]">
        <fo:block>
          <fo:inline font-weight="bold"> <xsl:call-template name="getString"> <xsl:with-param name="stringName" select="'Figure'"/> <xsl:with-param name="language" select="$language"/> </xsl:call-template> <xsl:text> </xsl:text> <xsl:value-of select="$fig-count-actual"/>.<xsl:text> </xsl:text> <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="exhibittitle"/> </fo:inline>
          <xsl:if test="desc">
            <xsl:text>. </xsl:text>
            <xsl:apply-templates select="*[contains(@class, ' topic/desc ')]" mode="exhibitdesc"/>
          </xsl:if>
        </fo:block>
      </xsl:when>
      <xsl:when test="*[contains(@class, ' topic/desc ')]">
        <fo:block>****<xsl:value-of select="*[contains(@class, ' topic/desc ')]"/> </fo:block>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- named templates -->
  <!-- ============================================================== -->
  <xsl:template name="get-title">
    <xsl:choose>
      <xsl:when test="@spectitle">
        <xsl:value-of select="@spectitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="get-sect-heading">
    <xsl:choose>
      <!-- replace with keyref once implemented -->
      <xsl:when test="@spectitle">
        <xsl:value-of select="@spectitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="sect-heading">
    <xsl:param name="deftitle" select="."/>
    <!-- get param by reference -->
    <xsl:variable name="heading">
      <xsl:choose>
        <xsl:when test="*[contains(@class, ' topic/title ')]">
          <xsl:value-of select="*[contains(@class, ' topic/title ')]"/>
        </xsl:when>
        <xsl:when test="@spectitle">
          <xsl:value-of select="@spectitle"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <!-- based on graceful defaults, build an appropriate section-level heading -->
    <xsl:choose>
      <xsl:when test="not($heading = '')">
        <xsl:if test="normalize-space($heading) = ''">
          <!-- hack: a title with whitespace ALWAYS overrides as null -->
          <!--xsl:comment>no heading</xsl:comment--> </xsl:if>
        <xsl:value-of select="$heading"/>
      </xsl:when>
      <xsl:when test="$deftitle">
        <xsl:value-of select="$deftitle"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- no heading title, output section starting with a break --> </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
</xsl:stylesheet>

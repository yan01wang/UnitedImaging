<?xml version="1.0"?>
<!DOCTYPE xsl:transform [
	<!-- entities for use in the generated output (must produce correctly in FO) -->
	<!ENTITY rbl "&#160;">
	<!ENTITY quotedblleft "&#x201C;">
	<!ENTITY quotedblright "&#x201D;">
	<!ENTITY bullet "&#x2022;">
	<!--check these two for better assignments -->
]>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
  <!-- ============================================================== -->
  <!-- Revision History -->
  <!-- ============================================================== -->
  <!--
       1/ 20050727: Changed template handling indexterms in order to 
                    allow generation of id's on lowerlevel (not 
                    primary) indexterms 
       2/ 20060311: Added topic id as inline fo element used for 
                    cross-referencing to another topic
       3/ 20070626: Added fix for index term resolving if located within
                    the prolog statement.
       4/ 20070720: Added functionality to render topichead elements 
                    correctly within PDF
       5/ 20080108: Added extra 'fo:block' elements before and after the 'fo:inline' elements of the indexterms
  -->
  <!-- ============================================================== -->
  <xsl:param name="working.directory"/>
  <!-- ============================================================== -->
  <!-- null processors -->
  <xsl:template match="*[contains(@class, ' topic/navtitle ')]"/>
  <!-- indexterm within prolog -->
	<xsl:template match="*[contains(@class,' topic/prolog ')]"/>
 <!--
 <xsl:template match="*[contains(@class, ' topic/prolog ')]">
    <fo:block keep-with-next="always" keep-with-previous="always" background-color="green">
     <xsl:apply-templates select="descendant-or-self::*[contains(@class, ' topic/indexterm ') and not(ancestor::*[contains(@class, ' topic/indexterm ')])]"/>
   </fo:block>
  </xsl:template>
-->  <!-- END OF indexterm within prolog -->
  <xsl:template match="*[contains(@class, ' topic/searchtitle ')]"/>
  <xsl:template match="*[contains(@class, ' topic/shortdesc ')]"/>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ') and not(contains(@class, ' mapgroup-d/topicgroup '))]">
    <xsl:variable name="topicLanguage">
      <xsl:call-template name="get.current.language"/>
    </xsl:variable>
    <xsl:comment>TOPIC <xsl:value-of select="@oid"/> </xsl:comment>
    <fo:block id="{generate-id()}">
      <xsl:copy-of select="@id"/>
      <!-- add writing-mode attribute to fo:block -->
      <xsl:call-template name="add.writing-mode">
        <xsl:with-param name="language" select="$topicLanguage"/>
      </xsl:call-template>
      <xsl:if test="($multilingual = 'yes' and count(ancestor-or-self::*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')]) &lt;= 2) or ($multilingual = 'no' and count(ancestor-or-self::*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')]) = 1)">
        <!-- add style attributes to fo:block -->
        <xsl:call-template name="add.style">
          <xsl:with-param name="style" select="'topic'"/>
          <xsl:with-param name="language" select="$topicLanguage"/>
        </xsl:call-template>
      </xsl:if>
      
      <!-- insert metadata -->
      <xsl:if test="contains(@class, ' topic/topic ')">
        <xsl:call-template name="insert.summary"/>
      </xsl:if>
      <!-- add changebars -->
      <xsl:call-template name="add.changebars">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="type" select="'begin'"/>
        <xsl:with-param name="language" select="$topicLanguage"/>
        <xsl:with-param name="placement" select="'break'"/>
      </xsl:call-template>
      <!-- process topic -->
      <xsl:apply-templates select="@navtitle | *[contains(@class, '- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]"/>
      <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' map/topicref '))]"/>
      <!-- generate overview of included topics -->
      <xsl:choose>
        <xsl:when test="$multilingual = 'yes' and count(ancestor-or-self::*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')]) = 1">
          <fo:block>
            <xsl:call-template name="add.style">
              <xsl:with-param name="style" select="'blocklabel'"/>
              <xsl:with-param name="language" select="$topicLanguage"/>
            </xsl:call-template>
            <xsl:call-template name="getString">
              <xsl:with-param name="stringName" select="'Contents'"/>
              <xsl:with-param name="language" select="$topicLanguage"/>
            </xsl:call-template>
          </fo:block>
          <fo:leader color="black" leader-pattern="rule" rule-thickness="5pt" leader-length="100%"/>
          <xsl:call-template name="create.toc">
            <xsl:with-param name="toc.startlevel">2</xsl:with-param>
            <xsl:with-param name="toc.depth" select="number($toc.level) + 1"/>
            <xsl:with-param name="language" select="$topicLanguage"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$generate.topicrefs = 'yes'">
            <xsl:if test="*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ') and not(contains(@class, ' mapgroup-d/topicgroup '))]">
              <xsl:if test="count(descendant::*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ') and not(contains(@class, ' mapgroup-d/topicgroup '))]) > 0">
                <fo:block>
                  <xsl:call-template name="add.style">
                    <xsl:with-param name="style" select="'blocklabel'"/>
                    <xsl:with-param name="language" select="$topicLanguage"/>
                  </xsl:call-template>
                  <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'Contents'"/>
                    <xsl:with-param name="language" select="$topicLanguage"/>
                  </xsl:call-template>
                </fo:block>
                <xsl:for-each select="*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')]">
                  <xsl:call-template name="generate-short-desc">
                    <xsl:with-param name="topicLanguage" select="$topicLanguage"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="add.changebars">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="type" select="'end'"/>
        <xsl:with-param name="language" select="$topicLanguage"/>
        <xsl:with-param name="placement" select="'break'"/>
      </xsl:call-template>
    </fo:block>
    <!-- embed remaining topics -->
      <xsl:apply-templates select="*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')]"/>
  </xsl:template>

  <!-- Common functions -->
  <xsl:template name="string-replace-all">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="by"/>
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text, $replace)"/>
        <xsl:value-of select="$by"/>
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="substring-after($text, $replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="by" select="$by"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ============================================================== -->

  <xsl:template name="generate-short-desc">
    <xsl:param name="topicLanguage"/>
    <xsl:choose>
      <xsl:when test="contains(@class, ' mapgroup-d/topicgroup ')">
        <xsl:for-each select="*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')]">
          <xsl:call-template name="generate-short-desc">
            <xsl:with-param name="topicLanguage" select="$topicLanguage"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <fo:basic-link internal-destination="{generate-id()}">
            <fo:block>
              <xsl:call-template name="add.style">
                <xsl:with-param name="style" select="'toc.section'"/>
                <xsl:with-param name="language" select="$topicLanguage"/>
              </xsl:call-template>
              <xsl:call-template name="add.changebars">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="type" select="'begin'"/>
                <xsl:with-param name="flag.compare.result" select="'yes'"/>
                <xsl:with-param name="language" select="$topicLanguage"/>
                <xsl:with-param name="placement" select="'break'"/>
              </xsl:call-template>
              <fo:inline>
                <xsl:apply-templates select="*[contains(@class, ' topic/title ')] | @navtitle | *[contains(@class, '- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]" mode="toc"/>
              </fo:inline>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="{generate-id()}"/>
              <xsl:call-template name="add.changebars">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="type" select="'end'"/>
                <xsl:with-param name="language" select="$topicLanguage"/>
                <xsl:with-param name="placement" select="'break'"/>
              </xsl:call-template>
            </fo:block>
          </fo:basic-link>
        </fo:block>
        <fo:block>
          <xsl:call-template name="add.style">
            <xsl:with-param name="style" select="'toc.shortdesc'"/>
            <xsl:with-param name="language" select="$topicLanguage"/>
          </xsl:call-template>
          <xsl:call-template name="add.changebars">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="type" select="'begin'"/>
            <xsl:with-param name="language" select="$topicLanguage"/>
            <xsl:with-param name="placement" select="'break'"/>
          </xsl:call-template>
          <xsl:apply-templates select="*[contains(@class, ' topic/shortdesc ')]" mode="toc"/>
          <xsl:call-template name="add.changebars">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="type" select="'end'"/>
            <xsl:with-param name="language" select="$topicLanguage"/>
            <xsl:with-param name="placement" select="'break'"/>
          </xsl:call-template>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/xtitlealts ')]">
    <fo:block>
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'topic.xtitlealts'"/>
        <xsl:with-param name="language">
          <xsl:call-template name="get.current.language"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/shortdesc ')]" mode="toc">
    <fo:block>
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'shortdesc'"/>
        <xsl:with-param name="language">
          <xsl:call-template name="get.current.language"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/body ')]">
    <!--<fo:block>-->
    <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' topic/shortdesc ')]" mode="toc"/>
    <xsl:apply-templates/>
    <!--</fo:block>-->
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/section ')]">
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="@id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block id="{generate-id()}">
      <xsl:copy-of select="@id"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/example ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <!--<fo:block>-->
    <xsl:if test="$insert.elementlabels = '[param not found]' or $insert.elementlabels = 'yes'">
      <fo:block>
        <xsl:call-template name="add.style">
          <xsl:with-param name="style" select="'blocklabel'"/>
          <xsl:with-param name="language" select="$language"/>
        </xsl:call-template>
        <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'Example'"/>
          <xsl:with-param name="language" select="$language"/>
        </xsl:call-template>
      </fo:block>
    </xsl:if>
    <fo:block>
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'block'"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </fo:block>
    <!--</fo:block>-->
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/p ')]">
    <xsl:choose>
      <xsl:when test="ancestor::*[contains(@class, ' topic/li ')] | ancestor::*[contains(@class, ' topic/note ')] | ancestor::*[contains(@class, ' topic/stentry ')] | ancestor::*[contains(@class, ' topic/entry ')]">
        <fo:block>
          <xsl:if test="string(@id)">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:call-template name="add.style">
            <xsl:with-param name="style" select="'block'"/>
            <xsl:with-param name="language">
              <xsl:call-template name="get.current.language"/>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:if test="string-length(ancestor-or-self::*/@outputclass) > 0">
            <xsl:call-template name="add.style">
              <xsl:with-param name="style" select="ancestor-or-self::*/@outputclass"/>
              <xsl:with-param name="language">
                <xsl:call-template name="get.current.language"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="string(@id)">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/note ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:param name="admon.img">
      <!-- TODO Create function to get images by reference -->
      <xsl:choose>
        <xsl:when test="@type = 'note'">
          <xsl:text>admon.note.png</xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'tip'">
          <xsl:text>admon.tip.png</xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'restriction'">
          <xsl:text>admon.restriction.png</xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'important'">
          <xsl:text>admon.important.png</xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'remember'">
          <xsl:text>admon.remember.png</xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'attention'">
          <xsl:text>admon.attention.png</xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'caution'">
          <xsl:text>admon.caution.png</xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'danger'">
          <xsl:text>admon.danger.png</xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'warning'">
          <xsl:text>admon.warning.png</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>admon.note.png</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <fo:block start-indent="0mm">
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'note'"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>
      <!-- take defaults if used inside top-level elements -->
      <xsl:if test="parent::*[contains(@class, ' topic/body ')] | parent::*[contains(@class, ' topic/section ')]">
        <xsl:attribute name="start-indent"><xsl:value-of select="$indent.basic"/>pt</xsl:attribute>
      </xsl:if>
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="10mm"/>
        <xsl:choose>
          <xsl:when test="ancestor::*[contains(@class, ' topic/entry ')]">
            <fo:table-column column-width="80%"/>
          </xsl:when>
          <xsl:otherwise>
            <fo:table-column column-width="90%"/>
          </xsl:otherwise>
        </xsl:choose>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell column-number="1" start-indent="2pt" end-indent="2pt" padding="2pt">
              <fo:block start-indent="0mm">
                <fo:external-graphic>
                  <xsl:attribute name="src">url(<xsl:value-of select="$admon.img"/>)</xsl:attribute>
                </fo:external-graphic>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell column-number="2" start-indent="2pt" end-indent="2pt" padding="2pt">
              <fo:block start-indent="0mm">
                <xsl:apply-templates/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/desc ')]">
    <fo:inline border-left-width="0pt" border-right-width="0pt">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/lq ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <fo:block>
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'lq'"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>
      <xsl:apply-templates/>
      <xsl:choose>
        <xsl:when test="@href">
          <fo:block text-align="right">
            <xsl:value-of select="@href"/>
            <xsl:if test="string-length(@reftitle) > 0"> , <xsl:value-of select="@reftitle"/> </xsl:if>
          </fo:block>
        </xsl:when>
        <xsl:when test="@reftitle">
          <fo:block text-align="right">
            <xsl:value-of select="@reftitle"/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <!--nop--> </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/q ')]">
    <fo:inline border-left-width="0pt" border-right-width="0pt"> "<xsl:apply-templates/>" </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- figure setup -->
  <xsl:template match="*[contains(@class, ' topic/fig ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <fo:block keep-together.within-column="always">
	  <xsl:call-template name="setframe"/>
      <xsl:if test="string-length(ancestor-or-self::*/@outputclass) > 0">
        <xsl:call-template name="add.style">
          <xsl:with-param name="style" select="ancestor-or-self::*/@outputclass"/>
          <xsl:with-param name="language" select="$language"/>
        </xsl:call-template>
      </xsl:if>	  
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'fig'"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>      
      <xsl:if test="@expanse = 'page'">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
      </xsl:if>
      <!-- this is where the main fig rendering happens -->
      <!--<xsl:apply-templates/>-->
      <xsl:apply-templates select="*[not(contains(@class, ' topic/title '))]"/>
      <xsl:apply-templates select="*[contains(@class, ' topic/title ')]"/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/figgroup ')]">
    <fo:inline border-left-width="0pt" border-right-width="0pt">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/pre ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:call-template name="generate.label"/>
    <fo:block>
      <xsl:call-template name="setscale"/>
      <xsl:call-template name="setframe"/>	
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'pre'"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/lines ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:call-template name="generate.label"/>
    <fo:block>
      <xsl:call-template name="setscale"/>
      <xsl:call-template name="setframe"/>	
      <xsl:call-template name="add.style">
        <xsl:with-param name="style" select="'lines'"/>
        <xsl:with-param name="language" select="$language"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- phrase elements -->
  <xsl:template match="*[contains(@class, ' topic/term ')]">
    <fo:inline border-left-width="0pt" border-right-width="0pt">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/ph ')]">
    <fo:inline border-left-width="0pt" border-right-width="0pt">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/tm ')]">
    <fo:inline border-left-width="0pt" border-right-width="0pt">
      <xsl:apply-templates/>
      <fo:inline baseline-shift="super" font-size="75%">
        <xsl:choose>
          <xsl:when test="@tmtype = 'tm'">(TM)</xsl:when>
          <xsl:when test="@tmtype = 'reg'">(R)</xsl:when>
          <xsl:when test="@tmtype = 'service'">(SM)</xsl:when>
          <xsl:otherwise>
            <xsl:text>Error in tm type.</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </fo:inline>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/boolean ')]">
    <fo:inline border-left-width="0pt" border-right-width="0pt" color="green">
      <xsl:value-of select="name()"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="@state"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/state ')]">
    <fo:inline border-left-width="0pt" border-right-width="0pt" color="red">
      <xsl:value-of select="name()"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>=</xsl:text>
      <xsl:value-of select="@value"/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- image and object data -->
  <xsl:template match="*[contains(@class, ' topic/image ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="@placement = 'break'">
        <fo:block>
          <xsl:choose>
            <xsl:when test="parent::*[contains(@class, ' topic/fig ')]">
              <xsl:if test="string-length(ancestor-or-self::*/@outputclass) > 0">
                <xsl:call-template name="add.style">
                  <xsl:with-param name="style" select="ancestor-or-self::*/@outputclass"/>
                  <xsl:with-param name="language" select="$language"/>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="add.style">
                <xsl:with-param name="style" select="'fig'"/>
                <xsl:with-param name="language" select="$language"/>
              </xsl:call-template>
              <xsl:if test="string-length(ancestor-or-self::*/@outputclass) > 0">
                <xsl:call-template name="add.style">
                  <xsl:with-param name="style" select="ancestor-or-self::*/@outputclass"/>
                  <xsl:with-param name="language" select="$language"/>
                </xsl:call-template>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="@align = 'left'">
              <xsl:attribute name="text-align">left</xsl:attribute>
            </xsl:when>
            <xsl:when test="@align = 'right'">
              <xsl:attribute name="text-align">right</xsl:attribute>
            </xsl:when>
            <xsl:when test="@align = 'center'">
              <xsl:attribute name="text-align">center</xsl:attribute>
            </xsl:when>
            <xsl:when test="@align = 'justify'">
              <xsl:attribute name="text-align">justify</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="text-align">center</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="insert-graphic"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="parent::*[contains(@class, ' topic/body ')] | parent::*[contains(@class, ' topic/section ')]">
        <fo:block>
          <xsl:call-template name="add.style">
            <xsl:with-param name="style" select="'fig'"/>
            <xsl:with-param name="language" select="$language"/>
          </xsl:call-template>
          <xsl:if test="string-length(ancestor-or-self::*/@outputclass) > 0">
            <xsl:call-template name="add.style">
              <xsl:with-param name="style" select="ancestor-or-self::*/@outputclass"/>
              <xsl:with-param name="language" select="$language"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="@align = 'left'">
              <xsl:attribute name="text-align">left</xsl:attribute>
            </xsl:when>
            <xsl:when test="@align = 'right'">
              <xsl:attribute name="text-align">right</xsl:attribute>
            </xsl:when>
            <xsl:when test="@align = 'center'">
              <xsl:attribute name="text-align">center</xsl:attribute>
            </xsl:when>
            <xsl:when test="@align = 'justify'">
              <xsl:attribute name="text-align">justify</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="text-align">center</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="insert-graphic"/>
        </fo:block>
      </xsl:when>
      <!-- inline graphics -->
      <!-- TODO image used under body or section directly must not be treated as an inline image -->
      <xsl:otherwise>
        <!--<xsl:call-template name="insert-graphic"/>-->
        <xsl:choose>
          <xsl:when test="@align = 'left' and parent::*[contains(@class, ' topic/fig ')]">
            <!--<xsl:message>image floating left</xsl:message>-->
            <fo:float float="left" clear="right">
              <fo:block>
                <xsl:call-template name="insert-graphic"/>
              </fo:block>
            </fo:float>
          </xsl:when>
          <xsl:when test="@align = 'right' and parent::*[contains(@class, ' topic/fig ')]">
            <!--<xsl:message>image floating right</xsl:message>-->
            <fo:float float="right" clear="left">
              <fo:block>
                <xsl:call-template name="insert-graphic"/>
              </fo:block>
            </fo:float>
          </xsl:when>
          <xsl:otherwise>
            <!--<xsl:message>image NOT floating</xsl:message>-->
            <xsl:call-template name="insert-graphic"/>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="insert-graphic">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:call-template name="add.changebars">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="type" select="'begin'"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="placement" select="@placement"/>
    </xsl:call-template>
    <fo:external-graphic id="{generate-id()}">
      <xsl:variable name="url">
        <xsl:value-of select="@href"/>
      </xsl:variable>
      <xsl:attribute name="src">url(<xsl:value-of select="$url"/>)</xsl:attribute>
      <xsl:choose>
        <xsl:when test="@scale">
          <xsl:attribute name="content-width">
            <xsl:value-of select="concat(@scale, '%')"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <!--xsl:attribute name="content-width">scale-to-fit</xsl:attribute-->
          <!-- no effect --> </xsl:otherwise>
      </xsl:choose>
    </fo:external-graphic>
    <xsl:call-template name="add.changebars">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="type" select="'end'"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="placement" select="@placement"/>
    </xsl:call-template>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/object ')]">
    <fo:block>
      <!-- copy through for browsers; unused for FO -->
      <!-- Detect if it is an SDL Media Manager movie -->
      <xsl:if test="contains(@data, 'sdlmedia.com')">
        <fo:external-graphic id="{generate-id()}">
          <xsl:if test="@data">
            <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
            <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
            <xsl:variable name="originalDataValue">
              <xsl:value-of select="translate(@data, $uppercase, $smallcase)"/>
            </xsl:variable>
            <xsl:variable name="dataValue">
              <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text">
                  <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="$originalDataValue"/>
                    <xsl:with-param name="replace" select="'distribution/?o'"/>
                    <xsl:with-param name="by" select="'distribution/?f'"/>
                  </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="replace" select="'distributions/?o'"/>
                <xsl:with-param name="by" select="'distributions/?f'"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="src">url(<xsl:value-of select="concat($dataValue,'&amp;ext=.mp4')"/>)</xsl:attribute>
            <xsl:attribute name="content-type">video/mp4</xsl:attribute>
            <xsl:attribute name="axf:poster-image">url(<xsl:value-of select="concat($dataValue,'&amp;ext=.jpg')"/>)</xsl:attribute>
            <xsl:attribute name="axf:show-controls">true</xsl:attribute>
            <xsl:attribute name="width">300pt</xsl:attribute>
            <xsl:attribute name="height">200pt</xsl:attribute>
          </xsl:if>
        </fo:external-graphic>
      </xsl:if>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/param ')]">
    <fo:block>
      <!-- copy through for browsers; unused for FO --> </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/draft-comment ')]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <xsl:if test="translate($show-comments, 'YES', 'yes') = 'yes'">
      <fo:block>
        <xsl:call-template name="add.style">
          <xsl:with-param name="style" select="'draft-comment'"/>
          <xsl:with-param name="language" select="$language"/>
        </xsl:call-template>
        <xsl:if test="string-length(@disposition > 0)"> Comment: <xsl:value-of select="@disposition"/> </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
    </xsl:if>
  </xsl:template>
  <!-- ============================================================== -->
  <!--DRD: this template needs to be parametrically controlled by user for visibility -->
  <xsl:template match="*[contains(@class, ' topic/required-cleanup ')]">
    <xsl:if test="translate($show-comments, 'YES', 'yes') = 'yes'">
      <fo:inline background="yellow" color="#CC3333">
        <!-- indents won't apply here; not a block context -->
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-color">black</xsl:attribute>
        <xsl:attribute name="border-width">thin</xsl:attribute>
        <!-- set id -->
        <fo:inline font-weight="bold">Required Cleanup <xsl:if test="string(@remap)">(<xsl:value-of select="@remap"/>) </xsl:if> <xsl:text>: </xsl:text> </fo:inline>
        <xsl:apply-templates/>
      </fo:inline>
    </xsl:if>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/fn ') and not(ancestor::*[contains(@class, ' topic/entry ')])]">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <!--		<fo:block font-size="8pt" color="purple"> -->
    <xsl:variable name="uniqueTextFootnotes" select="ancestor::*[contains(@class, ' topic/topic ')][1]//*[contains(@class, ' topic/fn ') and not(. = preceding::*[contains(@class, ' topic/fn ')])]"/>
    <fo:footnote axf:suppress-duplicate-footnote="true" axf:footnote-position="column">
      <xsl:copy-of select="@id"/>
      <fo:inline baseline-shift="super" font-size="75%" keep-with-previous.within-line="always">
        <xsl:choose>
          <xsl:when test="@callout">
            <xsl:value-of select="@callout"/>
            <!--xsl:number level="multiple" count="//fn"  format="1 "/-->
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="calculate.text.footnotes.sequencenumber">
              <xsl:with-param name="footnote-node" select="."/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </fo:inline>
      <xsl:if test="string-length(.) > 0">
        <fo:footnote-body>
          <fo:block>
            <xsl:call-template name="add.style">
              <xsl:with-param name="style" select="'footnote'"/>
              <xsl:with-param name="language" select="$language"/>
            </xsl:call-template>
            <xsl:if test="@id">
              <fo:inline font-style="italic">
                <xsl:text>[Footnote: </xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>]</xsl:text>
              </fo:inline>
            </xsl:if>
            <fo:inline baseline-shift="super" font-size="75%">
              <xsl:choose>
                <xsl:when test="@callout">
                  <xsl:value-of select="@callout"/>
                  <!--xsl:number level="multiple" count="//fn"  format="1 "/-->
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="calculate.text.footnotes.sequencenumber">
                    <xsl:with-param name="footnote-node" select="."/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <!--<xsl:number level="multiple" count="//fn"  format="1 "/>-->
                </xsl:otherwise>
              </xsl:choose>
            </fo:inline>
            <xsl:apply-templates/>
          </fo:block>
        </fo:footnote-body>
      </xsl:if>
    </fo:footnote>
    <!--</fo:block>-->
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/fn ') and ancestor::*[contains(@class, ' topic/entry ')]]">
    <!-- TODO: build list of unique footnotes used in table (check callout/number handling vs footnote body text) -->
    <!--		<xsl:variable name="uniqueTableFootnotes" select="ancestor-or-self::*[contains(@class,' topic/table ')][1]//*[contains(@class,' topic/fn ') and not(.=preceding::*[contains(@class,' topic/fn ')])]"/>-->
    <fo:inline baseline-shift="super" font-size="75%" keep-with-previous.within-line="always">
      <xsl:choose>
        <xsl:when test="@callout">
          <xsl:value-of select="@callout"/>
          <!--xsl:number level="multiple" count="//fn"  format="1 "/-->
        </xsl:when>
        <xsl:otherwise>

          <xsl:call-template name="calculate.table.footnotes.sequencenumber">
            <xsl:with-param name="footnote-node" select="."/>
          </xsl:call-template>
          <!--<xsl:number level="multiple" count="//fn"  format="1 "/>-->
        </xsl:otherwise>
      </xsl:choose>
    </fo:inline>
  </xsl:template>
  <!-- ======================================================================= -->
  <!-- Calculate sequence number of (unique) footnote found in the text       -->
  <!-- ======================================================================= -->
  <xsl:template name="calculate.text.footnotes.sequencenumber">
    <xsl:param name="footnote-node"/>
    <xsl:param name="language"/>

    <xsl:variable name="uniqueTextFootnotes" select="ancestor::*[contains(@class, ' topic/topic ')][1]//*[contains(@class, ' topic/fn ') and not(. = preceding::*[contains(@class, ' topic/fn ')])]"/>

    <xsl:if test="count($uniqueTextFootnotes) > 0">
      <xsl:for-each select="$uniqueTextFootnotes">
        <xsl:if test=". = $footnote-node">
          <!--<xsl:message>Found footnote node as being number: <xsl:value-of select="position()" /></xsl:message>-->
          <xsl:value-of select="position()"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- ======================================================================= -->
  <!-- Calculate sequence number of (unique) footnote found in the table       -->
  <!-- ======================================================================= -->
  <xsl:template name="calculate.table.footnotes.sequencenumber">
    <xsl:param name="footnote-node"/>
    <xsl:param name="language"/>

    <xsl:variable name="tableNode">
      <xsl:value-of select="ancestor::*[contains(@class, ' topic/tgroup ')][1]"/>
    </xsl:variable>

    <!--xsl:message>Handling footnodes in : <xsl:value-of select="$tableNode"/></xsl:message-->
    <!--		<xsl:variable name="uniqueTableFootnotes" select="ancestor::*[contains(@class,' topic/table ')][1]//*[contains(@class,' topic/fn ') and not(.=preceding::*[contains(@class,' topic/fn ')])]"/>-->
    <xsl:variable name="uniqueTableFootnotes" select="ancestor::*[contains(@class, ' topic/table ')][1]//*[contains(@class, ' topic/fn ') and not(. = preceding::*[contains(@class, ' topic/fn ')][ancestor-or-self::*[contains(@class, ' topic/tgroup ')] = $tableNode])]"/>
    <!--xsl:message>Found footnodes : <xsl:value-of select="count($uniqueTableFootnotes)"/></xsl:message-->
    <!--xsl:message>Search for position of footnote: <xsl:value-of select="$footnote-node"/></xsl:message-->
    <xsl:if test="count($uniqueTableFootnotes) > 0">
      <xsl:for-each select="$uniqueTableFootnotes">
        <xsl:if test=". = $footnote-node">
          <!--<xsl:message>Found footnote node as being number: <xsl:value-of select="position()" /></xsl:message>-->
          <xsl:value-of select="position()"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="footnotex">
    <xsl:param name="language">
      <xsl:call-template name="get.current.language"/>
    </xsl:param>
    <fo:footnote>
      <fo:inline baseline-shift="super" font-size="7pt" font-family="Arial">
        <xsl:number count="//fn" format="1"/>
      </fo:inline>
      <fo:footnote-body>
        <fo:block>
          <xsl:call-template name="add.style">
            <xsl:with-param name="style" select="'footnote'"/>
            <xsl:with-param name="language" select="$language"/>
          </xsl:call-template>
          <fo:inline baseline-shift="super" font-size="75%">
            <xsl:number level="multiple" count="//fn" format="1 "/>
          </fo:inline>
          <xsl:apply-templates/>
        </fo:block>
      </fo:footnote-body>
    </fo:footnote>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- other special data -->
  <!-- this rule is prolog-specific; can move it into dita-prolog.xsl if desired -->
  <xsl:template match="*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/keyword ')]" priority="2">
    <fo:inline>
      <xsl:text> [</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>] </xsl:text>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/keyword ')]">
    <fo:inline border-left-width="0pt" border-right-width="0pt">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/cite ')]">
    <fo:inline font-style="italic">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/indextermref ')]">
    <fo:inline font-style="italic">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/indexterm ')]">
    <xsl:choose>
      <xsl:when test="parent::*[contains(@class, ' topic/section ')]">
        <fo:block keep-with-next="always" keep-with-previous="always">
          <fo:inline id="{generate-id()}"/>
          <!-- implemented additional check for secondary index -->
          <xsl:apply-templates select="*[contains(@class, ' topic/indexterm ')]"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline id="{generate-id()}"/>
        <!-- implemented additional check for secondary index -->
        <xsl:apply-templates select="*[contains(@class, ' topic/indexterm ')]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="nulled-indexterm">
    <fo:inline margin="1pt" background-color="#ffddff">
      <!-- border="1pt black solid;"--> [ <xsl:apply-templates/> ] </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class, ' topic/data ')]">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- =================== end of element rules ====================== -->
</xsl:stylesheet>

<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.1">
  <xsl:import href="../common/infoshare.params.xsl"></xsl:import>
  <xsl:import href="../common/infoshare.jobticket.xsl"></xsl:import>
  <xsl:import href="../common/infoshare.I18N.xsl"></xsl:import>
  <xsl:import href="infoshare.dita2htm.metadata.xsl"></xsl:import>


  <!-- ============================================================== -->
  <!--
		TWEAKS
			$toc.numbering   			- indicates whether a toc is needed (yes / no)
			$toc.level						- indicates how many levels will be included in the toc (1..5)
	-->
  <!-- ============================================================== -->
  <!-- Revision History -->
  <!-- ============================================================== -->
  <!--
       1/ Initial Version
       2/ 20070720: Added functionality to render topichead elements 
                    correctly within PDF
       3/ 20080427: nested maps not working correctly caused by the topicgroup element
  -->
  <!-- ============================================================== -->
  <xsl:param name="OUTEXT" select="'.html'"/>
  <!-- "htm" and "html" are valid values -->
  <xsl:param name="WORKDIR" />
  <xsl:param name="DITAEXT" select="'.xml'"/>
  <xsl:param name="FILEREF" select="'file://'"/>
  <xsl:param name="contenttarget" select="'contentwin'"/>
  <xsl:param name="CSS"/>
  <xsl:param name="CSSPATH"/>
  <xsl:param name="OUTPUTCLASS"/>
  <xsl:param name="toc.level">20</xsl:param>
  <xsl:param name="toc.numbering">no</xsl:param>


  <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" />
  <!-- ============================================================== -->
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
          <xsl:otherwise>
            <!-- null processor -->
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length($contenttarget)>0 and $contenttarget!='NONE'">
          <base target="{$contenttarget}"/>
        </xsl:if>
        <link rel="stylesheet" type="text/css" href="webhelplayout.css" />
        <link rel="stylesheet" type="text/css" href="stylesheet.css" />
        <script language="javascript" type="text/javascript" src="toc.js"></script>
      </head>
      <body class="framelayout">
        <h1 class="heading1">
          <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'Contents'" />
            <xsl:with-param name="language">
              <xsl:call-template name="get.current.language" />
            </xsl:with-param>
          </xsl:call-template>
          <xsl:if test="string-length($OUTPUTCLASS) &gt; 0">
            <xsl:attribute name="class">
              <xsl:value-of select="$OUTPUTCLASS"/>
            </xsl:attribute>
          </xsl:if>
        </h1>
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
          <tr>
            <td align="left" valign="top" nowrap="nowrap">
              <xsl:call-template name="generate.toc">
                <xsl:with-param name="poutline-level" select="0" />
                <xsl:with-param name="node" select="*[contains(@class,' map/map ')]"/>
              </xsl:call-template>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
  <!-- ============================================================== -->
  <!-- named templates -->
  <!-- ============================================================== -->
  <xsl:template name="generate.toc">
    <xsl:param name="poutline-level" />
    <xsl:param name="node"/>

    <span id="s{generate-id()}">
      <xsl:if test="$poutline-level > 0">
        <xsl:attribute name="class">
          <xsl:text>sp</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:for-each select="$node/*[contains(@class,' topic/topic ') or contains(@class,' map/topicref ')  and not(contains(@class,' mapgroup-d/topicgroup '))][not(@toc='no')]">
        <xsl:variable name="outline-level">
          <xsl:call-template name="get-outline-level">
            <xsl:with-param name="node" select="."/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="outline-number">
          <xsl:call-template name="get-outline-number">
            <xsl:with-param name="node" select="."/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$toc.level >= $outline-level">
            <!--<xsl:if test="$outline-level > 1">
							<xsl:attribute name="class"><xsl:text>sp</xsl:text></xsl:attribute>
						</xsl:if>-->
            <div class="tocItem">
              <xsl:choose>
                <xsl:when test="*[contains(@class,' topic/topic ') or contains(@class,' map/topicref ') and not(contains(@class,' mapgroup-d/topicgroup '))]">
                  <img id="p{generate-id()}" src="plus.png">
                    <xsl:attribute name="onclick">
                      <xsl:text>exp('</xsl:text>
                      <xsl:value-of select="generate-id()"/>
                      <xsl:text>')</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="style">
                      <xsl:value-of select="concat('margin-left:',16*($outline-level - 1),'px')"/>
                    </xsl:attribute>
                  </img>
                  <img id="b{generate-id()}" src="book.png"/>
                </xsl:when>
                <xsl:otherwise>
                  <img id="{generate-id()}" src="space.png">
                    <xsl:attribute name="onclick">
                      <xsl:text>exp('</xsl:text>
                      <xsl:value-of select="generate-id()"/>
                      <xsl:text>')</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="style">
                      <xsl:value-of select="concat('margin-left:',16*($outline-level - 1),'px')"/>
                    </xsl:attribute>
                  </img>
                  <img id="{generate-id()}" src="topic.png"/>
                </xsl:otherwise>
              </xsl:choose>

              <a id="a{generate-id()}" target="{$contenttarget}" onclick="javascript:highlight(this)">
                <xsl:if test="string-length(@href) > 0">
                  <xsl:attribute name="href">
                    <xsl:value-of select="substring-before(@href,$DITAEXT)"/>
                    <xsl:value-of select="$OUTEXT"/>
                  </xsl:attribute>
                  <xsl:if test="@scope='external' or @type='external' or ((@format='PDF' or @format='pdf') and not(@scope='local'))">
                    <xsl:attribute name="target">_blank</xsl:attribute>
                  </xsl:if>
                </xsl:if>
                <xsl:if test="string-length(@href)=0">
                  <xsl:attribute name="onclick">
                    <xsl:text>exp('</xsl:text>
                    <xsl:value-of select="generate-id()"/>
                    <xsl:text>')</xsl:text>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="$toc.numbering = 'yes'">
                  <xsl:value-of select="$outline-number"/>
                  <xsl:text> </xsl:text>
                </xsl:if>
                <!--		 					  <xsl:apply-templates select="*[contains(@class,' topic/title ')] | @navtitle | *[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]" mode="toc"/>-->
                <xsl:choose>
                  <xsl:when test="@locktitle='yes'">
                    <xsl:apply-templates select="@navtitle" mode="toc"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="*[contains(@class,' topic/title ')] | *[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]">
                        <xsl:apply-templates select="*[contains(@class,' topic/title ')] | *[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]" mode="toc"/>
                      </xsl:when>
                      <xsl:when test="@navtitle">
                        <xsl:apply-templates select="@navtitle" mode="toc"/>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <!-- DO NOTHING -->
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="generate.toc">
          <xsl:with-param name="poutline-level" select="$outline-level" />
          <xsl:with-param name="node" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </span>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="get-outline-number">
    <xsl:param name="node" />
    <xsl:param name="outline-number"/>
    <xsl:variable name="outline-level">
      <xsl:call-template name="get-outline-level">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$outline-level > 0">
        <xsl:variable name="new-outline-number">
          <xsl:choose>
            <xsl:when test="not(contains($node/@class, ' mapgroup-d/topicgroup '))">
              <xsl:call-template name="count-items-topicgroup">
                <xsl:with-param name="node" select="$node"/>
              </xsl:call-template>
              <xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <!-- DO NOTHING -->
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="get-outline-number">
          <xsl:with-param name="outline-level" select="$outline-level - 1" />
          <xsl:with-param name="outline-number" select="concat($new-outline-number, $outline-number)"/>
          <xsl:with-param name="node" select="$node/parent::*[contains(@class,' topic/topic ') or contains(@class,' map/topicref ')]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$outline-number"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="count-items-topicgroup">
    <xsl:param name="node"/>
    <xsl:choose>

      <xsl:when test="$node/parent::*[contains(@class,' mapgroup-d/topicgroup ')] or $node/preceding-sibling::*[contains(@class,' mapgroup-d/topicgroup ') or @toc ='no' ]">
        <xsl:variable name="result">
          <xsl:call-template name="count-items-topicgroup-helper">
            <xsl:with-param name="current-node" select="$node/ancestor::*[not(contains(@class,' mapgroup-d/topicgroup ')) or @toc='no'][1]/*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')][1]"/>
            <xsl:with-param name="stop-node-generated-id" select="generate-id($node)"/>
            <xsl:with-param name="position" select="1"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$result &gt;= 9999999">
            <xsl:value-of select="$result - 9999999"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$result"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count($node/preceding-sibling::*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')]) + 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="count-items-topicgroup-helper">
    <xsl:param name="current-node"/>
    <xsl:param name="stop-node-generated-id"/>
    <xsl:param name="position"/>
    <xsl:choose>
      <xsl:when test="generate-id($current-node) = $stop-node-generated-id">
        <xsl:value-of select="$position + 9999999"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$current-node[contains(@class, ' mapgroup-d/topicgroup ') or @toc='no']">
            <xsl:variable name="child-value">
              <xsl:call-template name="count-items-topicgroup-helper">
                <xsl:with-param name="current-node" select="$current-node/*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')][1]"/>
                <xsl:with-param name="stop-node-generated-id" select="$stop-node-generated-id"/>
                <xsl:with-param name="position" select="0"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="sibling-value">
              <xsl:choose>
                <xsl:when test="$child-value &gt;= 9999999">
                  <xsl:value-of select="0"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="count-items-topicgroup-helper">
                    <xsl:with-param name="current-node" select="$current-node/following-sibling::*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')][1]"/>
                    <xsl:with-param name="stop-node-generated-id" select="$stop-node-generated-id"/>
                    <xsl:with-param name="position" select="0"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="$position + $child-value + $sibling-value"/>
          </xsl:when>
          <xsl:when test="$current-node[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')]">
            <xsl:variable name="sib-value">
              <xsl:call-template name="count-items-topicgroup-helper">
                <xsl:with-param name="current-node" select="$current-node/following-sibling::*[contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')][1]"/>
                <xsl:with-param name="stop-node-generated-id" select="$stop-node-generated-id"/>
                <xsl:with-param name="position" select="0"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$position + $sib-value + 1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$position"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="get-outline-level">
    <xsl:param name="node" />
    <xsl:value-of select="count($node/ancestor-or-self::*[contains(@class,' topic/topic ') or contains(@class,' map/topicref ') and not(contains(@class,' mapgroup-d/topicgroup '))])"/>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template name="generate.tocNavArray">
    <xsl:param name="node"/>
    <xsl:for-each select="$node/*[contains(@class,' topic/topic ') or contains(@class,' map/topicref ') and not(contains(@class,' mapgroup-d/topicgroup '))][not(@toc='no')]">
      var tocElem = new Array('<xsl:value-of select="generate-id()"/>','<xsl:value-of select="concat(substring-before(@href,$DITAEXT),$OUTEXT)"/>');
      tocArr.push(tocElem);
      <xsl:if test="count(ancestor::*) > 1">
        var tocParent = new Array('<xsl:value-of select="generate-id(parent::*)"/>','<xsl:value-of select="generate-id()"/>');
        tocParentArr.push(tocParent);
      </xsl:if>
      <xsl:call-template name="generate.tocNavArray">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <!-- ============================================================== -->
</xsl:stylesheet>

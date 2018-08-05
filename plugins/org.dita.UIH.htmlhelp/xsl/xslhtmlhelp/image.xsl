<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                exclude-result-prefixes="xs dita-ot dita2html ditamsg">
				<!-- =========== IMAGE/OBJECT =========== -->

<xsl:template match="*[contains(@class, ' topic/image ')]" name="topic.image">
  <!-- build any pre break indicated by style -->
  <xsl:choose>
    <xsl:when test="parent::*[contains(@class, ' topic/fig ')][contains(@frame, 'top ')]">
      <!-- NOP if there is already a break implied by a parent property -->
    </xsl:when>
    <xsl:when test="@placement = 'break'">
      <br/>
    </xsl:when>
  </xsl:choose>
  <xsl:call-template name="setaname"/>
  <xsl:choose>
    <xsl:when test="@placement = 'break'"><!--Align only works for break-->
      <xsl:choose>
        <xsl:when test="@align = 'left'">
          <div class="imageleft">
            <xsl:call-template name="topic-image"/>
          </div>
        </xsl:when>
        <xsl:when test="@align = 'right'">
          <div class="imageright">
            <xsl:call-template name="topic-image"/>
          </div>
        </xsl:when>
        <xsl:when test="@align = 'center'">
          <div class="imagecenter">
            <xsl:call-template name="topic-image"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="topic-image"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="topic-image"/>
    </xsl:otherwise>
  </xsl:choose>
  <!-- build any post break indicated by style -->
  <xsl:if test="not(@placement = 'inline')"><br/></xsl:if>
  <!-- image name for review -->
  <xsl:if test="$ARTLBL = 'yes'"> [<xsl:value-of select="@href"/>] </xsl:if>
</xsl:template>

<xsl:template name="topic-image">
  <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
  <img>
    <xsl:call-template name="commonattributes">
      <xsl:with-param name="default-output-class">
        <xsl:if test="@placement = 'break'"><!--Align only works for break-->
          <xsl:choose>
            <xsl:when test="@align = 'left'">imageleft</xsl:when>
            <xsl:when test="@align = 'right'">imageright</xsl:when>
            <xsl:when test="@align = 'center'">imagecenter</xsl:when>
          </xsl:choose>
        </xsl:if>
	 </xsl:with-param>
    </xsl:call-template>
	<!-- 嵌入的图片 增加属性 css设定前后间距 -->
	<xsl:if test="@placement = 'inline'">
	<xsl:attribute name="class" select="'inline_image'"/>
	</xsl:if>
	<xsl:if test="@placement = 'break'">
	<xsl:attribute name="class" select="'break_image'"/>
	</xsl:if>
	
	<xsl:attribute name="width" select="floor(number(@dita-ot:image-width) div 2)"/>
	<xsl:attribute name="height" select="floor(number(@dita-ot:image-height)  div 2)"/>
	
    <xsl:call-template name="setid"/>
    <xsl:choose>
      <xsl:when test="*[contains(@class, ' topic/longdescref ')]">
        <xsl:apply-templates select="*[contains(@class, ' topic/longdescref ')]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@longdescref"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="@href|@height|@width"/>
    <xsl:apply-templates select="@scale"/>
    <xsl:choose>
      <xsl:when test="*[contains(@class, ' topic/alt ')]">
        <xsl:variable name="alt-content"><xsl:apply-templates select="*[contains(@class, ' topic/alt ')]" mode="text-only"/></xsl:variable>
        <xsl:attribute name="alt" select="normalize-space($alt-content)"/>
      </xsl:when>
      <xsl:when test="@alt">
        <xsl:attribute name="alt" select="@alt"/>
      </xsl:when>
    </xsl:choose>
  </img>
  <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/alt ')]">
  <xsl:apply-templates select="." mode="text-only"/>
</xsl:template>

<!-- Process image attributes. Using priority, in case default @href is added at some point. -->
<!-- 20090303: Removed priority; does not appear to be needed. -->
<xsl:template match="*[contains(@class, ' topic/image ')]/@href">
  <xsl:attribute name="src" select="."/>
</xsl:template>

<!-- AM: handling for scale attribute -->
<xsl:template match="*[contains(@class, ' topic/image ')]/@scale">
    <xsl:variable name="width" select="../@dita-ot:image-width"/>
    <xsl:variable name="height" select="../@dita-ot:image-height"/>
    <xsl:if test="not(../@width) and not(../@height)">
      <xsl:attribute name="height" select="floor(number($height) * number(.) div 100)"/>
      <xsl:attribute name="width" select="floor(number($width) * number(.) div 100)"/>
    </xsl:if>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/image ')]/@height">
  <xsl:variable name="height-in-pixel">
    <xsl:call-template name="length-to-pixels">
      <xsl:with-param name="dimen" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="not($height-in-pixel = '100%')">
    <xsl:attribute name="height">
      <!--xsl:choose>
        <xsl:when test="../@scale and string(number(../@scale))!='NaN'">          
          <xsl:value-of select="number($height-in-pixel) * number(../@scale)"/>
        </xsl:when>
        <xsl:otherwise-->
          <xsl:value-of select="number($height-in-pixel)"/>
        <!--/xsl:otherwise>
      </xsl:choose-->
    </xsl:attribute>
  </xsl:if>  
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/image ')]/@width">
  <xsl:variable name="width-in-pixel">
    <xsl:call-template name="length-to-pixels">
      <xsl:with-param name="dimen" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="not($width-in-pixel = '100%')">
    <xsl:attribute name="width">
      <!--xsl:choose>
        <xsl:when test="../@scale and string(number(../@scale))!='NaN'">          
          <xsl:value-of select="number($width-in-pixel) * number(../@scale)"/>
        </xsl:when>
        <xsl:otherwise-->
          <xsl:value-of select="number($width-in-pixel)"/>
        <!--/xsl:otherwise>
      </xsl:choose-->
    </xsl:attribute>
  </xsl:if>  
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/image ')]/@longdescref">
  <xsl:attribute name="longdesc">
    <xsl:choose>
      <!-- Guess whether link target is a DITA topic or something else -->
      <xsl:when test="contains(., '.dita') or contains(., '.xml')">
        <xsl:call-template name="replace-extension">
          <xsl:with-param name="filename" select="."/>
          <xsl:with-param name="extension" select="$OUTEXT"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>

  <xsl:template match="*[contains(@class, ' topic/image ')]/*[contains(@class, ' topic/longdescref ')]">
  <xsl:if test="@href and not (@href = '')">
    <xsl:attribute name="longdesc">
      <xsl:choose>
        <xsl:when test="not(@format) or @format = 'dita'">
          <xsl:call-template name="replace-extension">
            <xsl:with-param name="filename" select="@href"/>
            <xsl:with-param name="extension" select="$OUTEXT"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:if>
</xsl:template>
</xsl:stylesheet>
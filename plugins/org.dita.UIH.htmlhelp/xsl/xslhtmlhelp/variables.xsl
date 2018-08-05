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

<!-- =========== DEFAULT VALUES FOR EXTERNALLY MODIFIABLE PARAMETERS =========== -->

<!-- /CSS = default CSS filename parameter ('')-->
<xsl:param name="CSS"/>

<xsl:param name="dita-css">
 <xsl:call-template name="getVariable">
      <xsl:with-param name="id" select="'dita-css'"/>
  </xsl:call-template>
</xsl:param>

<xsl:param name="bidi-dita-css">
 <xsl:call-template name="getVariable">
      <xsl:with-param name="id" select="'bidi-dita-css'"/>
  </xsl:call-template>
</xsl:param>

 <!-- left to right languages -->
 <!-- bidirectional languages -->

<!-- Transform type, such as 'xhtml', 'htmlhelp', or 'eclipsehelp' -->
<xsl:param name="TRANSTYPE" select="'xhtml'"/>

<!-- default CSS path parameter (null)-->
<xsl:param name="CSSPATH"/>

<!-- Preserve DITA class ancestry in XHTML output; values are 'yes' or 'no' -->
<xsl:param name="PRESERVE-DITA-CLASS" select="'yes'"/>

<!-- the file name containing XHTML to be placed in the HEAD area
     (file name and extension only - no path). -->
<xsl:param name="HDF"/>

<!-- the file name containing XHTML to be placed in the BODY running-heading area
     (file name and extension only - no path). -->
<xsl:param name="HDR"/>

<!-- the file name containing XHTML to be placed in the BODY running-footing area
     (file name and extension only - no path). -->
<xsl:param name="FTR"/>

<!-- default "output artwork filenames" processing parameter ('no')-->
<xsl:param name="ARTLBL" select="'no'"/><!-- "no" and "yes" are valid values; non-'yes' is ignored -->

<!-- default "hide draft & cleanup content" processing parameter ('no' = hide them)-->
<xsl:param name="DRAFT" select="'no'"/><!-- "no" and "yes" are valid values; non-'yes' is ignored -->

<!-- default "hide index entries" processing parameter ('no' = hide them)-->
<xsl:param name="INDEXSHOW" select="'no'"/><!-- "no" and "yes" are valid values; non-'yes' is ignored -->

<!-- for now, disable breadcrumbs pending link group descision -->
<xsl:param name="BREADCRUMBS" select="'no'"/> <!-- "no" and "yes" are valid values; non-'yes' is ignored -->

<!-- the year for the copyright -->
<xsl:param name="YEAR" select="format-date(current-date(), '[Y]')"/>

<!-- default "output extension" processing parameter ('.html')-->
<xsl:param name="OUTEXT" select="'.html'"/><!-- "htm" and "html" are valid values -->

<!-- the working directory that contains the document being transformed.
     Needed as a directory prefix for the @conref "document()" function calls.
     default is '../doc/')-->
  <xsl:param name="WORKDIR">
    <xsl:apply-templates select="/processing-instruction('workdir-uri')[1]" mode="get-work-dir"/>
  </xsl:param>

<!-- the path back to the project. Used for c.gif, delta.gif, css to allow user's to have
     these files in 1 location. -->
    <xsl:param name="PATH2PROJ">
        <xsl:apply-templates select="/processing-instruction('path2project-uri')[1]" mode="get-path2project"/>
    </xsl:param>
  
<!-- the file name (file name and extension only - no path) of the document being transformed.
     Needed to help with debugging.
     default is 'myfile.xml')-->
<xsl:param name="FILENAME"/>
<xsl:param name="FILEDIR"/>
<xsl:param name="CURRENTFILE" select="concat($FILEDIR, '/', $FILENAME)"/>

<!-- the file name containing filter/flagging/revision information
     (file name and extension only - no path).  - testfile: revflag.dita -->
<xsl:param name="FILTERFILE"/>

<!-- Debug mode - enables XSL debugging xsl-messages.
     Needed to help with debugging.
     default is 'no')-->
<xsl:param name="DBG" select="'no'"/> <!-- "no" and "yes" are valid values; non-'yes' is ignored -->

<!-- Switch to enable or disable the generation of default meta message in html header -->
<xsl:param name="genDefMeta" select="'no'"/>

<!-- Name of the keyref file that contains key definitions -->
<!-- Deprecated since 2.1 -->
<xsl:param name="KEYREF-FILE" select="concat($WORKDIR, $PATH2PROJ, 'keydef.xml')"/>
<!-- Deprecated since 2.1 -->
<xsl:variable name="keydefs" select="document($KEYREF-FILE)"/>
  
<xsl:param name="BASEDIR"/>
  
<xsl:param name="OUTPUTDIR"/>

  <!-- get destination dir with BASEDIR and OUTPUTDIR-->
  <xsl:variable name="desDir">
    <xsl:choose>
      <xsl:when test="not($BASEDIR)"/> <!-- If no filterfile leave empty -->
      <xsl:when test="starts-with($BASEDIR, 'file:')">
        <xsl:value-of select="translate(concat($BASEDIR, '/', $OUTPUTDIR, '/'), '\', '/')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains($OUTPUTDIR, ':\') or contains($OUTPUTDIR, ':/')">
            <xsl:value-of select="'file:/'"/><xsl:value-of select="concat($OUTPUTDIR, '/')"/>
          </xsl:when>
          <xsl:when test="starts-with($OUTPUTDIR, '/')">
            <xsl:value-of select="'file://'"/><xsl:value-of select="concat($OUTPUTDIR, '/')"/>
          </xsl:when>
          <xsl:when test="starts-with($BASEDIR, '/')">
            <xsl:text>file://</xsl:text><xsl:value-of select="concat($BASEDIR, '/', $OUTPUTDIR, '/')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>file:/</xsl:text><xsl:value-of select="translate(concat($BASEDIR, '/', $OUTPUTDIR, '/'), '\', '/')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!-- =========== "GLOBAL" DECLARATIONS (see 35) =========== -->

<!-- The document tree of filterfile returned by document($FILTERFILE,/)-->
  <xsl:variable name="FILTERFILEURL">
    <xsl:choose>
      <xsl:when test="not($FILTERFILE)"/> <!-- If no filterfile leave empty -->
      <xsl:when test="starts-with($FILTERFILE, 'file:')">
        <xsl:value-of select="$FILTERFILE"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="starts-with($FILTERFILE, '/')">
            <xsl:text>file://</xsl:text><xsl:value-of select="$FILTERFILE"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>file:/</xsl:text><xsl:value-of select="$FILTERFILE"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
<xsl:variable name="FILTERDOC"
              select="if (string-length($FILTERFILEURL) > 0)
                      then document($FILTERFILEURL, /)
                      else ()"/>
  
  <xsl:variable name="passthrough-attrs" as="element()*"
                select="$FILTERDOC/val/prop[@action = 'passthrough']"/>

<!-- Define a newline character -->
<xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>

<!--Check the file Url Definition of HDF HDR FTR-->
 <xsl:variable name="HDFFILE">
   <xsl:choose>
     <xsl:when test="not($HDF)"/> <!-- If no filterfile leave empty -->
     <xsl:when test="starts-with($HDF, 'file:')">
       <xsl:value-of select="$HDF"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:choose>
         <xsl:when test="starts-with($HDF, '/')">
           <xsl:text>file://</xsl:text><xsl:value-of select="$HDF"/>
         </xsl:when>
         <xsl:otherwise>
           <xsl:text>file:/</xsl:text><xsl:value-of select="$HDF"/>
         </xsl:otherwise>
       </xsl:choose>
     </xsl:otherwise>
   </xsl:choose>
 </xsl:variable>
  
  <xsl:variable name="HDRFILE">
    <xsl:choose>
      <xsl:when test="not($HDR)"/> <!-- If no filterfile leave empty -->
      <xsl:when test="starts-with($HDR, 'file:')">
        <xsl:value-of select="$HDR"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="starts-with($HDR, '/')">
            <xsl:text>file://</xsl:text><xsl:value-of select="$HDR"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>file:/</xsl:text><xsl:value-of select="$HDR"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:variable>
  
  <xsl:variable name="FTRFILE">
    <xsl:choose>
      <xsl:when test="not($FTR)"/> <!-- If no filterfile leave empty -->
      <xsl:when test="starts-with($FTR, 'file:')">
        <xsl:value-of select="$FTR"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="starts-with($FTR, '/')">
            <xsl:text>file://</xsl:text><xsl:value-of select="$FTR"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>file:/</xsl:text><xsl:value-of select="$FTR"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
<!-- Define the error message prefix identifier -->
<!-- Deprecated since 2.3 -->
<xsl:variable name="msgprefix">DOTX</xsl:variable>

<!-- Filler for A-name anchors  - was &nbsp;-->
<xsl:variable name="afill"></xsl:variable>

<xsl:variable name="HTML_ID_SEPARATOR" select="'__'"/>

<xsl:variable name="v_currentLang">
  <xsl:value-of select="dita-ot:get-current-language(.)"/>
</xsl:variable>
</xsl:stylesheet>
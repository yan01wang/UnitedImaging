<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
	<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
	<!ENTITY charsToEscape "'.?!,'">
	<!ENTITY charsEscaped  "'    '">
	<!ENTITY alphalist "ABCDEFGHIJKLMNOPQRSTUVWXYZ">
	<!ENTITY lngseparator "'#@#'">
	<!ENTITY sq "'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
		<!-- ============================================================== -->
  <!-- Revision History
       1/	20090107: Created - TriPane HTML file generation mechanism.
  -->
  <!-- ============================================================== -->
	<xsl:import href="../common/infoshare.params.xsl"></xsl:import>
	<xsl:import href="../common/infoshare.jobticket.xsl"></xsl:import>
	<xsl:import href="../common/infoshare.I18N.xsl"></xsl:import>
	<xsl:import href="infoshare.dita2htm.metadata.xsl"></xsl:import>
	<!-- ============================================================== -->
	<xsl:param name="WORKDIR" />
	<xsl:param name="pagename" />
  <!-- ============================================================== -->
  <!--xsl:output method="html"
            encoding="UTF-8"
            indent="yes" 
            omit-xml-declaration="yes" /-->
	<xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" />	
  <!-- ============================================================== -->
  <xsl:variable name="document-title">
		<xsl:call-template name="getJobTicketParam">
			<xsl:with-param name="varname">documenttitle</xsl:with-param>
			<xsl:with-param name="default" />
		</xsl:call-template>  
  </xsl:variable>
  <!-- ============================================================== -->
    
	<xsl:template match="/">
		<xsl:message>Tripane file creation started for: <xsl:value-of select="$pagename"/></xsl:message>
		<xsl:choose>
			<xsl:when test="($pagename='index' or $pagename='INDEX')">
				<xsl:call-template name="generate.startdocument">
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($pagename='header' or $pagename='HEADER')">
				<xsl:call-template name="generate.headerdocument">
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($pagename='search' or $pagename='SEARCH')">
				<xsl:call-template name="generate.searchdocument">
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>		
			</xsl:when>
			<xsl:when test="($pagename='searchlabels' or $pagename='SEARCHLABELS')">
				<xsl:call-template name="generate.searchlabeldocument">
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>		
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>pagename value '<xsl:value-of select="$pagename"/>' not supported.</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
  <!-- ============================================================== -->  
	<xsl:template name="generate.startdocument">
	  <xsl:param name="language"/>
	  
	  <xsl:variable name="rtl">
		  <xsl:choose>
		  	<!-- right to left / top to bottom -->
		  	<xsl:when test="$language = 'ar'">yes</xsl:when>
		  	<xsl:when test="$language = 'ar-eg'">yes</xsl:when>
		  	<xsl:when test="$language = 'he'">yes</xsl:when>
		  	<xsl:when test="$language = 'he-il'">yes</xsl:when>
		  	<!-- top to bottom / right to left -->
		
			  <!-- left to right / top to bottom -->
		    <xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>	  
	  </xsl:variable>
	  <xsl:variable name="stylesheetname">
			<xsl:choose>
				<xsl:when test="$rtl=yes">webhelplayout-rtl.css</xsl:when>
				<xsl:otherwise>webhelplayout.css</xsl:otherwise>
			</xsl:choose>  
	  </xsl:variable>
	  
    <html>
		  <head>
		    <title>SDL LiveContent Architect - <xsl:value-of select="$document-title" /></title>
		    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
		    <link rel="stylesheet" type="text/css" href="{$stylesheetname}"/>
		  </head>
			<frameset rows="80,*">
				<frame name="headerwin" src="header.html" frameborder="0" scrolling="no" marginwidth="0" marginheight="0" noresize="noresize" />
				<xsl:choose>
					<xsl:when test="$rtl=yes">			
						<frameset cols="*, 325" borderColor="#e0e0e0" frameborder="1">					
							<frame name="contentwin" src="start.html" frameborder="0" marginwidth="6" marginheight="0" borderColor="#e0e0e0" style="overflow:auto" />
							<frame name="navigationwin" src="toc.html" scrolling="auto" frameborder="0" marginwidth="0" marginheight="0"  target="contentwin" borderColor="#e0e0e0" style="overflow:auto" />							
						</frameset>					
					</xsl:when>
					<xsl:otherwise>
						<frameset cols="325,*" borderColor="#e0e0e0" frameborder="1">					
							<frame name="navigationwin" src="toc.html" scrolling="auto" frameborder="0" marginwidth="0" marginheight="0"  target="contentwin" borderColor="#e0e0e0" style="overflow:auto" />
							<frame name="contentwin" src="start.html" frameborder="0" marginwidth="6" marginheight="0" borderColor="#e0e0e0" style="overflow:auto" />
						</frameset>						
					</xsl:otherwise>
				</xsl:choose>
			</frameset>
		</html>
		
	</xsl:template>
  <!-- ============================================================== -->
	<xsl:template name="generate.splashscreen">
		<xsl:param name="language"/>
		
		<xsl:variable name="rtl">
			<xsl:choose>
				<!-- right to left / top to bottom -->
				<xsl:when test="$language = 'ar'">yes</xsl:when>
				<xsl:when test="$language = 'ar-eg'">yes</xsl:when>
				<xsl:when test="$language = 'he'">yes</xsl:when>
				<xsl:when test="$language = 'he-il'">yes</xsl:when>
				<!-- top to bottom / right to left -->
				
				<!-- left to right / top to bottom -->
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>	  
		</xsl:variable>
		<xsl:variable name="stylesheetname">
			<xsl:choose>
				<xsl:when test="$rtl=yes">webhelplayout-rtl.css</xsl:when>
				<xsl:otherwise>webhelplayout.css</xsl:otherwise>
			</xsl:choose>  
		</xsl:variable>
		
		<html>
			<head>
				<title>SDL LiveContent Architect - <xsl:value-of select="$document-title" /></title>
				<link rel="stylesheet" type="text/css" href="{$stylesheetname}"/>
			</head>
			<body>
				
			</body>
		</html>
		
	</xsl:template>
	<!-- ============================================================== -->	
	<xsl:template name="generate.searchdocument">
	  <xsl:param name="language"/>
	  
      <html>
		<head>
			<title>Search</title>
			<base target="_self" />
			<link rel="stylesheet" type="text/css" href="webhelplayout.css" />
			<link rel="stylesheet" type="text/css" href="stylesheet.css" />
			<script type="text/javascript" src="searchlabels.js" charset="UTF-8"></script>
			<script type="text/javascript" src="search.js" charset="UTF-16"></script>
			<script type="text/javascript" src="searchdata.js" charset="UTF-8"></script>
		</head>
		<body class="framelayout">
			<h1 class="heading1">
				<xsl:call-template name="getString">
					<xsl:with-param name="stringName" select="'Search'" />
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>
			</h1>
			<form action="#" onsubmit="Search(document.forms['SearchFrm'].searchcriteria.value); return false;" name="SearchFrm" id="SearchFrm" >
				<span>
				<xsl:call-template name="getString">
					<xsl:with-param name="stringName" select="'Enter search criteria:'" />
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>				
				</span><br />
				<input type="text" width="145" name="searchcriteria" />
				<input type="submit" name="searchbutton" width="50">
					<xsl:attribute name="value">
						<xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Search'" />
							<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
						</xsl:call-template>
					</xsl:attribute>				
				</input>
			</form>
			<div id="resultlist">
				<xsl:call-template name="getString">
					<xsl:with-param name="stringName" select="'No documents found'" />
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>
			</div>
		</body>
	  </html>
		
	</xsl:template>


  <!-- ============================================================== -->  
	<xsl:template name="generate.headerdocument">
	  <xsl:param name="language"/>

		<html>
			<head>
				<title>SDL LiveContent Architect - <xsl:value-of select="$document-title" /></title>
				<link rel="stylesheet" type="text/css" href="webhelplayout.css"/>
				<script language="javascript" type="text/javascript" src="docnavigation.js" charset="UTF-8"></script> 		
				<script language="javascript" type="text/javascript" src="WebhelpMenu.js"></script>
				<xsl:text disable-output-escaping="yes">&lt;!--[if gte IE 6]&gt;
   		&lt;style&gt;
   				#tabnavigation li
   				{
   					width: 79px;
   				}
   		&lt;/style&gt;
   		&lt;![endif]--&gt;</xsl:text>				
			</head>
			<body>
				<div id="headersection">
					<ul id="tabnavigation">
						<li id="content" class="current"><a href="javascript:ChangeMenu('content');"><xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Contents'" />
							<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
						</xsl:call-template></a></li>
						<li id="content-end" class="endcurrent"></li>
						<li id="index" class=""><a href="javascript:ChangeMenu('index');"><xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Index'" />
							<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
						</xsl:call-template></a></li>
						<li id="index-end" class="end"></li>
						<li id="search" class=""><a href="javascript:ChangeMenu('search');"><xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Search'" />
							<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
						</xsl:call-template></a></li>
						<li id="search-end" class="end"></li>
					</ul>
				</div>
				<div id="breadcrumbsection">
					<h1>
						<xsl:choose>
							<xsl:when test="string-length($document-title) > 0"><xsl:value-of select="$document-title" /></xsl:when>
							<xsl:otherwise>SDL LiveContent Architect - Web Help</xsl:otherwise>
						</xsl:choose>
					</h1>
					<ul id="buttons">
						<li>
							<img src="previous.png" border="0" onclick="javascript:showPrevTopic();">
								<xsl:attribute name="alt">
									<xsl:call-template name="getString">
										<xsl:with-param name="stringName" select="'Previous topic'" />
										<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:attribute name="title">
									<xsl:call-template name="getString">
										<xsl:with-param name="stringName" select="'Previous topic'" />
										<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>							
							</img>
						</li>
						<li>
							<img src="next.png" border="0" onclick="javascript:showNextTopic();">
								<xsl:attribute name="alt">
									<xsl:call-template name="getString">
										<xsl:with-param name="stringName" select="'Next topic'" />
										<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:attribute name="title">
									<xsl:call-template name="getString">
										<xsl:with-param name="stringName" select="'Next topic'" />
										<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>							
							</img>
						</li>
						<li>
							<img src="print.png" border="0" onclick="javascript:printTopic();">
								<xsl:attribute name="alt">
									<xsl:call-template name="getString">
										<xsl:with-param name="stringName" select="'Print topic'" />
										<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:attribute name="title">
									<xsl:call-template name="getString">
										<xsl:with-param name="stringName" select="'Print topic'" />
										<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>							
							</img>
						</li>
	<!--					<li>
							<img src="email.png" border="0">
								<xsl:attribute name="alt">
									<xsl:call-template name="getString">
										<xsl:with-param name="stringName" select="'Email topic'" />
										<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:attribute name="title">
									<xsl:call-template name="getString">
										<xsl:with-param name="stringName" select="'Email topic'" />
										<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
							</img>
						</li>-->
					</ul>
				</div>
			</body>
		</html>

	</xsl:template>
	
  <!-- ============================================================== -->
	<xsl:template name="generate.searchlabeldocument">
	  <xsl:param name="language"/>
	  
		var searchinglabel = "<xsl:call-template name="getString">
					<xsl:with-param name="stringName" select="'Searching'" />
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>";
		var searchtitlelabel = "<xsl:call-template name="getString">
					<xsl:with-param name="stringName" select="'Search'" />
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>";
		var searchbuttonlabel = "<xsl:call-template name="getString">
					<xsl:with-param name="stringName" select="'Search'" />
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>";
		var nodocumentsfoundlabel = "<xsl:call-template name="getString">
					<xsl:with-param name="stringName" select="'No documents found'" />
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>";
		var entersearchcriterialabel = "<xsl:call-template name="getString">
					<xsl:with-param name="stringName" select="'Enter search criteria:'" />
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>";
		var followingdocumentsfoundlabel = "<xsl:call-template name="getString">
					<xsl:with-param name="stringName" select="'Following documents found:'" />
					<xsl:with-param name="language"><xsl:call-template name="get.current.language" /></xsl:with-param>
				</xsl:call-template>";
	</xsl:template>  

</xsl:stylesheet>

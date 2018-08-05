<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fox="http://xml.apache.org/fop/extensions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions">
  <!-- ============================================================== -->
	<!-- Revision History -->
	<!-- ============================================================== -->
	<!--
       1/ Initial Version
			 2/	20100310 RS: Made functionality compliant wiht DITAMERGE 
			                 syntax (new merging mechanism)    
			 3/ 20110725 RS: Added front cover template for Notices page             
  -->
	<!-- ============================================================== -->
	<!-- setup -->
	<xsl:include href="../common/infoshare.params.xsl"/>
	<!-- ============================================================== -->
	<!-- common routines -->
	<xsl:include href="infoshare.dita2fo.diff.xsl"/>
	<xsl:include href="infoshare.dita2fo.index.xsl"/>
	<xsl:include href="infoshare.dita2fo.lof.xsl"/>
	<xsl:include href="infoshare.dita2fo.metadata.xsl"/>
	<xsl:include href="infoshare.dita2fo.report.xsl"/>
	<xsl:include href="infoshare.dita2fo.subroutines.xsl"/>
	<xsl:include href="infoshare.dita2fo.toc.xsl"/>
	<!-- ============================================================== -->
	<!-- base dita -->
	<xsl:include href="infoshare.dita2fo.calstable.xsl"/>
	<xsl:include href="infoshare.dita2fo.elems.xsl"/>
	<xsl:include href="infoshare.dita2fo.links.xsl"/>
	<xsl:include href="infoshare.dita2fo.lists.xsl"/>
	<xsl:include href="infoshare.dita2fo.simpletable.xsl"/>
	<xsl:include href="infoshare.dita2fo.titles.xsl"/>
	<!-- custom overrides -->
	<xsl:include href="infoshare.dita2fo.apiref.xsl"/>
	<xsl:include href="infoshare.dita2fo.bkinfo.xsl"/>
	<xsl:include href="infoshare.dita2fo.task.xsl"/>
	<!-- domain overrides -->
	<xsl:include href="infoshare.dita2fo.domains.xsl"/>
	<!-- ============================================================== -->
	<!-- infoshare metadata -->
	<xsl:param name="doc.version">
		<xsl:if test="$export-document-type = 'ISHPublication' and $export-document-level='lng'">
    	<xsl:call-template name="getMetadataValue">
       <xsl:with-param name="fieldname">VERSION</xsl:with-param>
       <xsl:with-param name="fieldlevel">version</xsl:with-param>
       <xsl:with-param name="default">no</xsl:with-param>
       <xsl:with-param name="document.id" select="$export-document-id"/>
    	</xsl:call-template>
 		</xsl:if>
	</xsl:param>
	<xsl:param name="doc.status">[status]</xsl:param>
	<xsl:param name="doc.date">
		<xsl:if test="$export-document-type = 'ISHPublication' and $export-document-level='lng'">
    	<xsl:call-template name="getMetadataValue">
       <xsl:with-param name="fieldname">MODIFIED-ON</xsl:with-param>
       <xsl:with-param name="fieldlevel">lng</xsl:with-param>
       <xsl:with-param name="default">no</xsl:with-param>
       <xsl:with-param name="document.id" select="$export-document-id"/>
    	</xsl:call-template>
 		</xsl:if>	
	</xsl:param>
	<!-- ============================================================== -->
	<!-- set params from template -->
	<xsl:param name="insert.coverpage">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'insert.coverpage'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="insert.toc">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'insert.toc'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="insert.index">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'insert.index'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="insert.lof">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'insert.lof'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="insert.elementlabels">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'insert.elementlabels'"/>
		</xsl:call-template>	
	</xsl:param>	
	<xsl:param name="generate.topicrefs">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'generate.topicrefs'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="toc.numbering">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'toc.numbering'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="toc.level">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'toc.level'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="toc.shortdescription">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'toc.shortdescription'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="force-page-count">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'force-page-count'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="column-count">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'column-count'"/>
		</xsl:call-template>
	</xsl:param>
  <xsl:param name="logo-height">
  	<xsl:call-template name="get.page-setup.param">
  		<xsl:with-param name="param" select="'logo-height'"/>
  	</xsl:call-template>
  </xsl:param>
	<xsl:param name="logo">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'logo'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="ruler-tickness">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'ruler-tickness'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="indent.basic">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'indent.basic'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="indent.extra">
		<xsl:call-template name="get.page-setup.param">
			<xsl:with-param name="param" select="'indent.extra'"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="documentsubtitle">User Manual</xsl:param>
	<!-- ============================================================== -->
	<!-- output method -->
	<xsl:output method="xml" version="1.0" indent="no"/>
	<!-- ============================================================== -->
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="*[contains(@class,' topic/topic ')]">
				<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions">
					<xsl:call-template name="page.setup"/>
					<xsl:call-template name="start.topic"/>
				</fo:root>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="dita">
		<xsl:call-template name="generate"/>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template match="*[contains(@class,' map/map ')]">
		<xsl:call-template name="generate"/>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="page.setup">
		<fo:layout-master-set>
			<!-- master set for chapter pages, first page is the title page -->
			<fo:page-sequence-master master-name="chapter-master">
				<fo:repeatable-page-master-alternatives>
					<!-- chapter-first-odd -->
					<fo:conditional-page-master-reference page-position="first" odd-or-even="odd" master-reference="common-page-odd"/>
					<!--chapter-first-even -->
					<fo:conditional-page-master-reference page-position="first" odd-or-even="even" master-reference="common-page-even"/>
					<!--chapter-rest-odd -->
					<fo:conditional-page-master-reference page-position="rest" odd-or-even="odd" master-reference="common-page-odd"/>
					<!--chapter-rest-even -->
					<fo:conditional-page-master-reference page-position="rest" odd-or-even="even" master-reference="common-page-even"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="toc-master">
				<fo:repeatable-page-master-alternatives>
					<!-- chapter-first-odd -->
					<fo:conditional-page-master-reference page-position="first" odd-or-even="odd" master-reference="toc-page-odd"/>
					<!--chapter-first-even -->
					<fo:conditional-page-master-reference page-position="first" odd-or-even="even" master-reference="toc-page-even"/>
					<!--chapter-rest-odd -->
					<fo:conditional-page-master-reference page-position="rest" odd-or-even="odd" master-reference="toc-page-odd"/>
					<!--chapter-rest-even -->
					<fo:conditional-page-master-reference page-position="rest" odd-or-even="even" master-reference="toc-page-even"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="index-master">
				<fo:repeatable-page-master-alternatives>
					<!--index-odd -->
					<fo:conditional-page-master-reference page-position="rest" odd-or-even="odd" master-reference="index-page-odd"/>
					<!--index-even -->
					<fo:conditional-page-master-reference page-position="rest" odd-or-even="even" master-reference="index-page-even"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:simple-page-master master-name="cover-page-odd">
				<xsl:call-template name="get.papersize"/>
				<fo:region-body region-name="region.body">
					<xsl:call-template name="get.cover.background-image"/>
				</fo:region-body> 
			</fo:simple-page-master>
			<fo:simple-page-master master-name="cover-page-even">
				<xsl:call-template name="get.papersize"/>
				<xsl:call-template name="get.margins"/>
				<fo:region-body region-name="region.body" margin-top="20pt" margin-bottom="20pt" />
			</fo:simple-page-master>
			<fo:simple-page-master master-name="common-page-odd">
				<xsl:call-template name="get.papersize"/>
				<xsl:call-template name="get.margins"/>
				<fo:region-body region-name="region.body" margin-top="20pt" margin-bottom="20pt">
					<xsl:if test="$column-count > 1">
						<xsl:attribute name="column-count"><xsl:value-of select="$column-count"/></xsl:attribute>
						<xsl:attribute name="column-gap">10mm</xsl:attribute>
					</xsl:if>
				</fo:region-body>
				<fo:region-before region-name="region.before.odd">
					<xsl:call-template name="get.header.extent"/>
				</fo:region-before>
				<fo:region-after region-name="region.after.odd">
					<xsl:call-template name="get.footer.extent"/>
				</fo:region-after>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="common-page-even">
				<xsl:call-template name="get.papersize"/>
				<xsl:call-template name="get.margins"/>
				<fo:region-body region-name="region.body" margin-top="20pt" margin-bottom="20pt">
					<xsl:if test="$column-count > 1">
						<xsl:attribute name="column-count"><xsl:value-of select="$column-count"/></xsl:attribute>
						<xsl:attribute name="column-gap">10mm</xsl:attribute>
					</xsl:if>
				</fo:region-body>
				<fo:region-before region-name="region.before.even">
					<xsl:call-template name="get.header.extent"/>
				</fo:region-before>
				<fo:region-after region-name="region.after.even">
					<xsl:call-template name="get.footer.extent"/>
				</fo:region-after>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="toc-page-odd">
				<xsl:call-template name="get.papersize"/>
				<xsl:call-template name="get.margins"/>
				<fo:region-body region-name="region.body" margin-top="20pt" margin-bottom="20pt">
					<xsl:if test="$column-count > 1">
						<xsl:attribute name="column-count"><xsl:value-of select="$column-count"/></xsl:attribute>
						<xsl:attribute name="column-gap">10mm</xsl:attribute>
					</xsl:if>
				</fo:region-body>
				<fo:region-before region-name="region.before.odd">
					<xsl:call-template name="get.header.extent"/>
				</fo:region-before>
				<fo:region-after region-name="region.after.odd">
					<xsl:call-template name="get.footer.extent"/>
				</fo:region-after>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="toc-page-even">
				<xsl:call-template name="get.papersize"/>
				<xsl:call-template name="get.margins"/>
				<fo:region-body region-name="region.body" margin-top="20pt" margin-bottom="20pt">
					<xsl:if test="$column-count > 1">
						<xsl:attribute name="column-count"><xsl:value-of select="$column-count"/></xsl:attribute>
						<xsl:attribute name="column-gap">10mm</xsl:attribute>
					</xsl:if>
				</fo:region-body>
				<fo:region-before region-name="region.before.even">
					<xsl:call-template name="get.header.extent"/>
				</fo:region-before>
				<fo:region-after region-name="region.after.even">
					<xsl:call-template name="get.footer.extent"/>
				</fo:region-after>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="index-page-odd">
				<xsl:call-template name="get.papersize"/>
				<xsl:call-template name="get.margins"/>
				<fo:region-body region-name="region.body" margin-top="20pt" margin-bottom="20pt">
					<xsl:attribute name="column-count">2</xsl:attribute>
					<xsl:attribute name="column-gap">10mm</xsl:attribute>
				</fo:region-body>
				<fo:region-before region-name="region.before.odd">
					<xsl:call-template name="get.header.extent"/>
				</fo:region-before>
				<fo:region-after region-name="region.after.odd">
					<xsl:call-template name="get.footer.extent"/>
				</fo:region-after>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="index-page-even">
				<xsl:call-template name="get.papersize"/>
				<xsl:call-template name="get.margins"/>
				<fo:region-body region-name="region.body" margin-top="20pt" margin-bottom="20pt">
					<xsl:attribute name="column-count">2</xsl:attribute>
					<xsl:attribute name="column-gap">10mm</xsl:attribute>
				</fo:region-body>
				<fo:region-before region-name="region.before.even">
					<xsl:call-template name="get.header.extent"/>
				</fo:region-before>
				<fo:region-after region-name="region.after.even">
					<xsl:call-template name="get.footer.extent"/>
				</fo:region-after>
			</fo:simple-page-master>
		</fo:layout-master-set>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="insert.coverpage">
		<!-- generate an "outside front cover" page (right side) (sheet 1) -->
		<xsl:if test="$insert.coverpage = 'yes'">
			<xsl:variable name="current-language"><xsl:call-template name="get.current.language"/></xsl:variable>
			<fo:page-sequence master-reference="cover-page-odd">
				<fo:flow flow-name="region.body">
					<fo:block-container>
						<xsl:call-template name="add.writing-mode">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<!-- set the title -->
						<fo:block>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'cover.title'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
							<xsl:call-template name="getJobTicketParam">
								<xsl:with-param name="varname">documenttitle</xsl:with-param>
								<xsl:with-param name="default">publication</xsl:with-param>
								<xsl:with-param name="document" select="."/>
							</xsl:call-template>
						</fo:block>
					</fo:block-container>						
						<!-- set the version number -->
  					<xsl:if test="string-length($doc.version) > 0">
	  					<fo:block-container>
	  						<xsl:call-template name="add.style">
	  							<xsl:with-param name="style" select="'doc.metadata.location'" />
	  							<xsl:with-param name="language" select="$current-language" />
	  						</xsl:call-template>
	      				  <fo:block>
									<xsl:call-template name="add.style">
										<xsl:with-param name="style" select="'doc.metadata'"/>
										<xsl:with-param name="language" select="$current-language"/>
									</xsl:call-template>
	      					version <xsl:apply-templates select="$doc.version"/>
	      				  <fo:block>Printed on <xsl:value-of select="$doc.date"/></fo:block>
	      				  </fo:block>
	  					</fo:block-container>
  					</xsl:if>
						<!-- set the status -->
						<!--
  					<xsl:if test="string-length($doc.status) > 0">
    					<fo:block text-align="right" font-size="8pt" font-weight="bold" line-height="100%">
    						<xsl:value-of select="$doc.status"/>
    					</fo:block>
  					</xsl:if>
  					-->
						<!-- set the build date -->
<!--  					<xsl:if test="string-length($doc.date) > 0">
    					<fo:block>
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'doc.metadata'"/>
									<xsl:with-param name="language" select="$current-language"/>
								</xsl:call-template>
    						Printed on <xsl:value-of select="$doc.date"/>
    					</fo:block>
  					</xsl:if>-->
						<!-- // cover -->

				</fo:flow>
			</fo:page-sequence>
			<!-- generate an "inside front cover" page (left side) (sheet 2) -->
			<fo:page-sequence master-reference="cover-page-even">
				<fo:flow flow-name="region.body">
					<fo:block-container>
						<xsl:call-template name="add.writing-mode">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<xsl:choose>
							<xsl:when test="count(//*[contains(@class,' topic/topic ') and @outputclass='inside-front-cover']) > 0">
							   <xsl:apply-templates select="//*[contains(@class,' topic/topic ') and @outputclass='inside-front-cover']"/>
							</xsl:when>
							<xsl:otherwise>
								<fo:block/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block-container>
				</fo:flow>
			</fo:page-sequence>
		</xsl:if>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="insert.toc">
		<xsl:if test="$insert.toc = 'yes'">
			<xsl:variable name="current-language">
				<xsl:call-template name="get.current.language"/>
			</xsl:variable>
			<fo:page-sequence master-reference="toc-master" format="i" initial-page-number="1">
				<xsl:if test="string-length($force-page-count) > 0">
					<xsl:attribute name="force-page-count"><xsl:value-of select="$force-page-count"/></xsl:attribute>
				</xsl:if>
				<!-- header -->
				<fo:static-content flow-name="region.before.odd">
					<fo:block-container>
						<xsl:call-template name="add.writing-mode">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<!--xsl:message>writing mode called with: <xsl:value-of select="$current-language"/></xsl:message-->
						<fo:block>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'header.odd'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
							<fo:page-number/>
						</fo:block>
					</fo:block-container>
				</fo:static-content>
				<fo:static-content flow-name="region.before.even">
					<fo:block-container>
						<xsl:call-template name="add.writing-mode">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<fo:block>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'header.even'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
							<fo:page-number/>
						</fo:block>
					</fo:block-container>
				</fo:static-content>
				<!-- // header section -->
				<!-- footer -->
				<fo:static-content flow-name="region.after.odd">
					<fo:block-container>
						<xsl:call-template name="add.writing-mode">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<fo:block>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'footer.odd'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
              <xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
								<xsl:call-template name="insert.watermark"/>
							</xsl:if>
							<xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'Contents'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
						</fo:block>
					</fo:block-container>
				</fo:static-content>
				<fo:static-content flow-name="region.after.even">
					<fo:block-container>
						<xsl:call-template name="add.writing-mode">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<fo:block>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'footer.even'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
                     <xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
                        <xsl:call-template name="insert.watermark">
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'Contents'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
						</fo:block>
					</fo:block-container>
				</fo:static-content>
				<!-- // footer section -->
				<!-- flow section -->
				<fo:flow flow-name="region.body">
					<!--<fo:block-container>-->
						<!--xsl:message>writing mode called with: <xsl:value-of select="$current-language"/></xsl:message-->
						<fo:block span="all">
  						<xsl:call-template name="add.writing-mode">
  							<xsl:with-param name="language" select="$current-language"/>
  						</xsl:call-template>						
							<fo:block axf:outline-level="1" axf:outline-expand="false">
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'toctitle'"/>
									<xsl:with-param name="language" select="$current-language"/>
								</xsl:call-template>
								<xsl:call-template name="getString">
									<xsl:with-param name="stringName" select="'Contents'"/>
									<xsl:with-param name="language" select="$current-language"/>
								</xsl:call-template>
							</fo:block>
							<fo:leader color="black" leader-pattern="rule" rule-thickness="5pt" leader-length="100%"/>
						</fo:block>
						<xsl:call-template name="generate.toc">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
					<!--</fo:block-container>-->
				</fo:flow>
				<!-- // flow section -->
			</fo:page-sequence>
		</xsl:if>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="insert.report">
		<xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
			<xsl:variable name="current-language">
				<xsl:call-template name="get.current.language"/>
			</xsl:variable>
			<fo:page-sequence master-reference="toc-master" format="i" initial-page-number="1">
				<xsl:if test="string-length($force-page-count) > 0">
					<xsl:attribute name="force-page-count"><xsl:value-of select="$force-page-count"/></xsl:attribute>
				</xsl:if>
				<!-- header -->
				<fo:static-content flow-name="region.before.odd">
					<fo:block-container>
						<xsl:call-template name="add.writing-mode">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<fo:block>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'header.odd'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
							<fo:page-number/>
						</fo:block>
					</fo:block-container>
				</fo:static-content>
				<fo:static-content flow-name="region.before.even">
					<fo:block-container>
						<xsl:call-template name="add.writing-mode">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<fo:block>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'header.even'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
							<fo:page-number/>
						</fo:block>
					</fo:block-container>
				</fo:static-content>
				<!-- // header section -->
				<!-- footer -->
				<fo:static-content flow-name="region.after.odd">
					<fo:block-container>
						<xsl:call-template name="add.writing-mode">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<fo:block>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'footer.odd'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
                     <xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
                        <xsl:call-template name="insert.watermark">
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'Contents'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
						</fo:block>
					</fo:block-container>
				</fo:static-content>
				<fo:static-content flow-name="region.after.even">
					<fo:block-container>
						<xsl:call-template name="add.writing-mode">
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<fo:block>
							<xsl:call-template name="add.style">
								<xsl:with-param name="style" select="'footer.even'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
                     <xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
                        <xsl:call-template name="insert.watermark">
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'Contents'"/>
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
						</fo:block>
					</fo:block-container>
				</fo:static-content>
				<!-- // footer section -->
				<!-- flow section -->
				<fo:flow flow-name="region.body">
					<!--<fo:block-container>-->
						<fo:block span="all">
  						<xsl:call-template name="add.writing-mode">
  							<xsl:with-param name="language" select="$current-language"/>
  						</xsl:call-template>
							<!--<fo:block axf:outline-level="1" axf:outline-expand="false">-->
							<fo:block axf:outline-expand="false">
							  <xsl:attribute name="axf:outline-level">
							    <xsl:choose>
							      <xsl:when test="$multilingual='yes'">2</xsl:when>
							      <xsl:otherwise>1</xsl:otherwise>
							    </xsl:choose>
							  </xsl:attribute>							
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'toctitle'"/>
									<xsl:with-param name="language" select="$current-language"/>
								</xsl:call-template>
								<xsl:text>Report</xsl:text>
								<!--
  				  		<xsl:call-template name="getString">
  			          <xsl:with-param name="stringName" select="'Report'"/>
  	            </xsl:call-template>
  	            -->
							</fo:block>
							<fo:leader color="black" leader-pattern="rule" rule-thickness="5pt" leader-length="100%"/>
						</fo:block>
						<xsl:call-template name="generate.report"/>
					<!--</fo:block-container>-->
				</fo:flow>
				<!-- // flow section -->
			</fo:page-sequence>
		</xsl:if>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="insert.index">
		<xsl:param name="node"/>
		<xsl:variable name="current-language">
			<xsl:call-template name="get.current.language"/>
		</xsl:variable>
		<xsl:message>In insert.index with following params: insert.index:<xsl:value-of select="$insert.index"/> - multilingual: <xsl:value-of select="$multilingual"/> - currentLanguage: <xsl:value-of select="$current-language"/></xsl:message>
		<xsl:if test="$insert.index = 'yes'">
			<!--xsl:message>Create index for Multilingual publication</xsl:message-->
			<xsl:if test="//*[contains(@class, ' topic/indexterm ')]">
				<fo:page-sequence master-reference="index-master" format="1" initial-page-number="auto">
					<xsl:if test="string-length($force-page-count) > 0">
						<xsl:attribute name="force-page-count"><xsl:value-of select="$force-page-count"/></xsl:attribute>
					</xsl:if>
					<!-- header -->
					<fo:static-content flow-name="region.before.odd">
						<fo:block-container>
							<xsl:call-template name="add.writing-mode">
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
							<fo:block>
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'header.odd'"/>
									<xsl:with-param name="language" select="$current-language"/>
								</xsl:call-template>
								<fo:page-number/>
							</fo:block>
						</fo:block-container>
					</fo:static-content>
					<fo:static-content flow-name="region.before.even">
						<fo:block-container>
							<xsl:call-template name="add.writing-mode">
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
							<fo:block>
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'header.even'"/>
									<xsl:with-param name="language" select="$current-language"/>
								</xsl:call-template>
								<fo:page-number/>
							</fo:block>
						</fo:block-container>
					</fo:static-content>
					<!-- // header section -->
					<!-- footer -->
					<fo:static-content flow-name="region.after.odd">
						<fo:block-container>
							<xsl:call-template name="add.writing-mode">
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
							<fo:block>
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'footer.odd'"/>
									<xsl:with-param name="language" select="$current-language"/>
								</xsl:call-template>
                        <xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
                           <xsl:call-template name="insert.watermark">
                           </xsl:call-template>
                        </xsl:if>
                        <xsl:call-template name="getString">
									<xsl:with-param name="stringName" select="'Index'"/>
									<xsl:with-param name="language" select="$current-language"/>
								</xsl:call-template>
							</fo:block>
						</fo:block-container>
					</fo:static-content>
					<fo:static-content flow-name="region.after.even">
						<fo:block-container>
							<xsl:call-template name="add.writing-mode">
								<xsl:with-param name="language" select="$current-language"/>
							</xsl:call-template>
							<fo:block>
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'footer.even'"/>
									<xsl:with-param name="language" select="$current-language"/>
								</xsl:call-template>
                        <xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
                           <xsl:call-template name="insert.watermark">
                           </xsl:call-template>
                        </xsl:if>
                        <xsl:call-template name="getString">
									<xsl:with-param name="stringName" select="'Index'"/>
									<xsl:with-param name="language" select="$current-language"/>
								</xsl:call-template>
							</fo:block>
						</fo:block-container>
					</fo:static-content>
					<!-- // footer section -->
					<!-- flow section -  title info spanning complete page  -->
					<fo:flow flow-name="region.body">
						<!--<fo:block-container>-->
							<fo:block span="all">
  							<xsl:call-template name="add.writing-mode">
  								<xsl:with-param name="language" select="$current-language"/>
  							</xsl:call-template>
								<!--<fo:block axf:outline-level="2" axf:outline-expand="false">-->
								<fo:block axf:outline-expand="false" span="all">
								  <xsl:attribute name="axf:outline-level">
								    <xsl:choose>
								      <xsl:when test="$multilingual='yes'">2</xsl:when>
								      <xsl:otherwise>1</xsl:otherwise>
								    </xsl:choose>
								  </xsl:attribute>								
									<xsl:call-template name="add.style">
										<xsl:with-param name="style" select="'toctitle'"/>
										<xsl:with-param name="language" select="$current-language"/>
									</xsl:call-template>
									<xsl:call-template name="getString">
										<xsl:with-param name="stringName" select="'Index'"/>
										<xsl:with-param name="language" select="$current-language"/>
									</xsl:call-template>
								</fo:block>
								<fo:leader color="black" leader-pattern="rule" rule-thickness="5pt" leader-length="100%"/>
							</fo:block>
							<xsl:message>Call generate.index starting from "<xsl:value-of select="name($node)"/>"</xsl:message>
							<xsl:call-template name="generate.index">
        	      <xsl:with-param name="language" select="$current-language" />
        	    </xsl:call-template>
						<!--</fo:block-container>-->
					</fo:flow>
					<!-- // flow section -->
				</fo:page-sequence>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="insert.lof">
		<xsl:variable name="language">
			<xsl:call-template name="get.current.language"/>
		</xsl:variable>
		<xsl:if test="$insert.lof = 'yes'">
			<xsl:if test="//*[contains(@class, ' topic/image ')]">
				<fo:page-sequence master-reference="index-master" format="1" initial-page-number="auto">
					<xsl:if test="string-length($force-page-count) > 0">
						<xsl:attribute name="force-page-count"><xsl:value-of select="$force-page-count"/></xsl:attribute>
					</xsl:if>
					<!-- header -->
					<fo:static-content flow-name="region.before.odd">
						<fo:block-container>
							<xsl:call-template name="add.writing-mode">
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
							<fo:block>
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'header.odd'"/>
									<xsl:with-param name="language" select="$language"/>
								</xsl:call-template>
								<fo:page-number/>
							</fo:block>
						</fo:block-container>
					</fo:static-content>
					<fo:static-content flow-name="region.before.even">
						<fo:block-container>
							<xsl:call-template name="add.writing-mode">
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
							<fo:block>
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'header.even'"/>
									<xsl:with-param name="language" select="$language"/>
								</xsl:call-template>
								<fo:page-number/>
							</fo:block>
						</fo:block-container>
					</fo:static-content>
					<!-- // header section -->
					<!-- footer -->
					<fo:static-content flow-name="region.after.odd">
						<fo:block-container>
							<xsl:call-template name="add.writing-mode">
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
							<fo:block>
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'footer.odd'"/>
									<xsl:with-param name="language" select="$language"/>
								</xsl:call-template>
                        <xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
                           <xsl:call-template name="insert.watermark">
                           </xsl:call-template>
                        </xsl:if>
                        <xsl:call-template name="getString">
									<xsl:with-param name="stringName" select="'List of Figures'"/>
									<xsl:with-param name="language" select="$language"/>
								</xsl:call-template>
							</fo:block>
						</fo:block-container>
					</fo:static-content>
					<fo:static-content flow-name="region.after.even">
						<fo:block-container>
							<xsl:call-template name="add.writing-mode">
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
							<fo:block>
								<xsl:call-template name="add.style">
									<xsl:with-param name="style" select="'footer.even'"/>
									<xsl:with-param name="language" select="$language"/>
								</xsl:call-template>
                        <xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
                           <xsl:call-template name="insert.watermark">
                           </xsl:call-template>
                        </xsl:if>
                        <xsl:call-template name="getString">
									<xsl:with-param name="stringName" select="'List of Figures'"/>
									<xsl:with-param name="language" select="$language"/>
								</xsl:call-template>
							</fo:block>
						</fo:block-container>
					</fo:static-content>
					<!-- // footer section -->
					<!-- flow section -  title info spanning complete page  -->
					<fo:flow flow-name="region.body">
						<!--<fo:block-container>-->
							<fo:block span="all">
  							<xsl:call-template name="add.writing-mode">
  								<xsl:with-param name="language" select="$language"/>
  							</xsl:call-template>
								<!--<fo:block axf:outline-level="1" axf:outline-expand="false">-->
								<fo:block axf:outline-expand="false" span="all">
								  <xsl:attribute name="axf:outline-level">
								    <xsl:choose>
								      <xsl:when test="$multilingual='yes'">2</xsl:when>
								      <xsl:otherwise>1</xsl:otherwise>
								    </xsl:choose>
								  </xsl:attribute>									
									<xsl:call-template name="add.style">
										<xsl:with-param name="style" select="'toctitle'"/>
                    <xsl:with-param name="language" select="$language"/>
									</xsl:call-template>
									<xsl:call-template name="getString">
										<xsl:with-param name="stringName" select="'List of Figures'"/>
									</xsl:call-template>
								</fo:block>
								<fo:leader color="black" leader-pattern="rule" rule-thickness="5pt" leader-length="100%"/>
							</fo:block>
							<xsl:call-template name="generate.lof">
								<xsl:with-param name="language" select="$language"/>
							</xsl:call-template>
						<!--</fo:block-container>-->
					</fo:flow>
					<!-- // flow section -->
				</fo:page-sequence>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="insert.chapters">
<xsl:variable name="current-language">
			<xsl:call-template name="get.current.language"/>
		</xsl:variable>
		<!--xsl:message>Insert Chapter started with language: <xsl:value-of select="$current-language"/></xsl:message-->
		<fo:page-sequence master-reference="chapter-master" format="1" initial-page-number="auto">
			<xsl:if test="string-length($force-page-count) > 0">
				<xsl:attribute name="force-page-count"><xsl:value-of select="$force-page-count"/></xsl:attribute>
			</xsl:if>
			<!-- header -->
			<fo:static-content flow-name="region.before.odd">
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$current-language"/>
					</xsl:call-template>
					<fo:block>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'header.odd'"/>
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<fo:page-number/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<fo:static-content flow-name="region.before.even">
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$current-language"/>
					</xsl:call-template>
					<fo:block>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'header.even'"/>
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
						<fo:page-number/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<!-- // header -->
			<!-- footnotes -->
			<fo:static-content flow-name="xsl-footnote-separator">
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$current-language"/>
					</xsl:call-template>
					<fo:block>
						<fo:leader leader-length="100%" leader-pattern="rule"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<!-- //footnotes -->
			<!-- footer -->
			<fo:static-content flow-name="region.after.odd">
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$current-language"/>
					</xsl:call-template>
					<fo:block>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'footer.odd'"/>
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
                  <xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
                     <xsl:call-template name="insert.watermark">
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:value-of select="title"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<fo:static-content flow-name="region.after.even">
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$current-language"/>
					</xsl:call-template>
					<fo:block>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'footer.even'"/>
							<xsl:with-param name="language" select="$current-language"/>
						</xsl:call-template>
                  <xsl:if test="translate($watermark, 'YES', 'yes')='yes'">
                     <xsl:call-template name="insert.watermark">
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:value-of select="title"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<!-- // footer -->
			<!-- flow section -->
			<fo:flow flow-name="region.body">

<!--    		<xsl:for-each select="*[contains(@refclass, ' map/topicref ') or contains(@class, ' map/topicref ')]"> -->
    		<xsl:for-each select="*[contains(@class, ' topic/topic ') and not(@outputclass='inside-front-cover')]">
    			<xsl:call-template name="insert.chapter">
    				<xsl:with-param name="node" select="."/>
    			</xsl:call-template>
    			<xsl:if test="$multilingual = 'yes'">
    				<xsl:call-template name="insert.index">
    					<xsl:with-param name="node" select="."/>
    				</xsl:call-template>
    			</xsl:if>
    		</xsl:for-each>

			</fo:flow>
			<!-- // flow section -->
		</fo:page-sequence>		
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="insert.chapter">
		<xsl:param name="node"/>
<!--			
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$current-language"/>
					</xsl:call-template>
					<fo:block break-before="page"> -->
  			<xsl:if test="$multilingual = 'yes'">
  				<fo:block>
  					<xsl:call-template name="add.style">
  						<xsl:with-param name="style" select="'chapter.break-before'"/>
              <xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
  					</xsl:call-template>
  				</fo:block>
  			</xsl:if>					
        <xsl:apply-templates select="$node"/>
<!--					</fo:block>
				</fo:block-container>-->

	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="insert.bookmarks.fop">
		<xsl:for-each select="*[contains(@class,' topic/topic ')]">
			<fox:outline internal-destination="{generate-id()}">
				<fox:label>
					<xsl:value-of select="*[contains(@class,' topic/title ')]"/>
				</fox:label>
				<xsl:call-template name="insert.bookmarks.fop"/>
			</fox:outline>
		</xsl:for-each>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="insert.documentinfo">
    <axf:document-info name="title" value="SDL LiveContent Architect" />
    <axf:document-info name="subject">
      <xsl:attribute name="value">
        <xsl:choose>
				  <xsl:when test="string-length(/*[contains(@class,' map/map ')]/@title) > 0">
					  <xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
					</xsl:when>
					<xsl:when test="string-length(//*[contains(@class,' topic/topic ')]/*[contains(@class, ' topic/title ')][1])">
					  <xsl:value-of select="//*[contains(@class,' topic/topic ')]/*[contains(@class, ' topic/title ')][1]" />
					</xsl:when>
					<xsl:otherwise>
					  [title missing]
					</xsl:otherwise>
				</xsl:choose>
      </xsl:attribute>
    </axf:document-info>
    <axf:document-info name="author" value="SDL LiveContent Architect" />
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="insert.watermark">
      <fo:block-container>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'draft-watermark'"/>
				<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
			</xsl:call-template>
         <fo:block>
            <xsl:text>This is a DRAFT publication intended for internal use only</xsl:text>
         </fo:block>
      </fo:block-container>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="start.topic">
		<fo:page-sequence master-reference="chapter-master" format="1" initial-page-number="auto">
			<xsl:if test="string-length($force-page-count) > 0">
				<xsl:attribute name="force-page-count"><xsl:value-of select="$force-page-count"/></xsl:attribute>
			</xsl:if>
			<!-- header -->
			<fo:static-content flow-name="region.before.odd">
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$language"/>
					</xsl:call-template>
					<fo:block>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'header.odd'"/>
							<xsl:with-param name="language" select="$language"/>
						</xsl:call-template>
						<fo:page-number/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<fo:static-content flow-name="region.before.even">
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$language"/>
					</xsl:call-template>
					<fo:block>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'header.even'"/>
							<xsl:with-param name="language" select="$language"/>
						</xsl:call-template>
						<fo:page-number/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<!-- // header -->
			<!-- footer -->
			<fo:static-content flow-name="region.after.odd">
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$language"/>
					</xsl:call-template>
					<fo:block>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'footer.odd'"/>
							<xsl:with-param name="language" select="$language"/>
						</xsl:call-template>
						<xsl:value-of select="/*/*[contains(@class,' topic/title')]"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<fo:static-content flow-name="region.after.even">
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$language"/>
					</xsl:call-template>
					<fo:block>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="'footer.even'"/>
							<xsl:with-param name="language" select="$language"/>
						</xsl:call-template>
						<xsl:value-of select="/*/*[contains(@class,' topic/title')]"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<!-- // footer -->
			<!-- flow section -->
			<fo:flow flow-name="region.body">
				<fo:block-container>
					<xsl:call-template name="add.writing-mode">
						<xsl:with-param name="language" select="$language"/>
					</xsl:call-template>
					<fo:block break-before="page">
						<xsl:apply-templates select="/*"/>
					</fo:block>
				</fo:block-container>
			</fo:flow>
			<!-- // flow section -->
		</fo:page-sequence>
	</xsl:template>
	<!-- ============================================================== -->
</xsl:stylesheet>

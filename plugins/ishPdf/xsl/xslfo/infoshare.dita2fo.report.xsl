<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
  <!-- ============================================================== -->
  <!-- Revision History
       1/ 20050927: Extracted functionality from infoshare.dita2fo.shell.xsl
  -->
	<!-- ============================================================== -->
	<xsl:template name="generate.report">
    <fo:table table-layout="fixed" border-color="black" border-style="solid" border-width="thin" font-family="Arial">
			<fo:table-column column-width="50%"/>
			<fo:table-column column-width="50%"/>
			<fo:table-body>
  		  <fo:table-row>
  				<fo:table-cell>
  					<fo:block font-weight="bold" start-indent="2pt">Identifier</fo:block>
  				</fo:table-cell>
  				<fo:table-cell>
  					<fo:block font-weight="bold" start-indent="2pt">Title</fo:block>
  				</fo:table-cell>
  		  </fo:table-row>
    	  <xsl:for-each select="document($url.report)/export-report/object-report">
					<fo:table-row>
						<fo:table-cell>
							<fo:block start-indent="2pt"><xsl:value-of select="@ishref"/></fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block start-indent="2pt"><xsl:value-of select="document(concat($WORKDIR,'/', @ishref, $ext.metadata))//ishfield[@name='FTITLE']"/></fo:block>
						</fo:table-cell>
          </fo:table-row>
    	  </xsl:for-each>
      </fo:table-body>
    </fo:table>
	</xsl:template>
	<!-- ============================================================== -->
</xsl:stylesheet>

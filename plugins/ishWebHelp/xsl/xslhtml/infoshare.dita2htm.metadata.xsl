<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
	<!-- ============================================================== -->
	<!-- Revision History -->
	<!-- ============================================================== -->
	<!--
       1/ Initial version
       2/ 20070813: Added span-style to metadata block in order to have
                    metadata table using complete pagewidth.
       3/ 20071108: EM/RS: added template to retrieve value of specific metadata field.
  -->
	<!-- ============================================================== -->
<!--
	<xsl:template match="ishfield">
		<xsl:apply-templates/>
	</xsl:template>
-->
	<!-- ============================================================== -->
<!--
	<xsl:template name="insert.summary">
	  <xsl:variable name="summary.id">
	    <xsl:choose>
	      <xsl:when test="$multilingual = 'yes'">
	        <xsl:value-of select="concat(ancestor-or-self::*/@xml:lang,'/',substring-after(@id,concat(ancestor-or-self::*/@xml:lang,'-')))"/>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="@id"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
    <xsl:if test="translate($show-metadata,'YES','yes') = 'yes'">
      < ! - - xsl:message>Processing metadata for with following parameters: summary.id: <xsl:value-of select="$summary.id" /> | @id: <xsl:value-of select="parent::*/@id"/> | of element: <xsl:value-of select="name(parent::*)"/></xsl:message - - >
    	<fo:block font-size="8pt" keep-with-next.within-column='always'>
  			<xsl:call-template name="add.style">
  				<xsl:with-param name="style" select="'span'"/>
  			</xsl:call-template> 
        <fo:table table-layout="fixed" border-color="black" border-style="solid" border-width="thin">
  				<fo:table-column column-width="25%"/>
  				<fo:table-column column-width="75%"/>
  				<fo:table-body>
               <fo:table-row keep-with-next.within-column='always' keep-with-previous.within-column='always'>
                  <fo:table-cell>
                     <fo:block start-indent="2pt">Title</fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                     <fo:block start-indent="2pt">
                        <xsl:apply-templates select="document(concat('file:///',$WORKDIR, '/', $summary.id, $ext.metadata),/)//ishfield[@name='FTITLE']"/>
                     </fo:block>
                  </fo:table-cell>
               </fo:table-row>
               <fo:table-row keep-with-next.within-column='always' keep-with-previous.within-column='always'>
                  <fo:table-cell>
                     <fo:block start-indent="2pt">Identifier</fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                     <xsl:choose>
                        <xsl:when test="$multilingual = 'yes'">
                           <fo:block start-indent="2pt">
                              <xsl:value-of select="substring-after($summary.id,'/')" />
                           </fo:block>
                        </xsl:when>
                        <xsl:otherwise>
                           <fo:block start-indent="2pt">
                              <xsl:value-of select="$summary.id" />
                           </fo:block>
                        </xsl:otherwise>
                     </xsl:choose>
                  </fo:table-cell>
               </fo:table-row>
               <fo:table-row keep-with-next.within-column='always' keep-with-previous.within-column='always'>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">Description</fo:block>
  						</fo:table-cell>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">
  							  <xsl:apply-templates select="document(concat('file:///',$WORKDIR, '/', $summary.id, $ext.metadata),/)//ishfield[@name='FDESCRIPTION']"/>
  							</fo:block>
  						</fo:table-cell>
            </fo:table-row>
  					<fo:table-row keep-with-next.within-column='always' keep-with-previous.within-column='always'>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">Language</fo:block>
  						</fo:table-cell>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">
  							  <xsl:apply-templates select="document(concat('file:///',$WORKDIR, '/', $summary.id, $ext.metadata))//ishfield[@name='DOC-LANGUAGE']"/>
  							</fo:block>
  						</fo:table-cell>
  					</fo:table-row>          
  					<fo:table-row keep-with-next.within-column='always' keep-with-previous.within-column='always'>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">Version</fo:block>
  						</fo:table-cell>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">
  							  <xsl:apply-templates select="document(concat('file:///',$WORKDIR, '/', $summary.id, $ext.metadata))//ishfield[@name='VERSION']"/>
  							</fo:block>
  						</fo:table-cell>
  					</fo:table-row>
  					<fo:table-row keep-with-next.within-column='always' keep-with-previous.within-column='always'>
  					  <fo:table-cell>
  					    <fo:block start-indent="2pt">Revision</fo:block>
  					  </fo:table-cell>
  					  <fo:table-cell>
  					    <fo:block start-indent="2pt">
  							<xsl:apply-templates select="document(concat('file:///',$WORKDIR, '/', $summary.id, $ext.metadata),/)//ishfield[@name='FISHREVCOUNTER']"/>
  							</fo:block>
  						</fo:table-cell>
            </fo:table-row>
  					<fo:table-row keep-with-next.within-column='always' keep-with-previous.within-column='always'>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">Changes</fo:block>
  						</fo:table-cell>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">
  							  <xsl:apply-templates select="document(concat('file:///',$WORKDIR, '/', $summary.id, $ext.metadata))//ishfield[@name='FCHANGES']"/>
  							</fo:block>
  						</fo:table-cell>
            </fo:table-row>
  					<fo:table-row keep-with-next.within-column='always' keep-with-previous.within-column='always'>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">Status</fo:block>
  						</fo:table-cell>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">
  							  <xsl:apply-templates select="document(concat('file:///',$WORKDIR, '/', $summary.id, $ext.metadata),/)//ishfield[@name='FSTATUS']"/>
  							</fo:block>
  						</fo:table-cell>
            </fo:table-row>
  					<fo:table-row keep-with-next.within-column='always' keep-with-previous.within-column='always'>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">Last modified on</fo:block>
  						</fo:table-cell>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">
  							  <xsl:apply-templates select="document(concat('file:///',$WORKDIR, '/', $summary.id, $ext.metadata),/)//ishfield[@name='MODIFIED-ON']"/>
  							</fo:block>
  						</fo:table-cell>
            </fo:table-row>
  					<fo:table-row keep-with-next.within-column='always' keep-with-previous.within-column='always'>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">Author</fo:block>
  						</fo:table-cell>
  						<fo:table-cell>
  							<fo:block start-indent="2pt">
  							  <xsl:apply-templates select="document(concat('file:///',$WORKDIR, '/', $summary.id, $ext.metadata),/)//ishfield[@name='FAUTHOR']"/>
  							</fo:block>
  						</fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>            
      </fo:block>
    </xsl:if>
	</xsl:template>
-->
	<!-- ============================================================== -->
   <xsl:template name="getMetadataValue">
      <xsl:param name="document.id" />
      <xsl:param name="fieldname" />
      <xsl:param name="fieldlevel" />
      <xsl:param name="default" />
      <xsl:choose>
         <xsl:when test="document(concat('file:///',$WORKDIR, '/', $document.id, $ext.metadata),/)//ishfield[@name=$fieldname and @level=$fieldlevel]">
            <xsl:value-of select="document(concat('file:///',$WORKDIR, '/', $document.id, $ext.metadata),/)//ishfield[@name=$fieldname and @level=$fieldlevel]"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$default"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
      <!-- ============================================================== -->
</xsl:stylesheet>

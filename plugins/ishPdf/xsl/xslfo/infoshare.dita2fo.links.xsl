<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version='1.1'>
	<!-- ============================================================== -->
	<!-- Revision History -->
	<!-- ============================================================== -->
	<!--
       1/ 20080520: Related links enabled for PDF output 
  -->
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' topic/related-links ')]">
  	<xsl:if test="count(.//*[contains(@class,' topic/link ')][not(@href = '') and @scope='external']) > 0">
  		<!-- Only print generated 'Related Information' title incase there external related links -->
	    <fo:block>
	  			<xsl:call-template name="add.style">
	  				<xsl:with-param name="style" select="'blocklabel'"/>
	  				<xsl:with-param name="language" select="$language"/>
	  			</xsl:call-template>		
	  			<xsl:call-template name="getString">
	  				<xsl:with-param name="stringName" select="'Related information'"/>
	  				<xsl:with-param name="language" select="$language"/>
	  			</xsl:call-template>
			</fo:block>
			
		</xsl:if>
		
		<!-- Render links -->
		<xsl:apply-templates />
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' topic/linklist ')]/*[contains(@class,' topic/title ')]">
    <fo:block font-weight="bold">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' topic/linklist ')]">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' topic/linkpool ')]">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' topic/linktext ')]">
    <fo:inline>
      <!-- TODO make literal -->
      <xsl:apply-templates/> (see page <fo:page-number-citation ref-id="{../@href}"/>)
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
  <xsl:template match="*[contains(@class,' topic/linktext ')]" mode="external">
    <fo:inline>
      <!-- TODO make literal -->
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>  
  <!-- ============================================================== -->
  <!-- rule for when the link is still not pointing at anything -->
  <xsl:template match="*[contains(@class,' topic/link ')][@href = '']">
    <fo:block>
      <xsl:text>&#x2022; </xsl:text>
      <fo:inline color="red">
				<xsl:call-template name="add.style">
					<xsl:with-param name="style" select="'hyperlink'"/>
					<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="add.style">
					<xsl:with-param name="style" select="'block'"/>
					<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
				</xsl:call-template>
        <xsl:apply-templates/>
      </fo:inline>
    </fo:block>
  </xsl:template>
  <!-- ============================================================== -->    
  <xsl:template match="*[contains(@class,' topic/link ')][not(@href = '') and not(@scope='external')]" />
  <!-- ============================================================== -->  
  <xsl:template match="*[contains(@class,' topic/link ')][not(@href = '') and @scope='external']">
		<fo:block>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'hyperlink'"/>
				<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="add.style">
				<xsl:with-param name="style" select="'block'"/>
				<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
			</xsl:call-template>	
			<xsl:call-template name="add.changebars">
				<xsl:with-param name="node" select="."/>
				<xsl:with-param name="type" select="'begin'"/>
				<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
				<xsl:with-param name="placement" select="'break'"/>
			</xsl:call-template>			
			<xsl:choose>
				<xsl:when test="@scope = 'external'">
					<xsl:apply-templates mode="external" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="add.changebars">
				<xsl:with-param name="node" select="."/>
				<xsl:with-param name="type" select="'end'"/>
				<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
				<xsl:with-param name="placement" select="'break'"/>
			</xsl:call-template>			
		</fo:block>
	<!--
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()" text-align="end">
				<fo:block>
					<xsl:call-template name="add.style">
						<xsl:with-param name="style" select="'block'"/>
						<xsl:with-param name="language"><xsl:call-template name="get.current.language"/></xsl:with-param>
					</xsl:call-template>
					<fo:inline>&#x2022;</fo:inline>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
          <xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
		-->
  </xsl:template>
  <!-- ============================================================== -->  
  <!-- Rule for when the xref is still not pointing at anything       -->
  <xsl:template match="*[contains(@class,' topic/xref ')][@href = '']">
    <fo:inline color="red">
      <fo:inline font-weight="bold">[xref to: <xsl:value-of select="@href"/>]</fo:inline>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->  
  <xsl:template match="*[contains(@class,' topic/xref ')][not(@href = '')]">
    <fo:inline color="blue">
      <xsl:choose>
        <!-- If the format attribute is dita, or is unspecified, then interpret the href as a topic -->
        <!-- Create an internal hyperlink to the topic -->
        <xsl:when test="@format='dita' or @format='DITA' or not(@format)">
          <fo:basic-link>
            <!-- Set the destination to the id attribute of the topic referred to by the href -->
            <xsl:attribute name="internal-destination">
              <xsl:choose>
                <!-- Mantis 2204: Fix xref in same topic -->
                <!-- If the href contains a # character, then the topic file name is the preceding substring -->
                <xsl:when test="starts-with(@href,'#') and contains(@href,'/')">
                  <xsl:value-of select="substring-after(@href,'/')"/>
                </xsl:when>
                <xsl:when test="starts-with(@href,'#')">
                  <xsl:value-of select="substring-after(@href,'#')"/>
                </xsl:when>
                <xsl:when test="contains(@href,'#') and contains(substring-after(@href,'#'),'/')">
                  <xsl:value-of select="substring-after(substring-after(@href,'#'),'/')"/>
                </xsl:when>
                <xsl:when test="contains(@href,'#')">
                  <xsl:value-of select="substring-after(@href,'#')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="document(@href,/)/*/@id"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="./text()"/>
          </fo:basic-link>
        </xsl:when>
        <!-- If the format attribute is html, then interpret the href as an external link -->
        <!-- (for example, to a website) -->
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="@format='html' or @format='HTML'">
              <fo:basic-link>
                <xsl:attribute name="external-destination">
                  <xsl:value-of select="@href"/>
                </xsl:attribute>
                <xsl:apply-templates/>
              </fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
              <!-- xref format not recognized: output xref contents without creating a hyperlink -->
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </fo:inline>
  </xsl:template>
  <!-- ============================================================== -->
</xsl:stylesheet>

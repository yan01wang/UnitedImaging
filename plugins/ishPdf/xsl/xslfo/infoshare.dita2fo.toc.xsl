<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" version="1.1">
  <!-- ============================================================== -->
	<!--
		TWEAKS
			$toc.numbering   			- indicates whether a toc is needed (yes / no)
			$toc.level						- indicates how many levels will be included in the toc (1..5)
			$toc.shortdescription - indicates whether a shortdesc should be extracted from the topic and displayed in the toc (yes / no) 
	-->
  <!-- ============================================================== -->
	<!-- Revision History -->
	<!-- ============================================================== -->
	<!--
       1/ Initial Version
       2/ 20070720: Added functionality to render topichead elements 
                    correctly within PDF
			 3/	20090819 EL: Made functionality compliant with DITA 1.2 
			                 element structures
			 4/	20100310 RS: Made functionality compliant wiht DITAMERGE 
			                 syntax (new merging mechanism)                 
  -->
	<!-- ============================================================== -->	
	<!-- ============================================================== -->
	<!-- named templates -->
	<!-- ============================================================== -->
	<xsl:template name="generate.toc">
		<xsl:param name="language"/>
		
		<!--<xsl:for-each select="//*[contains(@class,' map/map ')]//*[contains(@class,' topic/topic ') or contains(@class,' map/topicref ') and not(contains(@class,' mapgroup-d/topicgroup '))]">-->
  	<xsl:for-each select="//*[contains(@class,' map/map ')]//*[(contains(@class,' topic/topic ') and not(contains(@class,' mapgroup-d/topicgroup '))) and not(@outputclass='inside-front-cover')]">
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
  	  <xsl:variable name="toc.depth">
  	    <xsl:choose>
  	      <xsl:when test="$multilingual = 'yes'">1</xsl:when>
  	      <xsl:otherwise>
  	        <xsl:value-of select="$toc.level" />
  	      </xsl:otherwise>
  	    </xsl:choose>
  	  </xsl:variable>
			<xsl:choose>
			  <xsl:when test="$toc.depth >= $outline-level">	  
				<!--xsl:when test="$toc.level >= $outline-level"-->	  
		  	  <fo:block>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="concat('toc',$outline-level)"/>
							<xsl:with-param name="language" select="$language"/>
						</xsl:call-template>
						<xsl:call-template name="add.changebars">
							<xsl:with-param name="node" select="."/>
							<xsl:with-param name="type" select="'begin'"/>
							<xsl:with-param name="flag.comparison.result" select="'yes'"/>
							<xsl:with-param name="language" select="$language"/>
							<xsl:with-param name="placement" select="'break'"/>
						</xsl:call-template>
		  			<fo:basic-link internal-destination="{generate-id()}">
		  				<fo:inline>
		 					  <xsl:if test="$toc.numbering = 'yes'">
		 					  	<xsl:value-of select="$outline-number"/><xsl:text> </xsl:text>
		 					  </xsl:if>
		 					  <xsl:apply-templates select="*[contains(@class,' topic/title ')] | @navtitle | *[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]" mode="toc"/>
		  				</fo:inline>
		  				<fo:leader leader-pattern="dots"/>
		  				<fo:page-number-citation ref-id="{generate-id()}"/>
		  			</fo:basic-link>
						<xsl:call-template name="add.changebars">
							<xsl:with-param name="node" select="."/>
							<xsl:with-param name="type" select="'end'"/>
							<xsl:with-param name="language" select="$language"/>
							<xsl:with-param name="placement" select="'break'"/>
						</xsl:call-template>
		  		</fo:block>
		  	</xsl:when>
				<xsl:otherwise><!-- DO NOTHING --></xsl:otherwise>
			</xsl:choose>
			<!-- extract short description -->
  		<xsl:if test="$toc.shortdescription = 'yes'">
  		  <fo:block>
					<xsl:call-template name="add.style">
						<xsl:with-param name="style" select="'block'"/>
						<xsl:with-param name="language" select="$language"/>
					</xsl:call-template>							  		  
					<xsl:call-template name="add.changebars">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="type" select="'begin'"/>
						<xsl:with-param name="language" select="$language"/>
						<xsl:with-param name="placement" select="'break'"/>
					</xsl:call-template>
  		    <xsl:value-of select="*[contains(@class,' topic/shortdesc ')]"/>
					<xsl:call-template name="add.changebars">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="type" select="'end'"/>
						<xsl:with-param name="language" select="$language"/>
						<xsl:with-param name="placement" select="'break'"/>
					</xsl:call-template>
  		  </fo:block>
  		</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- ============================================================== -->
	<xsl:template name="create.toc">
    <xsl:param name="toc.startlevel" />
    <xsl:param name="toc.depth" />
    <xsl:param name="language"/>
    
    <xsl:for-each select=".//*[((contains(@class,' topic/topic ') or contains(@class,' map/topicref '))) and not(@outputclass='inside-front-cover') and count(ancestor-or-self::*[(contains(@class,' topic/topic ') or contains(@class,' map/topicref ')) and not(@outputclass='inside-front-cover')]) > number($toc.startlevel)-1]">
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
      <xsl:variable name="tocref"><xsl:value-of select="concat('toc',$outline-level)"/></xsl:variable>
      <xsl:choose>
				<xsl:when test="(number($toc.startlevel) + number($toc.depth)) >= $outline-level">	  
		  	  <fo:block>
						<xsl:call-template name="add.style">
							<xsl:with-param name="style" select="concat('toc',$outline-level)"/>
							<xsl:with-param name="language" select="$language"/>
						</xsl:call-template>
						<xsl:call-template name="add.changebars">
							<xsl:with-param name="node" select="."/>
							<xsl:with-param name="type" select="'begin'"/>
							<xsl:with-param name="flag.comparison.result" select="'yes'"/>
							<xsl:with-param name="language" select="$language"/>
							<xsl:with-param name="placement" select="'break'"/>
						</xsl:call-template>
		  			<fo:basic-link internal-destination="{generate-id()}">
		  				<fo:inline>
		 					  <xsl:if test="$toc.numbering = 'yes'">
		 					  	<xsl:value-of select="$outline-number"/><xsl:text> </xsl:text>
		 					  </xsl:if>
		 					  <xsl:apply-templates select="*[contains(@class,' topic/title ')] | @navtitle  | *[contains(@class,'- map/topicmeta ')]/*[contains(@class, '- topic/navtitle ')]" mode="toc"/>
		  				</fo:inline>
		  				<fo:leader leader-pattern="dots"/>
		  				<fo:page-number-citation ref-id="{generate-id()}"/>
		  			</fo:basic-link>
						<xsl:call-template name="add.changebars">
							<xsl:with-param name="node" select="."/>
							<xsl:with-param name="type" select="'end'"/>
							<xsl:with-param name="language" select="$language"/>
							<xsl:with-param name="placement" select="'break'"/>
						</xsl:call-template>
		  		</fo:block>
		  	</xsl:when>
				<xsl:otherwise><!-- DO NOTHING --></xsl:otherwise>
			</xsl:choose>			
			<!-- extract short description -->
  		<xsl:if test="$toc.shortdescription = 'yes'">
  		  <fo:block>
					<xsl:call-template name="add.style">
						<xsl:with-param name="style" select="'block'"/>
						<xsl:with-param name="language" select="$language"/>
					</xsl:call-template>							  		  
					<xsl:call-template name="add.changebars">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="type" select="'begin'"/>
						<xsl:with-param name="language" select="$language"/>
						<xsl:with-param name="placement" select="'break'"/>
					</xsl:call-template>
  		    <xsl:apply-templates select="*[contains(@class,' topic/shortdesc ')]" mode="toc"/>
					<xsl:call-template name="add.changebars">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="type" select="'end'"/>
						<xsl:with-param name="language" select="$language"/>
						<xsl:with-param name="placement" select="'break'"/>
					</xsl:call-template>
  		  </fo:block>
  		</xsl:if>
		</xsl:for-each>	
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
		  		<xsl:with-param name="node" select="$node/parent::*[(contains(@class,' topic/topic ') or contains(@class,' map/topicref ')) and not(@outputclass='inside-front-cover')]"/>
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
			<xsl:when test="$node/parent::*[contains(@class,' mapgroup-d/topicgroup ')] or $node/preceding-sibling::*[contains(@class,' mapgroup-d/topicgroup ')]">
				<xsl:variable name="result">
					<xsl:call-template name="count-items-topicgroup-helper">
						<xsl:with-param name="current-node" select="$node/ancestor::*[not(contains(@class,' mapgroup-d/topicgroup '))][1]/*[(contains(@class, ' topic/topic ') or contains(@class, ' map/topicref '))][1]"/>
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
				<xsl:value-of select="count($node/preceding-sibling::*[(contains(@class, ' topic/topic ') or contains(@class, ' map/topicref ')) and not(@outputclass='inside-front-cover')]) + 1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
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
					<xsl:when test="$current-node[contains(@class, ' mapgroup-d/topicgroup ')]">
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
		<xsl:value-of select="count($node/ancestor-or-self::*[contains(@class,' topic/topic ') or contains(@class,' map/topicref ') and not(contains(@class,' mapgroup-d/topicgroup ')) and  not(@outputclass='inside-front-cover')])"/>
	</xsl:template>
	<!-- ============================================================== -->
</xsl:stylesheet>

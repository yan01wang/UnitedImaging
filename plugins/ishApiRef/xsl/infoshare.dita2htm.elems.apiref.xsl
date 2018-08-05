<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ============================================================== -->

	<xsl:template match="*[contains(@class,' apiref/paramlist ')]">
<!--		<xsl:param name="showConref">
			<xsl:choose>
				<xsl:when test="*[contains(@class,' apiref/param')][contains(@class,' topic/strow ')]/@id">yes</xsl:when>
			</xsl:choose>
		</xsl:param> -->
		<div>
			<!--<xsl:call-template name="trisoft.flagitandid"/>-->
			<hr/>
			<h4>Parameters</h4>
			<table cellspacing="1px">
<!--				<xsl:call-template name="dita-common-attributes">
					<xsl:with-param name="default-output-class">paramlist</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="setscale"/>
				<xsl:call-template name="gen-dflt-data-hdr"/>-->
				<thead>
<!--					<xsl:if test="$showConref = 'yes'">
						<th/>
					</xsl:if> -->
					<th>Name</th>
					<th>Type</th>
					<th>Direction</th>
					<th>Description</th>
				</thead>
				<xsl:apply-templates>
<!--					<xsl:with-param name="showConref" select="$showConref"/>-->
				</xsl:apply-templates>
			</table>
			<hr/>
		</div>

	</xsl:template>

	<!-- ============================================================== -->

	<xsl:template match="*[contains(@class,' apiref/param')][contains(@class,' topic/strow ')]" mode="root">
		<div>
<!--			<xsl:call-template name="trisoft.flagitandid"/>-->
			<hr/>
			<h4>Parameters</h4>
			<table cellspacing="1px">
<!--				<xsl:call-template name="dita-common-attributes">
					<xsl:with-param name="default-output-class">paramlist</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="setscale"/>
				<xsl:call-template name="gen-dflt-data-hdr"/>-->
				<thead>
					<th>Name</th>
					<th>Type</th>
					<th>Direction</th>
					<th>Description</th>
				</thead>
				<xsl:apply-templates select=".">
<!--					<xsl:with-param name="showConref">no</xsl:with-param >-->
				</xsl:apply-templates>
			</table>
			<hr/>
		</div>
	</xsl:template>

	<!-- ============================================================== -->

	<xsl:template match="*[contains(@class,' apiref/param')][contains(@class,' topic/strow ')]">
<!--		<xsl:param name="showConref"/>-->
		<xsl:param name="apiRefClassString" select="concat('apiref/param',substring-before(substring-after(@class,' apiref/param'),' '))"/>
		<xsl:param name="paramDirection">
			<xsl:choose>
				<xsl:when test="contains($apiRefClassString,'InOut')">InOut</xsl:when>
				<xsl:when test="contains($apiRefClassString,'Out')">Out</xsl:when>
				<xsl:when test="contains($apiRefClassString,'In')">In</xsl:when>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="paramType" select="substring-before(substring-after($apiRefClassString,'apiref/param'),$paramDirection)"/>
		<tr>
			<!--<xsl:if test="$showConref = 'yes'">
				<td>
					<xsl:call-template name="trisoft.flagitandid" />
				</td>
			</xsl:if>-->
			<xsl:apply-templates select="*[contains(@class,' apiref/paramName ')]"/>
			<xsl:choose>
				<xsl:when test="$paramType = 'Enum'">
					<xsl:apply-templates select="*[contains(@class,' apiref/paramEnumName ')]"/>
				</xsl:when>
				<xsl:otherwise>
					<td align="left" valign="top">
						<xsl:value-of select="$paramType"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<td align="left" valign="top">
				<xsl:value-of select="$paramDirection"/>
			</td>
			<xsl:apply-templates select="*[contains(@class,' apiref/paramDesc ')]"/>
		</tr>
	</xsl:template>

	<!-- ============================================================== -->

</xsl:stylesheet>


<?xml version='1.0'?>

<!--===========================================================================
	This file is part of the DITA Open Toolkit project hosted on Sourceforge.net.
	See the accompanying license.txt file for applicable licenses.
	==========================================================================-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    exclude-result-prefixes="opentopic opentopic-index dita2xslfo"
    version="2.0">
	
	<!--Steps-->
    <xsl:template match="*[contains(@class, ' task/steps ')]">
        <xsl:choose>
            <xsl:when test="$GENERATE-TASK-LABELS='YES'">
              <fo:block>
                  <xsl:apply-templates select="." mode="dita2xslfo:task-heading">
                      <xsl:with-param name="use-label">
                        <xsl:apply-templates select="." mode="dita2xslfo:retrieve-task-heading">
                          <xsl:with-param name="pdf2-string">Task Steps</xsl:with-param>
                          <xsl:with-param name="common-string">task_procedure</xsl:with-param>
                        </xsl:apply-templates>
                      </xsl:with-param>
                  </xsl:apply-templates>
                  <fo:list-block xsl:use-attribute-sets="steps">
                      <xsl:call-template name="commonattributes"/>
                      <xsl:apply-templates/>
                  </fo:list-block>
              </fo:block>
            </xsl:when>
            <xsl:otherwise>
			    <fo:block>
					<xsl:apply-templates/>
				</fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="*[contains(@class, ' task/steps ')]/*[contains(@class, ' task/step ')]">
        <!-- Switch to variable for the count rather than xsl:number, so that step specializations are also counted -->
        <xsl:variable name="actual-step-count" select="number(count(preceding-sibling::*[contains(@class, ' task/step ')])+1)"/>
		<xsl:choose>
		    <xsl:when test="not(preceding-sibling::*[contains(@class, ' task/step ')]) and not(following-sibling::*[contains(@class, ' task/step ')])">
				<fo:list-block xsl:use-attribute-sets="steps">
				    <fo:list-item xsl:use-attribute-sets="steps.step">
					    <fo:list-item-label xsl:use-attribute-sets="steps.step__label">
						    <fo:block font-size="125%"><xsl:text>&#x25ba;</xsl:text><xsl:text> </xsl:text></fo:block>
						</fo:list-item-label>
						<fo:list-item-body xsl:use-attribute-sets="steps.step__body">
						    <fo:block xsl:use-attribute-sets="steps.step__content">
								<xsl:value-of select="cmd"/>
								<xsl:apply-templates select="node()[name()!='cmd']"/>
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
			</xsl:when>
			<xsl:otherwise>
			    <fo:list-block xsl:use-attribute-sets="steps">
				<xsl:call-template name="commonattributes"/>
				<fo:list-item xsl:use-attribute-sets="steps.step">
					<fo:list-item-label xsl:use-attribute-sets="steps.step__label">
						<fo:block xsl:use-attribute-sets="steps.step__label__content">
							<fo:inline>
								<xsl:call-template name="commonattributes"/>
							</fo:inline>
							<xsl:if test="preceding-sibling::*[contains(@class, ' task/step ')] | following-sibling::*[contains(@class, ' task/step ')]">
								<xsl:call-template name="getVariable">
									<xsl:with-param name="id" select="'Ordered List Number'"/>
									<xsl:with-param name="params">
										<number>
											<xsl:value-of select="$actual-step-count"/>
										</number>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</fo:block>
					</fo:list-item-label>

					<fo:list-item-body xsl:use-attribute-sets="steps.step__body">
						<fo:block xsl:use-attribute-sets="steps.step__content">
							<xsl:apply-templates/>
						</fo:block>
					</fo:list-item-body>

				</fo:list-item>
				</fo:list-block>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>

    <xsl:template match="*[contains(@class, ' task/stepsection ')]">
        <fo:block>
			<xsl:apply-templates/>
		</fo:block>
    </xsl:template>
	
	<!--Substeps-->
    <xsl:template match="*[contains(@class, ' task/substeps ')]">
        <fo:list-block xsl:use-attribute-sets="substeps">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:list-block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' task/substeps ')]/*[contains(@class, ' task/substep ')]">
        <fo:list-item xsl:use-attribute-sets="substeps.substep">
            <fo:list-item-label xsl:use-attribute-sets="substeps.substep__label">
                <fo:block xsl:use-attribute-sets="substeps.substep__label__content">
                    <fo:inline>
                        <xsl:call-template name="commonattributes"/>
                    </fo:inline>
                    <xsl:number format="a). "/>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body xsl:use-attribute-sets="substeps.substep__body">
                <fo:block xsl:use-attribute-sets="substeps.substep__content">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>

	<xsl:template match="*[contains(@class, ' task/prereq ')]">
        <fo:block xsl:use-attribute-sets="prereq">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates select="." mode="dita2xslfo:task-heading">
                  <xsl:with-param name="use-label">
                    <xsl:apply-templates select="." mode="dita2xslfo:retrieve-task-heading">
                      <xsl:with-param name="pdf2-string">Task Prereq</xsl:with-param>
                      <xsl:with-param name="common-string">task_prereq</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:with-param>
            </xsl:apply-templates>
            <fo:block xsl:use-attribute-sets="prereq__content">
              <xsl:apply-templates/>
            </fo:block>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>

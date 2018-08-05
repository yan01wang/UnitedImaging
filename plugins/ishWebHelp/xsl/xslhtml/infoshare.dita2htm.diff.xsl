<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <!-- ============================================================== -->
   <xsl:template match="processing-instruction('ish')[.='text_remove_begin']">
      <xsl:text disable-output-escaping="yes">&lt;span class="textRemoved"&gt;</xsl:text>
   </xsl:template>
   <!-- ============================================================== -->
   <xsl:template match="processing-instruction('ish')[.='text_remove_end']">
      <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
   </xsl:template>
   <!-- ============================================================== -->
   <xsl:template match="processing-instruction('ish')[.='text_insert_begin']">
      <xsl:text disable-output-escaping="yes">&lt;span class="textInserted"&gt;</xsl:text>
   </xsl:template>
   <!-- ============================================================== -->
   <xsl:template match="processing-instruction('ish')[.='text_insert_end']">
      <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
   </xsl:template>
   <!-- ============================================================== -->
   <xsl:template name="removebegin" match="processing-instruction('ish')[.='remove_begin']">
      <xsl:if test="contains(following-sibling::*[1]/@class, ' topic/image ')">
         <xsl:text disable-output-escaping="yes">&lt;span class="backRemove"&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="contains(following-sibling::*[1]/@class, ' topic/topicref ') or contains(following-sibling::*[1]/@class, ' map/topicref ')">
         <xsl:text disable-output-escaping="yes">&lt;span class="textRemoved"&gt;</xsl:text>
      </xsl:if>
   </xsl:template>
   <!-- ============================================================== -->
   <xsl:template name="removeend" match="processing-instruction('ish')[.='remove_end']">
      <xsl:if test="contains(preceding-sibling::*[1]/@class, ' topic/image ')">
         <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="contains(preceding-sibling::*[1]/@class, ' topic/topicref ') or contains(preceding-sibling::*[1]/@class, ' map/topicref ')">
         <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
      </xsl:if>
   </xsl:template>
   <!-- ============================================================== -->
   <xsl:template match="processing-instruction('ish')[.='insert_begin']">
      <xsl:if test="contains(following-sibling::*[1]/@class, ' topic/image ')">
         <xsl:text disable-output-escaping="yes">&lt;span class="backInsert"&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="contains(following-sibling::*[1]/@class, ' topic/topicref ') or contains(following-sibling::*[1]/@class, ' map/topicref ')">
         <xsl:text disable-output-escaping="yes">&lt;span class="textInserted"&gt;</xsl:text>
      </xsl:if>
   </xsl:template>
   <!-- ============================================================== -->
   <xsl:template match="processing-instruction('ish')[.='insert_end']">
      <xsl:if test="contains(preceding-sibling::*[1]/@class, ' topic/image ')">
         <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="contains(preceding-sibling::*[1]/@class, ' topic/topicref ') or contains(preceding-sibling::*[1]/@class, ' map/topicref ')">
         <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
      </xsl:if>
   </xsl:template>
   <!-- ============================================================== -->
</xsl:stylesheet>

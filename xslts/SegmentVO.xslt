<!--Translates 
	<SegmentVO>
		<SegmentVO></SegmentVO>
	</SegmentVO>
	 to 
	 <Coverage>
	 	<CoverageInformation></CoverageInformation>
	 	<RiderInformation></RiderInformation>
	 </Coverage>
 -->

<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <!-- Copy everything -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Template handling the top-level 'SegmentVO' -->
  <xsl:template match="SegmentVO">
    <CoverageInformation>
      <!-- Apply the copy template to all sub-elements except 'SegmentVO' -->
      <xsl:apply-templates select="*[name()!='SegmentVO']"/>
    </CoverageInformation>
    <!-- Apply the templates to the 'SegmentVO' sub-elements -->
    <xsl:apply-templates select="SegmentVO"/>
  </xsl:template>

  <!-- Template handling the inner 'SegmentVO' -->
  <xsl:template match="SegmentVO/SegmentVO">
    <RiderInformation>
      <xsl:apply-templates/>
    </RiderInformation>
  </xsl:template>
  <xsl:template match="/">
  <Coverage>
    <xsl:apply-templates></xsl:apply-templates>
  </Coverage>
</xsl:template>
</xsl:stylesheet>
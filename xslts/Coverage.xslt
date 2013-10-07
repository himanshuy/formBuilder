<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:timeStamp="java.lang.System">
	<xsl:variable name="lifeVOPK" select="concat('-',timeStamp:currentTimeMillis())"/>
	<xsl:template match="/">
	  <xsl:apply-templates select="Coverage/CoverageInformation" />
	</xsl:template>
	<xsl:template match="CoverageInformation">
	  <SegmentVO>
	    <AgeAtIssue><xsl:value-of select="AgeAtIssue"/></AgeAtIssue>
	      <Amount><xsl:value-of select="Amount"/></Amount>
	      <IssueStateCT><xsl:value-of select="IssueStateCT"/></IssueStateCT>
	      <OptionCodeCT><xsl:value-of select="OptionCodeCT"/></OptionCodeCT>
	      <ApplicationReceivedDate><xsl:value-of select="ApplicationReceivedDate"/></ApplicationReceivedDate>
	      <ApplicationSignedDate><xsl:value-of select="ApplicationSignedDate"/></ApplicationSignedDate>
	      <CreationDate><xsl:value-of select="CreationDate"/></CreationDate>
	      <EffectiveDate><xsl:value-of select="EffectiveDate"/></EffectiveDate>
	      <IssueDate><xsl:value-of select="IssueDate"/></IssueDate>
	      <TerminationDate>12/31/9999</TerminationDate>
	      <RateSeriesDate><xsl:value-of select="RateSeriesDate"/></RateSeriesDate>
	      <SegmentPK><xsl:value-of select="SegmentPK"/></SegmentPK>
	      <ProductStructureFK>1330706906578</ProductStructureFK>
		  <LifeVO>
		  	<FaceAmount><xsl:value-of select="FaceAmount"/></FaceAmount>
		  	<LifePK><xsl:value-of select="$lifeVOPK"/></LifePK>
		  	<SegmentFK><xsl:value-of select="SegmentPK"/></SegmentFK>
		  </LifeVO>
	    <xsl:for-each select="../RiderInformation">
	      <SegmentVO>
	        <xsl:for-each select="*">
		      <xsl:copy>
			    <xsl:apply-templates/>
			  </xsl:copy>
		    </xsl:for-each>
	      </SegmentVO>
	    </xsl:for-each>
	  </SegmentVO>
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
    <xsl:template match="ClientInformation">
        <SaveData>
            <xsl:for-each select="RoleTypeCT">
                <ClientInformation>
                        <xsl:apply-templates select="../*[name()!='RoleTypeCT']"/>
                        <RoleTypeCT><xsl:value-of select="."/></RoleTypeCT>
                </ClientInformation>
            </xsl:for-each>
        </SaveData>
    </xsl:template>
</xsl:stylesheet>
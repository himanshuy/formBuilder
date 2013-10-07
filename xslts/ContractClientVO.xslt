<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
            <xsl:for-each select="ContractClientVO">
              <ClientInformation>
              	<RelationshipToInsuredCT><xsl:value-of select="RelationshipToInsuredCT"/></RelationshipToInsuredCT>
                <RelationshipToEmployeeCT><xsl:value-of select="RelationshipToEmployeeCT"/></RelationshipToEmployeeCT>
                <AssignmentReasonCT><xsl:value-of select="AssignmentReasonCT"/></AssignmentReasonCT>
                <xsl:for-each select="ClientRoleVO">
                	<RoleTypeCT><xsl:value-of select="RoleTypeCT"/></RoleTypeCT>
                	<xsl:for-each select="ClientDetailVO">
                		<FirstName><xsl:value-of select="FirstName"/></FirstName>
                        <LastName><xsl:value-of select="LastName"/></LastName>
                        <MiddleName><xsl:value-of select="MiddleName"/></MiddleName>
                        <DateOfBirth><xsl:value-of select="DateOfBirth"/></DateOfBirth>
                        <TaxIdentification><xsl:value-of select="TaxIdentification"/></TaxIdentification>
                	</xsl:for-each>
                </xsl:for-each>
              </ClientInformation>
            </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
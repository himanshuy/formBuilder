<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" xmlns:timeStamp="java.lang.System">
    <xsl:template match="/">
    		<xsl:for-each select="ClientInformation">
            <xsl:variable name="contractClientPK" select="concat('-',timeStamp:currentTimeMillis())"/>
            <xsl:variable name="clientRolePK" select="concat('-',timeStamp:currentTimeMillis())"/>
                <ContractClientVO>
                    <RelationshipToInsuredCT><xsl:value-of select="RelationshipToInsuredCT"/></RelationshipToInsuredCT>
                    <RelationshipToEmployeeCT><xsl:value-of select="RelationshipToEmployeeCT"/></RelationshipToEmployeeCT>
                    <AssignmentReasonCT><xsl:value-of select="AssignmentReasonCT"/></AssignmentReasonCT>
                    <Associated><xsl:value-of select="Associated"/></Associated>
                    <AuthorizedSignatureCT><xsl:value-of select="AuthorizedSignatureCT"/></AuthorizedSignatureCT>
                    <ClassCT><xsl:value-of select="ClassCT"/></ClassCT>
                    <ContractClientPK><xsl:value-of select="$contractClientPK"/></ContractClientPK>
                    <ClientRoleVO>
                        <RoleTypeCT><xsl:value-of select="RoleTypeCT"/></RoleTypeCT>
                        <ClientDetailVO>
                            <FirstName><xsl:value-of select="FirstName"/></FirstName>
                            <LastName><xsl:value-of select="LastName"/></LastName>
                            <MiddleName><xsl:value-of select="MiddleName"/></MiddleName>
                            <BirthDate><xsl:value-of select="DateOfBirth"/></BirthDate>
                            <TaxIdentification><xsl:value-of select="TaxIdentification"/></TaxIdentification>
                            <ClientDetailPK><xsl:value-of select="ClientDetailPK"/></ClientDetailPK>
                        </ClientDetailVO>
                        <ClientRolePK><xsl:value-of select="$clientRolePK"/></ClientRolePK>
                        <ClientDetailFK><xsl:value-of select="ClientDetailPK"/></ClientDetailFK>
                    </ClientRoleVO>
                    <ClientRoleFK><xsl:value-of select="$clientRolePK"/></ClientRoleFK>
                    <CorrespondenceAddressTypeCT><xsl:value-of select="CorrespondenceAddressTypeCT"/></CorrespondenceAddressTypeCT>
                    <CreationDateTime><xsl:value-of select="CreationDateTime"/></CreationDateTime>
                    <CreationOperator><xsl:value-of select="CreationOperator"/></CreationOperator>
                    <EffectiveDate><xsl:value-of select="EffectiveDate"/></EffectiveDate>
                    <SegmentFK><xsl:value-of select="SegmentFK"/></SegmentFK>
                    <TerminationDate>12/31/9999</TerminationDate>
                </ContractClientVO>
               </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/*">
		<FMPXMLRESULT xmlns="http://www.filemaker.com/fmpxmlresult">
			<ERRORCODE>0</ERRORCODE>
			<PRODUCT BUILD="" NAME="" VERSION=""/>
            <DATABASE DATEFORMAT="M/d/yyyy" LAYOUT="" NAME="" RECORDS="{count(/*/*/*)}" TIMEFORMAT="h:mm:ss a"/>
			<METADATA>
                <xsl:for-each select="/*/*/*[position()=1]/first-name">
					<FIELD>
						<xsl:attribute name="EMPTYOK">NO</xsl:attribute>
						<xsl:attribute name="MAXREPEAT">1</xsl:attribute>
						<xsl:attribute name="NAME"><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:attribute name="TYPE">TEXT</xsl:attribute>
					</FIELD>
				</xsl:for-each>
                <xsl:for-each select="/*/*/*[position()=1]/last-name">
					<FIELD>
						<xsl:attribute name="EMPTYOK">NO</xsl:attribute>
						<xsl:attribute name="MAXREPEAT">1</xsl:attribute>
						<xsl:attribute name="NAME"><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:attribute name="TYPE">TEXT</xsl:attribute>
					</FIELD>
				</xsl:for-each>
                <xsl:for-each select="/*/*/*[position()=1]/full-name">
					<FIELD>
						<xsl:attribute name="EMPTYOK">NO</xsl:attribute>
						<xsl:attribute name="MAXREPEAT">1</xsl:attribute>
						<xsl:attribute name="NAME"><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:attribute name="TYPE">TEXT</xsl:attribute>
					</FIELD>
				</xsl:for-each>
                <xsl:for-each select="/*/*/*[position()=1]/netid">
					<FIELD>
						<xsl:attribute name="EMPTYOK">NO</xsl:attribute>
						<xsl:attribute name="MAXREPEAT">1</xsl:attribute>
						<xsl:attribute name="NAME"><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:attribute name="TYPE">TEXT</xsl:attribute>
					</FIELD>
				</xsl:for-each>
                <xsl:for-each select="/*/*/*[position()=1]/ndguid">
					<FIELD>
						<xsl:attribute name="EMPTYOK">NO</xsl:attribute>
						<xsl:attribute name="MAXREPEAT">1</xsl:attribute>
						<xsl:attribute name="NAME"><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:attribute name="TYPE">TEXT</xsl:attribute>
					</FIELD>
				</xsl:for-each>
                <xsl:for-each select="/*/*/*[position()=1]/position-title">
					<FIELD>
						<xsl:attribute name="EMPTYOK">NO</xsl:attribute>
						<xsl:attribute name="MAXREPEAT">1</xsl:attribute>
						<xsl:attribute name="NAME"><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:attribute name="TYPE">TEXT</xsl:attribute>
					</FIELD>
				</xsl:for-each>
                <xsl:for-each select="/*/*/*[position()=1]/campus-department">
					<FIELD>
						<xsl:attribute name="EMPTYOK">NO</xsl:attribute>
						<xsl:attribute name="MAXREPEAT">1</xsl:attribute>
						<xsl:attribute name="NAME"><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:attribute name="TYPE">TEXT</xsl:attribute>
					</FIELD>
				</xsl:for-each>
                <xsl:for-each select="/*/*/*[position()=1]/contact-information/*">
					<FIELD>
						<xsl:attribute name="EMPTYOK">YES</xsl:attribute>
						<xsl:attribute name="MAXREPEAT">1</xsl:attribute>
						<xsl:attribute name="NAME"><xsl:value-of select="name()"/></xsl:attribute>
						<xsl:attribute name="TYPE">TEXT</xsl:attribute>
					</FIELD>
				</xsl:for-each>
			</METADATA>
			<RESULTSET>
                <xsl:attribute name="FOUND"><xsl:value-of select="count(/descendant::person)"/></xsl:attribute>
                <xsl:for-each select="/descendant::person">
					<ROW>
						<xsl:attribute name="MODID">0</xsl:attribute>
						<xsl:attribute name="RECORDID">0</xsl:attribute>
					    <COL>
							<DATA>
                                <xsl:value-of select="first-name"/>
							</DATA>
						</COL>
					    <COL>
							<DATA>
                                <xsl:value-of select="last-name"/>
							</DATA>
						</COL>
					    <COL>
							<DATA>
                                <xsl:value-of select="full-name"/>
							</DATA>
						</COL>
					    <COL>
							<DATA>
                                <xsl:value-of select="netid"/>
							</DATA>
						</COL>
					    <COL>
							<DATA>
                                <xsl:value-of select="ndguid"/>
							</DATA>
						</COL>
					    <COL>
							<DATA>
                                <xsl:value-of select="position-title"/>
							</DATA>
						</COL>
					    <COL>
							<DATA>
                                <xsl:value-of select="campus-department"/>
							</DATA>
						</COL>
					    <COL>
							<DATA>
                                <xsl:value-of select="contact-information/campus-address"/>
							</DATA>
						</COL>
					    <COL>
							<DATA>
                                <xsl:value-of select="contact-information/email"/>
							</DATA>
						</COL>
					    <COL>
							<DATA>
                                <xsl:value-of select="contact-information/phone"/>
							</DATA>
						</COL>
					</ROW>
				</xsl:for-each>
			</RESULTSET>
		</FMPXMLRESULT>
	</xsl:template>
</xsl:stylesheet>

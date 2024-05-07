<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:src="https://github.com/dwugofski/rpgml/p2e" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../common/xslt/smallblock/p2e.header.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.rich_text.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.requirements.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.entries.xslt"/>

	<!-- Documentation intended for XslDoc -->

	<!--xsl:output method="html" indent="no"/-->
	<xsl:strip-space elements="*"/>

	<!-- 
		========================================================================
		Activity Stat Black in HTML, Small Block Format
		========================================================================
	-->

	<!--**
		Display the statblock of a feat
	-->
	<xsl:template match="src:feat">
		<div class="statblock feat">
			<!-- Give the ID of the feat -->
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			<!-- Make the header -->
			<xsl:call-template name="header">
				<xsl:with-param name="name" select="./src:name"/>
				<xsl:with-param name="level" select="./src:level"/>
				<xsl:with-param name="type">Feat</xsl:with-param>
				<xsl:with-param name="actCount" select="./src:actCount"/>
			</xsl:call-template>
			<!-- We can safely assume the name and action count are in the element -->
			<xsl:apply-templates select="./*[position() &gt;= 4]" mode="feat"/>
		</div>
	</xsl:template>

	<!--**
		Catch-all to cover non-feat-specific elements and use normal templates
	-->
	<xsl:template match="*" mode="feat">
		<p>
			<xsl:apply-templates select="."/>
		</p>
	</xsl:template>

	<!--**
		Modify the description of a feat to have a horizontal ruler above it
	-->
	<xsl:template match="src:description" mode="feat">
		<hr/>
		<xsl:apply-templates select="."/>
	</xsl:template>

</xsl:stylesheet>
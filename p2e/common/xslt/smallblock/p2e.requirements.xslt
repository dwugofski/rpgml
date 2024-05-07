<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:src="https://github.com/dwugofski/rpgml/p2e" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="./p2e.rich_text.xslt"/>
	<xsl:import href="./p2e.entries.xslt"/>

	<!-- Documentation intended for XslDoc -->

	<!-- 
		========================================================================
		TRANSLATE A REQUIREMENTS LIST INTO SMALL BLOCK HTML
		========================================================================
	-->

	<!--**
		Display a rich-text requirement
	-->
	<xsl:template match="src:req">
		<xsl:call-template name="enclosed_rich_paragraph"/>
	</xsl:template>

	<!--**
		Display the statblock of a prerequisites entry
	-->
	<xsl:template match="src:prereqs">
		<xsl:call-template name="delimiter_list_entry">
			<xsl:with-param name="title">Prerequisites</xsl:with-param>
			<xsl:with-param name="classname">prereqs</xsl:with-param>
			<xsl:with-param name="items" select="./src:req"/>
			<xsl:with-param name="delimiter" select="';'"/>
			<xsl:with-param name="terminator" select="''"/>
		</xsl:call-template>
	</xsl:template>

	<!--**
		Display the statblock of a prerequisites entry
	-->
	<xsl:template match="src:reqs">
		<xsl:call-template name="delimiter_list_entry">
			<xsl:with-param name="title">Requirements</xsl:with-param>
			<xsl:with-param name="classname">reqs</xsl:with-param>
			<xsl:with-param name="items" select="./src:req"/>
			<xsl:with-param name="delimiter" select="';'"/>
			<xsl:with-param name="terminator" select="''"/>
		</xsl:call-template>
	</xsl:template>


</xsl:stylesheet>
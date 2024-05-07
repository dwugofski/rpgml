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
		Activity Stat Block in HTML, Small Block Format
		========================================================================
	-->

	<!--**
		Display the statblock of an activity
	-->
	<xsl:template match="src:activity">
		<div class="statblock activity">
			<!-- Give the ID of the activity -->
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			<!-- Make the header -->
			<xsl:call-template name="header">
				<xsl:with-param name="name" select="./src:name"/>
				<xsl:with-param name="type">Activity</xsl:with-param>
				<xsl:with-param name="actCount" select="./src:actCount"/>
			</xsl:call-template>
			<!-- We can safely assume the name and action count are in the element -->
			<xsl:apply-templates select="./*[position() &gt;= 3]" mode="activity"/>
		</div>
	</xsl:template>

	<!--**
		Catch-all to cover non-activity-specific elements and use normal templates
	-->
	<xsl:template match="*" mode="activity">
		<p>
			<xsl:apply-templates select="."/>
		</p>
	</xsl:template>

	<!--**
		Modify the description of an activity to have a horizontal ruler above it
	-->
	<xsl:template match="src:description" mode="activity">
		<hr/>
		<xsl:apply-templates select="."/>
	</xsl:template>

</xsl:stylesheet>
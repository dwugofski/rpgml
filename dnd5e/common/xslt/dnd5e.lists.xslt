<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="3.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:dnd="https://github.com/dwugofski/rpgml/dnd5e"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../../../common/xslt/text_transform.xslt"/>

	<!-- Documentation intended for XslDoc -->

	<!-- 
		========================================================================
		Abilities
		========================================================================
	-->

	<xsl:template name="Tability">
		<xsl:param name="ability"/>
		<xsl:call-template name="Tcapitalize">
			<xsl:with-param name="text" select="$ability"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="Tability_short">
		<xsl:param name="ability"/>
		<xsl:choose>
			<xsl:when test="$ability = 'strength'">STR</xsl:when>
			<xsl:when test="$ability = 'dexterity'">DEX</xsl:when>
			<xsl:when test="$ability = 'constitution'">CON</xsl:when>
			<xsl:when test="$ability = 'intelligence'">INT</xsl:when>
			<xsl:when test="$ability = 'wisdom'">WIS</xsl:when>
			<xsl:when test="$ability = 'charisma'">CHA</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dnd:ability">
		<xsl:call-template name="Tability">
			<xsl:with-param name="ability" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="dnd:ability" mode="short">
		<xsl:call-template name="Tability_short">
			<xsl:with-param name="ability" select="."/>
		</xsl:call-template>
	</xsl:template>

	<!-- 
		========================================================================
		Skills
		========================================================================
	-->

	<xsl:template name="Tskill">
		<xsl:param name="skill"/>
		<xsl:choose>
			<xsl:when test="$skill = 'sleight_of_hand'">Sleight of Hand</xsl:when>
			<xsl:when test="$skill = 'animal_handling'">Animal Handling</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="Tcamelcase">
					<xsl:with-param name="text" select="$skill"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dnd:skill">
		<xsl:call-template name="Tskill">
			<xsl:with-param name="skill" select="."/>
		</xsl:call-template>
	</xsl:template>


</xsl:stylesheet>
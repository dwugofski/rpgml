<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:src="https://github.com/dwugofski/rpgml/p2e" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../../common/xslt/text_transform.xslt"/>
	<xsl:import href="../../common/xslt/numerics.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.header.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.rich_text.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.requirements.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.entries.xslt"/>

	<!-- Documentation intended for XslDoc -->

	<!--xsl:output method="html" indent="no"/-->
	<xsl:strip-space elements="*"/>

	<!-- 
		========================================================================
		Spell Stat Block in HTML, Small Block Format
		========================================================================
	-->

	<!--**
		Display the statblock of a spell
	-->
	<xsl:template match="src:spell">
		<div class="statblock spell">
			<!-- Give the ID of the spell -->
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			<!-- Make the header -->
			<xsl:call-template name="header">
				<xsl:with-param name="name" select="./src:name"/>
				<xsl:with-param name="type" select="@subtype"/>
				<xsl:with-param name="level" select="./src:level"/>
			</xsl:call-template>
			<!-- Translate the traits list as normal -->
			<xsl:apply-templates select="./src:traits"/>
			<!-- Translate the tradition and domain lists via template -->
			<xsl:apply-templates select="./src:traditions"/>
			<xsl:apply-templates select="./src:domains"/>

			<!-- Specify how the spell is cast -->
			<p class="cast_container">
				<strong><xsl:text>Cast: </xsl:text></strong>
				<xsl:apply-templates select="./src:actCount" mode="spell"/>
				<xsl:call-template name="delimiter_list_entry">
					<xsl:with-param name="classname" select="'cast'"/>
					<xsl:with-param name="items" select="./src:components | ./src:trigger | ./src:reqs"/>
					<xsl:with-param name="delimiter" select="';'"/>
					<xsl:with-param name="terminator" select="''"/>
				</xsl:call-template>
				<xsl:text>.</xsl:text>
			</p>

			<!-- Specify what the spell can be cast at (i.e. range, area, target) -->
			<p class="rat_container">
				<xsl:call-template name="delimiter_list_entry">
					<xsl:with-param name="classname" select="'rat'"/>
					<xsl:with-param name="items" select="./src:range | ./src:area | ./src:targets"/>
					<xsl:with-param name="delimiter" select="';'"/>
					<xsl:with-param name="terminator" select="''"/>
				</xsl:call-template>
			</p>

			<!-- Specify the saving throw and duration of the spell -->
			<p class="throw_duration_container">
				<xsl:call-template name="delimiter_list_entry">
					<xsl:with-param name="classname" select="'throw_duration'"/>
					<xsl:with-param name="items" select="./src:spellSave | ./src:duration"/>
					<xsl:with-param name="delimiter" select="';'"/>
					<xsl:with-param name="terminator" select="''"/>
				</xsl:call-template>
			</p>

			<!-- Display the description -->
			<xsl:apply-templates select="./src:description" mode="spell"/>

			<!-- Display the heightened information -->
			<xsl:apply-templates select="./src:heightened"/>
		</div>
	</xsl:template>

	<!--**
		Catch-all to cover non-activity-specific elements and use normal templates

		Covers:
			- traits
	-->
	<xsl:template match="*" mode="spell">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<!--**
		Translate the traditions list
	-->
	<xsl:template match="src:traditions">
		<p>
			<strong><xsl:text>Traditions: </xsl:text></strong>
			<xsl:for-each select="./src:tradition">
				<xsl:value-of select="."/>
				<xsl:if test="position() != last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</p>
	</xsl:template>

	<!--**
		Translate the domains list
	-->
	<xsl:template match="src:domains">
		<p>
			<strong><xsl:text>Domains: </xsl:text></strong>
			<xsl:for-each select="./src:domain">
				<xsl:value-of select="."/>
				<xsl:if test="position() != last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</p>
	</xsl:template>

	<!--**
		Translate the action count
	-->
	<xsl:template match="src:actCount" mode="spell">
		<xsl:choose>
			<xsl:when test="string(.) = 'free'">
				<span class="actcount count_free"/>
			</xsl:when>
			<xsl:when test="string(.) = 'reaction'">
				<span class="actcount count_react"/>
			</xsl:when>
			<xsl:when test="string(.) = '1'">
				<span class="actcount count_2"/>
			</xsl:when>
			<xsl:when test="string(.) = '2'">
				<span class="actcount count_2"/>
			</xsl:when>
			<xsl:when test="string(.) = '3'">
				<span class="actcount count_3"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--**
		Translate the spell components
	-->
	<xsl:template match="src:verbal">
		<xsl:text>verbal</xsl:text>
	</xsl:template>
	<xsl:template match="src:somatic">
		<xsl:text>somatic</xsl:text>
	</xsl:template>
	<xsl:template match="src:material">
		<xsl:text>material</xsl:text>
		<xsl:if test="normalize-space(src:material) != ''">
			<xsl:text> (</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="src:components">
		<xsl:for-each select="./*">
			<xsl:apply-templates select="."/>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!--**
		Display the simple text entries of the spell
	-->
	<xsl:template match="src:range | src:area | src:targets | src:duration">
		<xsl:call-template name="simple_entry">
			<xsl:with-param name="title">
				<xsl:call-template name="Tcapitalize_first">
					<xsl:with-param name="text" select="local-name()"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="classname" select="local-name()"/>
		</xsl:call-template>
	</xsl:template>

	<!--**
		Display the saving throw information for a spell
	-->
	<xsl:template match="src:spellSave">
		<xsl:call-template name="simple_entry">
			<xsl:with-param name="title" select="'Saving Throw'"/>
			<xsl:with-param name="classname" select="saving-throw"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="src:spellSave/src:basic">
		<xsl:text>basic </xsl:text>
	</xsl:template>
	<xsl:template match="src:spellSave/src:save">
		<xsl:call-template name="Tcapitalize_first">
			<xsl:with-param name="text">
				<xsl:value-of select="."/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!--**
		Modify the description of a spell to have a horizontal ruler above/below it
	-->
	<xsl:template match="src:description" mode="spell">
		<hr/>
		<xsl:apply-templates select="."/>
		<!-- Add hr after if the spell has heightened options -->
		<xsl:if test="count(../src:heightened) &gt; 0">
			<hr/>
		</xsl:if>
	</xsl:template>

	<!--**
		Display heightened information
	-->
	<xsl:template match="src:heightened">
		<xsl:call-template name="rich_container_entry">
			<xsl:with-param name="title">
				<xsl:text>Heightened (</xsl:text>
				<xsl:choose>
					<xsl:when test="@level[0] = '+'">
						<xsl:value-of select="@level"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="ordinal">
							<xsl:with-param name="value" select="@level"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>)</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="classname">heightened</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
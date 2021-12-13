<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="3.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:coc="https://github.com/dwugofski/rpgml/coc"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../../common/xslt/text_transform.xslt"/>
	<xsl:import href="../../common/xslt/html/rich_text.xslt"/>

	<!-- Documentation intended for XslDoc -->

	<!-- 
		========================================================================
		Stat Block Header Bar
		========================================================================
	-->

	<!--**
		Displays the statblock
	-->
	<xsl:template match="coc:spell">
		<div class="statblock spell">
			<div class="header">
				<h2>Spell</h2>
				<h1>
					<xsl:value-of select="./coc:name"/>
				</h1>
			</div>

			<div>
				<p>
					<strong>Cost:</strong>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./coc:spellcost/node()"/>
				</p>

				<p>
					<strong>Casting time:</strong>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./coc:spelltime/node()"/>
				</p>
			</div>

			<xsl:if test="./coc:description">
				<hr/>
				<xsl:apply-templates select="./coc:description/node()"/>
			</xsl:if>
		</div>
	</xsl:template>

</xsl:stylesheet>
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:src="https://github.com/dwugofski/rpgml/p2e" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Documentation intended for XslDoc -->

	<!-- 
		========================================================================
		STAT BLOCK HEADER BAR
		========================================================================
	-->

	<!--**
		Displays an action count
	-->
	<xsl:template name="actionCountImg">
		<xsl:param name="count"/>
		<span><xsl:attribute name="class">actcount count_<xsl:value-of select="$count"/></xsl:attribute></span>
		<!--<div><xsl:attribute name="class">fl actcount count_<xsl:value-of select="$count"/></xsl:attribute></div>-->
	</xsl:template>

	<!--**
		Displays the header bar of a statblock
	-->
	<xsl:template name="header">
		<xsl:param name="name"/>
		<xsl:param name="type"/>
		<xsl:param name="actCount" select="NaN"/>
		<xsl:param name="level"/>
		<xsl:param name="var" select="0"/>
		<!-- Header -->
		<div class="statblock_header">
			<h1 class="fl"><xsl:value-of select="$name"/></h1>
			<xsl:if test="$actCount">
				<div><xsl:attribute name="class">fl actcount count_<xsl:value-of select="$actCount"/></xsl:attribute></div>
			</xsl:if>
			<xsl:if test="$level">
				<h2 class="fr">
					<xsl:value-of select="$type"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$level"/>
					<!-- Add a + if we have a number of variants -->
					<xsl:if test="$var > 0"><xsl:text>+</xsl:text></xsl:if>
				</h2>
			</xsl:if>
			<div class="clearer"></div>
		</div>
	</xsl:template>

	<!--**
		Displays the traits list for a stat block
	-->
	<xsl:template match="src:traits">
		<xsl:call-template name="traitList">
			<xsl:with-param name="traits" select="./src:trait"/>
		</xsl:call-template>
		<!--<div class="statblock_tags">
			<xsl:for-each select="./src:trait">
				<xsl:choose>
					<xsl:when test="@type != ''">
						<div class="statblock_tag fl tag_{@type}"><xsl:value-of select="."/></div>
					</xsl:when>
					<xsl:otherwise>
						<div class="statblock_tag fl"><xsl:value-of select="."/></div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<div class="clearer"></div>
		</div>-->
	</xsl:template>

	<xsl:template name="traitList">
		<xsl:param name="traits"/>
		<div class="statblock_tags">
			<xsl:for-each select="$traits">
				<xsl:choose>
					<xsl:when test="@type != ''">
						<div class="statblock_tag fl tag_{@type}"><xsl:value-of select="."/></div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="name() = 'rarity'">
								<xsl:if test="node() != 'common'">
									<div class="statblock_tag fl tag_rarity"><xsl:value-of select="."/></div>
								</xsl:if>
							</xsl:when>
							<xsl:when test="name() = 'alignment'">
								<div class="statblock_tag fl tag_alignment"><xsl:value-of select="."/></div>
							</xsl:when>
							<xsl:when test="name() = 'size'">
								<div class="statblock_tag fl tag_size"><xsl:value-of select="."/></div>
							</xsl:when>
							<xsl:when test="name() = 'type'">
								<div class="statblock_tag fl tag_creatureType"><xsl:value-of select="."/></div>
							</xsl:when>
							<xsl:otherwise>
								<div class="statblock_tag fl"><xsl:value-of select="."/></div>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<div class="clearer"></div>
		</div>
	</xsl:template>

</xsl:stylesheet>
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:src='https://github.com/dwugofski/rpgml/p2e'
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../../common/xslt/text_transform.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.header.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.rich_text.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.requirements.xslt"/>
	<xsl:import href="../common/xslt/smallblock/p2e.entries.xslt"/>

	<!-- Documentation intended for XslDoc -->

	<!-- 
		========================================================================
		Item Stat Black in HTML, Small Block Format
		========================================================================
	-->

	<!--**
		Displays the header bar of a statblock
	-->
	<xsl:template match="src:item">
		<div class="statblock item">
			<!-- Give the ID of the item -->
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			<!-- Make the header -->
			<xsl:choose>
				<xsl:when test="./src:level = 'var'">
					<xsl:call-template name="header">
						<xsl:with-param name="name" select="./src:name"/>
						<xsl:with-param name="type">Item</xsl:with-param>
						<xsl:with-param name="level" select="./src:variants/src:variant[1]/src:level"/>
						<xsl:with-param name="var" select="1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="header">
						<xsl:with-param name="name" select="./src:name"/>
						<xsl:with-param name="type">Item</xsl:with-param>
						<xsl:with-param name="level" select="./src:level"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Trait list -->
			<xsl:apply-templates select="./src:traits"/>
			<!-- Item header information -->
			<!-- The price (for a non-variant item) -->
			<div class="statblock_section">
				<xsl:if test="src:price">
					<p class="reverse_indent"><xsl:apply-templates select="src:price"/></p>
				</xsl:if>
				<p class="reverse_indent">
					<!-- How to use the item -->
					<xsl:if test="src:usage">
						<xsl:apply-templates select="src:usage"/>
						<xsl:if test="src:bulk">
							<xsl:text>; </xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:apply-templates select="src:bulk"/>
				</p>
				<p class="reverse_indent">
					<!-- How to use the item -->
					<xsl:if test="src:activate">
						<xsl:apply-templates select="src:activate"/>
					</xsl:if>
				</p>
			</div>
			<!-- Item description -->
			<xsl:if test="src:description">
				<hr/>
				<div class="statblock_section">
					<xsl:apply-templates select="src:description"/>
				</div>
			</xsl:if>
			<!-- Item variant information -->
			<xsl:for-each select="src:variants/src:variant">
				<hr/>
				<div class="statblock_section">
					<p class="reverse_indent">
						<strong><xsl:text>Type </xsl:text></strong>
						<xsl:value-of select="src:type"/>
						<xsl:if test="src:level">
							<xsl:if test="src:type">
								<xsl:text>; </xsl:text>
							</xsl:if>
							<strong><xsl:text>Level </xsl:text></strong>
							<xsl:value-of select="src:level"/>
						</xsl:if>
						<xsl:if test="src:price">
							<xsl:if test="(src:level) or (src:type)">
								<xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:apply-templates select="src:price"/>
						</xsl:if>
					</p>
					<xsl:if test="src:description">
						<xsl:apply-templates select="src:description"/>
					</xsl:if>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!--**
		Describes how an item is activated
	-->
	<xsl:template match="src:activate">
		<p>
			<strong><xsl:text>Activate </xsl:text></strong>
			<xsl:call-template name="actionCountImg">
				<xsl:with-param name="count" select="./src:actCount"/>
			</xsl:call-template>
			<xsl:if test="./src:actName">
				<xsl:value-of select="./src:actName"/><xsl:text>; </xsl:text>
			</xsl:if>
			<xsl:if test="./src:trigger">
				<strong><xsl:text>Trigger </xsl:text></strong>
				<xsl:value-of select="./src:trigger"/><xsl:text>; </xsl:text>
			</xsl:if>
			<xsl:if test="./src:reqs">
				<strong><xsl:text>Requirements </xsl:text></strong>
				<xsl:for-each select="./src:reqs/src:req">
					<xsl:if test="position() > 1">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="./src:effect">
				<strong><xsl:text>Effect </xsl:text></strong>
				<!-- Add the first paragraph in-line -->
				<xsl:apply-templates select="./src:effect/src:p[1]" mode="enclosed_rich_paragraph"/>
			</xsl:if>
		</p>
		<!-- Should add the rest of the effect description as separate paragraphs -->
		<xsl:for-each select="./src:effect/src:p">
			<xsl:if test="position() > 1">
				<xsl:apply-templates/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!--**
		Provides the price of an item
	-->
	<xsl:template match="src:price">
		<strong><xsl:text>Price </xsl:text></strong>
		<xsl:value-of select="src:int"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="src:coin"/>
		<xsl:if test="src:special">
			<xsl:text> </xsl:text>
			<xsl:value-of select="src:special"/>
		</xsl:if>
	</xsl:template>

	<!--**
		Describes how an item is used
	-->
	<xsl:template match="src:usage">
		<strong><xsl:text>Usage </xsl:text></strong>
		<xsl:text>: </xsl:text>
		<xsl:value-of select="."/>
	</xsl:template>

	<!--**
		Describes the bulk of an item
	-->
	<xsl:template match="src:bulk">
		<strong><xsl:text>Bulk </xsl:text></strong>
		<xsl:choose>
			<xsl:when test=". = none">&#8212;</xsl:when>
			<xsl:when test=". = light">L</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
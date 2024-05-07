<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:src="https://github.com/dwugofski/rpgml/p2e" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Documentation intended for XslDoc -->

	<!-- 
		========================================================================
		Rich Text Output
		========================================================================
	-->

	<!--**
		Displays a line break
	-->
	<xsl:template match='src:br'>
		<br/>
	</xsl:template>

	<!--**
		Displays strong (i.e. bold) text
	-->
	<xsl:template match='src:strong'>
		<strong>
			<xsl:apply-templates/>
		</strong>
	</xsl:template>

	<!--**
		Displays emphasized (i.e. italics) text
	-->
	<xsl:template match='src:em'>
		<em>
			<xsl:apply-templates/>
		</em>
	</xsl:template>

	<!--**
		Displays unarticulated (i.e. underlined) text
	-->
	<xsl:template match='src:u'>
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>

	<!--**
		Displays citational (i.e. underlined) text
	-->
	<xsl:template match='src:cite'>
		<cite>
			<xsl:apply-templates/>
		</cite>
	</xsl:template>

	<!--**
		Displays marked (i.e. highlighted) text
	-->
	<xsl:template match='src:mark'>
		<mark>
			<xsl:apply-templates/>
		</mark>
	</xsl:template>

	<!--**
		Displays roll text
	-->
	<xsl:template match='src:roll'>
		<span class="entry roll">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<!--**
		Displays a list item
	-->
	<xsl:template match='src:li'>
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<!--**
		Displays an unordered (i.e. bulletted) list
	-->
	<xsl:template match='src:ul'>
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<!--**
		Displays an ordered (i.e. numbered) list
	-->
	<xsl:template match='src:ol'>
		<ol>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>

	<!--**
		Displays a horizontal rule
	-->
	<xsl:template match='src:hr'>
		<hr/>
	</xsl:template>

	<!--**
		Displays a paragraph of text
	-->
	<xsl:template match='src:p'>
		<p>
			<xsl:if test="@class">
				<xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<!--**
		Displays a paragraph of text
	-->
	<xsl:template match='src:p' mode="enclosed_rich_paragraph">
		<xsl:apply-templates/>
	</xsl:template>

	<!--**
		Displays a paragraph of text
	-->
	<xsl:template match='src:p//text()'>
		<xsl:value-of select="."/>
	</xsl:template>

	<!--**
		Displays a rich text paragraph, but without any enclosing paragraph tags
	-->
	<xsl:template name="enclosed_rich_paragraph">
		<xsl:apply-templates/>
	</xsl:template>

	<!--**
		Displays a rich text paragraph with enclosing paragraph tags
	-->
	<xsl:template name="rich_paragraph">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<!--**
		Displays a check result
	-->
	<xsl:template match="src:checkResult">
		<div class="checkResult">
			<xsl:if test="./src:critSuccess">
				<p>
					<strong>Critical Success</strong><xsl:text>: </xsl:text>
					<xsl:apply-templates select="./src:critSuccess"/>
				</p>
			</xsl:if>
			<xsl:if test="./src:success">
				<p>
					<strong>Success</strong><xsl:text>: </xsl:text>
					<xsl:apply-templates select="./src:success"/>
				</p>
			</xsl:if>
			<xsl:if test="./src:fail">
				<p>
					<strong>Failure</strong><xsl:text>: </xsl:text>
					<xsl:apply-templates select="./src:fail"/>
				</p>
			</xsl:if>
			<xsl:if test="./src:critFail">
				<p>
					<strong>Critical Failure</strong><xsl:text>: </xsl:text>
					<xsl:apply-templates select="./src:critFail"/>
				</p>
			</xsl:if>
		</div>
	</xsl:template>

</xsl:stylesheet>
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Documentation intended for XslDoc -->

	<!--**
		A number which has a +/- sign, even if positive
	-->
	<xsl:template name="diff_int">
		<xsl:param name="value"/>
		<xsl:if test="$value > 0">
			<xsl:text>+</xsl:text>
		</xsl:if>
		<xsl:value-of select="$value"/>
	</xsl:template>

	<!--**
		A number in english
	-->
	<xsl:template name="num_to_word">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="number($value) = 1">
				<xsl:text>one</xsl:text>
			</xsl:when>
			<xsl:when test="number($value) = 2">
				<xsl:text>two</xsl:text>
			</xsl:when>
			<xsl:when test="number($value) = 3">
				<xsl:text>three</xsl:text>
			</xsl:when>
			<xsl:when test="number($value) = 4">
				<xsl:text>four</xsl:text>
			</xsl:when>
			<xsl:when test="number($value) = 5">
				<xsl:text>five</xsl:text>
			</xsl:when>
			<xsl:when test="number($value) = 6">
				<xsl:text>six</xsl:text>
			</xsl:when>
			<xsl:when test="number($value) = 7">
				<xsl:text>seven</xsl:text>
			</xsl:when>
			<xsl:when test="number($value) = 8">
				<xsl:text>eight</xsl:text>
			</xsl:when>
			<xsl:when test="number($value) = 9">
				<xsl:text>nine</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--**
		Get the ordinal suffix for an number (e.g. 'st' for 1, since 1->1st)
	-->
	<xsl:template name="ordinal_suff">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="(floor((number($value) mod 100) div 10)) = 1">
				<xsl:text>th</xsl:text>
			</xsl:when>
			<xsl:when test="(number($value) mod 10) = 1">
				<xsl:text>st</xsl:text>
			</xsl:when>
			<xsl:when test="(number($value) mod 10) = 2">
				<xsl:text>nd</xsl:text>
			</xsl:when>
			<xsl:when test="(number($value) mod 10) = 3">
				<xsl:text>rd</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>th</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--**
		Get a number with its ordinal suffix (e.g. 1->'1st')
	-->
	<xsl:template name="ordinal">
		<xsl:param name="value"/>
		<xsl:value-of select="$value"/>
		<xsl:call-template name="ordinal_suff">
			<xsl:with-param name="value" select="$value"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:src="https://github.com/dwugofski/rpgml/p2e" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="./p2e.rich_text.xslt"/>

	<!-- Documentation intended for XslDoc -->

	<!-- 
		========================================================================
		SIMPLE/TEXTUAL ENTRIES IN A STATBLOCK
		========================================================================
	-->

	<!--**
		Display a simple "Title: text..." entry
	-->
	<xsl:template name="simple_entry">
		<xsl:param name="title"/>
		<xsl:param name="classname"/>
		<span>
			<xsl:attribute name="class"><xsl:text>entry simple </xsl:text><xsl:value-of select="$classname"/></xsl:attribute>
			<xsl:if test="$title">
				<strong><xsl:value-of select="$title"/></strong>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<!--**
		Display the statblock of a frequency entry
	-->
	<xsl:template match="src:frequency">
		<xsl:call-template name="simple_entry">
			<xsl:with-param name="title">Frequency</xsl:with-param>
			<xsl:with-param name="classname">frequency</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!--**
		Display the statblock of a trigger entry
	-->
	<xsl:template match="src:trigger">
		<xsl:call-template name="simple_entry">
			<xsl:with-param name="title">Trigger</xsl:with-param>
			<xsl:with-param name="classname">trigger</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!--**
		Display the statblock of a cost entry
	-->
	<xsl:template match="src:cost">
		<xsl:call-template name="simple_entry">
			<xsl:with-param name="title">Cost</xsl:with-param>
			<xsl:with-param name="classname">cost</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- 
		========================================================================
		NAMED NUMERIC ENTRY
		========================================================================
	-->

	<xsl:template name="named_numeric_entry">
		<xsl:param name="bold" select="false()"/>
		<xsl:param name="case" select="''"/>
		<xsl:param name="classname"/>
		<xsl:param name="name" select="''"/>
		<xsl:param name="isMod" select="false()"/>
		<xsl:param name="numeric"  select="''"/>
		<xsl:param name="units"  select="''"/>
		<xsl:param name="modifier"/>
		<xsl:param name="extra"/>
		<span>
			<xsl:attribute name="class"><xsl:text>entry numeric </xsl:text><xsl:value-of select="$classname"/></xsl:attribute>
			<xsl:if test="not($name = '')">
				<xsl:choose>
					<xsl:when test="$bold">
						<strong>
							<xsl:call-template name="Tsetcase">
								<xsl:with-param name="text" select="$name"/>
								<xsl:with-param name="case" select="$case"/>
							</xsl:call-template>
							<xsl:text> </xsl:text>
						</strong>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="Tsetcase">
							<xsl:with-param name="text" select="$name"/>
							<xsl:with-param name="case" select="$case"/>
						</xsl:call-template>
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$isMod = true() and $numeric &gt;= 0">
				<xsl:text>+</xsl:text>
			</xsl:if>
			<xsl:apply-templates select="$numeric"/>
			<xsl:if test="$units">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$units"/>
			</xsl:if>
			<xsl:if test="$modifier">
				<xsl:text> (</xsl:text>
				<xsl:apply-templates select="$modifier"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:if test="$extra">
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="$extra"/>
			</xsl:if>
		</span>
	</xsl:template>

	<!-- 
		========================================================================
		LIST ENTRIES IN A STATBLOCK
		========================================================================
	-->

	<!--**
		Display an entry with a simple "Title: list..." entry, where lists
		are separated by a delimiter
	-->
	<xsl:template name="delimiter_list_entry">
		<xsl:param name="bold" select="true()"/>
		<xsl:param name="case" select="''"/>
		<xsl:param name="title"/>
		<xsl:param name="classname"/>
		<xsl:param name="items"/>
		<xsl:param name="delimiter" select="','"/>
		<xsl:param name="terminator" select="'and'"/>
		<xsl:param name="modifier"/>
		<xsl:param name="extra"/>
		<span>
			<xsl:attribute name="class"><xsl:text>entry delimiter_list </xsl:text><xsl:value-of select="$classname"/></xsl:attribute>
			<xsl:if test="$title">
				<xsl:choose>
					<xsl:when test="$bold">
						<strong>
							<xsl:call-template name="Tsetcase">
								<xsl:with-param name="text" select="$title"/>
								<xsl:with-param name="case" select="$case"/>
							</xsl:call-template>
							<xsl:text> </xsl:text>
						</strong>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="Tsetcase">
							<xsl:with-param name="text" select="$title"/>
							<xsl:with-param name="case" select="$case"/>
						</xsl:call-template>
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:for-each select="$items">
				<xsl:if test="position() &gt; 1">
					<xsl:choose>
						<!-- If we have <= 2 items and we want a terminator (e.g.
						"and"), don't put a delimiter -->
						<xsl:when test="count($items) &lt;= 2 and $terminator">
							<xsl:text> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$delimiter"/><xsl:text> </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$terminator">
						<xsl:if test="position() = last()">
							<xsl:value-of select="$terminator"/><xsl:text> </xsl:text>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:apply-templates select="."/>
			</xsl:for-each>
			<xsl:if test="$modifier">
				<xsl:text> (</xsl:text>
				<xsl:apply-templates select="$modifier"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:if test="$extra">
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="$extra"/>
			</xsl:if>
		</span>
	</xsl:template>

	<!-- 
		========================================================================
		RICH PARAGRAPH ENTRIES IN A STATBLOCK
		========================================================================
	-->

	<!--**
		Display a simple "[Title: ]text..." entry, where the text is a series
		of rich text paragraph/block containers.
	-->
	<xsl:template name="rich_container_entry">
		<xsl:param name="title"/>
		<xsl:param name="classname"/>
		<div>
			<xsl:attribute name="class"><xsl:text>entry rich_container </xsl:text><xsl:value-of select="$classname"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="$title">
					<xsl:for-each select="./*">
						<xsl:choose>
							<xsl:when test="position() = 1">
								<!-- Via XSD, we can assume 1st entry is paragraph -->
								<p>
									<strong><xsl:value-of select="$title"/><xsl:text> </xsl:text></strong>
									<xsl:apply-templates/>
								</p>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<!--**
		Description text
	-->
	<xsl:template match="src:description">
		<xsl:call-template name="rich_container_entry">
			<xsl:with-param name="classname">desc</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!--**
		Special text
	-->
	<xsl:template match="src:special">
		<xsl:call-template name="rich_container_entry">
			<xsl:with-param name="title">Special</xsl:with-param>
			<xsl:with-param name="classname">special desc</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
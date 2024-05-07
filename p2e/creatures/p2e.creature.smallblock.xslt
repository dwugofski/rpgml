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
		Creature Stat Black in HTML, Small Block Format
		========================================================================
	-->

	<xsl:template match="src:creature">
		<div class="statblock creature">
			<!-- Give the ID attribute -->
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			<!-- Make the header bar -->
			<xsl:call-template name="header">
				<xsl:with-param name="name" select="./src:name"/>
				<xsl:with-param name="type">Creature</xsl:with-param>
				<xsl:with-param name="level" select="./src:level"/>
			</xsl:call-template>
			<!-- Display the traits -->
			<xsl:call-template name="traitList">
				<xsl:with-param name="traits" select="./src:rarity | ./src:size | ./src:types/src:type | ./src:alignment | ./src:traits/src:trait"/>
			</xsl:call-template>
			<!-- Display Perception -->
			<p>
				<xsl:call-template name="named_numeric_entry">
					<xsl:with-param name="bold" select="true()"/>
					<xsl:with-param name="case" select="'camel'"/>
					<xsl:with-param name="name" select="'Perception'"/>
					<xsl:with-param name="isMod" select="true()"/>
					<xsl:with-param name="numeric" select="./src:perception/src:int"/>
					<xsl:with-param name="modifier" select="./src:perception/src:modifier"/>
					<xsl:with-param name="extra" select="./src:perception/src:extra"/>
				</xsl:call-template>
			</p>
			<!-- Display Languages -->
			<p>
				<span>
					<xsl:attribute name="class"><xsl:text>entry delimiter_list languages</xsl:text></xsl:attribute>
					<strong><xsl:text>Languages </xsl:text></strong>
					<xsl:for-each select="./src:languages/src:language | ./src:languages/src:modifier">
						<xsl:if test="position() &gt; 1">
							<xsl:choose>
								<xsl:when test="name() = 'modifier'">
									<xsl:text> </xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>, </xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="name() = 'modifier'">
								<xsl:text>(</xsl:text>
								<xsl:value-of select="."/>
								<xsl:text>)</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:if test="count(./src:languages/src:extra) &gt; 0">
						<xsl:if test="count(./src:languages/src:language) &gt; 0">
							<xsl:text>; </xsl:text>
							<xsl:for-each select="./src:languages/src:extra">
								<xsl:if test="position() &gt; 1">
									<xsl:text>, </xsl:text>
								</xsl:if>
								<xsl:value-of select="."/>
							</xsl:for-each>
						</xsl:if>
					</xsl:if>
				</span>
			</p>
			<!-- Display skills -->
			<p>
				<xsl:call-template name="delimiter_list_entry">
					<xsl:with-param name="title" select="'Skills'"/>
					<xsl:with-param name="classname" select="'skills'"/>
					<xsl:with-param name="items" select="./src:skills/src:skill"/>
					<xsl:with-param name="delimiter" select="','"/>
					<xsl:with-param name="terminator" select="''"/>
					<xsl:with-param name="modifier" select="./src:skills/src:modifier"/>
					<xsl:with-param name="extra" select="./src:skills/src:extra"/>
				</xsl:call-template>
			</p>
			<!-- Display abilities -->
			<p>
				<xsl:call-template name="delimiter_list_entry">
					<xsl:with-param name="title" select="''"/>
					<xsl:with-param name="classname" select="'abilities'"/>
					<xsl:with-param name="items" select="./src:abilities/child::*"/>
					<xsl:with-param name="delimiter" select="','"/>
					<xsl:with-param name="terminator" select="''"/>
					<xsl:with-param name="modifier" select="./src:abilities/src:modifier"/>
					<xsl:with-param name="extra" select="./src:abilities/src:extra"/>
				</xsl:call-template>
			</p>
			<!-- Display items -->
			<xsl:if test="count(src:items/src:item) &gt; 0">
				<p>
					<xsl:call-template name="delimiter_list_entry">
						<xsl:with-param name="title" select="'Items'"/>
						<xsl:with-param name="classname" select="'items'"/>
						<xsl:with-param name="items" select="./src:items/src:item"/>
						<xsl:with-param name="delimiter" select="','"/>
						<xsl:with-param name="terminator" select="''"/>
						<xsl:with-param name="modifier" select="./src:items/src:modifier"/>
						<xsl:with-param name="extra" select="./src:items/src:extra"/>
					</xsl:call-template>
				</p>
			</xsl:if>
			<!-- Display interaction features -->
			<xsl:if test="count(./src:interactions/src:featSum) != 0">
				<div>
					<xsl:attribute name="class">interactions</xsl:attribute>
					<xsl:apply-templates select="./src:interactions/src:featSum"/>
				</div>
			</xsl:if>
			<hr/>
			<!-- Display saves -->
			<p>
				<xsl:call-template name="delimiter_list_entry">
					<xsl:with-param name="title" select="''"/>
					<xsl:with-param name="classname" select="'armor_saves'"/>
					<xsl:with-param name="items" select="src:armor | ./src:saves/child::*"/>
					<xsl:with-param name="delimiter" select="','"/>
					<xsl:with-param name="terminator" select="''"/>
					<xsl:with-param name="modifier" select="./src:saves/src:modifier"/>
					<xsl:with-param name="extra" select="./src:saves/src:extra"/>
				</xsl:call-template>
			</p>
			<!-- Display HP, weaknesses, and immunities -->
			<p>
				<xsl:call-template name="delimiter_list_entry">
					<xsl:with-param name="title" select="''"/>
					<xsl:with-param name="classname" select="'dmg_details'"/>
					<xsl:with-param name="items" select="src:hitpoints | ./src:immunities[count(child::*) != 0] | ./src:weaknesses[count(child::*) != 0] | src:resistances[count(child::*) != 0]"/>
					<xsl:with-param name="delimiter" select="';'"/>
					<xsl:with-param name="terminator" select="''"/>
				</xsl:call-template>
			</p>
			<!-- Display off-turn features -->
			<xsl:if test="count(./src:offturn/src:featSum) != 0">
				<div>
					<xsl:attribute name="class">offturn</xsl:attribute>
					<xsl:apply-templates select="./src:offturn/src:featSum"/>
				</div>
			</xsl:if>
			<hr/>
			<!-- Display speeds -->
			<p>
				<xsl:call-template name="delimiter_list_entry">
					<xsl:with-param name="title" select="'Speed'"/>
					<xsl:with-param name="classname" select="'speeds'"/>
					<xsl:with-param name="items" select="./src:speeds[count(src:int) &gt; 0] | ./src:speeds/src:speed"/>
					<xsl:with-param name="delimiter" select="','"/>
					<xsl:with-param name="terminator" select="''"/>
				</xsl:call-template>
			</p>
			<!-- Display attacks -->
			<xsl:if test="count(./src:attacks/src:attack) != 0">
				<div>
					<xsl:attribute name="class">attacks</xsl:attribute>
					<xsl:apply-templates select="./src:attacks/src:attack"/>
				</div>
			</xsl:if>
			<!-- Display spells -->
			<!-- Display on-turn features -->
			<xsl:if test="count(./src:onturn/src:featSum) != 0">
				<div>
					<xsl:attribute name="class">onturn</xsl:attribute>
					<xsl:apply-templates select="./src:onturn/src:featSum"/>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="src:skill">
		<xsl:call-template name="named_numeric_entry">
			<xsl:with-param name="bold" select="false()"/>
			<xsl:with-param name="case" select="'camel'"/>
			<xsl:with-param name="classname" select="'skill'"/>
			<xsl:with-param name="name" select="./src:name"/>
			<xsl:with-param name="isMod" select="true()"/>
			<xsl:with-param name="numeric" select="./src:int"/>
			<xsl:with-param name="modifier" select="./src:modifier"/>
			<xsl:with-param name="extra" select="./src:extra"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="src:abilities/child::*">
		<xsl:call-template name="named_numeric_entry">
			<xsl:with-param name="bold" select="true()"/>
			<xsl:with-param name="case" select="'first'"/>
			<xsl:with-param name="classname" select="'ability name()'"/>
			<xsl:with-param name="name" select="substring(name(),1,3)"/>
			<xsl:with-param name="isMod" select="true()"/>
			<xsl:with-param name="numeric" select="./src:int"/>
			<xsl:with-param name="modifier" select="./src:modifier"/>
			<xsl:with-param name="extra" select="./src:extra"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="src:saves/child::*">
		<xsl:call-template name="named_numeric_entry">
			<xsl:with-param name="bold" select="true()"/>
			<xsl:with-param name="case" select="'first'"/>
			<xsl:with-param name="classname" select="'save name()'"/>
			<xsl:with-param name="name" select="name()"/>
			<xsl:with-param name="isMod" select="true()"/>
			<xsl:with-param name="numeric" select="./src:int"/>
			<xsl:with-param name="modifier" select="./src:modifier"/>
			<xsl:with-param name="extra" select="./src:extra"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="src:armor">
		<xsl:call-template name="named_numeric_entry">
			<xsl:with-param name="bold" select="true()"/>
			<xsl:with-param name="case" select="'upper'"/>
			<xsl:with-param name="classname" select="'armor'"/>
			<xsl:with-param name="name" select="'AC'"/>
			<xsl:with-param name="isMod" select="true()"/>
			<xsl:with-param name="numeric" select="./src:int"/>
			<xsl:with-param name="modifier" select="./src:modifier"/>
			<xsl:with-param name="extra" select="./src:extra"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="src:hitpoints">
		<xsl:call-template name="named_numeric_entry">
			<xsl:with-param name="bold" select="true()"/>
			<xsl:with-param name="case" select="'upper'"/>
			<xsl:with-param name="classname" select="'hitpoints'"/>
			<xsl:with-param name="name" select="'HP'"/>
			<xsl:with-param name="isMod" select="false()"/>
			<xsl:with-param name="numeric" select="./src:int"/>
			<xsl:with-param name="modifier" select="./src:modifier"/>
			<xsl:with-param name="extra" select="./src:extra"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="src:immunities | src:weaknesses | src:resistances">
		<xsl:call-template name="delimiter_list_entry">
			<xsl:with-param name="bold" select="true()"/>
			<xsl:with-param name="case" select="'first'"/>
			<xsl:with-param name="title" select="name()"/>
			<xsl:with-param name="classname" select="'dmg_details'"/>
			<xsl:with-param name="items" select="./child::*"/>
			<xsl:with-param name="delimiter" select="','"/>
			<xsl:with-param name="terminator" select="''"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="src:immunity">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="src:weakness | src:resistance">
		<xsl:call-template name="named_numeric_entry">
			<xsl:with-param name="bold" select="false()"/>
			<xsl:with-param name="case" select="'lower'"/>
			<xsl:with-param name="classname" select="'hitpoints'"/>
			<xsl:with-param name="name" select="./src:name"/>
			<xsl:with-param name="isMod" select="false()"/>
			<xsl:with-param name="numeric" select="./src:int"/>
			<xsl:with-param name="modifier" select="./src:modifier"/>
			<xsl:with-param name="extra" select="./src:extra"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="src:speeds | src:speed">
		<xsl:call-template name="named_numeric_entry">
			<xsl:with-param name="bold" select="false()"/>
			<xsl:with-param name="case" select="'lower'"/>
			<xsl:with-param name="classname" select="'speed'"/>
			<xsl:with-param name="name">
				<xsl:if test="name() = 'speed'">
					<xsl:value-of select="src:name"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="isMod" select="false()"/>
			<xsl:with-param name="numeric" select="./src:int"/>
			<xsl:with-param name="units" select="'feet'"/>
			<xsl:with-param name="modifier" select="./src:modifier"/>
			<xsl:with-param name="extra" select="./src:extra"/>
		</xsl:call-template>
	</xsl:template>

	<!-- 
		========================================================================
		FEAT SUMMARY ENTRIES IN A STATBLOCK
		========================================================================
	-->

	<xsl:template match="src:featSum">
		<div>
			<xsl:attribute name="class">entry featsum</xsl:attribute>
			<p>
				<strong>
					<xsl:value-of select="./src:name"/>
					<xsl:text> </xsl:text>
				</strong>
				<span><xsl:attribute name="class">actcount count_<xsl:value-of select="./src:actCount"/></xsl:attribute></span>
				<xsl:if test="count(./src:traits/src:trait) &gt; 0">
					<xsl:text>(</xsl:text>
					<xsl:for-each select="./src:traits/src:trait">
						<xsl:if test="position() &gt; 1">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:value-of select="."/>
					</xsl:for-each>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<xsl:text> </xsl:text>
				<xsl:if test="./src:frequency">
					<xsl:apply-templates select="./src:frequency"/>
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:if test="./src:trigger">
					<xsl:apply-templates select="./src:trigger"/>
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:for-each select="./src:description/src:p[1]">
					<xsl:if test="count(../../src:frequency | ../../src:trigger) != 0">
						<strong><xsl:text>Effect </xsl:text></strong>
					</xsl:if>
					<xsl:apply-templates/>
				</xsl:for-each>
			</p>
			<xsl:for-each select="./src:description/src:p[position()&gt;1]">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
			<xsl:apply-templates select="./src:special"/>
		</div>
	</xsl:template>

	<!-- 
		========================================================================
		ATTACK SUMMARY ENTRIES IN A STATBLOCK
		========================================================================
	-->

	<xsl:template match="src:attack">
		<div>
			<xsl:attribute name="class">entry attack</xsl:attribute>
			<p>
				<strong>
					<xsl:call-template name="Tcamelcase">
						<xsl:with-param name="text" select="src:type"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
				</strong>
				<xsl:call-template name="named_numeric_entry">
					<xsl:with-param name="bold" select="false()"/>
					<xsl:with-param name="case" select="'lower'"/>
					<xsl:with-param name="classname" select="'atackmod'"/>
					<xsl:with-param name="name" select="./src:name"/>
					<xsl:with-param name="isMod" select="true()"/>
					<xsl:with-param name="numeric" select="./src:int"/>
					<xsl:with-param name="modifier" select="./src:modifier | ./src:traits/src:trait"/>
					<xsl:with-param name="extra" select="./src:extra"/>
				</xsl:call-template>
				<xsl:text>, </xsl:text>
				<xsl:call-template name="delimiter_list_entry">
					<xsl:with-param name="bold" select="true()"/>
					<xsl:with-param name="case" select="'first'"/>
					<xsl:with-param name="classname" select="'atackresult'"/>
					<xsl:with-param name="title">
						<xsl:choose>
							<xsl:when test="count(src:result/src:damage) != 0">Damage</xsl:when>
							<xsl:otherwise>Effect</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="items" select="./src:result/child::*"/>
					<xsl:with-param name="delimiter" select="','"/>
					<xsl:with-param name="terminator" select="'and'"/>
				</xsl:call-template>
			</p>
		</div>
	</xsl:template>

	<xsl:template match="src:attack/src:traits/src:trait">
		<xsl:if test="node() != ../src:trait[1]">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="src:attack/src:modifier">
		<xsl:value-of select="."/>
		<xsl:if test="count(../src:traits/src:trait) != 0">
			<xsl:text>; </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="src:damage">
		<span>
			<xsl:attribute name="class"><xsl:text>entry numeric roll damage</xsl:text></xsl:attribute>
			<xsl:apply-templates select="src:roll"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="src:name"/>
			<xsl:if test="src:modifier">
				<xsl:text> (</xsl:text>
				<xsl:value-of select="src:modifier"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</span>
	</xsl:template>


</xsl:stylesheet>

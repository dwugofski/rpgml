<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="3.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:dnd="https://github.com/dwugofski/rpgml/dnd5e"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../../common/xslt/text_transform.xslt"/>
	<xsl:import href="../../common/xslt/numerics.xslt"/>
	<xsl:import href="../../common/xslt/html/rich_text.xslt"/>
	<xsl:import href="../common/xslt/dnd5e.lists.xslt"/>

	<!--xsl:output method="html" indent="no"/-->
	<xsl:strip-space elements="*"/>

	<!-- Documentation intended for XslDoc -->

	<!-- 
		========================================================================
		Stat Block Header Bar
		========================================================================
	-->

	<!--**
		Display the statblock
	-->
	<xsl:template match="dnd:creature">
		<div class="statblock creature">
			<!-- Give the ID of the creature -->
			<xsl:attribute name="id">sb_creature_<xsl:value-of select="@id"/></xsl:attribute>

			<!-- Give the name, size, type, and alignment of the creature -->
			<div class="header">
				<h1>
					<xsl:value-of select="./dnd:name"/>
				</h1>
				<h6>
					<xsl:value-of select="./dnd:size"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./dnd:creatureType"/>
					<xsl:if test="./dnd:creatureSubtype">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="./dnd:creatureSubtype"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>, </xsl:text>
					<xsl:apply-templates select="./dnd:alignment"/>
				</h6>
			</div>

			<hr/>

			<!-- Give the AC, HP, and speed -->
			<div>
				<p>
					<strong>Armor Class</strong>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./dnd:ac/dnd:int"/>
					<xsl:if test="(./dnd:ac/dnd:extra) or (./dnd:ac/dnd:modifier)">
						<xsl:text> (</xsl:text>
						<xsl:if test="./dnd:ac/dnd:extra">
							<xsl:apply-templates select="./dnd:ac/dnd:extra"/>
							<xsl:if test="./dnd:ac/dnd:modifier">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:if>
						<xsl:if test="./dnd:ac/dnd:modifier">
							<xsl:apply-templates select="./dnd:ac/dnd:modifier"/>
						</xsl:if>
						<xsl:text>)</xsl:text>
					</xsl:if>
				</p>
				<p>
					<strong>Hit Points</strong>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./dnd:hp/dnd:int"/>
					<xsl:if test="./dnd:hp/dnd:roll">
						<xsl:text> (</xsl:text>
						<xsl:apply-templates select="./dnd:hp/dnd:roll"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
				</p>
				<p>
					<strong>Speed</strong>
					<xsl:text> </xsl:text>
					<xsl:if test="./dnd:speed/dnd:int">
						<xsl:apply-templates select="./dnd:speed/dnd:int"/>
						<xsl:text> ft.</xsl:text>
						<xsl:if test="./dnd:speed/dnd:modifier">
							<xsl:text> (</xsl:text>
							<xsl:if test="./dnd:speed/dnd:modifier">
								<xsl:apply-templates select="./dnd:speed/dnd:modifier"/>
							</xsl:if>
							<xsl:text>)</xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:for-each select="./dnd:speed/dnd:altspeed">
						<xsl:if test="(position() > 1) or (count(../dnd:int) > 0)">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:value-of select="@type"/>
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="./dnd:int"/>
						<xsl:text> ft.</xsl:text>
						<xsl:if test="./dnd:modifier">
							<xsl:text> (</xsl:text>
							<xsl:if test="./dnd:modifier">
								<xsl:apply-templates select="./dnd:modifier"/>
							</xsl:if>
							<xsl:text>)</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</p>
			</div>

			<hr/>

			<!-- The list of abilities -->
			<div class="statblockAbilities">
				<table>
					<tr>
						<xsl:for-each select="./dnd:abilities/dnd:ablval">
							<th>
								<xsl:call-template name="Tability_short">
									<xsl:with-param name="ability" select="@type"/>
								</xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
					<tr>
						<xsl:for-each select="./dnd:abilities/dnd:ablval">
							<td>
								<xsl:value-of select="./dnd:int[1]"/>
								<xsl:text> (</xsl:text>
								<xsl:call-template name="diff_int">
									<xsl:with-param name="value">
										<xsl:choose>
											<xsl:when test="./dnd:int[2]">
												<xsl:value-of select="./dnd:int[2]"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="floor((number(./dnd:int[1]) - 10) div 2)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
								</xsl:call-template>
								<xsl:text>)</xsl:text>
							</td>
						</xsl:for-each>
					</tr>
				</table>
			</div>

			<hr/>

			<!-- The list of numeric attributes -->
			<div>
				<!-- TODO: Saves -->

				<xsl:if test="count(./dnd:skills/dnd:skillmod) > 0">
					<p class="skills">
						<strong>Skills</strong>
						<xsl:text> </xsl:text>
						<xsl:for-each select="./dnd:skills/dnd:skillmod">
							<xsl:if test="position() > 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:call-template name="Tskill">
								<xsl:with-param name="skill" select="@type"/>
							</xsl:call-template>
							<xsl:text> </xsl:text>
							<xsl:call-template name="diff_int">
								<xsl:with-param name="value" select="./dnd:int"/>
							</xsl:call-template>
							<xsl:if test="./dnd:modifier">
								<xsl:text> (</xsl:text>
								<xsl:apply-templates select="./dnd:modifier"/>
								<xsl:text>)</xsl:text>
							</xsl:if>
						</xsl:for-each>
					</p>
				</xsl:if>

				<xsl:if test="count(./dnd:vulnerabilities/dnd:damageType) > 0">
					<p class="vulnerabilities">
						<strong>Damage Vulnerabilities</strong>
						<xsl:text> </xsl:text>
						<xsl:call-template name="damageTypeList">
							<xsl:with-param name="list" select="./dnd:vulnerabilities"/>
						</xsl:call-template>
					</p>
				</xsl:if>

				<xsl:if test="count(./dnd:resistances/dnd:damageType) > 0">
					<p class="resistances">
						<strong>Damage Resistances</strong>
						<xsl:text> </xsl:text>
						<xsl:call-template name="damageTypeList">
							<xsl:with-param name="list" select="./dnd:resistances"/>
						</xsl:call-template>
					</p>
				</xsl:if>

				<xsl:if test="count(./dnd:immunities/dnd:damageType) > 0">
					<p class="immunities">
						<strong>Damage Immunities</strong>
						<xsl:text> </xsl:text>
						<xsl:call-template name="damageTypeList">
							<xsl:with-param name="list" select="./dnd:immunities"/>
						</xsl:call-template>
					</p>
				</xsl:if>

				<xsl:if test="count(./dnd:condImmunities/dnd:condition) > 0">
					<p class="condImmunities">
						<strong>Condition Immunities</strong>
						<xsl:text> </xsl:text>
						<xsl:for-each select="./dnd:condImmunities/dnd:condition">
							<span class="link">
								<xsl:attribute name="type">condition</xsl:attribute>
								<xsl:attribute name="ref"><xsl:value-of select="."/></xsl:attribute>
								<xsl:call-template name="Tcapitalize">
									<xsl:with-param name="text" select="."/>
								</xsl:call-template>
							</span>
							<xsl:if test="position() != last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</p>
				</xsl:if>

				<p class="senses">
					<strong>Senses</strong>
					<xsl:text> </xsl:text>
					<xsl:for-each select="./dnd:senses/dnd:sense">
						<xsl:call-template name="Tcapitalize">
							<xsl:with-param name="text" select="@type"/>
						</xsl:call-template>
						<xsl:text> </xsl:text>
						<xsl:value-of select="./dnd:int"/>
						<xsl:text>ft.</xsl:text>
						<xsl:if test="./dnd:modifier">
							<xsl:text> (</xsl:text>
							<xsl:apply-templates select="./dnd:modifier"/>
							<xsl:text>)</xsl:text>
						</xsl:if>
						<xsl:text>, </xsl:text>
					</xsl:for-each>
					<xsl:text>Passive Perception </xsl:text>
					<xsl:value-of select="./dnd:senses/dnd:pp"/>
				</p>

				<p class="languages">
					<strong>Languages</strong>
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="count(./dnd:languages/dnd:language) > 0">
							<xsl:for-each select="./dnd:languages/dnd:language">
								<xsl:value-of select="."/>
								<xsl:if test="not(position() = last())">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>&#8212;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</p>

				<p class="cr">
					<strong>Challenge</strong>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./dnd:cr"/>
					<xsl:text> (</xsl:text>
					<xsl:choose>
						<xsl:when test="./dnd:cr = '0'"><xsl:text>0</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '1/8'"><xsl:text>25</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '1/4'"><xsl:text>50</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '1/2'"><xsl:text>100</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '1'"><xsl:text>200</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '2'"><xsl:text>450</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '3'"><xsl:text>700</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '4'"><xsl:text>1,100</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '5'"><xsl:text>1,800</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '6'"><xsl:text>2,300</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '7'"><xsl:text>2,900</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '8'"><xsl:text>3,900</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '9'"><xsl:text>5,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '10'"><xsl:text>5,900</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '11'"><xsl:text>7,200</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '12'"><xsl:text>8,400</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '13'"><xsl:text>10,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '14'"><xsl:text>11,500</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '15'"><xsl:text>13,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '16'"><xsl:text>15,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '17'"><xsl:text>18,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '18'"><xsl:text>20,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '19'"><xsl:text>22,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '20'"><xsl:text>25,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '21'"><xsl:text>33,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '22'"><xsl:text>41,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '23'"><xsl:text>50,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '24'"><xsl:text>62,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '25'"><xsl:text>75,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '26'"><xsl:text>90,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '27'"><xsl:text>105,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '28'"><xsl:text>120,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '29'"><xsl:text>135,000</xsl:text></xsl:when>
						<xsl:when test="./dnd:cr = '30'"><xsl:text>155,000</xsl:text></xsl:when>
					</xsl:choose>
					<xsl:text> XP)</xsl:text>
				</p>
			</div>
			<hr/>

			<xsl:if test="count(./dnd:feats/*) > 0">
				<div class="feats">
					<xsl:apply-templates select="./dnd:feats/*"/>
				</div>
			</xsl:if>

			<xsl:if test="count(./dnd:actions/*) > 0">
				<div class="actions">
					<h2>Actions</h2>
					<xsl:apply-templates select="./dnd:actions/node()"/>
				</div>
			</xsl:if>

			<xsl:if test="count(./dnd:legendaries/*) > 0">
				<div class="legendaries">
					<h2>Legendary Actions</h2>
					<xsl:apply-templates select="./dnd:legendaries/node()"/>
				</div>
			</xsl:if>

			<xsl:if test="count(./dnd:reactions/*) > 0">
				<div class="reactions">
					<h2>Reactions</h2>
					<xsl:apply-templates select="./dnd:reactions/node()"/>
				</div>
			</xsl:if>

		</div>
	</xsl:template>

	<!--**
		Translate an alignment to a string
	-->
	<xsl:template match="dnd:alignment">
		<xsl:choose>
			<xsl:when test=". = 'unaligned'">unaligned</xsl:when>
			<xsl:when test=". = 'any'">any</xsl:when>
			<xsl:when test=". = 'lg'">lawful good</xsl:when>
			<xsl:when test=". = 'ng'">neutral good</xsl:when>
			<xsl:when test=". = 'cg'">chaotic good</xsl:when>
			<xsl:when test=". = 'ln'">lawful neutral</xsl:when>
			<xsl:when test=". = 'nn'">neutral</xsl:when>
			<xsl:when test=". = 'cn'">chaotic neutral</xsl:when>
			<xsl:when test=". = 'le'">lawful evil</xsl:when>
			<xsl:when test=". = 'ne'">neutral evil</xsl:when>
			<xsl:when test=". = 'ce'">chaotic evil</xsl:when>
			<xsl:when test=". = '~lg'">not lawful good</xsl:when>
			<xsl:when test=". = '~ng'">not neutral good</xsl:when>
			<xsl:when test=". = '~cg'">not chaotic good</xsl:when>
			<xsl:when test=". = '~ln'">not lawful neutral</xsl:when>
			<xsl:when test=". = '~nn'">not neutral</xsl:when>
			<xsl:when test=". = '~cn'">not chaotic neutral</xsl:when>
			<xsl:when test=". = '~le'">not lawful evil</xsl:when>
			<xsl:when test=". = '~ne'">not neutral evil</xsl:when>
			<xsl:when test=". = '~ce'">not chaotic evil</xsl:when>
			<xsl:when test=". = 'l'">lawful</xsl:when>
			<xsl:when test=". = 'c'">chaotic</xsl:when>
			<xsl:when test=". = 'g'">good</xsl:when>
			<xsl:when test=". = 'e'">evil</xsl:when>
			<xsl:when test=". = '~l'">non-lawful</xsl:when>
			<xsl:when test=". = '~n'">non-neutral</xsl:when>
			<xsl:when test=". = '~c'">non-chaotic</xsl:when>
			<xsl:when test=". = '~g'">non-good</xsl:when>
			<xsl:when test=". = '~e'">non-evil</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!--**
		Translate a constraint description
	-->
	<xsl:template match="dnd:constraint">
		<xsl:choose>
			<xsl:when test="@type = 'custom'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:when test="@type = 'form'">
				<xsl:call-template name="Tcamelcase">
					<xsl:with-param name="text" select="."/>
				</xsl:call-template>
				<xsl:text> Form Only</xsl:text>
			</xsl:when>
			<xsl:when test="@type = 'day'">
				<xsl:value-of select="."/>
				<xsl:text>/Day</xsl:text>
			</xsl:when>
			<xsl:when test="@type = 'longrest'">
				<xsl:value-of select="."/>
				<xsl:text>/Long Rest</xsl:text>
			</xsl:when>
			<xsl:when test="@type = 'shortrest'">
				<xsl:value-of select="."/>
				<xsl:text>/Short Rest</xsl:text>
			</xsl:when>
			<xsl:when test="@type = 'recharge'">
				<xsl:text>Recharge </xsl:text>
				<xsl:if test="number(.) &lt; 6">
					<xsl:value-of select="."/>
					<xsl:text>&#8212;</xsl:text>
				</xsl:if>
				<xsl:text>6</xsl:text>
			</xsl:when>
			<xsl:when test="@type = 'recharge'">
				<xsl:text>Costs </xsl:text>
				<xsl:value-of select="."/>
				<xsl:text> Actions</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!--**
		Translate an area description
	-->
	<xsl:template match="dnd:area">
		<xsl:choose>
			<xsl:when test="@type = 'target'">
				<xsl:choose>
					<xsl:when test="number(./dnd:int) = 1">
						<xsl:text>one target</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="./dnd:int"/>
						<xsl:text>targets</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="./dnd:modifier">
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="./dnd:modifier"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--**
		Translate a feat description
	-->
	<xsl:template match="dnd:feat">
		<div class="feat">
			<p>
				<strong>
					<xsl:value-of select="./dnd:name"/>
					<xsl:if test="./dnd:constraint">
						<xsl:text> (</xsl:text>
						<xsl:apply-templates select="./dnd:constraint"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>.</xsl:text>
				</strong>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./dnd:description/dnd:p[1]/node()"/>
			</p>
			<xsl:for-each select="./dnd:description/*">
				<xsl:if test="position() > 1">
					<xsl:apply-templates select="."/>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!--**
		Translate an attack description
	-->
	<xsl:template match="dnd:attack">
		<div class="attack">
			<p>
				<strong>
					<xsl:value-of select="./dnd:name"/>
					<xsl:if test="./dnd:constraint">
						<xsl:text> (</xsl:text>
						<xsl:apply-templates select="./dnd:constraint"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>.</xsl:text>
				</strong>
				<xsl:text> </xsl:text>
				<em>
					<xsl:if test="./dnd:reach">
						<xsl:text>Melee</xsl:text>
						<xsl:if test="./dnd:range">
							<xsl:text> or </xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="./dnd:range">
						<xsl:text>Ranged</xsl:text>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="@type = 'weapon'">
							<xsl:text> Weapon </xsl:text>
						</xsl:when>
						<xsl:when test="@type = 'spell'">
							<xsl:text> Spell </xsl:text>
						</xsl:when>
					</xsl:choose>
					<xsl:text>Attack:</xsl:text>
				</em>
				<xsl:text> </xsl:text>
				<xsl:call-template name="diff_int">
					<xsl:with-param name="value" select="./dnd:bonus"/>
				</xsl:call-template>
				<xsl:text> to hit</xsl:text>
				<xsl:if test="(./dnd:reach) and (number(./dnd:reach) > 0)">
					<xsl:text>, reach </xsl:text>
					<xsl:value-of select="./dnd:reach"/>
					<xsl:text> ft.</xsl:text>
				</xsl:if>
				<xsl:if test="./dnd:range">
					<xsl:text>, </xsl:text>
					<xsl:if test="./dnd:reach">
						<xsl:text>or </xsl:text>
					</xsl:if>
					<xsl:text>range </xsl:text>
					<xsl:value-of select="./dnd:range/dnd:int[1]"/>
					<xsl:if test="./dnd:range/dnd:int[2]">
						<xsl:text>/</xsl:text>
						<xsl:value-of select="./dnd:range/dnd:int[2]"/>
					</xsl:if>
					<xsl:text> ft.</xsl:text>
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="./dnd:area"/>
				<xsl:text>. </xsl:text>
				<em><xsl:text>Hit:</xsl:text></em>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./dnd:description/dnd:p[1]/node()"/>
			</p>
			<xsl:for-each select="./dnd:description/*">
				<xsl:if test="position() > 1">
					<xsl:apply-templates select="."/>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!--**
		Translate a spell list
	-->
	<xsl:template match="dnd:spellcasting">
		<div class="spellList">
			<p class="spellListHeader">
				<strong>
					<xsl:text>Spellcasting</xsl:text>
					<xsl:if test="./dnd:constraint">
						<xsl:text> (</xsl:text>
						<xsl:apply-templates select="./dnd:constraint"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>.</xsl:text>
				</strong>
				<xsl:text> This creature is a </xsl:text>
				<xsl:call-template name="ordinal">
					<xsl:with-param name="value" select="./dnd:level"/>
				</xsl:call-template>
				<xsl:text>-level spellcaster. Its spellcasting ability is </xsl:text>
				<xsl:call-template name="Tcapitalize">
					<xsl:with-param name="text" select="./dnd:ability"/>
				</xsl:call-template>
				<xsl:text> (spell save DC </xsl:text>
				<xsl:value-of select="./dnd:dc"/>
				<xsl:text>, </xsl:text>
				<xsl:call-template name="diff_int">
					<xsl:with-param name="value" select="./dnd:bonus"/>
				</xsl:call-template>
				<xsl:text> to hit with spell attacks). </xsl:text>
				<xsl:if test="./dnd:specialSpells">
					<xsl:apply-templates select="./dnd:specialSpells/node()"/>
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="@type = 'prepared'">
						<xsl:text>It has the following </xsl:text>
						<xsl:value-of select="./dnd:class"/>
						<xsl:text> spells prepared:</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'spontaneous'">
						<xsl:text>It knows the following </xsl:text>
						<xsl:value-of select="./dnd:class"/>
						<xsl:text> spells:</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'pooled'">
						<xsl:text>It has </xsl:text>
						<xsl:call-template name="num_to_word">
							<xsl:with-param name="value" select="./dnd:slotPool/dnd:int"/>
						</xsl:call-template>
						<xsl:text> </xsl:text>
						<xsl:call-template name="ordinal">
							<xsl:with-param name="value" select="./dnd:slotPool/dnd:level"/>
						</xsl:call-template>
						<xsl:text>-level spell slots, which it regains after a short or long rest, and knows the following </xsl:text>
						<xsl:value-of select="./dnd:class"/>
						<xsl:text> spells:</xsl:text>
					</xsl:when>
				</xsl:choose>
			</p>
			<xsl:for-each select="./dnd:spellList/dnd:spellLevelList">
				<p class="spellLevelList">
					<xsl:choose>
						<xsl:when test="number(./dnd:level) = 0">
							<xsl:text>Cantrips (at will): </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="ordinal">
								<xsl:with-param name="value" select="./dnd:level"/>
							</xsl:call-template>
							<xsl:text>-level</xsl:text>
							<xsl:if test="./dnd:int">
								<xsl:text> (</xsl:text>
								<xsl:choose>
									<xsl:when test="number(./dnd:int) = 0">
										<xsl:text>at will</xsl:text>
									</xsl:when>
									<xsl:when test="number(./dnd:int) = 1">
										<xsl:text>1 slot</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="./dnd:int"/>
										<xsl:text> slots</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text>)</xsl:text>
							</xsl:if>
							<xsl:text>: </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:for-each select="./dnd:link">
						<xsl:if test="position() > 1">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</p>
			</xsl:for-each>
		</div>
		<xsl:apply-templates select="./dnd:description"/>
	</xsl:template>

	<xsl:template match="dnd:description">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dnd:modifier">
		<xsl:apply-templates select="./node()"/>
	</xsl:template>

	<xsl:template name="damageTypeList">
		<xsl:param name="list"/>
		<xsl:for-each select="$list/dnd:damageType">
			<xsl:call-template name="Tcapitalize">
				<xsl:with-param name="text" select="."/>
			</xsl:call-template>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="(count($list/dnd:damageType) > 0) and (count($list/dnd:specialDamageType) > 0)">
			<xsl:text>; </xsl:text>
		</xsl:if>
		<xsl:for-each select="$list/dnd:specialDamageType">
			<xsl:choose>
				<xsl:when test=". = 'nonmagical'">
					<xsl:text>Bludgeoning, Piercing, and Slashing from Nonmagical Attacks</xsl:text>
				</xsl:when>
				<xsl:when test=". = 'nonsilvered'">
					<xsl:text>Bludgeoning, Piercing, and Slashing from Nonmagical Attacks that aren't Silvered</xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="( (count($list/dnd:damageType) > 0) or (count($list/dnd:specialDamageType) > 0) ) and (count($list/dnd:customDamageType) > 0)">
			<xsl:text>; </xsl:text>
		</xsl:if>
		<xsl:for-each select="$list/dnd:customDamageType">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>


</xsl:stylesheet>
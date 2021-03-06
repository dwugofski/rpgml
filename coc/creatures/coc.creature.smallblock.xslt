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
	<xsl:template match="coc:creature">
		<div class="statblock creature">
			<!-- Give the ID of the creature -->
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>

			<!-- Give the Name, Subname of the creature -->
			<div class="header">
				<h2>NPC / Creature</h2>
				<h1>
					<!-- Give the Name of the creature in all caps -->
					<xsl:call-template name="Tall_caps">
						<xsl:with-param name="text" select="./coc:name"/>
					</xsl:call-template>
					<!-- Give the Subname of the creature, with the first letter in caps -->
					<xsl:if test="./coc:subname">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="./coc:subname"/>
					</xsl:if>
				</h1>
			</div>

			<!-- Give the characteristics of the creature -->
			<div class="characteristics">
				<p>
					<xsl:for-each select="./coc:characteristics/coc:char">
						<xsl:apply-templates select="."/>
						<xsl:if test="position() != last()">
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</p>
			</div>

			<!-- Give the core stats of the creature -->
			<div class="core_stats">
				<p>
					<xsl:if test="./coc:sanity">
						<!-- Sanity -->
						<strong>SAN:</strong><xsl:text> </xsl:text>
						<xsl:apply-templates select="./coc:sanity"/>
						<xsl:text>, </xsl:text>
					</xsl:if>

					<!-- Hit points -->
					<strong>HP:</strong><xsl:text> </xsl:text>
					<xsl:apply-templates select="./coc:hitpoints"/>
					<xsl:text>, </xsl:text>

					<xsl:if test="./coc:magic">
						<!-- Magic points -->
						<strong>MP:</strong><xsl:text> </xsl:text>
						<xsl:apply-templates select="./coc:magic"/>
						<xsl:text>, </xsl:text>
					</xsl:if>

					<!-- Build -->
					<strong>Build:</strong><xsl:text> </xsl:text>
					<xsl:apply-templates select="./coc:build"/>

					<xsl:if test="./coc:armor">
						<!-- Armor -->
						<xsl:text>, </xsl:text>
						<strong>Armor:</strong>
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="./coc:armor"/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="./coc:armor/coc:name"/>
						<xsl:text>)</xsl:text>
					</xsl:if>

					<xsl:if test="./coc:horror">
						<!-- Sanity loss -->
						<xsl:text>, </xsl:text>
						<strong>Sanity Loss:</strong>
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="./coc:horror"/>
					</xsl:if>

					<xsl:if test="./coc:dodge">
						<!-- Dodge -->
						<xsl:text>, </xsl:text>
						<strong>Dodge:</strong><xsl:text> </xsl:text>
						<xsl:apply-templates select="./coc:dodge"/>
					</xsl:if>
				</p>
			</div>

			<!-- On-turn details -->
			<div class="actions">
				<p>
					<!-- Move -->
					<strong>Move:</strong><xsl:text> </xsl:text>
					<xsl:apply-templates select="./coc:move"/>
					<xsl:text>, </xsl:text>

					<!-- Damage Bonus -->
					<strong>Damage Bonus:</strong><xsl:text> </xsl:text>
					<xsl:apply-templates select="./coc:damage-bonus"/>
				</p>
			</div>

			<hr/>

			<!-- Fighting Styles -->
			<div class="fighting">
				<xsl:choose>
					<xsl:when test="count(./coc:fighting/coc:fight) > 1">
						<p><strong>Fighting:</strong></p>
						<ul>
							<xsl:for-each select="./coc:fighting/coc:fight">
								<li>
									<strong><xsl:value-of select="./coc:name"/>:</strong>
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="."/>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<p>
							<strong>Fighting:</strong>
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="./coc:fighting/coc:fight"/>
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</div>

			<!-- Maneuvers -->
			<div class="maneuvers">
				<xsl:apply-templates select="./coc:maneuvers/coc:maneuver"/>
			</div>

			<!-- Skills -->
			<xsl:if test="count(./coc:skills/*) >= 1">
				<div class="skills">
					<p>
						<strong><xsl:text>Skills:</xsl:text></strong>
						<xsl:text> </xsl:text>
						<xsl:for-each select="./coc:skills/coc:skill">
							<xsl:call-template name="Tcamelcase">
								<xsl:with-param name="text" select="./coc:name"/>
							</xsl:call-template>
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="."/>
							<xsl:if test="position() != last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</p>
				</div>
			</xsl:if>

			<!-- Spells -->
			<xsl:if test="count(./coc:spells/*) >= 1">
				<div class="spells">
					<p>
						<strong><xsl:text>Spells:</xsl:text></strong>
						<xsl:text> </xsl:text>
						<xsl:for-each select="./coc:spells/*">
							<xsl:if test="position() > 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:apply-templates/>
						</xsl:for-each>
					</p>
				</div>
			</xsl:if>

			<!-- Descriptive Flavor Text -->
			<xsl:if test="./coc:specials">
				<hr/>
				<div class="specials">
					<xsl:apply-templates select="./coc:specials/coc:special"/>
				</div>
			</xsl:if>

		</div>
	</xsl:template>

	<!--**
		Translates a characteristic
	-->
	<xsl:template match="coc:char">
		<span class="characteristic">
			<strong>
				<xsl:choose>
					<xsl:when test="@name = 'strength'"><xsl:text>STR</xsl:text></xsl:when>
					<xsl:when test="@name = 'constitution'"><xsl:text>CON</xsl:text></xsl:when>
					<xsl:when test="@name = 'size'"><xsl:text>SIZ</xsl:text></xsl:when>
					<xsl:when test="@name = 'dexterity'"><xsl:text>DEX</xsl:text></xsl:when>
					<xsl:when test="@name = 'appearance'"><xsl:text>APP</xsl:text></xsl:when>
					<xsl:when test="@name = 'education'"><xsl:text>EDU</xsl:text></xsl:when>
					<xsl:when test="@name = 'intelligence'"><xsl:text>INT</xsl:text></xsl:when>
					<xsl:when test="@name = 'power'"><xsl:text>POW</xsl:text></xsl:when>
					<xsl:when test="@name = 'luck'"><xsl:text>LUC</xsl:text></xsl:when>
				</xsl:choose>
			</strong>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./coc:dec | ./coc:int | ./coc:na | ./coc:nan | ./coc:null | ./coc:varies | ./coc:chance"/>
			<xsl:if test="./coc:modifier">
				<xsl:text> (</xsl:text>
				<xsl:value-of select="./coc:modifier"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</span>
	</xsl:template>

	<!--**
		Translates a percent chance for something
	-->
	<xsl:template match="coc:chance">
		<span class="value chance"><xsl:value-of select="."/><xsl:text>%</xsl:text></span>
		<xsl:text> (</xsl:text>
		<span class="int">
			<xsl:choose>
				<xsl:when test="../coc:hard">
					<xsl:value-of select="../coc:hard"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="floor(number(.) div 2)"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
		<xsl:text>/</xsl:text>
		<span class="int">
			<xsl:choose>
				<xsl:when test="../coc:extreme">
					<xsl:value-of select="../coc:extreme"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="floor(number(.) div 5)"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<!--**
		Translates a modified value
	-->
	<xsl:template name="modifiedValue" match="coc:hitpoints | coc:damage-bonus | coc:build | coc:move | coc:alternate | coc:attacks | coc:fight | coc:dodge | coc:armor | coc:skill | coc:sanity | coc:magic | coc:horror | coc:attacks">
		<xsl:apply-templates select="./coc:dec | ./coc:int | ./coc:roll | ./coc:na | ./coc:nan | ./coc:null | ./coc:varies | ./coc:chance"/>
		<xsl:if test="./coc:modifier">
			<xsl:text> (</xsl:text>
			<xsl:apply-templates select="./coc:modifier"/>
			<xsl:text>)</xsl:text>
		</xsl:if>
		<xsl:if test="./coc:attacks">
			<xsl:if test="(./coc:attacks/coc:int > 1 or ./coc:attacks/coc:modifier)">
				<xsl:text> (x</xsl:text>
				<xsl:apply-templates select="./coc:attacks"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:if test="./coc:effect">
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./coc:effect/node()"/>
		</xsl:if>
		<xsl:if test="./coc:extra">
			<xsl:text>. </xsl:text>
			<xsl:apply-templates select="./coc:extra"/>
		</xsl:if>
	</xsl:template>

	<!--**
		Translate a special
	-->
	<xsl:template match="coc:special">
		<div class="special">
			<p>
				<strong>
					<xsl:value-of select="./coc:name"/>
					<xsl:text>:</xsl:text>
				</strong>
				<xsl:choose>
					<xsl:when test="@type='maneuver'">
						<strong><xsl:text> (mnvr):</xsl:text></strong>
					</xsl:when>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="coc:description/coc:p[1]/node()"/>
			</p>
			<xsl:apply-templates select="coc:description/*[position()>1]"/>
		</div>
	</xsl:template>

	<!--**
		Translate a maneuver
	-->
	<xsl:template match="coc:maneuver">
		<div class="maneuver">
			<p>
				<strong>
					<xsl:value-of select="./coc:name"/>
					<xsl:text> (mnvr):</xsl:text>
				</strong>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="coc:description/coc:p[1]/node()"/>
			</p>
			<xsl:apply-templates select="coc:description/*[position()>1]"/>
		</div>
	</xsl:template>

	<!--**
		Translate a sanity check into text
	-->
	<xsl:template match="coc:horror">
		<xsl:choose>
			<xsl:when test="count(./coc:int | ./coc:roll) > 1">
				<xsl:apply-templates select="(./coc:int | ./coc:roll)[1]"/>
				<xsl:text>/</xsl:text>
				<xsl:apply-templates select="(./coc:int | ./coc:roll)[2]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="./coc:int | ./coc:roll"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="./coc:modifier">
			<xsl:text> (</xsl:text>
			<xsl:apply-templates select="./coc:modifier"/>
			<xsl:text>)</xsl:text>
		</xsl:if>
		<xsl:if test="./coc:effect">
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./coc:effect/node()"/>
		</xsl:if>
		<xsl:if test="./coc:extra">
			<xsl:text>. </xsl:text>
			<xsl:apply-templates select="./coc:extra"/>
		</xsl:if>
	</xsl:template>

	<!--**
		Translate the damage bonus variable into text
	-->
	<xsl:template match="coc:var[@ref='dmg_bonus']">
		<span class="var dmg_bonus">
			<xsl:choose>
				<xsl:when test="../ancestor::coc:creature/coc:damage-bonus/coc:roll">
					<xsl:apply-templates select="../ancestor::coc:creature/coc:damage-bonus/coc:roll"/>
				</xsl:when>
				<xsl:when test="../ancestor::coc:creature/coc:damage-bonus/coc:int">
					<xsl:apply-templates select="../ancestor::coc:creature/coc:damage-bonus/coc:int"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>damage bonus</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="../ancestor::coc:creature/coc:damage-bonus/coc:modifier">
				<xsl:text>*</xsl:text>
			</xsl:if>
		</span>
	</xsl:template>

	<!--**
		Translate a spell
	-->
	<xsl:template match="coc:spell">
		<span class="spellref"><xsl:value-of select="."/></span>
	</xsl:template>

</xsl:stylesheet>
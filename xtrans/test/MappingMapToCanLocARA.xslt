<?xml version="1.0" encoding="UTF-8"?>
<!--
This file was generated by Altova MapForce 2015r4

YOU SHOULD NOT MODIFY THIS FILE, BECAUSE IT WILL BE
OVERWRITTEN WHEN YOU RE-RUN CODE GENERATION.

Refer to the Altova MapForce Documentation for further details.
http://www.altova.com/mapforce
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:agt="http://www.altova.com/Mapforce/agt" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="agt xs">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:template name="agt:MapToCanLocARA_var63_resultof_index_map">
		<xsl:param name="var62_current"/>
		<xsl:for-each select="$var62_current/rec">
			<rec>
				<xsl:attribute name="LOCNUM">
					<xsl:value-of select="string(position())"/>
				</xsl:attribute>
				<xsl:variable name="var1_ACCNTNUM">
					<xsl:if test="@ACCNTNUM">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="string(boolean(string($var1_ACCNTNUM))) != 'false'">
					<xsl:attribute name="ACCNTNUM">
						<xsl:value-of select="string(@ACCNTNUM)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:variable name="var2_LOCNUM">
					<xsl:if test="@LOCNUM">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="SOURCELOC">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var2_LOCNUM))) != 'false'">
							<xsl:value-of select="string(@LOCNUM)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var3_POSTALCODE">
					<xsl:if test="@POSTALCODE">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="POSTALCODE">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var3_POSTALCODE))) != 'false'">
							<xsl:value-of select="string(@POSTALCODE)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var4_STATECODE">
					<xsl:if test="@STATECODE">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="STATECODE">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var4_STATECODE))) != 'false'">
							<xsl:value-of select="string(@STATECODE)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var5_COUNTYCODE">
					<xsl:if test="@COUNTYCODE">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="COUNTYCODE">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var5_COUNTYCODE))) != 'false'">
							<xsl:value-of select="string(@COUNTYCODE)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var6_LATITUDE">
					<xsl:if test="@LATITUDE">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="LATITUDE">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var6_LATITUDE))) != 'false'">
							<xsl:value-of select="string(@LATITUDE)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var7_LONGITUDE">
					<xsl:if test="@LONGITUDE">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="LONGITUDE">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var7_LONGITUDE))) != 'false'">
							<xsl:value-of select="string(@LONGITUDE)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var8_BLDGSCHEME">
					<xsl:if test="@BLDGSCHEME">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="string(boolean(string($var8_BLDGSCHEME))) != 'false'">
					<xsl:attribute name="BLDGSCHEME">
						<xsl:value-of select="string(@BLDGSCHEME)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:variable name="var9_BLDGCLASS">
					<xsl:if test="@BLDGCLASS">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="string(boolean(string($var9_BLDGCLASS))) != 'false'">
					<xsl:attribute name="BLDGCLASS">
						<xsl:value-of select="string(@BLDGCLASS)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:variable name="var10_OCCSCHEME">
					<xsl:if test="@OCCSCHEME">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="string(boolean(string($var10_OCCSCHEME))) != 'false'">
					<xsl:attribute name="OCCSCHEME">
						<xsl:value-of select="string(@OCCSCHEME)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:variable name="var11_OCCTYPE">
					<xsl:if test="@OCCTYPE">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="string(boolean(string($var11_OCCTYPE))) != 'false'">
					<xsl:attribute name="OCCTYPE">
						<xsl:value-of select="string(@OCCTYPE)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:variable name="var12_YEARBUILT">
					<xsl:if test="@YEARBUILT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="YEARBUILT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var12_YEARBUILT))) != 'false'">
							<xsl:value-of select="string(@YEARBUILT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'12/31/9999'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var13_YEARUPGRAD">
					<xsl:if test="@YEARUPGRAD">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="YEARUPGRAD">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var13_YEARUPGRAD))) != 'false'">
							<xsl:value-of select="string(@YEARUPGRAD)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'12/31/9999'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var14_NUMSTORIES">
					<xsl:if test="@NUMSTORIES">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="NUMSTORIES">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var14_NUMSTORIES))) != 'false'">
							<xsl:value-of select="string(@NUMSTORIES)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var15_NUMBLDGS">
					<xsl:if test="@NUMBLDGS">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="NUMBLDGS">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var15_NUMBLDGS))) != 'false'">
							<xsl:value-of select="string(@NUMBLDGS)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('1')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var16_FLOORAREA">
					<xsl:if test="@FLOORAREA">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="FLOORAREA">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var16_FLOORAREA))) != 'false'">
							<xsl:value-of select="string(@FLOORAREA)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var17_WSCVVAL">
					<xsl:if test="@WSCV1VAL">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV1VAL">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var17_WSCVVAL))) != 'false'">
							<xsl:value-of select="string(@WSCV1VAL)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var18_WSCVVAL">
					<xsl:if test="@WSCV2VAL">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV2VAL">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var18_WSCVVAL))) != 'false'">
							<xsl:value-of select="string(@WSCV2VAL)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var19_WSCVVAL">
					<xsl:if test="@WSCV3VAL">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV3VAL">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var19_WSCVVAL))) != 'false'">
							<xsl:value-of select="string(@WSCV3VAL)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var20_WSCVVAL">
					<xsl:if test="@WSCV4VAL">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV4VAL">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var20_WSCVVAL))) != 'false'">
							<xsl:value-of select="string(@WSCV4VAL)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var21_WSCVVAL">
					<xsl:if test="@WSCV5VAL">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV5VAL">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var21_WSCVVAL))) != 'false'">
							<xsl:value-of select="string(@WSCV5VAL)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var22_WSCVVAL">
					<xsl:if test="@WSCV6VAL">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV6VAL">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var22_WSCVVAL))) != 'false'">
							<xsl:value-of select="string(@WSCV6VAL)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var23_WSCVVAL">
					<xsl:if test="@WSCV7VAL">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV7VAL">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var23_WSCVVAL))) != 'false'">
							<xsl:value-of select="string(@WSCV7VAL)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var24_WSCVVAL">
					<xsl:if test="@WSCV8VAL">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV8VAL">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var24_WSCVVAL))) != 'false'">
							<xsl:value-of select="string(@WSCV8VAL)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var25_WSCVVAL">
					<xsl:if test="@WSCV9VAL">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV9VAL">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var25_WSCVVAL))) != 'false'">
							<xsl:value-of select="string(@WSCV9VAL)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var26_WSCVVAL">
					<xsl:if test="@WSCV10VAL">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV10VAL">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var26_WSCVVAL))) != 'false'">
							<xsl:value-of select="string(@WSCV10VAL)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var27_WSCVLIMIT">
					<xsl:if test="@WSCV1LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV1LIMIT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var27_WSCVLIMIT))) != 'false'">
							<xsl:value-of select="string(@WSCV1LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var28_WSCVLIMIT">
					<xsl:if test="@WSCV2LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV2LIMIT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var28_WSCVLIMIT))) != 'false'">
							<xsl:value-of select="string(@WSCV2LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var29_WSCVLIMIT">
					<xsl:if test="@WSCV3LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV3LIMIT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var29_WSCVLIMIT))) != 'false'">
							<xsl:value-of select="string(@WSCV3LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var30_WSCVLIMIT">
					<xsl:if test="@WSCV4LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV4LIMIT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var30_WSCVLIMIT))) != 'false'">
							<xsl:value-of select="string(@WSCV4LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var31_WSCVLIMIT">
					<xsl:if test="@WSCV5LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV5LIMIT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var31_WSCVLIMIT))) != 'false'">
							<xsl:value-of select="string(@WSCV5LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var32_WSCVLIMIT">
					<xsl:if test="@WSCV6LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV6LIMIT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var32_WSCVLIMIT))) != 'false'">
							<xsl:value-of select="string(@WSCV6LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var33_WSCVLIMIT">
					<xsl:if test="@WSCV7LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV7LIMIT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var33_WSCVLIMIT))) != 'false'">
							<xsl:value-of select="string(@WSCV7LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var34_WSCVLIMIT">
					<xsl:if test="@WSCV8LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV8LIMIT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var34_WSCVLIMIT))) != 'false'">
							<xsl:value-of select="string(@WSCV8LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var35_WSCVLIMIT">
					<xsl:if test="@WSCV9LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV9LIMIT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var35_WSCVLIMIT))) != 'false'">
							<xsl:value-of select="string(@WSCV9LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var36_WSCVLIMIT">
					<xsl:if test="@WSCV10LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV10LMT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var36_WSCVLIMIT))) != 'false'">
							<xsl:value-of select="string(@WSCV10LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var37_WSCVDED">
					<xsl:if test="@WSCV1DED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV1DED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var37_WSCVDED))) != 'false'">
							<xsl:value-of select="string(@WSCV1DED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var38_WSCVDED">
					<xsl:if test="@WSCV2DED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV2DED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var38_WSCVDED))) != 'false'">
							<xsl:value-of select="string(@WSCV2DED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var39_WSCVDED">
					<xsl:if test="@WSCV3DED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV3DED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var39_WSCVDED))) != 'false'">
							<xsl:value-of select="string(@WSCV3DED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var40_WSCVDED">
					<xsl:if test="@WSCV4DED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV4DED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var40_WSCVDED))) != 'false'">
							<xsl:value-of select="string(@WSCV4DED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var41_WSCVDED">
					<xsl:if test="@WSCV5DED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV5DED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var41_WSCVDED))) != 'false'">
							<xsl:value-of select="string(@WSCV5DED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var42_WSCVDED">
					<xsl:if test="@WSCV6DED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV6DED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var42_WSCVDED))) != 'false'">
							<xsl:value-of select="string(@WSCV6DED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var43_WSCVDED">
					<xsl:if test="@WSCV7DED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV7DED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var43_WSCVDED))) != 'false'">
							<xsl:value-of select="string(@WSCV7DED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var44_WSCVDED">
					<xsl:if test="@WSCV8DED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV8DED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var44_WSCVDED))) != 'false'">
							<xsl:value-of select="string(@WSCV8DED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var45_WSCVDED">
					<xsl:if test="@WSCV9DED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV9DED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var45_WSCVDED))) != 'false'">
							<xsl:value-of select="string(@WSCV9DED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var46_WSCVDED">
					<xsl:if test="@WSCV10DED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCV10DED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var46_WSCVDED))) != 'false'">
							<xsl:value-of select="string(@WSCV10DED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var47_WSSITELIM">
					<xsl:if test="@WSSITELIM">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSSITELIM">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var47_WSSITELIM))) != 'false'">
							<xsl:value-of select="string(@WSSITELIM)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var48_WSSITEDED">
					<xsl:if test="@WSSITEDED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSSITEDED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var48_WSSITEDED))) != 'false'">
							<xsl:value-of select="string(@WSSITEDED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var49_WSCOMBINEDLIM">
					<xsl:if test="@WSCOMBINEDLIM">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCOMBINEDLIM">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var49_WSCOMBINEDLIM))) != 'false'">
							<xsl:value-of select="string(@WSCOMBINEDLIM)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var50_WSCOMBINEDDED">
					<xsl:if test="@WSCOMBINEDDED">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="WSCOMBINEDDED">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var50_WSCOMBINEDDED))) != 'false'">
							<xsl:value-of select="string(@WSCOMBINEDDED)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var51_CONDTYPE">
					<xsl:if test="@COND1TYPE">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="COND1TYPE">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var51_CONDTYPE))) != 'false'">
							<xsl:value-of select="string(@COND1TYPE)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var52_CONDNAME">
					<xsl:if test="@COND1NAME">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="COND1NAME">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var52_CONDNAME))) != 'false'">
							<xsl:value-of select="string(@COND1NAME)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var53_CONDLIMIT">
					<xsl:if test="@COND1LIMIT">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="COND1LIMIT">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var53_CONDLIMIT))) != 'false'">
							<xsl:value-of select="string(@COND1LIMIT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var54_CONDDEDUCTIBLE">
					<xsl:if test="@COND1DEDUCTIBLE">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="COND1DEDUCTIBLE">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var54_CONDDEDUCTIBLE))) != 'false'">
							<xsl:value-of select="string(@COND1DEDUCTIBLE)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var55_ROOFSYS">
					<xsl:if test="@ROOFSYS">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="ROOFSYS">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var55_ROOFSYS))) != 'false'">
							<xsl:value-of select="string(@ROOFSYS)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var56_ROOFGEOM">
					<xsl:if test="@ROOFGEOM">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="ROOFGEOM">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var56_ROOFGEOM))) != 'false'">
							<xsl:value-of select="string(@ROOFGEOM)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var57_ROOFANCH">
					<xsl:if test="@ROOFANCH">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="ROOFANCH">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var57_ROOFANCH))) != 'false'">
							<xsl:value-of select="string(@ROOFANCH)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var58_ROOFAGE">
					<xsl:if test="@ROOFAGE">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="ROOFAGE">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var58_ROOFAGE))) != 'false'">
							<xsl:value-of select="string(@ROOFAGE)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var59_ROOFFRAME">
					<xsl:if test="@ROOFFRAME">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="ROOFFRAME">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var59_ROOFFRAME))) != 'false'">
							<xsl:value-of select="string(@ROOFFRAME)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var60_CLADRATE">
					<xsl:if test="@CLADRATE">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="CLADRATE">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var60_CLADRATE))) != 'false'">
							<xsl:value-of select="string(@CLADRATE)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="var61_RESISTOPEN">
					<xsl:if test="@RESISTOPEN">
						<xsl:value-of select="'1'"/>
					</xsl:if>
				</xsl:variable>
				<xsl:attribute name="RESISTOPEN">
					<xsl:choose>
						<xsl:when test="string(boolean(string($var61_RESISTOPEN))) != 'false'">
							<xsl:value-of select="string(@RESISTOPEN)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</rec>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="/">
		<root>
			<xsl:attribute name="xsi:noNamespaceSchemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance">C:/Users/Administrator/Desktop/git/ARA/flamingo/hurloss/Files/ValidationFiles/CanLocARA.xsd</xsl:attribute>
			<xsl:for-each select="root">
				<xsl:call-template name="agt:MapToCanLocARA_var63_resultof_index_map">
					<xsl:with-param name="var62_current" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</root>
	</xsl:template>
</xsl:stylesheet>

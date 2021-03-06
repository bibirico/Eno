<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions" 
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
	xmlns:eno="http://xml.insee.fr/apps/eno" 
	xmlns:enoodt="http://xml.insee.fr/apps/eno/out/odt" 
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
	xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
	xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" 
	xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
	xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" 
	xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" 
	exclude-result-prefixes="xs fn xd eno enoodt" version="2.0">
	
	<xsl:import href="../../../styles/style.xsl"/>
	
	<xsl:param name="properties-file"/>
	<xsl:param name="parameters-file"/>
	<xsl:param name="labels-folder"/>
	
	<xsl:variable name="properties" select="doc($properties-file)"/>
	
	<xsl:variable name="header-content" select="doc($properties//HeaderFile)"/>
	
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p>An xslt stylesheet who transforms an input into Odt through generic driver templates.</xd:p>
			<xd:p>The real input is mapped with the drivers.</xd:p>
		</xd:desc>
	</xd:doc>
	
	<!-- Forces the traversal of the whole driver tree. Must be present once in the transformation. -->
	<xsl:variable name="varName" select="parent"/>
	<xsl:template match="*" mode="model" priority="-1">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Match on the Form driver: write the root of the document with the main title -->
	<xsl:template match="Form" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		
		<office:document office:version="1.2" office:mimetype="application/vnd.oasis.opendocument.text"
			xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
			xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0">
			<office:font-face-decls>
				<style:font-face style:name="Arial" svg:font-family="Arial" style:font-family-generic="system" style:font-pitch="variable"/>
			</office:font-face-decls>
			
			<office:styles>
				<style:style style:name="Standard" style:family="paragraph" style:class="text"/>
				<style:style style:name="Title" style:family="paragraph" style:class="chapter">
					<style:paragraph-properties fo:text-align="center" fo:margin-top="3cm"
						style:justify-single-word="false"/>
					<style:text-properties fo:font-size="36pt" fo:font-weight="bold" fo:color="#7b7c7c"/>
				</style:style>
				<style:style style:name="TitleComment" style:family="paragraph">
					<style:paragraph-properties fo:text-align="center" fo:margin-top="3cm"
						style:justify-single-word="false"/>
					<style:text-properties fo:font-size="22pt" fo:font-weight="bold"/>
				</style:style>
				<style:style style:name="Module" style:family="paragraph" style:default-outline-level="1"
					style:class="text">
					<style:paragraph-properties fo:text-align="center" fo:break-before="page"/>
					<style:text-properties fo:font-size="14pt" fo:font-weight="bold"/>
				</style:style>
				<style:style style:name="SubModule" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:margin-top="0.6cm" fo:text-align="left"/>
					<style:text-properties fo:font-size="14pt" fo:font-weight="bold"/>
				</style:style>
				<style:style style:name="QuestionName" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:margin-top="0.4cm" fo:text-align="left"/>
					<style:text-properties fo:font-size="10pt" fo:font-style="italic" fo:font-weight="bold"
						fo:color="#a5106c"/>
				</style:style>
				<style:style style:name="Question" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:margin-top="0.1cm" fo:text-align="left"/>
					<style:text-properties fo:font-size="10pt"/>
				</style:style>
				<style:style style:name="Format" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:text-align="left"/>
					<style:text-properties fo:font-size="10pt"/>
				</style:style>
				<!-- <style:style style:name="QuestionSelect" style:family="paragraph"
					style:default-outline-level="2" style:class="text">
					<style:paragraph-properties fo:text-align="left"/>
					<style:text-properties fo:font-size="10pt" fo:font-weight="bold"/>
					</style:style> -->
				<style:style style:name="Comment" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:margin-top="0.1cm" fo:text-align="left"/>
					<style:text-properties fo:font-size="10pt" fo:color="#006600"/>
				</style:style>
				<style:style style:name="Help" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:margin-top="0.1cm" fo:text-align="left"/>
					<style:text-properties fo:font-size="10pt" fo:color="#0000ff" style:text-underline-style="solid"
					/>
				</style:style>
				<style:style style:name="Instruction" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:margin-top="0.1cm" fo:text-align="left"/>
					<style:text-properties fo:font-size="10pt" fo:color="#0000ff"/>
				</style:style>
				<style:style style:name="Warning" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:text-align="left" fo:border="0.05pt solid #000000"
						fo:margin-top="0.1cm"/>
					<style:text-properties fo:font-size="10pt" fo:font-weight="bold" fo:color="#ff3333"/>
				</style:style>
				<style:style style:name="CodeItem" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:text-align="left" fo:margin-left="1cm" fo:margin-top="0.1cm"/>
					<style:text-properties fo:font-size="10pt"/>
				</style:style>
				<style:style style:name="CalculatedVariableTitle" style:family="paragraph"
					style:default-outline-level="2" style:class="text">
					<style:paragraph-properties fo:text-align="left" fo:margin-top="0.7cm"/>
					<style:text-properties fo:font-size="10pt" fo:font-weight="bold"/>
				</style:style>
				<style:style style:name="CalculatedVariableContent" style:family="paragraph"
					style:default-outline-level="2" style:class="text">
					<style:paragraph-properties fo:text-align="left" fo:margin-top="0.3cm"/>
					<style:text-properties fo:font-size="10pt"/>
				</style:style>
				<style:style style:name="Control" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:text-align="left" fo:margin-top="0.7cm"
						fo:border="0.05pt solid #000000"/>
					<style:text-properties fo:font-size="10pt" fo:font-weight="bold" fo:color="#0000ff"/>
				</style:style>
				<style:style style:name="MultipleChoice" style:family="table">
					<style:table-properties fo:break-before="page"/>
				</style:style>
				<style:style style:name="MultipleChoice.Column" style:family="table-column"> </style:style>
				<style:style style:name="MultipleChoice.Cell" style:family="table-cell"> </style:style>
				<style:style style:name="Table" style:family="table">
					<style:table-properties fo:margin-top="1cm"/>
				</style:style>
				<style:style style:name="Table.Column" style:family="table-column"> </style:style>
				<style:style style:name="Table.Cell" style:family="table-cell"> </style:style>
				<style:style style:name="ColumnHeader" style:family="paragraph" style:default-outline-level="2"
					style:class="text">
					<style:paragraph-properties fo:text-align="center"/>
					<style:text-properties fo:font-size="10pt" fo:font-weight="bold"/>
				</style:style>
			</office:styles>
			
			
			<!--
				<xsl:copy-of select="$header-content/office:document/@*"/>
				<xsl:copy-of select="$header-content/office:document/node()[not(name()='office:body')]"/>
			-->
			<office:body>
				<office:text>
					<text:p text:style-name="Title"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
					<text:p text:style-name="TitleComment">
						<!--  <xsl:value-of select="concat('Specification generated on: ',format-dateTime(current-dateTime(), '[D01]/[M01]/[Y0001] - [H1]:[m01]:[s01]'))"/>-->
						Specification generated from Eno
					</text:p>
					<!-- Go to the children -->
					<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
						<xsl:with-param name="driver" select="." tunnel="yes"/>
					</xsl:apply-templates>
				</office:text>
			</office:body>
		</office:document>
	</xsl:template>
	<!--                   -->
	<!-- Match on the Module driver: write the module label -->
	<xsl:template match="Module" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		
		<text:p text:style-name="Module"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		
		<!-- Go to the children -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Match on the SubModule driver: write the sub-module label -->
	<xsl:template match="SubModule" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		
		<text:p text:style-name="SubModule"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		
		<!-- Go to the children -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="xf-input" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<xsl:variable name="typeResponse" select="enoodt:get-type($source-context)"></xsl:variable>
		<xsl:variable name="lengthResponse" select="enoodt:get-length($source-context)"></xsl:variable>
		<xsl:variable name="numberOfDecimals" select="enoodt:get-number-of-decimals($source-context)"></xsl:variable>
		<xsl:variable name="minimumResponse" select="enoodt:get-minimum($source-context)"></xsl:variable>
		<xsl:variable name="maximumResponse" select="enoodt:get-maximum($source-context)"></xsl:variable>
		<xsl:variable name="questionName" select="enoodt:get-question-name($source-context)"></xsl:variable>
		
		<xsl:if test="$questionName != ''">
			<text:p text:style-name="QuestionName">
				<xsl:value-of select="concat('[',$questionName,']')"/>
			</text:p>
			<text:p text:style-name="Format">
				<xsl:choose>
					<xsl:when test="$typeResponse='text'">
						<xsl:value-of select="concat('Car ',$lengthResponse)"/>
					</xsl:when>
					<xsl:when test="$typeResponse='number' and fn:string-length($numberOfDecimals)>0">
						<xsl:value-of select="concat('num ',$minimumResponse,'..',$maximumResponse,' - ',$numberOfDecimals,' chiffre(s) après la virgule')"/>
					</xsl:when>
					<xsl:when test="$typeResponse='number' and fn:string-length($numberOfDecimals)=0">
						<xsl:value-of select="concat('num ',$minimumResponse,'..',$maximumResponse)"/>
					</xsl:when>
					<xsl:when test="$typeResponse='date'">
						<xsl:value-of select="$typeResponse"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'Booléen'"/>
					</xsl:otherwise>
				</xsl:choose>
			</text:p>
			<text:p text:style-name="Question"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</xsl:if>
			
		
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	
	<!--	<xsl:template match="xf-textarea[ancestor::MultipleQuestion ]" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		
		<office:text>
		<text:p text:style-name="QuestionName">
		<xsl:value-of select="concat('[',enoodt:get-question-name($source-context),']')"/>
		</text:p>
		<text:p text:style-name="Question"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</office:text>
		</xsl:template>-->
	
	
	
	<!-- [ancestor::MultipleQuestion ] -->
	<xsl:template match="xf-textarea" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<xsl:variable name="typeResponse" select="enoodt:get-type($source-context)"/>
		<xsl:variable name="format" select="enoodt:get-format($source-context)"/>
		<xsl:variable name="lengthResponse" select="enoodt:get-length($source-context)"/>
		<xsl:variable name="numberOfDecimals" select="enoodt:get-number-of-decimals($source-context)"/>
		<xsl:variable name="minimumResponse" select="enoodt:get-minimum($source-context)"/>
		<xsl:variable name="maximumResponse" select="enoodt:get-maximum($source-context)"/>
		<xsl:variable name="questionName" select="enoodt:get-question-name($source-context)"/>
		<xsl:if test="$questionName !=''">
			<text:p text:style-name="QuestionName">
				<xsl:value-of select="concat('[',$questionName,']')"/>
			</text:p>
			<text:p>
				<xsl:choose>
					<xsl:when test="$typeResponse='text'">
						<xsl:value-of select="concat('Car ',$lengthResponse)"/>
					</xsl:when>
					<xsl:when test="$typeResponse='date'">
						<xsl:value-of select="$typeResponse"/>
					</xsl:when>
					<xsl:when test="$typeResponse='number' and fn:string-length($numberOfDecimals)=0">
						<xsl:value-of select="concat('num ',$minimumResponse,'..',$maximumResponse)"/>
					</xsl:when>
					<xsl:when test="$typeResponse='number' and fn:string-length($numberOfDecimals)>0">
						<xsl:value-of select="concat('num ',$minimumResponse,'..',$maximumResponse,' - ',$numberOfDecimals,' chiffre(s) après la virgule')"/>
					</xsl:when>
				</xsl:choose>
			</text:p>
			<text:p text:style-name="Question"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</xsl:if>

		
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="xf-select " mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<xsl:variable name="typeResponse" select="enoodt:get-type($source-context)"/>
		<xsl:variable name="idQuestion" select="enoodt:get-name($source-context)"/>
		<xsl:variable name="questionName" select="enoodt:get-question-name($source-context)"/>
		<xsl:variable name="maximumLengthCode" select="enoodt:get-code-maximum-length($source-context)"/>
		
		<xsl:if test="$questionName != ''">
			<text:p text:style-name="QuestionName">
				<xsl:value-of select="concat('[',$questionName,']')"/>
			</text:p>
			<xsl:choose>
				<xsl:when test="$maximumLengthCode != ''">
					<text:p>
						<xsl:value-of select="concat('Car ',$maximumLengthCode,' - ','liste de modalités')"/>
					</text:p>
				</xsl:when>
				<xsl:otherwise>
					<text:p><xsl:value-of select="'Booleen'"/></text:p>
				</xsl:otherwise>
			</xsl:choose>
			<text:p text:style-name="Question"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</xsl:if>		
		<!-- Returns to the parent -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<!-- Match on the xf-select driver: write the question label -->
	<xsl:template match="xf-select1" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<xsl:variable name="typeResponse" select="enoodt:get-type($source-context)"/>
		<xsl:variable name="lengthResponse" select="enoodt:get-length($source-context)"/>
		<xsl:variable name="questionName" select="enoodt:get-question-name($source-context)"/>
		<xsl:variable name="maximumLengthCode" select="enoodt:get-code-maximum-length($source-context)"/>
	
		<xsl:if test="$questionName != ''">
			<text:p text:style-name="QuestionName">
				<xsl:value-of select="concat('[',$questionName,']')"/>
			</text:p>
			<xsl:choose>
				<xsl:when test="$maximumLengthCode != ''">
					<text:p>
						<xsl:value-of select="concat('Car ',$maximumLengthCode,' - ','liste de modalités')"/>
					</text:p>
				</xsl:when>
				<xsl:otherwise>
					<text:p><xsl:value-of select="concat('Booleen',$maximumLengthCode, ' raté !')"/></text:p>
				</xsl:otherwise>
			</xsl:choose>
			<text:p text:style-name="QuestionSelect"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</xsl:if>		
		<!-- Go to the children -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<!-- Match on the Table driver: write the question label -->
	<xsl:template match="Table" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<xsl:variable name="ancestors">
			<xsl:copy-of select="root(.)"/>
		</xsl:variable>
		<xsl:variable name="questionName" select="enoodt:get-question-name($source-context)"/>
		<xsl:variable name="maximumLengthCode" select="enoodt:get-code-maximum-length($source-context)"/>
		<xsl:variable name="headerLine" select="enoodt:get-header-line($source-context,position())"/>
		<xsl:if test="$questionName != ''">
			<text:p text:style-name="QuestionName">
				<xsl:value-of select="concat('[',$questionName,']')"/>
			</text:p>
			<text:p>
				<xsl:value-of select="concat('Car ',$maximumLengthCode)"/>
			</text:p>
		</xsl:if>
		
		<text:p text:style-name="Question"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		
		<table:table table:name="{enoodt:get-name($source-context)}">
			<!--header-->
			<xsl:apply-templates 
				select="enoodt:get-header-lines($source-context)">	
			</xsl:apply-templates>
			<table:table-column/>
			<table:table-column/>
			
			<table:table-row>
				<xsl:apply-templates 
					select="$headerLine" mode="source">
				</xsl:apply-templates>
			</table:table-row>
			
			
			
			<!-- Body -->
			<xsl:for-each select="enoodt:get-body-lines($source-context)">
				<table:table-row>
					<xsl:apply-templates
						select="enoodt:get-body-line($source-context, position())" mode="source">
					</xsl:apply-templates>
				</table:table-row>
			</xsl:for-each>			
		</table:table>
		
		<!-- Go to the children -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<!-- Pour les entêtes (en haut ou à gauche) -->
	<xsl:template match="TextCell" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		
		<table:table-cell>
			<text:p><xsl:value-of select="enoodt:get-label($source-context,$languages)"/></text:p>
		</table:table-cell>
		<table:table-cell>
			<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
				<xsl:with-param name="driver" select="." tunnel="yes"/>
			</xsl:apply-templates>
		</table:table-cell>
	</xsl:template>
	
	<xsl:template match="Cell" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<table:table-cell>
			<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
				<xsl:with-param name="driver" select="." tunnel="yes"/>
			</xsl:apply-templates>
		</table:table-cell>
		
		
	</xsl:template>
	
	<!-- Match on the xf-item driver: write the code value and label -->
	<xsl:template match="xf-item" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<xsl:variable name="label" select="enoodt:get-label($source-context, $languages[1])"/>
		<xsl:if test="$label !='' and not(ancestor::Table)">
			<text:p text:style-name="CodeItem">
				<xsl:value-of select="fn:concat(enoodt:get-value($source-context), ' - ', $label)"/>
			</text:p>
		</xsl:if>
		<xsl:if test="ancestor::Table">
			<text:table-cell text:style-name="CodeItem">
				<text:p><xsl:value-of select="fn:concat(enoodt:get-value($source-context), ' - ', $label)"/></text:p>
			</text:table-cell>
			
		</xsl:if>	
		
		<!-- Got to the children -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!--
	<xsl:template match="xf-item[not(ancestor::Table or ancestor::xf-textarea)]" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>		
		<text:p text:style-name="CodeItem">
			<xsl:value-of select="fn:concat(enoodt:get-value($source-context), ' - ', enoodt:get-label($source-context, $languages[1]))"/>
		</text:p>	
		<!-\- Returns to the parent -\->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>-->
	
	<!--	<xsl:template match="MultipleQuestion " mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		
		<office:text>
		<text:p text:style-name="CodeItem">
		<xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</office:text>
		
		<!-\- Returns to the parent -\->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
		<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
		</xsl:template>
	-->
	
	<!-- Match on the xf-output driver: write the instruction text, with a different styles for comments and instructions -->
	<xsl:template match="xf-output" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<xsl:variable name="instructionFormat" select="enoodt:get-format($source-context)"/>
		<xsl:variable name="instructionLabel" select="enoodt:get-label($source-context, $languages)"/>
		<xsl:variable name="instructionFormatMaj" select="concat(upper-case(substring($instructionFormat,1,1)),
			substring($instructionFormat,2))" as="xs:string"></xsl:variable>
		<xsl:choose>
			<xsl:when test="$instructionFormat='comment'">
				
				<text:p text:style-name="Comment"><xsl:value-of select="$instructionLabel"/></text:p>
				<!--<text:p text:style-name="Comment"><xsl:value-of select="$instructionFormatMaj"/></text:p>-->
				
			</xsl:when>
			<xsl:when test="$instructionFormat='instruction'">
				
				<text:p text:style-name="Instruction"><xsl:value-of select="$instructionLabel"/></text:p>
				<!--<text:p text:style-name="Instruction"><xsl:value-of select="$instructionFormatMaj"/></text:p>-->
				
			</xsl:when>
		</xsl:choose>
		
		<!-- Go to the children -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
		
	</xsl:template>

	<xsl:template match="CalculatedVariable" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<xsl:variable name="variableCalculation" select="enoodt:get-calculate($source-context)"/>
		<xsl:variable name="variableCalculationLabel" select="enoodt:get-calculate-text($source-context,$languages[1],'label')"/>
		<xsl:variable name="variableCalculationAlert" select="enoodt:get-calculate-text($source-context,$languages[1],'alert')"/>
		
		<text:p><xsl:value-of select="$variableCalculation"/></text:p>
		<text:p><xsl:value-of select="$variableCalculationLabel"/></text:p>
		<text:p><xsl:value-of select="$variableCalculationAlert"/></text:p>
		<!-- Go to the children -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>		
	</xsl:template>
	
</xsl:stylesheet>

component{

	// https://templates.mailchimp.com/development/responsive-email/
	// https://www.campaignmonitor.com/blog/email-marketing/2019/04/order-stacked-columns-responsive-email/

	// https://jsoup.org/
	// https://github.com/serg472/htmlcompressor
	variables._config = {
		baseColour: "##ffffff",
		breakPoint: 480,
		containerWidth: 600,
		customTagPath: "",
		lineLength: 500,
		compressCSS: true,
		allowIncludes: true
	}

	variables._crlf = chr(13) & chr(10); // CRLF shorthand
	variables._jsoup = ""; // cached jsoup reference
	variables._jsoupJarPath = "java/jsoup-1.13.1.jar"; // path to jsoup jar
	variables._compressorJarPath = ["java/htmlcompressor-1.5.3.jar","java/yuicompressor-2.4.6.jar"]; // path to HTML compressor jar
	
	// named css snippets
	variables._css = {
		"any": {},
		"sm": {},
		"lg": {},
		"outlook": {}
	};
	// 
	variables._css_all = {
		"any": [],
		"sm": [],
		"lg": [],
		"outlook": []
	};
	// css rules to inline
	variables._css_inline = [];
	// template inserts
	variables._inserts = {
		"title": "",
		"preview": ""
	};
	// 
	variables._defaultAttributes = {};
	variables._templates = {};
	variables._properties = {};

	variables._n = "\n/"; // new line placeholder

	/**
	* @hint constructor
	*/
	public any function init(struct config={}){
		structAppend(variables._config, arguments.config);
		//configure(arguments.config);
		return this;
	}

	/**
	* @hint determines our base path
	*/
	public string function getBasePath(){
		return getDirectoryFromPath(getMetaData(this).path);
	}

	/**
	* @hint returns our variables scope - useful for inspection
	*/
	public struct function getSnapshot(){
		return variables;
	}

	
	/**
	* @hint attempts to validate a given string as EMML
	*/
	public struct function isEMML(string input){
		local.ret = {
			"isValid": false,
			"err": ""
		};

		// escape non em- tags
		local.escaped = escapeHTML(arguments.input);

		try{

			local.doc = XmlParse(local.escaped);
			if(local.doc.XmlRoot.XmlName == "em-eml"){
				local.ret.isValid = true;
			}else{
				local.ret.err = "Invalid document root";
			}

		}catch(any e){
			local.ret.err = cfcatch.message;	
		}
		
		
		return local.ret;
	}

	/**
	* @hint renders an email as HTML
	*/
	public any function toHTML(string input, boolean minify=false, struct inserts={}){

		local.validated = isEMML(arguments.input);
		if(!local.validated.isValid){
			return local.validated.err;
		}

		// handle any 'include' tags
		if(config("allowIncludes")){
			arguments.input = doIncludes(arguments.input);
		}

		// escape non em- tags
		local.escaped = escapeHTML(arguments.input);

		// remove whitepsace between column tags
		local.escaped = inlineColumns(local.escaped);

		local.xml = xmlParse(local.escaped);
		local.html = processNode(local.xml.xmlRoot);

		variables._inserts.css = outputCSS();
		local.html = doInserts(local.html, arguments.inserts);

		for(local.inline in variables._css_inline){
			local.html = inlineStyle(local.html, local.inline.selector, local.inline.style);
		}

		if(arguments.minify){
			local.html = minifyHTML(local.html);
		}

		return local.html;
	}

	/**
	* @hint renders an email as plain text
	*/
	public any function toText(string input, struct inserts={}){

		local.validated = isEMML(arguments.input);
		if(!local.validated.isValid){
			return local.validated.err;
		}

		// handle any 'include' tags
		if(config("allowIncludes")){
			arguments.input = doIncludes(arguments.input);
		}

		// escape non em- tags
		local.escaped = escapeHTML(arguments.input);

		local.xml = xmlParse(local.escaped);
		local.txt = processNode(node:local.xml.xmlRoot, mode:"TEXT");
		local.txt = doInserts(local.txt, arguments.inserts);

		// unescape our CRLF placeholder
		local.txt = trim(replaceNoCase(local.txt, variables._n, chr(13) & chr(10), "ALL"));

		return local.txt;
	}

	/**
	* @hint perform includes
	*/
	public string function doIncludes(string input){
		local.includeRegEx = "<em-include (.*[^\/])?\/?>";

		var attributePattern = CreateObject(
			"java",
			"java.util.regex.Pattern"
			).Compile(
				"(\w+)(?:\s*=\s*(""[^""]*""|[^\s]*))?"
				);

		return jreReplace(arguments.input, local.includeRegEx, function($0, attributes, start, targetText){
			local.attr = {
				template: ""
			};

			local.attributeMatcher = attributePattern.Matcher(arguments.attributes);

			while(local.attributeMatcher.Find()){
				local.name = local.attributeMatcher.Group( 1 );
				local.attr[local.name] = "";

				local.value = local.attributeMatcher.Group( 2 );
				if(structKeyExists(local, "value")){
					local.value = local.value.ReplaceAll("^""|""$", "" );
					local.attr[local.name] = local.value;
				}

			}

			if(len(local.attr.template)){
				savecontent variable="local.templateInclude"{
					include template="#local.attr.template#";
				}
				return local.templateInclude;
			}


			return "";
		});
	}


	/**
	* @hint escapes any non em- tags
	*/
	public string function escapeHTML(string input){
		//local.escaped = replaceNoCase(arguments.input, "&nbsp;", "[nbsp;]", "ALL");
		local.escaped = replaceNoCase(arguments.input, "&", "[[amp]]", "ALL");
		local.escaped = reReplaceNoCase(local.escaped, "<(?!/?em-)", "[&lt;]", "ALL");
		return local.escaped;
	}

	/**
	* @hint unescapes any tags previously escaped using escapeHTML()
	*/
	public string function unescapeHTML(string input){
		//local.out = replaceNoCase(arguments.input, "[nbsp;]", "&nbsp;", "ALL");
		local.out = replaceNoCase(arguments.input, "[[amp]]", "&", "ALL");
		local.out = reReplaceNoCase(local.out, "\[[&lt;|<]\]", "<", "ALL");
		return local.out;
	}

	/**
	* @hint processes a given tag node and recurses through any child nodes
	*/
	public any function processNode(any node, any parent="", string mode="HTML"){
		local.out = [];

		if(arguments.node.xmlType == "TEXT"){
			// this is a plain text node
			arrayAppend(local.out, unescapeHTML(arguments.node.xmlValue));
		}else{
			// this is a tag node
			//local.tag = getTag(arguments.node.xmlName, arguments.node.xmlAttributes);
			local.tag = getTagFromNode(arguments.node, arguments.parent);
			local.tag.before();

			// render our child content
			local.childContent = [];
			if(local.tag.processChildren()){
				for(local.childNode in arguments.node.xmlNodes){
					arrayAppend(local.childContent, processNode(local.childNode, local.tag, arguments.mode));
				}
			}

			// render our tag
			local.childContent = arrayToList(local.childContent, "");
			local.tag.setChildContent(local.childContent);
			if(arguments.mode IS "HTML"){
				arrayAppend(local.out, local.tag.render());
			}else{
				arrayAppend(local.out, local.tag.renderText());
			}

		}

		return arrayToList(local.out, "");
	}

	/**
	* @hint creates a tag object from a given node
	*/
	public any function getTagFromNode(any node, any container, string childContent=""){
		arguments.tagName = replaceNoCase(arguments.node.xmlName, "em-", "");
		local.tag = createObject("component", getTagDotPath(arguments.tagName)).initFromNode(this, arguments.node, arguments.container, arguments.childContent);
		return local.tag;
	}

	/**
	* @hint creates a tag object from a given tag name. We do not have a node context here
	*/
	public any function getTag(string tagName, struct attributes, string childContent=""){
		arguments.tagName = replaceNoCase(arguments.tagName, "em-", "");
		local.tag = createObject("component", getTagDotPath(arguments.tagName)).init(this, arguments.attributes, arguments.childContent);
		return local.tag;
	}

	/**
	* @hint determines the dot path for a given tag name. This includes a check for a custom tag path
	*/
	public string function getTagDotPath(string tagName){
		local.tagPath = "tags.#arguments.tagName#";

		// check for a custom tag
		local.customTagDotPath = getCustomTagDotPath(arguments.tagName);
		if(len(local.customTagDotPath)){
			local.tagPath = local.customTagDotPath;
		}

		return local.tagPath ;
	}

	/**
	* @hint determines the dot path for a given custom tag name. If the tag does not exist, an empty string gets returned
	*/
	public string function getCustomTagDotPath(string tagName){
		local.customTagPath = config("customTagPath");
		if(len(local.customTagPath)){
			local.customTagFolder = expandPath("/" & replaceNoCase(local.customTagPath, ".", "/", "ALL")) & "\";
			if(fileExists(local.customTagFolder & arguments.tagName & ".cfc")){
				return local.customTagPath & "." & arguments.tagName;
			}
		}
		return "";
	}
	
	/**
	* @hint output a CSS string of a given type
	*/
	public string function outputCSS(string type="any"){
		local.css = arrayToList(variables._css_all[arguments.type], variables._crlf);
		local.keyedCSS = [];
		for(local.cssKey in variables._css[arguments.type]){
			arrayAppend(local.keyedCSS, variables._css[arguments.type][local.cssKey]);
		}
		return local.css & arrayToList(local.keyedCSS, variables._crlf);
	}

	/**
	* @hint add CSS to our instance with an optional reference and type
	*/
	public function addCSS(required string css, string reference="", type="any"){
		if(!len(arguments.reference)){
			arrayAppend(variables._css_all[arguments.type], arguments.css);
		}else{
			variables._css[arguments.type][arguments.reference] = arguments.css;
		}
	}

	/**
	* @hint add inline CSS to our instance with an optional selector. If no selector is given, the CSS is parsed and each selector and rule found is added
	*/
	public function addInlineCSS(required string css, string selector=""){
		arguments.css = trim(arguments.css);
		if(!len(arguments.selector)){
			// parse our string
			local.split = listToArray(arguments.css, "}");
			for(local.rule in local.split){
				local.splitPair = listToArray(local.rule, "{");
				if(arrayLen(local.splitPair) == 2){
					arrayAppend(variables._css_inline, {
						selector: trim(local.splitPair[1]),
						style: trim(local.splitPair[2])
					});
				}
			}
		}else{
			arrayAppend(variables._css_inline, {
				selector: trim(arguments.selector),
				style: trim(arguments.css)
			});
		}
	}

	/**
	* @hint returns a config value for a given key
	*/
	public function config(string key, any default=""){
		if(structKeyExists(variables._config, arguments.key)){
			return variables._config[arguments.key];
		}
		return arguments.default;
	}

	/**
	* @hint sets an attribute template
	*/
	public void function setAttributeTemplate(string templateName, struct attr){
		variables._templates[arguments.templateName] = arguments.attr;
	}

	/**
	* @hint returns an attribute template for a given name
	*/
	public struct function getAttributeTemplate(string templateName){
		if(structKeyExists(variables._templates, arguments.templateName)){
			return variables._templates[arguments.templateName];	
		}
		return {};
	}

	/**
	* @hint sets default attributes for a given tag name
	*/
	public void function setDefaultAttributes(string tagName, struct attr){
		variables._defaultAttributes[arguments.tagName] = arguments.attr;
	}

	/**
	* @hint gets default attributes for a given tag name
	*/
	public struct function getDefaultAttributes(string tagName){
		if(structKeyExists(variables._defaultAttributes, arguments.tagName)){
			return variables._defaultAttributes[arguments.tagName];
		}
		return {};
	}

	/**
	* @hint sets a property value
	*/
	public void function setProperty(string key, any value){
		variables._properties[arguments.key] = arguments.value;
	}

	/**
	* @hint gets a property value for a given key
	*/
	public any function getProperty(string key, any default=""){
		if(structKeyExists(variables._properties, arguments.key)){
			return variables._properties[arguments.key];
		}
		return arguments.default;
	}



	public string function _inlineStyle(string input, string styles, string elements){
		// prepare elements for regex
		local.els = replace(arguments.elements, ",", "|", "ALL");
		// first, we enure all elements have a style attribute - this assumes all elements have not attributes
		arguments.input = reReplaceNoCase(arguments.input, "<(#local.els#)>", '<\1 style="">', "ALL");
		// apply our styles
		arguments.input = reReplaceNoCase(arguments.input, '<(#local.els#)(.*?)style="(.*?)"[^>]*?(\/?)>', '<\1\2style="#arguments.css#\3"\4>', "ALL");
		// return our string
		return arguments.input;
	}

	/**
	* @hint uses jsoup to inline our inline styles
	*/
	public string function inlineStyle(string input, string selector, string styles, boolean overwrite=false){
		// escape escaped character to prevent them being unescaped
		arguments.input = reReplaceNoCase(arguments.input, "&([^;]+?);", "~~\1;", "ALL");

		local.parsed = jsoupParse(arguments.input);

		local.els = local.parsed.select(arguments.selector);
		for(local.el in local.els){
			local.classNames = listToArray(local.el.attr("class"), " ");
			if(!arrayFindNoCase(local.classNames, "noInline")){
				local.style = local.el.attr("style");
				local.el.attr("style", mergeStyles(local.style, arguments.styles, arguments.overwrite));
			}
		}

		//local.parsed.outputSettings().escapeMode(EscapeMode.xhtml);
		
		local.out = local.parsed.html();
		// reapply our escaped characters
		local.out = reReplaceNoCase(local.out, "~~([^;]+?);", "&\1;", "ALL");
		return local.out;
	}

	/**
	* @hint parses a CSS rule into individual styles
	*/
	public struct function parseStyles(string input){
		local.styles = structNew("ordered");
		local.split = listToArray(arguments.input, ";");
		for(local.pair in local.split){
			local.splitPair = listToArray(local.pair, ":");
			if(arrayLen(local.splitPair) == 2){
				local.styles[trim(local.splitPair[1])] = trim(local.splitPair[2]);
			}
		}
		return local.styles;
	}

	/**
	* @hint marges two css rules together
	*/
	public string function mergeStyles(string style1, string style2, boolean overwrite=false){
		local.styles = parseStyles(arguments.style1);
		structAppend(local.styles, parseStyles(arguments.style2), arguments.overwrite);
		local.out = [];
		for(local.key in local.styles){
			arrayAppend(local.out, local.key & ":" & local.styles[local.key]);
		}
		return arrayToList(local.out, ";");
	}

	/**
	* @hint gets a jsoup instance (relies on Lucee context attribute - for this to work on ACF, we need to add the jars to the classpath or use JavaLoader)
	*/
	public any function jsoup(){
		if(isSimpleValue(variables._jsoup)){
			variables._jsoup = createObject("java", "org.jsoup.Jsoup", variables._jsoupJarPath);
		}
		return variables._jsoup;
	}

	/**
	* @hint gets a jsoup whitelist instance (relies on Lucee context attribute - for this to work on ACF, we need to add the jars to the classpath or use JavaLoader)
	*/
	public any function jsoupWhitelist(){
		return createObject("java", "org.jsoup.safety.Whitelist", variables._jsoupJarPath);
	}

	/**
	* @hint parses a given string using jsoup
	*/
	public any function jsoupParse(string source){
		return jsoup().parse(JavaCast("string", arguments.source));
	}

	/**
	* @hint cleans a given string using jsoup
	*/
	public any function jsoupClean(string input, any whitelist=jsoupWhitelist().relaxed()){
		return jsoup().clean(JavaCast("string", arguments.input), arguments.whitelist);
	}

	/**
	* @hint determines the files size of a given string by saving it as a file to ram
	*/
	public any function fileSize(string content){
		local.filePath = "ram://" & createUUID() & ".html";
		fileWrite(local.filePath, arguments.content, "utf-8");
		local.info = getFileInfo(local.filePath);
		fileDelete(local.filePath);
		return local.info;
	}

	/**
	* @hint basic conversion from HTML to plain text
	*/
	public string function htmlToText(string input){
		local.CRLF = chr(13) & chr(10);
		local.LF = chr(10);
		local.N = "\n/";
		local.out = arguments.input;

		// normalise CRLF
		local.out = replaceNoCase(local.out, local.CRLF, local.LF, "ALL");
		
		// closing paragraphs
		local.out = replaceNoCase(local.out, "</p>", local.N, "ALL");
		// line breaks
		local.out = replaceNoCase(local.out, "<br />", local.LF, "ALL");
		local.out = replaceNoCase(local.out, "<br/>", local.LF, "ALL");
		local.out = replaceNoCase(local.out, "<br>", local.LF, "ALL");
		// closing lists
		local.out = replaceNoCase(local.out, "</li>", local.N, "ALL");
		local.out = replaceNoCase(local.out, "</ul>", local.N, "ALL");
		local.out = replaceNoCase(local.out, "</ol>", local.N, "ALL");
		// bold text
		local.out = REReplaceNoCase(local.out, "</?(strong|bold)[^>]*>", "*", "ALL");
		// emphasised text
		local.out = REReplaceNoCase(local.out, "</?(em|i)[^>]*>", "_", "ALL");
		// links
		local.out = REReplaceNoCase(local.out, "(<a[^>]*href="")([^##][^""]*)(""[^>]*>)(.*?)(</a>)", "\4 [\2]", "ALL");
		// list items
		local.out = replaceNoCase(local.out, "<li>", "* ", "ALL");
		// strip all HTML tags
		local.out = REReplaceNoCase(local.out, "</?[^>]*/?>", "", "ALL");
		
		// trim each line of output
		local.aOut = listToArray(local.out, local.LF);
		local.aOut = arrayMap(local.aOut, function(item){
			return trim(arguments.item);
		});

		local.out = arrayToList(local.aOut, local.LF);

		// remove tabs
		//local.out = replaceNoCase(local.out, chr(9), "", "ALL");

		// reset CRLF
		local.out = replaceNoCase(local.out, local.LF, local.CRLF, "ALL");

		return local.out;
	}

	/**
	* @hint unescape HTML entities using Java
	*/
	public string function unescapeHTMLEntities(string input){
		local.strEscUtils = createObject("java", "org.apache.commons.lang.StringEscapeUtils");
		return local.strEscUtils.unescapeHTML(arguments.input);
	}
	
	/**
	* @hint returns a new line placeholder
	*/
	public string function newTextLine(){
		return variables._n;
	}

	/**
	* @hint replaces {{:[name]:}} strings in a given string with values passed in a given struct
	*/
	public string function doInserts(string html, struct inserts={}){
		for(local.key in arguments.inserts){

			local.replaceWith = arguments.inserts[local.key];
			// check for a closure
			if(isClosure(local.replaceWith)){
				local.replaceWith = invoke(local, "replaceWith");
			}

			arguments.html = replaceNoCase(arguments.html, "{{:#local.key#:}}", local.replaceWith);
		}
		return arguments.html;
	}

	/**
	* @hint scans all tags and custom tags to determine all our tag names and allowed attributes
	*/
	public any function getTagInsight(boolean withCustomTags=false){
		local.tags = {};

		// core tags
		local.tagFolder = getDirectoryFromPath(getMetaData(this).path) & "tags\";
		local.tagFiles = directoryList(local.tagFolder, false, "path");
		for(local.tagFile in local.tagFiles){
			local.name = listFirst(listLast(local.tagFile, "\"), ".");
			if(local.name != "tag"){
				local.tags["em-" & lcase(local.name)] = getTagAttributes(local.tagFile, "tags." & local.name);
			}
		}

		// custom tags
		local.customTagPath = config("customTagPath");
		if(len(local.customTagPath) AND arguments.withCustomTags){
			local.customTagFolder = expandPath("/" & replaceNoCase(local.customTagPath, ".", "/", "ALL")) & "\";

			local.customTagFiles = directoryList(local.customTagFolder, false, "path");
			
			for(local.customTagFile in local.customTagFiles){
				local.name = listFirst(listLast(local.customTagFile, "\"), ".");
				if(! structKeyExists(local.tags, "em-" & lcase(local.name))){
					local.tags["em-" & lcase(local.name)] = getTagAttributes(local.customTagFile, local.customTagPath & "." & local.name);
				}
			}
		}

		// create class tag
		local.allAttr = ["name"];
		for(local.tag in local.tags){
			for(local.attr in local.tags[local.tag]){
				if(!arrayFindNoCase(local.allAttr, local.attr) AND local.attr != "class"){
					arrayAppend(local.allAttr, local.attr);
				}
			}
		}
		arraySort(local.allAttr, "text");
		local.tags["em-class"] = local.allAttr;

		// return tag insights
		return local.tags;
	}

	/**
	* @hint extracts getAttribute() references from a given string and returns an array of attribute names found
	*/
	public any function getTagAttributes(string tagPath, string tagDotPath){
		local.out = [];

		// check for extending another tag
		local.meta = getComponentMetadata(arguments.tagDotPath);
		if(structKeyExists(local.meta, "extends")){
			// stop at our base 'tag', otherwise...
			if(local.meta.extends.path != getBasePath() & ("tags\tag.cfc")){
				// recursive call
				local.out = getTagAttributes(local.meta.extends.path, local.meta.extends.fullName);
			}
		}

		local.file = fileRead(arguments.tagPath);

		//local.matched = reFindNoCase("getAttribute\([^\)].*?\)", local.file, 1, true, "ALL");
		local.matched = reFindAllNoCase("getAttribute\([^\)].*?\)", local.file);
		//return local.matched;

		for(local.item in local.matched){
			local.attr = replaceNoCase(local.item.match[1], "getAttribute(", "");
			local.attr = listFirst(local.attr, ",");
			local.attr = replaceListNoCase(local.attr, """,',)", ",,");
			if(len(local.attr) && !arrayFindNoCase(local.out, local.attr)){
				arrayAppend(local.out, lcase(local.attr));
			}
		}

		// our template attribute
		if(arraylen(local.out) && !arrayFindNoCase(local.out, "template")){
			arrayAppend(local.out, "template");
		}

		arraySort(local.out, "text");

		return local.out;
	}

	/**
	* @hint removes whitespace between column tags
	*/
	public any function inlineColumns(string input){
		return reREplaceNoCase(arguments.input, "<\/em-column>[[:space:]]+<em-column", "</em-column><em-column", "ALL");
	};

	/**
	* @hint minifies HTML - https://github.com/serg472/htmlcompressor
	*/
	public string function minifyHTML(string input, boolean compressCSS=config("compressCSS"), numeric lineLength=config("lineLength")){
		local.comp = createObject("java", "com.googlecode.htmlcompressor.compressor.HtmlCompressor", variables._compressorJarPath);
		local.comp.setCompressCss(arguments.compressCSS);
		local.comp.setYuiCssLineBreak(arguments.lineLength);
		local.comp.setPreserveLineBreaks(true); // preserve our line breaks as we do our own concatenation
		
		// normalise our input
		arguments.input = cleanTags(normaliseCRLF(arguments.input));

		// do our compression
		local.compressed = local.comp.compress(arguments.input);

		//return local.compressed;

		if(arguments.compressCSS){
			// concatenate our output
			return limitLength(local.compressed, arguments.lineLength);
		}else{
			local.compressed = replaceNoCase(local.compressed, ">#variables._crlf#", ">¬", "ALL");
			//return local.compressed;
			return limitLength(local.compressed, arguments.lineLength, "¬");
		}
	};

	/**
	* @hint A 'lite' form of HTML minification - will break down if tags exist that contain formatted content
	* eg. pre, textarea. script, style could also cause problems.
	*/
	public string function minifyHTMLLite(string input, numeric lineLength=config("lineLength")){

		// normalise our input
		local.out = cleanTags(normaliseCRLF(arguments.input));
		
		// white space following a return
		local.out = REreplaceNoCase(local.out, "\n+\s+", variables._crlf, "all");
		// 2 or more spaces reduced to one
		local.out = REreplaceNoCase(local.out, "[ ]{2,}", " ", "ALL");
		// spaces between tags
		local.out = REreplaceNoCase(local.out, ">[ ]{1,}<", "><", "ALL");

		// concatenate our output
		return limitLength(local.out, arguments.lineLength);
	}

	/**
	* @hint remove CRLF from within tags and replace with a single space
	*/
	public string function cleanTags(string input){
		local.out = arguments.input;
		local.cleanedTags = false;
		while(!local.cleanedTags){

			local.tagClean = REreplaceNoCase(local.out, "<([^>]*?)[\r\n]([^>]*?)>", "<\1 \2>", "ALL");	

			if(local.tagClean == local.out){
				local.cleanedTags = true;
			}else{
				local.out = local.tagClean;
			}
		}
		return local.out;
	}

	/**
	* @hint normalise CR LF to a single LF
	*/
	public string function normaliseCRLF(string input){
		local.out = replaceNoCase(arguments.input, chr(13), chr(10), "ALL");
		local.out = replaceNoCase(local.out, chr(10) & chr(10), chr(10), "ALL");
		local.out = replaceNoCase(local.out, chr(10), variables._crlf, "ALL");
		return local.out;
	}

	/**
	* @hint concatenate a HTML string to a given max line length
	*/
	public string function limitLength(string input, numeric lineLength=config("lineLength"), string splitOn=variables._crlf){
		local.splitInput = listToArray(arguments.input, arguments.splitOn);

		local.out = [];
		
		local.chunk = "";
		for(local.item in local.splitInput){

			if(len(local.chunk) + len(local.item) + 1 LTE arguments.lineLength){
				local.chunk = local.chunk & local.item & " ";
			}else{
				arrayAppend(local.out, local.chunk);
				local.chunk = local.item;
			}

		}

		arrayAppend(local.out, local.chunk);

		local.outString = arrayToList(local.out, chr(13) & chr(10));

		// spaces between tags
		local.outString = REreplaceNoCase(local.outString, ">[ ]{1,}<", "><", "ALL");

		return local.outString;
	}

	/**
	* @hint reFindNoCase 'ALL' support for Lucee 4.5
	*/
	public array function reFindAllNoCase(string regex, string input){
		local.out = [];
		local.searchFrom = 1;
		local.searchComplete = false;

		while(NOT local.searchComplete){
			local.regResult = REFindNoCase(arguments.regEx, arguments.input, local.searchFrom, true);

			if(local.regResult.POS[1]){
				arrayAppend(local.out, duplicate(local.regResult));
				local.searchFrom = local.regResult.POS[1] + 1;
			}else{
				local.searchComplete = true; // no matches, break our conditional loop
			}
		}

		return local.out;
	}

	/**
	 * https://www.bennadel.com/blog/3322-jregex-a-coldfusion-wrapper-around-javas-regular-expression-patterns.htm
	* I use Java's Pattern / Matcher libraries to replace matched patterns using the
	* given operator function or closure.
	*
	* @targetText I am the text being scanned.
	* @patternText I am the Java Regular Expression pattern used to locate matches.
	* @operator I am the Function or Closure used to provide the match replacements.
	* @output false
	*/
	public string function jreReplace(
		required string targetText,
		required string patternText,
		required function operator
		) {

		var matcher = createObject( "java", "java.util.regex.Pattern" )
			.compile( javaCast( "string", patternText ) )
			.matcher( javaCast( "string", targetText ) );
		var buffer = createObject( "java", "java.lang.StringBuffer" ).init();

		// Iterate over each pattern match in the target text.
		while ( matcher.find() ) {

			// When preparing the arguments for the operator, we need to construct an
			// argumentCollection structure in which the argument index is the numeric
			// key of the argument offset. In order to simplify overlaying the pattern
			// group matching over the arguments array, we're simply going to keep an
			// incremented offset every time we add an argument.
			var operatorArguments = {};
			var operatorArgumentOffset = 1; // Will be incremented with each argument.

			var groupCount = matcher.groupCount();

			// NOTE: Calling .group(0) is equivalent to calling .group(), which will
			// return the entire match, not just a capturing group.
			for ( var i = 0 ; i <= groupCount ; i++ ) {

				operatorArguments[ operatorArgumentOffset++ ] = matcher.group( javaCast( "int", i ) );

			}

			// Including the match offset and the original content for parity with the
			// JavaScript String.replace() function on which this algorithm is based.
			// --
			// NOTE: We're adding 1 to the offset since ColdFusion starts offsets at 1
			// where as Java starts offsets at 0.
			operatorArguments[ operatorArgumentOffset++ ] = ( matcher.start() + 1 );
			operatorArguments[ operatorArgumentOffset++ ] = targetText;

			var replacement = operator( argumentCollection = operatorArguments );

			// In the event the operator doesn't return a value, we'll assume that the
			// intention is to replace the match with nothing.
			if ( isNull( replacement ) ) {

				replacement = "";

			}

			// Since the operator is providing the replacement text based on the
			// individual parts found in the match, we are going to assume that any
			// embedded group reference is coincidental and should be consumed as a
			// string literal.
			matcher.appendReplacement(
				buffer,
				matcher.quoteReplacement( javaCast( "string", replacement ) )
			);

		}

		matcher.appendTail( buffer );

		return( buffer.toString() );

	}
	
}
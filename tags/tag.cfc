component{

	variables._context = "";
	variables._node = "";
	variables._container = "";
	variables._attributes = {};
	variables._childContent = "";
	
	variables._defaultAttributes = {};

	/**
	* @hint constructor
	*/
	public any function init(any context, struct attributes={}, string childContent=""){
		variables._context = arguments.context;
		variables._attributes = arguments.attributes;
		variables._childContent = arguments.childContent;

		if(len(getAttribute("class"))){
			local.splitClass = listToArray(getAttribute("class"), " ");
			for(local.className in local.splitClass){
				structAppend(variables._attributes, getAttributeTemplate(trim(local.className)), false);
			}
		}

		return this;
	}

	/**
	* @hint constructor from a node
	*/
	public any function initFromNode(any context, any node, any container, string childContent=""){
		variables._node = arguments.node;
		variables._container = arguments.container;

		return init(arguments.context, variables._node.xmlAttributes, arguments.childContent);
	}

	/**
	* @hint returns true if this tag can process child tags
	*/
	public boolean function processChildren(){
		return true;
	}

	/**
	* @hint returns our parent context - emlParser
	*/
	public any function context(){
		return variables._context;
	}

	/**
	* @hint returns a tag name excluding the em- prefix
	*/
	public string function tagName(string input=variables._node.xmlName){
		return replaceNoCase(arguments.input, "em-", "");
	}

	/**
	* @hint returns our container tag object
	*/
	public any function getContainer(){
		return variables._container;
	}

	/**
	* @hint sets our container tag object
	*/
	public void function setContainer(any container){
		variables._container = arguments.container;
	}

	/**
	* @hint returns true if this tag has a container
	*/
	public boolean function hasContainer(){
		return !isNull(variables._container);
	}

	/**
	* @hint returns the innner width of our container
	*/
	public string function getContainerWidth(){
		if(hasContainer()){
			return getContainer().getInnerWidth();	
		}
		return config("containerWidth") & "px";
	}

	/**
	* @hint returns our outer width
	*/
	public string function getOuterWidth(){
		local.outerWidth = val(getContainerWidth());
		local.w = trim(getAttribute('width'));
		if(len(local.w)){
			if(right(local.w, 1) IS "%"){
				local.outerWidth = (local.outerWidth/100) * val(local.w);
			}
			if(right(local.w, 2) IS "px"){
				local.outerWidth = val(local.w);
			}
		}else{

			local.outerWidth = (local.outerWidth/100) * (100/columnCount());

		}
		return local.outerWidth & "px";
	}

	/**
	* @hint returns our inner width - width excluding padding
	*/
	public string function getInnerWidth(){
		return (val(getOuterWidth()) - paddingWidth()) & "px";
	}

	/**
	* @hint calculates the total width of any padding applied to this tag. This searches for padding and inner-padding attributes
	*/
	public numeric function paddingWidth(boolean includeInner=true){
		local.pwl = 0;
		local.pwr = 0;
		if(len(trim(getAttribute('padding')))){
			local.pSplit = listToArray(trim(getAttribute('padding')), " ");
			if(arrayLen(local.pSplit) == 1){
				local.pwl = val(local.pSplit[1]);
				local.pwr = val(local.pSplit[1]);
			}else if(arrayLen(local.pSplit) == 2){
				local.pwl = val(local.pSplit[2]);
				local.pwr = val(local.pSplit[2]);
			}else if(arrayLen(local.pSplit) == 4){
				local.pwr = val(local.pSplit[2]);
				local.pwl = val(local.pSplit[4]);
			}
		}

		local.p = 0;
		local.p += len(getAttribute('padding-left')) ? val(getAttribute('padding-left')) : local.pwl;
		local.p += len(getAttribute('padding-right')) ? val(getAttribute('padding-right')) : local.pwr;

		if(arguments.includeInner){
			local.pwl = 0;
			local.pwr = 0;
			if(len(trim(getAttribute('inner-padding')))){
				local.pSplit = listToArray(trim(getAttribute('inner-padding')), " ");
				if(arrayLen(local.pSplit) == 1){
					local.pwl = val(local.pSplit[1]);
					local.pwr = val(local.pSplit[1]);
				}else if(arrayLen(local.pSplit) == 2){
					local.pwl = val(local.pSplit[2]);
					local.pwr = val(local.pSplit[2]);
				}else if(arrayLen(local.pSplit) == 4){
					local.pwr = val(local.pSplit[2]);
					local.pwl = val(local.pSplit[4]);
				}
			}

			//local.p = 0;
			local.p += len(getAttribute('inner-padding-left')) ? val(getAttribute('inner-padding-left')) : local.pwl;
			local.p += len(getAttribute('inner-padding-right')) ? val(getAttribute('inner-padding-right')) : local.pwr;
		}

		return local.p;
	}

	/**
	* @hint calculates the total height of any padding applied to this tag. This searches for padding and inner-padding attributes
	*/
	public numeric function paddingHeight(boolean includeInner=true){
		local.pht = 0;
		local.phb = 0;
		if(len(trim(getAttribute('padding')))){
			local.pSplit = listToArray(trim(getAttribute('padding')), " ");
			if(arrayLen(local.pSplit) == 1){
				local.pht = val(local.pSplit[1]);
				local.phb = val(local.pSplit[1]);
			}else if(arrayLen(local.pSplit) == 2){
				local.pht = val(local.pSplit[1]);
				local.phb = val(local.pSplit[1]);
			}else if(arrayLen(local.pSplit) == 4){
				local.pht = val(local.pSplit[1]);
				local.phb = val(local.pSplit[3]);
			}
		}

		local.p = 0;
		local.p += len(getAttribute('padding-top')) ? val(getAttribute('padding-top')) : local.pht;
		local.p += len(getAttribute('padding-bottom')) ? val(getAttribute('padding-bottom')) : local.phb;

		if(arguments.includeInner){
			local.pht = 0;
			local.phb = 0;
			if(len(trim(getAttribute('inner-padding')))){
				local.pSplit = listToArray(trim(getAttribute('inner-padding')), " ");
				if(arrayLen(local.pSplit) == 1){
					local.pht = val(local.pSplit[1]);
					local.phb = val(local.pSplit[1]);
				}else if(arrayLen(local.pSplit) == 2){
					local.pht = val(local.pSplit[1]);
					local.phb = val(local.pSplit[1]);
				}else if(arrayLen(local.pSplit) == 4){
					local.pht = val(local.pSplit[1]);
					local.phb = val(local.pSplit[3]);
				}
			}

			//local.p = 0;
			local.p += len(getAttribute('inner-padding-top')) ? val(getAttribute('inner-padding-top')) : local.pht;
			local.p += len(getAttribute('inner-padding-bottom')) ? val(getAttribute('inner-padding-bottom')) : local.phb;
		}

		return local.p;
	}

	/**
	* @hint returns a count of columns... not sure why this is here as it specific to the em-column tag
	*/
	public numeric function columnCount(){
		return 1;
	}

	/**
	* @hint returns true if we have a node reference
	*/
	public boolean function hasNode(){
		return !isNull(variables._node);
	}

	/**
	* @hint sets our node reference - this is the XML node of a parsed emml document
	*/
	public void function setNode(any node){
		variables._node = arguments.node;
	}

	/**
	* @hint gets our node reference - this is the XML node of a parsed emml document
	*/
	public any function getNode(){
		return variables._node;
	}

	
	/**
	* @hint helper functions that call back up to our context emlParser
	*/
	public string function outputCSS(string type="any"){
		return context().outputCSS(argumentCollection:arguments);
	}
	public void function addCSS(required string css, string reference=""){
		context().addCSS(argumentCollection:arguments);
	}
	public void function addInlineCSS(required string css, string selector=""){
		context().addInlineCSS(argumentCollection:arguments);
	}
	public any function config(string key, any default=""){
		return context().config(argumentCollection:arguments);
	}
	public any function getAttributeTemplate(string templateName){
		return context().getAttributeTemplate(argumentCollection:arguments);
	}
	public any function getStyleTemplate(string templateName){
		return context().getStyleTemplate(argumentCollection:arguments);
	}
	public string function toHTML(string input){
		return context().toHTML(argumentCollection:arguments);
	}
	public string function htmlToText(string input){
		return context().htmlToText(argumentCollection:arguments);
	}
	public string function newTextLine(){
		return context().newTextLine();
	}
	
	/**
	* @hint returns our child content
	*/
	public string function getChildContent(){
		return variables._childContent;
	}

	/**
	* @hint sets our child content
	*/
	public void function setChildContent(string content=""){
		variables._childContent = arguments.content;
	}

	/**
	* @hint returns an attribute value by checking some possible locations:
	* 1. attribute set on the tag itself
	* 2. default attrbitue set via our head attributes for our tag name
	* 3. default attrbitue set via our head attributes for all tags
	* 4. a default value set within the tag cfc itself - generally a fallback value
	*/
	public any function getAttribute(string key, any default=""){
		// attrbiute value set
		if(structKeyExists(variables._attributes, arguments.key)){
			return variables._attributes[arguments.key];
		}

		if(hasNode()){
			// tag specific default
			local.defaults = variables._context.getDefaultAttributes(tagName());
			if(structKeyExists(local.defaults, arguments.key)){
				return local.defaults[arguments.key];
			}
			// 'all' default
			local.defaults = variables._context.getDefaultAttributes("all");
			if(structKeyExists(local.defaults, arguments.key)){
				return local.defaults[arguments.key];
			}
		}

		// default set within tag component
		if(structKeyExists(variables._defaultAttributes, arguments.key)){
			return variables._defaultAttributes[arguments.key];
		}

		return arguments.default;
	}

	/**
	* @hint sets an attribute value
	*/
	public any function setAttribute(string key, any value){
		variables._attributes[arguments.key] = arguments.value;
	}

	/**
	* @hint called before a tag gets rendered
	*/
	public void function before(){
		
	}
	
	/**
	* @hint perform the actual redner of our tag
	*/
	public string function render(){
		return getChildContent();
	}

	/**
	* @hint perform a text render of our tag
	*/
	public string function renderText(){
		return htmlToText(getChildContent());
	}

	/**
	* @hint returns our tag style definitions - these get used to populate our htmlAttribute styles
	*/
	public struct function getStyles(){
		return {};
	}

	/**
	* @hint processes a given struct of attributes to check for 'addclass' and 'template'
	*/
	public struct function parseAttributes(struct attr){
		if(structKeyExists(arguments.attr, "addclass")){
			if(structKeyExists(arguments.attr, "class")){
				arguments.attr.class = listAppend(arguments.attr.class, arguments.attr.addclass, " ");
			}else{
				arguments.attr["class"] = arguments.attr.addclass;
			}
		}
		structDelete(arguments.attr, "addclass");

		// check one or more template names and merge them into our defined attributes
		if(structKeyExists(arguments.attr, "template")){
			local.templateKeys = listToArray(arguments.attr.template);
			for(local.templateKey in local.templateKeys){
				local.template = getAttributeTemplate(local.templateKey);
				if(isStruct(local.template)){
					structAppend(arguments.attr, parseAttributes(local.template), false);
				}

				if(structKeyExists(arguments.attr, "addclass")){
					if(structKeyExists(arguments.attr, "class")){
						arguments.attr.class = listAppend(arguments.attr.class, arguments.attr.addclass, " ");
					}else{
						arguments.attr["class"] = arguments.attr.addclass;
					}
				}
				structDelete(arguments.attr, "addclass");
			}
			structDelete(arguments.attr, "template");

		}
		return arguments.attr;
	}	

	/**
	* @hint outputs a string of HTML attributes and inline style
	*/
	public string function htmlAttributes(struct attr){
		local.out = [];

		arguments.attr = parseAttributes(arguments.attr);

		for(local.key in arguments.attr){
			local.value = arguments.attr[local.key];
			local.key = lCase(replace(local.key, "_", "-", "ALL"));
			

			if(local.key == "style"){
				local.value = style(local.value);
			}

			if(len(trim(local.value))){
				arrayAppend(local.out, local.key & "=""" & local.value & """");	
			}
					
		}

		if(arrayLen(local.out)){
			return " " & arrayToList(local.out, " ");
		}

		return "";
	}


	/**
	* @hint parses a struct of styles to include template styles if defined
	*/
	public struct function parseStyle(any styles){
		if(!isStruct(arguments.styles)){
			if(len(arguments.styles)){
				arguments.styles = {"template":arguments.styles};
			}else{
				return {};
			}
		}


		if(structKeyExists(arguments.styles, "template")){
			local.templateKeys = listToArray(arguments.styles.template);
			for(local.templateKey in local.templateKeys){
				local.template = getStyle(local.templateKey);
				if(isStruct(local.template)){
					structAppend(arguments.styles, parseStyle(local.template), false);
				}

				/*local.template = getStyleTemplate(local.templateKey);
				if(isStruct(local.template)){
					structAppend(arguments.styles, parseStyle(local.template), false);
				}*/
				
			}
			structDelete(arguments.styles, "template");
		}
		return arguments.styles;

	}

	/**
	* @hint converts a given struct of styles into an inline style string
	*/
	public string function style(any styles){
		local.out = [];
		arguments.styles = parseStyle(arguments.styles);

		for(local.key in arguments.styles){
			local.value = arguments.styles[local.key];
			local.key = lCase(replace(local.key, "_", "-", "ALL"));

			if(len(local.value)){
				arrayAppend(local.out, local.key & ":" & local.value);
			}

		}
		return arrayToList(local.out, ";");
	}

	/**
	* @hint gets defined styles by a given name
	*/
	public any function getStyle(string styleName){
		local.styles = getStyles();
		if(structKeyExists(local.styles, arguments.styleName)){
			return local.styles[arguments.styleName];
		}
		return "";
	}

	/**
	* @hint wraps content in an mso | IE conditional comment
	*/
	public string function conditional(string content, boolean negation=false, string agent="mso | IE"){
		local.markup = ["<!--[if"];
		if(arguments.negation) arrayAppend(local.markup, " !");
		arrayAppend(local.markup, arguments.agent & "]>");
		if(arguments.negation) arrayAppend(local.markup, "<!-->");
		arrayAppend(local.markup, arguments.content);
		if(arguments.negation) arrayAppend(local.markup, "<!--");
		arrayAppend(local.markup, "<![endif]-->");
		return arrayToList(local.markup, "");
	}
	
}
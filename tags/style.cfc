component extends="tag"{

	variables._defaultAttributes = {
		'inline': false,
		'selector': "",
		'reference': "",
		'type': "any"
 	};
	
	public string function render(){
		if(getAttribute('inline')){
			// inline css
			addInlineCSS(getChildContent(), getAttribute('selector'));
		}else{
			// css
			addCSS(getChildContent(), getAttribute('reference'), getAttribute('type'));
		}
		return "";
	}

}
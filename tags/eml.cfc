component extends="tag"{

	variables._defaultAttributes = {
		'lang': 'en'
	};
	
	public string function render(){
		context().setProperty("lang", getAttribute('lang'));
		return header() & getChildContent() & footer();
	}

	

	public string function header(){
		savecontent variable="local.templateHead"{
			include template="../includes/inc_templateHeader.cfm";
		}
		return local.templateHead;
	} 

	public string function footer(){
		savecontent variable="local.templateFoot"{
			include template="../includes/inc_templateFooter.cfm";
		}
		return local.templateFoot;
	} 

	

	
}
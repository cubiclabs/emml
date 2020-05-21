component extends="tag"{

	variables._defaultAttributes = {
		'spaces': 1,
	};


	public string function render(){
		return repeatString("&nbsp;", val(getAttribute('spaces')));
	}

	public string function renderText(){
		return repeatString(" ", val(getAttribute('spaces')));
	}
	
}
component extends="tag"{

	variables._defaultAttributes = {
		'previewPadding': true
	};

	public void function render(){
		context().setProperty("preview", getChildContent());
		context().setProperty("previewPadding", getAttribute('previewPadding'));
		return "";
	}
}
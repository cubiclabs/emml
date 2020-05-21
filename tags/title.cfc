component extends="tag"{

	public void function render(){
		context().setProperty("title", getChildContent());
		return "";
	}
}
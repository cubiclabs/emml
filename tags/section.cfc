component extends="row"{

	/**
	* @hint constructor
	*/
	public any function init(any context, struct attributes={}, string childContent=""){
		local.out = super.init(argumentCollection:arguments);

		setAttribute("section", true);
		
		return local.out;
	}
	
}
component extends="tag"{

	public boolean function processChildren(){
		return false;
	}


	public void function before(){
		
		if(hasNode()){
			for(local.child in getNode().xmlChildren){

				local.tagName = this.tagName(local.child.xmlName);

				if(local.tagName == "class"){
					
					local.templateArgs = local.child.xmlAttributes;

					if(structKeyExists(local.templateArgs, "name")
						AND len(local.templateArgs.name)){

						local.name = local.templateArgs.name;
						local.args = duplicate(local.templateArgs);
						structDelete(local.args, "name");

						context().setAttributeTemplate(local.name, local.args);
					}
				}else{
					context().setDefaultAttributes(local.tagName, local.child.xmlAttributes);	
				}

				
			}
		}


	}

}
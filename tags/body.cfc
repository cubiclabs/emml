component extends="tag"{

	variables._defaultAttributes = {
		//'width': '600px'
	};
	
	public string function getContainerWidth(){
		return getAttribute('width', config("containerWidth") & 'px');
	}

	public struct function getStyles(){
		return {
			'div': {
				'background-color': getAttribute('background-color')
			}
		};
	}

	
	public string function render(){
		
		local.bodyAttr = htmlAttributes({
			addclass: getAttribute('css-class'),
			style: "div"
		});

		local.preview = "";
		if(len(context().getProperty("preview"))){
			local.preview = '<div style="display:none;font-size:1px;color:##ffffff;line-height:1px;max-height:0px;max-width:0px;opacity:0;overflow:hidden;">#context().getProperty("preview")#</div>';
			if(context().getProperty("previewPadding")){
				local.preview &= '<div style="display: none; max-height: 0px; overflow: hidden;">&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;</div>';
			}			
		}

		return "<body#local.bodyAttr#>
			#local.preview#
			<div#local.bodyAttr#>
				#getChildContent()#
			</div>
		</body>";
	}

	
	
}
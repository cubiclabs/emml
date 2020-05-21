component extends="tag"{

	variables._defaultAttributes = {
		'align': 'center',
		'border': '0',
		'height': 'auto',
		'target': '_blank',
		'font-size': '13px',
		//'background-color': '##ffffff'
	};

	public struct function getStyles(){

		local.fullWidth = getAttribute('full-width') == 'full-width';

		return {
			img: {
				'border': getAttribute('border'),
				'border-left': getAttribute('border-left'),
				'border-right': getAttribute('border-right'),
				'border-top': getAttribute('border-top'),
				'border-bottom': getAttribute('border-bottom'),
				'border-radius': getAttribute('border-radius'),
				'display': 'block',
				'outline': 'none',
				'text-decoration': 'none',
				'height': getAttribute('height'),
				'max-height': getAttribute('max-height'),
				'min-width': fullWidth ? '100%' : '',
				'width': fullWidth ? '100%': '',
				'max-width': fullWidth ? '' : '100%',
				'font-size': getAttribute('font-size')
				},
			td: {
				'background': getAttribute('background-color'),
				'padding': getAttribute('padding'),
				'padding-top': getAttribute('padding-top'),
				'padding-right': getAttribute('padding-right'),
				'padding-bottom': getAttribute('padding-bottom'),
				'padding-left': getAttribute('padding-left'),
				'width': fullWidth ? '' : getAttribute('width')
			},
			table: {
				'min-width': fullWidth ? '100%' : '',
				'max-width': fullWidth ? '100%' : getAttribute('max-width'),
				'width': fullWidth ? getAttribute('width') : '',
				'border-spacing': '0px'
			}
		};
	}

	public void function setCSS(){
		addCSS("table.em-full-width-mobile { width: 100% !important;}
			td.em-full-width-mobile { width: auto !important;}",
			"em-full-width-mobile", "sm");
	}

	public string function renderImage(){
		local.height = getAttribute('height');
		local.fullWidth = getAttribute('full-width') == 'full-width';
		
		local.fallbackWidth = getAttribute('fallback-width');
		if(local.fullWidth && !len(local.fallbackWidth)){
			local.fallbackWidth = val(getInnerWidth());
		}

		local.img = "<img #htmlAttributes({
			'align': getAttribute('align'),
			'height': len(local.height) ? local.height == 'auto' ? local.height : val(local.height) : '',
			'src': getAttribute('src'),
			'srcset': getAttribute('srcset'),
			'style': 'img',
			'title': getAttribute('title'),
			'width': local.fallbackWidth, // for outlook
			'usemap': getAttribute('usemap')
		})# alt=""#getAttribute('alt')#"" />";

		if(len(getAttribute('href'))){
			return "<a #htmlAttributes({
				'href': getAttribute('href'),
				'target': getAttribute('target'),
				'rel': getAttribute('rel'),
				'name': getAttribute('name'),
			})#>
			#local.img#
			</a>";
		}

    	return local.img;
	}


	public string function render(){

		local.fluidMobile = isBoolean(getAttribute('fluid-on-mobile')) && getAttribute('fluid-on-mobile');
		if(local.fluidMobile){
			setCSS();
		}

		local.height = getAttribute('height');

		local.tableClass = getAttribute('css-class');
		if(local.fluidMobile) local.tableClass &= "em-full-width-mobile";

		return "
			<table #htmlAttributes({
				'align': getAttribute('align'),
				'border': '0',
				'cellpadding': '0',
				'cellspacing': '0',
				'role': 'presentation',
				'style': 'table',
				'class': local.tableClass
			})#>
			
			<tr>
				<td #htmlAttributes({
					'style': 'td',
					'bgcolor': getAttribute('background-color'),
					'class': local.fluidMobile
						? 'em-full-width-mobile'
						: ''
				})#>
					#renderImage()#
				</td>
			</tr>
		
		</table>";
	}
	

	public string function renderText(){
		local.img = "[" & getAttribute('src') & "]";
		local.alt = getAttribute('alt');
		local.href = getAttribute('href');

		if(len(local.alt)){
			local.img &= " (" & local.alt & ")";
		}

		if(len(local.href)){
			local.img &= " [" & local.href & "]";
		}

		return local.img;
	}
}
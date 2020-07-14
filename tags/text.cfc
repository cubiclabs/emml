component extends="tag"{

	variables._defaultAttributes = {
		'align': 'auto',
		'color': '##000000',
		'font-family': 'Arial, sans-serif',
		'font-size': '13px',
		'line-height': '1',
		'padding': '10px 25px'
	};


	public struct function getStyles(){

		return {
			text: {
				'border-collapse': 'collapse',
				'font-family': getAttribute('font-family'),
				'font-size': getAttribute('font-size'),
				'font-style': getAttribute('font-style'),
				'font-weight': getAttribute('font-weight'),
				'letter-spacing': getAttribute('letter-spacing'),
				'line-height': getAttribute('line-height'),
				'text-align': getAttribute('align'),
				'text-decoration': getAttribute('text-decoration'),
				'text-transform': getAttribute('text-transform'),
				'color': getAttribute('color'),
				'height': getAttribute('height')
			},
			td: {
				'background-color': getAttribute('background-color'),
				'border': getAttribute('border'),
				'border-bottom': getAttribute('border-bottom'),
				'border-left': getAttribute('border-left'),
				'border-right': getAttribute('border-right'),
				'border-top': getAttribute('border-top'),
				'padding': getAttribute('padding'),
				'padding-bottom': getAttribute('padding-bottom'),
				'padding-left': getAttribute('padding-left'),
				'padding-right': getAttribute('padding-right'),
				'padding-top': getAttribute('padding-top'),
				'text-align': getAttribute('align'),
				'height': getAttribute('height'),
				'vertical-align': 'top'
			}
		};
	}

	public string function renderText(){
		return "<div #htmlAttributes({
			  'style': 'text',
			  'addclass': getAttribute('css-class')
			})#>#getChildContent()#</div>";
	}

	public string function render(){
		local.height = getAttribute("height");

		local.tdAtrr = {
			'style': 'td'
		};
		if(len(local.height)){
			local.tdAtrr['height'] = val(local.height);
		}

		return '
			<table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr><td #htmlAttributes(local.tdAtrr)#>
					#renderText()#
				</td></tr>
			</table>';

		if(len(local.height)){
			return conditional('<table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td height="#val(local.height)#" style="vertical-align:top;height:#local.height#;">')
			 & renderText()
			 & conditional('</td></tr></table>');
		}

		return renderText();
	}
	
}
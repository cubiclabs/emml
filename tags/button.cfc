component extends="tag"{


	variables._defaultAttributes = {
		'align': 'center',
		'background-color': '##414141',
		'border': 'none',
		'border-radius': '3px',
		'color': '##ffffff',
		'font-family': 'Arial, sans-serif',
		'font-size': '13px',
		'font-weight': 'normal',
		'inner-padding': '10px 25px',
		'line-height': '120%',
		'padding': '10px 0',
		'target': '_blank',
		'text-decoration': 'none',
		'text-transform': 'none',
		'vertical-align': 'middle'
	};

	public struct function getStyles(){
		return {
			table: {
				'border-collapse': 'separate',
				'width': getAttribute('width'),
				'line-height': '100%'
			},
			td: {
				'border': getAttribute('border'),
				'border-bottom': getAttribute('border-bottom'),
				'border-left': getAttribute('border-left'),
				'border-radius': getAttribute('border-radius'),
				'border-right': getAttribute('border-right'),
				'border-top': getAttribute('border-top'),
				'cursor': 'auto',
				'font-style': getAttribute('font-style'),
				'height': getAttribute('height'),
				'mso-padding-alt': getAttribute('inner-padding'),
				'text-align': getAttribute('text-align'),
				'background': getAttribute('background-color')
			},
			content: {
				'display': 'inline-block',
				'width': getAttribute('width'),
				'background': getAttribute('background-color'),
				'color': getAttribute('color'),
				'font-family': getAttribute('font-family'),
				'font-size': getAttribute('font-size'),
				'font-style': getAttribute('font-style'),
				'font-weight': getAttribute('font-weight'),
				'line-height': getAttribute('line-height'),
				'letter-spacing': getAttribute('letter-spacing'),
				'margin': '0',
				'text-decoration': getAttribute('text-decoration'),
				'text-transform': getAttribute('text-transform'),
				'padding': getAttribute('inner-padding'),
				'mso-padding-alt': '0px',
				'border-radius': getAttribute('border-radius')
			},
			wrapper: {
				'width': getAttribute('inline', false) ? '' : '100%',
				'display': getAttribute('inline', false) ? 'inline-block' : '',
			},
			wrappertd: {
				'padding': getAttribute('padding'),
				'padding-top': getAttribute('padding-top'),
				'padding-right': getAttribute('padding-right'),
				'padding-bottom': getAttribute('padding-bottom'),
				'padding-left': getAttribute('padding-left')//,
				//'width': '100%'
			}
		};
	}

	public string function render(){
		local.tag = len(getAttribute('href')) ? 'a' : 'span';
		
		return "<table #htmlAttributes({
			'border': '0',
			'cellpadding': '0',
			'cellspacing': '0',
			'align': getAttribute('align'),
			'role': 'presentation',
			'style': 'wrapper'
		})#>
			<tr>
				<td #htmlAttributes({
					//'align': getAttribute('align'),
					'style': 'wrappertd'
				})#>
		<table #htmlAttributes({
			'border': '0',
			'cellpadding': '0',
			'cellspacing': '0',
			'role': 'presentation',
			'style': 'table',
			'align': getAttribute('align')
		})#>
			<tr>
				<td #htmlAttributes({
					'align': 'center',
					'bgcolor': getAttribute('background-color') == 'none'
						? ''
						: getAttribute('background-color'),
					'role': 'presentation',
					'style': 'td',
					'valign': getAttribute('vertical-align')
				})#>
					<#local.tag# #htmlAttributes({
						'href': getAttribute('href'),
						'rel': getAttribute('rel'),
						'name': getAttribute('name'),
						'style': 'content',
						'target': local.tag == 'a' ? getAttribute('target') : '',
					})#>
					#getChildContent()#
					</#local.tag#>
				</td>
			</tr>
		</table>

		</td>
		</tr></table>";
	}


	public string function renderText(){
		local.buttonContent = super.renderText();

		if(len(getAttribute('href'))){
			local.buttonContent &= " [" & getAttribute('href') & "]";
		}

		return local.buttonContent;
	}
	
}
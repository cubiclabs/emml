component extends="tag"{


	variables._defaultAttributes = {
		'align': 'center',
		'background-color': '##414141',
		'border': 'none',
		'border-radius': '3px',
		'color': '##ffffff',
		'font-family': 'Arial, sans-serif',
		'font-size': '14px',
		'font-weight': 'normal',
		'inner-padding': '10px 25px',
		'line-height': '18px',
		'padding': '10px 0',
		'target': '_blank',
		'text-decoration': 'none',
		'text-transform': 'none',
		'vertical-align': 'middle'
	};

	public struct function getStyles(){
		local.styles = {
			"table": structNew("ordered"),
			"td": structNew("ordered"),
			"content": structNew("ordered"),
			"wrapper": structNew("ordered"),
			"wrappertd": structNew("ordered")
		};

		local.styles.table['border-collapse'] = 'separate';
		local.styles.table['width']=  getAttribute('width');
		
		local.styles.td['border'] = getAttribute('border');
		local.styles.td['border-bottom'] = getAttribute('border-bottom');
		local.styles.td['border-left'] = getAttribute('border-left');
		local.styles.td['border-radius'] = getAttribute('border-radius');
		local.styles.td['border-right'] = getAttribute('border-right');
		local.styles.td['border-top'] = getAttribute('border-top');
		local.styles.td['cursor'] = 'auto';
		local.styles.td['font-style'] = getAttribute('font-style');
		local.styles.td['height'] =getAttribute('height');
				//'mso-padding-alt': getAttribute('inner-padding'),
		local.styles.td['text-align'] = getAttribute('text-align');
		local.styles.td['background'] = getAttribute('background-color');

		local.styles.content['display'] = 'block';
		local.styles.content['width'] = getAttribute('width');
		local.styles.content['background'] = getAttribute('background-color');
		local.styles.content['border'] = "1px solid #getAttribute('background-color')#";
		local.styles.content['color'] = getAttribute('color');
		local.styles.content['font-family'] = getAttribute('font-family');
		local.styles.content['font-size'] = getAttribute('font-size');
		local.styles.content['font-style'] = getAttribute('font-style');
		local.styles.content['font-weight'] = getAttribute('font-weight');
		local.styles.content['mso-line-height-rule'] = 'exactly';
		local.styles.content['line-height'] = getAttribute('line-height');
		local.styles.content['letter-spacing'] = getAttribute('letter-spacing');
		local.styles.content['margin'] = '0';
		local.styles.content['text-decoration'] = getAttribute('text-decoration');
		local.styles.content['text-transform'] = getAttribute('text-transform');
		local.styles.content['padding'] = getAttribute('inner-padding');
				//'mso-padding-alt': '0px',
		local.styles.content['border-radius'] = getAttribute('border-radius');

		local.styles.wrapper['width'] = getAttribute('inline', false) ? '' : '100%';
		local.styles.wrapper['display'] = getAttribute('inline', false) ? 'inline-block' : '';

		local.styles.wrappertd['padding'] = getAttribute('padding');
		local.styles.wrappertd['padding-top'] = getAttribute('padding-top');
		local.styles.wrappertd['padding-right'] = getAttribute('padding-right');
		local.styles.wrappertd['padding-bottom'] = getAttribute('padding-bottom');
		local.styles.wrappertd['padding-left'] = getAttribute('padding-left');
				//'width': '100%'
		return local.styles;
	}

	public string function render(){
		local.tag = len(getAttribute('href')) ? 'a' : 'span';
		
		return "<table #htmlAttributes({
			'border': '0',
			'cellpadding': '0',
			'cellspacing': '0',
			//'align': getAttribute('align'),
			'role': 'presentation',
			'style': 'wrapper'
		})#>
			<tr>
				<td #htmlAttributes({
					'align': getAttribute('align'),
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
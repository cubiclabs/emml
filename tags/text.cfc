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
		local.styles = structNew("ordered");
		local.styles["text"] = structNew("ordered");
		local.styles["td"] = structNew("ordered");

		local.styles.text['mso-line-height-rule'] = 'exactly';
		local.styles.text['border-collapse'] = 'collapse';
		local.styles.text['font-family'] = getAttribute('font-family');
		local.styles.text['font-size'] = getAttribute('font-size');
		local.styles.text['font-style'] = getAttribute('font-style');
		local.styles.text['font-weight'] = getAttribute('font-weight');
		local.styles.text['letter-spacing'] = getAttribute('letter-spacing');
		local.styles.text['line-height'] = getAttribute('line-height');
		local.styles.text['text-align'] = getAttribute('align');
		local.styles.text['text-decoration'] = getAttribute('text-decoration');
		local.styles.text['text-transform'] = getAttribute('text-transform');
		local.styles.text['color'] = getAttribute('color');
		local.styles.text['height'] = getAttribute('height');
		
		local.styles.td['background-color'] = getAttribute('background-color');
		local.styles.td['border'] = getAttribute('border');
		local.styles.td['border-bottom'] = getAttribute('border-bottom');
		local.styles.td['border-left'] = getAttribute('border-left');
		local.styles.td['border-right'] = getAttribute('border-right');
		local.styles.td['border-top'] = getAttribute('border-top');
		local.styles.td['padding'] = getAttribute('padding');
		local.styles.td['padding-bottom'] = getAttribute('padding-bottom');
		local.styles.td['padding-left'] = getAttribute('padding-left');
		local.styles.td['padding-right'] = getAttribute('padding-right');
		local.styles.td['padding-top'] = getAttribute('padding-top');
		local.styles.td['text-align'] = getAttribute('align');
		local.styles.td['height'] = getAttribute('height');
		local.styles.td['vertical-align'] = 'top';
		
		return local.styles;
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
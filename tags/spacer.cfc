component extends="tag"{

	variables._defaultAttributes = {
		'height': '20px',
	};


	public struct function getStyles(){
		return {
			div: {
				'height': getAttribute('height')
			},
			table: {
				'mso-hide': getAttribute('outlook-hidden') == "outlook-hidden" ? 'all' : ''
			},
			td: {
				'vertical-align': 'top',
				'height': getAttribute("height"),
				'font-size': '0px',
				'line-height': '0px'
			}
		};
	}

	public string function render(){
		local.height = getAttribute("height");

		return '<table role="presentation" border="0" cellpadding="0" cellspacing="0"#htmlAttributes({
					'addclass': getAttribute('css-class'),
					'style': 'table'
					})#>
			<tr><td#htmlAttributes({
					'height': val(local.height),
					'aria-hidden': 'true',
					'style': 'td'
					})#>&nbsp;</td></tr></table>';
		/*
		return conditional('<table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td#htmlAttributes({
				'height': val(local.height),
				'aria-hidden': 'true',
				'style': 'table',
				})#')
			& "<div #htmlAttributes({
				'style': 'div',
				})#>#getChildContent()#</div>"
			& conditional('</td></tr></table>');
		*/
	}

	public string function renderText(){
		return newTextLine();
	}
}
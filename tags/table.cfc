component extends="tag"{

	variables._defaultAttributes = {
		'align': 'left',
		'border': 'none',
		'cellpadding': '0',
		'cellspacing': '0',
		'color': '##000000',
		'font-family': 'Arial, sans-serif',
		'font-size': '13px',
		'line-height': '22px',
		//'table-layout': 'auto',
		'width': '100%',
		'role': 'presentation'
	};


	public struct function getStyles(){
		return {
			table: {
				'border-collapse': 'collapse',
				'color': getAttribute('color'),
				'background-color': getAttribute('background-color'),
				'width': getAttribute('width'),
				'border': getAttribute('border'),
				'border-spacing': getAttribute('border-spacing'),
				'mso-hide': getAttribute('outlook-hidden') == "outlook-hidden" ? 'all' : ''
			}
		};
	}

	

	public string function render(){
		
		return '<table #htmlAttributes({
			'cellpadding': getAttribute('cellpadding'),
			'cellspacing': getAttribute('cellspacing'),
			'width': getAttribute('width'),
			'addclass': getAttribute('css-class'),
			'role': getAttribute('role'),
			'border': '0',
			'style': 'table'
		})#>
			#getChildContent()#
		</table>';
	}
	
}
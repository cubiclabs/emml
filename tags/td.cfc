component extends="tag"{

	variables._defaultAttributes = {
		'align': 'left',
		'color': '##000000',
		//'font-family': 'Arial, sans-serif',
		'font-size': '13px',
		//'cell-font-size': '0px',
		'line-height': '22px'
	};


	public struct function getStyles(){
		return {
			td: {
				'border': getAttribute('border'),
				'color': getAttribute('color'),
				'text-align': getAttribute('align'),
				'background-color': getAttribute('background-color'),
				'font-size': getAttribute('font-size'),
				'padding': getAttribute('padding'),
				'padding-top': getAttribute('padding-top'),
				'padding-right': getAttribute('padding-right'),
				'padding-bottom': getAttribute('padding-bottom'),
				'padding-left': getAttribute('padding-left'),
				'word-break': 'break-word',
				'width': getAttribute('width'),
				'vertical-align': getAttribute('vertical-align')
			},
			text: {
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
			}
		};
	}

	

	public string function render(){

		local.tdWidth = getAttribute('width');
		if(right(local.tdWidth, 2) IS "px"){
			local.tdWidth = val(local.tdWidth);
		}


		return '<td #htmlAttributes({
			'valign': getAttribute('vertical-align'),
			'align': getAttribute('align'),
			'width': local.tdWidth,
			'colspan': getAttribute('colspan'),
			'rowspan': getAttribute('rowspan'),
			'addclass': getAttribute('css-class'),
			'style': 'td'})#>
			#getChildContent()#
		</td>';
		
		return '<td #htmlAttributes({
			'valign': getAttribute('vertical-align'),
			'width': getAttribute('width'),
			'addclass': getAttribute('css-class'),
			'style': 'td'})#>
		<div #htmlAttributes({
			'style': 'text'})#>
			#getChildContent()#
		</div>
		</td>';
	}
	
}
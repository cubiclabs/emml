component extends="tag"{

	variables._defaultAttributes = {
		'align': 'center',
		'border-color': '##000000',
		'border-style': 'solid',
		'border-width': '4px',
		'padding': '10px 25px',
		'width': '100%'
	};


	public struct function getStyles(){

		local.borderStyle = [];
		if(len(getAttribute("border-style"))){
			arrayAppend(local.borderStyle, getAttribute("border-style"));
		}
		if(len(getAttribute("border-width"))){
			arrayAppend(local.borderStyle, getAttribute("border-width"));
		}
		if(len(getAttribute("border-color"))){
			arrayAppend(local.borderStyle, getAttribute("border-color"));
		}
		local.borderStyle = arrayToList(local.borderStyle, " ");

		return {
			divider: {
				'border-top': local.borderStyle,
				'font-size': '1px',
				'margin': '0px auto',
				'width': getAttribute('width')
			},
			wrapper: {
				'border': '0px',
				'font-size': '0px',
				'width': '100%'
			},
			wrappertd: {
				'align': getAttribute('align'),
				'font-size': '0px',
				'padding': getAttribute('padding'),
				'padding-top': getAttribute('padding-top'),
				'padding-right': getAttribute('padding-right'),
				'padding-bottom': getAttribute('padding-bottom'),
				'padding-left': getAttribute('padding-left'),
				'width': '100%'
			}
		};
	}



	public string function render(){
		


		return "
		<table #htmlAttributes({
			'border': '0',
			'cellpadding': '0',
			'cellspacing': '0',
			'style': 'wrapper',
			'role': 'presentation',
			'width': '100%',
		})#>
			<tr>
				<td #htmlAttributes({
					'style': 'wrappertd',
					'width': '100%',
				})#>
					<table #htmlAttributes({
						'align': getAttribute('align'),
						'cellpadding': '0',
						'cellspacing': '0',
						'style': 'divider',
						'role': 'presentation',
						'width': getAttribute('width')
					})#>
						<tr>
							<td style=""height:0;line-height:0;"">
								&nbsp;
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>";
	}
	

	public string function renderText(){
		return "----------------------------";
	}
}
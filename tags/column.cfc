component extends="tag"{

	variables._defaultAttributes = {
		'direction': 'ltr',
		'vertical-align': 'top',
		'align': 'left',
		'color': '##000000',
		'font-family': 'Arial, sans-serif',
		'font-size': '14px',
		'line-height': '1',
		'fluid': true
	};

	public numeric function columnCount(){
		if(hasContainer()){
			local.cols = 0;
			local.siblings = getContainer().getNode().xmlChildren;
			for(local.sibling in local.siblings){
				if(local.sibling.xmlName == "em-column"){
					cols++;
				}
			}
			return cols;
		}
		return 1;
	}

	public string function columnClassName(){
		if(getAttribute('fluid', true)){
			local.p = round(100/columnCount());
			return "em-column-" & local.p;	
		}
		return "";
	}

	public void function columnCSS(){
		
		addCSS(".em-minheight100{
			min-height: 100%;
		}", "em-minheight100", "sm");
		
		addCSS(".em-minheight100{
			min-height: 100%;
		}", "em-minheight100", "lg");

		if(getAttribute('fluid', true)){
			local.w = 100/columnCount();
			addCSS("." & columnClassName() & "{
				width: #local.w#% !important;
				max-width: #local.w#%;
			}", columnClassName(), "lg");
			addCSS(".em-column{
				height: auto !important;
				min-height: 0px !important;
			}", "em-column", "sm");	
		}
	}

	public string function getColumnWidth(){
		if(getAttribute('fluid', true)){
			return "100%";
		}else{
			local.w = getAttribute('width');
			if(len(local.w)){
				return local.w;
			}
			return 100/columnCount() & "%";
		}
	}

	public struct function getStyles(){

		return {
			div: {
				'background-color': getAttribute('background-color'),
				'font-size': '0px',
				'text-align': 'left',
				'direction': getAttribute('direction'),
				'display': getAttribute('display', 'inline-block'),
				'vertical-align': getAttribute('vertical-align'),
				'width': getColumnWidth(),
				//'min-height': "100%"
				//'height': '100%', // breaks thunderbird...
				//'padding': getAttribute('padding'),
				//'padding-top': getAttribute('padding-top'),
				//'padding-right': getAttribute('padding-right'),
				//'padding-bottom': getAttribute('padding-bottom'),
				//'padding-left': getAttribute('padding-left'),
				//'box-sizing': 'border-box'
			},
			tdOutlook: {
				'background-color': getAttribute('background-color'),
				//'padding': getAttribute('padding'),
				//'padding-top': getAttribute('padding-top'),
				//'padding-right': getAttribute('padding-right'),
				//'padding-bottom': getAttribute('padding-bottom'),
				//'padding-left': getAttribute('padding-left'),
				//'vertical-align': getAttribute('vertical-align'),
				'vertical-align': 'top',
				'width': getOuterWidth(len(getAttribute('outlook-width')) ? getAttribute('outlook-width') : getAttribute('width'))
			},
			table: {
				'background-color': getAttribute('inner-background-color'),
				'border': getAttribute('border'),
				'border-bottom': getAttribute('border-bottom'),
				'border-left': getAttribute('border-left'),
				'border-radius': getAttribute('border-radius'),
				'border-right': getAttribute('border-right'),
				'border-top': getAttribute('border-top'),
				//'vertical-align': getAttribute('vertical-align'),
				//'height': '100%'
				'border-spacing': '0px'
			},
			td: {
				'font-size': '0px',
				'padding': getAttribute('inner-padding'),
				'padding-top': getAttribute('inner-padding-top'),
				'padding-right': getAttribute('inner-padding-right'),
				'padding-bottom': getAttribute('inner-padding-bottom'),
				'padding-left': getAttribute('inner-padding-left'),
				'word-break': 'break-word',
				//'vertical-align': getAttribute('vertical-align')
			},
			paddingCell: {
				'padding': getAttribute('padding'),
				'padding-top': getAttribute('padding-top'),
				'padding-right': getAttribute('padding-right'),
				'padding-bottom': getAttribute('padding-bottom'),
				'padding-left': getAttribute('padding-left')
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
				'color': getAttribute('color')
			}
		};
	}

	public string function getPaddingString(){
		return trim(htmlAttributes({
			'padding': getAttribute('padding'),
			'padding-top': getAttribute('padding-top'),
			'padding-right': getAttribute('padding-right'),
			'padding-bottom': getAttribute('padding-bottom'),
			'padding-left': getAttribute('padding-left')
		}));
	}

	public string function paddingTableOpen(){
		if(len(getPaddingString())){
			return "<table #htmlAttributes({
				'border': '0',
				'cellpadding': '0',
				'cellspacing': '0',
				'role': 'presentation',
				'width': '100%'
			})#><tr><td #htmlAttributes({
				'style': 'paddingCell'
			})#>";
		}
		return "";
	}

	public string function paddingTableClose(){
		if(len(getPaddingString())){
			return '</td></tr></table>';
		}
		return "";
	}

	public string function render(){
		columnCSS();

		local.classes = "em-minheight100";
		if(getAttribute('fluid', true)){
			local.classes &= " " & columnClassName() & " em-column em-outlook-group-fix";	
		}
		if(len(getAttribute('css-class'))){
			local.classes &= " " & getAttribute('css-class');
		}

		/* IMPORTANT - column tags need to be flsuh against one another in order to render properly on iOS gMail app.
		
		<em-column>
			stuff
		</em-column><em-column>
			more stuff
		</em-column>

		*/

		return "<!--[if mso | IE]><td #htmlAttributes({
				'align': getAttribute('align'),
				'addclass': getAttribute('css-class') & ' outlook',
				'style': 'tdOutlook'
              })#><![endif]--><div #htmlAttributes({
			'class': local.classes,
			'style': 'div'
		})#>

        #paddingTableOpen()#

		<table #htmlAttributes({
			'align': getAttribute('align'),
			'border': '0',
			'cellpadding': '0',
			'cellspacing': '0',
			'role': 'presentation',
			'style': 'table',
			'width': '100%',
			//'height': '100%',
			'class': 'em-column'
		})#>

			<tr>
				<td #htmlAttributes({
						'align': getAttribute('align'),
						'style': 'td'
				})#>
					<div #htmlAttributes({
						'style': 'text'
					})#>
						#getChildContent()#
					</div>
				</td>
			</tr>
		</table>

		#paddingTableClose()#
		
		</div><!--[if mso | IE]></td><![endif]-->";
	}


	public string function renderText(){
		return newTextLine() & super.renderText() & newTextLine();
	}
	
}
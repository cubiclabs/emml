component extends="tag"{

	variables._defaultAttributes = {
		'background-repeat': 'repeat',
		'background-size': 'auto',
		'backgrouond-position': 'top center',
		'direction': 'ltr',
		'padding': '20px 0',
		'text-align': 'left',
		'text-padding': '4px 4px 4px 0',
		'section': false,
		'valign': 'top',
		'outlook-nobgimage': false
 	};
	
 	public boolean function isFullWidth(){
 		return getAttribute('full-width') == 'full-width';
 	}

 	public boolean function hasBackground() {
		return len(getAttribute('background-url'));
	}

	public struct function getStyles(){

		local.tdHeight = getAttribute('height');
		if(len(local.tdHeight) AND right(local.tdHeight, 2) IS "px"){
			local.tdHeight = val(local.tdHeight) - paddingHeight();
			local.tdHeight &= "px";
		}

		local.background = len(getAttribute('background-url')) ? 
			//getBackgroundDefinition() : 
			{
				'background': getBackgroundString()
			} :
			{
				'background': getAttribute('background-color'),
				'background-color': getAttribute('background-color')
			};

		local.ret = {
			tableFullwidth: {
				//...(fullWidth ? background : {}),
				'width': '100%',
				'border-radius': getAttribute('border-radius')
			},
			table: {
				//...(fullWidth ? {} : background),
				'border-collapse': 'collapse',
				'width': '100%',
				'border-radius': getAttribute('border-radius'),
				'height': '1px'
			},
			td: {
				'border': getAttribute('border'),
				'border-bottom': getAttribute('border-bottom'),
				'border-left': getAttribute('border-left'),
				'border-right': getAttribute('border-right'),
				'border-top': getAttribute('border-top'),
				'direction': getAttribute('direction'),
				'font-size': '0px',
				'padding': getAttribute('padding'),
				'padding-bottom': getAttribute('padding-bottom'),
				'padding-left': getAttribute('padding-left'),
				'padding-right': getAttribute('padding-right'),
				'padding-top': getAttribute('padding-top'),
				'text-align': getAttribute('text-align'),
				'height': local.tdHeight
			},
			div: {
				//...(fullWidth ? {} : background),
				'margin': '0px auto',
				'border-radius': getAttribute('border-radius'),
				'max-width': getContainerWidth()
			},
			innerDiv: {
				'line-height': '0',
				'font-size': '0'
			},
			outlookBGTable: {
				'border-collapse': 'collapse',
				'width': len(getAttribute('outlook-bg-width')) ? getAttribute('outlook-bg-width') : getContainerWidth(),
				'height': len(getAttribute('outlook-bg-height')) ? getAttribute('outlook-bg-height') : getAttribute('height')
			},
			outlookBGTd: {
				'width': len(getAttribute('outlook-bg-width')) ? getAttribute('outlook-bg-width') : getContainerWidth(),
				'height': len(getAttribute('outlook-bg-height')) ? getAttribute('outlook-bg-height') : getAttribute('height')
			},
			outlookBGImage: {
				'behavior': 'url(##default##VML)',
				'display': 'inline-block',
				'position': 'absolute',
				'width': len(getAttribute('outlook-bg-width')) ? getAttribute('outlook-bg-width') : getContainerWidth(),
				'height': len(getAttribute('outlook-bg-height')) ? getAttribute('outlook-bg-height') : getAttribute('height'),
				'top': '0',
				'left': '0',
				'border': '0',
				'z-index': '1'
			},
			outlookBGRect: {
				'display': 'inline-block',
				'position': 'absolute',
				'width': len(getAttribute('outlook-bg-width')) ? getAttribute('outlook-bg-width') : getContainerWidth(),
				'height': len(getAttribute('outlook-bg-height')) ? getAttribute('outlook-bg-height') : getAttribute('height'),
				'top': '0',
				'left': '0',
				'border': '0',
				'z-index': '2'
			}
		};

		if(isFullWidth()){
			structAppend(local.ret.tableFullwidth, local.background);
		}else{
			structAppend(local.ret.table, local.background);
			structAppend(local.ret.div, local.background);
		}

		return local.ret;
	}

	public void function defineCSS(){
		// by putting these CSS classes into media queries, they will get removed by gMAIL IMAP clients
		// and prevent a layout problem in the process
		addCSS(".em-height100{
			height: 100%;
		}", "em-height100", "lg");

		addCSS(".em-height100{
			height: 100%;
		}", "em-height100", "sm");
	}

	// backround shorthand css is required in order to support GANGA (Gmail App for Non Google Accounts)
	// https://freshinbox.com/blog/gmail-imap-ganga-finally-supports-background-images/
	public string function getBackgroundString(){
		local.str = [getAttribute('background-color')];
		if(hasBackground()){
			arrayAppend(local.str, "url(" & getAttribute('background-url') & ")");
			arrayAppend(local.str, "top center / " & getAttribute('background-size'));
			arrayAppend(local.str, getAttribute('background-repeat'));
		}
		return arrayToList(local.str, " ");
	}

	public struct function getBackgroundDefinition(){
		local.ret = {};
		local.ret["backgrouond-color"] = getAttribute('background-color');

		if(hasBackground()){
			local.ret["backgrouond-image"] = "url('" & getAttribute('background-url') & "')";
			local.ret["backgrouond-position"] = getAttribute('background-position');
			local.ret["backgrouond-size"] = getAttribute('background-size');
			local.ret["backgrouond-repeat"] = getAttribute('background-repeat');
		}
		return local.ret;
	}


	public string function renderBefore() {
    
		return '
			<!--[if mso | IE]>
				<table #htmlAttributes({
					'align': 'center',
					'border': '0',
					'cellpadding': '0',
					'cellspacing': '0',
					'role': 'presentation',
					'addclass': getAttribute('css-class') & ' outlook',
					'style': {
						'width': getContainerWidth(),
						'height': '1px'
					},
					'width': val(getContainerWidth()),
					'bgcolor': getAttribute('background-color')
				})#>
				<tr style="height:100%">
					<td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;height:100%">
			<![endif]-->';
	}


	public string function renderAfter() {
		return "
		<!--[if mso | IE]>
					</td>
				</tr>
			</table>
		<![endif]-->";
	}

	public string function renderWrappedChildren(){
    	
    	local.outlookOpen = "";
    	local.outlookClose = "";

		if(isBoolean(getAttribute("section")) AND !getAttribute("section")){
			local.outlookOpen = '<!--[if mso | IE]>
				<table role="presentation" border="0" cellpadding="0" cellspacing="0">
				<tr>
			<![endif]-->';

			local.outlookClose = '<!--[if mso | IE]>
				</tr>
				</table>
			<![endif]-->';	
		}


    	return "#local.outlookOpen#
			#getChildContent()#
			#local.outlookClose#";
      /*
      ${this.renderChildren(children, {
        renderer: component =>
          component.constructor.isRawElement()
            ? component.render()
            : `
          <!--[if mso | IE]>
            <td
              ${component.htmlAttributes({
                align: component.getAttribute('align'),
                class: suffixCssClasses(
                  component.getAttribute('css-class'),
                  'outlook',
                ),
                style: 'tdOutlook',
              })}
            >
          <![endif]-->
            ${component.render()}
          <!--[if mso | IE]>
            </td>
          <![endif]-->
    `,
      })}
      */
	}


	// NOTE: this does not render in the Windows 10 Mail client
	public string function __renderWithBackground(content){
		
		return '			
			<!--[if mso | IE]>
				<v:rect #htmlAttributes({
					'style': isFullWidth()
						? { 'mso-width-percent': '1000' }
						: { 'width': getContainerWidth() },
					'xmlns:v': 'urn:schemas-microsoft-com:vml',
					'fill': 'true',
					'stroke': 'false',
					'position': 'absolute'
				})#>
					<v:fill #htmlAttributes({
						'origin': '0.5, 0',
						'position': '0.5, 0',
						'src': getAttribute('background-url'),
						'color': getAttribute('background-color'),
						'type': 'tile'
					})# />
					
					<v:textbox style="mso-fit-shape-to-text:true" inset="0,0,0,0">
						<![endif]-->
							#arguments.content#
						<!--[if mso | IE]>
					</v:textbox>
				</v:rect>
			<![endif]-->';
	}

	public string function renderWithBackground(content){

		if(isBoolean(getAttribute('outlook-nobgimage')) AND getAttribute('outlook-nobgimage')){
			return arguments.content;
		}
		
		return '
			<!--[if gte mso 9]>
				<table #htmlAttributes({
					'style': 'outlookBGTable',
					'role': 'presentation',
					'border': '0',
					'cellpadding': '0',
					'cellspacing': '0'
				})#>
				<tr><td #htmlAttributes({'style': 'outlookBGTd'})#>
				<v:image #htmlAttributes({
					'style': 'outlookBGImage',
					'xmlns:v': 'urn:schemas-microsoft-com:vml',
					'src': len(getAttribute('outlook-bg-url')) ? getAttribute('outlook-bg-url') : getAttribute('background-url')
				})# />				
				<v:rect #htmlAttributes({
					'style': 'outlookBGRect',
					'xmlns:v': 'urn:schemas-microsoft-com:vml',
					'fill': 'true',
					'stroke': 'false'
				})#>
					<v:fill opacity="0%" style="z-index: 1;" />
					<div>            
			<![endif]--> 
				#arguments.content#
			<!--[if gte mso 9]>
				</div></v:fill></v:rect>
				</td></tr></table>
			<![endif]-->';
	}

	public string function renderSection(){
		return '
			<div #htmlAttributes({
				'class': isFullWidth() ? "" : getAttribute('css-class'),
				'style': 'div'
			})#>
			#hasBackground() ? "<div #htmlAttributes({'style': 'innerDiv'})#>" : ""#
			<table #htmlAttributes({
					//'align': 'left',
					'background': isFullWidth()
						? ""
						: getAttribute('background-url'),
					'border': '0',
					'cellpadding': '0',
					'cellspacing': '0',
					'role': 'presentation',
					'style': 'table'
				})#>
				<tbody class="em-height100">
					<tr class="em-height100">
						<td #htmlAttributes({
								'align': 'left',
								'style': 'td',
								'class': 'em-height100',
								'valign': getAttribute('valign')
							})#>
							#renderWrappedChildren()#
							
						</td>
					</tr>
				</tbody>
			</table>
			#hasBackground() ? '</div>' : ''#
			</div>';
	}

	public string function renderFullWidth(){
		local.content = hasBackground() ? 
			renderWithBackground(renderBefore() & renderSection() & renderAfter())
			: 
			renderBefore() & renderSection() & renderAfter();

		return '
			<table #htmlAttributes({
					//'align': 'center',
					'class': getAttribute('css-class'),
					'background': getAttribute('background-url'),
					'border': '0',
					'cellpadding': '0',
					'cellspacing': '0',
					'role': 'presentation',
					'style': 'tableFullwidth'
				})#>
				<tbody>
					<tr>
						<td style="position:relative;">
							#local.content#
						</td>
					</tr>
				</tbody>
			</table>';
	}

	public string function renderSimple(){
		local.section = renderSection();

		return "
			#renderBefore()#
			#hasBackground() ? renderWithBackground(section) : section#
			#renderAfter()#";
	}


	public string function render(){
		defineCSS();

		//return getChildContent() & toHTML("<em-button>wagga</em-button>");
		return isFullWidth() ? renderFullWidth() : renderSimple();
	}
	
}
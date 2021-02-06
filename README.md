## About

This project started as a basic ColdFusion port of the [mjml project](https://mjml.io/).

It is used to parse a simple email markup language to simplify the process of creating responsive email templates that look great in as many email clients as possible - both mobile and desktop.

It currently supports Lucee 4.5+.

Adobe ColdFusion is not currently supported, but in theory could be if internal changes are made to use [JavaLoader](https://github.com/markmandel/JavaLoader) initiate required Java classes.

## The emlParser object
You need to create an instance of the emlParser.cfc. This should be treated as a transient object - you need to create a new object for each email that you want to render.

`eml = new emlParser( [configuration] );`

### Configuration
`configuration` is an optional struct that can be used to configure certain aspects of the email render. Default values are:

```
{
   breakPoint: 480,
   compressCSS: true,
   containerWidth: 600,
   customTagPath: "",
   lineLength: 500
}
```

For example:
```
eml = new eml.emlParser({
   breakPoint: 400,
   containerWidth: 700
});
```

| Key | Default | Notes |
| :-------- | :------ | :---- |
| breakPoint | 480 | The width in pixels that the css breakpoint occurs |
| compressCSS | true | If set to true, the CSS gets compressed when the rendered output is minified |
| containerWidth| 600 | The width in pixels of the main container element of the rendered output |
| customTagPath|  | A path to a directory that contains custom tags. This path should either use a mapping or be relative to the application context root |
| lineLength| 500 | The target line length used when the rendered output is minified |


## Rendering an email
To generate the HTML for your email, call the `toHTML()` method:

`toHTML( input [, minify, inserts] )`

### Required arguments
* `input` _string_: the emml to parse and render

### Optional arguments
* `minify` _boolean default=false_: if set to true, the HTML output is minified
* `inserts` _struct default={}_: a struct containing keys of placeholders to replace within the rendered HTML. For example, if you passed in {test: "This is my test"}, placeholders `{{:test:}}` within the rendered HTML would be replaced with 'This is my test'.

### Example
`myHTML = eml.toHTML(myMarkup);`

## emml
The emlParser is expecting a string comprised of 'em' tags that make up an email render. In its most basic form, this looks like:

```
<em-eml>
	<em-body>
		Hello World
	</em-body>
</em-eml>
```




## Tags
The following tags are available:

* [em‐attributes](https://github.com/cubiclabs/emml/wiki/em‐attributes)
* [em-body](https://github.com/cubiclabs/emml/wiki/em‐body)
* [em-button](https://github.com/cubiclabs/emml/wiki/em‐button)
* [em-column](https://github.com/cubiclabs/emml/wiki/em‐column)
* [em-divider](https://github.com/cubiclabs/emml/wiki/em‐divider)
* [em-eml](https://github.com/cubiclabs/emml/wiki/em‐eml)
* [em-head](https://github.com/cubiclabs/emml/wiki/em‐head)
* [em-hspace](https://github.com/cubiclabs/emml/wiki/em‐hspace)
* [em-image](https://github.com/cubiclabs/emml/wiki/em‐image)
* [em-preview](https://github.com/cubiclabs/emml/wiki/em‐preview)
* [em-row](https://github.com/cubiclabs/emml/wiki/em‐row)
* [em-section](https://github.com/cubiclabs/emml/wiki/em‐section)
* [em-spacer](https://github.com/cubiclabs/emml/wiki/em‐spacer)
* [em-style](https://github.com/cubiclabs/emml/wiki/em‐style)
* [em-table](https://github.com/cubiclabs/emml/wiki/em‐table)
* [em-td](https://github.com/cubiclabs/emml/wiki/em‐td)
* [em-text](https://github.com/cubiclabs/emml/wiki/em‐text)
* [em-title](https://github.com/cubiclabs/emml/wiki/em‐title)

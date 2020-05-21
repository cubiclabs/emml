<!doctype html>
<html 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:v="urn:schemas-microsoft-com:vml" 
  xmlns:o="urn:schemas-microsoft-com:office:office" 
  lang="<cfoutput>#context().getProperty("lang")#</cfoutput>">

<head>
  <title><cfoutput>#context().getProperty("title")#</cfoutput></title>
  <!--[if !mso]><!-- -->
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <!--<![endif]-->
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style type="text/css">
    #outlook a {
      padding: 0;
    }
    v:* { behavior: url(#default#VML); display: inline-block; }
    body {
      margin: 0;
      padding: 0;
      -webkit-text-size-adjust: 100%;
      -ms-text-size-adjust: 100%;
    }

    table,
    td {
      border-collapse: collapse;
      mso-table-lspace: 0pt;
      mso-table-rspace: 0pt;
    }

    img {
      border: 0;
      height: auto;
      line-height: 100%;
      outline: none;
      text-decoration: none;
      -ms-interpolation-mode: bicubic;
    }

    p {
      display: block;
      margin: 13px 0;
    }

  </style>
  <!--[if mso]>
        <xml>
        <o:OfficeDocumentSettings>
          <o:AllowPNG/>
          <o:PixelsPerInch>96</o:PixelsPerInch>
        </o:OfficeDocumentSettings>
        </xml>
        <![endif]-->
  <!--[if lte mso 11]>
        <style type="text/css">
          .em-outlook-group-fix { width:100% !important; }
        </style>
        <![endif]-->
<!--- separate style blocks for media queries in gmail app --->
<style type="text/css">
<cfoutput>#outputCSS()#</cfoutput>
</style>
<cfset local.css_sm = outputCSS("sm")>
<cfset local.css_lg = outputCSS("lg")>

<cfif len(local.css_sm)>
  <cfoutput>
<style type="text/css">
  @media only screen and (max-width:#config("breakPoint")#px) {
    #local.css_sm#
  }
</style>
  </cfoutput>
</cfif>
<cfif len(local.css_lg)>
  <cfoutput>
<style type="text/css">
  @media only screen and (min-width:#config("breakPoint")#px) {
    #local.css_lg#
  }
</style>
</cfoutput>
</cfif>
<cfset local.css_outlook = outputCSS("outlook")>
<cfif len(local.css_outlook)>
  <cfoutput>
  <!--[if mso | IE]>
  <style type="text/css">
    #local.css_outlook#
  </style>
  <![endif]-->
  </cfoutput>
</cfif>
</head>


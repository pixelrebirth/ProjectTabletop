$get = invoke-webrequest -uri http://eberron.wikia.com/wiki/Special:Random ; ((($get.ParsedHtml.body.outertext) -split('\n')) | ? {$_.length -gt 150})
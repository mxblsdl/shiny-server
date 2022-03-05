
#* @serializer html
#* @get /render
function(metric) {
  outfile <- paste0("report_", metric, ".html")
  
  render(
    input = "template.Rmd",
    params = list(data = metric),
    output_format = "html_document",
    output_file = outfile
  )
  
  readBin(outfile, "raw", n = file.info(outfile)$size) 
}


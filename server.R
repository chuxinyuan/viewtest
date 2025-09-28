server = function(input, output, session) {
  values = reactiveValues(ready = FALSE)

  observeEvent(input$content, {
    if (nchar(input$content) == 0) {
      rendered_html(tags$p("请在编辑页输入内容再进行预览", class = "text-muted"))
      return()
    }
    
    tryCatch({
      temp_file = tempfile(fileext = ".Rmd")
      on.exit(unlink(temp_file), add = TRUE)
      temp_html = tempfile(fileext = ".html")
      on.exit(unlink(temp_html), add = TRUE)
      
      writeLines(input$content, temp_file)
      litedown:::convert_knitr(temp_file)
      litedown::fuse(temp_file, temp_html, quiet = TRUE)
      
      html_fragment = paste(
        readLines(temp_html, warn = FALSE), 
        collapse = "\n"
      )
      
      output$preview = renderUI({
        tags$div(id = "preview", HTML(html_fragment))
      })
      
      values$ready = TRUE
      values$html_fragment = html_fragment
    }, error = function(e) {
      tags$div(
        class = "alert alert-danger",
        tags$h4("渲染出错："),
        tags$p(e$message),
        tags$p("请检查您的 R 代码语法是否正确")
      )
    })
  })
  
  observe({
    if (values$ready == TRUE) {
      session$sendCustomMessage("render_ready", list())
    }
  })
}

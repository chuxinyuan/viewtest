server = function(input, output, session) {
  values = reactiveValues()

  observeEvent(input$content, {
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
      
      values$html_fragment = html_fragment
    }, error = function(e) {
      tags$div(
        class = "alert alert-danger",
        tags$h4("渲染出错："),
        tags$p(e$message)
      )
    })
  })
  
  observeEvent(values$html_fragment, {
    req(values$html_fragment)
    shinyjs::delay(1000, {
      runjs("
        const el = document.getElementById('preview');
        if (el) {
          renderMathInElement(el, {throwOnError: false});
          Prism.highlightAllUnder(el);
        }
      ")
    })
  })
}

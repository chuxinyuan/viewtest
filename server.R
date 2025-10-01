server = function(input, output, session) {
  values = reactiveValues()
  
  observeEvent(input$content, {
    tryCatch({
      content = input$content
      if (!use_fuse(content)) {
        html_fragment = litedown::mark(text = content)
      } else {
        r = "(?<!(^``))(?<!(\n``))`r[ #]([^`]+)\\s*`"
        content = gsub(r, "`{r} \\3`", content, perl = TRUE)
        html_fragment = litedown::fuse(text = content)
      }
      
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
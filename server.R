server = function(input, output, session) {
  values = reactiveValues(ready = FALSE)
  
  observeEvent(input$content, {
    if (nchar(input$content) == 0) {
      return(tags$p("请在编辑页输入内容再进行预览", class = "text-muted"))
    }
    
    tryCatch({
      # 创建临时 Rmd 文件和 HTML 文件
      temp_file = tempfile(fileext = ".Rmd")
      on.exit(unlink(temp_file), add = TRUE)
      temp_html = tempfile(fileext = ".html")
      on.exit(unlink(temp_html), add = TRUE)
      
      # 渲染 Rmd 为 HTML 片段
      writeLines(input$content, temp_file)
      litedown:::convert_knitr(temp_file)
      litedown::fuse(temp_file, temp_html, quiet = TRUE)
      
      # HTML 片段里注入代码高亮和数学公式渲染代码
      html_content = paste(
        readLines(temp_html, warn = FALSE),
        collapse = "\n"
      )
      
      # HTML 片段准备就绪
      values$ready = TRUE
      
      # 渲染 HTML 片段，加入 preview id 方便定制
      output$preview = renderUI({
        tags$div(id = "preview", HTML(html_content))
      })
    }, error = function(e) {
      # 显示错误信息
      tags$div(
        class = "alert alert-danger",
        tags$h4("渲染出错："),
        tags$p(e$message),
        tags$p("请检查您的 R 代码语法是否正确")
      )
    })
    
    # 一旦 HTML 片段准备就绪就通知前端渲染公式和代码块
    observe({
      if (values$ready) {
        session$sendCustomMessage("render_ready", list(status = "ok"))
      }
    })
  })
}

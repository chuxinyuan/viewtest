server = function(input, output, session) {
  output$preview = renderUI({
    if (nchar(input$content) == 0) {
      return(tags$p("请在编辑页输入内容再进行预览", class = "text-muted"))
    }
    
    tryCatch({
      tags$div(
        class = "text-center",
        tags$p("正在渲染预览..."),
        tags$div(class = "spinner-border", role = "status")
      )
      
      # # 创建临时 Rmd 文件
      # temp_file = tempfile(fileext = ".Rmd")
      # writeLines(input$content, temp_file)
      # litedown:::convert_knitr(temp_file)
      # on.exit(unlink(temp_file), add = TRUE)
      # 
      # # 渲染 Rmd 文件为 HTML
      # temp_html = tempfile(fileext = ".html")
      # litedown::fuse(
      #   input = temp_file,
      #   output = temp_html,
      #   quiet = TRUE
      # )
      # on.exit(unlink(temp_html), add = TRUE)
      
      # 创建临时 Rmd 文件
      temp_file = tempfile(fileext = ".Rmd")
      writeLines(input$content, temp_file)
      on.exit(unlink(temp_file), add = TRUE)
      
      # 渲染 Rmd 文件为 HTML
      temp_html = tempfile(fileext = ".html")
      rmarkdown::render(
        input = temp_file,
        output_file = temp_html,
        output_options = list(highlight = 'zenburn'),
        quiet = TRUE
      )
      on.exit(unlink(temp_html), add = TRUE)
      
      # 渲染 HTML 文件，加入 preview id 方便定制
      html_content = readLines(temp_html, warn = FALSE)
      tags$div(
        id = "preview",
        HTML(paste(html_content, collapse = "\n"))
      )
    }, error = function(e) {
      # 显示错误信息
      tags$div(
        class = "alert alert-danger",
        tags$h4("渲染出错："),
        tags$p(e$message),
        tags$p("请检查您的 R 代码语法是否正确")
      )
    })
  })
}

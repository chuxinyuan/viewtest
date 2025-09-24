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
      
      # 创建临时 Rmd 文件并写入用户输入内容
      temp_file = tempfile(fileext = ".Rmd")
      on.exit(unlink(temp_file), add = TRUE)
      yaml = c("---\noutput: html\n---\n\n", "")
      content = paste0(yaml[2], input$content)
      writeLines(content, temp_file)
      litedown:::convert_knitr(temp_file)

      # 渲染 Rmd 为 HTML
      temp_html = tempfile(fileext = ".html")
      on.exit(unlink(temp_file), add = TRUE)
      litedown::fuse(temp_file, temp_html, quiet = TRUE)
      
      # # 创建临时 Rmd 文件
      # temp_file = tempfile(fileext = ".Rmd")
      # on.exit(unlink(temp_file), add = TRUE)
      # writeLines(input$content, temp_file)
      # on.exit(unlink(temp_file), add = TRUE)
      # 
      # # 渲染 Rmd 文件为 HTML
      # temp_html = tempfile(fileext = ".html")
      # on.exit(unlink(temp_html), add = TRUE)
      # rmarkdown::render(
      #   input = temp_file,
      #   output_file = temp_html,
      #   output_options = list(highlight = 'kate'),
      #   quiet = TRUE
      # )
      
      # 读取并返回 HTML 内容
      html_content = paste(
        readLines(temp_html, warn = FALSE),
        collapse = "\n"
      )
      
      # 渲染 HTML 文件，加入 preview id 方便定制
      tags$div(id = "preview", HTML(html_content))
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

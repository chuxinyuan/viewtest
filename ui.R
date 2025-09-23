ui = fluidPage(
  fluidRow(
    column(
      width = 12,
      wellPanel(
        h4("公文正文（支持 R Markdown）"),
        tabsetPanel(
          tabPanel(
            title = "编辑正文", 
            value = "edit_tab",
            aceEditor(
              outputId = "content",
              mode = "markdown",
              fontSize = 16,
              placeholder = "",
              value = paste(
                readLines("www/demo.Rmd"), 
                collapse = "\n"
              ),
              wordWrap = "soft",  # 启用自动视觉换行
              height = "600px",
            )
          ),
          tabPanel(
            title = "预览正文",
            value = "preview_tab",
            htmlOutput(outputId = "preview")
          )
        )
      )
    )
  )
)

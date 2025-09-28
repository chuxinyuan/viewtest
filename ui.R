ui = fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.css"),
    tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/@xiee/utils@1.14.14/css/prism-xcode.min.css")
  ),
  tags$script(src = "https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.js"),
  tags$script(src = "https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/contrib/auto-render.min.js"),
  tags$script(src = "https://cdn.jsdelivr.net/npm/@xiee/utils@1.14.14/js/render-katex.min.js"),
  tags$script(src = "https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-core.min.js"),
  tags$script(src = "https://cdn.jsdelivr.net/npm/prismjs@1.29.0/plugins/autoloader/prism-autoloader.min.js"),
  
  useShinyjs(),
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
              value = paste(readLines("www/demo.Rmd"), collapse = "\n"),
              wordWrap = "soft",
              height = "600px"
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

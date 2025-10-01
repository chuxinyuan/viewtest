#'
#' 参数配置文件
#' 
#' @author 楚新元
#' @date 2025-09-29
#'
# 加载相关 R 包
library(shiny)
library(litedown)
library(shinyAce)
library(shinyjs)

# 判断用 fuse 还是用 mark
use_fuse = \(text) {
  pattern = c(
    "```\\{[a-zA-Z0-9_]+\\}",  # 代码块 ```{r} / ```{python}
    "`\\{[a-zA-Z0-9_]+\\}",    # 内联 `{r} / `{python}
    "`r\\s",                   # knitr 风格 `r
    "`python\\s",              # Quarto 风格 `python
    "#\\|"                     # #| 代码块选项
  )
  any(sapply(pattern, grepl, x = text))
}

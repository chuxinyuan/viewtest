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

# 判断输入文本应该用 `fuse` 还是 `mark`
use_fuse = function(text) {
  # 代码块标记（如```{r}）
  code_chunk_pattern = "```\\{[a-zA-Z0-9_]+"
  # 内联代码标记（如`{r} 1+1`）
  inline_code_pattern = "`\\{[a-zA-Z0-9_]+"
  # R 脚本中的代码块选项（#|）
  r_script_pattern = "#\\|"
  
  # 检查是否包含任何可执行代码标记
  has_code = any(
    grepl(code_chunk_pattern, text),
    grepl(inline_code_pattern, text),
    grepl(r_script_pattern, text)
  )
  
  return(has_code)
}

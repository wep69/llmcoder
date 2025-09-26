\name{llm_explain_code}
\alias{llm_explain_code}
\title{Explain Code with LLM}
\usage{
llm_explain_code()
}
\description{
Opens an interactive dialog to get explanations of selected R code using various LLM providers.
If no code is selected, opens with an empty text area for manual input.
The explanation is displayed in a formatted output area.
}
\details{
This function launches an interactive Shiny interface that allows users to:
\itemize{
  \item Get detailed explanations of R code functionality
  \item Understand complex R constructs and syntax
  \item Learn about R best practices used in the code
  \item Select from multiple LLM providers (OpenAI, Gemini, Qwen, OpenRouter)
  \item Configure generation parameters for explanation style
  \item Copy explanations for educational or documentation purposes
}

If text is selected in RStudio when the function is called, it will be pre-loaded
into the interface. Otherwise, users can paste or type code manually.
}
\value{
No return value, called for side effects (opens interactive UI)
}
\examples{
\dontrun{
# Select some R code in RStudio, then run:
llm_explain_code()

# Example of code that could be explained:
# Complex data manipulation with dplyr
# Advanced statistical functions
# Custom R functions with multiple parameters
}
}
\seealso{
\code{\link{llm_generate_code}}, \code{\link{llm_fix_code}}, \code{\link{llm_settings}}
}
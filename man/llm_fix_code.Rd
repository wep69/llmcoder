\name{llm_fix_code}
\alias{llm_fix_code}
\title{Fix Code with LLM}
\usage{
llm_fix_code()
}
\description{
Opens an interactive dialog to fix and improve selected R code using various LLM providers.
If no code is selected, opens with an empty text area for manual input.
The improved code can be inserted back into the active RStudio document.
}
\details{
This function launches an interactive Shiny interface that allows users to:
\itemize{
  \item Fix syntax errors in R code
  \item Improve code performance and readability
  \item Get suggestions for better R practices
  \item Select from multiple LLM providers (OpenAI, Gemini, Qwen, OpenRouter)
  \item Configure generation parameters
  \item Insert corrected code back into RStudio
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
llm_fix_code()

# Example of code that could be fixed:
# "for(i in 1:length(x)) print(x[i])"  # Could be improved to use vectorization
}
}
\seealso{
\code{\link{llm_generate_code}}, \code{\link{llm_explain_code}}, \code{\link{llm_settings}}
}
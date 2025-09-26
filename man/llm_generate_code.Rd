\name{llm_generate_code}
\alias{llm_generate_code}
\title{Generate R Code with LLM}
\usage{
llm_generate_code()
}
\description{
Opens a Shiny gadget interface for generating R code using various Large Language Model (LLM) providers. Users can describe what they want in natural language and the LLM will generate corresponding R code.
}
\details{
This function launches an interactive Shiny interface that allows users to:
\itemize{
  \item Select from multiple LLM providers (OpenAI, Gemini, Qwen, OpenRouter)
  \item Choose specific models for each provider
  \item Configure generation parameters (temperature, max tokens)
  \item Enter natural language descriptions of desired R code
  \item Generate and automatically insert code into RStudio
}

The function requires API keys to be configured for the selected provider. Keys can be set through the LLM Settings addin or via environment variables.
}
\examples{
\dontrun{
# Launch the code generation interface
llm_generate_code()

# Example prompts you could use:
# "Create a function to calculate correlation matrix"
# "Generate code for data visualization with ggplot2"
# "Write a function to clean missing values from a dataframe"
}
}
\seealso{
\code{\link{llm_fix_code}}, \code{\link{llm_explain_code}}, \code{\link{llm_settings}}
}
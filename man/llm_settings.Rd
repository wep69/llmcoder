\name{llm_settings}
\alias{llm_settings}
\title{LLM Settings Addin}
\usage{
llm_settings()
}
\description{
Opens an interactive configuration interface to manage API keys and preferences
for various LLM providers including OpenAI, Gemini, Qwen, and OpenRouter.
}
\details{
This function launches an interactive Shiny interface that allows users to:
\itemize{
  \item Configure API keys for supported LLM providers
  \item Set default providers and models
  \item Manage custom model configurations
  \item Test API connections
  \item Import/export configuration settings
  \item View usage statistics and quotas
}

Settings are saved securely in the user's home directory and persist across
R sessions. API keys are never stored in plain text in R scripts.
}
\value{
No return value, called for side effects (opens settings UI)
}
\examples{
\dontrun{
# Open the settings interface
llm_settings()

# Typical workflow:
# 1. Enter API keys for desired providers
# 2. Test connections
# 3. Set preferred default models
# 4. Configure custom models if needed
}
}
\seealso{
\code{\link{llm_generate_code}}, \code{\link{llm_fix_code}}, \code{\link{llm_explain_code}}
}
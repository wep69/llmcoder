\name{add_custom_model}
\alias{add_custom_model}
\title{Add Custom Model}
\usage{
add_custom_model(provider, model_id, display_name = NULL, description = NULL)
}
\arguments{
\item{provider}{Provider name (openai, gemini, qwen, openrouter)}

\item{model_id}{Model identifier}

\item{display_name}{Optional display name for the model}

\item{description}{Optional description}
}
\value{
Invisible TRUE on success
}
\description{
Add a custom LLM model to a specified provider. The custom model will be
saved to the user's custom models configuration file.
}
\details{
This function allows users to extend the built-in model catalog by adding
custom or newer models that may not be included in the default configuration.
Custom models are saved to a YAML file in the user's home directory.

Supported providers:
\itemize{
  \item openai - OpenAI GPT models
  \item gemini - Google Gemini models  
  \item qwen - Alibaba Qwen models
  \item openrouter - OpenRouter model catalog
}
}
\examples{
\dontrun{
# Add a custom OpenAI model
add_custom_model("openai", "gpt-4-custom", "GPT-4 Custom", "Custom GPT-4 model")

# Add a custom model with minimal information
add_custom_model("openai", "my-model")

# Add multiple models
add_custom_model("gemini", "gemini-2.0-flash", "Gemini 2.0 Flash")
add_custom_model("qwen", "qwen-max-latest", "Qwen Max Latest")
}
}
\seealso{
\code{\link{remove_custom_model}}, \code{\link{list_custom_models}}, \code{\link{create_custom_models_template}}
}
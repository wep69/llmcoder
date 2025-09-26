\name{create_custom_models_template}
\alias{create_custom_models_template}
\title{Create Custom Models Template File}
\usage{
create_custom_models_template()
}
\value{
Invisible path to the created template file
}
\description{
Create an example YAML configuration file for custom models with 
sample model definitions. This helps users get started with adding 
their own custom LLM models.
}
\details{
This function creates a template YAML file in the user's home directory
with example configurations for custom models across all supported providers.
The template includes:

\itemize{
  \item Proper YAML structure for custom models
  \item Example models for each provider (OpenAI, Gemini, Qwen, OpenRouter)
  \item Comments explaining each field
  \item Best practices for model naming and organization
}

The template file can be edited directly or used as a reference for
understanding the custom models configuration format. Users can add
their own models to this file or use the programmatic functions
(\code{add_custom_model}, etc.) instead.

If a custom models file already exists, the function will prompt for
confirmation before overwriting it.
}
\examples{
\dontrun{
# Create the custom models template file
create_custom_models_template()

# The template file will be created at:
# ~/.llmcoder_custom_models.yml

# You can then edit it manually or use functions like:
# add_custom_model("openai", "gpt-4-my-custom")
}
}
\seealso{
\code{\link{add_custom_model}}, \code{\link{list_custom_models}}, \code{\link{import_openrouter_models}}
}
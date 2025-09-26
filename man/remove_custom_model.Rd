\name{remove_custom_model}
\alias{remove_custom_model}
\title{Remove Custom Model}
\usage{
remove_custom_model(provider, model_id)
}
\arguments{
\item{provider}{Provider name}

\item{model_id}{Model identifier to remove}
}
\value{
Invisible TRUE on success
}
\description{
Remove a custom LLM model from a specified provider's configuration.
}
\details{
This function removes a previously added custom model from the user's
custom models configuration file. It only affects custom models that
were added via \code{add_custom_model()} and does not remove built-in
models from the default configuration.

If the specified provider or model is not found in the custom models
configuration, the function will stop with an informative error message.
}
\examples{
\dontrun{
# Remove a custom model
remove_custom_model("openai", "my-custom-model")

# Remove multiple models
remove_custom_model("gemini", "old-model-version")
remove_custom_model("qwen", "deprecated-model")
}
}
\seealso{
\code{\link{add_custom_model}}, \code{\link{list_custom_models}}, \code{\link{create_custom_models_template}}
}
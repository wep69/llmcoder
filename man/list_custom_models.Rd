\name{list_custom_models}
\alias{list_custom_models}
\title{List Custom Models}
\usage{
list_custom_models(provider = NULL)
}
\arguments{
\item{provider}{Optional provider name to filter results}
}
\value{
Data frame with custom models information
}
\description{
Display a list of all configured custom models, optionally filtered by provider.
Returns a data frame with model information including provider, model ID, 
display name, and description.
}
\details{
This function retrieves and displays all custom models that have been
added via \code{add_custom_model()}. The results can be filtered to show
only models for a specific provider.

The returned data frame contains columns:
\itemize{
  \item provider - The LLM provider name
  \item model_id - The model identifier
  \item display_name - Human-readable model name
  \item description - Model description (if provided)
}

If no custom models are configured, the function prints an informative
message and returns an invisible empty data frame.
}
\examples{
\dontrun{
# List all custom models
list_custom_models()

# List custom models for a specific provider
list_custom_models("openai")

# Store the result for further processing
custom_models <- list_custom_models()
print(custom_models)
}
}
\seealso{
\code{\link{add_custom_model}}, \code{\link{remove_custom_model}}, \code{\link{create_custom_models_template}}
}
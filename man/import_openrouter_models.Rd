\name{import_openrouter_models}
\alias{import_openrouter_models}
\title{Import Models from OpenRouter}
\usage{
import_openrouter_models(limit = 20)
}
\arguments{
\item{limit}{Maximum number of models to import (default: 20)}
}
\value{
Invisible number of models imported
}
\description{
Import popular LLM models from OpenRouter's catalog as custom models.
This function adds a curated list of frequently used models to the 
OpenRouter provider configuration.
}
\details{
This function automatically adds a selection of popular and high-quality
models from OpenRouter's extensive catalog. The models are chosen based on:
\itemize{
  \item Performance and reliability
  \item Cost-effectiveness
  \item Popularity in the community
  \item Specialized capabilities (coding, reasoning, etc.)
}

Models are imported as custom models and can be managed using the standard
custom model functions (\code{list_custom_models}, \code{remove_custom_model}).

The imported models typically include:
\itemize{
  \item Latest Claude models (Anthropic)
  \item Advanced GPT models (OpenAI)
  \item Open-source models (Llama, Mistral, etc.)
  \item Specialized coding models
}
}
\examples{
\dontrun{
# Import the default set of popular models
import_openrouter_models()

# Import only the top 10 most popular models
import_openrouter_models(limit = 10)

# Check what was imported
list_custom_models("openrouter")
}
}
\seealso{
\code{\link{add_custom_model}}, \code{\link{list_custom_models}}, \code{\link{create_custom_models_template}}
}
#' API Client for LLM Providers
#'
#' This module provides unified API clients for various LLM providers
#' including OpenAI, Gemini, Qwen, and OpenRouter.

# Base API client class
create_api_client <- function(provider, api_key, config) {
  structure(
    list(
      provider = provider,
      api_key = api_key,
      config = config
    ),
    class = c(paste0(provider, "_client"), "llm_client")
  )
}

#' OpenAI API Client
call_openai <- function(client, prompt, model = NULL, temperature = 0.7, max_tokens = 2000) {
  if (is.null(model)) model <- client$config$providers$openai$default_model

  tryCatch({
    response <- httr2::request(paste0(client$config$providers$openai$base_url, "/chat/completions")) %>%
      httr2::req_headers(
        "Authorization" = paste("Bearer", client$api_key),
        "Content-Type" = "application/json"
      ) %>%
      httr2::req_body_json(list(
        model = model,
        messages = list(list(role = "user", content = prompt)),
        temperature = temperature,
        max_tokens = max_tokens
      )) %>%
      httr2::req_perform() %>%
      httr2::resp_body_json()

    return(list(
      success = TRUE,
      content = response$choices[[1]]$message$content,
      model = model,
      provider = "openai"
    ))
  }, error = function(e) {
    return(list(
      success = FALSE,
      error = paste("OpenAI API error:", e$message),
      provider = "openai"
    ))
  })
}

#' Gemini API Client
call_gemini <- function(client, prompt, model = NULL, temperature = 0.7, max_tokens = 2000) {
  if (is.null(model)) model <- client$config$providers$gemini$default_model

  tryCatch({
    # Gemini uses a different endpoint structure
    url <- paste0(client$config$providers$gemini$base_url,
                 "/models/", model, ":generateContent?key=", client$api_key)

    response <- httr2::request(url) %>%
      httr2::req_headers("Content-Type" = "application/json") %>%
      httr2::req_body_json(list(
        contents = list(list(parts = list(list(text = prompt)))),
        generationConfig = list(
          temperature = temperature,
          maxOutputTokens = max_tokens
        )
      )) %>%
      httr2::req_perform() %>%
      httr2::resp_body_json()

    return(list(
      success = TRUE,
      content = response$candidates[[1]]$content$parts[[1]]$text,
      model = model,
      provider = "gemini"
    ))
  }, error = function(e) {
    return(list(
      success = FALSE,
      error = paste("Gemini API error:", e$message),
      provider = "gemini"
    ))
  })
}

#' Qwen (Alibaba) API Client
call_qwen <- function(client, prompt, model = NULL, temperature = 0.7, max_tokens = 2000) {
  if (is.null(model)) model <- client$config$providers$qwen$default_model

  tryCatch({
    # Qwen uses OpenAI-compatible format
    response <- httr2::request(paste0(client$config$providers$qwen$base_url, "/chat/completions")) %>%
      httr2::req_headers(
        "Authorization" = paste("Bearer", client$api_key),
        "Content-Type" = "application/json"
      ) %>%
      httr2::req_body_json(list(
        model = model,
        messages = list(list(role = "user", content = prompt)),
        temperature = temperature,
        max_tokens = max_tokens
      )) %>%
      httr2::req_perform() %>%
      httr2::resp_body_json()

    return(list(
      success = TRUE,
      content = response$choices[[1]]$message$content,
      model = model,
      provider = "qwen"
    ))
  }, error = function(e) {
    return(list(
      success = FALSE,
      error = paste("Qwen API error:", e$message),
      provider = "qwen"
    ))
  })
}

#' OpenRouter API Client
call_openrouter <- function(client, prompt, model = NULL, temperature = 0.7, max_tokens = 2000) {
  if (is.null(model)) model <- client$config$providers$openrouter$default_model

  tryCatch({
    response <- httr2::request(paste0(client$config$providers$openrouter$base_url, "/chat/completions")) %>%
      httr2::req_headers(
        "Authorization" = paste("Bearer", client$api_key),
        "Content-Type" = "application/json",
        "HTTP-Referer" = "https://rstudio.com",
        "X-Title" = "LLM Coder RStudio Addin"
      ) %>%
      httr2::req_body_json(list(
        model = model,
        messages = list(list(role = "user", content = prompt)),
        temperature = temperature,
        max_tokens = max_tokens
      )) %>%
      httr2::req_perform() %>%
      httr2::resp_body_json()

    return(list(
      success = TRUE,
      content = response$choices[[1]]$message$content,
      model = model,
      provider = "openrouter"
    ))
  }, error = function(e) {
    return(list(
      success = FALSE,
      error = paste("OpenRouter API error:", e$message),
      provider = "openrouter"
    ))
  })
}

#' Universal LLM API Call
#'
#' Calls the appropriate LLM provider based on the client configuration
call_llm <- function(client, prompt, model = NULL, temperature = 0.7, max_tokens = 2000) {
  switch(client$provider,
    "openai" = call_openai(client, prompt, model, temperature, max_tokens),
    "gemini" = call_gemini(client, prompt, model, temperature, max_tokens),
    "qwen" = call_qwen(client, prompt, model, temperature, max_tokens),
    "openrouter" = call_openrouter(client, prompt, model, temperature, max_tokens),
    stop("Unsupported provider: ", client$provider)
  )
}

#' Get Available Models for Provider
get_available_models <- function(provider, config) {
  # Get all models (built-in + custom)
  if (exists("get_all_models")) {
    return(get_all_models(provider))
  }

  # Fallback to built-in models only
  switch(provider,
    "openai" = config$providers$openai$models,
    "gemini" = config$providers$gemini$models,
    "qwen" = config$providers$qwen$models,
    "openrouter" = config$providers$openrouter$models,
    character(0)
  )
}

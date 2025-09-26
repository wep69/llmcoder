#' Configuration Manager for LLM Coder
#'
#' Manages API keys, provider settings, and user preferences

#' Load Configuration
load_config <- function() {
  config_file <- system.file("config.yml", package = "llmcoder")
  if (file.exists(config_file)) {
    config::get(file = config_file)
  } else {
    # Fallback configuration if package config is not available
    list(
      providers = list(
        openai = list(
          name = "OpenAI",
          base_url = "https://api.openai.com/v1",
          models = c("gpt-4", "gpt-4-turbo", "gpt-3.5-turbo"),
          default_model = "gpt-4"
        ),
        gemini = list(
          name = "Google Gemini",
          base_url = "https://generativelanguage.googleapis.com/v1beta",
          models = c("gemini-1.5-pro", "gemini-1.5-flash", "gemini-1.0-pro"),
          default_model = "gemini-1.5-pro"
        ),
        qwen = list(
          name = "Alibaba Qwen",
          base_url = "https://dashscope-intl.aliyuncs.com/compatible-mode/v1",
          models = c("qwen-turbo", "qwen-plus", "qwen-max"),
          default_model = "qwen-plus"
        ),
        openrouter = list(
          name = "OpenRouter",
          base_url = "https://openrouter.ai/api/v1",
          models = c("openai/gpt-4", "anthropic/claude-3-haiku", "google/gemini-pro"),
          default_model = "openai/gpt-4"
        )
      )
    )
  }
}

#' Get API Key for Provider
get_api_key <- function(provider) {
  # Check environment variables first
  env_var <- switch(provider,
    "openai" = "OPENAI_API_KEY",
    "gemini" = "GEMINI_API_KEY",
    "qwen" = "QWEN_API_KEY",
    "openrouter" = "OPENROUTER_API_KEY",
    NULL
  )

  if (!is.null(env_var)) {
    key <- Sys.getenv(env_var, unset = "")
    if (nchar(key) > 0) return(key)
  }

  # Check user preferences file
  prefs_file <- file.path(path.expand("~"), ".llmcoder_config.rds")
  if (file.exists(prefs_file)) {
    prefs <- readRDS(prefs_file)
    if (provider %in% names(prefs$api_keys)) {
      return(prefs$api_keys[[provider]])
    }
  }

  return(NULL)
}

#' Save API Key for Provider
save_api_key <- function(provider, api_key) {
  prefs_file <- file.path(path.expand("~"), ".llmcoder_config.rds")

  # Load existing preferences or create new
  if (file.exists(prefs_file)) {
    prefs <- readRDS(prefs_file)
  } else {
    prefs <- list(api_keys = list())
  }

  # Update API key
  prefs$api_keys[[provider]] <- api_key

  # Save preferences
  saveRDS(prefs, prefs_file)
  invisible(TRUE)
}

#' Get User Preferences
get_user_prefs <- function() {
  prefs_file <- file.path(path.expand("~"), ".llmcoder_config.rds")
  if (file.exists(prefs_file)) {
    prefs <- readRDS(prefs_file)
  } else {
    prefs <- list(
      api_keys = list(),
      default_provider = "openai",
      default_temperature = 0.7,
      default_max_tokens = 2000,
      auto_insert = TRUE
    )
  }
  prefs
}

#' Save User Preferences
save_user_prefs <- function(prefs) {
  prefs_file <- file.path(path.expand("~"), ".llmcoder_config.rds")
  saveRDS(prefs, prefs_file)
  invisible(TRUE)
}

#' Validate API Key
validate_api_key <- function(provider, api_key, config) {
  if (is.null(api_key) || nchar(api_key) == 0) {
    return(list(valid = FALSE, message = "API key is required"))
  }

  # Create a test client
  client <- create_api_client(provider, api_key, config)

  # Try a simple test call
  result <- tryCatch({
    call_llm(client, "Hello", temperature = 0.1, max_tokens = 10)
  }, error = function(e) {
    list(success = FALSE, error = e$message)
  })

  if (result$success) {
    return(list(valid = TRUE, message = "API key is valid"))
  } else {
    return(list(valid = FALSE, message = result$error))
  }
}

#' Check Provider Availability
check_provider_availability <- function(provider) {
  api_key <- get_api_key(provider)
  if (is.null(api_key)) {
    return(list(available = FALSE, message = "No API key configured"))
  }

  config <- load_config()
  validation <- validate_api_key(provider, api_key, config)

  list(
    available = validation$valid,
    message = validation$message
  )
}

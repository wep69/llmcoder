# Guia de Instalação - LLM Coder

Este guia fornece instruções detalhadas para instalar e configurar o addin LLM Coder no RStudio.

## Pré-requisitos

- R versão 4.0.0 ou superior
- RStudio versão 1.3 ou superior
- Conexão com a internet
- Chave API de pelo menos um provedor LLM

## Instalação Passo a Passo

### Passo 1: Verificar Versões

```r
# Verificar versão do R
R.version.string

# Verificar se o RStudio está disponível
rstudioapi::isAvailable()
```

### Passo 2: Instalar Dependências

```r
# Lista de pacotes necessários
packages <- c(
  "shiny",
  "miniUI",
  "rstudioapi",
  "httr2",
  "jsonlite",
  "DT",
  "shinydashboard",
  "shinyWidgets",
  "config",
  "glue"
)

# Verificar quais pacotes precisam ser instalados
to_install <- packages[!packages %in% installed.packages()[,"Package"]]

if(length(to_install)) {
  install.packages(to_install)
}

# Verificar se todos foram instalados
all(packages %in% installed.packages()[,"Package"])
```

### Passo 3: Instalar Pacotes de Desenvolvimento (Opcional)

Se você planeja modificar o código:

```r
if(!require(devtools)) install.packages("devtools")
if(!require(remotes)) install.packages("remotes")
```

### Passo 4: Instalar o LLM Coder

#### Opção A: Instalação Local (Desenvolvimento)

```r
# Navegue até o diretório do projeto
setwd("D:/Walter/R/Shiny_Apps/Coder")

# Instalar o pacote
devtools::install(".", dependencies = TRUE)
```

#### Opção B: Carregar para Desenvolvimento

```r
# Para desenvolvimento ativo
devtools::load_all("D:/Walter/R/Shiny_Apps/Coder")
```

### Passo 5: Verificar Instalação

```r
# Verificar se o pacote foi instalado
library(llmcoder)

# Verificar se as funções estão disponíveis
exists("llm_generate_code")
exists("llm_fix_code")
exists("llm_explain_code")
exists("llm_settings")
```

### Passo 6: Verificar Addins no RStudio

1. Reinicie o RStudio
2. Vá no menu **Tools** → **Addins** → **Browse Addins...**
3. Procure por addins que começam com "LLM" ou "Generate Code"

Você deve ver:
- Generate Code with LLM
- Fix Code with LLM
- Explain Code
- LLM Settings

## Configuração de Chaves API

### Método 1: Interface Gráfica (Recomendado)

1. No RStudio, vá em **Addins** → **LLM Settings**
2. Na aba "API Keys", digite suas chaves para os provedores desejados
3. Clique em "Test Connection" para verificar cada chave
4. Salve as configurações

### Método 2: Variáveis de Ambiente

#### No Windows:

1. Crie/edite o arquivo `.Renviron` na sua pasta home:

```r
# Localizar pasta home
path.expand("~")

# Editar .Renviron
file.edit("~/.Renviron")
```

2. Adicione as chaves:

```
OPENAI_API_KEY=sk-sua-chave-openai-aqui
GEMINI_API_KEY=AIza-sua-chave-gemini-aqui
QWEN_API_KEY=sk-sua-chave-qwen-aqui
OPENROUTER_API_KEY=sk-or-sua-chave-openrouter-aqui
```

3. Reinicie o RStudio

#### No Linux/Mac:

Adicione ao seu `.bashrc` ou `.zshrc`:

```bash
export OPENAI_API_KEY="sk-sua-chave-openai-aqui"
export GEMINI_API_KEY="AIza-sua-chave-gemini-aqui"
export QWEN_API_KEY="sk-sua-chave-qwen-aqui"
export OPENROUTER_API_KEY="sk-or-sua-chave-openrouter-aqui"
```

## Obtendo Chaves API

### OpenAI
1. Visite [OpenAI Platform](https://platform.openai.com/api-keys)
2. Faça login ou crie uma conta
3. Clique em "Create new secret key"
4. Copie e guarde a chave (começa com `sk-`)

### Google Gemini
1. Visite [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Faça login com sua conta Google
3. Clique em "Create API Key"
4. Copie a chave (começa com `AIza`)

### Alibaba Qwen
1. Visite [Alibaba Cloud DashScope](https://dashscope.console.aliyun.com/)
2. Crie uma conta ou faça login
3. Navegue para API Keys
4. Gere uma nova chave API

### OpenRouter
1. Visite [OpenRouter](https://openrouter.ai/keys)
2. Crie uma conta
3. Gere uma chave API (começa com `sk-or-`)
4. Adicione créditos à sua conta se necessário

## Teste de Instalação

Execute este script para testar a instalação:

```r
# Teste básico de funcionalidade
test_llmcoder <- function() {
  cat("=== Teste de Instalação LLM Coder ===\n\n")

  # 1. Verificar se o pacote está carregado
  cat("1. Verificando pacote...\n")
  if(exists("llm_generate_code")) {
    cat("   ✓ Funções carregadas\n")
  } else {
    cat("   ✗ Funções não encontradas\n")
    return(FALSE)
  }

  # 2. Verificar configuração
  cat("2. Verificando configuração...\n")
  tryCatch({
    config <- llmcoder:::load_config()
    cat("   ✓ Configuração carregada\n")
  }, error = function(e) {
    cat("   ✗ Erro na configuração:", e$message, "\n")
    return(FALSE)
  })

  # 3. Verificar chaves API
  cat("3. Verificando chaves API...\n")
  providers <- c("openai", "gemini", "qwen", "openrouter")

  for(provider in providers) {
    key <- llmcoder:::get_api_key(provider)
    if(!is.null(key)) {
      cat("   ✓", provider, "configurado\n")
    } else {
      cat("   ○", provider, "não configurado\n")
    }
  }

  cat("\n=== Teste Concluído ===\n")
  cat("O addin está pronto para uso!\n")
  cat("Acesse via: Addins → Generate Code with LLM\n")
}

# Executar teste
test_llmcoder()
```

## Solução de Problemas

### Problema: Addins não aparecem no menu

**Solução:**
```r
# Reinstalar e reiniciar
devtools::install(".", force = TRUE)
.rs.restartR()
```

### Problema: Erro "package 'X' is not available"

**Solução:**
```r
# Instalar pacote específico
install.packages("nome-do-pacote")

# Ou instalar de fonte alternativa
install.packages("nome-do-pacote", repos = "https://cran.rstudio.com/")
```

### Problema: Erro de API "Invalid key"

**Soluções:**
1. Verificar se a chave está correta
2. Verificar se tem créditos/cotas
3. Verificar conectividade de rede
4. Testar chave diretamente no site do provedor

### Problema: Erro httr2

**Solução:**
```r
# Atualizar httr2
install.packages("httr2")

# Ou instalar versão de desenvolvimento
remotes::install_github("r-lib/httr2")
```

## Suporte

Para ajuda adicional:
1. Consulte o README.md
2. Abra uma issue no repositório
3. Verifique logs do RStudio: View → Show Log

---

**Instalação completa!** 🎉

Agora você pode usar o LLM Coder para gerar, corrigir e explicar código R diretamente no RStudio.
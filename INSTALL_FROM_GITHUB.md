# 🚀 Instalação do LLM Coder via GitHub

## 📦 **Instalação Rápida**

```r
# Instalar devtools se necessário
if (!require(devtools)) {
  install.packages("devtools")
}

# Instalar LLM Coder direto do GitHub
devtools::install_github("wep69/llmcoder")

# Carregar o pacote
library(llmcoder)
```

## 🔧 **Configuração Inicial**

```r
# Abrir configurações (primeira vez)
llm_settings()
```

## 🎯 **Como Usar**

### **Via Menu RStudio**
1. RStudio → **Addins** → **LLM Coder**
2. Escolha: Generate Code, Fix Code, Explain Code, ou Settings

### **Via Código R**
```r
# Gerar código
llm_generate_code()

# Corrigir código (selecione código antes)
llm_fix_code()

# Explicar código (selecione código antes)
llm_explain_code()

# Configurações
llm_settings()
```

## 🔑 **Configuração de APIs**

Configure suas chaves API em **Settings**:

- **OpenAI:** `OPENAI_API_KEY`
- **Google Gemini:** `GEMINI_API_KEY`
- **Alibaba Qwen:** `QWEN_API_KEY`
- **OpenRouter:** `OPENROUTER_API_KEY`

## 📋 **Dependências**

O pacote instalará automaticamente:
- shiny (>= 1.7.0)
- miniUI (>= 0.1.1)
- rstudioapi (>= 0.13)
- httr2 (>= 1.0.0)
- jsonlite (>= 1.8.0)
- DT (>= 0.24)
- shinydashboard (>= 0.7.2)
- shinyWidgets (>= 0.7.0)
- config (>= 0.3.1)
- glue (>= 1.6.0)
- yaml (>= 2.3.0)

## 🆘 **Solução de Problemas**

### **Erro de Instalação**
```r
# Limpar cache e reinstalar
remove.packages("llmcoder")
devtools::install_github("wep69/llmcoder", force = TRUE)
```

### **Problemas de Dependências**
```r
# Instalar dependências manualmente
install.packages(c("shiny", "miniUI", "rstudioapi", "httr2",
                   "jsonlite", "DT", "shinydashboard", "shinyWidgets",
                   "config", "glue", "yaml"))
```

### **Teste de Instalação**
```r
# Verificar se instalou corretamente
library(llmcoder)
test_llmcoder_installation()
```

## 🌟 **Recursos Avançados**

### **Modelos Personalizados**
```r
# Adicionar modelo personalizado
add_custom_model("openai", "gpt-4-turbo-2024", "GPT-4 Turbo 2024")

# Listar modelos
list_custom_models()

# Importar modelos populares do OpenRouter
import_openrouter_models(limit = 20)
```

### **Configuração Programática**
```r
# Definir chave API via código (não recomendado para produção)
Sys.setenv(OPENAI_API_KEY = "sua_chave_aqui")

# Configurar provedor padrão
set_default_provider("openai")
```

## 📖 **Documentação Completa**

- **README.md** - Visão geral
- **EXAMPLES.md** - Exemplos práticos
- **CUSTOM_MODELS.md** - Guia de modelos personalizados
- **LATEST_MODELS_EXAMPLES.md** - Modelos 2024/2025

## 🔗 **Links Úteis**

- **Repositório:** https://github.com/wep69/llmcoder
- **Issues:** https://github.com/wep69/llmcoder/issues
- **Documentação:** Arquivos .md inclusos no pacote

---

**🚀 Aproveite o LLM Coder!**
Gerado com [Claude Code](https://claude.ai/code)
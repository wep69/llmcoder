# Guia de Modelos Personalizados - LLM Coder

Este guia explica como adicionar e gerenciar modelos LLM personalizados no addin LLM Coder.

## 🎯 Modelos Mais Recentes Incluídos

### 🔥 OpenAI (Atualizados para 2024/2025)
- **gpt-4o** - Modelo mais avançado da OpenAI (novo padrão)
- **gpt-4o-mini** - Versão otimizada e mais rápida
- **o1-preview** - Modelo de raciocínio avançado
- **o1-mini** - Versão compacta do modelo de raciocínio
- **gpt-4-turbo** - Versão aprimorada do GPT-4
- **gpt-4** - Modelo clássico
- **gpt-3.5-turbo** - Modelo econômico

### 🔥 Google Gemini (Modelos 2024/2025)
- **gemini-1.5-pro** - Modelo principal com contexto estendido
- **gemini-1.5-flash** - Versão rápida e eficiente
- **gemini-1.5-flash-8b** - Versão ainda mais compacta
- **gemini-2.0-flash-exp** - 🆕 Modelo experimental Gemini 2.0
- **gemini-exp-1206** - 🆕 Modelo experimental mais recente
- **gemini-1.0-pro** - Versão clássica

### 🔥 Alibaba Qwen (Série 2.5 e Especializados)
- **qwen-max** - Modelo mais poderoso
- **qwen-plus** - Modelo balanceado
- **qwen-turbo** - Modelo rápido
- **qwen2.5-72b-instruct** - 🆕 Modelo grande 72B
- **qwen2.5-32b-instruct** - Modelo médio 32B
- **qwen2.5-14b-instruct** - Modelo compacto 14B
- **qwen2.5-7b-instruct** - Modelo pequeno 7B
- **qwen2.5-3b-instruct** - Ultra compacto 3B
- **qwen2.5-1.5b-instruct** - Micro modelo 1.5B
- **qwen2.5-0.5b-instruct** - Nano modelo 0.5B
- **qwq-32b-preview** - 🆕 Modelo especializado em raciocínio

### 🔥 OpenRouter (300+ Modelos Atualizados)
- **openai/gpt-4o** - GPT-4o via OpenRouter
- **anthropic/claude-3.5-sonnet** - 🆕 Claude mais avançado
- **anthropic/claude-3.5-haiku** - 🆕 Claude rápido
- **google/gemini-pro-1.5** - Gemini via OpenRouter
- **meta-llama/llama-3.1-405b-instruct** - 🆕 Llama gigante 405B
- **meta-llama/llama-3.1-70b-instruct** - 🆕 Llama grande 70B
- **mistralai/mistral-large** - 🆕 Mistral mais avançado
- **mistralai/codestral** - 🆕 Modelo especializado em código
- **deepseek/deepseek-chat** - 🆕 Modelo chinês avançado
- **qwen/qwen-2.5-72b-instruct** - Qwen via OpenRouter
- **cohere/command-r-plus** - 🆕 Command R Plus
- **x-ai/grok-beta** - 🆕 Grok da xAI (Elon Musk)

## 🛠️ Como Adicionar Modelos Personalizados

### Método 1: Interface Gráfica (Recomendado)

1. **Abrir Configurações:**
   - RStudio → Addins → LLM Settings
   - Clicar na aba "Custom Models"

2. **Adicionar Modelo:**
   - Selecionar o provedor
   - Inserir o ID exato do modelo
   - Dar um nome amigável (opcional)
   - Adicionar descrição (opcional)
   - Clicar "Add"

3. **Importação Rápida:**
   - Clicar "Import OpenRouter Models" para 20+ modelos populares
   - Clicar "Create Template File" para exemplo de configuração

### Método 2: Programática (R Console)

```r
# Carregar o pacote
library(llmcoder)

# Adicionar modelo OpenAI
add_custom_model(
  provider = "openai",
  model_id = "gpt-4o-2024-11-20",
  display_name = "GPT-4o November 2024",
  description = "Latest GPT-4o with November 2024 improvements"
)

# Adicionar modelo Gemini
add_custom_model(
  provider = "gemini",
  model_id = "gemini-2.0-flash-thinking-exp-1219",
  display_name = "Gemini 2.0 Flash Thinking",
  description = "Experimental Gemini 2.0 with enhanced reasoning"
)

# Adicionar modelo Qwen
add_custom_model(
  provider = "qwen",
  model_id = "qwen2.5-coder-32b-instruct",
  display_name = "Qwen 2.5 Coder 32B",
  description = "Specialized model for coding tasks"
)

# Adicionar modelo OpenRouter
add_custom_model(
  provider = "openrouter",
  model_id = "anthropic/claude-3-5-sonnet-20241022",
  display_name = "Claude 3.5 Sonnet",
  description = "Latest Claude model with improved capabilities"
)
```

### Método 3: Arquivo YAML Manual

```r
# Criar arquivo template
create_custom_models_template()

# Localizar e editar o arquivo
# Arquivo: ~/.llmcoder_custom_models.yml
```

Exemplo de estrutura YAML:

```yaml
openai:
  gpt-4o-2024-11-20:
    id: "gpt-4o-2024-11-20"
    display_name: "GPT-4o November 2024"
    description: "Latest GPT-4o model with improved capabilities"
    added_date: "2024-12-25"

gemini:
  gemini-2.0-flash-exp:
    id: "gemini-2.0-flash-exp"
    display_name: "Gemini 2.0 Flash Experimental"
    description: "Experimental Gemini 2.0 model"
    added_date: "2024-12-25"

qwen:
  qwq-32b-preview:
    id: "qwq-32b-preview"
    display_name: "QwQ 32B Preview"
    description: "Reasoning-focused Qwen model"
    added_date: "2024-12-25"

openrouter:
  anthropic/claude-3-5-sonnet-20241022:
    id: "anthropic/claude-3-5-sonnet-20241022"
    display_name: "Claude 3.5 Sonnet"
    description: "Advanced Claude model via OpenRouter"
    added_date: "2024-12-25"
```

## 🎯 Modelos Recomendados para Código

### Para Geração de Código R
1. **gpt-4o** - Excelente para código complexo
2. **claude-3.5-sonnet** - Muito bom em explicações
3. **qwen2.5-72b-instruct** - Especializado em programação
4. **codestral** - Focado especificamente em código

### Para Correção de Bugs
1. **o1-preview** - Raciocínio avançado para debug
2. **gpt-4-turbo** - Análise detalhada de problemas
3. **qwq-32b-preview** - Modelo de raciocínio da Alibaba
4. **deepseek-chat** - Bom em análise de código

### Para Explicações Didáticas
1. **claude-3.5-haiku** - Explicações claras e concisas
2. **gemini-1.5-pro** - Bom em tutoriais
3. **gpt-4o-mini** - Equilibrio qualidade/velocidade
4. **command-r-plus** - Bom em documentação

## 📋 Gerenciamento de Modelos

### Listar Modelos Personalizados
```r
# Listar todos
list_custom_models()

# Listar por provedor
list_custom_models("openai")
```

### Remover Modelos
```r
# Remover modelo específico
remove_custom_model("openai", "gpt-4o-2024-11-20")

# Ou usar a interface gráfica (botão Delete)
```

### Importação em Massa
```r
# Importar 20 modelos populares do OpenRouter
import_openrouter_models(limit = 20)

# Importar mais modelos
import_openrouter_models(limit = 50)
```

## 🔍 IDs de Modelos Mais Recentes

### OpenAI (Dezembro 2024)
- `gpt-4o-2024-11-20` - Versão mais recente
- `gpt-4o-mini-2024-07-18` - Mini mais atual
- `o1-2024-12-17` - O1 mais recente
- `o1-mini-2024-09-12` - O1 Mini

### Gemini (Dezembro 2024)
- `gemini-2.0-flash-exp` - Gemini 2.0 experimental
- `gemini-exp-1206` - Modelo experimental dezembro
- `gemini-1.5-pro-002` - Versão aprimorada
- `gemini-1.5-flash-002` - Flash atualizado

### Qwen (Série 2.5)
- `qwen2.5-72b-instruct` - Modelo grande
- `qwen2.5-coder-32b-instruct` - Especializado em código
- `qwq-32b-preview` - Modelo de raciocínio
- `qwen2.5-math-72b-instruct` - Especializado em matemática

### OpenRouter (Modelos Populares 2024)
- `anthropic/claude-3-5-sonnet-20241022`
- `meta-llama/llama-3.1-405b-instruct`
- `google/gemini-exp-1206`
- `deepseek/deepseek-r1-distill-llama-70b`
- `x-ai/grok-beta`

## ⚡ Dicas e Truques

### 1. Validação de Modelos
- Sempre teste novos modelos antes de usar em produção
- Use "Test Connection" na interface para verificar
- Alguns modelos experimentais podem ser instáveis

### 2. Performance vs. Qualidade
- **Modelos grandes** (70B+): Melhor qualidade, mais lento
- **Modelos médios** (7B-32B): Bom equilíbrio
- **Modelos pequenos** (<7B): Mais rápido, qualidade menor

### 3. Especialização
- **Código**: Codestral, Qwen Coder, DeepSeek
- **Raciocínio**: O1, QwQ, Claude
- **Velocidade**: Mini modelos, Flash, Haiku
- **Criatividade**: GPT-4o, Claude Sonnet

### 4. Custo-Benefício
- OpenRouter oferece preços competitivos
- Modelos "mini" e "flash" são mais econômicos
- Modelos experimentais podem ser gratuitos temporariamente

## 🚀 Atualizações Futuras

O sistema de modelos personalizados permite:
- ✅ Adicionar qualquer modelo novo instantaneamente
- ✅ Importar listas de modelos populares
- ✅ Gerenciar via interface ou código
- ✅ Backup/restore de configurações

### Modelos Futuros Esperados (2025)
- GPT-5 (quando lançado)
- Gemini 3.0
- Qwen 3.0
- Claude 4
- Novos modelos open-source

---

**Mantenha seus modelos atualizados para aproveitar as últimas melhorias!** 🚀

*Última atualização: Dezembro 2024*
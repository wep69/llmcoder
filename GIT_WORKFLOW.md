# 🚀 Git Workflow - LLM Coder

Este guia explica como gerenciar o repositório Git do projeto LLM Coder, desde a configuração inicial até atualizações futuras.

## 📋 **Pré-requisitos**

- Git instalado no sistema
- Conta GitHub ativa
- Repositório GitHub criado: `https://github.com/wep69/llmcoder`

## 🏁 **Configuração Inicial (Primeira Vez)**

### 1. Inicializar Repositório Local

```bash
cd "D:\Walter\R\Shiny_Apps\Coder"

# Inicializar Git no diretório
git init

# Configurar usuário local (substitua pelos seus dados)
git config user.name "Walter"
git config user.email "walter@example.com"
```

### 2. Criar e Configurar .gitignore

```bash
# O arquivo .gitignore já foi criado com as exclusões necessárias:
# - Arquivos temporários R (.Rhistory, .RData, .Rproj.user)
# - Arquivos de sistema (.DS_Store, Thumbs.db)
# - Arquivos Claude (.claude/)
# - Arquivos de build (*.tar.gz, *.zip)
# - Configurações do usuário com chaves API
```

### 3. Adicionar Arquivos ao Controle de Versão

```bash
# Adicionar todos os arquivos (exceto os do .gitignore)
git add .

# Verificar status
git status
```

### 4. Fazer o Commit Inicial

```bash
git commit -m "🚀 Initial release of LLM Coder v0.1.0

✨ Features:
- 4 RStudio Addins (Generate, Fix, Explain, Settings)
- Support for OpenAI, Gemini, Qwen, OpenRouter
- Custom models management
- Complete settings interface
- 40+ built-in models with extensible system

🔧 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### 5. Conectar ao Repositório Remoto

```bash
# Adicionar remote origin
git remote add origin https://github.com/wep69/llmcoder.git

# Renomear branch para main
git branch -M main

# Fazer push inicial (forçado se necessário)
git push -u origin main
# ou se já houver conteúdo no GitHub:
git push --force origin main
```

## 🔄 **Workflow de Atualizações Futuras**

### Processo Padrão para Novas Alterações

#### 1. Verificar Status Atual

```bash
cd "D:\Walter\R\Shiny_Apps\Coder"

# Verificar status dos arquivos
git status

# Ver diferenças
git diff
```

#### 2. Adicionar Alterações

```bash
# Adicionar arquivos específicos
git add arquivo_modificado.R

# Ou adicionar todos os arquivos modificados
git add .

# Verificar o que será commitado
git status
```

#### 3. Fazer Commit com Mensagem Descritiva

```bash
# Commit com mensagem descritiva
git commit -m "🐛 Fix notification types in Shiny components

- Replace type='success' with type='message'
- Fix updateTagList deprecation issues
- Add proper error handling in settings UI

Fixes #1"
```

#### 4. Enviar para GitHub

```bash
# Push das alterações
git push origin main
```

## 📝 **Padrões de Mensagens de Commit**

### Formato Recomendado:
```
<emoji> <tipo>: <descrição curta>

<descrição detalhada se necessário>

<referências a issues, co-autores, etc>
```

### Emojis Sugeridos:
- 🚀 `:rocket:` - Release/Deploy inicial
- ✨ `:sparkles:` - Nova funcionalidade
- 🐛 `:bug:` - Correção de bug
- 🔧 `:wrench:` - Mudanças de configuração
- 📖 `:books:` - Documentação
- ♻️ `:recycle:` - Refatoração
- 🎨 `:art:` - Melhorias de UI/UX
- ⚡ `:zap:` - Melhorias de performance
- 🔒 `:lock:` - Segurança
- 🧪 `:test_tube:` - Testes

### Exemplos de Boas Mensagens:

```bash
# Nova funcionalidade
git commit -m "✨ Add support for Claude API

- Implement Claude API client in api_clients.R
- Add Claude models to config.yml
- Update settings UI with Claude configuration
- Add documentation and examples

Co-Authored-By: Claude <noreply@anthropic.com>"

# Correção de bug
git commit -m "🐛 Fix API key validation for OpenRouter

- Correct header format for OpenRouter requests
- Add proper error handling for 401 responses
- Update test cases

Fixes #5"

# Documentação
git commit -m "📖 Update installation instructions

- Add troubleshooting section
- Include dependency requirements
- Fix typos in README.md"
```

## 🌿 **Trabalhando com Branches**

### Para Desenvolvimento de Funcionalidades Maiores:

```bash
# Criar nova branch para feature
git checkout -b feature/claude-api-support

# Trabalhar na feature...
git add .
git commit -m "✨ Add Claude API integration"

# Enviar branch para GitHub
git push -u origin feature/claude-api-support

# Após aprovação, fazer merge via GitHub ou localmente:
git checkout main
git merge feature/claude-api-support
git push origin main

# Deletar branch local
git branch -d feature/claude-api-support
```

## 🏷️ **Criando Releases**

### Para Versões Oficiais:

```bash
# Criar tag de versão
git tag -a v0.2.0 -m "Release v0.2.0

🎉 New Features:
- Claude API support
- Enhanced error handling
- Custom model templates

🐛 Bug Fixes:
- Fixed Shiny notification types
- Resolved API timeout issues

📖 Documentation:
- Updated installation guide
- Added troubleshooting section"

# Enviar tag para GitHub
git push origin v0.2.0

# Ou enviar todas as tags
git push --tags
```

## 🔍 **Comandos Úteis de Diagnóstico**

```bash
# Ver histórico de commits
git log --oneline

# Ver alterações específicas de um commit
git show commit_hash

# Ver diferenças entre branches
git diff main..feature-branch

# Ver arquivos modificados
git diff --name-only

# Verificar remote configurado
git remote -v

# Ver status detalhado
git status -v
```

## ⚠️ **Problemas Comuns e Soluções**

### 1. Push Rejeitado (Remote Ahead)

```bash
# Problema: Remote tem commits que local não tem
# Solução:
git pull origin main
# Resolver conflitos se necessário
git push origin main
```

### 2. Arquivos Grandes ou Binários

```bash
# Remover arquivo do tracking
git rm --cached arquivo_grande.zip

# Adicionar ao .gitignore
echo "*.zip" >> .gitignore
git add .gitignore
git commit -m "🙈 Ignore zip files"
```

### 3. Reverter Commit

```bash
# Reverter último commit (mantém alterações)
git reset --soft HEAD~1

# Reverter e descartar alterações
git reset --hard HEAD~1

# Reverter commit específico (cria novo commit)
git revert commit_hash
```

### 4. Conflitos de Merge

```bash
# Quando há conflitos:
git status  # Ver arquivos em conflito
# Editar arquivos para resolver conflitos
git add arquivo_resolvido.R
git commit -m "🔀 Resolve merge conflicts"
```

## 📊 **Workflow Recomendado para Atualizações**

### 1. Fluxo Simples (Para correções pequenas):
```bash
git add .
git commit -m "🐛 Fix minor bug in settings UI"
git push origin main
```

### 2. Fluxo Completo (Para funcionalidades maiores):
```bash
# 1. Criar branch
git checkout -b feature/nova-funcionalidade

# 2. Desenvolver e commitar
git add .
git commit -m "✨ Add nova funcionalidade"

# 3. Enviar branch
git push -u origin feature/nova-funcionalidade

# 4. Criar Pull Request no GitHub

# 5. Após aprovação, merge e limpeza
git checkout main
git pull origin main
git branch -d feature/nova-funcionalidade
```

## 🎯 **Checklist para Releases**

- [ ] Todos os testes passam
- [ ] Documentação atualizada
- [ ] Versão atualizada em DESCRIPTION
- [ ] CHANGELOG.md atualizado
- [ ] README.md revisado
- [ ] Exemplos funcionando
- [ ] Tag de versão criada
- [ ] Release notes preparadas

## 🔗 **Links Úteis**

- **Repositório:** https://github.com/wep69/llmcoder
- **Issues:** https://github.com/wep69/llmcoder/issues
- **Pull Requests:** https://github.com/wep69/llmcoder/pulls
- **Releases:** https://github.com/wep69/llmcoder/releases

---

**💡 Dica:** Sempre faça commits pequenos e frequentes com mensagens descritivas. É melhor ter 5 commits pequenos e claros do que 1 commit grande e confuso.

🔧 **Gerado com Claude Code**
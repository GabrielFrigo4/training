.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: Training Hub Orchestrator
# ----------------------------------------------------------------

.PHONY: help clone pull upgit status test audit format prettier lint-format hooks ci main clean

REPOS = Algorithms Marathon

### ================================
### HELP & DOCUMENTATION
### ================================
help:
	_e=$$'\e'; \
	cmd() { printf "    $${_e}[36mmake %-20s$${_e}[0m %s\n" "$$1" "$$2"; }; \
	sec() { printf "\n  $${_e}[1;33m%s$${_e}[0m\n" "$$1"; }; \
	printf "\n  $${_e}[1;37mTraining Hub — Orquestrador de Programação Competitiva$${_e}[0m\n"; \
	printf "  =======================================================\n"; \
	sec "Sincronização & Submódulos:"; \
	cmd "clone"          "Inicializa e atualiza todos os submódulos recursivamente"; \
	cmd "main"           "Alterna todos os submódulos clonados para a branch main"; \
	cmd "pull"           "Atualiza submódulos de algoritmos com os remotos no GitHub"; \
	cmd "upgit"          "Atualiza todos os repositórios Git encontrados recursivamente"; \
	sec "Diagnóstico & Status:"; \
	cmd "status"         "Exibe status Git dos repositórios de treino"; \
	cmd "hooks"          "Configura e aplica permissões canônicas em .githooks"; \
	sec "Qualidade & Testes:"; \
	cmd "test"           "Valida scripts de teste e conformidade local"; \
	cmd "audit"          "Executa auditoria estática de integridade, submódulos e padrões"; \
	cmd "format"         "Formata recursivamente arquivos (MD, JSON, YAML, HTML, CSS) com Prettier"; \
	cmd "prettier"       "Formata recursivamente arquivos (MD, JSON, YAML, HTML, CSS) com Prettier"; \
	cmd "lint-format"    "Valida formatação recursiva sem alterar arquivos"; \
	cmd "ci"             "Executa pipeline local de validação"; \
	sec "Manutenção & Limpeza:"; \
	cmd "clean"          "Remove artefatos temporários, caches e ambientes virtuais (.venv)"; \
	echo ""

### ================================
### SUBMODULES ORCHESTRATION
### ================================
clone:
	echo "📦 Inicializando submódulos do Training..."
	git submodule update --init --recursive
	printf "✅ Submódulos inicializados com sucesso!\n\n"
	$(MAKE) main

main:
	echo "🌿 Alternando submódulos para a branch main..."
	for r in $(REPOS); do \
		if [ -e "$$r/.git" ]; then \
			echo "  🌿 $$r -> main"; \
			git -C "$$r" checkout main 2> "/dev/null" || git -C "$$r" switch main 2> "/dev/null" || echo "  ⚠️  $$r: falha ao alternar para main."; \
		else \
			echo "  ⏭️  $$r: não clonado, pulando."; \
		fi; \
	done
	printf "✅ Submódulos ativos configurados na branch main!\n\n"

pull: main
	echo "🔄 Sincronizando submódulos de treino..."
	git submodule update --remote --merge
	echo "✅ Submódulos sincronizados!"

upgit:
	echo "🔄 Atualizando repositórios Git..."
	find . \( -type d -name ".git" -print -prune \) -o \( -type f -name ".git" -print \) 2> "/dev/null" | awk '{ n=split($$0, a, "/"); print n, $$0 }' | sort -n -k1,1 | cut -d' ' -f2- | while read -r g; do \
		d="$$(dirname "$$g")"; \
		echo "# ----------------------------------------------------------------"; \
		echo "# $$d"; \
		echo "# ----------------------------------------------------------------"; \
		git -C "$$d" pull --ff-only 2> "/dev/null" || git -C "$$d" pull || echo "⚠️  Falha ao atualizar $$d"; \
		echo ""; \
	done
	echo "✅ Repositórios Git atualizados!"

status:
	echo "📊 Status dos Submódulos do Training:"
	git submodule status

### ================================
### QUALITY GATES & AUDIT
### ================================
hooks:
	chmod 0755 .githooks/* 2> "/dev/null" || true
	git config core.hooksPath .githooks
	echo "✅ Hooks configurados com sucesso em .githooks!"

test:
	echo "🧪 Validando integridade e scripts de automação..."
	find . -type f -name "*.sh" -not -path "*/.git/*" -not -path "*/OSS/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" -exec sh -n {} +
	if [ -d ".githooks" ]; then \
		find .githooks -type f -exec sh -n {} +; \
	fi
	echo "✅ Scripts validados com sucesso!"

audit: test
	echo "🔍 Executando auditoria estática de integridade e padrões..."
	git submodule status | while read -r sha path rest; do \
		case "$$sha" in \
			U*) echo "❌ Conflito no submódulo: $$path" >&2; exit 1 ;; \
		esac; \
	done
	if [ -d ".githooks" ]; then \
		for h in .githooks/*; do \
			if [ -f "$$h" ] && [ ! -x "$$h" ]; then \
				echo "❌ Gancho sem permissão executável: $$h" >&2; \
				exit 1; \
			fi; \
		done; \
	fi
	_tmp=$$(git ls-files | grep -E '(__pycache__/|\.pyc$$|\.DS_Store$$|\.bak$$|\.swp$$|\.tmp$$)' || true); \
	if [ -n "$$_tmp" ]; then \
		echo "❌ Arquivos temporários rastreados: $$_tmp" >&2; \
		exit 1; \
	fi
	git ls-files | while IFS= read -r p; do \
		if [ -f "$$p" ] && grep -q -E '^(<<<<<<< |>>>>>>> )' "$$p" 2> "/dev/null"; then \
			echo "❌ Marcador de conflito encontrado em: $$p" >&2; \
			exit 1; \
		fi; \
	done
	echo "✅ Auditoria estática aprovada!"

format:
	echo "🎨 Formatando arquivos (MD, JSON, YAML, HTML, CSS) com Prettier recursivamente..."
	if command -v prettier > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" \
			-exec prettier --write {} +; \
		echo "✅ Todos os arquivos do Training foram formatados recursivamente!"; \
	elif command -v npx > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" \
			-exec npx --yes prettier --write {} +; \
		echo "✅ Todos os arquivos do Training foram formatados recursivamente!"; \
	else \
		echo "⚠️ Prettier não encontrado no PATH."; \
	fi

prettier: format

lint-format:
	echo "🔍 Validando formatação (MD, JSON, YAML, HTML, CSS) com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" \
			-exec prettier --check {} +; \
		echo "✅ Formatação 100% em conformidade!"; \
	elif command -v npx > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" \
			-exec npx --yes prettier --check {} +; \
		echo "✅ Formatação 100% em conformidade!"; \
	else \
		echo "ℹ️ Prettier não instalado; pulando validação."; \
	fi

ci: test audit lint-format status
	echo "✅ Pipeline local aprovada!"

### ================================
### CLEANUP
### ================================
clean:
	echo "🧹 Limpando artefatos, caches e ambientes virtuais em todos os módulos de treino..."
	for r in $(REPOS); do \
		if [ -e "$$r/Makefile" ]; then \
			(cd "$$r" && $(MAKE) clean) 2> "/dev/null" || true; \
		fi; \
	done
	rm -rf .venv
	find . -type d -name "__pycache__" -exec rm -rf {} + 2> "/dev/null" || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2> "/dev/null" || true
	find . -type d -name ".ruff_cache" -exec rm -rf {} + 2> "/dev/null" || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2> "/dev/null" || true
	echo "✅ Limpeza do Training concluída!"

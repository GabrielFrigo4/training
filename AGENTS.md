# 🎯 Training — AI Agent Briefing

> Este é o **repositório hub** do ecossistema **Training** de Gabriel Frigo. Ele orquestra os repositórios de preparação para maratonas de programação, algoritmos avançados, estruturas de dados e automação de competições.

---

## 🧭 Identidade e Papel

O **Training** é o **meta-repositório e ponto de entrada** para a prática e registro competitivo. Ele coordena dois repositórios federados:

| Componente                      | Papel                                                                                                               | Repositório Remoto            |
| :------------------------------ | :------------------------------------------------------------------------------------------------------------------ | :---------------------------- |
| **[`Algorithms`](Algorithms/)** | Hub de algoritmos, templates multilíngues (C++23, Python, Rust), CLI `cpt` e handbook para Codeforces, OBI, AtCoder | `GabrielFrigo4/cp-training`   |
| **[`Marathon`](Marathon/)**     | Treinamento oficial para a Maratona SBC / ICPC (Final Nacional 2026), regras estritas e Makefiles oficiais          | `GabrielFrigo4/icpc-training` |

---

## 📦 Os Repositórios Federados

```text
Training/
├── .agents/                   # Governança e runbooks locais de IA
├── .githooks/                 # Quality gates de pre-commit e commit-msg
├── .github/                   # Workflows de CI
├── Algorithms/                # Hub de CP geral, templates e handbook
├── Marathon/                  # Foco na Final Nacional do ICPC 2026
├── AGENTS.md                  # Este briefing de engenharia
├── LICENSE                    # Licença MIT
├── Makefile                   # Orquestrador POSIX silencioso
├── PRINCIPLES.md              # 22 Princípios de Engenharia aplicados
├── README.md                  # Apresentação executiva do Training Hub
└── TODO.md                    # Matriz de status operacional e roadmap
```

---

## ⚠️ Regras Críticas para Agentes de IA

1. **A Regra de Ouro:** Ao entrar em `Algorithms` ou `Marathon`, consulte os arquivos `AGENTS.md` e `PRINCIPLES.md` locais antes de editar código.
2. **Autonomia de Competição:** Soluções de problemas, templates e testes pertencem aos seus respectivos repositórios.
3. **Hermetismo de Produção (`rm -rf .agents`):** A execução e ferramentas CLI (como `cpt` ou `make`) nunca devem depender de arquivos de IA.
4. **Makefile como Orquestrador:** Use a raiz do hub para sincronizar ou inspecionar o status global dos submódulos.
5. **Zero-Tweaks Invariant:** O hub deve compilar e ser navegável imediatamente após `git clone --recursive`.

6. **Taxonomia Tripartite de Comentários:** O código adota estritamente três categorias: 1. Comentários de Sistema = PERMITIDOS (shebangs, pragmas, linters); 2. Comentários Estruturais de 64/32 colunas = PERMITIDOS (cabeçalhos de 64 `-`, seções de 32 colunas `### ===` e `### ---` com títulos em MAIÚSCULO, réguas de 64 `=` em `.gitignore` com títulos em MAIÚSCULO, sem vazamento); 3. Comentários Explicativos/Narrativos = PROIBIDOS em código, configs E blocos de código dentro de Markdowns.

---

## 🛡️ Regra da Proatividade e Correção Contínua (Boy Scout Rule)

O agente de IA atua de forma proativa na manutenção e aplicação dos padrões canônicos deste repositório.

Ao identificar linhas ou artefatos fora dos padrões estabelecidos:

1. **Notificar concisamente** o usuário sobre o ajuste realizado.
2. **Corrigir a inconformidade**, aplicando o padrão correspondente:
    - **Taxonomia Tripartite de Comentários:** Eliminar comentários explicativos óbvios em código, configs e blocos de código em Markdowns, preservando exclusivamente comentários de sistema e delimitadores estruturais (64/32 colunas).
    - **Banners Estruturais:** Ajustar réguas para exatamente 64 hífens no topo ou 32 caracteres com `### ` no corpo (ou 64 `=` em `.gitignore`), com títulos sempre em MAIÚSCULO.
    - **Portabilidade POSIX:** Substituir bashismos (`[[ ]]`, `&>`, arrays, `source`) por sintaxe estrita POSIX `/bin/sh`.
    - **Shebang Universal:** Garantir sempre `#!/usr/bin/env sh` ou `#!/usr/bin/env python3`.
    - **Sequências ANSI & Escapes:** Não use octais (`\033`, `\001`) para caracteres ou escapes. Use `[ -t 1 ] && echo -n $\x27\e...\x27` ou notação hexadecimal (`\x01`, `\x1b`). Octal é exclusivo para permissões POSIX (`chmod 0755`, `chmod 0644`, `umask`).
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).
    - **Invariante Out-of-the-Box:** Garantir modos octais corretos no Git Index e auto-cura em tempo de execução sem requerer intervenção manual pós-clone.
    - **Emissão Semântica de UI:** Substituir `echo` avulsos com emojis pelas rotinas canônicas `_ui_*`.
    - **Antifragilidade & Resiliência:** Resolução ativa de caminhos em cascata, auto-cura de permissões (0600 em chaves/segredos) e validação defensiva de pré-requisitos.
    - **Curadoria Cognitiva:** Capturar decisões estruturais e regras tácitas em skills locais compactas (`.agents/skills/`), mantendo-as atualizadas e expurgando ruído obsoleto.
    - **Refatoração Sem Legado:** Expurgar aliases obsoletos, variáveis mortas e shims de compatibilidade em renomeações.
    - **Elevação Antifrágil & Shift Seguro:** Usar o bloco explícito `if [ "$(id -u)" -ne 0 ]` para resolução de `ELEVATE` (evitando término fatal sob `set -e` como root) e proteger todo comando `shift` com validação prévia de parâmetros (`[ "$#" -ge N ] && shift N`).
    - **Simetria de Documentação:** Mover regras ou invariantes universais documentadas erroneamente em sub-membros específicos para o documento de arquitetura do grupo correspondente, eliminando falsas assimetrias.

---

## 🚀 Comandos de Verificação Rápida (Quality Gates)

| Comando            | Finalidade Operacional                                      |
| :----------------- | :---------------------------------------------------------- |
| `make help`        | Exibe o catálogo completo de tarefas operacionais           |
| `make status`      | Inspeciona o estado Git dos submódulos de treino            |
| `make pull`        | Sincroniza submódulos com as branches principais            |
| `make test`        | Valida sintaxe e scripts de teste nos submódulos            |
| `make audit`       | Executa rotinas de auditoria nos componentes                |
| `make format`      | Aplica formatação automática em arquivos suportados         |
| `make prettier`    | Formata arquivos Markdown e JSON com Prettier               |
| `make lint-format` | Valida conformidade de formatação sem modificar arquivos    |
| `make hooks`       | Configura permissões e ganchos Git em todos os repositórios |
| `make ci`          | Executa pipeline local completa de validação integrada      |

---

## 📖 Referências Obrigatórias

Antes de qualquer modificação neste ecossistema, consulte:

- [README.md](README.md) — Apresentação executiva do Training Hub
- [PRINCIPLES.md](PRINCIPLES.md) — 22 Princípios de Engenharia aplicados
- [TODO.md](TODO.md) — Matriz de status operacional e roadmap
- [LICENSE](LICENSE) — Licença MIT do projeto

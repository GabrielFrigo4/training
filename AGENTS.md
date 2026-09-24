# 🎯 Training — AI Agent Briefing

> Este é o **repositório hub** do ecossistema **Training** de Gabriel Frigo. Ele orquestra os repositórios de preparação para maratonas de programação, algoritmos avançados, estruturas de dados e automação de competições.

---

## 🧭 1. Identidade e Papel

O **Training** é o **meta-repositório e ponto de entrada** para a prática e registro competitivo. Ele coordena dois repositórios federados:

| Componente                      | Papel                                                                                                               | Repositório Remoto            |
| :------------------------------ | :------------------------------------------------------------------------------------------------------------------ | :---------------------------- |
| **[`Algorithms`](Algorithms/)** | Hub de algoritmos, templates multilíngues (C++23, Python, Rust), CLI `cpt` e handbook para Codeforces, OBI, AtCoder | `GabrielFrigo4/cp-training`   |
| **[`Marathon`](Marathon/)**     | Treinamento oficial para a Maratona SBC / ICPC (Final Nacional 2026), regras estritas e Makefiles oficiais          | `GabrielFrigo4/icpc-training` |

---

## ⚠️ 2. Regras Críticas para Agentes de IA

1. **A Regra de Ouro:** Ao entrar em `Algorithms` ou `Marathon`, consulte os arquivos `AGENTS.md` e `PRINCIPLES.md` locais antes de editar código.
2. **Autonomia de Competição:** Soluções de problemas, templates e testes pertencem aos seus respectivos repositórios.
3. **Hermetismo de Produção (`rm -rf .agents`):** A execução e ferramentas CLI (como `cpt` ou `make`) nunca devem depender de arquivos de IA.
4. **Makefile como Orquestrador:** Use a raiz do hub para sincronizar ou inspecionar o status global dos submódulos.
5. **Zero-Tweaks Invariant:** O hub deve compilar e ser navegável imediatamente após `git clone --recursive`.

---

## 🌲 3. Estrutura do Repositório

```
Training/
├── .agents/                   # Governança e runbooks locais de IA
├── .githooks/                 # Quality gates de pre-commit e commit-msg
├── .github/                   # Workflows de CI
├── Algorithms/                # Hub de CP geral, templates e handbook
├── Marathon/                  # Foco na Final Nacional do ICPC 2026
├── AGENTS.md                  # Este briefing de engenharia
├── LICENSE                    # Licença MIT
├── Makefile                   # Orquestrador POSIX silencioso
├── PRINCIPLES.md              # 18 Princípios de Engenharia aplicados
└── README.md                  # Apresentação executiva do Training Hub
```

---

## ⚡ 4. Comandos de Verificação Rápida

| Comando       | Finalidade                                        |
| :------------ | :------------------------------------------------ |
| `make help`   | Exibe o catálogo completo de tarefas operacionais |
| `make status` | Inspeciona o estado Git dos submódulos de treino  |
| `make pull`   | Sincroniza submódulos com as branches principais  |
| `make test`   | Valida sintaxe e scripts de teste                 |

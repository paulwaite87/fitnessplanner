#!make

-include .env
export

.env:
	@echo "Creating .env from .env.tmpl"; \
	cp .env.tmpl .env

init_env: .env

.claude/settings.local.json: claude_settings.json.tmpl
	@echo "Creating .claude/settings.local.json from claude_settings.json.tmpl"; \
	sed -e "s|__REPO_ROOT__|$(CURDIR)|g" -e "s|__HOME__|$(HOME)|g" claude_settings.json.tmpl > .claude/settings.local.json

init_claude_settings: .claude/settings.local.json

## Registers the trainingpeaks MCP server in local (per-machine) Claude config.
## Needed because mcpServers declared in .claude/settings.local.json require an
## interactive approval that never happens on a fresh machine/session; adding it
## via `claude mcp add -s local` writes straight to the trusted local scope.
## TP_AUTH_COOKIE is passed explicitly (from .env) as the server's own env block,
## since it otherwise only reaches `make` targets, not the subprocess Claude
## launches - without it, tp-mcp falls back to the system keyring, which hangs
## on headless Linux boxes with no Secret Service.
init_claude_mcp:
	@claude mcp remove trainingpeaks -s local >/dev/null 2>&1 || true
	@claude mcp add trainingpeaks -s local -e TP_AUTH_COOKIE="$(TP_AUTH_COOKIE)" -- "$(CURDIR)/trainingpeaks-mcp/.venv/bin/tp-mcp" serve

init_ssh:
	@echo "Ensuring SSH keys are loaded into the session.."
	@ssh-add -q < /dev/tty 2>/dev/null || true

## init: Initialise submodules
init_submodules:
	@git submodule sync --recursive
	@git submodule init
	@git config --file .gitmodules --get-regexp path | awk '{print $$2}' | while read path; do \
		if ! git ls-files --error-unmatch "$$path" >/dev/null 2>&1; then \
			url=$$(git config --file .gitmodules --get "submodule.$$path.url"); \
			echo "==> Registering missing submodule path: $$path"; \
			git submodule add -f "$$url" "$$path" 2>/dev/null || true; \
		fi \
	done
	@git submodule update --init --recursive --progress

init: init_env init_ssh init_submodules init_claude_settings
	@cd trainingpeaks-mcp ;\
	uv run python3 -m venv .venv ;\
	uv run pip install -e . ;\
	echo "Workspace initialised"
	@$(MAKE) init_claude_mcp

cookie login:
	@cd trainingpeaks-mcp ;\
	uv run pip install -e ".[browser]" ;\
	uv run tp-mcp auth --from-browser auto

## serve: Start the TP server
serve:
	@cd trainingpeaks-mcp ;\
	uv run tp-mcp serve

## help: Show this help menu
help:
	@echo "Available commands:"
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | awk '{printf "  \033[36m%-20s\033[0m %s\n", $$1, substr($$0, index($$0,$$2))}'

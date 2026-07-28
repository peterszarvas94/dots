#!/usr/bin/env bash
# Re-apply after npm install or when OpenCode refreshes cursor-oauth-opencode@latest.
# Keeps durable Cursor user API keys (crsr_...) in auth.json refresh across token exchange.
set -euo pipefail
python3 - <<'PY'
from pathlib import Path

home = Path.home()
roots_auth = [
    home / ".config/opencode/node_modules/cursor-oauth-opencode/dist/auth.js",
    home / ".cache/opencode/packages/cursor-oauth-opencode@latest/node_modules/cursor-oauth-opencode/dist/auth.js",
]

auth_old = """    return {
        access: data.accessToken,
        refresh: (typeof data.refreshToken === "string" && data.refreshToken) || refreshToken,
        expires: getTokenExpiry(data.accessToken),
    };"""
auth_new = """    return {
        access: data.accessToken,
        // Keep durable user API keys (crsr_...) so expiry can re-exchange.
        // Cursor may return a short-lived JWT as refreshToken; that must not replace crsr_.
        refresh: refreshToken.startsWith("crsr_")
            ? refreshToken
            : ((typeof data.refreshToken === "string" && data.refreshToken) || refreshToken),
        expires: getTokenExpiry(data.accessToken),
    };"""

for p in roots_auth:
    if not p.exists():
        print("skip missing", p)
        continue
    text = p.read_text()
    if 'refreshToken.startsWith("crsr_")' in text:
        print("ok auth", p)
        continue
    if auth_old not in text:
        print("WARN auth pattern missing", p)
        continue
    p.write_text(text.replace(auth_old, auth_new, 1))
    print("patched auth", p)
PY

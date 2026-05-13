#!/usr/bin/env bash

set -euo pipefail

PARSER_DIR="${PARSER_DIR:-$HOME/.config/nvim/parsers}"
WORK_DIR="${WORK_DIR:-/tmp/ts-parsers}"

mkdir -p "$PARSER_DIR"
mkdir -p "$WORK_DIR"

clone_build() {
  local repo="$1"
  local dir_name="$2"
  local build_path="$3"
  local output_name="$4"

  local checkout="$WORK_DIR/$dir_name"
  rm -rf "$checkout"
  git clone --depth 1 "$repo" "$checkout"
  mkdir -p "$PARSER_DIR/parser"
  tree-sitter build -o "$PARSER_DIR/parser/$output_name.so" "$checkout/$build_path"

  if [[ -d "$checkout/queries" ]]; then
    mkdir -p "$PARSER_DIR/queries/$output_name"
    cp -f "$checkout/queries/"*.scm "$PARSER_DIR/queries/$output_name/" 2>/dev/null || true
  fi
}

clone_build "https://github.com/tree-sitter/tree-sitter-go" "go" "." "go"
clone_build "https://github.com/tree-sitter/tree-sitter-javascript" "javascript" "." "javascript"
clone_build "https://github.com/tree-sitter/tree-sitter-typescript" "typescript" "typescript" "typescript"
clone_build "https://github.com/tree-sitter/tree-sitter-typescript" "tsx" "tsx" "tsx"
clone_build "https://github.com/vrischmann/tree-sitter-templ" "templ" "." "templ"
clone_build "https://github.com/tree-sitter/tree-sitter-html" "html" "." "html"
clone_build "https://github.com/tree-sitter/tree-sitter-css" "css" "." "css"
clone_build "https://github.com/tree-sitter/tree-sitter-json" "json" "." "json"
clone_build "https://github.com/tree-sitter-grammars/tree-sitter-yaml" "yaml" "." "yaml"
clone_build "https://github.com/tree-sitter-grammars/tree-sitter-lua" "lua" "." "lua"
clone_build "https://github.com/tree-sitter/tree-sitter-rust" "rust" "." "rust"
clone_build "https://github.com/tree-sitter-grammars/tree-sitter-toml" "toml" "." "toml"
clone_build "https://github.com/tree-sitter/tree-sitter-jsdoc" "jsdoc" "." "jsdoc"
clone_build "https://github.com/tree-sitter/tree-sitter-bash" "bash" "." "bash"
clone_build "https://github.com/tree-sitter/tree-sitter-ruby" "ruby" "." "ruby"
clone_build "https://github.com/DerekStride/tree-sitter-sql" "sql" "." "sql"
clone_build "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "markdown" "tree-sitter-markdown" "markdown"
clone_build "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "markdown-inline" "tree-sitter-markdown-inline" "markdown_inline"

echo "Parsers installed to: $PARSER_DIR"

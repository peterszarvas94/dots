#!/usr/bin/env bash

# AI wrote me this script, because nvim-treesitter got archived,

set -euo pipefail

PARSER_DIR="${PARSER_DIR:-$HOME/.config/nvim/parsers}"
WORK_DIR="${WORK_DIR:-/tmp/ts-parsers}"

mkdir -p "$PARSER_DIR"
mkdir -p "$WORK_DIR"

replace_exact_in_file() {
  local file="$1"
  local from="$2"
  local to="$3"

  [[ -f "$file" ]] || return 0

  local tmp
  tmp="$(mktemp)"

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" == "$from" ]]; then
      printf '%s\n' "$to" >>"$tmp"
    else
      printf '%s\n' "$line" >>"$tmp"
    fi
  done <"$file"

  mv "$tmp" "$file"
}

remove_exact_in_file() {
  local file="$1"
  local needle="$2"

  [[ -f "$file" ]] || return 0

  local tmp
  tmp="$(mktemp)"

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" != "$needle" ]]; then
      printf '%s\n' "$line" >>"$tmp"
    fi
  done <"$file"

  mv "$tmp" "$file"
}

normalize_query_predicates() {
  local query_root="$PARSER_DIR/queries"
  [[ -d "$query_root" ]] || return 0

  while IFS= read -r file; do
    remove_exact_in_file "$file" ' (#is-not? local))'
    remove_exact_in_file "$file" '  (#is-not? local)'
  done < <(find "$query_root" -type f -name '*.scm')
}

clone_build() {
  local repo="$1"
  local dir_name="$2"
  local build_path="$3"
  local output_name="$4"
  local branch="${5:-}"

  local checkout="$WORK_DIR/$dir_name"
  local grammar_path="$checkout/$build_path"
  rm -rf "$checkout"
  if [[ -n "$branch" ]]; then
    git clone --depth 1 --branch "$branch" "$repo" "$checkout"
  else
    git clone --depth 1 "$repo" "$checkout"
  fi

  if [[ ! -f "$grammar_path/src/parser.c" ]]; then
    if [[ -f "$grammar_path/grammar.js" ]]; then
      tree-sitter generate "$grammar_path/grammar.js"
    elif [[ -f "$grammar_path/grammar.json" ]]; then
      tree-sitter generate "$grammar_path/grammar.json"
    else
      echo "No grammar.js or grammar.json found in $grammar_path" >&2
      exit 1
    fi
  fi

  mkdir -p "$PARSER_DIR/parser"
  tree-sitter build -o "$PARSER_DIR/parser/$output_name.so" "$grammar_path"

  if [[ -d "$checkout/queries/$output_name" ]]; then
    mkdir -p "$PARSER_DIR/queries/$output_name"
    cp -f "$checkout/queries/$output_name/"*.scm "$PARSER_DIR/queries/$output_name/" 2>/dev/null || true
  elif [[ -d "$checkout/queries" ]]; then
    mkdir -p "$PARSER_DIR/queries/$output_name"
    cp -f "$checkout/queries/"*.scm "$PARSER_DIR/queries/$output_name/" 2>/dev/null || true
  fi

  post_process_queries "$output_name"
}

patch_sql_queries() {
  local sql_highlights="$PARSER_DIR/queries/sql/highlights.scm"
  if [[ -f "$sql_highlights" ]]; then
    replace_exact_in_file "$sql_highlights" '   (#match? @number "^[-+]?%d+$"))' '   (#match? @number "^[-+]?[0-9]+$"))'
    replace_exact_in_file "$sql_highlights" '  (#match? @float "^[-+]?%d*\.%d*$"))' '  (#match? @float "^[-+]?[0-9]*\.[0-9]*$"))'
  fi
}

post_process_queries() {
  local lang="$1"

  case "$lang" in
    sql)
      patch_sql_queries
      ;;
  esac
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
clone_build "https://github.com/DerekStride/tree-sitter-sql" "sql" "." "sql" "gh-pages"
clone_build "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "markdown" "tree-sitter-markdown" "markdown"
clone_build "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "markdown-inline" "tree-sitter-markdown-inline" "markdown_inline"

normalize_query_predicates

echo "Parsers installed to: $PARSER_DIR"

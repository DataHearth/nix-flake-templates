# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A collection of Nix flake templates for bootstrapping development environments across multiple languages and frameworks. Users consume templates via:

```sh
nix flake init --template github:DataHearth/nix-flake-templates#<template-name>
```

## Architecture

**Root `flake.nix`** is a pure template registry — it declares 6 templates with paths to their directories, has no inputs, and provides no devShell itself.

Each template directory is a self-contained Nix flake with:
- `flake.nix` — uses `flake-parts` with `mkFlake`, defines `devShells.default` via `pkgs.mkShell`
- `.envrc` — always `use flake` for direnv integration
- `.pre-commit-config.yaml` — pre-commit hooks (all templates include `pre-commit` in nix packages)
- Language-specific config and source files

All templates target `x86_64-linux` only and use `nixpkgs-unstable` (except Rust which also pulls `rust-overlay`).

## Templates

| Template | Stack | Linting | Package Manager |
|---|---|---|---|
| `basic` | Empty shell | pre-commit generic hooks | — |
| `python` | Python 3.12+, setuptools | ruff (via pre-commit) | uv |
| `rust` | Stable Rust (edition 2024) via rust-overlay | cargo fmt + clippy (via pre-commit) | cargo |
| `go` | Go, golangci-lint | golangci-lint (via pre-commit) | go modules |
| `typescript` | Node.js 22, TypeScript, Biome | Biome (via pre-commit) | pnpm |
| `sveltekit` | SvelteKit + Svelte 5 + TailwindCSS v4 + Vite 7 + TS + Biome | Biome (via pre-commit) | pnpm |

## Conventions

- Lock files are gitignored at the root level (see `.gitignore`): `pnpm-lock.yaml`, `package-lock.json`, `flake.lock`, `Cargo.lock`, `go.mod`, `uv.lock`
- Every template includes a `.pre-commit-config.yaml` with `pre-commit/pre-commit-hooks` for generic checks (trailing whitespace, EOF, YAML, merge conflicts) plus language-specific hooks
- JS/TS templates use Biome for linting and formatting (replaces ESLint + Prettier)
- JS/TS templates that use pnpm set `packageManager` in `package.json`
- All flake templates follow the same Nix pattern: `flake-parts.lib.mkFlake` → `perSystem` → `devShells.default`

## Adding a New Template

1. Create a new directory with a self-contained `flake.nix` using `flake-parts`
2. Include `.envrc` (`use flake`), `.gitignore`, and `.pre-commit-config.yaml`
3. Add `pre-commit` to the nix devShell packages
4. Register the template in the root `flake.nix` under `templates`
5. Add any generated lock files to the root `.gitignore`

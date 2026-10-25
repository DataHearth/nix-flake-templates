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
- `flake.nix` — uses `flake-parts` with `mkFlake` and numtide's `devshell` flake module; the shell is `perSystem.devshells.default`, tools listed as `commands` so they show in the `menu`
- `.envrc` — always `use flake` for direnv integration
- Language-specific config and source files

All templates target `x86_64-linux` only and use `nixpkgs-unstable` (except Rust which also pulls `rust-overlay`).

## Templates

| Template | Stack | Linting | Package Manager |
|---|---|---|---|
| `basic` | Empty shell | — | — |
| `python` | Python 3.14 (nixpkgs `python3`), uv_build backend | ruff | uv |
| `rust` | Latest stable Rust (edition 2024) via rust-overlay | `checks.fmt` (cargo fmt) + `lint` command (clippy) | cargo |
| `go` | Go 1.27 (`go_latest`, matches the Go golangci-lint is built with), golangci-lint v2 | `checks.lint` + `lint` command (golangci-lint) | go modules |
| `typescript` | Node.js 24 LTS (nixpkgs `nodejs`), TypeScript 7, Biome | `checks.lint` (Biome) | pnpm |
| `sveltekit` | SvelteKit 3 (config in `vite.config.ts`) + Svelte 5 + TailwindCSS v4 + Vite 8 + TS 6 (Kit's peer range) + Biome | `checks.lint` (Biome) | pnpm |

## Conventions

- Lock files are gitignored at the root level (see `.gitignore`): `pnpm-lock.yaml`, `package-lock.json`, `flake.lock`, `Cargo.lock`, `go.mod`, `uv.lock`
- No pre-commit: the user works in jj, which has no git hooks; linting runs through `nix flake check` and devshell commands
- JS/TS templates use Biome for linting and formatting (replaces ESLint + Prettier)
- JS/TS templates that use pnpm set `packageManager` in `package.json`
- `packageManager` (pnpm) and the `@biomejs/biome` devDependency are pinned to the nixpkgs versions, so pnpm doesn't download another copy of itself and `pnpm lint` matches `nix flake check`
- All flake templates follow the same Nix pattern: `flake-parts.lib.mkFlake` → `imports = [ inputs.devshell.flakeModule ]` → `perSystem` → `devshells.default`

## Adding a New Template

1. Create a new directory with a self-contained `flake.nix` using `flake-parts` and the `devshell` flake module (`devshell.inputs.nixpkgs.follows = "nixpkgs"`)
2. Include `.envrc` (`use flake`) and `.gitignore`
3. Register the template in the root `flake.nix` under `templates`
4. Add any generated lock files to the root `.gitignore`

# GlotCap

GlotCap is a TanStack Start + Convex app for live speaking practice, transcript review, learning insights, and media translation/transcription tools.

## Stack

- TanStack Start with React 19
- Convex for backend functions, auth, and realtime state
- Tailwind CSS v4
- A bundled local `ts-common` workspace package containing the previously private shared modules this app depends on

## Getting Started

1. Install dependencies:

```bash
bun install
```

2. Copy env scaffolding:

```bash
cp .env.example .env
```

3. Start Convex and the web app:

```bash
bun run dev
```

## Environment Notes

- Client-side values live in `.env`.
- Convex server secrets should be set with `bunx convex env set`.
- Check `.env.example` for the main public/runtime variables.

## Repo Layout

- `src/`: frontend routes, components, and browser-side logic
- `convex/`: backend queries, mutations, actions, HTTP actions, and schema
- `shared/`: app-specific domain contracts shared across frontend/backend
- `packages/ts-common/`: vendored subset of shared utilities required to open-source this app cleanly

## Scripts

- `bun run dev`: start Convex and Vite
- `bun run build`: production build
- `bun run test`: run Vitest
- `bun run check`: lint and typecheck
- `bun run quality:hooks`: format check, lint, and typecheck
- `bun run quality:ci`: format check, lint, typecheck, and tests
- `bun run secrets:check -- <files...>`: scan files for committed secrets

## Continuous Integration

GitHub Actions runs `bun run quality:ci`, the production web build, and a Docker build/health smoke test on pull requests and pushes to `main`. CI uses Bun 1.2.7, Node 22, the committed lockfile, and the bundled workspaces. Dependency installation skips lifecycle scripts so CI does not install developer Git hooks.

Only the public `VITE_CONVEX_URL` is supplied. CI does not deploy the web app or Convex backend, and does not need provider credentials or deployment secrets. The smoke test checks the web container's HTTP health, not authenticated backend/provider integration.

## Git Hooks

- Hooks are managed with `lefthook`.
- `pre-commit` runs staged diff checks, large-file blocking, staged secret scanning, staged Prettier/ESLint checks, and a full typecheck.
- `pre-push` runs the test suite.
- `bun install` will install hooks automatically when this project lives inside a real Git repo.

## License

Apache-2.0

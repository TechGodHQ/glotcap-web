# syntax=docker/dockerfile:1
FROM oven/bun:1.2.7@sha256:b03e0d2abf6e1b99d5d219134cd7b294555d2bd708adff765c4320c8b0187822 AS bun

FROM node:22-bookworm-slim@sha256:43ac6c60b8f89723f746e8a92ce91abd5017e627ce1ddfe4238355d3a30b772c AS builder
COPY --from=bun /usr/local/bin/bun /usr/local/bin/bun
WORKDIR /app

# Include every bundled workspace so the committed lockfile stays authoritative.
COPY package.json bun.lock ./
COPY packages ./packages
# Do not run the repository's developer Git-hook installer in a container.
RUN bun install --frozen-lockfile --ignore-scripts
COPY . .

# Public frontend configuration only. Backend deployment is deliberately separate.
ARG VITE_CONVEX_URL
ENV VITE_CONVEX_URL=${VITE_CONVEX_URL}
ENV NITRO_PRESET=node-server
RUN test -n "$VITE_CONVEX_URL" && bun run build

FROM node:22-bookworm-slim@sha256:43ac6c60b8f89723f746e8a92ce91abd5017e627ce1ddfe4238355d3a30b772c AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000
COPY --from=builder --chown=node:node /app/.output ./.output
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:' + (process.env.PORT || '3000') + '/').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))"
CMD ["node", ".output/server/index.mjs"]

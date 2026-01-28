# ---------- Build stage ----------
FROM klakegg/hugo:0.121.0-ext-alpine AS build

WORKDIR /src

# Copy everything (including theme submodule)
COPY . .

# Build the site
RUN hugo --gc --minify

# ---------- Runtime stage ----------
FROM nginx:alpine

# Copy the generated site to nginx
COPY --from=build /src/public /usr/share/nginx/html

# Optional: basic healthcheck
HEALTHCHECK --interval=30s --timeout=5s \
  CMD wget -qO- http://localhost || exit 1

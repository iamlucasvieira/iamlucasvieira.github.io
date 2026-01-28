# ---------- Build stage ----------
FROM hugomods/hugo:exts-0.121.0 AS build

WORKDIR /src
COPY . .

RUN hugo --gc --minify

# ---------- Runtime stage ----------
FROM nginx:alpine
COPY --from=build /src/public /usr/share/nginx/html

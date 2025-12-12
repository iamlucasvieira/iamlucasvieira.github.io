# Personal Website

My personal website built with Hugo, featuring my blog posts and projects.

**Live Site:** [lucasvieira.nl](https://lucasvieira.nl/)

## Tech Stack

- [Hugo](https://gohugo.io/) (v0.121.0) - Static site generator
- [Hugo Bear Blog](https://github.com/janraasch/hugo-bearblog) - Hugo theme
- GitHub Pages - Hosting
- GitHub Actions - Automated deployment

## Local Development

### Prerequisites

- Hugo Extended (v0.121.0 or later)
- Git

### Setup

Clone the repository with submodules:

```bash
git clone --recursive https://github.com/iamlucasvieira/iamlucasvieira.github.io.git
cd iamlucasvieira.github.io
```

If you already cloned without `--recursive`, initialize the theme submodule:

```bash
git submodule update --init --recursive
```

### Running Locally

Start the Hugo development server:

```bash
hugo server -D
```

The site will be available at `http://localhost:1313/`

### Building

Generate the static site:

```bash
hugo --gc --minify
```

The output will be in the `public/` directory.

## Project Structure

```
.
├── content/          # Markdown content files
│   ├── posts/       # Blog posts
│   └── projects/    # Project pages
├── themes/          # Hugo Bear Blog theme (submodule)
├── public/          # Generated static site (not in git)
└── hugo.toml        # Hugo configuration
```

## Deployment

The site automatically deploys to GitHub Pages when changes are pushed to the `main` branch using GitHub Actions. The workflow is defined in `.github/workflows/hugo.yaml`.

## License

Content is copyrighted. Code is available for reference.

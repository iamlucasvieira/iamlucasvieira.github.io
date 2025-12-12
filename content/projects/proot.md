+++
title = "PRoot: Visualizing PR Dependencies"
date = "2024-04-08T22:43:54+01:00"
tags = ["rust", "cli"]
+++

# Visualizing PR Dependencies

[[Source]](https://github.com/iamlucasvieira/proot) [[Demo]](https://crates.io/crates/proot)

There was a time at work when we were drowning in PRs. Like, _a lot_ of PRs. And when you're trying to figure out which one to review first, or why merging one breaks another, or where the bottleneck in your deployment chain is... your brain starts to hurt.

So I built [PRoot](https://github.com/iamlucasvieira/proot) – a CLI that turns your GitHub PRs into an actual graph you can look at. Because sometimes you just need to see the mess you're in.

## The Problem

Here's the thing: PRs don't exist in isolation. PR #47 depends on #45, which depends on #42, which is blocked by #38 that nobody's reviewed yet. And you're sitting there wondering why nothing is moving forward.

GitHub shows you a list of PRs. It doesn't show you _how they connect_. That's where PRoot comes in.

## What It Does

Run `proot` in any repo and you get a tree view of your PRs:

```bash
┌ main
├──○ [#47] feature/new-api - Add new API endpoints
│  └──○ [#49] feature/api-tests - Add tests for new API
├──○ [#45] fix/database - Fix database migration
│  └──○ [#48] fix/db-tests - Add database tests
└──○ [#42] refactor/cleanup - Code cleanup
```

Now you can actually see that #49 is blocked by #47, and #48 is blocked by #45. Review order: obvious.

You can also:

- Open any PR in your browser: `proot 47`
- Filter to just your PRs: `proot filter --me`
- Use custom filters: `proot filter -c "is:closed"`

## Why Rust?

I've been learning Rust, and this felt like the perfect project. It's a CLI tool – no complex UI, just some data processing and pretty terminal output. Plus, I wanted to play with:

- **Clap** for argument parsing (it's ridiculously easy)
- **Serde** for JSON handling (GitHub CLI outputs JSON)
- **Colored** for making the terminal not look like 1995

The whole thing is a wrapper around `gh cli`, parsing its JSON output and building a graph structure. Nothing fancy, but it works.

## The Graph Part

The interesting bit is how I represent the PR relationships. Each PR has a `head` branch and a `base` branch. If PR A's head is PR B's base, then B depends on A.

I build an [adjacency list](https://en.wikipedia.org/wiki/Adjacency_list) where each base branch points to all the head branches that target it:

```rust
pub struct PrGraph {
    adjacency_list: HashMap<String, Vec<String>>,
    prs: HashMap<String, Pr>,
}
```

Then it's just a [DFS](https://en.wikipedia.org/wiki/Depth-first_search) traversal to print the tree. The tricky part was handling cross-repository PRs (forks) and making sure the output actually looks like a tree with all those Unicode box-drawing characters.

## Lessons Learned

**Rust's error handling is verbose but worth it.** Every function returns a `Result`, and you handle errors explicitly. It's more work upfront, but debugging is way easier because you're forced to think about what can go wrong.

**Graph algorithms are everywhere.** I knew the theory from university, but actually implementing a DFS to traverse PR dependencies? That's when it clicked.

## Current Status

It's published on [crates.io](https://crates.io/crates/proot), which is wild because I built it for myself and now other people apparently use it. The download count keeps going up and I have no idea who these people are.

If you're drowning in PRs like we were, give it a try:

```bash
cargo install proot
```

Or check out the [repo](https://github.com/iamlucasvieira/proot) if you want to see how it works.

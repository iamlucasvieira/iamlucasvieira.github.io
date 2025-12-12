+++
title = "A game in 10 days"
date = "2025-07-12T15:18:43+01:00"
tags = ["game"]
+++

# Pip's Flight: A game in 10 days

[[Source]](https://github.com/iamlucasvieira/pips-flight) [[Demo]](https://hilucas.itch.io/pips-flight)

{{< figure src="images/title.png" align="center" >}}

Last summer I did something I'd been thinking about for years: I finally entered a game jam. [Shovel Jam 2025](https://itch.io/jam/shovel-jam-2025) had the perfect vibe for a first-timer—welcoming community, and a reasonable 10-day timeline, and a interesting theme: "Just Get Started."

The result was [Pip's Flight](https://hilucas.itch.io/pips-flight), a 2D platformer about an owl who can't fly yet. You guide Pip through three levels with limited jumps, trying to collect stars and reach the clouds. I handled everything solo:

- code
- pixel art
- music
- level design
- and definitely too much coffee

## The Idea

The theme "Just Get Started" made me think about first attempts at anything—those awkward early stages where you don't know what you're doing yet. Learning to fly felt like the perfect metaphor. Pip is an owl, but grounded. Each level gives you just enough jumps to make it through, so every leap matters.

I wanted that feeling of carefully planned movement. You can't spam the jump button—you have to think about your route, commit to it, and sometimes trust that you'll make it across that gap.

## Building in Godot

This was my first real [Godot](https://godotengine.org/) project. I picked it because it is lightweight, open-source, and has a nice community. GDScript (Godot's scripting language) felt Python-adjacent enough to just jump in, and the scene system just makes sense once you get it.

The movement system uses a [state machine](https://en.wikipedia.org/wiki/Finite-state_machine) pattern—Idle, Walk, Jump, Fall, Glide. Each state handles its own physics and transitions:

```gdscript
# From player_state.gd
const IDLE = "Idle"
const WALK = "Walk"
const JUMP = "Jump"
const FALL = "Fall"
const GLIDE = "Glide"
```

The jump state checks if you have jumps available before executing:

```gdscript
func enter(_previous_state_path: String, _data := {}) -> void:
    if jump_cooldown.is_stopped() and player.can_jump():
        animated_sprite_2d.play("flap")
        player.velocity.y = player.JUMP_VELOCITY
        Game.increase_jump_counter()
        jump_cooldown.start()
```

The state machine handled edge cases cleanly—like preventing mid-air jumps unless you have double-jump unlocked, or transitioning smoothly from glide back to fall when you release the button.

## Art and Animations

I love crafts im my free time; sketching, painting, etc. So I was very excited to do the entire art and animations myself. I used [Aseprite](https://www.aseprite.org/) to create the sprites and animations.

{{< figure src="images/animation.gif" caption="Pip's animations" align="center" >}}

## What Went Wrong

Everything takes longer than you think. I spent two days just getting the physics to feel right. The collision detection was buggy until day 6. I had planned four levels and cut it to three at the last minute because level design is _slow_.

The game is also pretty short—you can finish all three levels in about 10 minutes if you know what you're doing. But honestly? For a first jam, shipping something complete felt more important than shipping something huge.

## What Went Right

The jump limit mechanic worked exactly how I wanted. Players _feel_ the constraint. You're constantly counting remaining jumps in your head, planning your next three moves. That tension between "can I make this jump?" and "do I have jumps left?" is the whole game.

I also managed to avoid scope creep. No enemies, no combat, no power-ups beyond the glide. Just movement, jumping, and careful planning. For 10 days, that was the right call.

## Lessons Learned

**Start even simpler.** I thought "three levels, basic platformer" was minimal. It wasn't. Next time: one mechanic, one level, iterate from there.

**Juice matters.** Adding screen shake when you land, particles when you collect stars, sound effects for everything—these tiny details made the game feel way more polished than it actually was.

---

If you want to try it, it's [free on itch.io](https://hilucas.itch.io/pips-flight).

+++
title = "Advent of Code 2022 in Rust"
date = "2024-01-17T13:11:06+01:00"
tags = ["rust"]
+++

In my quest to learn Rust, I dived into the first three days of Advent Of Code 2022. Let me tell you... It was very fun. Even though I have [previously solved](https://github.com/iamlucasvieira/advent-of-code-2023/tree/main/2022) those three challenges in Go, Rust allowed me to approach them uniquely.

You can check out my solutions [here](https://github.com/iamlucasvieira/advent-of-code-2022). And for anyone wanting to use Rust for Advent of Code, you should check this awesome [Rust template](https://github.com/fspoettel/advent-of-code-rust) – it's a lifesaver for setting up and testing your code.

## Day 1 - Calorie Counting

Day 1's puzzle was all about calories. We're given lists of numbers, and our task is to find the group with the highest sum. For example:

```text
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
```

The highest sum happens in the 4th group: `24000` = 9000 + 8000 + 7000

For this challenge, I wanted my Rust code to be as 'Rusty' as possible. I started by parsing the input with iterators:

```rust
fn parse(input: &str) -> Vec<u32> {
    input
        .split("\n\n")
        .map(|group| {
            group
                .lines()
                .map(|line| line.parse::<u32>().unwrap())
                .sum::<u32>()
        })
        .collect::<Vec<u32>>()
}
```

Then, it was all about finding the max value:

```rust
pub fn part_one(input: &str) -> Option<u32> {
    parse(input).iter().max().copied()
}
```

The twist in part two was to find the sum of the top three values. I approached this by sorting and summing the highest values:

```rust
pub fn part_two(input: &str) -> Option<u32> {
    let mut group_sums = parse(input);
    group_sums.sort();
    group_sums.reverse();
    group_sums.iter().take(3).sum::<u32>().into()
}
```

Rust iterators made my solution quite different to my Go approach. It was like thinking in 3D instead of 2D (if that makes sense). Here is my Go version:

```go
func parseData(data []string) ([]int, error) {
	var calories = []int{0}

	idx := 0
	for _, line := range data {

		if line == "" {
			calories = append(calories, 0)
			idx++
			continue
		}

		calorie, err := strconv.Atoi(line)
		if err != nil {
			return nil, err
		}

		calories[idx] += calorie

	}
	return calories, nil
}

func part1() {
	fmt.Println("Part 1:")
	data, err := parseData(utils.ReadFile("input.txt"))
	if err != nil {
		panic(err)
	}
	maxCalories := slices.Max(data)
	fmt.Printf("Max calories: %d\n", maxCalories)
}
```

## Day 2 - Rock Paper Scissors

The challenge of day 2 is a classic game of rock, paper, scissors. Each line in the input has the opponent and player choices. The objective is to compute the score from all matches. The input looks like this:

```text
A Y
B X
C Z
```

The opponent choice is in the left column, and the player choice is in the right column. Where:

- `A` = `X` = Rock
- `B` = `Y` = Paper
- `C` = `Z` = Scissors

For the score, winning gives 6 points, a tie gives 3 points and 0 for losing. Besides that, we add the value of the player's choice: +1 for choosing Rock, +2 for choosing paper and +3 for choosing Scissors.

Here's where Rust's `enum` shined. It was perfect for defining the possible states and the game logic.

```rust
#[derive(Debug, PartialEq, Clone)]
enum Game {
    Rock,
    Paper,
    Scissors,
}

impl Game {
    fn from_str(input: &str) -> Result<Game, &'static str> {
        match input {
            "A" | "X" => Ok(Game::Rock),
            "B" | "Y" => Ok(Game::Paper),
            "C" | "Z" => Ok(Game::Scissors),
            _ => Err("Invalid input"),
        }
    }

    fn value(&self) -> u32 {
        match self {
            Game::Rock => 1,
            Game::Paper => 2,
            Game::Scissors => 3,
        }
    }

    fn score(&self, other: &Game) -> u32 {
        match (self, other) {
            (Game::Rock, Game::Paper) => 0,
            (Game::Rock, Game::Scissors) => 6,
            (Game::Paper, Game::Rock) => 6,
            (Game::Paper, Game::Scissors) => 0,
            (Game::Scissors, Game::Rock) => 0,
            (Game::Scissors, Game::Paper) => 6,
            _ => 3,
        }
    }
}
```

- `from_str` converts a string into one of the enum values.
- `value` gives a numeric value to each choice.
- `score` calculates the score for a match based on the classic game rules.

With the rules set, scoring the matches was straightforward:

```rust
pub fn part_one(input: &str) -> Option<u32> {
    parse(input)
        .iter()
        .map(|(oponent, player)| player.score(oponent) + player.value())
        .sum::<u32>()
        .into()
}
```

Before starting this challenge, I knew I wanted to use enums in at least one of my solutions. Using them exceeded my expectations. Rust's enums are more than just a list of constants; they can encapsulate varied data types and include methods, making them incredibly powerful. I now understand why many Gophers still wait for this feature to be added in Go.

## Day 3 - Rucksack Reorganization

The challenge of day 3 is to find the common character in two halves of a string.

For example, in the string `vJrwpWtwJgWrhcsFMMfFFhFp`, the common character is `p`. It appears both on the string's first half (`vJrwpWtwJgWr`) and the second half (`hcsFMMfFFhFp`).

I first defined all the functions I needed

```rust
fn parse(input: &str) -> Vec<&str> {
    input
        .lines()
        .map(|line| line.trim())
        .filter(|line| !line.is_empty())
        .collect()
}

fn split_half(input: &str) -> (&str, &str) {
    let mid = input.len() / 2;
    input.split_at(mid)
}

fn common_char(first: &str, second: &str) -> Option<char> {
    first.chars().find(|&c| second.contains(c))
}

fn char_priority(c: char) -> Option<u32> {
    match c {
        'a'..='z' => Some(c as u32 - 'a' as u32 + 1),
        'A'..='Z' => Some(c as u32 - 'A' as u32 + 27),
        _ => None,
    }
}
```

- `parse` takes the input string and turns it into a vector of strings.
- `split_half` divides a string into two equal parts.
- `common_char` finds a character common to two strings. (I used the `find` method because it's efficient — it stops searching as soon as it finds a match.)
- `char_priority` assigns a numeric value to the common character, as defined in the problem.

Then, I incorporated these functions into an iterator pattern to get the solution:

```rust
pub fn part_one(input: &str) -> Option<u32> {
    parse(input)
        .iter()
        .filter_map(|line| {
            let (first, second) = split_half(line);
            common_char(first, second).and_then(char_priority)
        })
        .sum::<u32>()
        .into()
}
```

In this code, I used `filter_map` to skip any `None` value (e.g., this would skip strings with no common character). However, in AOC challenges, we can assume the input file will always satisfy the assumptions (in this example, every string will have a common character). Therefore, I could have used `unwrap` in the values instead. A more robust approach would be handling errors and returning a message. I plan to explore these error-handling strategies in future implementations.

## Wrapping Up

The main things I enjoyed and learned in this project:

1. **Rust's Iterators Are Awesome**: Rust's iterators are data transformers, not just simple loops. They introduced me to a new way of thinking, enabling more efficient and elegant data manipulation.
2. **Rust's Enums Are Versatile**: Rust's Enums function almost like mini-classes. They can handle different data types and include methods. This feature makes them very useful in many parts of your code.
3. **Testing in Rust is Smooth**: Writing tests in Rust was very intuitive. The testing framework is integrated so seamlessly into the language that setting up and running tests is smooth.

Though enums are amazing, testing them can be tricky. For now, I'm leaning towards using enums mainly for data parsing while keeping my logic in separate, testable chunks.

That's it for now!

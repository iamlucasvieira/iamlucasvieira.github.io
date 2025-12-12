+++
title = "Building an Interpreter in Rust: The Monkey Language"
date = "2024-04-12T15:03:53+01:00"
tags = ["rust", "interpreters"]
+++

# Building an Interpreter in Rust

[[Source]](https://github.com/iamlucasvieira/rust-monkey-interpreter)

I built an interpreter for the [Monkey programming language](https://monkeylang.org/) in Rust. This is, hands down, my favorite project so far. Not because it's the most practical thing I've ever made, but because it made me understand how programming languages actually work – not just use them.

I started with [Writing an Interpreter in Go](https://interpreterbook.com/) and [Crafting Interpreters](https://craftinginterpreters.com/). Both are excellent. But here's the thing: the first book uses Go, and I was learning Rust. So I decided to translate the concepts myself rather than copy-paste Go code.

This was the best decision I made. You don't truly understand something until you've had to implement it in a language with different constraints. Go's garbage collector lets you be relaxed about memory. Rust's borrow checker makes you think about ownership at every step. Every concept had to be carefully considered.

Here's what Monkey code looks like:

```rust
let fibonacci = fn(x) {
    if (x == 0) {
        return 0;
    } else {
        if (x == 1) {
            return 1;
        } else {
            fibonacci(x - 1) + fibonacci(x - 2);
        }
    }
};

fibonacci(10); // 55
```

Nothing groundbreaking, but enough complexity to make things interesting.

## The Architecture

Building an interpreter means building four main pieces:

1. **Lexer** – turns source code into tokens
2. **Parser** – turns tokens into an Abstract Syntax Tree ([AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree))
3. **Evaluator** – walks the AST and executes it
4. **Environment** – stores variables and their values

The flow is straightforward: `Source Code → Lexer → Parser → AST → Evaluator → Result`

## The Parts That Made Me Think

### The Parser is Smarter Than I Expected

I thought parsing would be simple pattern matching. It's not. The challenge is handling operator precedence without writing a giant nested if-statement.

The solution? [Pratt parsing](https://en.wikipedia.org/wiki/Operator-precedence_parser#Pratt_parsing). Each operator has a precedence level, and the parser uses that to decide how to group expressions:

```rust
fn parse_expression(&mut self, precedence: Precedence) -> Result<ast::Expression> {
    let mut left_expression = self.parse_prefix(&self.cur_token.clone());
    let mut peek_precedence = self.peek_token.precedence();

    while !self.peek_token.is_of_type(&token::Token::SEMICOLON)
        && precedence < peek_precedence
    {
        self.next_token();
        left_expression = self.parse_infix(left_expression?);
        peek_precedence = self.peek_token.precedence();
    }

    left_expression
}
```

This tiny loop handles parsing `1 + 2 * 3` correctly (as `1 + (2 * 3)`) without any special-casing. The precedence levels do all the work.

### Closures Are Just Environments

When you define a function in Monkey, it captures its environment. This is how closures work:

```monkey
let newAdder = fn(x) {
    fn(y) { x + y };
};

let addTwo = newAdder(2);
addTwo(3); // 5
```

The inner function remembers `x` even after `newAdder` returns. In my implementation, functions are just:

```rust
Object::Function {
    parameters: Vec<ast::Identifier>,
    body: Rc<RefCell<ast::BlockStatement>>,
    env: Rc<RefCell<Environment>>,  // ← The magic
}
```

That `env` field holds the captured environment. When you call the function, it creates a new environment that extends the captured one. That's it.

### Hash Maps Need Hashable Keys

Implementing hash maps in Monkey was interesting because not everything should be a valid key:

```rust
impl HashKey for Object {
    fn hash_key(&self) -> Result<u64> {
        match self {
            Object::Integer(value) => Ok(*value as u64),
            Object::Boolean(value) => Ok(if *value { 1 } else { 0 }),
            Object::String(value) => {
                let mut hasher = DefaultHasher::new();
                (*value).hash(&mut hasher);
                Ok(hasher.finish())
            }
            _ => anyhow::bail!(Error::KeyError(format!(
                "unusable as hash key: {}",
                self.object_type()
            ))),
        }
    }
}
```

Functions and arrays can't be keys. Why? Because you can't meaningfully compare them. Two functions with the same code but different closures aren't "equal" in any useful sense.

### The REPL is Just a Loop

The Read-Eval-Print Loop is exactly what it sounds like:

```rust
pub fn start<R: Read, W: Write>(reader: R, writer: &mut W) -> io::Result<()> {
    let mut reader = BufReader::new(reader);
    let env = Rc::new(RefCell::new(Environment::new()));

    loop {
        write!(writer, "{}", PROMPT)?;
        writer.flush()?;

        let mut line = String::new();
        if reader.read_line(&mut line)? == 0 { break; }

        let mut lexer = lexer::Lexer::new(line.trim());
        let mut parser = parser::Parser::new(&mut lexer);

        if let Ok(program) = parser.parse_program() {
            match evaluator::eval(program.into(), env.clone()) {
                Ok(evaluated) => writeln!(writer, "{}", evaluated)?,
                Err(e) => writeln!(writer, "{}", e)?,
            }
        }
    }
    Ok(())
}
```

Read a line, parse it, evaluate it, print the result. The environment persists across iterations so variables stick around. That's how a REPL works.

## What Rust Taught Me

### Reference Counting Everywhere

Because the AST needs to share ownership of nodes, I used `Rc<>` everywhere. The environment is `Rc<RefCell<Environment>>` so it can be mutated while shared. Function bodies are `Rc<RefCell<BlockStatement>>` for the same reason.

This felt clunky at first, but it's actually explicit about what Go's garbage collector hides: shared ownership requires runtime bookkeeping.

### Enums Are Perfect for ASTs

Rust's enums make AST nodes beautiful:

```rust
pub enum Expression {
    Identifier(Identifier),
    Integer(IntegerLiteral),
    String(StringLiteral),
    Boolean(Boolean),
    Prefix(PrefixExpression),
    Infix(InfixExpression),
    If(IfExpression),
    Function(FunctionLiteral),
    Call(CallExpression),
    Array(ArrayLiteral),
    Index(IndexExpression),
    Hash(HashLiteral),
}
```

Each variant holds its own data. Pattern matching makes the evaluator clean:

```rust
match expr {
    ast::Expression::Integer(literal) => Ok(Rc::new(Object::Integer(literal.value))),
    ast::Expression::String(literal) => Ok(Rc::new(Object::String(literal.value))),
    ast::Expression::Boolean(literal) => eval_boolean(literal),
    ast::Expression::Prefix(literal) => eval_prefix_expression(literal, env),
    ast::Expression::Infix(literal) => eval_infix_expression(literal, env),
    // ... and so on
}
```

No null checks, no inheritance hierarchies, just data and functions.

## What I'd Do Differently

If I were starting over, I'd add:

- **Better error messages** with line numbers and column positions
- **A type system** (even a simple one would catch bugs)
- **Bytecode compilation** for performance (this is what Crafting Interpreters does in part 3)

## Try It

The interpreter is on [GitHub](https://github.com/iamlucasvieira/rust-monkey-interpreter). You can run the REPL:

```bash
cargo run
```

Or execute a file:

```bash
cargo run -- examples/fibonacci.monkey
```

---

If you've ever wondered how programming languages work, build an interpreter. It's one of those projects that changes how you think about code. You go from "I use functions" to "I understand why functions work."

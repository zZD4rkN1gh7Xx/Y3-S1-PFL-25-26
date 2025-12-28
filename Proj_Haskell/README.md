# Calculator Project PFL-Haskell 25/26

A Haskell-based calculator for arithmetic expressions with support for variables and assignments.

<h2 align="center">This project was made by

<div align="center">

| Nome            | Número de Estudante |
|-----------------|---------------------|
| Luciano Ferreira| 202208158           |

</div>


## Overview

This project extends a basic calculator with additional arithmetic operations and variable management capabilities. It's built using functional parsing combinators based on Graham Hutton's "Programming in Haskell".



## Features

### Part 1: Extended Arithmetic Operations
- Addition (`+`)
- Subtraction (`-`)
- Multiplication (`*`)
- Integer division (`/`)
- Modulus/remainder (`%`)
- Parenthesized expressions

### Part 2: Variables and Commands
- Variable assignment: `variable=expression`
- Variable names: sequences of letters (e.g., `x`, `foo`, `myVar`)
- Expression evaluation with variables
- Persistent state across multiple commands

## Usage

### Running the Calculator

```bash
ghc Calculator.hs
./Calculator < input.txt
```

Or interactively in GHCi:
```bash
ghci Calculator.hs
main
# Type expressions/commands, one per line
# Type 'quit' to exit
```

### Example Sessions

**Arithmetic operations:**
```
10-5+12
17

(10+5)/(2+7)
1

1234/6/2
102
```

**Variables and assignments:**
```
x=1
1

xx=x*x+1
2

(x+xx+1)*xx
8
```

## Files

- `Calculator.hs` - Main calculator implementation with parser and evaluator
- `Parsing.hs` - Parsing combinator library (do not modify)
- `projeto1.pdf` - Project specification

## Grammar

```
command  ::= variable '=' expr | expr
expr     ::= term exprCont
exprCont ::= '+' term exprCont | '-' term exprCont | ε
term     ::= factor termCont
termCont ::= '*' factor termCont | '/' factor termCont | '%' factor termCont | ε
factor   ::= variable | natural | '(' expr ')'
```

## Notes

- Division by zero will cause a runtime error
- Using undefined variables will cause a runtime error
- Type `quit` to exit the calculator
- Each command should be on a separate line

## PDF and project ideia by Author

Pedro Vasconcelos, DCC/FCUP, 2025
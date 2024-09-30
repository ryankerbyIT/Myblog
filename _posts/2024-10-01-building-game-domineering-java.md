---
title: "Building the Game of Domineering in Java: A Deep Dive into Object-Oriented Design"
description: "Domineering in Java: A Strategic Two-Player Game Built with Simple Data Structures and Object-Oriented Design."
author: Ryan Kerby
date: 2024-09-27 12:00:00 +0800
categories: [Projects, Algorithms]
tags: [Java, Java Games, Programming, Clean Code, Object-Oriented Programming, Data Structures, Algorithms]
pin: true
math: false
mermaid: false
image:
  path: /assets/images/domineering-game-java.jpg
  alt: "An abstract visual representation of programming The Game of Domineering in Java."
---


### **Building Domineering in Java: A Comprehensive Guide to Game Logic, Data Structures, and OOP**

## Introduction
Domineering is a two-player strategy game played on an 8x8 grid. Each player takes turns placing dominoes on the board: one player places horizontally (east-west), while the other places vertically (north-south). The objective is to be the last player able to make a legal move. The game highlights critical concepts in programming, such as data structures, algorithms, and object-oriented design.

This in-depth guide will take you through building Domineering in Java using an object-oriented approach. We’ll explore the logic behind the game, showcase how data structures like 2D arrays are employed, and discuss how various algorithms work together to simulate the game. Along the way, code examples will illustrate key aspects of the implementation.

## Overview of the Game
1. `Players:` Two players take turns placing dominoes. One places them horizontally, and the other places them vertically.
2. `Objective:` Be the last player able to make a legal move.
3. `Gameplay:` Players place dominoes (occupying two adjacent squares) onto an 8x8 grid. The game ends when one player cannot make a valid move.

### Setting Up the Game: The **Domineering** Class
The entire game logic is encapsulated within a single class named `Domineering`. This class contains methods and attributes that handle the board's state, manage player moves, and enforce the rules of the game.

## Code Walkthrough
### 1. Defining the Board: Using a 2D Boolean Array
A two-dimensional boolean array is used to represent the board. This array tracks the state of each square, determining whether it is occupied by a domino.
```java
// Array of board squares, true if occupied.
private boolean[][] squares;

// The board is initially empty.
public Domineering() {
    squares = new boolean[8][8];
    // Java initializes all array elements to false.
}

```

### Explanation:
- `squares` `Array: A` `boolean[][]` array of size `8x8` is initialized to represent the board. Each element is `false` by default (Java initializes boolean arrays to `false`), indicating that the squares are unoccupied.
- `Space Complexity:` The array has a fixed size of 64 elements, making it a memory-efficient way to represent the board.
- `Time Complexity:` Accessing or modifying the elements of the array is an `O(1)` operation, allowing for quick checks and updates during gameplay.

### 2. Rendering the Board: The **toString** Method
The board's current state is visualized using the `toString` method, which provides a string representation of the board.
```java
@Override
public String toString() {
    StringBuilder result = new StringBuilder();
    result.append("   1 2 3 4 5 6 7 8"); // Column headers
    for (int row = 0; row < 8; row++) {
        result.append("\n").append(row + 1).append(" "); // Row header (1-8)
        for (int column = 0; column < 8; column++) {
            if (squares[row][column]) {
                result.append(" #");
            } else {
                result.append(" .");
            }
        }
    }
    return result.toString();
}
```
### Explanation
- **Column Headers:** The first line adds numbers 1 through 8 to represent column numbers for easier input reference.
- **Row Headers:** Each row in the grid is prefixed with its corresponding number (1 to 8).
**Occupied vs. Empty Squares:** The method appends " #" if a square is occupied (true), otherwise " .", creating a visual representation of the game state.
- **StringBuilder:** Efficiently concatenates strings during board rendering, avoiding the performance penalty of repeated string concatenation.

### 3. Managing Player Turns: The **play** Method
The **play** method is the core game loop. It alternates turns between the horizontal and vertical players, checking for legal moves and handling player input.
```java
public void play() {
    boolean player = HORIZONTAL;
    while (true) {
        System.out.println("\n" + this);
        if (player == HORIZONTAL) {
            System.out.println("Horizontal to play");
        } else {
            System.out.println("Vertical to play");
        }

        if (!hasLegalMoveFor(player)) {
            System.out.println("No legal moves -- you lose!");
            return;
        }

        int row, column;
        boolean validMove;
        do {
            System.out.print("Row (1-8): ");
            row = INPUT.nextInt() - 1; // Adjust input to zero-indexed array
            System.out.print("Column (1-8): ");
            column = INPUT.nextInt() - 1; // Adjust input to zero-indexed array

            validMove = isValidMove(row, column, player);
            if (!validMove) {
                System.out.println("Invalid move! Try again.");
            }
        } while (!validMove);

        playAt(row, column, player);
        player = !player;
    }
}
```
### Explanation
- **Main Game Loop:** Continuously runs, alternating between the horizontal and vertical players until one cannot make a legal move.
- **Turn Indication:** Displays which player's turn it is, enhancing user interaction.
- **Input Handling:** Prompts the player to input the row and column, adjusting the 1-based input to the 0-based indexing used by the array (row - 1 and column - 1).
- **Move Validation:** Calls isValidMove() to check if the move is legal. If not, it prompts the user to try again.
- **Play Execution:** Calls playAt() to place the domino on the board.
- **Switch Player:** Toggles the player variable to alternate turns.

### Validating Moves: The **isValidMove** Method
This method checks whether the proposed move is valid for the current player.
```java
public boolean isValidMove(int row, int column, boolean player) {
    int rowOffset = player == VERTICAL ? 1 : 0;
    int columnOffset = player == HORIZONTAL ? 1 : 0;

    // Check if move is within bounds
    if (row < 0 || row + rowOffset >= 8 || column < 0 || column + columnOffset >= 8) {
        return false;
    }

    // Check if both squares are unoccupied
    return !squares[row][column] && !squares[row + rowOffset][column + columnOffset];
}
```
### Explanation
- **Bounds Check:** Ensures that the domino does not exceed the board's boundaries.
- **Occupied Check:** Checks that both squares required for the domino placement are unoccupied.
- **Offsets:** Uses **rowOffset** and **columnOffset** to differentiate between horizontal and vertical placements, ensuring the method can validate moves for both players.
- **Efficiency:** Runs in constant time **(O(1))** because it only performs a few checks.

### 5. Placing Dominoes: The **playAt** Method
The playAt method updates the board to reflect the placement of the domino.
```java
public void playAt(int row, int column, boolean player) {
    if (player == HORIZONTAL) {
        squares[row][column] = true;
        squares[row][column + 1] = true;
    } else {
        squares[row][column] = true;
        squares[row + 1][column] = true;
    }
}
```
### Explanation
- **Horizontal Placement:** Marks the current square and the square to the right as occupied.
- **Vertical Placement:** Marks the current square and the square below as occupied.
- **Assumption:** This method assumes that isValidMove() has already confirmed the legality of the move.

### 6. Checking for Legal Moves: The **hasLegalMoveFor** Method
This method checks if there are any legal moves left for the current player.
```java
public boolean hasLegalMoveFor(boolean player) {
    int rowOffset = player == VERTICAL ? 1 : 0;
    int columnOffset = player == HORIZONTAL ? 1 : 0;

    for (int row = 0; row < (8 - rowOffset); row++) {
        for (int column = 0; column < (8 - columnOffset); column++) {
            if (!squares[row][column] && !squares[row + rowOffset][column + columnOffset]) {
                return true;
            }
        }
    }
    return false;
}
```
### Explanation
- **Search for Legal Moves:** Iterates over each square on the board to find at least one valid move for the specified player.
- **Adjusts for Orientation:** Uses rowOffset and columnOffset to check the availability of spaces required for horizontal or vertical placements.
- **Complexity:** Runs in O(n^2) time for an n x n board. However, since the board size is fixed (8x8), this operation is effectively O(1) in practical terms.

## Key Object-Oriented Concepts in Use

### 1. Encapsulation
Encapsulation is the concept of bundling data (attributes) and methods that operate on the data into a single unit, or class, while hiding the internal state from outside interference. In this implementation:

- The board state is encapsulated within the **Domineering** class using a private 2D boolean array (**squares**). Direct access to this array is restricted, allowing it to be manipulated only through the class's methods (e.g., **playAt()**, **isValidMove())**.
- Methods like **isValidMove()**, **playAt()**, and **hasLegalMoveFor()** interact with the board's state, ensuring that only valid operations are performed on the board. This encapsulation enforces game rules and prevents unauthorized changes to the board's internal state.

### Code Example: Encapsulation
```java
private boolean[][] squares; // Encapsulated board state

public void playAt(int row, int column, boolean player) {
    if (player == HORIZONTAL) {
        squares[row][column] = true;
        squares[row][column + 1] = true;
    } else {
        squares[row][column] = true;
        squares[row + 1][column] = true;
    }
}
```
- The **squares** array is marked as **private**, hiding it from external access.
- The **playAt()** method modifies the **squares** array internally while ensuring that only valid placements (based on previous validation) are made.

### 2. Abstraction
Abstraction is about simplifying complex reality by modeling classes that represent real-world objects and concepts while exposing only the essential details. In this implementation:

- The **Domineering** class abstracts the concept of the Domineering game, handling board management, player moves, and game rules.
- The internal workings of move validation and placement are hidden from the user, allowing them to interact with the game at a higher level (e.g., inputting row and column numbers).

### Code Example: Abstraction
```java
public boolean isValidMove(int row, int column, boolean player) {
    int rowOffset = player == VERTICAL ? 1 : 0;
    int columnOffset = player == HORIZONTAL ? 1 : 0;

    // Check if move is within bounds
    if (row < 0 || row + rowOffset >= 8 || column < 0 || column + columnOffset >= 8) {
        return false;
    }

    // Check if both squares are unoccupied
    return !squares[row][column] && !squares[row + rowOffset][column + columnOffset];
}
```
The **isValidMove()** method abstracts the complex logic needed to determine if a move is valid, encapsulating it within a simple, easy-to-use method. Users of this method don't need to know the underlying mechanics; they just get a **true** or **false** result indicating move validity.

### 3. Inheritance (N/A in this Example)
The current implementation does not use inheritance directly, as there is no subclassing or hierarchy involved. However, this design could be extended in the future with additional classes to represent different board types or game variations.

### 4. Polymorphism (N/A in this Example)
While the game does not employ polymorphism directly, there is potential for its use. For instance, if you decide to implement computer-controlled players or different game variations, you could use polymorphism to define a common interface for different player types (human, AI) or board configurations.

### 5. Single Responsibility Principle (SRP)
The class design follows the Single Responsibility Principle, a core principle of object-oriented design. The **Domineering** class is solely responsible for managing the game state, player interactions, and enforcing game rules. Each method within the class has a distinct responsibility:
- toString(): Handles board rendering.
- play(): Manages the gameplay loop and player turns.
- isValidMove(): Checks if a player's move is valid.
- playAt(): Updates the board state for a valid move.
- hasLegalMoveFor(): Checks for any remaining legal moves for the current player.

### Enhancing the Game: Possible Extensions

### 1. Adding an AI Player
One possible enhancement is to implement an AI opponent. This would involve creating a new class (e.g., **AIPlayer**) that contains methods for decision-making based on board analysis. This class would interact with the Domineering class through public methods like **isValidMove()** and **playAt()**, illustrating further use of encapsulation and abstraction.

### 2. Creating a Graphical Interface
While the current implementation is console-based, adding a graphical interface (using JavaFX or Swing) could improve the game's interactivity. In this scenario, the **Domineering** class would serve as the "model" in a Model-View-Controller (MVC) design pattern, where the graphical interface would represent the "view" and "controller" components.

### 3. Implementing Inheritance for Board Variations
Suppose you want to support different board sizes or types. In that case, you could create a base class (e.g., **Board**) and derive specific classes (**StandardBoard**, **LargeBoard**) from it, using inheritance to handle variations in board behavior.

## Conclusion
This implementation of Domineering in Java offers a rich learning experience in object-oriented design, data structures, and algorithms:

- **Object-Oriented Design:** By encapsulating the game's data and logic within the Domineering class, the code is modular, extensible, and easy to understand.
- **Data Structures:** A simple 2D boolean array serves as the board, demonstrating how a straightforward data structure can effectively model complex game mechanics.
- **Algorithms:** The methods for move validation, placement, and game state evaluation encapsulate the game's core logic, showcasing the use of efficient algorithms to drive gameplay.

By understanding and implementing these concepts, one can appreciate the power of object-oriented programming in building interactive applications. This game can serve as a foundation for more complex projects, from board game simulators to AI-driven strategy games.


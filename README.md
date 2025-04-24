# Text-Based RPG Store and Inventory Simulator

This is a command-line Java application that simulates a store and inventory system for a role-playing game (RPG). Players can enter the store, buy or sell items, manage their inventory, and interact with item attributes such as wearables, consumables, and equipment.

This was initially created as my semester-long project for CS 214 Software Development at Colorado State University in Fall 2023. I have since refined the game for a better User Experience.

## Features

- Player inventory management
- Item buying/selling through a simulated store
- Escrow-based transaction system
- Wearable, consumable, and equipable item logic
- JUnit test suite to verify store behavior and player interactions
- Command-line user interface

## Technologies

- Java 11
- Maven (build tool)
- JUnit 4 (unit testing)

## Project Structure

````plaintext
.
├── pom.xml                    # Maven config (dependencies, build rules)
├── README.md                  # Project documentation
├── LICENSE                    # MIT license
├── .gitignore                 # Git exclusions (e.g., /target/)
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── Main.java
│   │   │   ├── Store.java
│   │   │   ├── Player.java
│   │   │   ├── Item.java
│   │   │   ├── ItemAttributes.java
│   │   │   ├── Escrow.java
│   │   │   └── CustomExceptions.java
│   └── test/
│       └── java/
│           └── TestSetJUnit4.java
│           └── TestSetJUnit5.java
└── target/                    # Generated build output (ignored by Git)

```` 

## How to Run

```bash
mvn clean compile
mvn exec:java -Dexec.mainClass="Main"
```
Make sure to use the Maven Exec plugin. If it's not already configured, you can either add it to your ```pom.xml``` or manually run the compiled class from the ```target/classes``` directory like so:
```bash
java -cp target/classes Main
```
## How to Test

```bash
mvn test
```
This will run all unit tests in `src/test/java/`, including:

- `TestSetJUnit4.java`
- `TestSetJUnit5.java` (if configured with JUnit 5 in `pom.xml`)

Tests cover core player-store interactions, item transactions, and money management.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact

Created and maintained by:

**Katie Taylor**  
GitHub: [@katietay](https://github.com/katietay)  
Email: katietaylorcruz@gmail.com

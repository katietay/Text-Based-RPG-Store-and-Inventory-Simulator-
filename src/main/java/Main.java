
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Store store = new Store();
        Player player = new Player(100.00);

        try (Scanner scanner = new Scanner(System.in)) {
            exposeGameSetup(store);
            exposeGamePlay(store, player, scanner);
            exposeGameStop();
        }
    }

    public static void exposeGameSetup(Store store) {
        store.addItem(new Item("Sword", 10.00));
        store.addItem(new Item("Health Potion", 5.00));
        store.addItem(new Item("Hat", 1.00));
        store.addItem(new Item("Armor", 20.00));
        store.addItem(new Item("Apple", 5.00));
        store.addItem(new Item("Water", 2.00));
        store.addItem(new Item("Axe", 15.00));
        store.addItem(new Item("Shirt", 5.00));
        store.addItem(new Item("Pants", 2.00));
        store.addItem(new Item("Corn", 2.00));
        store.addItem(new Item("Helm", 15.00));
        store.addItem(new Item("Invisible Cloak", 50.00));
        System.out.println("Game setup completed.");
    }

    public static void exposeGamePlay(Store store, Player player, Scanner scanner) {
        while (true) {
            System.out.println("\nEnter a command (1 to enter the store, 4 to exit):");
            String input = scanner.nextLine();

            if (input.equals("1")) {
                store.enter(player);
                storeMenu(scanner, store, player);
                store.exit(player);
            } else if (input.equals("4")) {
                System.out.println("Exiting the program...");
                break;
            } else {
                System.out.println("Invalid command!");
            }
        }
    }

    public static void exposeGameStop() {
        System.out.println("Game stopped.");
    }

    public static void storeMenu(Scanner scanner, Store store, Player player) {
        while (true) {
            System.out.println("\nStore Menu:");
            System.out.println("1. Buy an item");
            System.out.println("2. Sell an item");
            System.out.println("3. Display inventory");
            System.out.println("4. Exit store");

            String input = scanner.nextLine();

            if (input.equals("1")) {
                buyItemFromStore(scanner, store, player);
            } else if (input.equals("2")) {
                sellItemToStore(scanner, store, player);
            } else if (input.equals("3")) {
                store.displayInventory();
            } else if (input.equals("4")) {
                System.out.println("Exiting the store...");
                store.exit(player);
                break;
            } else {
                System.out.println("Invalid command!");
            }
        }
    }

    public static void buyItemFromStore(Scanner scanner, Store store, Player player) {
        if (!store.checkPlayerInStore(player)) {
            System.out.println("You need to be in the store to buy items.");
            return;
        }

        store.displayInventory();
        System.out.print("Enter the name of the item you want to buy: ");
        String itemName = scanner.nextLine().trim();
        Item item = store.getItemByName(itemName);

        if (item != null) {
            if (store.buyItem(item, player)) {
                System.out.println("Item purchased successfully!");
            } else {
                System.out.println("Could not purchase the item from the store.");
            }
        } else {
            System.out.println("Item not available in the store.");
        }
    }

    public static void sellItemToStore(Scanner scanner, Store store, Player player) {
        if (!store.checkPlayerInStore(player)) {
            System.out.println("You need to be in the store to sell items.");
            return;
        }

        player.displayInventory();
        System.out.print("Enter the name of the item you want to sell: ");
        String itemName = scanner.nextLine().trim();
        Item item = player.getItemByName(itemName);

        if (item != null) {
            if (store.sellItem(item, player)) {
                System.out.println("Item sold successfully!");
            } else {
                System.out.println("Could not sell the item to the store.");
            }
        } else {
            System.out.println("Item not found in your inventory.");
        }
    }
}

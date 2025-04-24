import java.util.ArrayList;
import java.util.List;

public class Store {
    public final List<Item> inventory;
    private final List<Player> players_in_store;
    private Item escrowedItem;
    private Player currentPlayer;

    public Store() {
        inventory = new ArrayList<>();
        players_in_store = new ArrayList<>();
    }

    public void enter(Player player) {
        if (!checkPlayerInStore(player)) {
            players_in_store.add(player);
            currentPlayer = player;
        } else {
            System.out.println("Player is already in the store.");
        }
    }

    public void exit(Player player) {
        if (checkPlayerInStore(player)) {
            players_in_store.remove(player);
        } else {
            System.out.println("Player never entered the store.");
        }
    }

    public void addItem(Item item) {
        inventory.add(item);
    }

    public void displayInventory() {
        System.out.println("Store Inventory:");
        for (Item item : inventory) {
            System.out.println(item.getName() + " - $" + item.getPrice());
        }
    }

    public boolean checkPlayerInStore(Player player) {
        return players_in_store.contains(player);
    }

    public Item getItemByName(String name) {
        for (Item item : inventory) {
            if (item.getName().equalsIgnoreCase(name)) {
                return item;
            }
        }
        return null;
    }
    public void buyUsingEscrow() {
        if (escrowedItem != null) {
            inventory.remove(escrowedItem);
            escrowedItem = null;
        } else {
            System.out.println("No item in escrow for buying.");
        }
    }
    
    public void sellUsingEscrow() {
        if (escrowedItem != null) {
            inventory.add(escrowedItem);
            escrowedItem = null;
        } else {
            System.out.println("No item in escrow for selling.");
        }
    }

    public boolean buyItem(Item item, Player player) {
        if (!checkPlayerInStore(player)) {
            System.out.println("Player needs to enter the store before being able to buy anything");
            return false;
        }

        for (Item storeItem : inventory) {
            if (storeItem.getName().equalsIgnoreCase(item.getName())) {
                if (player.escrowItem(storeItem) && player.escrowMoney(storeItem.getPrice())) {
                    player.releaseEscrowedItem();
                    player.addItem(storeItem);
                    inventory.remove(storeItem);
                    return true;
                } else {
                    System.out.println("Item or money already in escrow.");
                    return false;
                }
            }
        }
        System.out.println("Item not available in the store.");
        return false;
    }

    public boolean sellItem(Item item, Player player) {
        if (!checkPlayerInStore(player)) {
            System.out.println("Player needs to enter the store before being able to sell anything");
            return false;
        }

        if (player.hasItem(item.getName())) {
            player.removeMoney(item.getPrice());
            player.relinquishItem(item);
            addItem(item);
            return true;
        } else {
            System.out.println("Item not found in the player's inventory!");
            return false;
        }
    }

    public void customerBuyUsingEscrow(Item item, Player player) {
        if (escrowedItem != null && escrowedItem.equals(item)) {
            inventory.remove(item);
            player.releaseEscrowedItem(); 
            escrowedItem = null;
        } else {
            System.out.println("Item in escrow does not match the item being purchased.");
        }
    }

    public void customerSellUsingEscrow(Item item, Player player) {
        if (escrowedItem != null) {
            player.escrowItem(item);
            inventory.add(item);
            escrowedItem = null;
        } else {
            System.out.println("No item in escrow for selling.");
        }
    }

    public void finalizeTransction(Player player){
        if (escrowedItem != null){
            player.releaseEscrowedItem();
            escrowedItem = null;
        }
    }

    public Item getEscrowedItem() {
        return escrowedItem;
    }
    

}

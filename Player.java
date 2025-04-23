
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;


public class Player {
    private double money;
    private final List<Item> inventory;
    private final List<Item> bag;
    private Item escrowedItem;
    private double escrowedMoney;

    public Player(double money) {
        this.money = money;
        this.inventory = new ArrayList<>();
        this.bag = new ArrayList<>();
        this.escrowedItem = null;
        this.escrowedMoney = 0;
    }

    public double getMoney() {
        return money;
    }

    public void addMoney(double amount) {
        money = money + amount;
    }

    public boolean removeMoney(double amount) {
        if (money >= amount) {
            money = money - amount;
            return true;
        } else {
            System.out.println("Not enough money to perform this action.");
            return false;
        }
    }

    public void addItem(Item item) {
        acquireItem(item);
    }

    public boolean hasItem(String itemName) {
        for (Item item : inventory) {
            if (item.getName().equalsIgnoreCase(itemName)) {
                return true;
            }
        }
        return false;
    }

    public void acquireItem(Item item) {
        inventory.add(item);
    }

    public void relinquishItem(Item item) {
        inventory.remove(item);
    }

    public void spendMoney(double amount) {
        money = money - amount;
    }

    public void enter(Store store) {
        store.enter(this);
    }

    public void exit(Store store) {
        store.exit(this);
    }

    public boolean buy(Item item, Store store) {
        if (!store.checkPlayerInStore(this)) {
            System.out.println("Player needs to enter the store before being able to buy anything");
            return false;
        }

        if (escrowItem(item) && escrowMoney(item.getPrice())) {
            if (getMoney() >= item.getPrice()) {
                removeMoney(item.getPrice());
                addItem(item);
                return true;
            } else {
                System.out.println("Not enough money to buy the item.");
                return false;
            }
        }
        return false;
    }

    public void wear(Item item) {
        if (inventory.contains(item)) {
            System.out.println("Wearing " + item.getName());
        } else {
            System.out.println("Item not found in the player's inventory.");
        }
    }

    public void hold(Item item) {
        if (inventory.contains(item)) {
            System.out.println("Holding " + item.getName());
        } else {
            System.out.println("Item not found in the player's inventory.");
        }
    }

    public void equip(Item item) {
        if (inventory.contains(item)) {
            System.out.println(item.getName() + " is equipped");
        } else {
            System.out.println("Item not found in the player's inventory.");
        }
    }

    public void eat(Item item) {
        if (inventory.contains(item)) {
            System.out.println("Eating " + item.getName());
        } else {
            System.out.println("Item not found in the player's inventory.");
        }
    }

    public void drink(Item item) {
        if (inventory.contains(item)) {
            System.out.println("Drinking " + item.getName());
        } else {
            System.out.println("Item not found in the player's inventory.");
        }
    }

    public void consume(Item item) {
        if (inventory.contains(item)) {
            System.out.println("Consuming " + item.getName());
        } else {
            System.out.println("Item not found in the player's inventory.");
        }
    }

    public void displayInventory() {
        System.out.println("Player Inventory:");
        for (Item item : inventory) {
            System.out.println(item.getName() + " - $" + item.getPrice());
        }
    }

    public Collection<Item> exposeInventory() {
        return inventory;
    }

    public Collection<Item> exposeWearInventory() {
        List<Item> wearInventory = new ArrayList<>();
        for (Item item : inventory) {
            if (ItemAttributes.isWearable(item)) {
                wearInventory.add(item);
            }
        }
        return wearInventory;
    }

    public Collection<Item> exposeHoldInventory() {
        List<Item> holdInventory = new ArrayList<>();
        for (Item item : inventory) {
            if (ItemAttributes.isHoldable(item)) {
                holdInventory.add(item);
            }
        }
        return holdInventory;
    }

    public Collection<Item> exposeEatInventory() {
        List<Item> eatInventory = new ArrayList<>();
        for (Item item : inventory) {
            if (ItemAttributes.isEdible(item)) {
                eatInventory.add(item);
            }
        }
        return eatInventory;
    }

    public Collection<Item> exposeDrinkInventory() {
        List<Item> drinkInventory = new ArrayList<>();
        for (Item item : inventory) {
            if (ItemAttributes.isDrinkable(item)) {
                drinkInventory.add(item);
            }
        }
        return drinkInventory;
    }

    public Collection<Item> exposeConsumeInventory() {
        List<Item> consumeInventory = new ArrayList<>();
        for (Item item : inventory) {
            if (ItemAttributes.isConsumable(item)) {
                consumeInventory.add(item);
            }
        }
        return consumeInventory;
    }

    public Collection<Item> exposeEquipInventory() {
        List<Item> equipInventory = new ArrayList<>();
        for (Item item : inventory) {
            if (ItemAttributes.isEquipable(item)) {
                equipInventory.add(item);
            }
        }
        return equipInventory;
    }

    public Item getItemByName(String name) {
        for (Item item : inventory) {
            if (item.getName().equalsIgnoreCase(name)) {
                return item;
            }
        }
        return null;
    }

    public void useItem(Item item) {
        String itemName = item.getName();

        if (ItemAttributes.isWearable(item)) {
            wear(item);
        } else if (ItemAttributes.isHoldable(item)) {
            hold(item);
        } else if (ItemAttributes.isEdible(item)) {
            eat(item);
        } else if (ItemAttributes.isDrinkable(item)) {
            drink(item);
        } else {
            System.out.println("Item type not recognized: " + itemName);
        }
    }

    private boolean canAddToBag(Item item) {
        double totalBagPrice = 0;
        for (Item bagItem : bag) {
            totalBagPrice = totalBagPrice + bagItem.getPrice();
        }
        return totalBagPrice + item.getPrice() <= Double.POSITIVE_INFINITY;
    }

    public void addToBag(Item item) {
        if (canAddToBag(item)) {
            bag.add(item);
        } else {
            System.out.println("Bag is full or item is too expensive to add.");
        }
    }

    public void removeFromBag(Item item) {
        if (bag.contains(item)) {
            bag.remove(item);
        } else {
            System.out.println("Item not found in bag.");
        }
    }

    public void displayBagInventory() {
        System.out.println("Player's Bag Inventory:");
        for (Item item : bag) {
            System.out.println(item.getName() + " - $" + item.getPrice());
        }
    }

    public boolean escrowItem(Item item) {
        if (item != null) {
            escrowedItem = item;
            return true;
        } else {
            System.out.println("Cannot escrow a null item.");
            return false;
        }
    }

    public Item getEscrowedItem() {
        return escrowedItem;
    }

    

    public boolean escrowMoney(double amount) {
        if (money >= amount) {
            escrowedMoney = amount;
            return true;
        } else {
            System.out.println("Not enough money to perform this action.");
            return false;
        }
    }

    public void releaseEscrowedMoney() {
        money += escrowedMoney;
        escrowedMoney = 0;
    }

    public void releaseEscrowedItem() {
        if (escrowedItem != null) {
            addItem(escrowedItem);
            escrowedItem = null;
        }
    }

    public void exposeCommonMethodConsume(Item item) {
        consume(item);
    }

    public void exposeCommonMethodEquip(Item item) {
        equip(item);
    }

    public void exposeCommonMethodUse(Item item) {
        useItem(item);
    }
}
    
    


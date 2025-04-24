
public class ItemAttributes {

    public static boolean isWearable(Item item) {
        String itemName = item.getName();
        return itemName.contains("Armor") ||  itemName.contains("Hat") ||itemName.contains("Shirt")
        || itemName.contains("Pants") || itemName.contains("Helm") || itemName.contains("Invisible Cloak");
    }

    public static boolean isHoldable(Item item) {
        String itemName = item.getName();
        return itemName.contains("Sword") || itemName.contains("Axe")|| itemName.contains("Corn")
        || itemName.contains("Apple")|| itemName.contains("Health Potion");
    }

    public static boolean isEdible(Item item) {
        String itemName = item.getName();
        return itemName.contains("Apple") || itemName.contains("Corn"); 
    }

    public static boolean isDrinkable(Item item) {
        String itemName = item.getName();
        return itemName.contains("Potion") || itemName.contains("Water");
    }

    public static boolean isConsumable(Item item) {
        String itemName = item.getName();
        return itemName.contains("Potion") || itemName.contains("Water") 
        ||itemName.contains("Apple") || itemName.contains("Corn"); 
    }

    public static boolean isEquipable(Item item) {
        String itemName = item.getName();
        return itemName.contains("Sword") || itemName.contains("Axe") || itemName.contains("Armor") 
        ||  itemName.contains("Hat") ||itemName.contains("Shirt")  || itemName.contains("Pants") 
        || itemName.contains("Helm") || itemName.contains("Invisible Cloak"); 
    }
}

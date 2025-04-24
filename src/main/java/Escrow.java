
public class Escrow {

    private static Item escrowedItem;
    private static double escrowedMoney;

    public static void escrowItem(Item item) {
        escrowedItem = item;
    }

    public static Item getEscrowedItem() {
        return escrowedItem;
    }

    public static void escrowMoney(double amount) {
        escrowedMoney = amount;
    }

    public static double getEscrowedMoney() {
        return escrowedMoney;
    }

    public static void returnMoneyToPlayer(Player player) {
        player.addMoney(escrowedMoney);
        escrowedMoney = 0;
    }

    public static void returnItemToPlayer(Player player) {
        if (escrowedItem != null) {
            player.addItem(escrowedItem);
            escrowedItem = null;
        }
    }
}

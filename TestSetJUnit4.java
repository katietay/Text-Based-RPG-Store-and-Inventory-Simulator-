import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;

import static org.junit.Assert.*;

@RunWith(JUnit4.class)
public class TestSetJUnit4 {

    static Store store;
    static Player player;
    static Item item0;
    static Item item1;
    static Item item2;

    @Before
    public void setup() {
        store = new Store();

        item0 = new Item("test0", 1.0);
        item1 = new Item("test1", 1.0);
        item2 = new Item("test2", 1.0);

        player = new Player(100.0);

        store.addItem(item0);
        store.addItem(item1);
        store.addItem(item2);
    }

    @Test
    public void testAcquire() {
        store.enter(player);
        store.buyItem(item0, player);
        store.buyItem(item1, player);
        store.buyItem(item2, player);

        assertSame(item0, player.getItemByName("test0"));
        assertSame(item1, player.getItemByName("test1"));
        assertSame(item2, player.getItemByName("test2"));
    }

    @Test
    public void testPlayerCanSell() {
        Item playerItem = new Item("player_item", 1.0);
        player.acquireItem(playerItem);
        assertSame(playerItem, player.getItemByName("player_item"));

        store.enter(player);
        assertTrue(store.sellItem(playerItem, player));
        assertNull(player.getItemByName("player_item"));
    }

    @Test
    public void testPlayerMoneyTransaction() {
        double initialMoney = player.getMoney();
        player.addMoney(50);
        assertEquals(initialMoney + 50, player.getMoney(), 0);

        assertTrue(player.removeMoney(30));
        assertEquals(initialMoney + 20, player.getMoney(), 0);

        assertFalse(player.removeMoney(1000));
        assertEquals(initialMoney + 20, player.getMoney(), 0);
    }

    @Test
    public void testPlayerInventory() {
        player.acquireItem(item0);
        player.acquireItem(item1);

        assertTrue(player.hasItem("test0"));
        assertFalse(player.hasItem("test2"));

        player.relinquishItem(item0);
        assertFalse(player.hasItem("test0"));

        player.addItem(item2);
        assertTrue(player.hasItem("test2"));
    }

    @Test
    public void testStoreEnterExit() {
        Store store = new Store();
        assertFalse(store.checkPlayerInStore(player));

        store.enter(player);
        assertTrue(store.checkPlayerInStore(player));

        store.exit(player);
        assertFalse(store.checkPlayerInStore(player));
    }

    @Test
    public void testStoreBuySellItems() {
        Store store = new Store();
        store.addItem(item0);
        store.addItem(item1);

        store.enter(player);
        assertTrue(store.buyItem(item0, player));
        assertTrue(store.sellItem(item0, player));

        assertFalse(store.buyItem(item2, player));
        assertFalse(store.sellItem(item2, player));
    }

    @Test
    public void testStoreEscrowMethods() {
        Store store = new Store();
        store.enter(player);

        store.buyItem(item0, player);
        store.buyUsingEscrow();
        assertNull(store.getEscrowedItem());

        store.sellItem(item1, player);
        store.sellUsingEscrow();
        assertNull(store.getEscrowedItem());
    }

    private void assertSame(Item expected, Item actual) {
        assertEquals(expected, actual);
    }

    private void assertNull(Item actual) {
        assertEquals(null, actual);
    }

    private void assertTrue(boolean actual) {
        assertEquals(true, actual);
    }

    private void assertFalse(boolean actual) {
        assertEquals(false, actual);
    }

    private void assertEquals(double expected, double actual, double delta) {
        org.junit.Assert.assertEquals(expected, actual, delta);
    }
}

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

class Product {
    private String name;
    private int quantity;
    private double price;

    public Product(String name, int quantity, double price) {
        this.name = name;
        this.quantity = quantity;
        this.price = price;
    }

    public String getName() {
        return name;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return String.format("%s: price [%.2f], quantity [%d]", name, price, quantity);
    }

    // Comparator for sorting by quantity
    public static final Comparator<Product> sortByQuantityAsc = Comparator.comparingInt(Product::getQuantity);

    public static final Comparator<Product> sortByQuantityDesc = Comparator.comparingInt(Product::getQuantity).reversed();

    // Comparator for sorting by price
    public static final Comparator<Product> sortByPriceAsc = Comparator.comparingDouble(Product::getPrice);

    public static final Comparator<Product> sortByPriceDesc = Comparator.comparingDouble(Product::getPrice).reversed();
}

class ProductManager {
    private List<Product> products;

    public ProductManager() {
        products = new ArrayList<>();
    }

    public void addProduct(Product product) {
        products.add(product);
    }

    // 1. Calculate the total value of the inventory (quantity x price)
    public double calculateTotalInventoryValue() {
        double totalValue = 0;
        for (Product product : products) {
            totalValue += product.getPrice() * product.getQuantity();
        }
        return totalValue;
    }

    // 2. Find the most expensive product (the highest price)
    public Product findMostExpensiveProduct() {
        if (products.isEmpty()) return null;
        return Collections.max(products, Comparator.comparingDouble(Product::getPrice));
    }

    // 3. Check if product with the specific name is in stock
    public boolean isProductInStock(String productName) {
        for (Product product : products) {
            if (product.getName().equalsIgnoreCase(productName) && product.getQuantity() > 0) {
                return true;
            }
        }
        return false;
    }

    // 4. Sort products with pre-defined comparators
    public void sortByQuantity(boolean ascending) {
        products.sort(ascending ? Product.sortByQuantityAsc : Product.sortByQuantityDesc);
    }

    public void sortByPrice(boolean ascending) {
        products.sort(ascending ? Product.sortByPriceAsc : Product.sortByPriceDesc);
    }

    public void displayProducts() {
        for (Product product : products) {
            System.out.println(product);
        }
    }
}

public class Main {
    public static void main(String[] args) {
        ProductManager manager = new ProductManager();

        // Add mock products to the store manager
        manager.addProduct(new Product("Laptop", 5, 999.99));
        manager.addProduct(new Product("Smartphone", 10, 499.99));
        manager.addProduct(new Product("Tablet", 0, 299.99));
        manager.addProduct(new Product("Smartwatch", 3, 199.99));

        // Display all products
        System.out.println("------------ Store Manager ------------");
        System.out.println("Product list: \n");
        manager.displayProducts();
        System.out.println("---------------------------------------");

        // Display total inventory value
        System.out.println(String.format("Total Inventory Value: %.2f", manager.calculateTotalInventoryValue()));

        // Find the most expensive product
        Product expensiveProduct = manager.findMostExpensiveProduct();
        System.out.println("Most Expensive Product: " + expensiveProduct.getName());

        // Check if "Headphones" are in stock
        System.out.println("Are Headphones in Stock? " + manager.isProductInStock("Headphones"));

        // Sort by quantity ascending and display
        System.out.println("\nProducts sorted by quantity (ascending):");
        manager.sortByQuantity(true);
        manager.displayProducts();

        // Sort by price descending and display
        System.out.println("\nProducts sorted by price (descending):");
        manager.sortByPrice(false);
        manager.displayProducts();
    }
}

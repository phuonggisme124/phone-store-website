/*
 * The Variants class represents a specific variant of a product.
 * Example: iPhone 15 - Red - 128GB
 */
package model;

public class Variants {

    //=================== FIELDS / ATTRIBUTES ===================//
    private int variantID;        // Variant ID (primary key)
    private int productID;        // Product ID (FK referencing Product)
    private String color;         // Color of the variant
    private int stock;            // Available stock quantity
    private double price;         // Original price of the variant
    private Double discountPrice; // Discounted price (nullable if no discount)
    private String storage;       // Storage / size / version
    private String description;   // Detailed description of the variant
    private String imageUrl;      // URL to the representative image

    //=================== CONSTRUCTORS ===================//
    // No-argument constructor
    public Variants() {
    }

    // Full-argument constructor
    public Variants(int variantID, int productID, String color, String storage,
            double price, Double discountPrice, int stock,
            String description, String imageUrl) {
        this.variantID = variantID;
        this.productID = productID;
        this.color = color;
        this.stock = stock;
        this.price = price;
        this.discountPrice = discountPrice;
        this.storage = storage;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    //=================== GETTERS & SETTERS ===================//
    public int getVariantID() {
        return variantID;
    }

    public void setVariantID(int variantID) {
        this.variantID = variantID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Double getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(Double discountPrice) {
        this.discountPrice = discountPrice;
    }

    public String getStorage() {
        return storage;
    }

    public void setStorage(String storage) {
        this.storage = storage;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    //=================== toString ===================//
    @Override
    public String toString() {
        return "Variants{"
                + "variantID=" + variantID
                + ", productID=" + productID
                + ", color='" + color + '\''
                + ", stock=" + stock
                + ", price=" + price
                + ", discountPrice=" + discountPrice
                + ", storage='" + storage + '\''
                + ", description='" + description + '\''
                + ", imageUrl='" + imageUrl + '\''
                + '}';
    }
}

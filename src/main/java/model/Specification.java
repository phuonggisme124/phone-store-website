/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author duynu
 */
public class Specification {

    private int specificationID;
    private int productID;
    private String os;
    private String cpu;
    private String gpu;
    private String ram;
    private int batteryCapacity;
    private String touchscreen;

    public Specification(int specificationID, int productID, String os, String cpu, String gpu, String ram, int batteryCapacity, String touchscreen) {
        this.specificationID = specificationID;
        this.productID = productID;
        this.os = os;
        this.cpu = cpu;
        this.gpu = gpu;
        this.ram = ram;
        this.batteryCapacity = batteryCapacity;
        this.touchscreen = touchscreen;
    }

    public int getSpecificationID() {
        return specificationID;
    }

    public void setSpecificationID(int specificationID) {
        this.specificationID = specificationID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getOs() {
        return os;
    }

    public void setOs(String os) {
        this.os = os;
    }

    public String getCpu() {
        return cpu;
    }

    public void setCpu(String cpu) {
        this.cpu = cpu;
    }

    public String getGpu() {
        return gpu;
    }

    public void setGpu(String gpu) {
        this.gpu = gpu;
    }

    public String getRam() {
        return ram;
    }

    public void setRam(String ram) {
        this.ram = ram;
    }

    public int getBatteryCapacity() {
        return batteryCapacity;
    }

    public void setBatteryCapacity(int batteryCapacity) {
        this.batteryCapacity = batteryCapacity;
    }

    public String getTouchscreen() {
        return touchscreen;
    }

    public void setTouchscreen(String touchscreen) {
        this.touchscreen = touchscreen;
    }

    
}

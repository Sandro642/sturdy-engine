package fr.sandro642.github;

public class ConsoleDisplay {
    public static void displayThreadStatus(int threadNumber, String status) {
        System.out.println("Thread: " + threadNumber + " - Status: " + status);
    }

    public static void displayMessage(int threadNumber, String message) {
        System.out.println("Thread: " + threadNumber + " - " + message);
    }
}
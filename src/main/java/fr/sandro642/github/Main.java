package fr.sandro642.github;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter GitHub token: ");
        String token = scanner.nextLine();

        System.out.print("Enter number of contributions: ");
        int contributions = scanner.nextInt();

        System.out.print("Enter number of threads: ");
        int threads = scanner.nextInt();

        System.out.print("Do you want to display thread consoles? (yes/no): ");
        boolean displayConsoles = scanner.next().equalsIgnoreCase("yes");

        ThreadManager threadManager = new ThreadManager(token, contributions, threads, displayConsoles);
        threadManager.start();
    }
}
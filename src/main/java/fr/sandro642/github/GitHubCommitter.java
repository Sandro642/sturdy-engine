package fr.sandro642.github;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class GitHubCommitter implements Runnable {
    private final int threadNumber;
    private final int contributions;
    private final boolean displayConsole;

    public GitHubCommitter(int threadNumber, int contributions, boolean displayConsole) {
        this.threadNumber = threadNumber;
        this.contributions = contributions;
        this.displayConsole = displayConsole;
    }

    @Override
    public void run() {
        try {
            File file = new File("contributions/thread" + threadNumber + ".txt");
            file.getParentFile().mkdirs();
            file.createNewFile();

            for (int i = 0; i < contributions; i++) {
                try (FileWriter writer = new FileWriter(file, true)) {
                    writer.write("a");
                }
                ConsoleDisplay.displayMessage(threadNumber, "Commit created");
                // Simulate commit and push
                ConsoleDisplay.displayMessage(threadNumber, "Pushed commit");
                if (displayConsole) {
                    System.out.println("Thread: " + threadNumber + " - Contribution: " + (i + 1));
                }
                // Simulate removing character and pushing
                try (FileWriter writer = new FileWriter(file)) {
                    writer.write("");
                }
                ConsoleDisplay.displayMessage(threadNumber, "Commit removed and pushed");
            }

            file.delete();
            ConsoleDisplay.displayMessage(threadNumber, "File deleted");
            if (displayConsole) {
                System.out.println("Thread: " + threadNumber + " - Completed");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
package fr.sandro642.github;

import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.errors.GitAPIException;
import org.eclipse.jgit.transport.UsernamePasswordCredentialsProvider;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class GitHubCommitter implements Runnable {
    private final int threadNumber;
    private final int contributions;
    private final boolean displayConsole;
    private final String token;

    public GitHubCommitter(int threadNumber, int contributions, boolean displayConsole, String token) {
        this.threadNumber = threadNumber;
        this.contributions = contributions;
        this.displayConsole = displayConsole;
        this.token = token;
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
                commitAndPush(file);
                ConsoleDisplay.displayMessage(threadNumber, "Commit created and pushed");
                if (displayConsole) {
                    System.out.println("Thread: " + threadNumber + " - Contribution: " + (i + 1));
                }
                try (FileWriter writer = new FileWriter(file)) {
                    writer.write("");
                }
                commitAndPush(file);
                ConsoleDisplay.displayMessage(threadNumber, "Commit removed and pushed");
            }

            file.delete();
            ConsoleDisplay.displayMessage(threadNumber, "File deleted");
            if (displayConsole) {
                System.out.println("Thread: " + threadNumber + " - Completed");
            }
        } catch (IOException | GitAPIException e) {
            e.printStackTrace();
        }
    }

    private void commitAndPush(File file) throws GitAPIException {
        try (Git git = Git.open(new File("."))) {
            git.add().addFilepattern(file.getPath()).call();
            git.commit().setMessage("Contribution from thread " + threadNumber).call();
            git.push()
                    .setCredentialsProvider(new UsernamePasswordCredentialsProvider(token, ""))
                    .call();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
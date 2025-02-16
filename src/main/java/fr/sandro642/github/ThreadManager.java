package fr.sandro642.github;

import reactor.core.scheduler.Schedulers;
import reactor.core.publisher.Flux;

public class ThreadManager {
    private final String token;
    private final int contributions;
    private final int threads;
    private final boolean displayConsoles;

    public ThreadManager(String token, int contributions, int threads, boolean displayConsoles) {
        this.token = token;
        this.contributions = contributions;
        this.threads = threads;
        this.displayConsoles = displayConsoles;
    }

    public void start() {
        int contributionsPerThread = contributions / threads;

        Flux.range(1, threads)
                .parallel(threads)
                .runOn(Schedulers.boundedElastic())
                .doOnNext(threadNumber -> {
                    GitHubCommitter committer = new GitHubCommitter(threadNumber, contributionsPerThread, displayConsoles);
                    committer.run();
                })
                .sequential()
                .blockLast();
    }
}
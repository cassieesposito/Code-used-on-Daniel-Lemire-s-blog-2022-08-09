I had some concerns about the methodology used in [this blog post by Daniel Lemire](https://lemire.me/blog/2022/08/09/hello-world-is-slower-in-c-than-in-c-linux/), and so I made some changes.

My concerns, as I wrote them in an as-of-yet-not-approved comment on the post:
>I have a concern about your conclusion here -- not that it's necessarily wrong, but that this test is incomplete. Specifically, this test does nothing to differentiate between execution time and function call time.

>If we're looking at 1 ms overhead every time you print to console, I'll grant that's significant. But if we're looking at 1 ms per execution? I can't rightfully agree with your conclusion that this is significant. Yes, granted, we're talking about a 200% increase in the execution time for Hello World, but in 2022, I cannot think of a real-world situation where anyone would be executing hello-world equivalent software with such frequency that it creates a cpu bottleneck. Not even in the embedded space.

>I haven't tested it yet (I might), but my guess is the performance difference you're seeing takes place in loading the module, and if you were to print to console 10,000 or 100,000 times per execution, you'd still be looking at about a 1 ms difference per execution. I'm basing this guess on the fact that we're seeing such a significant performance increase in the statically linked c++ version and the knowledge that in a Linux environment, there's some decent chance that stdio.h is preloaded in memory while iostream is not.

>Obviously, my hunches are not data, and more testing is required before we draw any conclusions here.

>The other question I have is whether you're running hyperfine with the -N flag. Without it, on processes this short, it's kicking the following warning at me:

>Warning: Command took less than 5 ms to complete. Note that the results might be inaccurate because hyperfine can not calibrate the shell startup time much more precise than this limit. You can try to use the `-N`/`--shell=none` option to disable the shell completely.

>Which seems potentially relevant.

>I might be back later with followup results.

Obviously, I'm now back with results. I was surprised. I have since seen some critique of this blog post that suggest the difference may specifically be between the stdio.h and iostream APIs specifically, rather than anything to do with the language as a whole and that [c++ has some alternative IO apis](https://github.com/fmtlib/fmt#speed-tests) that may run faster than stdio.h.

The Results:
```cc -O2 -o helloc hello.c -Wall
c++ -O2 -o hellocpp hello.cpp -Wall
c++ -O2 -o hellocppstatic hello.cpp -Wall -static-libstdc++
c++ -O2 -o hellocppfullstatic hello.cpp -Wall -static-libstdc++ -static-libgcc
cc -O2 -o multi_helloc multi_hello.c -Wall
c++ -O2 -o multi_hellocpp multi_hello.cpp -Wall
c++ -O2 -o multi_hellocppstatic multi_hello.cpp -Wall -static-libstdc++
c++ -O2 -o multi_hellocppfullstatic multi_hello.cpp -Wall -static-libstdc++ -static-libgcc
hyperfine -N --runs 5000 ./helloc
Benchmark 1: ./helloc
  Time (mean ± σ):       0.3 ms ±   0.1 ms    [User: 0.3 ms, System: 0.0 ms]
  Range (min … max):     0.2 ms …   1.7 ms    5000 runs
 
  Warning: The first benchmarking run for this command was significantly slower than the rest (0.5 ms). This could be caused by (filesystem) caches that were not filled until after the first run. You should consider using the '--warmup' option to fill those caches before the actual benchmark. Alternatively, use the '--prepare' option to clear the caches before each timing run.
 
hyperfine -N --runs 5000 ./hellocpp
Benchmark 1: ./hellocpp
  Time (mean ± σ):       1.0 ms ±   0.0 ms    [User: 0.8 ms, System: 0.1 ms]
  Range (min … max):     0.9 ms …   2.2 ms    5000 runs
 
  Warning: The first benchmarking run for this command was significantly slower than the rest (1.2 ms). This could be caused by (filesystem) caches that were not filled until after the first run. You should consider using the '--warmup' option to fill those caches before the actual benchmark. Alternatively, use the '--prepare' option to clear the caches before each timing run.
 
hyperfine -N --runs 5000 ./hellocppstatic
Benchmark 1: ./hellocppstatic
  Time (mean ± σ):       0.5 ms ±   0.0 ms    [User: 0.4 ms, System: 0.0 ms]
  Range (min … max):     0.5 ms …   2.1 ms    5000 runs
 
  Warning: The first benchmarking run for this command was significantly slower than the rest (0.6 ms). This could be caused by (filesystem) caches that were not filled until after the first run. You should consider using the '--warmup' option to fill those caches before the actual benchmark. Alternatively, use the '--prepare' option to clear the caches before each timing run.
 
hyperfine -N --runs 5000 ./hellocppfullstatic
Benchmark 1: ./hellocppfullstatic
  Time (mean ± σ):       0.4 ms ±   0.0 ms    [User: 0.4 ms, System: 0.0 ms]
  Range (min … max):     0.4 ms …   0.8 ms    5000 runs
 
  Warning: The first benchmarking run for this command was significantly slower than the rest (0.6 ms). This could be caused by (filesystem) caches that were not filled until after the first run. You should consider using the '--warmup' option to fill those caches before the actual benchmark. Alternatively, use the '--prepare' option to clear the caches before each timing run.
 
hyperfine -N --runs 5000 ./multi_helloc
Benchmark 1: ./multi_helloc
  Time (mean ± σ):       1.0 ms ±   0.0 ms    [User: 0.9 ms, System: 0.1 ms]
  Range (min … max):     1.0 ms …   2.3 ms    5000 runs
 
  Warning: The first benchmarking run for this command was significantly slower than the rest (1.1 ms). This could be caused by (filesystem) caches that were not filled until after the first run. You should consider using the '--warmup' option to fill those caches before the actual benchmark. Alternatively, use the '--prepare' option to clear the caches before each timing run.
 
hyperfine -N --runs 5000 ./multi_hellocpp
Benchmark 1: ./multi_hellocpp
  Time (mean ± σ):      11.0 ms ±   0.6 ms    [User: 5.3 ms, System: 5.6 ms]
  Range (min … max):     5.7 ms …  13.5 ms    5000 runs
 
  Warning: Statistical outliers were detected. Consider re-running this benchmark on a quiet PC without any interferences from other programs. It might help to use the '--warmup' or '--prepare' options.
 
hyperfine -N --runs 5000 ./multi_hellocppstatic
Benchmark 1: ./multi_hellocppstatic
  Time (mean ± σ):      10.1 ms ±   0.2 ms    [User: 4.5 ms, System: 5.5 ms]
  Range (min … max):     9.6 ms …  12.4 ms    5000 runs
 
hyperfine -N --runs 5000 ./multi_hellocppfullstatic
Benchmark 1: ./multi_hellocppfullstatic
  Time (mean ± σ):      10.0 ms ±   0.2 ms    [User: 4.5 ms, System: 5.5 ms]
  Range (min … max):     9.5 ms …  11.3 ms    5000 runs
```

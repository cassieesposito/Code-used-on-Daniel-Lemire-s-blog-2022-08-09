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
{{RESULTS.md}}

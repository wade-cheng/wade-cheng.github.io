#import "../../../templates/blog_post.typ": conf

#show: conf.with(
  page-title: "compile-typst-site: optimizing compile times",
  date: "2025-11-26",
)

#smallcaps[This blog] is generated with Typst using #link("https://wade-cheng.com/compile-typst-site/")[`compile-typst-site`]. It's written in Rust.

Programming language culture is an interesting thing: while there's nothing technically forcing the average Python code to be duck typed and the average Rust code to prefer invariants via typing, this happens anyways. CLIs, like `cts`, and the simple case study of parsing command-line arguments gives some good examples. In Python, I might default to using stdlib's `argparse` and grab the arguments by getter properties: `if cli.verbose: foo()`---less explicit stuff going on. But in Rust, and in all the tutorial information around CLI building, we seem to prefer using proc-macros to generate code that validates the args into a CLI struct. Something something different philosophies of the average case. I'm sure there's derive validators in python, and you can forgo derive in Rust.

But. One pet peeve I have about Rust, coming from interpreted languages like Python and simpler codebases from coursework, is the relatively long compile time compared to these prior experiences. In the more obnoxious cases, this even bleeds over `cargo check` efficiency, making the Rust LSP less effective.#footnote[Subframe LSP responses are great for coding. Stuff like bevy projects or #link("https://graphite.rs/") contributions can get a little absurd, again, relative to what I'm used to. Mumble mumble metaprogramming is cool but dangerous.] Now, this isn't happening by any means to `cts`, and there are tradeoffs to consider instead of wanton compile-time optimization: massive, slow, libraries are such because they're so feature-filled. It might be strictly easier for me and better for the users to use one library, except for compile times. So let's see what I managed to cull down.

= Part 1: the entire damn web framework ecosystem

Some while back, I dusted off the final major feature that I wanted to implement: an automatic-browser-refreshing web server to serve output files.#footnote[See the diff at #link("https://github.com/wade-cheng/compile-typst-site/compare/1c515eef155e35447a2ffea4a52d7d75d637ef90...3354854acadbc7c8d5b81a57ed3d60df84ea1dc6")[compile-typst-site/compare/1c515e...335485]. Less than two hundred lines of code, ignoring the lockfile.] The feature you know and love from Eleventy, Vite, Django, and other web frameworks galore---we can't _not_ have it :p

Manually reloading the page every time I hit save was getting old, so I took to Google, and threw together some code by newly depending on
- `tower-livereload` to implement web page reloading logic,
- `axum` to run a web server, and
- `tokio` to appease the async-colored code.

It was pretty cool! But compiling instantly became heavier. Rust lets you profile with the `--timings` build flag, so let's see how that looks:

#html.details[
  #html.summary[#link("./cargo-timing-all-deps.html")]
  #html.img(src: "./all-deps.png")
]

Yikes.

You can see a loooong chain of unparallelizable compilations from us implementing live reload by using, uh, an entire web ecosystem. Well, let's think. What exactly did these dependencies do, anyway? They spun up a web server and reloaded the page when Typst compilation finished.

If you aren't familiar, I refer you to the Rust Book for how a tutorial stepping through a #link("https://doc.rust-lang.org/book/ch21-00-final-project-a-web-server.html")[dead-simple web server]. Since `cts` just serves static assets, I can also just write one myself with manual TCP connections and HTTP messages, and it _probably_ won't be an issue.#footnote[Come #link("https://github.com/wade-cheng/compile-typst-site/issues")[holler] at me if it is.]

Now, how does reloading a web server work? I knew `tower-livereload` injected code, but a bit of further digging led to #link("https://emnudge.dev/notes/live-reload/"), which alongside the HTTP spec and the Rust Book web server tutorial, informed the basis of my implementation. As it turns out, we control the web server code, and the web server tells the browser what to render, so we can easily inject any (JavaScript) code we need to run on that front---just insert it right before responding to the client. Conceptually, that code just says "any time I get notified, reload the page." We wait for notifications via JavaScript's #link("https://developer.mozilla.org/en-US/docs/Web/API/EventSource")[`EventSource`], which opens a connection to a server and gets pinged every time that server sends a message back. The specific spec says something along the following: when a server receives a request from an `EventSource`, it should respond `OK` with the mime-type `text/event-stream`. I sent the rust byte string:

```
b"HTTP/1.1 200 OK\r\n\
  Content-Type: text/event-stream\r\n\
  Cache-Control: no-cache\r\n
  Connection: keep-alive\r\n\r\n"
```

Then, whenever the server wishes to send a message, it can just do so over the connection. There's more spec to follow, but I didn't need to bother with sending data or comments---just any message will do to prod the frontend code. So, when the server gets the signal from `cts` to reload the page, the server sends another byte string:#footnote[Spec says to write `data: <PAYLOAD>\\r\\n\\r\\n` to send data.]

```
b"data: reload\r\n\r\n"
```

I decided to make the API endpoint for this live reloading `/livereload`, so the injected JavaScript was like so:

```
<script>
    const source = new EventSource('/livereload');
    source.onmessage = () => {
        source.close(); 
        location.reload();
    }
    source.onerror = () => {
        source.close();
    };
    window.onbeforeunload = () => {
        source.close();
    };
</script>
```

We only ever really listen once before reloading the page cleans up the `EventSource` anyways. We run some cleanup code lest we get red in the browser console on reload.

= Part 2: serde (and syn)

So, what's our new starting point?

#html.details[
  #html.summary[#link("./cargo-timing-handwritten-http.html")]
  #html.img(src: "./handwritten-http.png")
]

Much better! Now, the low-hanging fruit is that `winnow`/`serde`/`syn` stuff we need to derive deserialization of a file into a struct. I had a little bit of boilerplate anyways, since I wanted to say "it's okay to leave these config entries blank," which led to some `unwrap_or_default`-ing, so I decided to jump the gun and just hack and slash it all out in favor of `nanoserde`. You'll notice that I already used `onlyargs`/`myn` as a light alternative to, say, `clap`. Their developer wrote a neat #link("https://blog.kodewerx.org/2023/04/improving-build-times-for-derive-macros.html")[blog post] on how one might strip features away from `syn` to get faster compile times. They cited `nanoserde` as having a similar underlying model, and indeed it's fast to compile. `nanoserde` is made by #link("https://github.com/not-fl3")[not-fl3] who, though now dormant, was super epic in the realm of short compile times. His \*quads ecosystem for game development felt like Python to use, compile times included.

Unfortunately, the TOML feature of nanoserde doesn't seem to have derive support, or I probably would've used it. Since it's probably fast anyways. Also, its spec compliance is a bit iffy: it at least doesn't support literal strings (single quotes). Hmm.

= Final product

Anyways, we're down to this relatively lean stack of dependencies:

#html.details[
  #html.summary[#link("./cargo-timing-nanoserde.html")]
  #html.img(src: "./nanoserde.png")
]

We can see that compiling `cts` more or less is just the length of compiling `notify-debouncer-full` now---everything else is parallelized. Maybe some time in the future, I'll be back with an update where I, in a fit of something or other, decide to rip even that out and write a file watcher from scratch to bring compile times down from two seconds to something like one. But for now, I think I'll leave this at that.
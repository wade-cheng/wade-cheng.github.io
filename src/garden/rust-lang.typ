#import "../../templates/garden_planter.typ": conf

#show: conf.with(
  page-title: "rust-lang",
)

I like Rust. I think it's a good programming language.

= Peeves

If you use a programming language and you aren't at all annoyed by it, something's either gone terribly wrong, or you're living in heaven on earth.

- Compile times. It's hard work to try to cull it down. Big props to Fedor and what he's done with the quads ecosystem. note nanoserde; damn is serde able to take up large compile times.

- partial borrows.

- see #link("https://smallcultfollowing.com/babysteps/")[babysteps]' series on ergonomic ref counting. 

  re-citing a post:
  #quote(block: true, attribution: [#link("https://dioxus.notion.site/Dioxus-Labs-High-level-Rust-5fe1f1c9c8334815ad488410d948f05e")[Dioxus blog post]])[
    ```
    // listen for dns connections
    let _some_a = self.some_a.clone();
    let _some_b = self.some_b.clone();
    let _some_c = self.some_c.clone();
    let _some_d = self.some_d.clone();
    let _some_e = self.some_e.clone();
    let _some_f = self.some_f.clone();
    let _some_g = self.some_g.clone();
    let _some_h = self.some_h.clone();
    let _some_i = self.some_i.clone();
    let _some_j = self.some_j.clone();
    tokio::task::spawn(async move {
        // do something with all the values
    });
    ```
    Working on this codebase was demoralizing. We could think of no better way to architect things---we needed listeners for basically everything that filtered their updates based on the state of the app. You could say “lol get gud,” but the engineers on this team were the sharpest people I've ever worked with. Cloudflare is all-in on Rust. They're willing to throw money at codebases like this. Nuclear fusion won't be solved with Rust if this is how sharing state works.
  ]

#import "../../templates/blog_post.typ": conf
#import "../../templates/utils.typ": sidenote

#show: conf.with(
    page-title: "Case studies in specificity: API docs and boolean choices",
    date: "2026-01-30",
)

I was doing a coding assignment recently, and noticed the provided package's `unique` function didn't specify whether it kept only the first item in every consecutive region of equal items. Instilled with a healthy wariness of Undefined Behavior#sidenote[nasal demons!!], I didn't want to assume it did so, even though that's the usual interpretation of that function. It was even more eye-raising because this was a library for parallel operations, so there could have presumably been some weird out-of-order shenanigans going on#sidenote[Divide and conquer doesn't consider items sequentially.] that cause it to take arbitrary items in every consecutive region. Equality is associative, after all---maybe something could cook wrt that?

After some tests and double checking the source code, it turned out to keep the first, anyway. Neat.

I remembered this being a problem when I browsed the corresponding Rust documentation before. So, since I'm getting nerd sniped, here's a lit review:
- C++: specified (#link("https://en.cppreference.com/w/cpp/algorithm/unique.html")[`std::unique`])
- Rust: not specified#sidenote[This sent me forum hunting/testing at least once before] (#link("https://doc.rust-lang.org/std/vec/struct.Vec.html#method.dedup")[`Vec::dedup`])
- R: doesn't specify the default behavior, but has a parameter that lets it keep the rightmost item instead, which implies the default is to keep the leftmost, LMAO, hilarious secret third option (#link("https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/unique")[`base::unique`])
- Python (and a few others): doesn't... seem to exist? The internet keeps saying "roll your own"

The R specificity issue in particular reminded me of a hot take blog post I read on never using checkboxes: #link("https://www.teamten.com/lawrence/programming/checkboxes/"). It's pretty good. I recommend reading it.#sidenote[I ran into this myself when using an #link("https://momijizukamori.github.io/bookbinder-js/")[imposer] and got confused by a "Alternate Page Rotation (AKA Flip on Long Side)" checkbox. Applying the post's principles, I would've been theoretically less confusing if it was phrased as "printer page rotation: #sym.ballot Flip on short side (standard page rotation) #sym.ballot Flip on long side (alternating page rotation)"]

While trying to find the article again, I also found this similar post on toggle buttons: #link("https://axesslab.com/toggles-suck/"). Toggles and checkboxes both represent boolean states, but toggles might worse, it seems.
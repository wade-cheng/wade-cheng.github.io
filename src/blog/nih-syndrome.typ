#import "../../templates/blog_post.typ": conf
#import "../../templates/utils.typ": *

#show: conf.with(
  page-title: "NIH Syndrome",
  date: "2025-12-17",
)


#quote(block: true, attribution: link("https://en.wikipedia.org/wiki/Not_invented_here")[Wikipedia])[
  Not invented here (NIH) is the tendency to avoid using or buying products, research, standards, or knowledge from external origins. It is usually adopted by social, corporate, or institutional cultures. Research illustrates a strong bias against ideas from the outside.
]

I code, and this seems to come up a lot in various places, including in my own practice.

Reinventing the wheel is totes fine when it's for a learning experience, I suppose. You can wave the flag of "ah yes, now I know this concept better. Ah yes, now I have more practice with the art of coding." This is probably the most uncontroversial reason to recode something.

But besides the learning case, there's also the awkward situation of familiarity when you use someone else's v.s. your own implementation of something. Every seventh blue moon, I decide to poke my head into the giant scope and breadth that is game development. There are at least two ways to approach this kind of coding problem. Since gamedev is so known, there are one morbillion engines out there that have a morbillion problems solved. But there's just the annoyance of trudging through the papercuts you accumulate every time you need to learn a new feature. Alternatively, you hook into a fairly low-level drawing library like pygame or raylib or macroquad, etc. This becomes closer to the "use the library" thing coders are more comfortable with. But now, you have to code everything.

So. It's choosing between the _feeling_ of floundering in deep water, and the _feeling_ of hard work followed by a holy understanding over the universe you've yourself shaped from clay. Even though I almost definitely would be more productive in gamedev if exactly every hour I've spent on reinventing was spent on learning an engine, it's the feeling that pains me.

I get the sense that this idea of feel is something that occurs in UX design all over: in gamedev, UI design, so on. I've definitely consumed some video essays about how gamers, even in competitive ranked settings, have chosen loadouts that feel better even if they're empirically quite definitively worse.#sidenote[#link("https://en.wikipedia.org/wiki/Desire_path")[Desire paths] aren't exactly this phenomenon, I don't believe, but the concept is cool anyways, and is the same vibe.]

Finally, another orthogonal point: I read an interesting article or blog post or other that said, it might be a good idea to NIH if your company's main selling point is the thing you're reinventing. For example, a graphics library might recode a graphics implementation, and this would be more acceptable than a game  dev recoding a graphics implementation.  The graphics library wants to do its best for its API, while the game dev should theoretically be focusing on making a fun game dang nab it. Is the idea.

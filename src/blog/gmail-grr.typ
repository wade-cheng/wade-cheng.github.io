#import "../../templates/blog_post.typ": conf
#import "../../templates/utils.typ": sidenote

#show: conf.with(
  page-title: "micropost: gmail, grr",
  date: "2025-12-01",
)

When you view a thread of emails on Gmail web,#sidenote[As a tech  nerd, I'm habitually trying to include my entire diagnostic information when I talk about having tech issues in case people want to think about reproducing or are otherwise curious about my system. Realised that it's a bit too verbose here, but that I also have sidenotes now :3 Problem on Gmail, web client, firefox, Ubuntu 24 Wayland, though there's really no chance this is anything that needs anything more specific than even just Gmail + web client. The wonders of modern browsers being operating systems, or something.] it collapses some messages to save screen real estate. I'm pretty sure it's impossible to expand it without using the mouse :/ Link Hints doesn't work, and neither is the section tab-selectable.#sidenote[You should make your interactive web components tab selectable! E.g. if you make a `<div>` a button, it won't be selectable by default, so slap a #link("https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/tabindex")[`tabindex="0"`] on it.]
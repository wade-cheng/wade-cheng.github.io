#import "../../templates/garden_planter.typ": conf

#show: conf.with(
  page-title: "daily driver issues",
)

My daily driver, Ubuntu 24, has some persisting issues that I don't quite enjoy. I list them for my and your perusal.

- Shell tab autocompletion doesn't work on some things. System packages seem fine, but externally downloaded ones are borked. `just` and `cargo`, for example.

- Switching to Wayland 

  - broke my conky config somehow.

  - ah, go figure, not being on X stops me from using Xkill


- I installed Nix-the-package-manager, and it's caused issues with R packages trying to compile with compilers from the Nix store, or something? Uh. Oh noes. This isn't now an issue after some trial-and-error with reinstalling R/Rstudio, but I should get Nix off my system at some point.

Additionally, some issues have been fixed.

- My firefox tabs flickered when running my mouse along the top of the screen. I recorded the video below:

  #html.video(height: 50, controls: true)[
    #html.source(src: "/assets/tab_flicker.mp4", type: "video/mp4")
    Your browser does not support the video tag. See #html.a(href: "/assets/tab_flicker.mp4").
  ]

  I took this video with the printscreen button on Ubuntu. You may notice that the mouse is not available. From Stackoverflow, I changed from Xorg to Wayland, and this fixed that. But hilariously enough, this also fixed the tab flickering issue.

  This is possibly in a bigger class of problems with Xorg possibly being jank around the edges of the screen?

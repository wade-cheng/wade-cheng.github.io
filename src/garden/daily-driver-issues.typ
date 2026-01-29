#import "../../templates/garden_planter.typ": conf
#import "../../templates/utils.typ": sidenote

#show: conf.with(
  page-title: "daily driver issues",
)

My daily driver is a Wayland Ubuntu 24 ThinkPad.

= Current issues

It has some persisting issues that I don't quite enjoy. I list them for my and your perusal.

- I've yet to figure out a good way to navigate around many UIs, eg nautilus the file manager, without the mouse. Alt tab order is... tedious... Maybe there's a trick like in Discord where f6 jumps your tab selection to the next logical section instead of the next tab item, but I haven't actually bothered to go looking. So basically, this one might be a skill issue.

- Printing works and then breaks again and then works again and then...

- Huh, well this is random. I used to have a bug/unimplemented feature in where if I hit save, eg just ctrl-s on some browser tab, the "rename saved file output" box wasn't focused until I alt tabbed and alt tabbed back. (Or click on it, but what are we, mouse-using plebians? I said ctrl-s, didn't I? /s /j) Or technically, that entire save dialogue window wasn't focused.

  But now I can hit save and immediately start typing to rename the file, like in any respectable OS UI. Random software update I guess. So weird.

- The terminal in snap-installed VSCode occasionally has path issues related to snap sandboxing.#sidenote[E.g., trying to do venv or tool stuff with `uv` can get weird, like tools only installing into the snap sandbox?] I fixed it by switching to the deb version, but at some point my Tinymist Typst preview got really slow and we've determined it's from svg rendering. We know it's because VSCode isn't using my GPU#sidenote[I'm on a laptop, so the default graphics is integrated i.e. with CPU]. I know firefox snap somehow has GPU turned on so maybe snaps automatically enable it? idk. Either way, I also have to figure out how to open vscode with the GPU by default now.#sidenote[Right clicking on the menu entry and hitting Launch using Discrete Graphics Card works, but I never open it that way---I use `zoxide` to jump to the dir i need and just hit a `code .`] Tried overriding the launch thing by putting one in the `~/.local` whatever, but it didn't work. Someone said this is the best way, so I guess I'll have to try again.

- Shell tab autocompletion doesn't work on some things. System packages seem fine, but externally downloaded ones are borked. `just` and `cargo`, for example.

- Switching to Wayland 

  - broke my conky config somehow. It's "fine," just shifted upwards partially off the screen. Ah welp, it may not be fine actually, after either a new update or me logging in and out...

  - ah, go figure, not being on X stops me from using Xkill


- I installed Nix-the-package-manager, and it's caused issues with R packages trying to compile with compilers from the Nix store, or something? Uh. Oh noes. This isn't now an issue after some trial-and-error with reinstalling R/Rstudio, but I should get Nix off my system at some point.

= Past issues

Additionally, some issues have been fixed.

- I had to manually reenable some ghostscript extension for imagemagick to get conversion to images to work, even though the insecure version of ghostscript wasn't on my machine.

- My firefox tabs flickered when running my mouse along the top of the screen. I recorded the video below:

  #html.video(height: 50, controls: true)[
    #html.source(src: "/assets/tab_flicker.mp4", type: "video/mp4")
    Your browser does not support the video tag. See #html.a(href: "/assets/tab_flicker.mp4").
  ]

  I took this video with the printscreen button on Ubuntu. You may notice that the mouse is not available. From Stackoverflow, I changed from Xorg to Wayland, and this fixed that. But hilariously enough, this also fixed the tab flickering issue.

  This is possibly in a bigger class of problems with Xorg possibly being jank around the edges of the screen?

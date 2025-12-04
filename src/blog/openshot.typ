#import "../../templates/blog_post.typ": conf
#import "../../templates/utils.typ": sidenote

#show: conf.with(
  page-title: "openshot is weird",
  date: "2025-12-03",
)

OpenShot is real weird... Instead of importing media into the  project in a contained way, like Photoshop or uhhhh any art program I know, it "links" to files via just saving the file paths. After I noticed, I had to manually copy over the files into the project folder and manually find and replace all the relative file paths with `@assets`.#sidenote[Apparently VSCode ctrl-f and adjacent utilities use BurntSushi's ripgrep. Cool.] Also it's obnoxious to do transformations without it creating animations and keyframes automatically, forcing me to do weird workarounds like snapping the clip to your scrubber cursor to preview while being able to do transformations. I suppose it's nice in the other case? Also, the ergonomics for precisely entering in positioning data is annoying, all the double clicking...

And finally, it segfaulted like three times while I was editing my video. It's almost nostalgic, it's been a while since software has segfaulted on me---I think of my in-progress C code for class.
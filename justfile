default:
    just --list --unsorted

watch:
    compile-typst-site --watch

build:
    compile-typst-site

export DEFAULT_BLOG_POST := '''
#import "../../templates/blog_post.typ": conf

#show: conf.with(
    page-title: "TODO",
    date: "1000-10-10",
)
'''
blog:
	printf '%s' "$DEFAULT_BLOG_POST" > src/blog/NEW_BLOG_POST.typ
	code src/blog/NEW_BLOG_POST.typ

# I assume linkedin blocks scraping
[working-directory: '_site']
check-links:
    lychee . -v --offline --exclude ".*linkedin.*" --root-dir $(pwd)

[working-directory: '_site']
check-links-full:
    lychee . -v --exclude ".*linkedin.*" --root-dir $(pwd)

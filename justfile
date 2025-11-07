default:
    just --list --unsorted

watch:
    compile-typst-site --watch

build:
    compile-typst-site

export DEFAULT_JUSTFILE := '''
#import "../../templates/blog_post.typ": conf

#show: conf.with(
    page-title: "TODO",
    date: "1000-10-10",
)
'''
blog:
	printf '%s' "$DEFAULT_JUSTFILE" > src/blog/NEW_BLOG_POST.typ
	code src/blog/NEW_BLOG_POST.typ

list-collections:
    python scripts/list-collections.py

post-process:
    python scripts/post-process.py

#!/usr/bin/env python
import subprocess
import glob
import json
from concurrent.futures import ThreadPoolExecutor

print("listing collections")


def process_post(kind, path):
    print(path)

    def query(label) -> str:
        return json.loads(
            subprocess.run(
                [
                    "typst",
                    "query",
                    path,
                    f"<{label}>",
                    "--root",
                    ".",
                    "--features",
                    "html",
                ],
                capture_output=True,
            ).stdout.decode("utf-8")
        )[0]["value"]

    # we can double our concurrency by computing these in
    # separate threads, but this is fine for now.
    # O(2n) vs O(n) span ykyk.
    pagetitle = query("page-title")
    date = query("date")
    print(pagetitle, date)

    path = path.removeprefix("src").removesuffix(".typ") + "/"
    return kind, {"path": path, "pagetitle": pagetitle, "date": date}


posts = {"blog": [], "garden": []}
items = [("blog", p) for p in glob.glob("src/blog/*.typ")] + [
    ("garden", p) for p in glob.glob("src/garden/*.typ")
]

with ThreadPoolExecutor() as executor:
    for kind, post in executor.map(lambda x: process_post(*x), items):
        posts[kind].append(post)

posts["blog"].sort(key=lambda p: p["date"], reverse=True)
posts["garden"].sort(key=lambda p: p["date"], reverse=True)

with open("posts.json", "w") as f:
    json.dump(posts, f)

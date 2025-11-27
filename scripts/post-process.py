#!/usr/bin/env python
import sys
import re
import unicodedata


def slugify(text):
    """
    Convert heading text to a URL-safe slug.
    Handles unicode, punctuation, and edge cases robustly.
    """
    # Normalize unicode characters (NFD = decompose accents)
    text = unicodedata.normalize("NFD", text).lower()

    # Replace spaces and underscores with hyphens
    text = re.sub(r"[\s_]+", "-", text)

    # Remove any character that isn't alphanumeric or hyphen
    text = re.sub(r"[^a-z0-9\-]", "", text)

    # Remove leading/trailing hyphens and collapse multiple hyphens
    text = re.sub(r"-+", "-", text).strip("-")

    # If slug is empty after sanitization, error
    if not text:
        raise ValueError("")

    return text


def add_heading_anchor(match):
    """
    Convert heading tags to include id and anchor link.
    Example: <h2>Loose leaf tea</h2> -> <h2 id="loose-leaf-tea"><a href="#loose-leaf-tea">Loose leaf tea</a></h2>
    """
    tag = match.group(1)  # h2, h3, etc.
    content = match.group(2)  # The text content

    slug = slugify(content)

    return f'<{tag} id="{slug}"><a href="#{slug}">{content}</a></{tag}>'


input_data = sys.stdin.buffer.read().decode("utf-8")

# Find all head tags
heads = re.findall(r"<head>.*?</head>", input_data, flags=re.DOTALL)

# Replace first head with second head, then remove the original second head
# We need to remove the second one first to avoid issues
replaced = input_data.replace(heads[1], "", 1)  # Remove second head
replaced = replaced.replace(heads[0], heads[1], 1)  # Replace first with second

# Add heading anchors to h2-h6
replaced = re.sub(
    r"<(h[2-6])>(.*?)</\1>", add_heading_anchor, replaced, flags=re.DOTALL
)

# Add lang attribute to html tag for hyphenation support
replaced = re.sub(r"<html>", '<html lang="en">', replaced)

# Extract the endnotes section content
endnotes_match = re.search(
    r'<section role="doc-endnotes">(.*?)</section>', replaced, re.DOTALL
)

if endnotes_match:
    endnotes_content = endnotes_match.group(1)

    # Remove the original endnotes section
    replaced = re.sub(
        r'\s*<section role="doc-endnotes">.*?</section>', "", replaced, flags=re.DOTALL
    )

    # Replace </main> with the endnotes section inside main
    replaced = re.sub(
        r"</main>",
        f'      <section role="doc-endnotes">\n        <hr><h2>Notes</h2>{endnotes_content}      </section>\n      </main>',
        replaced,
    )

sys.stdout.buffer.write(replaced.encode("utf-8"))

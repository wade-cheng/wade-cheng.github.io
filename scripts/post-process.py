#!/usr/bin/env python
import sys
import re
import unicodedata


def slugify(text) -> str:
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


def add_heading_anchors(html) -> str:
    """
    Convert heading tags to include anchor link.
    Example: `<h2>Loose leaf tea</h2>` -> `<h2 id="loose-leaf-tea"><a href="#loose-leaf-tea">Loose leaf tea</a></h2>`
    """

    def add_heading_anchor(match) -> str:
        tag = match.group(1)  # h2, h3, etc.
        content = match.group(2)  # The text content

        slug = slugify(content)

        return f'<{tag} id="{slug}"><a href="#{slug}">{content}</a></{tag}>'

    # Add heading anchors to h2-h6 (including the Notes heading)
    html = re.sub(r"<(h[2-6])>(.*?)</\1>", add_heading_anchor, html, flags=re.DOTALL)

    return html


def generate_section_wrappers(html) -> str:
    """
    Wrap each h2-h6 heading and its content in a <section> tag with the appropriate id.
    Sections end when the next heading is encountered or when </main> is reached.
    """

    def process_main_content(match):
        main_content = match.group(1)

        # Split by headings
        parts = re.split(
            r'(<h[2-6] id=".*?">.*?</h[2-6]>)', main_content, flags=re.DOTALL
        )

        result = []
        open_section = False

        for part in parts:
            # Check if this part is a heading
            heading_match = re.match(
                r'<(h[2-6]) id="(.*?)">(.*?)</\1>', part, flags=re.DOTALL
            )

            if heading_match:
                # Close previous section if open
                if open_section:
                    result.append("</section>\n")

                tag = heading_match.group(1)
                slug = heading_match.group(2)
                heading_content = heading_match.group(3)

                # Open new section and add heading without id
                result.append(f'<section id="{slug}">\n')
                result.append(f"<{tag}>{heading_content}</{tag}>")
                open_section = True
            else:
                result.append(part)

        # Close final section if open
        if open_section:
            result.append("</section>\n")

        return "<main>" + "".join(result) + "</main>"

    # Process content within <main> tags
    return re.sub(
        r"<main>(.*?)</main>", process_main_content, html, flags=re.DOTALL
    ).replace('<section id="notes">', '<section id="notes" role="doc-endnotes">')


def generate_toc(html) -> str:
    """
    Generate a table of contents from h2-h6 headings.
    Returns HTML string with navigation list and Gumshoe script.
    """
    # Find all headings with id attribute (before section wrapping)
    headings = re.findall(
        r'<(h[2-6]) id="(.*?)"><a(.*?)>(.*?)</a></\1>', html, flags=re.DOTALL
    )

    if not headings:
        return ""

    # Build navigation list
    toc_items = []
    for _, slug, _, text in headings:
        toc_items.append(f'<li><a href="#{slug}">{text}</a></li>')

    toc_html = f"""
<nav id="toc">
    <h2 class="smallcaps">on this page</h2>
    <ul>
        {"".join(toc_items)}
    </ul>
</nav>
"""

    return toc_html


def fix_heads(html) -> str:
    """
    Overwrite the head in the wrong place to the head in the correct place.
    """
    # Find all head tags
    heads = re.findall(r"<head>.*?</head>", html, flags=re.DOTALL)

    # Replace first head with second head, then remove the original second head
    # We need to remove the second one first to avoid issues
    replaced = html.replace(heads[1], "", 1)  # Remove second head
    replaced = replaced.replace(heads[0], heads[1], 1)  # Replace first with second

    return replaced


def fix_endnotes(html) -> str:
    """
    move endnotes from outside into main tag
    """
    # Extract and move the endnotes section (before adding anchors so Notes heading gets processed)
    endnotes_match = re.search(
        r'<section role="doc-endnotes">(.*?)</section>', html, re.DOTALL
    )

    if endnotes_match:
        endnotes_content = endnotes_match.group(1)

        # Remove the original endnotes section
        html = re.sub(
            r'\s*<section role="doc-endnotes">.*?</section>', "", html, flags=re.DOTALL
        )

        # Replace </main> with the endnotes section inside main
        html = re.sub(
            r"</main>",
            f"        <hr><h2>Notes</h2>{endnotes_content}      </main>",
            html,
        )

    return html


def add_toc(html, toc) -> str:
    # Insert table of contents after </header>
    if toc:
        html = re.sub(r"(</header>)", rf"\1\n      {toc}", html)
        # Add Gumshoe script before </body>
        gumshoe_script = """<script src="https://cdn.jsdelivr.net/gh/cferdinandi/gumshoe@4.0/dist/gumshoe.polyfills.min.js"></script>
    <script>document.addEventListener('DOMContentLoaded', function() { var spy = new Gumshoe('#toc a'); });</script>"""
        html = re.sub(r"(</body>)", rf"{gumshoe_script}\n\1", html)
    return html


input_data = sys.stdin.buffer.read().decode("utf-8")

replaced = fix_heads(input_data)
replaced = fix_endnotes(replaced)
replaced = add_heading_anchors(replaced)
toc = generate_toc(replaced)
replaced = generate_section_wrappers(replaced)
replaced = add_toc(replaced, toc)

# Add lang attribute to html tag for hyphenation support
replaced = re.sub(r"<html>", '<html lang="en">', replaced)

sys.stdout.buffer.write(replaced.encode("utf-8"))

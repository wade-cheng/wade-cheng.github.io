const { feedPlugin } = require("@11ty/eleventy-plugin-rss");

// Helper function to generate slug from heading text
function slugify(text) {
    return text
        .toString()
        .toLowerCase()
        .trim()
        .replace(/\s+/g, '-')
        .replace(/[^\w\-]+/g, '')
        .replace(/\-\-+/g, '-');
}

module.exports = function (eleventyConfig) {
    const months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
    ];
    eleventyConfig.addPassthroughCopy("./src/favicon/*");
    eleventyConfig.addPassthroughCopy("./src/CNAME");
    eleventyConfig.addPassthroughCopy("./src/.nojekyll");
    eleventyConfig.addPassthroughCopy("./src/404.html");
    eleventyConfig.addPassthroughCopy("./src/*.css");
    eleventyConfig.addPassthroughCopy("./src/*.js");
    eleventyConfig.addPassthroughCopy("./src/assets/*");
    eleventyConfig.addPassthroughCopy("./src/assets/*/*");
    eleventyConfig.addPassthroughCopy("./src/blog/*");
    eleventyConfig.addPassthroughCopy("./src/blog/*/*");
    // eleventyConfig.addPassthroughCopy("**/*.pdf");
    eleventyConfig.addFilter("formatDate", function (date) {
        return `<time datetime="${date.toISOString().slice(0, 10)}">${months[date.getMonth()]} ${date.getDate()}, ${date.getFullYear()}</time>`;
    });

    eleventyConfig.addFilter("smartquotes", (post) => {
        // Replace straight quotes with smart quotes

        // Handle double quotes
        post = post.replace(
            /(\s|>)"([^"]*)"(\s|<|[.,;:!?])/g,
            "$1\u201C$2\u201D$3",
        );
        // Handle single quotes/apostrophes
        post = post.replace(
            /(\s|>)'([^']*)'(\s|<|[.,;:!?])/g,
            "$1\u2018$2\u2019$3",
        );
        // Handle apostrophes in contractions
        post = post.replace(/(\w)'(\w)/g, "$1\u2019$2");
        // Handle special cases
        post = post.replace(/Hawai'i/g, "Hawaiʻi");
        return post;
    });

    // Add transform to automatically add IDs to headings
    eleventyConfig.addTransform("addHeadingAnchors", function(content, outputPath) {
        if (outputPath && outputPath.endsWith(".html")) {
            // Add id attributes and anchor links to h2, h3, h4 headings
            content = content.replace(/<h([234])>([^<]+)<\/h\1>/g, (_match, level, text) => {
                const id = slugify(text);
                return `<h${level} id="${id}"><a href="#${id}">${text}</a></h${level}>`;
            });
        }
        return content;
    });

    eleventyConfig.addPlugin(feedPlugin, {
        type: "atom", // or "rss", "json"
        outputPath: "/blog/feed.xml",
        collection: {
            name: "blog-post", // iterate over `collections.posts`
            limit: 10, // 0 means no limit
        },
        metadata: {
            language: "en",
            title: "wade's blog",
            subtitle:
                "various microblogs, ramblings, fun thematic gatherings of links, and other blog posts.",
            base: "https://wade-cheng.is-a.dev/",
            author: {
                name: "wade cheng",
                // email: "", // Optional
            },
        },
    });

    return {
        dir: {
            input: "src",
            output: "docs",
        },
    };
};

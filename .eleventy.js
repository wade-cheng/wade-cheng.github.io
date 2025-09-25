const { feedPlugin } = require("@11ty/eleventy-plugin-rss");

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
    eleventyConfig.addPassthroughCopy("./src/CNAME");
    eleventyConfig.addPassthroughCopy("./src/.nojekyll");
    eleventyConfig.addPassthroughCopy("./src/404.html");
    eleventyConfig.addPassthroughCopy("./src/*.css");
    eleventyConfig.addPassthroughCopy("./src/*.js");
    eleventyConfig.addPassthroughCopy("./src/assets/*");
    eleventyConfig.addPassthroughCopy("./src/assets/*/*");
    // eleventyConfig.addPassthroughCopy("./src/blog/*")
    eleventyConfig.addPassthroughCopy("./src/blog/*/*");
    // eleventyConfig.addPassthroughCopy("**/*.pdf");
    eleventyConfig.addFilter("formatDate", function (date) {
        return `${date.getDate()} ${months[date.getMonth()]} ${date.getFullYear()}`;
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

#import "../../templates/blog_post.typ": conf
#import "../../templates/utils.typ": sidenote

#show: conf.with(
  page-title: "my tab management scheme is a bump allocator",
  date: "2026-02-19",
)

So, if you squint real hard, my browser tab management scheme is a #link("https://en.wikipedia.org/wiki/Region-based_memory_management")[bump allocator].#sidenote[Man, non-general-case mallocation schemes are so cool. The general case is just "yeah let's try to get some memory for you chief, do whatever with it, we'll clean it up," but non-general-case implies you _know_ things about your access patterns. Maybe I just do a bunch of stuff and then you can clean it all up after. And we find out this can be faster than managing free lists and coalescing and etc etc. Cool.] I open up my project, need to keep a bunch of things open, I start getting so many tabs that it's hard to find tabs I've already opened, so I just create new ones, but of course I want to keep the previous tabs just in case I need them, and suddenly I'm over here at the finish line, test cases passing, with Firefox prompting me, kindly but perhaps with some concern, on whether I'd really like to close those 134 tabs.

Overall, it's pretty cool how good code abstractions often end up mirroring real organic behavior. 

#html.div(style: "text-align: left")[
- I'm reminded of some sorting algorithms. I think. Maybe.
- I'm reminded of how much of the history of machine learning follows human brain stuff. What with explicit coding of decision trees that follow how humans think, into neural nets that can be (at a high level) conceptualized as neurons doing shenanigans. 
  - see the feature engineering v.s. feature learning plot, neat 2d space: #link("https://www.cs.cmu.edu/~mgormley/courses/10601-f25//slides/lecture10-reg-ink.pdf")
- Lots of historical and contemp. chess algorithm building blocks are like this
  - #link("https://www.chessprogramming.org/Quiescence_Search")["Keep on thinking about a line until there's nothing more to think about"])
  - this entire page: #link("https://www.chessprogramming.org/Evaluation")]
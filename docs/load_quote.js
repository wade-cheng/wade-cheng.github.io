quotes = [
    ["http://backrooms-wiki.wikidot.com/the-red-knight", "A broken ring of mail"],
    ["http://backrooms-wiki.wikidot.com/the-red-knight", "erstwhile"],
    ["http://backrooms-wiki.wikidot.com/the-red-knight", "a finger of an arm of a body that died eons ago."],
    ["https://www.google.com/search?q=Adib+Sin+-+To+Eternity", "you were dancing to a thousand stars"],
];



window.onload = function() {
    quote = quotes[Math.floor(Math.random()*quotes.length)];
    
    document.getElementById("quote").innerHTML += `<a href=\"${quote[0]}\" target="_blank" rel="noopener noreferrer">${quote[1]}</a>`;
};

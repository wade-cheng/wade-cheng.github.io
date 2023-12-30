
/////////////// SETTING UP THE DATA STRUCTURE

let park = [
    {
        id: "bumper_cars_0",
        name: "Bumper Cars",
        price: 10,
        open_on: [false, false, true, true, true, true, false],
        allow_children: true,
    },
    {
        id: "mc_dropper_0",
        name: "The Dropper",
        price: 12,
        open_on: [true, true, true, false, false, false, false],
        allow_children: false,
    },
    {
        id: "paintball_0",
        name: "Paintball",
        price: 21,
        open_on: [false, true, true, true, true, true, false],
        allow_children: true,
    },
];

/////////////// ACTIVITY ONE STUFF

let int_to_weekday = {
    0: "Sunday",
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
};

/**
 * Takes in a ride from the dictionary of rides, park
 * Returns the days the ride is open.
 * For example, "open on Monday, Tuesday, and Friday"
 */
function daysOpen(ride) {
    let ans = "open on ";
    let days_open = ride.open_on;

    // adds the string form of weekday of the current index if that index is a day open
    days_open.forEach(
        (element, i) => (ans += days_open[i] ? int_to_weekday[i] + ", " : "")
    );
    ans = ans.slice(0, -1); // strip last whitespace so lastIndexOf can be used

    // insert " and" according to english grammar
    ans =
        ans.slice(0, ans.lastIndexOf(" ")) +
        " and" +
        ans.slice(ans.lastIndexOf(" "), ans.length);

    return ans.slice(0, -1); // return without ending comma (left over from above forEach)
}

console.log(`The first amusement ride is the ${park[0].name}`);
console.log(`The second attraction is ${daysOpen(park[1])}`);
console.log(
    `The second attraction is ${
        park[1].open_on[0] ? "open" : "closed"
    } on Sunday.`
);

/////////////// ACTIVITY TWO STUFF

/**
 * Returns a copy of amusementRides, but double all but the second ride's cost
 */
function doublePrices(amusementRides) {
    let rides = JSON.parse(JSON.stringify(amusementRides));

    rides.forEach((ride, index) => {
        if (index !== 1) {
            ride.price *= 2;
        }
    });

    return rides;
}

/**
 * prints out the name and price for every ride in amusementRides
 */
function debugAmusementRides(amusementRides) {
    amusementRides.forEach((ride) => {
        console.log(`${ride.name} costs ${ride.price} dollars.`);
    });
}

/**
 * writes the name and price for every ride in amusementRides to activity_one.html
 */
function writeAmusementRides(amusementRides) {
    let ans = "";
    amusementRides.forEach((ride) => {
        ans += `${ride.name} costs ${ride.price} dollars.\n\n`;
    });

    ans = ans.slice(0, -1); // strip last newline so the thing doesn't look ugly

    document.getElementById("content").innerText = ans;
}

// print old park to console
console.log("old park:");
debugAmusementRides(park);

// create and print double priced new park to console
console.log("new park:");
let newPark = doublePrices(park);
debugAmusementRides(newPark);

// write new park to html
writeAmusementRides(newPark);

/////////////// MAKE THE THING MOVE BECAUSE WHY NOT

/**
 * Generates a random integer between start (inclusive) and stop (exclusive)
 */
function randint(start, stop) {
    return Math.floor(Math.random() * (stop - start) + start);
}

const CONTENT_ID_TO_ANIMATE = "content";

let DOC_WIDTH = document.body.clientWidth;
let DOC_HEIGHT = window.innerHeight; // others height values are wrong for some reason
const CONTENT_WIDTH = document.getElementById(CONTENT_ID_TO_ANIMATE).offsetWidth;
const CONTENT_HEIGHT = document.getElementById(CONTENT_ID_TO_ANIMATE).offsetHeight;

// Optional. If off, will have wrong dimensions on resize.
addEventListener('resize', (event) => {
    DOC_WIDTH = document.body.clientWidth;
    DOC_HEIGHT = window.innerHeight;
});

let movingContent = document.getElementById(CONTENT_ID_TO_ANIMATE);

let x = DOC_WIDTH / 2 - CONTENT_WIDTH / 2; // Set to starting position. During animation, this is current position.
let y = randint(0, DOC_HEIGHT - CONTENT_HEIGHT / 2);
let dx = 1; // change in x per frame
let dy = Math.random() > 0.5 ? 1 : -1;  // randomly, -1 or 1
let move = function () {
    if (x > DOC_WIDTH - CONTENT_WIDTH - 3) {  // 3 is buffer
        dx = -1;
    } else if (x < 0) {
        dx = 1;
    }

    if (y > DOC_HEIGHT - CONTENT_HEIGHT - 3) {
        dy = -1;
    } else if (y < 0) {
        dy = 1;
    }
    x += dx;
    y += dy
    movingContent.style.left = x + "px";
    movingContent.style.top = y + "px";
};
setInterval(move, 10);

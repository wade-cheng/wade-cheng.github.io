function checkDarkmode() {
	console.log("got here");
	var r = document.querySelector(':root');
	var bgColor = getComputedStyle(r).getPropertyValue("--bg");

	console.log("cookie is " + document.cookie);
	if(document.cookie == "darkmode=On") {
		console.log("switch TO DARK")
		r.style.setProperty('--bg', '#20384B');
		r.style.setProperty('--text', '#E1F2FF');
	} else {
		console.log("switch TO LIGHT")
		r.style.setProperty('--bg', 'white');
		r.style.setProperty('--text', 'black');
	}
}

checkDarkmode();
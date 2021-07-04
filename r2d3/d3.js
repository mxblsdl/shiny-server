
// define height of original div
var h = d3.select("#one").node().getBoundingClientRect().height;
var trans = 1000; // define transition time

// select first div element and make it disappear
d3.select('#btn-one').on("click", () => {
		d3.select('#one').transition().
		duration(trans).
		style("height", 0 + 'px')
		.style("opacity", 0);
		
// Select other div and replace 
		d3.select('#two').
		transition().
		duration(trans).
		style("height", h + 'px').
		style("opacity", 1);
});

// repeat same operation in reverse order
d3.select('#btn-two').on("click", () => {
		d3.select('#one').
		transition().
		duration(trans).
		style("height", h + 'px')
		.style("opacity", 1);
		
		d3.select('#two').
		transition().
		duration(trans).
		style("height", 0 + 'px').
		style("opacity", 0);
});
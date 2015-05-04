// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

// Setting up values for the graph
var data = {
  "total": 0,
  "reserved": 0,
  "standby": 0
}
var gWidth = 960
var gHeight = 500
var radius = Math.min(gWidth, gHeight) / 2;
var arc = d3.svg.arc()
  .outerRadius(radius - 10)
  .innerRadius(radius - 70)
var svg = d3.select("#capacity_view")
  .append("svg")
  .attr("width", gWidth)
  .attr("height", gHeight)
  .append("g")
  .attr("transform", "translate(" + gWidth / 2 + "," + gHeight / 2 + ")")
var pie = d3.layout.pie()
    .sort(null)
    .value(function(d) { return d.population; });

// Updates the number of reserverd spots by the given amount
function addReserved(){
  num = getIncrement()
  data["reserved"] += num
  $("#reserved-total")[0].innerHTML = data["reserved"]
  addTotal(num)
}

// Updates the number of standby spots by the given amount
function addStandby(){
  num = getIncrement()
  data["standby"] += num
  $("#standby-total")[0].innerHTML = data["standby"]
  addTotal(num)
}

// Updates the total number of spots used
function addTotal(num){
  data["total"] += num
  $("#total")[0].innerHTML = data["total"]
}

function callback () {
  console.log(this.responseText);
};

// Returns the number of spots to increment by
function getIncrement(){
  return parseInt($("#inc").val())
}

function renderGraph(){

}

function transform(){
  r = "translate(" + arc.centroid(this) + ")"
  console.log(r)
  return r
}

function updateGraph(){
  for(var key in data){
    console.log(key + " " + data[key])
    g = svg.selectAll(".arc")
          .data(pie())
          .enter()
          .append("g")
          .attr("class", "arc")
    
    g.append("path")
      .attr("d", arc)
      .style("fill", "#000")
  }
}

$("#reserved").on("click", addReserved)
$("#standby").on("click", addStandby)
$("#total").on("change", updateGraph)

$("#reserved").on("click", updateGraph)
$("#standby").on("click", updateGraph)


var request = new XMLHttpRequest();
request.onload = callback;
request.open("post", "http://localhost:3000/capacity/get");
var formData = new FormData();
formData.append('my_data', 'back to basics')
request.send(formData);

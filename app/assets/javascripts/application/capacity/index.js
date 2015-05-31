// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

// Setting up values for the graph
var data;
var mCapacity;
var gWidth;
var gHeight;
var radius;
var arc;
var svg;
var pie;

if ($("#capacity_index").length) {
  initializeCapacityTracker();
}

function initializeCapacityTracker(){
  data = {
    "total": 0,
    "reserved": 0,
    "standby": 0
  }
  mCapacity = gon.capacity;
  gHeight = 400;
  gWidth = 400;
  radius = Math.min(gWidth, gHeight) / 2;
  arc = d3.svg.arc()
    .outerRadius(radius - 10)
    .innerRadius(radius - 70)
  svg = d3.select("#capacity_view")
    .append("svg")
    .attr("width", gWidth)
    .attr("height", gHeight)
    .append("g")
    .attr("transform", "translate(" + gWidth / 2 + "," + gHeight / 2 + ")")
  pie = d3.layout.pie()
    .value(function(d) { return d.value; });

  $("#reserved").on("click", { num: 1 },  add);
  $("#standby").on("click", { num: 1 }, add);
  $("#reserved-del").on("click", { num: -1 },  add);
  $("#standby-del").on("click", { num: -1 }, add);
  $("#capacity-warning").hide();
  $.ajax({
    "type": "POST",
    "url": "http://localhost:3000/capacity/get",
    "success": function(temp){
      temp.forEach(function(d){
        data[d.type] = d.value;
        if(d.type != "empty"){
          data["total"] += d.value;
        } else {
          $("#remaining")[0].innerHTML = d.value;
        }
      });
    }
  });
  updateGraph();
}

// Updates the number of reserverd spots by the given amount
function add(event){  
  if(this.id === "reserved" || this.id === "reserved-del"){
    temp = data["reserved"] + event.data.num;
    if(temp < 0){
      event.data.num = -data["reserved"];
      temp = 0;
    }
    data["reserved"] = temp;
  } else if(this.id === "standby" || this.id === "standby-del"){
    temp = data["standby"] + event.data.num;
    if(temp < 0){
      event.data.num = -data["standby"];
      temp = 0;
    }
    data["standby"] = temp;
  } else {
    console.log("Add was called without clicking a button");
  }
  
  data["total"] = data["total"] + event.data.num;
  if(data["total"] > mCapacity){
    console.log("OVER CAPACITY");
    $("#capacity-warning").show();
  } else {
    $("#capacity-warning").hide();
  }
  $("#remaining")[0].innerHTML = mCapacity - data["total"];
  updateServer();
}

function transform(){
  r = "translate(" + arc.centroid(this) + ")"
  return r
}

function updateGraph(){
  dataCall = d3.xhr("http://localhost:3000/capacity/get")
  params = {id: 1}
  dataCall.post(params, function(error, data){
    data = JSON.parse(data.response);

    data.forEach(function(d){
      data[d.type] = d.value;
    });

    var g = svg.selectAll(".arc")
        .data(pie(data))
      .enter().append("g")
        .attr("class", "arc");

    g.append("path")
      .attr("d", arc)
      .style("fill", function(d) {
        switch (d.data.type){
          case "reserved":
            return "#EF7B5C";
          case "standby":
            return "#66CFC3";
          case "empty":
            return "#9BE08B";
        }
      });

    g.append("text")
      .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
      .attr("dy", ".35em")
      .style("text-anchor", "middle")
      .text(function(d) { return d.data.value; });
  });
}

function updateServer(){
  $.ajax({
    "type": "POST",
    "url": "http://localhost:3000/capacity/update",
    "data": data,
    "success": function(){
      console.log("Success!");
    }
  });
  $(".arc").remove();
  updateGraph();
}



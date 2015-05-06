// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

// Setting up values for the graph
var data = {
  "total": 0,
  "reserved": 0,
  "standby": 0,
  "reserved_confirmed": 0
}
var mCapacity = parseInt($("#max-capacity")[0].innerHTML);
console.log(mCapacity);
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
    .value(function(d) { return d.value; });

// Updates the number of reserverd spots by the given amount
function add(){
  num = parseInt($("#inc").val());
  if(this.id === "reserved"){
    temp = data["reserved"] + num;
    if(temp < 0){
      num = -data["reserved"];
      temp = 0;
    }
    data["reserved"] = temp;
    $("#reserved-total")[0].innerHTML = data["reserved"]
  } else if(this.id === "standby"){
    temp = data["standby"] + num;
    if(temp < 0){
      num = -data["standby"];
      temp = 0;
    }
    data["standby"] = temp;
    $("#standby-total")[0].innerHTML = data["standby"]
  } else {
    console.log("add was called without a button");
  }
  
  data["total"] = data["total"] + num;
  $("#total")[0].innerHTML = data["total"]
  if(data["total"] > mCapacity){
    console.log("OVER CAPACITY");
    $("#capacity-warning").show();
  } else {
    $("#capacity-warning").hide();
  }

  updateServer();
}

function transform(){
  r = "translate(" + arc.centroid(this) + ")"
  console.log(r)
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
            return "#A00";
          case "standby":
            return "#00A";
          case "reserved_confirmed":
            return "#000";
          case "empty":
            return "#0A0";
        }
      });

    g.append("text")
      .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
      .attr("dy", ".35em")
      .style("text-anchor", "middle")
      .text(function(d) { return d.data.type; });
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


$("#reserved").on("click", add);
$("#standby").on("click", add);
$("#capacity-warning").hide();
$.ajax({
  "type": "POST",
  "url": "http://localhost:3000/capacity/get",
  "success": function(temp){
    // console.log(temp);
    temp.forEach(function(d){
      data[d.type] = d.value;
      if(d.type != "empty"){
        data["total"] += d.value;
      }
    });
    $("#standby-total")[0].innerHTML = data["standby"];
    $("#reserved-total")[0].innerHTML = data["reserved"];
    $("#total")[0].innerHTML = data["total"];
  }
});
updateGraph();


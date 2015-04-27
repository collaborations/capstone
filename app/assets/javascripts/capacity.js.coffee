# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
total = 0
reserved = 0
standby = 0

add = (num) ->
  #Increment total
  total += num
  $("#total")[0].innerHTML = total

addReserved = () ->
  num = getIncrement()
  reserved += num
  $("#reserved-total")[0].innerHTML = reserved
  add(num)

addStandby = () ->
  num = getIncrement()
  standby += num
  $("#standby-total")[0].innerHTML = standby
  add(num)

getIncrement = () ->
  return parseInt($("#inc").val())


$("#reserved").on("click", addReserved)
$("#standby").on("click", addStandby)

















# var width = 960,
#     height = 500,
#     radius = Math.min(width, height) / 2;
width = 960
height = 500
radius = Math.min(width, height) / 2;


# var color = d3.scale.ordinal()
#     .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);
color = d3.scale.ordinal().range(["#98abc5", "#8a89a6", "#7b6888"])


# var arc = d3.svg.arc()
#     .outerRadius(radius - 10)
#     .innerRadius(radius - 70);
arc = d3.svg.arc().outerRadius(radius - 10).innerRadius(radius - 70)

# var pie = d3.layout.pie()
#     .sort(null)
#     .value(function(d) { return d.population; });
pie = d3.layout.pie().sort(null)

# var svg = d3.select("body").append("svg")
#     .attr("width", width)
#     .attr("height", height)
#   .append("g")
#     .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
svg = d3.select("body").append("svg").attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

# d3.csv("data.csv", function(error, data) {

#   data.forEach(function(d) {
#     d.population = +d.population;
#   });

#   var g = svg.selectAll(".arc")
#       .data(pie(data))
#     .enter().append("g")
#       .attr("class", "arc");

#   g.append("path")
#       .attr("d", arc)
#       .style("fill", function(d) { return color(d.data.age); });

#   g.append("text")
#       .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
#       .attr("dy", ".35em")
#       .style("text-anchor", "middle")
#       .text(function(d) { return d.data.age; });

# });

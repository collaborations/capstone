# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
data = {
  "total": 0,
  "reserved": 0,
  "standby": 0
}
width = 960
height = 500
radius = Math.min(width, height) / 2;
arc = d3.svg.arc()
  .outerRadius(radius - 10)
  .innerRadius(radius - 70)
svg = d3.select("#capacity_view")
  .append("svg")
  .attr("width", width)
  .attr("height", height)
  .append("g")
  .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

add = (num) ->
  #Increment total
  data["total"] += num
  $("#total")[0].innerHTML = data["total"]

addReserved = () ->
  num = getIncrement()
  data["reserved"] += num
  $("#reserved-total")[0].innerHTML = data["reserved"]
  add(num)

addStandby = () ->
  num = getIncrement()
  data["standby"] += num
  $("#standby-total")[0].innerHTML = data["standby"]
  add(num)

getIncrement = () ->
  return parseInt($("#inc").val())

transform = () ->
  r = "translate(" + arc.centroid(this) + ")"
  console.log(r)
  return r

updateGraph = () ->
  for label, val of data
    console.log(label + " " + val)
    g = svg.selectAll(".arc").data(val).enter().append("g").attr("class", "arc")
    g.append("path").attr("d", arc).style("fill", "#FFFFFF")
    g.append("text").attr("transform", transform()).attr("dy", ".35em").style("text-anchor", "middle").text(label)

$("#reserved").on("click", addReserved)
$("#standby").on("click", addStandby)
$("#total").on("change", updateGraph)

$("#reserved").on("click", updateGraph)
$("#standby").on("click", updateGraph)

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


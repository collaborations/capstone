# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Setting up values for the graph
data = {
  "total": 0,
  "reserved": 0,
  "standby": 0
}
gWidth = 960
gHeight = 500
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

# Updates the number of reserverd spots by the given amount
addReserved = () ->
  num = getIncrement()
  data["reserved"] += num
  $("#reserved-total")[0].innerHTML = data["reserved"]
  addTotal(num)

# Updates the number of standby spots by the given amount
addStandby = () ->
  num = getIncrement()
  data["standby"] += num
  $("#standby-total")[0].innerHTML = data["standby"]
  addTotal(num)

# Updates the total number of spots used
addTotal = (num) ->
  data["total"] += num
  $("#total")[0].innerHTML = data["total"]

# Returns the number of spots to increment by
getIncrement = () ->
  return parseInt($("#inc").val())


transform = () ->
  r = "translate(" + arc.centroid(this) + ")"
  console.log(r)
  return r

updateGraph = () ->
  for label, val of data
    console.log(label + " " + val)
    g = svg.selectAll(".arc")
          .data(val)
          .enter()
          .append("g")
          .attr("class", "arc")
    
    g.append("path")
      .attr("d", arc)
      .style("fill", "#FFFFFF")
    # g.append("text")
    #   .attr("transform", -> 
    #       console.log("test")
    #     )
    #   .attr("dy", ".35em")
    #   .style("text-anchor", "middle")
    #   .text(label)

$("#reserved").on("click", addReserved)
$("#standby").on("click", addStandby)
$("#total").on("change", updateGraph)

$("#reserved").on("click", updateGraph)
$("#standby").on("click", updateGraph)



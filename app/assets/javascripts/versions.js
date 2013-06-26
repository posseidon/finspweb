$(function() {
  $('#adminUnitsSteps').psteps({
    traverse_titles: 'never',
    step_order: false,
    step_start: startStep($("#adminUnitsSteps").attr("title")),
    back: false
  });

  $('#cadastralParcelsSteps').psteps({
    traverse_titles: 'never',
    step_order: false,
    step_start: startStep($("#cadastralParcelsSteps").attr("title")),
    back: false
  });

  $('#geographicalNamesSteps').psteps({
    traverse_titles: 'never',
    step_order: false,
    step_start: startStep($("#geographicalNamesSteps").attr("title")),
    back: false
  });

  $(".action").click(function(){
    $("#foo").modal({
      keyboard: false,
      show: true
    });
  });
  var target = document.getElementById('spinner');
  var spinner = new Spinner(opts).spin(target);

  $("#checkFolderLink").click(function(){
    var hrefValue = $(this).attr("href").split("=")[0];
    $(this).attr("href", hrefValue + "=" + $("#location").val());
  });
});


var startStep = function(condition){
  switch(condition){
    case 'UnExtracted':
      return '1';
      break;
    case 'Extracted':
      return '2';
      break;
    case 'Processed':
      return '3';
      break;
    case 'Archived':
      return '4';
      break;
    default:
      return '1';
  }
};

var loadInfo = function(jsonObject, infoElement){
  var files = JSON.parse(jsonObject).files;
  var records = 0;
  $.each(files, function(idx, value){
    records += value.size;
  });

  $("#"+infoElement).attr("data-original-title", "Records: " + records);

}

var modelSchema = function(attributesArray, schemaTable){
  $.each(JSON.parse(attributesArray), function(index, value){
    $("#"+schemaTable + " tbody").append("<tr><td class='key'>"+value+"</td><td class='droppable mapped'></td></tr>");
  });
};

var shapeSchema = function(jsonObject, schemaTable){
  var data = JSON.parse(JSON.parse(jsonObject).schema);
  $.each(data, function(idx, val){
    // Removing unnecessary spaces with: REPLACE method
    $("#"+ schemaTable + " tbody").append("<tr><td class='draggable'>"+val.replace(/[^a-zA-Z _]/g, "")+"</td></tr>");
  });
}

var schemaTableJSON = function(tableId){
  var data = [];
  $("#"+tableId+" tbody tr").each(function(){
    data.push($(this).find(".key").html());
    data.push($(this).find(".droppable").html());
  });
  return JSON.stringify(data);
};

var clearSchemaTable = function(tableId){
  $("#"+tableId+" tbody tr").each(function(){
    var mappedValueColumn = $(this).find(".droppable").empty();
  });
};

var load_mapping_table = function(mapping, tableId){
  // Clear table content
  $("#"+tableId+" > tbody").html("");
  // Iterate through attributes and append.
  var data = JSON.parse(mapping, function(key, value){
    if(key){
      // Append a new row
      $("#"+tableId+" > tbody").append("<tr>"+"<td class='key'>"+ key +"</td><td class='droppable mapped'>"+ value +"</td></tr>");
    }
  });
};

var opts = {
  lines: 13, // The number of lines to draw
  length: 20, // The length of each line
  width: 10, // The line thickness
  radius: 30, // The radius of the inner circle
  corners: 1, // Corner roundness (0..1)
  rotate: 0, // The rotation offset
  direction: 1, // 1: clockwise, -1: counterclockwise
  color: '#000', // #rgb or #rrggbb
  speed: 1, // Rounds per second
  trail: 60, // Afterglow percentage
  shadow: false, // Whether to render a shadow
  hwaccel: false, // Whether to use hardware acceleration
  className: 'spinner', // The CSS class to assign to the spinner
  zIndex: 2e9, // The z-index (defaults to 2000000000)
  top: 'auto', // Top position relative to parent in px
  left: 'auto' // Left position relative to parent in px
};



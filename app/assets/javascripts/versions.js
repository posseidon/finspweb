$(function() {

  /**
   * Clear mapping on click request.
   */
  $(".clear").click(function(){
    var tblId = $(this).attr("data-name");
    clearSchemaTable(tblId);
    setDroppable(tblId);
  });

  /**
   * Activate Save Mapping Form.
   */
  $(".save").click(function(){
    var mappingTable = $(this).attr("data-reminder");
    var mappingRule  = mappingToJson(mappingTable);
    var targetTbl    = $(this).attr("data-appender");
    var modal        = $(this).attr("href");
    $(modal + " > .modal-header > form #data").val(mappingRule);
    loadMappingData(mappingRule, targetTbl);
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


var loadActionSteps = function(divIdentifier){
  $('#'+divIdentifier).psteps({
    traverse_titles: 'never',
    step_order: false,
    step_start: startStep($("#"+divIdentifier).attr("title")),
    back: false
  });
}

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

var setDroppable = function(tableId){
  $("#" + tableId +" tbody .droppable.mapped").droppable({
    drop: function(event, ui){
      var mappedValue = $(this).html();
      if(mappedValue != ''){
        $(this).text(mappedValue + "," + ui.draggable.text());
      }else{
        $(this).text(ui.draggable.text());
      }
    }
  });
}

var setDraggable = function(tableId, container){
  $("#" + tableId + " tbody tr .draggable").draggable({
    helper: "clone",
    containment: "#"+container,
    cursor: "crosshair"
  });
}

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

var mappingToJson = function(tableId){
  var obj = {};
  $("#"+tableId+" tbody tr").each(function(){
    var key = $(this).find(".key").html();
    obj[key] = $(this).find(".droppable").html();
  });
  return JSON.stringify(obj);
}

var clearSchemaTable = function(tableId){
  $("#"+tableId+" tbody tr").each(function(){
    var mappedValueColumns = $(this).find(".droppable");
    mappedValueColumns.html("");
  });
};

var loadMappingData = function(data, tableId){
  // Clear table content
  $(tableId+" > tbody").html("");
  // Iterate through attributes and append.
  var data = JSON.parse(data, function(key, value){
    if(key){
      // Append a new row
      $(tableId+" > tbody").append("<tr>"+"<td>"+ key +"</td><td>"+ value +"</td></tr>");
    }
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



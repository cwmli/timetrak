$(document).ready(function(){
  var editOn = 0;
  if (sessionStorage["filter"]){
    checkRetrieval();
  };

  $(document).off("click", "#mail").on("click", "#mail", function(){
    $.ajax({ url: '/calendar/mail/' });
  });
  //single event creation form
  $(document).off("click", "#cancel-sgen").on("click", "#cancel-sgen", function(){
    $("#new-sgen").fadeOut();
    $("#mask").fadeOut();
  });
  $("#sgen").off("click").on("click", function(){
    $("#new-sgen").fadeIn();
    $("#mask").fadeIn();
  })

  $(document).off("click", "#close-popup").on("click", "#close-popup", function(){
    $(this).parent().fadeOut('normal', function(){$(this).remove()});
  });

  //generation form
  $("#cancel-gen").off("click").on("click", function(){
    $("#new-gen").fadeOut();
    $("#mask").fadeOut();
  });
  $("#gen").off("click").on("click", function(){
    $("#new-gen").fadeIn();
    $("#mask").fadeIn();
  });

  $("#gLimit").off("input paste").on(" input paste", function(e){
    $('select[id*="gPermitted_"]').remove();
    $("#gen-confirm").remove();
    var limit = $("#gLimit").val();
    if (limit > 7) { limit = 7;}
    for (i=0; i < limit; i++){
      $("#float-form-table").append(" \
      <select style='font-size: inherit;border: none;' type='text' id='gPermitted_+"+i+"'> \
      <option value='nil'>None</option> \
      <option value='0'>Sunday</option> \
      <option value='1'>Monday</option> \
      <option value='2'>Tuesday</option> \
      <option value='3'>Wednesday</option> \
      <option value='4'>Thursday</option> \
      <option value='5'>Friday</option> \
      <option value='6'>Saturday</option> \
      </select>");
    }
    $("#float-form-table").append("<div class='button-main submit-button' id='gen-confirm'>CONTINUE</div>")
  });

  $(document).off("click","#gen-confirm");
  $(document).on("click","#gen-confirm", function(){
    var start = $("#gDate").val();
    var perweek = $("#gLimit").val();
    var stime = $("#gSTime").val();
    var etime = $("#gETime").val();
    var days = [];
    jQuery.each($('select[id*="gPermitted_"]'), function(){
      if($(this).val() != "nil"){
        days.push($(this).val());
      }
    })

    $.ajax({
      url: '/calendar/generate',
      data: { startdate: start, limit: perweek, weekdays: days, starttime: stime, endtime: etime}
    });
  })

  //enable event editing
  $(document).off("click", "[id=edit-event]");
  $(document).on("click", "[id=edit-event]", function(e) {
    if(editOn == 1){
      checkRetrieval();
      editOn = 0; //disable edit if on
    }
    else{
      this.style.background = "#19A3D1";
      editOn = 1; //turn on edit
    }
  });

  //upcoming events info expand
  $(document).off("click", "[id=expand-info]");
  $(document).on("click", "[id=expand-info]", function(e) {
      $(this.parentElement.parentElement.nextElementSibling).slideToggle();
  });

  $("#s-team").off("change").on("change", function(){
    var input = $("#s-team").find(":selected").text();
    sessionStorage["filter"] = input;
    checkRetrieval();
  })

  //all events info popup
  $(document).off("click", "[class=event-item], [class=event-item-passed]");
  $(document).on("click", "[class=event-item], [class=event-item-passed]", function() {
    $.ajax({
        url: "/events/show/"+$(this).attr("id"),
        type: "GET"
    });
  })

  function checkRetrieval(){
    var s_date = $(".month").attr("id");
    if (sessionStorage["filter"] != "Filter..."){
      $("#events-rblock").fadeIn();
      $("#gen").fadeIn();
      $("#sgen").fadeOut();
      if (sessionStorage["filter"] == "All"){
        retrieveAllEvents(s_date);
      }else{
        retrieveEvent(sessionStorage["filter"], s_date);
        $("#sgen").fadeIn();
      }
    }else{
      $("#gen").fadeOut();
      $("#sgen").fadeOut();
      $("#events-rblock").fadeOut();
    }
  }

  //inline editing
  $(document).off("click", ".editable");
  $(document).on("click", ".editable", function(e) {
    var currentValue = this.innerHTML;
    if (editOn == 1 && !this.firstElementChild){ //if input has not already been created
      var edittag = $(this).parent().parent().parent().find("span#edit-event");
      if(edittag.parent().find("span#del").html() == undefined){
        $("<span class='standard-block' id='del' title='Save changes'><input type='submit' name='commit' value='✔' style='border: 0;' class='button-block standard-block'</span>").insertBefore(edittag);
      }
      if ($(this).hasClass("dinput")){
        $(this).html("<input type='date' value='"+currentValue+"' name=event["+this.id+"]>");
      }
      else if ($(this).hasClass("tinput")){
        $(this).html("<input type='time' value='"+currentValue+"'name=event["+this.id+"]>");
      }
      else if ($(this).hasClass("lineinput")){
        $(this).html("<input type='text' value='"+currentValue+"' name=event["+this.id+"]>");
      }
      else{//text area
        $(this).html("<textarea name=event["+this.id+"]>"+currentValue+"</textarea>");
      }
    }
  });
});

$(document).ready(function(){
  $(".subcontainer").fadeIn();
  var editOn = 0;

  $("#cancel-event").off("click").on("click", function(){
    $("#new-event-form").fadeOut();
    $("#mask").fadeOut();
  });

  $("#new-event").off("click").on("click", function(){
    $("#new-event-form").fadeIn();
    $("#mask").fadeIn();
  });

  //enable event editing
  $(document).off("click", "[id=edit-event]");
  $(document).on("click", "[id=edit-event]", function(e) {
    if(editOn == 1){
      checkRetrieval();
      editOn = 0; //disable edit if on
    }
    else{
      this.style.background = "#19A3D1";
      $("<span class='new-block' title='Save changes'><input type='submit' name='commit' value='✔' class='new-block'</span>").insertBefore($(this))
      editOn = 1; //turn on edit
    }
  });

  //upcoming events info expand
  $(document).off("click", "[id=expand-info]");
  $(document).on("click", "[id=expand-info]", function(e) {
      $(this.parentElement.parentElement.nextElementSibling).slideToggle();
  });

  $("#s-team").off("change").on("change", function(){
    checkRetrieval();
  })

  //all events info popup
  $(document).on("click", "[id=event-item], [id=event-item-passed]", function() {
    /*$.ajax({
        url: "path to event_controller/show(this.id)"
        type: <GET>/<POST>
    });*/
  })

  function checkRetrieval(){
    var team_name = $("#s-team").find(":selected").text();
    var s_date = $(".month").attr("id");
    if (team_name == "All"){
      retrieveAllEvents(s_date);
    }else{
      retrieveEvent(team_name, s_date);
    }
  }

  //inline editing
  $(document).off("click", ".editable");
  $(document).on("click", ".editable", function(e) {
    var currentValue = this.innerHTML;
    if (editOn == 1 && !this.firstElementChild){ //if input has not already been created
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

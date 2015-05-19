$(document).ready(function(){
  $(".subcontainer").fadeIn();

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
      var event_block_id = "#"+this.parentElement.parentElement.parentElement.id;
      var event_block_parent_id = "#"+this.parentElement.parentElement.parentElement.parentElement.id;
      $(event_block_parent_id).load(location.href + " "+event_block_id); //reload
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

  //all events info popup
  $(document).on("click", "[id=event-item], [id=event-item-passed]", function() {
    /*$.ajax({
        url: "path to event_controller/show(this.id)"
        type: <GET>/<POST>
    });*/
  })
});

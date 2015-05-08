$(document).ready(function(){
  console.log("ready");
  $(".subcontainer").fadeIn();
  var editOn = 0; //default false

  $("#cancel-event").click(function(){
    $("#new-event-form").fadeOut();
    $("#mask").fadeOut();
  });

  $("#new-event").click(function(){
    $("#new-event-form").fadeIn();
    $("#mask").fadeIn();
  });

  $(document).on("click", "[id=edit-event]", function() {
    if(editOn == 1){
      var event_block_id = "#"+this.parentElement.parentElement.parentElement.id;
      var event_block_parent_id = "#"+this.parentElement.parentElement.parentElement.parentElement.id;
      $(event_block_parent_id).load(location.href + " "+event_block_id);
      editOn = 0; //disable edit if on
    }
    else{
      console.log("Edit on");
      this.style.background = "#19A3D1";
      $("<span class='new-block' title='Save changes'><input type='submit' name='commit' value='✔' class='new-block'</span>").insertBefore($(this))
      editOn = 1; //turn on edit
    }
  })

  $(document).on("click", ".editable", function() {
    var currentValue = this.innerHTML;
    if (editOn == 1 && !this.firstElementChild){ //if input has not already been created
      if ($(this).hasClass("dinput")){
        $(this).html("<input type='date' name=event["+this.id+"]>");
      }
      else if ($(this).hasClass("tinput")){
        $(this).html("<input type='time' name=event["+this.id+"]>");
      }
      else if ($(this).hasClass("lineinput")){
        $(this).html("<input type='text' value='"+currentValue+"' name=event["+this.id+"]>");
      }
      else{//text area
        $(this).html("<textarea name=event["+this.id+"]>"+currentValue+"</textarea>");
      }
    }
  })

  //upcoming events info expand
  $(document).on("click", "[id=expand-info]", function(e) {
    if (e.handled != true){
      $(this.parentElement.parentElement.nextElementSibling).slideToggle();
      e.handled = true;
    }
  });

  //all events info popup
  $(document).on("click", "[id=event-item], [id=event-item-passed]", function() {
    /*$.ajax({
        url: "path to event_controller/show(this.id)"
        type: <GET>/<POST>
    });*/
  })
});

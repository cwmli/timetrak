$(document).ready(function(){
  var editOn = 0; //default false
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

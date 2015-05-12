$(document).ready(function(){
    $("#new-season").off("click").on("click", function(){
      $("#new-season-form").fadeOut();
      $("#mask").fadeOut();
    });

    $("#s-season").off("change").on("change", function(){
        var selection = $(this).find(":selected").text();//fetch name of selection
        $.ajax({
            url: '/seasons/' + selection,
            type: 'GET',
            success: function(data){
              $("#season-info").empty().append(data);
            }
          });
    });
})

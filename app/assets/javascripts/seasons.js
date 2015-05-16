$(document).ready(function(){
   var opendelay;
    //button methods
    $("#cancel-season").off("click").on("click", function(){
      $("#new-season-form").fadeOut();
      $("#mask").fadeOut();
    });

    $("#new-season").off("click").on("click", function(){
      $("#new-season-form").fadeIn();
      $("#mask").fadeIn();
    });

    //button switcher
    $("#new-season").off('mouseenter').on('mouseenter', function(){
      opendelay = setTimeout(function(){
        $("#new-season").slideUp('fast',function(){
          $("#del-season").css("display", "block");
        });
      }, 750); //.5seconds
    }).mouseleave(function(){
      clearTimeout(opendelay);
    });
    $("#del-season").off('mouseleave').on('mouseleave', function(){
      $("#del-season").slideUp('fast', function(){
        $("#new-season").slideDown('fast');
      });
    });

    $("#cancel-team").off("click").on("click", function(){
      $("#new-team-form").fadeOut();
      $("#mask").fadeOut();
    });

    $(document).on("click", '#new-team', function(){
      $("#new-team-form").fadeIn();
      $("#mask").fadeIn();
    });

    $("#s-season").off("click").on("click", function(){
      $("#season-info").fadeOut();
      $("#new-team").fadeOut();
    });


    //retrieve team information with ajax
    $("#s-season").off("change").on("change", function(){
        var selection = $(this).find(":selected").text();//fetch name of selection
        $('#season-info').contents(':not(#static-teamslist)').remove();
        $.ajax({
            url: '/seasons/details/' + selection,
            data: { season_name: selection},
            type: 'GET',
            dataType: 'json',
            success: function(data){
              $("#new-team").fadeIn();
              $("#season-info").fadeIn();
              if(!jQuery.isEmptyObject(data)){
                for(var i in data){
                  $("#season-info").prepend("<p>"+i+"</p>")
                }
                $("#season-info").prepend("<h2>Teams in Season:</h2>");
              }
              else{
                $("#season-info").prepend("<p>No teams here.</p>").prepend("<h2>Teams in Season:</h2>");
              }
            }
          });
    });
})

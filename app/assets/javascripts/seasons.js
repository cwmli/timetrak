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
      if ($("#del-season").length){
        opendelay = setTimeout(function(){
          $("#new-season").slideUp('fast',function(){
            $("#del-season").css("display", "block");
          });
        }, 750); //.5seconds
      }
    }).mouseleave(function(){
      clearTimeout(opendelay);
    });
    $(document).on('mouseleave', '#del-season', function(){
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

    //retrieve team information with ajax
    $("#s-season").off("change").on("change", function(){
        $("#season-info").fadeOut('fast');
        $("#new-team").fadeOut('fast');
        $("#static-teamslist").fadeOut('fast');

        var selection = $(this).find(":selected").text();//fetch name of selection
        $('#season-info').contents(':not(#static-teamslist)').remove();//clear any previous data
        if (selection != "Select a season"){//the user actually made a choice
          $.ajax({
              url: '/seasons/details/' + selection,
              data: { season_name: selection},
              type: 'GET',
              dataType: 'json',
              success: function(data){
                //also refresh the delete button to match current season
                $("#reloadonchange").load(location.href + " #del-season");
                if(!jQuery.isEmptyObject(data)){ //team data exists
                  for(var i in data){
                    $("#season-info").prepend("<p>"+data[i]+"</p>")
                  }
                  $("#season-info").prepend("<h2>Teams in Season:</h2>");
                }
                else{
                  $("#season-info").prepend("<p>No teams here.</p>").prepend("<h2>Teams in Season:</h2>");
                }

                //refresh available teams to match current season
                $("#static-teamslist").load(location.href + " #infob").fadeIn('normal', function(){
                  $("#new-team").fadeIn();
                  $("#season-info").fadeIn();
                });
              }
            });
        }
    });
})

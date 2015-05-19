$(document).ready(function(){
   var seasondelay;
   var teamdelay;
    //button methods
    $("#cancel-season").off("click").on("click", function(){
      $("#new-season-form").fadeOut();
      $("#mask").fadeOut();
    });

    $("#new-season").off("click").on("click", function(){
      $("#new-season-form").fadeIn();
      $("#mask").fadeIn();
    });

    //button switcher for season deletion
    $("#new-season").off('mouseenter').on('mouseenter', function(){
      if ($("#del-season").length){
        seasondelay = setTimeout(function(){
          $("#new-season").slideUp('fast',function(){
            $("#del-season").css("display", "block");
          });
        }, 1000); //1seconds
      }
    }).mouseleave(function(){
      clearTimeout(seasondelay);
    });
    $(document).on('mouseleave', '#del-season', function(){
      $("#del-season").slideUp('fast', function(){
        $("#new-season").slideDown('fast');
      });
    });

    //team info ajax call
    $(document).on('mouseenter', '.team-button' ,function(e){
        teamdelay = setTimeout(function(){
          $("#team-info").fadeOut('fast');
          var targetname = $(e.target).val()
          if (!targetname){ targetname = $(e.target).text(); }
          retrieveTeamInfo(targetname);//retrieve input value
        }, 750); //.5seconds
    })
    $(document).on('mouseleave', '.team-button', function(){
      clearTimeout(teamdelay);//clear team information?
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
        if (selection != "Select a season"){//the user actually made a choice
          retrieveSeasonTeams(selection);
        }
    });
})

function retrieveSeasonTeams(season){
  $('#season-info').contents(':not(#static-teamslist)').remove();//clear any previous data
  $.ajax({
      url: '/seasons/details/' + season,
      data: { season_name: season},
      type: 'GET',
      dataType: 'json',
      success: function(data){
        //refresh the delete button to match current season
        $("#reloadonchange").load(location.href + " #del-season");
        if(!jQuery.isEmptyObject(data)){ //team data exists
          for(var i in data){
            $("#season-info").prepend("<div class='team-button'>"+data[i]+"</div>")
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

function retrieveTeamInfo(team){
  $("#team-info").empty() //clear previous information
  $.ajax({
    url: '/teams/details/' + team,
    data: { team_name: team},
    type: 'GET',
    dataType: 'json',
    success: function(data){
      $("#team-info").fadeIn();
      if(!jQuery.isEmptyObject(data)){
          $("#team-info").append("<h2>"+data.name+"</h2>");
          $("#team-info").append("<p>"+data.description+"</p>");
          $("#team-info").append("<h3>In seasons: </h3>"+data.in_season)
      }else{
        $("#team-info").html("Unable to load team data.");
      }
    }
  });
}

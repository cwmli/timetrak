function retrieveSeasonTeams(season){
  $('#season-info').contents(':not(#static-teamslist)').remove();//clear any previous data
  $.ajax({
      url: '/seasons/details/' + season,
      data: { season_name: season},
      type: 'GET',
      dataType: 'json',
      success: function(data){
        //refresh the delete button to match current season
        $("#reloaddel").load(location.href + " #del-season");
        $("#reloadnewven").load(location.href + " #new-venue-form");
        //refresh available teams to match current season
        $("#static-teamslist").load(location.href + " #infob").fadeIn('normal', function(){
          $("#calendar-view").fadeIn();
          $("#new-venue").fadeIn();
          $("#season-info").fadeIn();
        });
        if(!jQuery.isEmptyObject(data)){ //team data exists
          for(var i in data){
            $("#season-info").prepend("<div class='team-button'>"+data[i]+"</div>")
          }
          $("#season-info").prepend("<h2>Teams in Season:</h2>");
        }
        else{
          $("#season-info").prepend("<p>No teams here.</p>").prepend("<h2>Teams:</h2>");
        }
      }
    });
}

function retrieveTeamInfo(team){
  $("#team-info").empty().fadeIn(); //clear previous information
  $.ajax({
    url: '/teams/details/'+team,
    data: { team_name: team}});
}

function retrieveAllEvents(date){
  $.ajax({
    url: '/calendar/all/',
    data: { date: date},
    type: 'GET'
  })
}

function retrieveEvent(team, date){
  $.ajax({
    url: '/calendar/retrieve/',
    data: { team_name: team, date: date},
    type: 'GET'
  })
}

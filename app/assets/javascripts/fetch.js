function retrieveSeasonTeams(season){
  $('#season-info').contents(':not(#static-teamslist, #static-venueslist)').remove();//clear any previous data
  $.ajax({
      url: '/seasons/details/' + season,
      data: { season_name: season},
      type: 'GET',
      success: function(){
        //refresh the delete button to match current season
        $("#reloaddel").load(location.href + " #del-season");
        $("#reloadnewupl").load(location.href + " #new-upload-form", function(){$("#new-upload").fadeIn();});
        //refresh available teams to match current season
        $("#static-venueslist").load(location.href + " #infoc", function(){$(this).fadeIn();});
        $("#static-teamslist").load(location.href + " #infob", function(){$(this).fadeIn();});
        $("#calendar-view").fadeIn();
        $("#season-info").fadeIn();
      }
    });
}

function retrieveTeamInfo(team){
  $("#team-info").empty().fadeIn(); //clear previous information
  $.ajax({
    url: '/teams/details/',
    data: { team_name: team}});
}

function retrieveVenueInfo(venue){
  $("#team-info").empty().fadeIn(); //clear previous information, this borrows team div
  $.ajax({
    url: '/venues/details/',
    data: { venue_name: venue}});
}

function retrieveAllEvents(date){
  $.ajax({
    url: '/calendar/all/',
    data: { date: date},
    type: 'GET'
  });
}

function retrieveEvent(team, date){
  $.ajax({
    url: '/calendar/retrieve/',
    data: { team_name: team, date: date},
    type: 'GET'
  });
}

function updateEventAttributes(season, oldvenue, newvenue, oldteam, newteam){
  if(oldteam == 'nil'){ //update event records for new venue data
    $.ajax({
      url: '/events/refresh/',
      data: {  season_name: season, old_venue_name: oldvenue, new_venue_name: newvenue},
      type: 'GET'
    });
  }else{ //update event records for new team data
    $.ajax({
      url: '/events/refresh/',
      data: {  season_name: season, old_team_name: oldteam, new_team_name: newteam},
      type: 'GET'
    });
  }
}

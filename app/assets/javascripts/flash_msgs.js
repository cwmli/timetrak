$(document).ready(function(){
  $(document).on('mouseover', 'body', function(){
    $("#success").delay(5000).fadeOut('normal', function(){ $(this).remove(); });
    $("#error").delay(5000).fadeOut('normal', function(){ $(this).remove(); });
    $("#alert").delay(5000).fadeOut('normal', function(){ $(this).remove(); });
  })
});

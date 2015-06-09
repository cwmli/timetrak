$(document).ready(function(){
  $(document).on('mouseover', 'body', function(){
    $("#success").delay(3000).fadeOut('normal', function(){ $(this).remove(); });
    $("#error").delay(3000).fadeOut('normal', function(){ $(this).remove(); });
    $("#alert").delay(3000).fadeOut('normal', function(){ $(this).remove(); });
  })
});

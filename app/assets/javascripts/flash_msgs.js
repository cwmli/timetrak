$(document).ready(function(){
  $(document).on('mouseover', 'body', function(){
    $("#success").delay(2000).fadeOut();
    $("#error").delay(2000).fadeOut();
  })
});

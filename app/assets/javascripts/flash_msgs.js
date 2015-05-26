$(document).ready(function(){
  $(document).on('mouseover', 'body', function(){
    $("#success").delay(2000).fadeOut().remove();
    $("#error").delay(2000).fadeOut().remove();
    $("#alert").delay(2000).fadeOut().remove();
  })
});

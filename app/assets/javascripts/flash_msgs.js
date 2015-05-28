$(document).ready(function(){
  $(document).on('mouseover', 'body', function(){
    $("#success").delay(5000).fadeOut().remove();
    $("#error").delay(5000).fadeOut().remove();
    $("#alert").delay(5000).fadeOut().remove();
  })
});

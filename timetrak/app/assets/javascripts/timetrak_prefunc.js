function change_form_visibility(){
  form = document.getElementById('float-form');
  if (form.style.visibility == 'hidden'){ //make visible
    form.style.animation = 'fadeInDown .5s ease';//IE Support
    form.style.WebkitAnimation = 'fadeInDown .5s ease';

    show_element('mask');
    show_element('float-form');
  }
  else{//hide
    form.style.animation = '';//IE Support
    form.style.WebkitAnimation = '';    

    hide_element('mask');
    hide_element('float-form');
  }
}

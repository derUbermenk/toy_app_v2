// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "bootstrap"
import "../stylesheets/application"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// file preview 
function previewFiles() {

  var preview = document.querySelector('#preview');
  var files   = document.querySelector('input[type=file]').files;

  function readAndPreview(file) {

    // Make sure `file.name` matches our extensions criteria
    if ( /\.(jpe?g|png|gif)$/i.test(file.name) ) {
      var reader = new FileReader();

      reader.addEventListener("load", function () {
        var image = new Image();
        //image.height = 100;
        image.title = file.name;
        image.src = this.result;
        preview.appendChild( image );
      }, false);

      reader.readAsDataURL(file);
    }

  }

  if (files) {
    [].forEach.call(files, readAndPreview);
  }
}

function display_preview_container() {
  let file_preview_container = document.querySelector(
    '#image-preview-container'
  )

  // make visible
  file_preview_container.className = 'container'
}

function toy_form_photo_upload() {

  let file_input = document.querySelector('div.toy-form input[type=file]')
  if(file_input) {
    file_input.addEventListener('change', () => {
      display_preview_container()
      previewFiles()
    })
  }

}

// delete button
function photo_delete_button_click() {
  let toy_show = document.querySelector('.toy-show')
  // check if in toy_show indeed
  if(toy_show){
    toy_show.addEventListener('click', (e) => {
      let clicked_element_class = e.target.className
      let clicked_element_id = e.target.id
      // detecting image 
      // console.log(e.target.className)
      if(clicked_element_class==='img-interaction-button delete'){
        let image_card = document.getElementById(`img-card-${clicked_element_id}`)
        // console.log(image_card)
        image_card.remove()
      }
    })
  }
}


// event listeners
document.addEventListener("turbolinks:load", toy_form_photo_upload )
document.addEventListener("turbolinks:load", photo_delete_button_click )
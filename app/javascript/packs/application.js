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



// toggle button depending on state of file field
function upload_button_toggle(caller) {
    let upload_button = document.querySelector('#upload-button')
    let file_field = document.querySelector('#image-upload-field')

    // keep button disabled if file field empty
    upload_button.disabled = (file_field.value == '') ? true : false

    console.log(`called from: ${caller}`)
    console.log(`file field value: ${file_field.value}`)
    console.log(`upload_button_status ${upload_button.disabled}`)
}

// clear images for upload
function clear_upload_click() {
  function clear_uploads() {
    let image_upload_field = document.querySelector('#image-upload-field')
    let image_preview_container = document.querySelector('#image-preview-container')
    let image_preview_image_list = document.querySelector('#preview')

    // clear images
    image_preview_image_list.innerHTML = ''
    image_upload_field.value = ''
    image_preview_container.className += ' d-none'
  }

  let clear_upload_button = document.querySelector('#clear-upload-button')

  if(clear_upload_button){
    clear_upload_button.addEventListener('click', () => {
      // clear file upload field
      clear_uploads()
      // 
      upload_button_toggle('clear upload click')
    })
  }
}

// preview images
function image_preview() {

  function display_preview_container() {
    let file_preview_container = document.querySelector(
      '#image-preview-container'
    )

    // make visible
    file_preview_container.className = 'container'
  }

  function previewFiles() {

  var preview = document.querySelector('#preview');
  var files   = document.querySelector('input[type=file]').files;

  console.log(files)

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

  let file_input = document.querySelector('#image-upload-field')
  if(file_input) {
    file_input.addEventListener('change', () => {
      previewFiles()
      display_preview_container()
      upload_button_toggle('image_preview')
    })
  }
}

// append new photos to view
function toy_image_submit(){
  function clear_uploads() {
    let image_upload_field = document.querySelector('#image-upload-field')
    let image_preview_container = document.querySelector('#image-preview-container')
    let image_preview_image_list = document.querySelector('#preview')

    // clear images
    image_preview_image_list.innerHTML = ''
    image_upload_field.value = ''
    image_preview_container.className += ' d-none'
  }

  function display_new_images(event){
    // const [data, status, xhr] = event.detail;
    const xhr = event.detail[2];

    // create temporary xhr.response parent
    let temp_parent = document.createElement('div')
    // converts xhr response to images cards
    temp_parent.innerHTML = xhr.response  

    // get the image cards
    // use array for to convert to array and allow forEach method
    let images_container = document.querySelector('div.image-view#list-view')
    let image_cards = Array.from(temp_parent.children)

    image_cards.forEach(image_card => images_container.prepend(image_card))
  }

  function display_error(event){
    const xhr = event.detail[2];

    // create temporary xhr.response parent
    let temp_parent = document.createElement('div')
    // converts xhr response to images cards
    temp_parent.innerHTML = xhr.response  

    // get the image cards
    // use array for to convert to array and allow forEach method
    let toy_show = document.querySelector('.toy-show')
    let errors = Array.from(temp_parent.children)

    errors.forEach(error_message => toy_show.prepend(error_message))
  }

  let toy_form = document.querySelector('.toy-form form')

  if(toy_form) {
    toy_form.addEventListener("submit", ()=> {
      document.addEventListener('ajax:success', (e) => { 
        display_new_images(e) 
        // clear file upload field
        clear_uploads()
        // 
        upload_button_toggle('Submit')
      })
      document.addEventListener('ajax:error', (e) => { 
        display_error(e) 
      })
    })
  }
}

// delete a toy image
function delete_toy_image() {
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

// toggle between views
function view_toggle() {

  function switch_toggles(clicked_toggle){
    // set the clicked toggle class active
    clicked_toggle.className = "nav-link view-toggle active"

    // set other toggles to inactive
    Array.from(document.querySelectorAll(`.view-toggle:not(#${clicked_toggle.id})`)).forEach(
      toggle => toggle.className = "nav-link view-toggle"
    )
  }

  function switch_views(element_id) {
    // find toggled view
    let toggled_view = document.querySelector(`.image-view#${element_id}`) 

    // set the toggled view to not have style display:none 
    toggled_view.className = 'image-view'

    // set all untoggled views to have style display:none through the bootstrap class d-none
    Array.from(document.querySelectorAll(`.image-view:not(#${toggled_view.id})`)).forEach(
      untoggled_view => untoggled_view.className = "image-view d-none"
    )
  }

  let view_toggles = document.querySelector('#view-toggles')

  view_toggles.addEventListener('click', (event) => {
    let event_target = event.target

    if (event_target.className === 'nav-link view-toggle') {
      switch_toggles(event_target)
      switch_views(event_target.id)

    // handle if the the event clicked the image inside the
    // the navlink  
    } else if(event_target.nodeName === 'IMG') {
      // use the parent element
      switch_toggles(event_target.parentElement)
      switch_views(event_target.parentElement.id)
    } else {
      return;
    }
  })
}

// event listeners
document.addEventListener("turbolinks:load", image_preview)
document.addEventListener("turbolinks:load", clear_upload_click)
document.addEventListener("turbolinks:load", delete_toy_image)
document.addEventListener("turbolinks:load", toy_image_submit)
document.addEventListener("turbolinks:load", view_toggle)

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require navbar.min


function displayPhoto(event) {
    var output = document.getElementById('imagePreview');
    output.src = URL.createObjectURL(event.target.files[0]);
}

function takePhotoNumber(event){
    var id = event.target.id;
    var photo_number = id.charAt(id.length - 1);
    return photo_number;
}

function openDialog(event) {
    photo_number = takePhotoNumber(event)
    document.getElementById('photo-'.concat(photo_number.toString())).click();
}

function displayProductPhoto(event) {
    photo_number = takePhotoNumber(event);
    var output = document.getElementById('photo-preview-'.concat(photo_number.toString()));
    output.src = URL.createObjectURL(event.target.files[0]);
}

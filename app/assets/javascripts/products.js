// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function submitOrderForm(event){
    document.getElementById('new_order').submit()
}

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
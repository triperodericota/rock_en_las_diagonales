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

$(document).on("change", "#state", function(){
    var state = $(this).val();
    $.ajax({
        url: "/show_cities",
        method: "GET",
        dataType: "json",
        data: {state: state},
        error: function (xhr, status, error) {
            console.error('AJAX Error: ' + status + error);
        },
        success: function (response) {
            console.log(response);
            var cities = response["cities"];
            $('#city').prop("disabled", false);
            $("#city").empty();
            $("#city").append('<option selected>Localidad</option>');
            for(var i=0; i< cities.length; i++) {
                console.log("city:".concat(cities[i].toString()));
                $("#city").append('<option value="' + cities[i].toString() + '">' + cities[i].toString() + '</option>');
            }
        }
    });
});


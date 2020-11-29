
/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")


import "bootstrap"
import "../src/application.scss"

document.addEventListener("turbolinks:load", () => {
    $('[data-toggle="tooltip"]').tooltip();
    $('[data-toggle="popover"]').popover()
})
;

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

console.log('Hello World from Webpacker');

window.Mercadopago.setPublishableKey("TEST-6ccb9c47-6884-4fcb-967c-83d3906ac14f");


$(document).on("change", "#photo", function (){
    var output = $("#imagePreview");
    output.attr("src",URL.createObjectURL(event.target.files[0]));
})

function takePhotoNumber(event) {
    var id = event.target.id;
    var photo_number = id.charAt(id.length - 1);
    return photo_number;
}

$(document).on("change", "input[id|='photo']", function (event) {
    alert("catch event");
    var photo_number = takePhotoNumber(event);
    var tag_id_string = "#photo-preview-".concat(photo_number.toString());
    console.log($(tag_id_string));
    $(tag_id_string).attr("src",URL.createObjectURL(event.target.files[0]));
})

$(document).on("click", "img[id|='photo-preview']", function (event) {
    var photo_number = takePhotoNumber(event);
    $("#photo-".concat(photo_number.toString())).click();
})

$(document).on("click", "#submitOrder", function () {
    if (document.getElementById("terms").checked) {
        $("#new_order").submit();
    } else {
        alert("Debes aceptar los términos antes de continuar")
    }
});

$(document).on("click", "#withDelivery", function () {
    $("#order_delivery").val(true)
    $("#state").prop("disabled", false)
    $("#order_buyer_address_street_name").prop("disabled", false)
    $("#order_buyer_address_street_number").prop("disabled", false)
    $("#order_buyer_address_apartament").prop("disabled", false)
    $("#order_buyer_address_zip").prop("disabled", false)
    $(this).prop("disabled", true)
})

$(document).on("change", "#state", function () {
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
            var cities = response["cities"];
            $('#city').prop("disabled", false);
            $("#city").empty();
            $("#city").append('<option selected>Localidad</option>');
            for (var i = 0; i < cities.length; i++) {
                console.log("city:".concat(cities[i].toString()));
                $("#city").append('<option value="' + cities[i].toString() + '">' + cities[i].toString() + '</option>');
            }
        }
    });
});

$(document).on("keyup", "#model-search", function () {
    var search_val = $(this).val();
    $.ajax({
        url: "/search",
        method: "GET",
        dataType: "json",
        data: {model: search_val},
        success: function (response) {
            var response = response["result"];
            console.log(response);
            var response_len = response.length;
            $("#search-result").empty();
            for (var i = 0; i < response_len; i++) {
                console.log("<li value='" + response[i]['id'] + "'" + "><a href='" + response[i]['url'] + "'" + ">" + response[i]['name'] + "</a></li>");
                $("#search-result").append("<li value='" + response[i]['id'] + "'" + "><a href='" + response[i]['url'] + "'" + "><h5>" + response[i]['name'] + "</h5></a><small>" + response[i]['type'] + "</small></li>");

            }
        }
    });
});


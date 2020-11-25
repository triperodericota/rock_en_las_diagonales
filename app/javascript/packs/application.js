7/* eslint no-console:0 */
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
window.Mercadopago.getIdentificationTypes();

document.onload = function() {


    document.getElementById("cardNumber").addEventListener('change', guessPaymentMethod);

    function guessPaymentMethod(event) {
        let cardnumber = document.getElementById("cardNumber").value;
        if (cardnumber.length >= 6) {
            let bin = cardnumber.substring(0, 6);
            window.Mercadopago.getPaymentMethod({
                "bin": bin
            }, setPaymentMethod);
        }
    };

    function setPaymentMethod(status, response) {
        if (status == 200) {
            let paymentMethod = response[0];
            document.getElementById('paymentMethodId').value = paymentMethod.id;

            if (paymentMethod.additional_info_needed.includes("issuer_id")) {
                getIssuers(paymentMethod.id);
            } else {
                getInstallments(
                    paymentMethod.id,
                    document.getElementById('transactionAmount').value
                );
            }
        } else {
            alert(`payment method info error: ${response}`);
        }
    }


    function getIssuers(paymentMethodId) {
        window.Mercadopago.getIssuers(
            paymentMethodId,
            setIssuers
        );
    }

    function setIssuers(status, response) {
        if (status == 200) {
            let issuerSelect = document.getElementById('issuer');
            response.forEach(issuer => {
                let opt = document.createElement('option');
            opt.text = issuer.name;
            opt.value = issuer.id;
            issuerSelect.appendChild(opt);
        })
            ;

            getInstallments(
                document.getElementById('paymentMethodId').value,
                document.getElementById('transactionAmount').value,
                issuerSelect.value
            );
        } else {
            alert(`issuers method info error: ${response}`);
        }
    }


    function getInstallments(paymentMethodId, transactionAmount, issuerId) {
        window.Mercadopago.getInstallments({
            "payment_method_id": paymentMethodId,
            "amount": parseFloat(transactionAmount),
            "issuer_id": issuerId ? parseInt(issuerId) : undefined
        }, setInstallments);
    }

    function setInstallments(status, response) {
        if (status == 200) {
            document.getElementById('installments').options.length = 0;
            response[0].payer_costs.forEach(payerCost => {
                let opt = document.createElement('option');
            opt.text = payerCost.recommended_message;
            opt.value = payerCost.installments;
            document.getElementById('installments').appendChild(opt);
        })
            ;
        } else {
            alert(`installments method info error: ${response}`);
        }
    }


    var doSubmit = false;
    document.getElementById('paymentForm').addEventListener('submit', getCardToken);

    function getCardToken(event) {
        event.preventDefault();
        if (!doSubmit) {
            let $form = document.getElementById('paymentForm');
            window.Mercadopago.createToken($form, setCardTokenAndPay);
            return false;
        }
    };

    function setCardTokenAndPay(status, response) {
        if (status == 200 || status == 201) {
            let form = document.getElementById('paymentForm');
            let card = document.createElement('input');
            card.setAttribute('name', 'token');
            card.setAttribute('type', 'hidden');
            card.setAttribute('value', response.id);
            form.appendChild(card);
            doSubmit = true;
            form.submit();
        } else {
            alert("Verify filled data!\n" + JSON.stringify(response, null, 4));
        }
    };

}

// PRODUCTS JS

function displayPhoto(event) {
    var output = document.getElementById('imagePreview');
    output.src = URL.createObjectURL(event.target.files[0]);
}

function takePhotoNumber(event) {
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

$(document).on("click","#submitOrder",function() {
    if(document.getElementById("terms").checked){
        $("#new_order").submit();
    }else{
        alert("Debes aceptar los términos antes de continuar")
    }
});

$(document).on("click", "#withDelivery", function(){
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

$(document).on("keyup","#model-search",function(){
    var search_val = $(this).val();
    $.ajax({
        url:"/search",
        method: "GET",
        dataType: "json",
        data: {model: search_val},
        success: function(response) {
            var response = response["result"];
            console.log(response);
            var response_len = response.length;
            $("#search-result").empty();
            for(var i=0; i < response_len; i++){
                console.log("<li value='"+response[i]['id']+"'"+"><a href='"+response[i]['url']+"'"+">"+response[i]['name']+"</a></li>");
                $("#search-result").append("<li value='"+response[i]['id']+"'"+"><a href='"+response[i]['url']+"'"+"><h5>"+response[i]['name']+"</h5></a><small>"+response[i]['type']+"</small></li>");

            }
        }
    });
});
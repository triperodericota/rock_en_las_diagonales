// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on("click", "#remove-artist", function() {
    var state = $(this).val();
    $.ajax({
        url: "/artists/:name/unfollow",
        method: "GET",
        dataType: "json",
        data: {state: state},
        error: function (xhr, status, error) {
            console.error('AJAX Error: ' + status + error);
        },
    });
});
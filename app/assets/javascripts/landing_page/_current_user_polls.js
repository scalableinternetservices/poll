$(document).on("ready page:change", setupShowMoreCurrentUserPolls);

function setupShowMoreCurrentUserPolls() {
    $("button[data-current-user-polls-request-size]").click(function () {
        // Submit an AJAX request for a new poll table
        $.get("/current_user_polls",
             { num_current_user_polls: this.getAttribute("data-current-user-polls-request-size") },
             function(data) {
                 $("#current-user-polls").html(data)
                 setupShowMoreCurrentUserPolls();
             },
             "html");
    });
}

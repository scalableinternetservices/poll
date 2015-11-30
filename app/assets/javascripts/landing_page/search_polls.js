$(document).on("ready page:change", setupShowMoreSearchPolls);

function setupShowMoreSearchPolls() {
    $("button[data-search-polls-request-size]").off().click(function () {
        // Submit an AJAX request for a new poll table
        $.get("/search_polls",
             { num_search_polls: this.getAttribute("data-search-polls-request-size"),
               search: this.getAttribute("data-search-polls-query") },
             function(data) {
                 $("#search-polls").html(data)
                 setupShowMoreSearchPolls();
                 setupShareButtons();
             },
             "html");
    });
}

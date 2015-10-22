// For whatever reason, loading this script via <script> tags forces AJAX
// queries to run synchronously, so explicitly set them to be asynchronous.

$( function() {
    setupOnClick();
});

function setupOnClick() {
    $("button[data-more-polls-request-size]").click(function () {
        // Submit an AJAX request for a new poll table
        $.get("user_polls/news_feed",
             { num_polls: this.getAttribute("data-more-polls-request-size") },
             function(data) {
                 $("#newsfeedtable").html(data)
                 setupOnClick();
             },
             "html");
    });
}
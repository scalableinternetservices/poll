$(document).on("page:change", setupShowMoreNewsFeedPolls);

function setupShowMoreNewsFeedPolls() {
    $("button[data-news-feed-polls-request-size]").off().click(function () {
        // Submit an AJAX request for a new poll table
        $.get("/news_feed_polls",
             { num_news_feed_polls: this.getAttribute("data-news-feed-polls-request-size") },
             function(data) {
                 $("#news-feed-polls").html(data)
                 setupShowMoreNewsFeedPolls();
             },
             "html");
    });
}

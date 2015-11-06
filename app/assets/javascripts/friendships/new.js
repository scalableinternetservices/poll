$(document).on("ready page:change", function() {
    $("button[data-search-users]").off().click(function () {
        var parameters = { search_field: $("#user-search-field").val() };
        
        if ($("[data-next-search-users-request-size]").length)
            parameters.request_size = $("[data-next-search-users-request-size]").attr("data-next-search-users-request-size");
        
        $.get("/friend_request/search_users",
              parameters,
              function (data) {
                  $("#search-users-friend-request-results").html(data);
              },
              "html");
    });
});

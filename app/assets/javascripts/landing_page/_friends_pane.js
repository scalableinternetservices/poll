$(document).on("ready page:change", setupShowMoreFriends);

function setupShowMoreFriends() {
    $("button[data-current-user-friends-request-size]").off().click(function() {
        $.get("/friends_pane",
             { num_current_user_friends: $(this).attr("data-current-user-friends-request-size") },
              function (data) {
                  $("#friends_pane").html(data)
                  setupShowMoreFriends();
              },
              "html");
    });
}

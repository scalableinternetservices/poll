$(document).on("page:change", function() {
    $("button[data-poll-id]").click(function () {
        $("#share-modal .modal-body").html("");

        var pollId = $(this).attr("data-poll-id");
        $.get("/friends_for_sharing",
              { num_friends: 5,
                poll_id: pollId },
              function (data) {
                  $("#share-modal .modal-body").html(data);
              },
              "html");
    });
});

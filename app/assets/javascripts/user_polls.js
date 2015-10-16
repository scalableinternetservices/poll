function addPollQuestion() {
    $(".hidden_question_field").each( function(index) {
        // Just a little hacky
        if ($(this).css("display") == "block")
            return true;

        $(this).css("display", "block");
        return false;
    });

    // Also a little hacky; hide the button once all options are displayed
    $("#add_poll_option_button").css("display", "none");
    $(".hidden_question_field").each( function(index) {
        if ($(this).css("display") == "none") {
            $("#add_poll_question_button").css("display", "block");
            return false;
        }
    });
}

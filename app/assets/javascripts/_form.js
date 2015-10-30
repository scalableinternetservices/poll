$(document).on("page:change", function () {
    $("button[data-max-questions]").off().click(function () {
        // One of the question fields is the dummy, so ignore that one
        var numQuestions = $(".question-field").length - 1;

        var fieldCopy = $("#template-field").clone();
        fieldCopy.attr("id", "field" + numQuestions);
        fieldCopy.attr("style", null);
        var newHtml = fieldCopy.html().replace(/\[poll_questions_attributes\]\[\d+\]/gm, "[poll_questions_attributes][" + numQuestions + "]");
        newHtml = newHtml.replace(/poll_questions_attributes_\d+_/gm, "poll_questions_attributes_" + numQuestions + "_");
        newHtml = newHtml.replace(/Question \d+/gm, "Question " + (numQuestions + 1));
        fieldCopy.html(newHtml);

        $("#template-field").before(fieldCopy);

        tryDisableAddQuestionButton();
    });
});

function tryDisableAddQuestionButton() {
    var numQuestions = $(".question-field").length - 1;

    $("button[data-max-questions]").each(function () {
        var button = $(this);
        if (numQuestions >= parseInt(button.attr("data-max-questions")))
            button.attr("style", "display: none;");
    });
}

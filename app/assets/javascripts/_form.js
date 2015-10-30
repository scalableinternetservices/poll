$(document).on("page:change", function () {
    $("button[data-max-questions]").off().click(function () {
        var currentQuestions = $(".question-field");
        var numQuestions = currentQuestions.length;

        var fieldCopy = currentQuestions.first().clone();
        fieldCopy.attr("id", "field" + numQuestions);
        var newHtml = fieldCopy.html().replace(/\[poll_questions_attributes\]\[\d+\]/gm, "[poll_questions_attributes][" + numQuestions + "]");
        newHtml = newHtml.replace(/poll_questions_attributes_\d+_/gm, "poll_questions_attributes_" + numQuestions + "_");
        newHtml = newHtml.replace(/Question \d+/gm, "Question " + (numQuestions + 1));
        fieldCopy.html(newHtml);

        // Clear all text areas and checkboxes within the question
        fieldCopy.find("textarea").html("");
        fieldCopy.find("input[type=checkbox]").attr("value", "0");

        $(currentQuestions).last().after(fieldCopy);

        setupAddAnswerButton();
        tryDisableAddQuestionButton();
    });

    setupAddAnswerButton();
});

function setupAddAnswerButton() {
    $("button[data-max-num-answers]").off().click(function () {
        // Determine the answer number
        var currentAnswers = $(this).parent().find("textarea");
        var numAnswers = currentAnswers.length;

        var answerCopy = currentAnswers.first().clone();
        var newName = answerCopy.attr("name").replace(/\[answers_attributes\]\[\d+\]/gm, "[answers_attributes][" + numAnswers + "]");
        var newId = answerCopy.attr("id").replace(/answers_attributes_\d+/gm, "answers_attributes_" + numAnswers);
        answerCopy.attr("name", newName);
        answerCopy.attr("id", newId);

        // Clear any existing contents
        answerCopy.html("");

        $(this).before(answerCopy);
        $(this).before("<br>");

        setupAddAnswerButton();
        tryDisableAddAnswerButton();
    });
}

function tryDisableAddQuestionButton() {
    var numQuestions = $(".question-field").length - 1;

    $("button[data-max-questions]").each(function () {
        var button = $(this);
        if (numQuestions >= parseInt(button.attr("data-max-questions")))
            button.attr("style", "display: none;");
    });
}

function tryDisableAddAnswerButton() {
    $("button[data-max-num-answers]").each(function () {
        var numAnswers = $(this).parent().find("textarea").length;

        if (numAnswers >= parseInt($(this).attr("data-max-num-answers")))
            $(this).attr("style", "display: none;");
    });
}

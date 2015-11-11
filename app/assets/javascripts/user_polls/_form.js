$(document).on("ready page:change", function() {
    // Setup the add question button
    $("button[data-max-num-questions]").off().click(function () {
        var currentQuestions = $(".question-field");
        var numQuestions = currentQuestions.length;
        var defaultNumAnswers = parseInt($(this).attr("data-default-num-answers"));

        // Clone an existing question but replace all the numbers
        var fieldCopy = currentQuestions.first().clone();
        fieldCopy.attr("id", "field" + numQuestions);
        var newHtml = fieldCopy.html().replace(/\[poll_questions_attributes\]\[\d+\]/gm, "[poll_questions_attributes][" + numQuestions + "]");
        newHtml = newHtml.replace(/poll_questions_attributes_\d+_/gm, "poll_questions_attributes_" + numQuestions + "_");
        newHtml = newHtml.replace(/Question \d+/gm, "Question " + (numQuestions + 1));
        fieldCopy.html(newHtml);

        // Delete answers up to the default number of answers
        fieldCopy.find("div.answer-container div.input-group").each(function (index, element) {
             if (index >= defaultNumAnswers)
                 element.remove();
        });

        // Clear the checkboxes within the question
        fieldCopy.find("input[type=checkbox]").attr("value", "0");

        $(currentQuestions).last().after(fieldCopy);

        setupChangeAnswerButtons();
    });

    setupChangeAnswerButtons();
});

function setAnswerIndexNumber(answer, index) {
    var newName = answer.attr("name").replace(/\[answers_attributes\]\[\d+\]/, "[answers_attributes][" + index + "]");
    var newId = answer.attr("id").replace(/answers_attributes_\d+/, "answers_attributes_" + index);
    answer.attr("name", newName);
    answer.attr("id", newId);
}

function setupChangeAnswerButtons() {
    // Setup remove answer button
    $("button[data-min-num-answers]").off().click(function () {
        // Find the answer immediately preceding this button
        var answerToDelete = $(this).parents("div.input-group").first();
        var parent = answerToDelete.parent();
        
        // Adjust the index numbers of the answers after what we're deleting
        var index = parseInt(answerToDelete.find("input[type=text]").attr("name").match(/\[answers_attributes\]\[(\d+)]/)[1]);
        answerToDelete.nextAll("div.input-group").each(function (i, answerToDecrement) {
            answerToDecrement = $(answerToDecrement).find("input[type=text]").first();
            setAnswerIndexNumber(answerToDecrement, index);
            index += 1;
        });

        // Delete the answer
        answerToDelete.remove();

        // Enable the add answer button, and try to disable the remove answer button
        parent.find("button[data-max-num-answers]").prop("disabled", false);
        tryDisableRemoveAnswerButton();
    });

    // Setup add answer buttons
    $("button[data-max-num-answers]").off().click(function () {
        // Find the answer immediately preceding this button
        var answerToCopy = $(this).parents("div.input-group").first();
        var parent = answerToCopy.parent();

        // Now make a clone to insert
        var answerToAdd = answerToCopy.clone();

        // Clear any existing contents in the text field
        answerToAdd.find("input[type=text]").html("");

        // Insert the clone
        answerToCopy.after(answerToAdd);
        
        // Adjust the index numbers of all numbers beyond the answer to copy
        var index = parseInt(answerToCopy.find("input[type=text]").attr("name").match(/\[answers_attributes\]\[(\d+)]/)[1]) + 1;
        answerToCopy.nextAll("div.input-group").each(function (i, answerToIncrement) {
            answerToIncrement = $(answerToIncrement).find("input[type=text]").first();
            setAnswerIndexNumber(answerToIncrement, index);
            index += 1;
        });

        setupChangeAnswerButtons();

        // Enable the remove answer button and try to disable the add answer button
        parent.find("button[data-min-num-answers]").prop("disabled", false);
        tryDisableAddAnswerButton();
    });

    tryDisableRemoveAnswerButton();
    tryDisableAddAnswerButton();
}

function tryDisableRemoveAnswerButton() {
    $("div.answer-container").each(function (index, element) {
        element = $(element)
        var minNumAnswers = parseInt(element.find("button[data-min-num-answers]").attr("data-min-num-answers"));
        var answers = element.find("div.input-group");
        if (answers.length <= minNumAnswers)
            element.find("div.input-group button[data-min-num-answers]").prop("disabled", true);
    });
}

function tryDisableAddAnswerButton() {
    $("div.answer-container").each(function (index, element) {
        element = $(element)
        var maxNumAnswers = parseInt(element.find("button[data-max-num-answers]").attr("data-max-num-answers"));
        var answers = element.find("div.input-group");
        if (answers.length >= maxNumAnswers)
            element.find("div.input-group button[data-max-num-answers]").prop("disabled", true);
    });
}

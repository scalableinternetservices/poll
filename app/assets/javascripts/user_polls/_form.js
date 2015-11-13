$(document).on("ready page:change", function() {
    setupChangeQuestionButtons();
    setupChangeAnswerButtons();
});

function setQuestionIndexNumber(question, index) {
    var newId = question.attr("id").replace(/field\d+/gm, "field" + index);
    var newHtml = question.html().replace(/\[poll_questions_attributes\]\[\d+\]/gm, "[poll_questions_attributes][" + index + "]");
    newHtml = newHtml.replace(/poll_questions_attributes_\d+_/gm, "poll_questions_attributes_" + index + "_");
    newHtml = newHtml.replace(/Question \d+/gm, "Question " + (index + 1));

    // Because we directly replace all the HTML, we need to save the input values
    // for each of the input fields, otherwise it gets overwritten
    textValues = [];
    question.find("input[type=text]").each(function (index, element) {
        textValues.push($(element).val());
    });
    checkboxValues = []
    question.find("input[type=checkbox]").each(function (index, element) {
        checkboxValues.push($(element).prop("checked"));
    });

    question.attr("id", newId);
    question.html(newHtml);

    // Restore the input values of each of the inputs
    question.find("input[type=text]").each(function (index, element) {
        $(element).val(textValues[index]);
    });
    question.find("input[type=checkbox]").each(function (index, element) {
        $(element).prop("checked", checkboxValues[index]);
    });
}

function setupChangeQuestionButtons() {
    // Setup the remove question button
    $("button[data-min-num-questions]").off().click(function() {
        var questionToDelete = $(this).parents(".question-field");
        
        // Reduce the question index number of all questions after this one
        questionToDelete.nextAll(".question-field").each(function (index, element) {
            element = $(element);
            var currentId = parseInt(element.attr("id").match(/field(\d+)/)[1]);
            setQuestionIndexNumber(element, currentId - 1);
        });

        // Delete the question
        questionToDelete.remove();
        
        // The button handlers get overwritten when we do our regex search and replace,
        // so re-apply them
        setupChangeQuestionButtons();
        setupChangeAnswerButtons();
    });

    // Setup the add question button
    $("button[data-max-num-questions]").off().click(function () {
        var clickedQuestion = $(this).parents(".question-field");
        var indexToAdd = parseInt(clickedQuestion.attr("id").match(/field(\d+)/)[1]) + 1;
        var defaultNumAnswers = parseInt($(this).attr("data-default-num-answers"));

        // Clone an existing question reset the answers to the default
        var questionCopy = clickedQuestion.first().clone();
        questionCopy.find("div.answer-container div.input-group").each(function (index, element) {
            if (index >= defaultNumAnswers)
                $(element).remove();
            else {
                $(element).find("input[type=text]").val("");
            }
        });

        // Clear the checkboxes within the question
        questionCopy.find("input[type=checkbox]").prop("checked", false);

        // Replace
        setQuestionIndexNumber(questionCopy, indexToAdd);

        // Add the question and update the indices of every question after
        clickedQuestion.first().after(questionCopy);
        questionCopy.nextAll(".question-field").each(function (index, element) {
            element = $(element);
            var currentId = parseInt(element.attr("id").match(/field(\d+)/)[1]);
            setQuestionIndexNumber(element, currentId + 1);
        });

        setupChangeQuestionButtons();
        setupChangeAnswerButtons();
    });
}

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

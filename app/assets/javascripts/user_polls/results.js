$(document).on("ready page:change", function() {
    // For each canvas, query to get the data to render
    $("canvas[data-poll-id]").each(function() {
        var element = this;
        $.get("/user_polls/" + $(this).attr("data-poll-id") + "/poll_details",
              null,
              function(data) {
                  renderPollData(element, data);
              },
              "json");
    });

    $("canvas[data-question-id]").each(function() {
        var element = this;
        $.get("/user_polls/" + $(this).attr("data-question-id") + "/question_details",
              null,
              function(data) {
                  renderQuestionData(element, data);
              },
              "json");
    });
});

function renderPollData(canvas, data) {
    if (canvas.getContext) {
        var context = canvas.getContext("2d");
        var plotY = 32;
        var plotHeight = canvas.height - 64;

        // Render the labels
        context.fillStyle = "#000000";
        context.font = "16px Times New Roman";
        context.fillText("Votes over time", 0, 12, 100);

        var startDate = new Date(data.time_range[0] * 1000);
        var endDate = new Date(data.time_range[1] * 1000);
        context.fillText(startDate.getMonth() + "/" + startDate.getDate(), 0, plotY + plotHeight + 16);
        var endDateText = endDate.getMonth() + "/" + endDate.getDate();
        var endDateWidth = context.measureText(endDateText).width
        context.fillText(endDateText, canvas.width - endDateWidth, plotY + plotHeight + 16);

        // Render the time plot
        var xSpacing = canvas.width / (data.vote_counts.length - 1);

        var maxCount = data.vote_counts[0];
        for (var i = 1; i < data.vote_counts.length; i++)
            if (data.vote_counts[i] > maxCount)
                maxCount = data.vote_counts[i];

        context.fillStyle = "#0000FF";
        var firstY = plotHeight * (1 - data.vote_counts[0] / maxCount) + plotY;
        context.moveTo(0, firstY);

        for (var i = 1; i < data.vote_counts.length; i++) {
            var y = plotHeight * (1 - data.vote_counts[i] / maxCount) + plotY;

            context.lineTo(i * xSpacing, y);
        }

        context.lineTo((data.vote_counts.length - 1) * xSpacing, plotY + plotHeight);
        context.lineTo(0, plotY + plotHeight);
        context.lineTo(0, firstY);

        context.fill();
    }
}

function renderQuestionData(canvas, data) {
    if (canvas.getContext) {
        var context = canvas.getContext("2d");

        context.fillStyle = "#000000";
        context.font = "16px Times New Roman";

        // Set the label width to the width of the largest label, capped to 120px
        var labelWidth = 0;
        for (var i = 0; i < data.answer_texts.length; i++)
            labelWidth = Math.max(labelWidth, context.measureText(data.answer_texts[i]).width);
        labelWidth = Math.min(labelWidth, 120);

        // Draw the labels
        for (var i = 0; i < data.answer_texts.length; i++)
            context.fillText(data.answer_texts[i], 0, 32 * i + 12, labelWidth);

        // Determine the required size of the number labels, which determines the bar lengths
        var maxNumberLabelWidth = 0;
        for (var i = 0; i < data.vote_counts.length; i++)
            maxNumberLabelWidth = Math.max(maxNumberLabelWidth, context.measureText(data.vote_counts[i].toString()).width);

        // Draw the bars and number labels
        var maxVotes = 1;
        var maxBarWidth = canvas.width - labelWidth - 8 - maxNumberLabelWidth - 8;
        for (var i = 0; i < data.vote_counts.length; i++)
            if (data.vote_counts[i] != null)
                maxVotes = Math.max(maxVotes, data.vote_counts[i]);
        for (var i = 0; i < data.vote_counts.length; i++) {
            var barWidth = maxBarWidth * data.vote_counts[i] / maxVotes;
            var barX = labelWidth + 8;

            context.fillStyle = "#992222";
            context.fillRect(barX, 32 * i, barWidth, 16);

            context.fillStyle = "#000000";
            context.fillText(data.vote_counts[i].toString(), barX + barWidth + 8, 32 * i + 12);
        }
    }
}

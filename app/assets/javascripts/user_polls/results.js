$(document).on("ready page:change", function() {
    // For each canvas, query to get the data to render
    $("canvas[data-question-id]").each(function() {
        var element = this;
        $.get("/user_polls/" + $(this).attr("data-question-id") + "/question_details",
              null,
              function(data) {
                  renderData(element, data);
              },
              "json");
    });
});

function renderData(canvas, data) {
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

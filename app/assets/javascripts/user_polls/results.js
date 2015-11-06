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

        context.fillStyle = "rgb(255, 0, 0)";
        context.fillRect(0, 0, 100, 100);
    }
}

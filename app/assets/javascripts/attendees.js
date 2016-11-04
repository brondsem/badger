$("td[data-checked-in]").on("click", function() {
  $this = $(this);
  $.ajax({
    url: $(this).data("url"),
    type: "POST"
  }).done(function(data, textStatus, jqXHR) {
    $this.attr("data-checked-in", data.checked_in);
  });
});

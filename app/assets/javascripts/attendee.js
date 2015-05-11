$("input[id=q_first_name_or_last_name_cont]").on("keyup", function() {
  $(this).closest("form").submit();
});

$("input[id=attendee_checked_in]").on("change", function() {
  console.log("checked in")
  $(this).closest("form").submit();
});

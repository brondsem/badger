$("input[id=q_first_name_or_last_name_cont]").on("keyup", function() {
  $(this).closest("form").submit();
});

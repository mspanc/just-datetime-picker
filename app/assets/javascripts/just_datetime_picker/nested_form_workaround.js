$('body.active_admin a.button').live('click', function() {
  $('input.datepicker:not(.hasDatepicker)').datepicker();
});


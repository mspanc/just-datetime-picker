// Workaround that enables date picker for fields in nested forms.
// By default ActiveAdmin enables date picker once, after the page
// has been loaded, so all datepicker fields created afterwards
// are dead by default.
//
// We attach to a.button to catch a moment where user can potentially
// add new field like this in a nested form.
$(document).on('click', 'body.active_admin a.button', function() {
  $('input.datepicker:not(.hasDatepicker)').datepicker();
});


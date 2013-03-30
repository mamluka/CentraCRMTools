$(function () {
    $('form').validate({
        highlight: function (label) {
            $(label).closest('.control-group').addClass('error');
        },
        success: function (label) {
            label.text('OK!').addClass('valid')
                .closest('.control-group').addClass('success');
        }
    });
})

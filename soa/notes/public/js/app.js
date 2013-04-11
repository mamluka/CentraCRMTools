$.validator.messages.required = '';
$('#noteForm').validate({
    submitHandler: function () {
        $('#noteForm').ajaxSubmit(function () {
            $.pm({target: window.parent, type: 'close-dialog'})
        });
    }
});

$('#subjectList').change(function () {
    if (this.options.selectedIndex > 0) {
        $('input[name=subject]').val($(this).val());
        $("#noteForm").validate().element("input[name=subject]");
    }

});
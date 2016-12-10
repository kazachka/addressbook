var showAlert = function() {
    jQuery("#alert").modal("show");
}

var showModal = function(onModalYesClick, arg) {
    jQuery("#modalYes").click(function() {
        onModalYesClick(arg);
    });
    jQuery("#deleteModal").modal("show");
}

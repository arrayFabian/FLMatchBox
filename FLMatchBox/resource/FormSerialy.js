
function FormsSerialy() {
    this.formSerialyByID = function (ID) {
        var fields = $("#" + ID + " input,#" + ID + " select,#" + ID + " textarea").serializeArray();
        var result = "";
        jQuery.each(fields, function (i, field) {
            var keyValue = field.value.replace('\\', "\\\\");
            keyValue = keyValue.replace('"', "\\\"");
            keyValue = keyValue.replace(" ", "");
            result += '"' + field.name + '":"' + keyValue + '",';
        });
        return result;
    }

    this.formSerialyByClass = function (Class) {
        var fields = $("." + Class + " input,." + Class + " select,." + Class + " textarea").serializeArray();
        var result = "";
        jQuery.each(fields, function (i, field) {
            var keyValue = field.value.replace('\\', "\\\\");
            keyValue = keyValue.replace('"', "\\\"");
            keyValue = keyValue.replace(" ", "");
            result += '"' + field.name + '":"' + keyValue + '",';
        });
        return result;
    }
}

var formsSerialy = new FormsSerialy();
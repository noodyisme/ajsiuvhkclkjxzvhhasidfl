function fn(workflowResponse) {
    var Base64 = Java.type('java.util.Base64');
    var String = Java.type('java.lang.String');
    var decoded = Base64.getDecoder().decode(workflowResponse);
    return new String(decoded);
}

function Log() {
    this.traceLevel = Log.traceLevel;
    this.debug = Log.debug;
    this.info = Log.info;
    this.error = Log.error;
    this.alert = Log.alert;
    this.confirm = Log.confirm;
}

// 1 = Error, 2 = Warning, 3 = Info, 4 = Verbose
Log.traceLevel = 4;

Log.debug = function (msg) {
    if (console && Log.traceLevel == 4) console.log(new Date().toTimeString() + "：" + msg);
};

Log.info = function (msg) {
    if (console && Log.traceLevel > 2) console.log(new Date().toTimeString() + "：" + msg);
};

Log.error = function (msg, showerror) {
    if (console) console.log(new Date().toTimeString() + "：" + msg);

    if (showerror) Log.alert(msg);
};

Log.alert = function (msg) {
    alert(msg);
}

Log.confirm = function (msg) {
    return confirm(msg, "提示");
}

if (top.log) {
    var log = top.log;
}
else {
    var log = new Log();
    top.log = log;
}
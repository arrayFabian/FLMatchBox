/// <reference path="../Scripts/jquery-1.5.1.min.js" />


//全局
var crossDomainUrl = 'http://10.0.1.112/NoCAWeb/';

var scripts = document.getElementsByTagName("script");
if (scripts[scripts.length - 1].innerHTML) eval(scripts[scripts.length - 1].innerHTML);

function getRootPath() {
    var strFullPath = document.location.href;
    var strPath = document.location.pathname;

    var pos = strFullPath.indexOf(strPath);
    var prePath = strFullPath.substring(0, pos);
    var postPath = strPath.substring(0, strPath.substr(1).indexOf('/') + 1);

    //    console.log("webroot:" + prePath + postPath);
    return (prePath + postPath);
}



function init() {
    if (!top.webRoot) {
        top.webRoot = getRootPath();
    }

   // document.write('<script src="../JsHtcCss/jQuery/jquery-1.5.1.min.js" type="text/javascript"></script>'.replace("..", top.webRoot));

    if (top.log) {
        var log = top.log;
    }
    else {
     //   document.write('<script src="../JsHtcCss/log.js" type="text/javascript"></script>'.replace("..", top.webRoot));
    }
}

init();



//---------------------------------------------------  
// 日期格式化  
// 格式 YYYY/yyyy/YY/yy 表示年份  
// MM/M 月份  
// W/w 星期  
// dd/DD/d/D 日期  
// hh/HH/h/H 时间  
// mm/m 分钟  
// ss/SS/s/S 秒  
//---------------------------------------------------  
Date.prototype.Format = function (formatStr) {
    var str = formatStr;
    var Week = ['日', '一', '二', '三', '四', '五', '六'];

    str = str.replace(/yyyy|YYYY/, this.getFullYear());
    str = str.replace(/yy|YY/, (this.getYear() % 100) > 9 ? (this.getYear() % 100).toString() : '0' + (this.getYear() % 100));

    str = str.replace(/MM/, this.getMonth() > 9 ? this.getMonth().toString() : '0' + this.getMonth());
    str = str.replace(/M/g, this.getMonth());

    str = str.replace(/w|W/g, Week[this.getDay()]);

    str = str.replace(/dd|DD/, this.getDate() > 9 ? this.getDate().toString() : '0' + this.getDate());
    str = str.replace(/d|D/g, this.getDate());

    str = str.replace(/hh|HH/, this.getHours() > 9 ? this.getHours().toString() : '0' + this.getHours());
    str = str.replace(/h|H/g, this.getHours());
    str = str.replace(/mm/, this.getMinutes() > 9 ? this.getMinutes().toString() : '0' + this.getMinutes());
    str = str.replace(/m/g, this.getMinutes());

    str = str.replace(/ss|SS/, this.getSeconds() > 9 ? this.getSeconds().toString() : '0' + this.getSeconds());
    str = str.replace(/s|S/g, this.getSeconds());

    return str;
}



function ClearForm(ElementID) {
    $("#" + ElementID + " input").each(function () {
        $(this).val("");
    })
}


function GetRequest() {
    var url = location.search; //获取url中"?"符后的字串
    var theRequest = new Object();
    if (url.indexOf("?") != -1) {
        var str = url.substr(1);
        strs = str.split("&");
        for (var i = 0; i < strs.length; i++) {
            theRequest[strs[i].split("=")[0]] = unescape(strs[i].split("=")[1]);
        }
    }
    return theRequest;
}

//var Request = new Object();
//Request = GetRequest();
//var 参数1, 参数2, 参数3, 参数N;
//参数1 = Request['参数1'];
//参数2 = Request['参数2'];
//参数3 = Request['参数3'];
//参数N = Request['参数N'];

/*-----------指向另外一个Url地址-----------*/
function Redirect(objUrl) {
    window.location.href = objUrl;
}


/*------设置默认值------*/
function setDefaultValue() {
    $("body .defaultValue").each(function () {
        var isValue = $(this).val();
        if (isValue == "") $(this).val("0");
    })
}
/*------设置默认值------*/



/* 确认框全选 */
function CheckAll() {
    var chk = event.srcElement;
    var list = document.documentElement.getElementsByTagName("input");
    if (chk.checked) {
        for (var i = 0; i < list.length; i++) {
            if (list[i].type == "checkbox" && !(list[i].checked)) {
                list[i].checked = true;
            }
        }
    }

    else {
        for (var i = 0; i < list.length; i++)
            if (list[i].type == "checkbox" && list[i].checked) {
                list[i].checked = false;
            }
    }
}
/* 确认框全选 */


/*检查数组是否包含某个字符串*/
function string_array(a, v) {
    var i;
    for (i = 0; i < a.length; i++) {
        if (v == a[i]) {
            return i;
        }
    }
    return -1;
} // 返回-1表达没找到，返回更多相关值表达找到的索引
/*检查数组是否包含某个字符串*/


//Guid生成器
function guidGenerator() {
    var S4 = function () { return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1); };
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}
//Guid生成器



//onLineStateCheck
function stateCheckBox(top) {
    var Width = $("body").width();
    var Height = $("body").height();
    var StateBoxWidth = $("#StateShow").width();
    $("#StateShow").css("left", Width / 2 - StateBoxWidth / 2);
    $("#StateShow").css("top", top);
    if (navigator.onLine) $("#StateShow").html("网络状态：在线...");
    else $("#StateShow").html("网络状态：离线...");
}
$(document).ready(function () {
    //获取音频工具 
    var audio = document.getElementById("myMusic"); 


    //开始，暂停按钮
    $("#MainControl")._toggle(function () {
        $(this).removeClass("MainControl").addClass("StopControl");
        if (audio.src == "") {
            var Defaultsong = $(".Single .SongName").eq(0).attr("KV");
            $(".MusicBox .ProcessControl .SongName").text(Defaultsong);
            $(".Single .SongName").eq(0).css("color", "#7A8093");
            audio.src = "../Media/" + Defaultsong + ".mp3";
        }
        audio.play();
        TimeSpan();
    }, function () {
        $(this).removeClass("StopControl").addClass("MainControl");
        audio.pause();
    });


    //歌曲列表的选择操作
    $(".MusicList .List .Single .SongName").click(function () {
        $(".MusicList .List .Single .SongName").css("color", "#fff");
        $("#MainControl").removeClass("MainControl").addClass("StopControl");
        $(this).css("color", "#7A8093");
        var SongName = $(this).attr("KV");
        $(".MusicBox .ProcessControl .SongName").text(SongName);
        audio.src = "../Media/" + SongName + ".mp3";
        audio.play();
        TimeSpan();
    });

    //左前进按钮
    $(".LeftControl").click(function () {
        $(".MusicList .List .Single .SongName").each(function () {
            if ($(this).css("color") == "rgb(122, 128, 147)") {
                var IsTop = $(this).parent(".Single").prev(".Single").length == 0 ? true : false;  //检查是否是最顶端的歌曲
                var PrevSong;
                if (IsTop) {
                    PrevSong = $(".Single").last().children(".SongName").attr("KV");
                    $(".Single").last().children(".SongName").css("color", "#7A8093");
                }
                else {
                    PrevSong = $(this).parent(".Single").prev(".Single").children(".SongName").attr("KV");
                    $(this).parent(".Single").prev(".Single").children(".SongName").css("color", "#7A8093");
                }

                audio.src = "../Media/" + PrevSong + ".mp3";
                $(".MusicBox .ProcessControl .SongName").text(PrevSong);
                $(this).css("color", "#fff");
                audio.play();
                return false; //代表break
            }
        })
    });

    //右前进按钮
    $(".RightControl").click(function () {
        $(".MusicList .List .Single .SongName").each(function () {
            if ($(this).css("color") == "rgb(122, 128, 147)") {
                var IsBottom = $(this).parent(".Single").next(".Single").length == 0 ? true : false;  //检查是否是最尾端的歌曲
                var NextSong;
                if (IsBottom) {
                    NextSong = $(".Single").first().children(".SongName").attr("KV");
                    $(".Single").first().children(".SongName").css("color", "#7A8093");
                }
                else {
                    NextSong = $(this).parent(".Single").next(".Single").children(".SongName").attr("KV");
                    $(this).parent(".Single").next(".Single").children(".SongName").css("color", "#7A8093");
                }

                audio.src = "../Media/" + NextSong + ".mp3";
                $(".MusicBox .ProcessControl .SongName").text(NextSong);
                $(this).css("color", "#fff");
                audio.play();
                return false; //代表break
            }
        })
    });

    //静音按钮
    $(".VoiceEmp").click(function () {
        $(".VoidProcessYet").css("width", "0");
        audio.volume = 0;
    });

    //满音量按钮
    $(".VoiceFull").click(function () {
        $(".VoidProcessYet").css("width", "66px");
        audio.volume = 1;
    });

    /*
    之前一直考虑进度条的原理，这边进度条的做法启发自腾讯一款播放器的做法，采用两个2px高度的div，重叠，
    上面那个与下面那个div的颜色不一样，用于区分进度,顶层div的width是根据播放的长度来调整的，width越长，说明播放越长，
    知道上层的div完全覆盖下面的div，达到长度的一致，说明播放完毕。我们的播放进度条和音量进度条都是这样做的
    */

    // 音频进度条事件（进度增加）
    $(".Process").click(function (e) {

        //播放进度条的基准参数
        var Process = $(".Process").offset();
        var ProcessStart = Process.left;
        var ProcessLength = $(".Process").width();


        var CurrentProces = e.clientX - ProcessStart;
        DurationProcessRange(CurrentProces / ProcessLength);
        $(".ProcessYet").css("width", CurrentProces);
    });

    //音频进度条事件（进度减少）
    $(".ProcessYet").click(function (e) {

        //播放进度条的基准参数
        var Process = $(".Process").offset();
        var ProcessStart = Process.left;
        var ProcessLength = $(".Process").width();

        var CurrentProces = e.clientX - ProcessStart;
        DurationProcessRange(CurrentProces / ProcessLength);
        $(".ProcessYet").css("width", CurrentProces);
    });

    //音量进度条事件（进度增加）
    $(".VoidProcess").click(function (e) {
        //音量进度条的基准参数
        var VoidProcess = $(".VoidProcess").offset();
        var VoidProcessStart = VoidProcess.left;
        var VoidProcessLength = $(".VoidProcess").width();

        var CurrentProces = e.clientX - VoidProcessStart;
        VolumeProcessRange(CurrentProces / VoidProcessLength);
        $(".VoidProcessYet").css("width", CurrentProces);
    });

    //音量进度条时间（进度减少）
    $(".VoidProcessYet").click(function (e) {
        //音量进度条的基准参数
        var VoidProcess = $(".VoidProcess").offset();
        var VoidProcessStart = VoidProcess.left;
        var VoidProcessLength = $(".VoidProcess").width();

        var CurrentProces = e.clientX - VoidProcessStart;
        VolumeProcessRange(CurrentProces / VoidProcessLength);
        $(".VoidProcessYet").css("width", CurrentProces);
    });

    //显示音乐列表事件
    $(".ShowMusicList").toggle(function () {
        $(".MusicList").show();

        var MusicBoxRight = $(".MusicBox").offset().left + $(".MusicBox").width();
        var MusicBoxBottom = $(".MusicBox").offset().top + $(".MusicBox").height();
        $(".MusicList").css("left", MusicBoxRight - $(".MusicList").width());
        $(".MusicList").css("top", MusicBoxBottom + 15);
    }, function () {
        $(".MusicList").hide();
    });


    //监听媒体文件结束的事件（ended），这边一首歌曲结束就读取下一首歌曲，实现播放上的循环播放
    audio.addEventListener('ended', function () {
        $(".MusicList .List .Single .SongName").each(function () {
            if ($(this).css("color") == "rgb(122, 128, 147)") {
                var IsBottom = $(this).parent(".Single").next(".Single").length == 0 ? true : false;  //检查是否是最尾端的歌曲
                var NextSong;
                if (IsBottom) {
                    NextSong = $(".Single").first().children(".SongName").attr("KV");
                    $(".Single").first().children(".SongName").css("color", "#7A8093");
                }
                else {
                    NextSong = $(this).parent(".Single").next(".Single").children(".SongName").attr("KV");
                    $(this).parent(".Single").next(".Single").children(".SongName").css("color", "#7A8093");
                }

                audio.src = "../Media/" + NextSong + ".mp3";
                $(".MusicBox .ProcessControl .SongName").text(NextSong);
                $(this).css("color", "#fff");
                audio.play();
                return false; //代表break
            }
        });
    }, false);


});

//音量进度条的转变事件
function VolumeProcessRange(rangeVal) {
    var audio = document.getElementById("myMusic");
    audio.volume = parseFloat(rangeVal);
}

//播放进度条的转变事件
function DurationProcessRange(rangeVal) {
    var audio = document.getElementById("myMusic");
    audio.currentTime = rangeVal * audio.duration;
    audio.play();
}

//播放事件
function Play(obj) {
    var SongUrl = obj.getAttribute("SongUrl");
    var audio = document.getElementById("myMusic");
    audio.src = "../Media/" + SongUrl + ".mp3";
    audio.play();
    TimeSpan();
}

//暂停事件
function Pause() {
    var audio = document.getElementById("myMusic");
    $("#PauseTime").val(audio.currentTime);
    audio.pause();
}

//继续播放事件
function Continue() {
    var audio = document.getElementById("myMusic");
    audio.startTime = $("PauseTime").val();
    audio.play();
}

//时间进度处理程序
function TimeSpan() {
    var audio = document.getElementById("myMusic");
    var ProcessYet = 0;
    setInterval(function () {
        var ProcessYet = (audio.currentTime / audio.duration) * 500;
        $(".ProcessYet").css("width", ProcessYet);
        var currentTime = timeDispose(audio.currentTime);
        var timeAll = timeDispose(TimeAll());
        $(".SongTime").html(currentTime + "&nbsp;|&nbsp;" + timeAll);
    }, 1000);
}

//时间处理，因为时间是以为单位算的，所以这边执行格式处理一下
function timeDispose(number) {
    var minute = parseInt(number / 60);
    var second = parseInt(number % 60);
    minute = minute >= 10 ? minute : "0" + minute;
    second = second >= 10 ? second : "0" + second;
    return minute + ":" + second;
}

//当前歌曲的总时间
function TimeAll() {
    var audio = document.getElementById("myMusic");
    return audio.duration;
}
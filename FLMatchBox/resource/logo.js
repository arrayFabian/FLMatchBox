$(document).ready(function () {
    var canvas = document.getElementById("logo");
    if (canvas.getContext) {
        var ctx = canvas.getContext("2d");
        ctx.arc(17, 17, 15, 0, 9.42, true); // Create the arc path.
        ctx.lineWidth = 3;
        ctx.lineJoin = 'bevel';
        ctx.lineCap = 'bevel';
        ctx.strokeStyle = '#23A1DD';

        ctx.shadowBlur = 4;
        ctx.shadowColor = '#909090';
        ctx.shadowOffsetX = 1;
        ctx.shadowOffsetY = 1;


        ctx.moveTo(41, 35); //Create the F
        ctx.lineTo(41, 2);
        ctx.lineTo(61, 2);
        ctx.moveTo(41, 15);
        ctx.lineTo(71, 15);

        ctx.moveTo(77, -1); //Create the L
        ctx.lineTo(77, 32);
        ctx.lineTo(102, 32);


        ctx.moveTo(103, 34); //Create the M
        ctx.lineTo(103, 0);
        ctx.lineTo(120, 20);
        ctx.lineTo(137, 0);
        ctx.lineTo(137, 34);

        ctx.stroke();
        ctx.save();

        ctx.beginPath(); //Create Imge Star
        ctx.moveTo(145, 2);
        var img1 = new Image();
        img1.src = "../Images/1.png";
        img1.onload = function () {
            ctx.drawImage(img1, 145, 2);
            ctx.stroke();
            ctx.save();
        }

        ctx.beginPath(); //Create the I
        ctx.shadowBlur = 4;
        ctx.shadowOffsetX = 0;
        ctx.shadowOffsetY = 0;

        ctx.moveTo(202, 3);
        ctx.strokeStyle = '#23A1DD';
        ctx.fillStyle = '#23A1DD';
        ctx.arc(185, 3, 3, 0, Math.PI * 2, true);
        ctx.fill();
        ctx.save();

        ctx.beginPath();
        ctx.moveTo(185, 35);
        ctx.lineTo(185, 10);

        ctx.moveTo(200, 0);
        ctx.lineTo(200, 33);
        ctx.lineTo(222, 33);
        ctx.save();
        ctx.stroke();

//        ctx.beginPath();

//        ctx.shadowBlur = 1;
//        ctx.shadowOffsetX = 0;
//        ctx.shadowOffsetY = 0;


//        // The font will be 60 pixel, Impact face
//        ctx.font = "15px impact";
//        //ctx.font = "12px arial,sans-serif";
//        // Use a brown fill for our text
//        ctx.fillStyle = '#23A1DD';
//        // Text can be aligned when displayed
//        ctx.textAlign = 'left';

//        // Draw the text in the middle of the canvas with a max
//        // width set to center properly
//        ctx.fillText('Hello , Ben!', 230, 12, 300);
//        ctx.restore();

//        ctx.fillStyle = '#FEBB05';
//        ctx.shadowBlur = 0;
//        ctx.font = "12px arial,sans-serif";
//        ctx.fillText("OffLine Report System!", 230, 30, 300);
      //  ctx.restore();
    }
})
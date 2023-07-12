$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type === "OpenReception"){
            $('.MotelMain').fadeIn(500);
            $('#MotelId').html(event.data.MotelId);
            $('#MotelName').html(event.data.MotelName);
            $('#MotelName2').html(event.data.MotelName+' <br><font style="font-size: 1.5vh; font-weight: 600;">Toplam Oda: '+event.data.toplamoda+'</html>');
            $('.MotelMain').css('background-image', 'url('+ event.data.MotelPNG + ')');
            let htmlYazi = ""
            let htmlYazi2 = ""
            for (let data = 0; data < event.data.data.length; data++) {
                const element = event.data.data[data];
                if (element.Owner == null) {
                    htmlYazi = htmlYazi + `
                    <div id="KiralamaServisi" data-motelid="${event.data.MotelId}" data-motelname="${event.data.MotelName}" data-odafiyat="${event.data.RoomPrice}" data-id="${data+1}" class="NewOda">
                        <p>ROOM ${data+1}</p>
                        <h4 class="minitext">EMPTY</h4>
                    </div>
                `  
                } else {
                    htmlYazi = htmlYazi + `
                    <div class="NewOda">
                        <p>ROOM ${data+1}</p>
                        <h4 class="minitext">FULL</h4>
                    </div>
                    `  
                }
                
            }
            if (event.data.PMotelTable != null) {
                for (let data2 = 0; data2 < event.data.PMotelTable.length; data2++) {
                    const veri = event.data.PMotelTable[data2];
                        htmlYazi2 = htmlYazi2 + `
                        <div class="MyOdaSelect">
                            <p class="anamanam">ROOM ${veri.roomid}</p>
                            <P class="anamanam2">${event.data.LeftMotelName}</P>
                            <button id="LeftOrospu" data-odaid="${veri.roomid}" data-sahip="${veri.owner}" class="LeftMotelButton" type="button">Cancel Room</button>
                            <button id="ReKey" data-odaid="${veri.roomid}" class="LeftMotelButton" type="button">Copy Key</button>
                        </div>
                    `  
                }
            }
            $(".MyMotelRooms").html(htmlYazi2)
            $(".MotelDashboard").html(htmlYazi)
        } else if (event.data.type === "CloseReception"){
            TumunuKapat();
            $.post('http://kibra-motels/CloseReception', JSON.stringify({}));
        }
    });
});


function TumunuKapat() {
    $(".MotelMain").hide();
    $(".MotelOdalar").hide();   
    $(".MotelOdalarList").hide();   
    $(".MotelSelectRoom").hide();                    
}
  

$(document).on('click','#KapatResepsiyon',function(e){
    e.preventDefault();
    TumunuKapat();
    $.post('http://kibra-motels/CloseReception', JSON.stringify({}));
})

$(document).on('click','#KapatRecepsiyon2',function(e){
    e.preventDefault();
    $('.MotelOdalar').fadeOut(500);
    $.post('http://kibra-motels/CloseReception2', JSON.stringify({}));
})

$(document).on('click','#KapatResepsiyon2',function(e){
    e.preventDefault();
    $('.MotelOdalarList').fadeOut(500);
    $.post('http://kibra-motels/CloseReception', JSON.stringify({}));
})

$(document).on('click','#KapatResepsiyon2',function(e){
    e.preventDefault();
    $('.MotelOdalarList').fadeOut(500);
    $.post('http://kibra-motels/CloseReception', JSON.stringify({}));
})

$(document).on('click','#MotelOdalar',function(e){
    e.preventDefault();
    $('.MotelMain').hide();
    $('.MotelOdalar').fadeIn(500);
})

$(document).on('click','#MotelOdalarList',function(e){
    e.preventDefault();
    $('.MotelMain').hide();
    $('.MotelOdalarList').fadeIn(500);
})

$(document).on('click','#LeftOrospu',function(e){
    e.preventDefault();
    motelroomandmotel = $(this).attr("data-odaid")
    odasahip = $(this).attr("data-sahip")
    $.post('http://kibra-motels/LeftMotelRoom', JSON.stringify({
        RoomNo: motelroomandmotel,
        OdaSahip: odasahip,
    })); 
})

$(document).on('click','#ReKey',function(e){
    e.preventDefault();
    motelid = $(this).attr("data-odaid")
    $.post('http://kibra-motels/CopyMotelKeyRoom', JSON.stringify({
        RoomNo: motelid,
    })); 
})

$(document).on('click','#KiralamaServisi',function(e){
    e.preventDefault();
    $('.MotelSelectRoom').fadeIn(500);
    odaid = $(this).attr("data-id");
    motelad = $(this).attr("data-motelname");
    odafiyat = $(this).attr("data-odafiyat");
    motelid = $(this).attr("data-motelid");
    let mindex = "";
    mindex = mindex + 
    `<div id="NewSayfa">
        <button class="MotelSelectClose" type="button">x</button>
        <h1 class="MotelSozlesmeTittle">Motel Agreement</h1>
        <p class="MotelSelectName">Motel Name: <span id="OdaFiyat" class="Kalin">${motelad}</span></p>
        <p class="MotelSelectName">Room number: <span id="OdaFiyat" class="Kalin">${odaid}</span></p>
        <p class="MotelSelectName">Room Rental Fee: <span id="OdaFiyat" class="Kalin">$${odafiyat}</span></p>
        <button id="KiralaOrospu" data-motelid="${motelid}" data-odaid="${odaid}" data-odaprice="${odafiyat}"class="KiralaButton" type="button">Rent a Room</button>
    </div> `
    $(".MotelSelectRoom").html(mindex);
})

$(document).on('click','#KiralaOrospu',function(e){
    e.preventDefault();
    odaid = $(this).attr("data-odaid")
    odaprice = $(this).attr("data-odaprice")
    motelid = $(this).attr("data-motelid")
    $.post('http://kibra-motels/BuyMotelRoom', JSON.stringify({
        RoomNo: odaid,
        OdaFiyat: odaprice,
        MotelId: motelid
    })); 
})
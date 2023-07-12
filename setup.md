If you are going to use the metadata feature, find the FormatItemInfo function in the qb-inventory/js/app.js file and add this line below.


Items: 
	['motelkey'] 			 		 = {['name'] = 'motelkey', 			  			['label'] = 'Motel Key', 			['weight'] = 0, 		['type'] = 'item', 		['image'] = 'motelkey.png', 			['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Motel Key'},

JS:
qb-inventory/js/app.js

} else if (itemData.name == "motelkey") {
            $(".item-info-title").html('<p>'+itemData.label+'</p>')
            $(".item-info-description").html('<p><strong></strong><span>Room No : ' + itemData.info.MotelRoomUnreal + '</span></p><p><strong></strong><span>Motel Name: ' + itemData.info.MotelName + '</span></p><p>');


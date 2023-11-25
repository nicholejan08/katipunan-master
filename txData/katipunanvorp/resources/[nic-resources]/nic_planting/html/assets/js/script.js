
window.addEventListener('message', (event) => {
	var menu = event.data

	// if (menu.message == null) {
	// 	$(".main").fadeOut();
	// 	$(".c-button").hide();
	// 	$(".symbol_01").hide();
	// 	$(".side-gradient").hide();
	// 	$.post('http://player_menu/player_menu_close', JSON.stringify({})
	//   );
	// } else if (menu.message == "main") {
	// 	$(".main").show();
	// 	$(".c-button").hide();
	// 	$(".symbol_01").hide();
	// 	$(".side-gradient").show();
	// 	$.post('http://player_menu/player_menu_open', JSON.stringify({})
    //     );
	// }

    // $(".action").mouseover(function(){
	// 	$.post('http://player_menu/player_menu_hover', JSON.stringify({})
	//   );
	// });
    
    // $("#close").unbind().click(function(){
	// 	$(".main").fadeOut();
	// 	$.post('http://player_menu/player_menu_close', JSON.stringify({}));
	// });

});

// close via backspace or escape

// $(document).keydown(e => {
// 	var code = e.keyCode || e.which;
// 	if(code == 8 || code == 27) { 
// 		$.post('http://player_menu/player_menu_close', JSON.stringify({}), () => { console.log("finish")}) ;
// 		$(".main").fadeOut();
// 	}
//   });
  


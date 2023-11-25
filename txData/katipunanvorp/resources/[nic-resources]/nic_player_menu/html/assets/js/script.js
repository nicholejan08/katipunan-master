window.addEventListener('message', (event) => {
	var menu = event.data

	if (menu.message == null) {
		$(".main").fadeOut();
		$(".c-button").hide();
		$(".symbol_01").hide();
		$(".side-gradient").hide();
		$.post('http://nic_player_menu/player_menu_close', JSON.stringify({}));
	} else if (menu.message == "main") {
		$(".main").show();
		$(".c-button").hide();
		$(".symbol_01").hide();
		$(".side-gradient").show();
		$.post('http://nic_player_menu/player_menu_open', JSON.stringify({}));
	} else if (menu.message == "wake") {
		$(".main").show();
		$(".side-gradient").hide();
		$(".c-button").show();
		$(".symbol_01").show();
		$.post('http://nic_player_menu/player_menu_wake', JSON.stringify({}));
	}

	$(".action").mouseover(function() {
		$.post('http://nic_player_menu/player_menu_hover', JSON.stringify({}));
	});

	$("#close").unbind().click(function() {
		$(".main").fadeOut();
		$.post('http://nic_player_menu/player_menu_close', JSON.stringify({}));
	});

	$("#sleep").unbind().click(function() {
		$(".main").fadeOut();
		$.post('http://nic_player_menu/player_menu_sleep', JSON.stringify({}));
		$.post('http://nic_player_menu/player_menu_close', JSON.stringify({}));
	});

	$("#standby").unbind().click(function() {
		$(".main").fadeOut();
		$.post('http://nic_player_menu/player_menu_standby', JSON.stringify({}));
		$.post('http://nic_player_menu/player_menu_close', JSON.stringify({}));
	});

	$("#sit").unbind().click(function() {
		$(".main").fadeOut();
		$.post('http://nic_player_menu/player_menu_sit', JSON.stringify({}));
		$.post('http://nic_player_menu/player_menu_close', JSON.stringify({}));
	});

	$("#pee").unbind().click(function() {
		$.post('http://nic_player_menu/player_menu_close', JSON.stringify({}));
		$.post('http://nic_player_menu/player_menu_pee', JSON.stringify({}));
	});

	$("#poop").unbind().click(function() {
		$.post('http://nic_player_menu/player_menu_close', JSON.stringify({}));
		$.post('http://nic_player_menu/player_menu_poop', JSON.stringify({}));
	});

	$("#wakeup").unbind().click(function() {
		$(".main").fadeOut();
		$.post('http://nic_player_menu/player_menu_wakeup', JSON.stringify({}));
		$.post('http://nic_player_menu/player_menu_close', JSON.stringify({}));
	});

});

// close via backspace or escape

$(document).keydown(e => {
	var code = e.keyCode || e.which;

	if (code == 8 || code == 27) {
		$.post('http://nic_player_menu/player_menu_close', JSON.stringify({}), () => {});
		$(".main").fadeOut();
	}
});
window.addEventListener('message', function(event) {
	let item = event.data;

	switch (item.action) {
		case 'updateStatusHud':
			$("#texttemp").html(item.temp + " °C");
			$("#textjob").html(item.job);
			$("#location").html(item.location);
			$("#day").html(item.day);

			if (item.temp >= 29) {
				$("#texttemp").css("color", "rgb(237, 57, 12)");
			} else if (item.temp >= 21 && item.temp <= 28) {
				$("#texttemp").css("color", "rgb(227, 140, 48)");

			} else if (item.temp >= 16 && item.temp <= 20) {
				$("#texttemp").css("color", "rgb(77, 160, 147)");

			} else if (item.temp >= 11 && item.temp <= 15) {
				$("#texttemp").css("color", "rgb(22, 217, 194)");
			} else if (item.temp <= 10) {
				$("#texttemp").css("color", "rgb(12, 128, 237)");
			}

			$("body").css("display", item.show ? "block" : "none");
			$("#boxSetHealth").css("width", item.health + "%");
			$("#boxSetArmour").css("width", item.armour + "%");

			widthHeightSplit(item.hunger, $("#boxSetHunger"));
			widthHeightSplit(item.thirst, $("#boxSetThirst"));
			widthHeightSplit(item.oxygen, $("#boxSetOxygen"));
			widthHeightSplit(item.stress, $("#boxSetStress"));
	}
});

function widthHeightSplit(value, ele) {
	let height = 25.5;
	let eleHeight = (value / 100) * height;
	let leftOverHeight = height - eleHeight;

	ele.css("height", eleHeight + "px");
	ele.css("top", leftOverHeight + "px");
};

$("document").ready(function() {

	const keyCodes = [88, 66, 74, 73, 20];

	function changeDisplayState(selector, disp) {
		const elements = document.querySelectorAll(selector);
		elements.forEach(e => {
			e.style.display = disp;
		});
	}

	window.addEventListener("keydown", event => {
		if (!keyCodes.includes(event.keyCode)) return;
		changeDisplayState("#actions, #actions1, #actions2, #actions3, #actions4, #emotes1", "none");
		switch (event.keyCode) {

			case 88: // X
				changeDisplayState("#actions1", "block");
				break;

			case 66: // B
				changeDisplayState("#actions2", "block");
				break;

			case 74: // J
				changeDisplayState("#actions3", "block");
				break;

			case 73: // I
				changeDisplayState("#actions4", "block");
				break;

			case 20: // CAPS LOCK
				changeDisplayState("#emotes1, #actions", "block");
				break;

			default:
				changeDisplayState("#actions", "block");
				break;

		}
	});

	window.addEventListener("keyup", event => {
		if (keyCodes.includes(event.keyCode)) {
			changeDisplayState("#actions", "block");
			changeDisplayState("#actions1, #actions2, #actions3, #actions4, #emotes1", "none");
		}
	});
});



$("document").ready(function() {


	window.addEventListener("message", function(event) {
		const item = event.data;
		const charID = item.ID;
		const charJob = item.job;
		const charMoney = item.money;
		const isHidden = item.hidden;

		if (item !== undefined && item.type === "HUD") {

			if (isHidden == false) {

				document.getElementById("textid").innerText = "ID " + charID;
				document.getElementById("textjob").innerText = charJob;
	
				var num = parseFloat(charMoney);
				var new_num = num.toFixed(2);
	
				document.getElementById("money").innerText = new_num;
	
				if (item.display === true) {
					if ($(".main-wrapper").is(":hidden")){
						$(".main-wrapper").fadeIn();
					}
				}
				
				else if (item.display === false) {
					if ($(".main-wrapper").is(":visible")){
						$(".main-wrapper").fadeOut();
					}
				}

			} else if (isHidden == true) {
				$(".main-wrapper").hide();
			}
			
		}
	});

});

// metabolism

$("document").ready(function() {

	var sizeWater = 42.0;
	var sizeFood = 42.0;

	if ($(window).width() == 1920 && $(window).height() == 1080) {

	} else if ($(window).height() != 1080) {
		sizeWater = (($(window).height() * sizeWater) / 1080);
		sizeFood = (($(window).height() * sizeFood) / 1080);
	}

	var barwater = $('.water');
	var barfood = $('.food');

	barwater.circleProgress({
		value: 0.0,
		size: sizeWater,
		thickness: 4,
		fill: {
			gradient: ['#aba390']
		},
	});
	
	barfood.circleProgress({
		value: 0.0,
		size: sizeFood,
		thickness: 4,
		fill: {
			color: ['#aba390']
		},
	});

	window.addEventListener("message", function(event) {
		const item = event.data;
		const charHunger = item.hunger;
		const charThirst = item.thirst;

		if (item !== undefined && item.type === "metabolism") {
			barwater.circleProgress('value', charThirst);
			barfood.circleProgress('value', charHunger);
		} 
	});

});

// player menu

window.addEventListener('message', (event) => {
	var menu = event.data

	if (menu !== undefined && menu.type === "player-menu") {
	
		if (menu.message == undefined) {
			$(".c-button").hide();
			$(".symbol_01").hide();

			if ($(".main-player-menu").hasClass("side-menu-open")){
				$(".main-player-menu").css("transition-timing-function", "ease-out");
				$(".main-player-menu").removeClass("side-menu-open");
			}

			$.post('http://nic_hud/player_menu_close', JSON.stringify({}));

		} else if (menu.message == "main") {
			$(".c-button").hide();
			$(".symbol_01").hide();

			if (!$(".main-player-menu").hasClass("side-menu-open")){
				$(".main-player-menu").css("transition-timing-function", "ease-in");
				$(".main-player-menu").addClass("side-menu-open");
			} else {
				$(".main-player-menu").css("transition-timing-function", "ease-out");
				$(".main-player-menu").removeClass("side-menu-open");
			}

			$.post('http://nic_hud/player_menu_open', JSON.stringify({}));
		} else if (menu.message == "wake") {

			$(".c-button").show();
			$(".symbol_01").show();

			if ($(".main-player-menu").hasClass("side-menu-open")){
				$(".main-player-menu").css("transition-timing-function", "ease-out");
				$(".main-player-menu").removeClass("side-menu-open");
			}
			
			$.post('http://nic_hud/player_menu_wake', JSON.stringify({}));
		}
	
		$(".action").mouseover(function() {
			$.post('http://nic_hud/player_menu_hover', JSON.stringify({}));
		});
	
		$("#close").unbind().click(function() {
			$.post('http://nic_hud/player_menu_close', JSON.stringify({}));
		});
	
		$("#sleep").unbind().click(function() {
			$.post('http://nic_hud/player_menu_sleep', JSON.stringify({}));
			$.post('http://nic_hud/player_menu_close', JSON.stringify({}));
		});
	
		$("#standby").unbind().click(function() {
			$.post('http://nic_hud/player_menu_standby', JSON.stringify({}));
			$.post('http://nic_hud/player_menu_close', JSON.stringify({}));
		});
	
		$("#sit").unbind().click(function() {
			$.post('http://nic_hud/player_menu_sit', JSON.stringify({}));
			$.post('http://nic_hud/player_menu_close', JSON.stringify({}));
		});
	
		$("#pee").unbind().click(function() {
			$.post('http://nic_hud/player_menu_close', JSON.stringify({}));
			$.post('http://nic_hud/player_menu_pee', JSON.stringify({}));
		});
	
		$("#poop").unbind().click(function() {
			$.post('http://nic_hud/player_menu_close', JSON.stringify({}));
			$.post('http://nic_hud/player_menu_poop', JSON.stringify({}));
		});
	
		$("#wakeup").unbind().click(function() {
			$(".wake-container").fadeOut();
			$.post('http://nic_hud/player_menu_wakeup', JSON.stringify({}));
			$.post('http://nic_hud/player_menu_close', JSON.stringify({}));
		});
	}

});

// close via backspace or escape

$(document).keydown(e => {
	var code = e.keyCode || e.which;

	if (code == 8 || code == 27) {
		$.post('http://nic_hud/player_menu_close', JSON.stringify({}), () => {});
		$(".main-player-menu").fadeOut();
	}
});

function rightClick(event) {
	if(event.button === 2){
		$.post('http://nic_hud/player_menu_close', JSON.stringify({}), () => {});
		$(".main").fadeOut();
	}
}

// crosshair

$(function(){
	window.onload = (e) => {
		window.addEventListener('message', (event) => {
			var item = event.data;
			if (item !== undefined && item.type === "crosshair") {
				if (item.display === true) {
                    $(".crosshair").css("display", "flex");
				} else{
                    $(".crosshair").fadeOut();
                }
			}
		});
	};
});
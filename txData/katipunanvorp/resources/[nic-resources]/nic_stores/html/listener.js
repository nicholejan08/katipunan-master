window.addEventListener('message', (event) => {
	var stores = event.data

	if (stores.message == null) {
		$(".assorted").hide();
		$(".bakery").hide();
		$(".fruits").hide();
		$(".market").hide();
		$(".tools").hide();
		$(".clinic").hide();
		$(".liquor").hide();
		$(".planting").hide();
		$(".horse_items").hide();
		$(".tents").hide();
		$(".weapons").hide();
		$(".ammo").hide();
		$(".ticket").hide();
	} else if (stores.message == "assorted") {
		$(".assorted").show();
	} else if (stores.message == "bakery") {
		$(".bakery").show();
	} else if (stores.message == "fruits") {
		$(".fruits").show();
	} else if (stores.message == "market") {
		$(".market").show();
	} else if (stores.message == "tools") {
		$(".tools").show();
	} else if (stores.message == "clinic") {
		$(".clinic").show();
	} else if (stores.message == "liquor") {
		$(".liquor").show();
	} else if (stores.message == "planting") {
		$(".planting").show();
	} else if (stores.message == "horse_items") {
		$(".horse_items").show();
	} else if (stores.message == "tents") {
		$(".tents").show();
	} else if (stores.message == "weapons") {
		$(".weapons").show();
	} else if (stores.message == "ammo") {
		$(".ammo").show();
	} else if (stores.message == "ticket") {
		$(".ticket").show();
	}

	// $(".item").unbind().click(function(){
	// 	$.post('http://nic_stores/close', JSON.stringify({})
	//   );
	// });

	// close function

	$(".stores_close_button").unbind().click(function(){
		$.post('http://nic_stores/close', JSON.stringify({})
	  );
	});

	// items to buy

	// $(".item").each(function(i, item){
	// 	var itemName = $(item).attrib("data-item");
		
	// 	$(item).unbind().click(function(){
	// 		$.post('http://nic_stores/'+itemName, JSON.stringify({}));
	// 	});
	// });

	$(".canteen").unbind().click(function(){
		$.post('http://nic_stores/canteen', JSON.stringify({})
	  );
	});

	$(".apple").unbind().click(function(){
		$.post('http://nic_stores/apple', JSON.stringify({})
	  );
	});

	$(".banana").unbind().click(function(){
		$.post('http://nic_stores/banana', JSON.stringify({})
	  );
	});

	$(".pandesal").unbind().click(function(){
		$.post('http://nic_stores/pandesal', JSON.stringify({})
	  );
	});

	$(".cheese_sm").unbind().click(function(){
		$.post('http://nic_stores/cheese_sm', JSON.stringify({})
	  );
	});

	$(".pandecoco").unbind().click(function(){
		$.post('http://nic_stores/pandecoco', JSON.stringify({})
	  );
	});

	$(".spanishbread").unbind().click(function(){
		$.post('http://nic_stores/spanishbread', JSON.stringify({})
	  );
	});

	$(".monay").unbind().click(function(){
		$.post('http://nic_stores/monay', JSON.stringify({})
	  );
	});

	$(".ensaymada").unbind().click(function(){
		$.post('http://nic_stores/ensaymada', JSON.stringify({})
	  );
	});

	$(".hopia").unbind().click(function(){
		$.post('http://nic_stores/hopia', JSON.stringify({})
	  );
	});

	$(".pan_de_manila").unbind().click(function(){
		$.post('http://nic_stores/pan_de_manila', JSON.stringify({})
	  );
	});

	$(".coffee").unbind().click(function(){
		$.post('http://nic_stores/coffee', JSON.stringify({})
	  );
	});

	$(".cigar").unbind().click(function(){
		$.post('http://nic_stores/cigar', JSON.stringify({})
	  );
	});

	$(".cigarette").unbind().click(function(){
		$.post('http://nic_stores/cigarette', JSON.stringify({})
	  );
	});

	$(".canned_sardines").unbind().click(function(){
		$.post('http://nic_stores/canned_sardines', JSON.stringify({})
	  );
	});

	$(".sugar_pack").unbind().click(function(){
		$.post('http://nic_stores/sugar_pack', JSON.stringify({})
	  );
	});

	$(".firstaid").unbind().click(function(){
		$.post('http://nic_stores/firstaid', JSON.stringify({})
	  );
	});

	$(".firstaid-s").unbind().click(function(){
		$.post('http://nic_stores/firstaid-s', JSON.stringify({})
	  );
	});

	$(".pig_liver").unbind().click(function(){
		$.post('http://nic_stores/pig_liver', JSON.stringify({})
	  );
	});

	$(".pork").unbind().click(function(){
		$.post('http://nic_stores/pork', JSON.stringify({})
	  );
	});

	$(".raw_chicken").unbind().click(function(){
		$.post('http://nic_stores/raw_chicken', JSON.stringify({})
	  );
	});

	$(".black_pepper").unbind().click(function(){
		$.post('http://nic_stores/black_pepper', JSON.stringify({})
	  );
	});

	$(".tomato_sauce").unbind().click(function(){
		$.post('http://nic_stores/tomato_sauce', JSON.stringify({})
	  );
	});

	$(".hotdog").unbind().click(function(){
		$.post('http://nic_stores/hotdog', JSON.stringify({})
	  );
	});

	$(".green_peas").unbind().click(function(){
		$.post('http://nic_stores/green_peas', JSON.stringify({})
	  );
	});

	$(".vetsin").unbind().click(function(){
		$.post('http://nic_stores/vetsin', JSON.stringify({})
	  );
	});

	$(".fish_sauce").unbind().click(function(){
		$.post('http://nic_stores/fish_sauce', JSON.stringify({})
	  );
	});

	$(".salt").unbind().click(function(){
		$.post('http://nic_stores/salt', JSON.stringify({})
	  );
	});

	$(".egg").unbind().click(function(){
		$.post('http://nic_stores/egg', JSON.stringify({})
	  );
	});

	$(".green_chilli").unbind().click(function(){
		$.post('http://nic_stores/green_chilli', JSON.stringify({})
	  );
	});

	$(".bay_leaf").unbind().click(function(){
		$.post('http://nic_stores/bay_leaf', JSON.stringify({})
	  );
	});

	$(".cooking_oil").unbind().click(function(){
		$.post('http://nic_stores/cooking_oil', JSON.stringify({})
	  );
	});

	$(".soy_sauce").unbind().click(function(){
		$.post('http://nic_stores/soy_sauce', JSON.stringify({})
	  );
	});

	$(".vinegar").unbind().click(function(){
		$.post('http://nic_stores/vinegar', JSON.stringify({})
	  );
	});

	$(".potato").unbind().click(function(){
		$.post('http://nic_stores/potato', JSON.stringify({})
	  );
	});

	$(".pepper").unbind().click(function(){
		$.post('http://nic_stores/pepper', JSON.stringify({})
	  );
	});

	$(".ginger").unbind().click(function(){
		$.post('http://nic_stores/ginger', JSON.stringify({})
	  );
	});

	$(".onion").unbind().click(function(){
		$.post('http://nic_stores/onion', JSON.stringify({})
	  );
	});

	$(".garlic").unbind().click(function(){
		$.post('http://nic_stores/garlic', JSON.stringify({})
	  );
	});

	$(".flint_steel").unbind().click(function(){
		$.post('http://nic_stores/flint_steel', JSON.stringify({})
	  );
	});

	$(".cleanshort").unbind().click(function(){
		$.post('http://nic_stores/cleanshort', JSON.stringify({})
	  );
	});

	$(".frame_tent").unbind().click(function(){
		$.post('http://nic_stores/frame_tent', JSON.stringify({})
	  );
	});

	$(".fishbait").unbind().click(function(){
		$.post('http://nic_stores/fishbait', JSON.stringify({})
	  );
	});

	$(".reticle").unbind().click(function(){
		$.post('http://nic_stores/reticle', JSON.stringify({})
	  );
	});

	$(".jump_boots").unbind().click(function(){
		$.post('http://nic_stores/jump_boots', JSON.stringify({})
	  );
	});

	$(".plywood").unbind().click(function(){
		$.post('http://nic_stores/plywood', JSON.stringify({})
	  );
	});

	$(".flag").unbind().click(function(){
		$.post('http://nic_stores/flag', JSON.stringify({})
	  );
	});

	$(".helmet").unbind().click(function(){
		$.post('http://nic_stores/helmet', JSON.stringify({})
	  );
	});

	$(".juggernaut").unbind().click(function(){
		$.post('http://nic_stores/juggernaut', JSON.stringify({})
	  );
	});

	$(".pot").unbind().click(function(){
		$.post('http://nic_stores/pot', JSON.stringify({})
	  );
	});

	$(".pear").unbind().click(function(){
		$.post('http://nic_stores/pear', JSON.stringify({})
	  );
	});

	$(".horse_stim").unbind().click(function(){
		$.post('http://nic_stores/horse_stim', JSON.stringify({})
	  );
	});

	$(".sugarcane").unbind().click(function(){
		$.post('http://nic_stores/sugarcane', JSON.stringify({})
	  );
	});

	$(".wateringcan").unbind().click(function(){
		$.post('http://nic_stores/wateringcan', JSON.stringify({})
	  );
	});

	$(".wine").unbind().click(function(){
		$.post('http://nic_stores/wine', JSON.stringify({})
	  );
	});

	$(".lockpick").unbind().click(function(){
		$.post('http://nic_stores/lockpick', JSON.stringify({})
	  );
	});

	$(".beer").unbind().click(function(){
		$.post('http://nic_stores/beer', JSON.stringify({})
	  );
	});

	$(".vodka").unbind().click(function(){
		$.post('http://nic_stores/vodka', JSON.stringify({})
	  );
	});

	$(".hamburger").unbind().click(function(){
		$.post('http://nic_stores/hamburger', JSON.stringify({})
	  );
	});

	$(".horsebrush").unbind().click(function(){
		$.post('http://nic_stores/horsebrush', JSON.stringify({})
	  );
	});

	$(".tango").unbind().click(function(){
		$.post('http://nic_stores/tango', JSON.stringify({})
	  );
	});

	$(".brandy").unbind().click(function(){
		$.post('http://nic_stores/brandy', JSON.stringify({})
	  );
	});

	$(".bell_pepper").unbind().click(function(){
		$.post('http://nic_stores/bell_pepper', JSON.stringify({})
	  );
	});

	$(".carrot").unbind().click(function(){
		$.post('http://nic_stores/carrot', JSON.stringify({})
	  );
	});

	$(".haycube").unbind().click(function(){
		$.post('http://nic_stores/haycube', JSON.stringify({})
	  );
	});

	$(".pot").unbind().click(function(){
		$.post('http://nic_stores/pot', JSON.stringify({})
	  );
	});

	$(".longneck").unbind().click(function(){
		$.post('http://nic_stores/longneck', JSON.stringify({})
	  );
	});

	$(".riceseed").unbind().click(function(){
		$.post('http://nic_stores/riceseed', JSON.stringify({})
	  );
	});

	$(".cornseed").unbind().click(function(){
		$.post('http://nic_stores/cornseed', JSON.stringify({})
	  );
	});

	$(".sticky_bomb").unbind().click(function(){
		$.post('http://nic_stores/sticky_bomb', JSON.stringify({})
	  );
	});

	$(".invi_potion").unbind().click(function(){
		$.post('http://nic_stores/invi_potion', JSON.stringify({})
	  );
	});

	$(".townportal").unbind().click(function(){
		$.post('http://nic_stores/townportal', JSON.stringify({})
	  );
	});

	$(".jump_potion").unbind().click(function(){
		$.post('http://nic_stores/jump_potion', JSON.stringify({})
	  );
	});

	$(".axe").unbind().click(function(){
		$.post('http://nic_stores/axe', JSON.stringify({})
	  );
	});

	$(".shovel").unbind().click(function(){
		$.post('http://nic_stores/shovel', JSON.stringify({})
	  );
	});

	$(".sack").unbind().click(function(){
		$.post('http://nic_stores/sack', JSON.stringify({})
	  );
	});

	$(".porkstew_recipe").unbind().click(function(){
		$.post('http://nic_stores/porkstew_recipe', JSON.stringify({})
	  );
	});

	$(".beefstew_recipe").unbind().click(function(){
		$.post('http://nic_stores/beefstew_recipe', JSON.stringify({})
	  );
	});

	$(".newspaper").unbind().click(function(){
		$.post('http://nic_stores/newspaper', JSON.stringify({})
	  );
	});

	$(".ladder").unbind().click(function(){
		$.post('http://nic_stores/ladder', JSON.stringify({})
	  );
	});

	$(".tentA1").unbind().click(function(){
		$.post('http://nic_stores/tentA1', JSON.stringify({})
	  );
	});

	$(".tentA2").unbind().click(function(){
		$.post('http://nic_stores/tentA2', JSON.stringify({})
	  );
	});

	$(".tentA3").unbind().click(function(){
		$.post('http://nic_stores/tentA3', JSON.stringify({})
	  );
	});

	$(".tentA4").unbind().click(function(){
		$.post('http://nic_stores/tentA4', JSON.stringify({})
	  );
	});

	$(".tentB1").unbind().click(function(){
		$.post('http://nic_stores/tentB1', JSON.stringify({})
	  );
	});

	$(".tentB2").unbind().click(function(){
		$.post('http://nic_stores/tentB2', JSON.stringify({})
	  );
	});

	$(".tentB3").unbind().click(function(){
		$.post('http://nic_stores/tentB3', JSON.stringify({})
	  );
	});

	$(".tentC1").unbind().click(function(){
		$.post('http://nic_stores/tentC1', JSON.stringify({})
	  );
	});

	$(".tentC2").unbind().click(function(){
		$.post('http://nic_stores/tentC2', JSON.stringify({})
	  );
	});

	$(".tentC3").unbind().click(function(){
		$.post('http://nic_stores/tentC3', JSON.stringify({})
	  );
	});

	$(".tentC4").unbind().click(function(){
		$.post('http://nic_stores/tentC4', JSON.stringify({})
	  );
	});

	$(".tentC5").unbind().click(function(){
		$.post('http://nic_stores/tentC5', JSON.stringify({})
	  );
	});

	$(".camera").unbind().click(function(){
		$.post('http://nic_stores/camera', JSON.stringify({})
	  );
	});

	$(".film").unbind().click(function(){
		$.post('http://nic_stores/film', JSON.stringify({})
	  );
	});

	$(".pickaxe").unbind().click(function(){
		$.post('http://nic_stores/pickaxe', JSON.stringify({})
	  );
	});

	$(".bticket").unbind().click(function(){
		$.post('http://nic_stores/bticket', JSON.stringify({})
	  );
	});

	$(".mticket").unbind().click(function(){
		$.post('http://nic_stores/mticket', JSON.stringify({})
	  );
	});

	$(".wilson").unbind().click(function(){
		$.post('http://nic_stores/wilson', JSON.stringify({})
	  );
	});

	$(".weapon_lasso").unbind().click(function(){
		$.post('http://nic_stores/weapon_lasso', JSON.stringify({})
	  );
	});

	$(".weapon_fishingrod").unbind().click(function(){
		$.post('http://nic_stores/weapon_fishingrod', JSON.stringify({})
	  );
	});

	$(".weapon_kit_binoculars").unbind().click(function(){
		$.post('http://nic_stores/weapon_kit_binoculars', JSON.stringify({})
	  );
	});

	$(".weapon_melee_hammer").unbind().click(function(){
		$.post('http://nic_stores/weapon_melee_hammer', JSON.stringify({})
	  );
	});

	$(".weapon_melee_knife").unbind().click(function(){
		$.post('http://nic_stores/weapon_melee_knife', JSON.stringify({})
	  );
	});

	$(".weapon_melee_lantern").unbind().click(function(){
		$.post('http://nic_stores/weapon_melee_lantern', JSON.stringify({})
	  );
	});

	$(".weapon_melee_machete").unbind().click(function(){
		$.post('http://nic_stores/weapon_melee_machete', JSON.stringify({})
	  );
	});

	$(".weapon_melee_torch").unbind().click(function(){
		$.post('http://nic_stores/weapon_melee_torch', JSON.stringify({})
	  );
	});

	$(".weapon_shotgun_pump").unbind().click(function(){
		$.post('http://nic_stores/weapon_shotgun_pump', JSON.stringify({})
	  );
	});

	$(".weapon_repeater_carbine").unbind().click(function(){
		$.post('http://nic_stores/weapon_repeater_carbine', JSON.stringify({})
	  );
	});

	$(".weapon_repeater_lancaster").unbind().click(function(){
		$.post('http://nic_stores/weapon_repeater_lancaster', JSON.stringify({})
	  );
	});

	$(".weapon_pistol_mauser").unbind().click(function(){
		$.post('http://nic_stores/weapon_pistol_mauser', JSON.stringify({})
	  );
	});

	$(".weapon_revolver_cattleman").unbind().click(function(){
		$.post('http://nic_stores/weapon_revolver_cattleman', JSON.stringify({})
	  );
	});

	$(".weapon_revolver_doubleaction").unbind().click(function(){
		$.post('http://nic_stores/weapon_revolver_doubleaction', JSON.stringify({})
	  );
	});

	$(".weapon_rifle_boltaction").unbind().click(function(){
		$.post('http://nic_stores/weapon_rifle_boltaction', JSON.stringify({})
	  );
	});

	$(".weapon_rifle_springfield").unbind().click(function(){
		$.post('http://nic_stores/weapon_rifle_springfield', JSON.stringify({})
	  );
	});

	$(".weapon_bow").unbind().click(function(){
		$.post('http://nic_stores/weapon_bow', JSON.stringify({})
	  );
	});

	$(".weapon_bow_improved").unbind().click(function(){
		$.post('http://nic_stores/weapon_bow_improved', JSON.stringify({})
	  );
	});

	$(".ammorepeaternormal").unbind().click(function(){
		$.post('http://nic_stores/ammorepeaternormal', JSON.stringify({})
	  );
	});

	$(".ammorepeaterexpress").unbind().click(function(){
		$.post('http://nic_stores/ammorepeaterexpress', JSON.stringify({})
	  );
	});

	$(".ammorepeatersplitpoint").unbind().click(function(){
		$.post('http://nic_stores/ammorepeatersplitpoint', JSON.stringify({})
	  );
	});

	$(".ammorepeatervelocity").unbind().click(function(){
		$.post('http://nic_stores/ammorepeatervelocity', JSON.stringify({})
	  );
	});

	$(".ammopistolnormal").unbind().click(function(){
		$.post('http://nic_stores/ammopistolnormal', JSON.stringify({})
	  );
	});

	$(".ammopistolexpress").unbind().click(function(){
		$.post('http://nic_stores/ammopistolexpress', JSON.stringify({})
	  );
	});

	$(".ammopistolsplitpoint").unbind().click(function(){
		$.post('http://nic_stores/ammopistolsplitpoint', JSON.stringify({})
	  );
	});

	$(".ammopistolvelocity").unbind().click(function(){
		$.post('http://nic_stores/ammopistolvelocity', JSON.stringify({})
	  );
	});

	$(".ammorevolvernormal").unbind().click(function(){
		$.post('http://nic_stores/ammorevolvernormal', JSON.stringify({})
	  );
	});

	$(".ammorevolverexpress").unbind().click(function(){
		$.post('http://nic_stores/ammorevolverexpress', JSON.stringify({})
	  );
	});

	$(".ammorevolversplitpoint").unbind().click(function(){
		$.post('http://nic_stores/ammorevolversplitpoint', JSON.stringify({})
	  );
	});

	$(".ammorevolvervelocity").unbind().click(function(){
		$.post('http://nic_stores/ammorevolvervelocity', JSON.stringify({})
	  );
	});

	$(".ammoriflenormal").unbind().click(function(){
		$.post('http://nic_stores/ammoriflenormal', JSON.stringify({})
	  );
	});

	$(".ammorifleexpress").unbind().click(function(){
		$.post('http://nic_stores/ammorifleexpress', JSON.stringify({})
	  );
	});

	$(".ammoriflesplitpoint").unbind().click(function(){
		$.post('http://nic_stores/ammoriflesplitpoint', JSON.stringify({})
	  );
	});

	$(".ammoriflevelocity").unbind().click(function(){
		$.post('http://nic_stores/ammoriflevelocity', JSON.stringify({})
	  );
	});

	$(".ammoshotgunnormal").unbind().click(function(){
		$.post('http://nic_stores/ammoshotgunnormal', JSON.stringify({})
	  );
	});

	$(".ammoshotgunslug").unbind().click(function(){
		$.post('http://nic_stores/ammoshotgunslug', JSON.stringify({})
	  );
	});

	$(".ammoarrownormal").unbind().click(function(){
		$.post('http://nic_stores/ammoarrownormal', JSON.stringify({}));
		$.post('http://nic_stores/addarrows', JSON.stringify({}));
	});
});

// close via backspace or escape

$(document).keydown(e => {
	var code = e.keyCode || e.which;
	if(code == 8 || code == 27) { 
		$.post('http://nic_stores/close', JSON.stringify({}), () => { console.log("finish")}) ;
	}
  });
  

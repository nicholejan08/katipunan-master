$(function(){
	window.onload = (e) => {
        /* 'links' the js with the Nui message from main.lua */
		window.addEventListener('message', (event) => {
            //document.querySelector("#logo").innerHTML = " "
			var item = event.data;
			if (item !== undefined && item.type === "canteen") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#canteen").show();
                     /* if the display is false, it will hide */
				} 
                else if (item.display == "fadein") {
                    $("#canteen").fadeIn();
                }
                else if (item.display == "fadeout") {
                    $("#canteen").fadeOut();
                }
                else{
                    $("#canteen").hide();
                }			
			}
			else if (item !== undefined && item.type === "canteen_drinking") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#canteen_drinking").show();
                     /* if the display is false, it will hide */
				} 
                else if (item.display == "fadein") {
                    $("#canteen_drinking").fadeIn();
                }
                else if (item.display == "fadeout") {
                    $("#canteen_drinking").fadeOut();
                }
                else{
                    $("#canteen_drinking").hide();
                }			
			}
			else if (item !== undefined && item.type === "drink") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#drink").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#drink").hide();
                }			
			}
			else if (item !== undefined && item.type === "drink2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#drink").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#drink").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "drinking") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#drinking").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#drinking").hide();
                }
			}
			else if (item !== undefined && item.type === "drinking2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#drinking").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#drinking").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "wash") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#wash").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#wash").hide();
                }			
			}
			else if (item !== undefined && item.type === "wash2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#wash").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#wash").fadeOut();
                }			
			}
			else if (item !== undefined && item.type === "washing") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#washing").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#washing").hide();
                }
			}
			else if (item !== undefined && item.type === "washing2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#washing").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#washing").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "eating") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#eating").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#eating").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "eating2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#eating").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#eating").hide();
                }
			}
			else if (item !== undefined && item.type === "eating3") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#eating").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#eating").hide();
                }
			}
			else if (item !== undefined && item.type === "poster") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#poster").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#poster").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "poster_butcher") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#poster_butcher").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#poster_butcher").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "eat") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#eat").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#eat").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "eat2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#eat").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#eat").hide();
                }
			}
			else if (item !== undefined && item.type === "kill_fire") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#kill_fire").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#kill_fire").hide();
                }
			}
			else if (item !== undefined && item.type === "kill_fire2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#kill_fire").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#kill_fire").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "killing_fire") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#killing_fire").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#killing_fire").hide();
                }
			}
			else if (item !== undefined && item.type === "killing_fire2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#killing_fire").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#killing_fire").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "poison") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#poison").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#poison").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "loot") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#loot").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#loot").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "existing_fire") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#existing_fire").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#existing_fire").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "existing_fire2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#existing_fire").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#existing_fire").hide();
                }
			}
			else if (item !== undefined && item.type === "hunger_plus") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#hunger_plus").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#hunger_plus").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "thirst_plus") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#thirst_plus").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#thirst_plus").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "safezone") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#safezone").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#safezone").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "buy") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#buy").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#buy").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "ragdoll") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#ragdoll").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#ragdoll").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "point") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#point").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#point").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "handsup") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#handsup").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#handsup").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "bought_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#bought_prompt").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#bought_prompt").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "control") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#control").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#control").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "theatre") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#theatre").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#theatre").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "wolverine") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#wolverine_overlay").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#wolverine_overlay").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "focus") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#focus_overlay").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#focus_overlay").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "pym") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#pym_overlay").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#pym_overlay").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "overlay") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#overlay").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#overlay").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "butcher_overlay") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#butcher_overlay").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#butcher_overlay").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "bounty_overlay") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#bounty_overlay").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#bounty_overlay").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "tired") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#tired_prompt").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#tired_prompt").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "armor") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#armor").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#armor").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "emote_controls") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#emote_controls").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#emote_controls").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "quiapo_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#quiapo_prompt").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#quiapo_prompt").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "talipapa_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#talipapa_prompt").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#talipapa_prompt").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "binondo_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#binondo_prompt").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#binondo_prompt").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "baguio_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#baguio_prompt").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#baguio_prompt").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "typhoon_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#typhoon_prompt").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#typhoon_prompt").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "pee_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#pee").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#pee").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "pee_prompt2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#pee").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#pee").hide();
                }
			}
			else if (item !== undefined && item.type === "peeing_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#peeing").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#peeing").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "pooping_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#pooping").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#pooping").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "harvest") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#harvest").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#harvest").hide();
                }
			}
			else if (item !== undefined && item.type === "harvest2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#harvest").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#harvest").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "harvesting") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#harvesting").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#harvesting").hide();
                }
			}
			else if (item !== undefined && item.type === "harvesting2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#harvesting").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#harvesting").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "mushroom_plus") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#mushroom_plus").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#mushroom_plus").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "falls1_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#falls1_prompt").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#falls1_prompt").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "falls2_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#falls2_prompt").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#falls2_prompt").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "cooldown_prompt") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#cooldown_prompt").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#cooldown_prompt").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "bicol_overlay") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#bicol_overlay").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#bicol_overlay").fadeOut();
                }
			}
            
			else if (item !== undefined && item.type === "chop") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#chop").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#chop").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "chop2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#chop").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#chop").hide();
                }
			}
            else if (item !== undefined && item.type === "chopping") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#chopping").fadeIn();
                     /* if the display is false, it will hide */
				} else{
                    $("#chopping").fadeOut();
                }
			}
			else if (item !== undefined && item.type === "chopping2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#chopping").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#chopping").hide();
                }
			}
			else if (item !== undefined && item.type === "chopping3") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#chopping").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#chopping").hide();
                }
			}
			else {
				
			}
		});
	};
});
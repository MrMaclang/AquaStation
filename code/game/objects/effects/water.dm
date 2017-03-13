//Seawater! It's everywhere across Deorsum, and the station is surrounded on all sides by it.
//Has different effects on different objects. To give an object an effect underwater, override its "water_act".

/obj/effect/water
	name = "seawater"
	desc = "Water you looking at?"
	icon = 'icons/effects/effects.dmi'
	icon_state = "full" //Color is determined by depth
	alpha = 200
	layer = MASSIVE_OBJ_LAYER
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	mouse_opacity = 0
	var/pressure = 100 //In kPa, how much pressure this water is exerting on anything on its tile
	var/volume = 100 //In percent, how much water is is on this tile; the water spread will only spread once it reaches 100
	var/depth = 0 //In meters, how deep the water is; 0 is the surface
	var/can_spread = TRUE //If this water can spread to other tiles
	var/active = FALSE //Water becomes "active" when an atom updates near it

/obj/effect/water/New(loc, depth_num = 0, volume_num = 100)
	..()
	for(var/obj/effect/water/W in loc)
		if(W != src)
			qdel(src)
			return
	depth = Clamp(depth_num, 0, INFINITY)
	volume = volume_num
	alpha = volume * 2
	pressure = (depth / 10) * 100 //1000 meters = 100 * one atmosphere = 100 atmospheres of pressure
	handle_depth_appearance()

/obj/effect/water/proc/handle_depth_appearance()
	switch(depth)
		if(DEPTH_LEVEL_SURFACE to DEPTH_LEVEL_SUNLIT)
			name = "sunlit water"
			desc = "Dappled with sunbeams and comfortably warm."
			color = rgb(0, 175, 255)
			set_light(3, 0.5, color)
		if(DEPTH_LEVEL_SUNLIT to DEPTH_LEVEL_NORMAL)
			name = "water"
			desc = "Dim light reaches this far down, but the warmth stops far above."
			color = rgb(0, 160, 230)
			set_light(1, 1, color)
		if(DEPTH_LEVEL_NORMAL to DEPTH_LEVEL_DEEP)
			name = "deep water"
			desc = "Looking up, you can make out a flicker of light, far, far above you."
			color = rgb(0, 70, 100)
		if(DEPTH_LEVEL_DEEP to DEPTH_LEVEL_LIGHTLESS)
			name = "lightless water"
			desc = "Nothing but blackness all around. You can't see more than a few feet through the murk."
			color = rgb(0, 30, 50)
		if(DEPTH_LEVEL_LIGHTLESS to DEPTH_LEVEL_ABYSSAL)
			name = "abyssal water"
			desc = "Down here, the penumbral darkness holds sway, black as death. You should not be here."
			color = rgb(0, 0, 0)

/obj/effect/water/Crossed(atom/movable/AM)
	START_PROCESSING(SSfastprocess, src)

/obj/effect/water/process()
	if(!hit_dem_atoms())
		STOP_PROCESSING(SSfastprocess, src)
		return

/obj/effect/water/proc/hit_dem_atoms()
	alpha = volume * 2
	var/stay_active = FALSE
	for(var/atom/movable/A in get_turf(src))
		if(A == src || isturf(A) || A.invisibility)
			continue
		if(A.water_act(src))
			stay_active = TRUE
	return stay_active

/obj/item/debug_water_spawn
	name = "bottomless water glass"
	desc = "For when you're <i>REALLY</i> thirsty."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "glass_clear"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/debug_water_spawn/attack_self(mob/living/user)
	var/depth = input(user, "How deep is this water?", "GET THE WATER NIGGUH IT'S GOIN' DOWN AWWW SHIT") as null|num
	new/obj/effect/water(get_turf(src), depth)

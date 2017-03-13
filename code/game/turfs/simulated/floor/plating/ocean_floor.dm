/turf/open/floor/plating/ocean_floor
	name = "seafloor"
	desc = "Grainy earth and sand."
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	icon_plating = "asteroid"
	var/simulated_depth = 0 //How deep the water on top of this turf is, in meters

/turf/open/floor/plating/ocean_floor/Initialize()
	..()
	if(simulated_depth)
		new/obj/effect/water(src, simulated_depth, 100)

/turf/open/floor/plating/ocean_floor/Destroy(force)
	if(!force) //This is meant to replace space
		return
	. = ..()

/turf/open/floor/plating/ocean_floor/sunlit
	simulated_depth = 100

/turf/open/floor/plating/ocean_floor/shallow
	simulated_depth = 200

/turf/open/floor/plating/ocean_floor/normal
	simulated_depth = 500

/turf/open/floor/plating/ocean_floor/lightless
	simulated_depth = 900

/turf/open/floor/plating/ocean_floor/abyss
	simulated_depth = 1005

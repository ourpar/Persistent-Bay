/obj/structure/extinguisher_cabinet
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/extinguisher.dmi'
	icon_state = "extinguisher_closed"
	anchored = 1
	density = 0
	max_health = 150
	var/obj/item/weapon/extinguisher/has_extinguisher
	var/opened = 0

/obj/structure/extinguisher_cabinet/attackby(obj/item/O, mob/user)
	if(isrobot(user))
		return
	if(istype(O, /obj/item/weapon/extinguisher))
		if(!has_extinguisher && opened && user.unEquip(O, src))
			has_extinguisher = O
			to_chat(user, "<span class='notice'>You place [O] in [src].</span>")
			playsound(src.loc, 'sound/effects/extin.ogg', 50, 0)
		else
			opened = !opened
	else
		opened = !opened
	update_icon()


/obj/structure/extinguisher_cabinet/attack_hand(mob/user)
	if(isrobot(user))
		return
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (user.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return
	if(has_extinguisher)
		user.put_in_hands(has_extinguisher)
		to_chat(user, "<span class='notice'>You take [has_extinguisher] from [src].</span>")
		playsound(src.loc, 'sound/effects/extout.ogg', 50, 0)
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/attack_tk(mob/user)
	if(has_extinguisher)
		has_extinguisher.dropInto(loc)
		to_chat(user, "<span class='notice'>You telekinetically remove [has_extinguisher] from [src].</span>")
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/on_update_icon()
	pixel_x = 0
	pixel_y = 0
	switch(dir)
		if(NORTH)
			pixel_y = 24
		if(SOUTH)
			pixel_y = -24
		if(EAST)
			pixel_x = 24
		if(WEST)
			pixel_x = -24

	if(!opened)
		icon_state = "extinguisher_closed"
		return
	if(has_extinguisher)
		if(istype(has_extinguisher, /obj/item/weapon/extinguisher/mini))
			icon_state = "extinguisher_mini"
		else
			icon_state = "extinguisher_full"
	else
		icon_state = "extinguisher_empty"

/obj/structure/extinguisher_cabinet/AltClick(var/mob/user)
	if(CanPhysicallyInteract(user))
		opened = !opened
		update_icon()

/obj/structure/extinguisher_cabinet/filled/New()
	..()
	has_extinguisher = new/obj/item/weapon/extinguisher(src)

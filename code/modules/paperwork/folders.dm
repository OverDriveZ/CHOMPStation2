/obj/item/weapon/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/bureaucracy.dmi' //CHOMPEdit: Continues using new folder sprite, contrary to YW
	icon_state = "folder"
	w_class = ITEMSIZE_SMALL
	pressure_resistance = 2
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	slot_flags = SLOT_BELT | SLOT_HOLSTER

/obj/item/weapon/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"

/obj/item/weapon/folder/red
	desc = "A red folder."
	icon_state = "folder_red"

/obj/item/weapon/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/weapon/folder/white
	desc = "A white folder."
	icon_state = "folder_white"

/obj/item/weapon/folder/blue_captain
	desc = "A blue folder with Site Manager markings."
	icon_state = "folder_captain"

/obj/item/weapon/folder/blue_hop
	desc = "A blue folder with HoP markings."
	icon_state = "folder_hop"

/obj/item/weapon/folder/white_cmo
	desc = "A white folder with CMO markings."
	icon_state = "folder_cmo"

/obj/item/weapon/folder/white_rd
	desc = "A white folder with RD markings."
	icon_state = "folder_rd"

/obj/item/weapon/folder/white_rd/New()
	//add some memos
	var/obj/item/weapon/paper/P = new()
	P.name = "Memo RE: proper analysis procedure"
	P.info = "<br>We keep test dummies in pens here for a reason"
	src.contents += P
	update_icon()

/obj/item/weapon/folder/yellow_ce
	desc = "A yellow folder with CE markings."
	icon_state = "folder_ce"

/obj/item/weapon/folder/red_hos
	desc = "A red folder with HoS markings."
	icon_state = "folder_hos"

/obj/item/weapon/folder/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("folder_paper")
	return

/obj/item/weapon/folder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/paper) || istype(W, /obj/item/weapon/photo) || istype(W, /obj/item/weapon/paper_bundle))
		user.drop_item()
		W.loc = src
		to_chat(user, "<span class='notice'>You put the [W] into \the [src].</span>")
		update_icon()
	else if(istype(W, /obj/item/weapon/pen))
		var/n_name = sanitizeSafe(tgui_input_text(user, "What would you like to label the folder?", "Folder Labelling", null, MAX_NAME_LEN), MAX_NAME_LEN)
		if(in_range(user, src) && user.stat == 0)
			name = "folder[(n_name ? text("- '[n_name]'") : null)]"
	return

/obj/item/weapon/folder/afterattack(turf/T as turf)
	for(var/obj/item/weapon/paper/P in T)
		P.loc = src
		update_icon()

/obj/item/weapon/folder/attack_self(mob/user as mob)
	var/dat = "<title>[name]</title>"

	for(var/obj/item/weapon/paper/P in src)
		dat += "<A href='?src=\ref[src];remove=\ref[P]'>Remove</A> <A href='?src=\ref[src];rename=\ref[P]'>Rename</A> - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/weapon/photo/Ph in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Ph]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Ph]'>Rename</A> - <A href='?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"
	for(var/obj/item/weapon/paper_bundle/Pb in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Pb]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Pb]'>Rename</A> - <A href='?src=\ref[src];browse=\ref[Pb]'>[Pb.name]</A><BR>"
	user << browse(dat, "window=folder")
	onclose(user, "folder")
	add_fingerprint(user)
	return

/obj/item/weapon/folder/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(src.loc == usr)

		if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if(P && (P.loc == src) && istype(P))
				P.loc = usr.loc
				usr.put_in_hands(P)

		else if(href_list["read"])
			var/obj/item/weapon/paper/P = locate(href_list["read"])
			if(P && (P.loc == src) && istype(P))
				if(!(istype(usr, /mob/living/carbon/human) || istype(usr, /mob/observer/dead) || istype(usr, /mob/living/silicon)))
					usr << browse("<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[stars(P.info)][P.stamps]</BODY></HTML>", "window=[P.name]")
					onclose(usr, "[P.name]")
				else
					usr << browse("<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>", "window=[P.name]")
					onclose(usr, "[P.name]")
		else if(href_list["look"])
			var/obj/item/weapon/photo/P = locate(href_list["look"])
			if(P && (P.loc == src) && istype(P))
				P.show(usr)
		else if(href_list["browse"])
			var/obj/item/weapon/paper_bundle/P = locate(href_list["browse"])
			if(P && (P.loc == src) && istype(P))
				P.attack_self(usr)
				onclose(usr, "[P.name]")
		else if(href_list["rename"])
			var/obj/item/weapon/O = locate(href_list["rename"])

			if(O && (O.loc == src))
				if(istype(O, /obj/item/weapon/paper))
					var/obj/item/weapon/paper/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/weapon/photo))
					var/obj/item/weapon/photo/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/weapon/paper_bundle))
					var/obj/item/weapon/paper_bundle/to_rename = O
					to_rename.rename()

		//Update everything
		attack_self(usr)
		update_icon()
	return

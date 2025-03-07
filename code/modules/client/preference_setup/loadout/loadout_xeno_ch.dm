/datum/gear/suit/hood
	display_name = "hooded cloak selection (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/hood/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/hooded/teshari/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/double_tank_nitrogen
	display_name = "Pocket sized double nitrogen tank (Customs)"
	path = /obj/item/weapon/tank/emergency/nitrogen/double
	whitelisted = SPECIES_CUSTOM
	sort_category = "Xenowear"

/datum/gear/double_tank_phoron
	display_name = "Pocket sized double phoron tank (Vox, Customs)"
	path = /obj/item/weapon/tank/emergency/phoron/double
	whitelisted = list(SPECIES_VOX, SPECIES_CUSTOM)
	sort_category = "Xenowear"

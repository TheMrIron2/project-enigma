void(float width, float height) HUD_WeaponName =
{
    local string weaponstring; 
	local float ofs;
	
	weaponstring = getWeaponName(weapon);
	ofs = (strlen(weaponstring));
		
	drawstring([0.925*width + (40*width/1024) - ofs*20*width/1024, 0.75*height + 10, 0], weaponstring, [0.02*width, 0.02*width, 0], [1, 1, 1], 1, 1);
}

void(float width, float height) HUD_Ammo =
{
    //credit to nzp team, will rewrite later
	local float ammo, curmag, benis, benis2;
	string ammostring, ammostring_1, ammostring_2;
	
	curmag = getstatf(STAT_CURRENTMAG);		
	ammo = getstatf(STAT_AMMO);	
	
	benis = strlen(ftos(ammo));
	benis2 = strlen(ftos(curmag));
	benis = benis + benis2;

	ammostring_1 = ftos(curmag);
	ammostring_2 = strcat("/",ftos(ammo));
	drawstring([width - (42/480)*width - (benis*20*width/1024), 0.96*height, 0], ammostring_1, [0.02*width, 0.02*width, 0], [1, 1, 1], 1, 1);
	drawstring([width - (42/480)*width - ((benis-strlen(ftos(curmag)))*20*width/1024), 0.96*height, 0], ammostring_2, [0.02*width, 0.02*width, 0], [1, 1, 1], 1, 1);
}

void(float width, float height) HUD_TDM =
{
    drawstring([0.03*g_width, 0.85*g_height, 0], "Team Deathmatch", [g_height * 0.025, g_height * 0.025, 1], [1, 1, 1], 1, 1);
}

void(float width, float height) HUD_Draw =
{
    HUD_WeaponName(width, height);
    HUD_Ammo(width, height);

    switch(gamemode) {
        case GM_TDM:
            HUD_TDM(width, height);
            break;
        default:
            break;
    }
}
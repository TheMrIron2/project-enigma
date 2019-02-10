void() precaches;

void() main = {

}

void() worldspawn = {
    precaches();

    #ifdef PC
    clientstat(STAT_CURRENTMAG, EV_FLOAT, currentmag);
    clientstat(STAT_AMMO, EV_FLOAT, currentammo);
    #endif
}

void() SetNewParms = {

}

void() SetChangeParms = {

}

void() StartFrame = {

}

void() precaches = {
    precache_model("models/player.mdl");
    precache_model("models/weapons/colt/v_colt.mdl");
}
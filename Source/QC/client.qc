void() ClientKill = {

}

void() ClientConnect = {

}

void() ClientDisconnect = {

}

void() PlayerPreThink = {

}

void() PlayerPostThink = {
    checkImpulses();
    checkPlayer();
}

void() PutClientInServer = {
    local entity spawnspot;
    spawnspot = find(world, classname, "info_player_start");

    self.classname = "player";
    self.health = 100;
    self.takedamage = DAMAGE_AIM;
    self.solid = SOLID_SLIDEBOX;
    self.movetype = MOVETYPE_WALK;
    self.flags = FL_CLIENT;

    self.origin = spawnspot.origin + '0 0 1';
    self.angles = spawnspot.angles;
    self.fixangle = TRUE;

    setmodel(self, "models/player.mdl");
    setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);

    self.view_ofs = '0 0 22';
    self.velocity = '0 0 0';

    self.maxspeed = 120; //temporarily here (FIXME) - add walk speeds

    //Weapon stuff
    self.weapon = W_STG;
    self.currentmag = getWeaponMag(self.weapon);
    self.currentammo = getWeaponReserve(self.weapon);
    self.weaponmodel = getWeaponModel(1, self.weapon);
    SwitchWeapon(self.weapon); //tell the client 'hey we have a new vmodel'

    //here just to test hud stuff
    setGamemode(GM_TDM);
}
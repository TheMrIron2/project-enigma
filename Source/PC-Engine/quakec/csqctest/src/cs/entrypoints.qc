#ifdef WORKINDP
	#define show_scoreboard sb_showscores
#endif

float show_scoreboard;
string dbgstr;

void()	CSQC_Shutdown = {};

//check engine extensions, and give suitable warning
void() checkengineversion =
{
	if (checkextension("FTE_STRINGS"))
	{
		isdp = substring(" ", 0, -1) == "";
		if (isdp)
			print("broken FTE_STRINGS support\n");
	}
	else
		print("no FTE_STRINGS support, this mod might crash... sorry\n");
};


//check compiler, and give suitable warnings (unfortunatly at run time)
float(float f) testfunc =
{
	return f;
}
float(float f1, float f2) testfunc2 =
{
	return f1+f2;
}
float testarray[2];

float(float p1, float p2) a = {return p1+p2+5;};
float() b = {return 86;};
float(float p1) c = {return p1+566;};
float() d = {return 7773;};

#pragma TARGET ID

void() checkcompilerversion =
{
	local entity testent;

	testent = spawn();
	testent.entnum = -5;
	testent.owner = testent;
	testent.owner.entnum += 5;
	if (testent.entnum)
		print("compiler failed on e.e.f += \n");
	remove(testent);

	testarray[0] = 5;
	testarray[1] = 6;

	if (testfunc (a(b(), c(d()))) != 86+5+7773+566)
		print("compiler failed on a(b(), c(d()))\n");
	if (testfunc(5)+testfunc(6) != 11)
		print("compiler failed on f()+f()\n");
	if (testfunc2(5, testfunc(6)) != 11)
		print("compiler failed on f2(0,f1(1))\n");
	if (testfunc2(testfunc(5),testfunc(6)) != 11)
		print("compiler failed on f2(f(),f())\n");
	if (testarray[0]+testarray[1] != 11)
		print("compiler failed on a[0]+a[1]\n");
};

#ifdef FTEDEPENDANT
# pragma TARGET FTE
#endif


void(float isnew) RefreshPlayer;


void(float isnew) RefreshOther =
{
	self.drawmask = MASK_ENGINE;
	setmodelindex(self, self.modelindex);

	if (self.entnum <= maxclients)
		RefreshPlayer(isnew);
	else if (self.colormap)
		self.modelindex = 0;	//don't show dead bodies, we do dying ourselves.
};



float(string centertext) centerprinted =
{
//warning!
//centertext is a temporary string!
//warning!

	return false;	//we don't want to handle it, let the engine do it.
};

.float classnum;

void(float isnew) CSQC_Ent_Update =
{
	local float classtype;
	local var void(float isnew) fnc;

	classtype = readbyte();

//remove if the class changed.
	if (self.classnum != classtype)
	{
		if (self.removefunc)
			self.removefunc();
		isnew = true;
		self.classnum = classtype;
	}

	fnc = ParseEntityClass[classtype];
	if (!fnc)
		error("Unrecognised entity class: Your csqc needs updating");
	fnc(isnew);

//	if (isnew)
//	print("csqc ", self.model, " updated at ", vtos(self.origin), "\n");
};

void() regcommands =
{
	registercommand("tetris");
	registercommand("skinchooser");
	registercommand("randomskin");
	registercommand("test");
	registercommand("+showscores");
	registercommand("-showscores");
	registercommand("+showteamscores");
	registercommand("-showteamscores");

	registercommand("osgk");
	registercommand("osgk_command");
	registercommand("osgk_resize");
	registercommand("osgk_mousemove");
	registercommand("osgk_keypress");
};

float(string str) CSQC_ConsoleCommand =
{
	local float args;
	args = tokenize(str);
	switch(argv(0))
	{
	case "test":
		sendevent("testevent", "fsev", 64, "hello world", player_local, '73 72 71');
		break;
	case "tetris":
		Menu_Tetris();
		break;
	case "skinchooser":
		Menu_SkinChooser();
		break;
	case "randomskin":
		SelectRandomSkin();
		break;
	case "+showscores":
		show_scoreboard = 1;
		return false;
	case "+showteamscores":
		show_scoreboard = 2;
		return false;
	case "-showscores":
	case "-showteamscores":
		show_scoreboard = 0;
		return false;
	case "osgk":
		Menu_OSGK(argv(1));
		break;
	case "osgk_command":
		gecko_navigate(argv(1), argv(2));
		break;
	case "osgk_keypress":
		gecko_keyevent(argv(1), stof(argv(2)), 2);
		break;
	case "osgk_resize":
		gecko_resize(argv(1), stof(argv(2)), stof(argv(3)));
		break;
	case "osgk_mousemove":
		gecko_mousemove(argv(1), stof(argv(2)), stof(argv(3)));
		break;
	default:
		return false;
	}
	return true;
};

void(string msg, float type) CSQC_Parse_Print =
{
cprint(msg);

	if (dbgstr)
		strunzone(dbgstr);
	dbgstr = strzone(msg);
};

void() CSQC_Ent_Remove =	//the ent disappeared on the server.
{
	if (self.removefunc)
		self.removefunc();
	remove(self);
};

entity viewentity;
//note that a better way of animating weapon firing would be as a response to an event, or as a clientside predicted thing.
void(entity ve) DoThatViewModelThing =
{
	float newframe, newmodel;

	newframe = getstatf(STAT_WEAPONFRAME);
	newmodel = getstatf(STAT_WEAPONMODEL);

	if (newmodel != ve.modelindex)
	{	//changed entirly.
		ve.modelindex = newmodel;
		ve.frame2 = ve.frame = newframe;
		ve.lerptime = time;
	}
	else if (newframe != ve.frame)
	{
		ve.frame2 = ve.frame;
		ve.frame = newframe;
		ve.lerptime = time;
	}
	ve.lerpfrac = 1-(time-ve.lerptime)*10;

	ve.origin = '0 0 0';
	ve.angles = '0 0 0';
	ve.angles_x *= -1;
};

void() drawloadingscreen =
{
//work in progress here
//	drawfill('0 0', '320 240', '1 1 1', 1);
//	drawstring('0 0', "loading screen", '1 1', '1 1 1', 1);
};

void() CSQC_Init =
{
	checkengineversion();
	checkcompilerversion();

	viewentity = spawn();
	viewentity.renderflags = RF_VIEWMODEL|RF_DEPTHHACK;

	drawloadingscreen ();

	regcommands();

#ifndef FTEDEPENDANT
	if (checkextension("EXT_CSQC_1"))
#endif
	{
//		deltalisten("*", RefreshOther, 0);	//catch-all
		deltalisten("progs/player.mdl", RefreshPlayer, RSES_NOLERP|RSES_NOROTATE);	//animate players/player-corpses
	}
};

void(entity ent) CSQC_DrawViewModel =
{
	if (player_local.sveffects & SVE_INVIS)
		ent.forceshader = shaderforname("powerups/invisibility");
	else
		ent.forceshader = 0;

	ent.fatness = 0;
	DoThatViewModelThing(ent);

#ifdef WORKINDP
	//DP doesn't support RF_VIEWMODEL
	//so hack around that
	ent.renderflags = RF_DEPTHHACK;	//nope, not a view model, that just breaks things
	ent.origin = vieworg;
	ent.angles = input_angles;
	ent.angles_x = -ent.angles_x;
#endif

	addentity(ent);
	if (player_local.sveffects & SVE_QUAD)
	{
		ent.fatness = -2;
		ent.forceshader = shaderforname("powerups/quad");
		addentity(ent);
	}
	if (player_local.sveffects & SVE_GOD)
	{
		ent.fatness = -2.8;
		ent.forceshader = shaderforname("powerups/regen");
		addentity(ent);
	}
}

//a bit of fun
void() CSQC_Input_Frame =
{
/*	if (input_buttons == 1)
		input_buttons = 2;
	else if (input_buttons == 2)
		input_buttons = 1;*/
};

void() CSQC_Delta_Remove =
{
	if (self == player_local)
		player_local = world;

//	print("delt ", ftos(self.modelindex), "(", self.model, ") removed\n");
	if (self.removefunc)
		self.removefunc();
	remove(self);
};


float (float event, float parama, float paramb) CSQC_InputEvent =
{
	if (event == 0)
	{
		switch(CVARF(cg_editor))
		{
		case 1:
			if (editor_lights_key(parama, paramb))
				return true;
			break;
		case 2:
			if (editor_terrain_key(parama, paramb))
				return true;
			break;
		}
	}
	return Menu_InputEvent(event, parama, paramb);
};

void(float width, float height, float do2d) CSQC_UpdateView =
{
	float hudtype = CVARF(cg_hudtype);

	chasecam = CVARF(cg_thirdPerson);
	if (getstatf(STAT_HEALTH) <= 0)
		chasecam = 1;

	clearscene();

	setviewprop(VF_DRAWCROSSHAIR, 1);

	//force fullscreen views (ignore viewsize).
	setviewprop(VF_MIN, '0 0 0');
	setviewprop(VF_SIZE_X, width);
	setviewprop(VF_SIZE_Y, height);
#if 0
	setviewprop(VF_MIN_X, width/2);
	setviewprop(VF_MIN_Y, height/2);
	setviewprop(VF_SIZE_X, width/2);
	setviewprop(VF_SIZE_Y, height/2);
#endif

	if (hudtype != 1)
	{
		setviewprop(VF_DRAWENGINESBAR, 0);
	}
	else
	{
		setviewprop(VF_DRAWENGINESBAR, 1);
	}

	addentities(MASK_NORMAL|MASK_ENGINE);

	if (player_local)
	{
		setviewprop(VF_ORIGIN, vieworg);
		setviewprop(VF_ANGLES, view_angles);

		makevectors(view_angles);
		SetListener(vieworg, v_forward, v_right, v_up);

		if (!chasecam)
		{
			CSQC_DrawViewModel(viewentity);
		}
	}
	else
	{
		//engine didn't tell us about our player entity. that's not right...
		addentities(MASK_ENGINEVIEWMODEL);
	}

	switch(CVARF(cg_editor))
	{
	case 1:
		/*add light ents*/
		editor_lights_add();
		hudtype = 0;
		break;
	case 2:
		break;
	}

	renderscene();

	if (do2d)
	{
		switch(CVARF(cg_editor))
		{
		case 1:
			/*add light ents*/
			editor_lights_overlay();
			hudtype = 0;
			break;
		case 2:
			break;
		default:
			if (hudtype)
				Hud_Draw(hudtype, show_scoreboard, width, height);
			break;
		}

		Menu_Think();
	}

	if (dbgstr)
	{
//		drawrawstring('16 64 0', dbgstr, '16 16 16', '1 1 1', 0.5);
//		drawstring('16 80 0', dbgstr, '16 16 16', 0.5);
	}
};


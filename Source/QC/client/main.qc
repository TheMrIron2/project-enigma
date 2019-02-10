void() toggleMenu =
{
	if(serverkey("constate") != "disconnected")
	{
		if(in_menu == MENU_NONE)
		{
			in_menu = MENU_PAUSE;
			setcursormode(TRUE,"menu/cursor");
		}
		else
		{
			in_menu = MENU_NONE;
			setcursormode(FALSE);
		}
	}
	else
	{
		in_menu = MENU_MAIN;
		setcursormode(TRUE,"menu/cursor");
	}
}


noref void(float apiver, string enginename, float enginever) CSQC_Init =
{
    registercommand("togglemenu");
	registercommand("startwalk");
	registercommand("stopwalk");
		
	print("CSQC Initialized.\n");

	dummy = spawn();
	
	if(serverkey("constate") == "disconnected")
		toggleMenu();
};

noref void() CSQC_WorldLoaded =
{
	if(!vmodel)
		vmodel = spawn();
		
	vmodel.renderflags = RF_VIEWMODEL;
	vmodel.origin = '0 0 0';
	vmodel_targetpos = vmodel_currentpos = vmodel.origin;
	vmodel_velocity = '0 0 0';
	setmodel(vmodel,"");
};

void() Update_Vmodel =
{
	local vector offset;
	local vector dir;
	
	offset_x = 0.6 * sin(time * 1.2);
	offset_y = 0.4 * cos(time * 1.5);
	offset_z = 0.7 * sin(1.1*time + 0.5);
	
	dir = vmodel_targetpos - vmodel_currentpos;
	if(vlen(dir) < (0.15 * 128 * frametime))
		vmodel_currentpos = vmodel_targetpos;
	else
		vmodel_currentpos += (dir * 0.15 * 128) * frametime;
	
	if(vlen(vmodel.angles) < (0.1 * 128 * frametime))
		vmodel.angles = '0 0 0';
	else
		vmodel.angles += (-vmodel.angles * 0.2 * 128) * frametime;
		
	vmodel_currentpos += (vmodel_velocity * 128) * frametime;
	vmodel_velocity *= 1 - frametime * 30;
	
	vmodel.angles += (vmodel_avelocity * 128) * frametime;
	vmodel_avelocity *= 1 - frametime * 30;
	
	vmodel.origin = vmodel_currentpos + offset;
}

noref void(float isnew) CSQC_Ent_Update =
{
	if(isnew)
		print(strcat(etos(self),"\n"));
}

// CALLED EVERY CLIENT RENDER FRAME
noref void(float width, float height, float menushown) CSQC_UpdateView =
{
	//clear and update our global screen resolution vars
	clearscene();
	g_width = width;
	g_height = height;
	
	//disable quake status bar and quake crosshair
	setviewprop(VF_DRAWENGINESBAR, 0);	
	setviewprop(VF_DRAWCROSSHAIR, 0);
	
	//autoadd entities received from servers for drawing	
	addentities(MASK_ENGINE);

	//do viewmodel manipulation, purely cosmetic stuff
	if(vmodel)
	{
		Update_Vmodel();
		addentity(vmodel);
		local vector vorg;
		local vector vang;
		vorg = getviewprop(VF_ORIGIN);
		vang = getviewprop(VF_ANGLES);
	}

	//does what you think it does
	renderscene();
	
	if(in_menu) {
		Draw_Menu();
	} else {
		HUD_Draw(g_width, g_height);
	}

	if(serverkey("constate") != "active" && serverkey("disconnected"))
	{
		drawfill('0 0 0',  [width, height, 0], '0.2 0.4 0.7', 1);
		drawstring([width/2 - 60, height/2, 0], "Loading...", [16,16,0],[1,1,1],1,1);
	}
};

noref float(string cmd) CSQC_ConsoleCommand =
{
	tokenize(cmd);
	switch(argv(0))
	{
        case "togglemenu":
			toggleMenu();
			return TRUE;
			break;
		case "map":
			return FALSE;
			break;
		case "startwalk":
			walk = TRUE;
			return FALSE;
		case "stopwalk":
			walk = FALSE;
			return FALSE;
		default:
			return FALSE;
	}
	return FALSE;
};

void(float scanx, float setval) Input_Movecheck = 
{
	tokenize(findkeysforcommand("+moveleft"));
	if (scanx == stof(argv(0)))
		K_LEFTDOWN = setval;
	
	tokenize(findkeysforcommand("+moveright"));
	if (scanx == stof(argv(0)))
		K_RIGHTDOWN = setval;
		
	tokenize(findkeysforcommand("+forward"));
	if (scanx == stof(argv(0)))
		K_FORWARDDOWN = setval;
		
	tokenize(findkeysforcommand("+back"));
	if (scanx == stof(argv(0)))
		K_BACKDOWN = setval;
}

noref float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent =
{
	switch(evtype)
	{
        case IE_KEYDOWN:
		    if(in_menu != MENU_NONE)
		    {
		    	if(scanx == K_MOUSE1)
		    	{
		    		menuClick();
		    		return TRUE;
		    	}

		    }
		
		    Input_Movecheck(scanx, 1);
		    return FALSE;
	    case IE_KEYDOWN:
		    Input_Movecheck(scanx, 1);
		    return FALSE;
	    case IE_KEYUP:
		    Input_Movecheck(scanx, 0);
		    return FALSE;
	    case IE_MOUSEDELTA:
	    	return FALSE;
	    case IE_MOUSEABS:
		    return FALSE;
	}
	return FALSE;
};

noref void() CSQC_Input_Frame =
{
	if(walk)
	{
		input_movevalues *= 0.5;
	}
}

noref void() CSQC_Parse_Event =
{
	local float first = readbyte();

	switch (first) {
		case EVENT_WEAPONCHANGE:
			local float to;
			to = readbyte();
			setmodel(vmodel, getWeaponModel(TRUE, to));

			vmodel.origin = '0 0 0';
			vmodel.angles = '-60 0 0';
			
			weapon = to;
			break;
		case EVENT_GAMEMODESET:
			gamemode = readbyte();
			break;
        default:
            break;
    }
}
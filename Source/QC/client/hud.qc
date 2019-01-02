void(float width, float height) HUD_Sbar =
{
    local string dummy;
    local float pwidth, x;

    dummy = "this is a hud... technically. :)";

    pwidth = stringwidth(dummy, 0, [0.025*height, 0.025*height, 0]);
	x = (width - pwidth)/2;

    drawstring([x, 0.85*height, 0], dummy, [height * 0.025, height * 0.025, 1], [1, 1, 1], 1, 1);
}

void(float width, float height) HUD_Draw =
{
    HUD_Sbar(width, height); //temp
}
void() M_Menu_Pause_Draw =
{
    drawstring([0.03*g_width, 0.05*g_height, 0], "PAUSED", [g_height * 0.055, g_height * 0.055, 1], [1, 1, 1], 1, 1);
    drawstring([0.03*g_width, 0.15*g_height, 0], "click to quit.", [g_height * 0.025, g_height * 0.025, 1], [1, 1, 1], 1, 1);
    drawstring([0.03*g_width, 0.25*g_height, 0], "oh btw hi i'm red", [g_height * 0.025, g_height * 0.025, 1], [1, 0, 0], 1, 1);
}

void() M_Menu_Main_Draw =
{
    drawstring([0.03*g_width, 0.15*g_height, 0], "click to be thrown into test map.", [g_height * 0.025, g_height * 0.025, 1], [1, 1, 1], 1, 1);
}

void() Draw_Menu =
{
    switch(in_menu) {
        case MENU_PAUSE:
            M_Menu_Pause_Draw();
            break;
        case MENU_MAIN:
            M_Menu_Main_Draw();
            break;
    } 
}

void() menuClick =
{
    switch(in_menu) {
        case MENU_MAIN:
            localcmd("map start\n");
            break;
        case MENU_PAUSE:
            localcmd("quit\n");
            break;
        default:
            print("wtf\n");
            break;
    }
}
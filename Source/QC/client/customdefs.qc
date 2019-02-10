//Various globals that are used in this FTEQW example are defined here, they are not used by the engine itself

#pragma warning disable Q302

float g_width, g_height; /* Globals for screen width and height */

float in_menu;

const float MENU_NONE = 0;
const float MENU_MAIN = 1;
const float MENU_PAUSE = 2;

float walk;
float weapon;

entity vmodel;
entity dummy;

vector vmodel_targetpos;
vector vmodel_currentpos;
vector vmodel_velocity;
vector vmodel_avelocity;

float K_LEFTDOWN, K_RIGHTDOWN, K_BACKDOWN, K_FORWARDDOWN;
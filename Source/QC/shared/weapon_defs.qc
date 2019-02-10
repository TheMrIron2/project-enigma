//
// weapon_defs.qc - Weapon Definitions (ammo counts, mag count, dmg, etc.)
//

float(float wep) getWeaponMag = {
    switch(wep) {
        case W_COLT:
            return 8;
            break;
        case W_STG:
            return 30;
            break;
        default: 
            return 0;
            break;
    }
    return 0;
}

float(float wep) getWeaponReserve = {
    switch(wep) {
        case W_COLT:
            return 24;
            break;
        case W_STG:
            return 90;
            break;
        default: 
            return 0;
            break;
    }

    return 0;
}

string(float wep) getWeaponName = {
    switch(wep) {
        case W_COLT:
            return "M1911";
            break;
        case W_STG:
            return "StG-44";
            break;
    }

    return "";
}

//FIXME - STG gmodel!
string(float view, float wep) getWeaponModel = {
    if (view) {
        switch(wep) {
            case W_COLT:
                return "models/weapons/colt/v_colt.mdl";
                break;
            case W_STG:
                return "models/weapons/stg/v_stg.mdl";
                break;
            default:
                return "";
                break;
        }
    } else {
        switch(wep) {
            case W_COLT:
                return "models/weapons/colt/g_colt.mdl";
                break;
            default:
                return "";
                break;
        }
    }

    return "";
}
//
// weapon_core.qc - Firing, reloading, etc.
//

void() W_Fire = {
    self.currentmag--;
}

void() checkPlayer = {
    if (self.button0) {
        if (self.currentmag > 0)
            W_Fire();
    }
}
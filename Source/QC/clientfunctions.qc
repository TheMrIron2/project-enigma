void(float to) SwitchWeapon =
{
	#ifdef PC
	
	WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET);
	WriteByte(MSG_MULTICAST, EVENT_WEAPONCHANGE);
	WriteByte(MSG_MULTICAST, to);
	msg_entity = self;
	multicast('0 0 0', MULTICAST_ONE);
	
	#endif
}

//FIXME - Change for MP!
void(float gm) setGamemode =
{
	gamemode = gm;

	#ifdef PC
	
	WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET);
	WriteByte(MSG_MULTICAST, EVENT_GAMEMODESET);
	WriteByte(MSG_MULTICAST, gamemode);
	msg_entity = self;
	multicast('0 0 0', MULTICAST_ONE);
	
	#endif
}
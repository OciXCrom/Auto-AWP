#include <amxmodx>
#include <cstrike>
#include <engine>
#include <fun>
#include <hamsandwich>

#define PLUGIN_VERSION "1.0"

new g_pAmmo, g_pKnife
new const g_szEntities[][] = { "player_weaponstrip", "game_player_equip", "armoury_entity" }

public plugin_init()
{
	register_plugin("Auto AWP", PLUGIN_VERSION, "OciXCrom")
	register_cvar("@CRXAutoAWP", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
	RegisterHam(Ham_Spawn, "player", "OnPlayerSpawn", 1)
	
	g_pAmmo = register_cvar("autoawp_ammo", "30")
	g_pKnife = register_cvar("autoawp_knife", "1")
	
	for(new i, iEnt = -1; i < sizeof(g_szEntities); i++)
	{
		iEnt = -1
		
		while((iEnt = find_ent_by_class(iEnt, g_szEntities[i])))
		{
			if(is_valid_ent(iEnt))
				remove_entity(iEnt)
		}
	}
}

public OnPlayerSpawn(id)
{
	if(!is_user_alive(id))
		return
		
	strip_user_weapons(id)
	
	if(get_pcvar_num(g_pKnife))
		give_item(id, "weapon_knife")
	
	static iAmmo
	iAmmo = get_pcvar_num(g_pAmmo)
	
	if(iAmmo == -1)
	{
		cs_set_weapon_ammo(give_item(id, "weapon_awp"), 97280)
		cs_set_user_bpammo(id, CSW_AWP, 0)
	}
	else
	{
		give_item(id, "weapon_awp")
		cs_set_user_bpammo(id, CSW_AWP, iAmmo)
	}
}
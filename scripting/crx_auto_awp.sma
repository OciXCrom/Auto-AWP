#include <amxmodx>
#include <cstrike>
#include <engine>
#include <fun>
#include <hamsandwich>

#define PLUGIN_VERSION "1.1"

enum _:Cvars
{
	autoawp_ammo,
	autoawp_knife,
	autoawp_health,
	autoawp_armor,
	autoawp_block_drop
}

new g_eCvars[Cvars]
new const g_szEntities[][] = { "player_weaponstrip", "game_player_equip", "armoury_entity" }

public plugin_init()
{
	register_plugin("Auto AWP", PLUGIN_VERSION, "OciXCrom")
	register_cvar("CRXAutoAWP", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
	RegisterHam(Ham_Spawn, "player", "OnPlayerSpawn", 1)
	register_clcmd("drop", "OnWeaponDrop")
	
	g_eCvars[autoawp_ammo] = register_cvar("autoawp_ammo", "30")
	g_eCvars[autoawp_knife] = register_cvar("autoawp_knife", "1")
	g_eCvars[autoawp_health] = register_cvar("autoawp_health", "-1")
	g_eCvars[autoawp_armor] = register_cvar("autoawp_armor", "-1")
	g_eCvars[autoawp_block_drop] = register_cvar("autoawp_block_drop", "1")
	
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
	
	if(get_pcvar_num(g_eCvars[autoawp_knife]))
		give_item(id, "weapon_knife")
	
	static iAmmo, iHealth, iArmor
	iAmmo = get_pcvar_num(g_eCvars[autoawp_ammo])
	iHealth = get_pcvar_num(g_eCvars[autoawp_health])
	iArmor = get_pcvar_num(g_eCvars[autoawp_armor])
	
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
	
	if(iHealth != -1)
		set_user_health(id, iHealth)
	
	if(iArmor != -1)
		set_user_armor(id, iArmor)
}

public OnWeaponDrop(id)
	return get_pcvar_num(g_eCvars[autoawp_block_drop])
	
stock checkPlayerSpawn(index, Float:fRadius = 128.0)
{
	new Float:vOrigin[3], szClassname[32], iEnt
	entity_get_vector(index, EV_VEC_origin, vOrigin)
   
    while((iEnt = find_ent_in_sphere(index, vOrigin, fRadius)) != 0)
    {
        entity_get_string(iEnt, EV_SZ_classname, szClassname, charsmax(szClassname))
       
        if(equal(szClassname, "info_player_start"))
            return 2
      
        else if(equal(szClassname, "info_player_deathmatch"))
            return 1
    }
	
	return 0
}
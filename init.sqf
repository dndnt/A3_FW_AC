if (!isServer) exitWith {};

AntiCheat_fnc_globalChat = 
{
	private ["_name","_talk"];
	_name = _this select 0;
	_talk = _this select 1;
	hint (_name + "uesd mod : " + _talk);
};

AntiCheat_fnc_modsCheck =
{
	private ["_newGroup"];
	if (isServer) exitWith {};
	if (!(isNil "AntiCheat_Checked")) exitWith{}; // One Existence Only
	AntiCheat_Checked = true;
	AntiCheat_mods = 
  ["balca_debug_tool","vaa_arsenal","KRON_SupportCall","yq_mod_SuperSoldier","dsl_gear_selection","loki_lk","elite","elite_sway","recoil","remove_fatigue_group","DRI_nofatigue","fhq_debug","NSS_Admin_Console","Cloak","stra_debug2","DevCon","mf_sdc","tao_a3_debugger","PA_arsenal","SOLDIER","MGI_TG_V2","VDEBUG","PA_less_wpn_sway","Mao_Bullet_Hits_Value","Mao_recoil","brg_inittest","balca_debug_tool_1","PRADAR2","viewDistance_TAW","vz_steadyShot","SSPCM","srifle_DMR_01_F","nuclear_boom","TPW_MODS","NW_RTSE","lsd_nvg","zam_shownames","gig_scud","panda_data","ivory_gr4","TORT_DYNAMICWEATHER2","GL5_System","asr_ai3","ZBE_Cache","BW_Bags","FAR_revive_pj","AirDrop","Unlocked_Uniforms","greuh_scopes","mcc_sandbox","DjOtacon_Ultimate_Soldier","TSS_NameTag"];
  AntiCheat_mods_name_eng =
  ["proving ground","virtual arsenal anywhere","KRON Support Call","Super Soldier mode","dsl gear selection","super A3","half sway or remove sway","ultimate soldier","remove fatigue","remove fatigue group","DRI no fatigue","FHQ debug console","NSS admin console","Cloak","stra_debug2","DevCon","mf_sdc","tao_a3_debugger","PA_arsenal","SOLDIER","MGI_TG_V2","VDEBUG_TOOL","DRI_nofatigue","PA_less_wpn_sway","Mao_Bullet_Hits_Value","Mao_recoil","brg_inittest","SB2","sb3","sb4","sb5","sb6","...","2b","TPW_MODS","NW_RTSE","lsd_nvg","PRADAR2","zam_shownames","gig_scud","panda_data","ivory_gr4","TORT_DYNAMICWEATHER2","GL5_System","asr_ai3","ZBE_Cache","BW_Bags","FAR_revive_pj"];
	AntiCheat_mods_found = [];
	AntiCheat_effect_noAimSway = false;
	AntiCheat_effect_noRecoil = false;
	waitUntil {!(isNull player)}; // In case of JIP
	sleep 1;
	{
		if (isClass (configFile  >> "CfgPatches" >> _x) ) then
		{
			AntiCheat_mods_found set [count AntiCheat_mods_found,_forEachIndex];
		}
	} forEach AntiCheat_mods;
	if(getNumber(configFile>>"CfgMovesMaleSdr">>"States">>"AmovPknlMstpSrasWrflDnon_turnR">>"aimPrecision")==0) then
	{
		AntiCheat_effect_noAimSway = true;
	};
	if(unitRecoilCoefficient player==0) then
	{
		AntiCheat_effect_noRecoil = true;
	};
	if (count AntiCheat_mods_found == 0 && {not AntiCheat_effect_noAimSway} && {not AntiCheat_effect_noRecoil}) exitWith{};
	AntiCheat_string_first = true;
	if (count AntiCheat_mods_found > 0) then
	{
		{
			if (AntiCheat_string_first) then 
			{
				AntiCheat_string = (AntiCheat_mods_name select _x);
				AntiCheat_string_eng = (AntiCheat_mods_name_eng select _x);
				AntiCheat_string_first = false;
			}
			else
			{
				AntiCheat_string = AntiCheat_string + ", " + (AntiCheat_mods_name select _x);
				AntiCheat_string_eng = AntiCheat_string_eng + ", " + (AntiCheat_mods_name_eng select _x);
			};
		} forEach AntiCheat_mods_found;
	};
	if (AntiCheat_effect_noAimSway) then
	{
		if (AntiCheat_string_first) then 
		{
			AntiCheat_string_eng = "unknown no sway";
			AntiCheat_string_first = false;
		};
		AntiCheat_string_eng = AntiCheat_string_eng + ", unknown no sway";
	};
	if (AntiCheat_effect_noRecoil) then
	{
		if (AntiCheat_string_first) then 
		{
			AntiCheat_string_eng = "unknown no recoil";
			AntiCheat_string_first = false;
		};
		AntiCheat_string_eng = AntiCheat_string_eng + ", unknown no recoil";
	};
	[[name player,AntiCheat_string], "AntiCheat_fnc_globalChat", nil, false] spawn BIS_fnc_MP;
	_newGroup = createGroup side player;
	[player] joinSilent _newGroup;
	player addRating -1000000;
	player setPos [0,0,0];
	while{true} do
	{
		player globalChat "You idiot, you've detected the use of prohibited MOD!";
		player globalChat "Please unload " + AntiCheat_string_eng + " mod!!!";
		if(player getVariable ["INS_REV_PVAR_is_unconscious",false]) then {}
		else {player setDamage 1;player setPos [0,0,0];};
		sleep 1.5;
	};
};

publicVariable "AntiCheat_fnc_globalChat";
publicVariable "AntiCheat_fnc_modsCheck";


// Call everywhere
sleep 0.3;
[[], "AntiCheat_fnc_modsCheck", nil, true] spawn BIS_fnc_MP;
systemChat "AntiCheat: start server";

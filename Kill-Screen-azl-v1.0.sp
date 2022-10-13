#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <cstrike> 
#include <sdktools>
#include <clientprefs>

public Plugin myinfo =
{
	name = "Kill Screen",
	author = "AZzeL ( Credite: Domikuss )",
	description = "Efect pe ecran cand omori pe cineva",
	version = "1.0",
	url = "https://fireon.ro"
};

Handle g_KILLScreen_Cookie;
bool g_IsKSEnabled[MAXPLAYERS + 1];

public void OnPluginStart()
{
	g_KILLScreen_Cookie = RegClientCookie("KILLScreenCookie", "KILLScreenCookie", CookieAccess_Protected);

	HookEvent("player_death", OnPlayerDeath);

	RegConsoleCmd("killscreen", Command_KILLScreen);
	RegConsoleCmd("ks",         Command_KILLScreen);
}

public void OnClientPutInServer(int client)
{
	g_IsKSEnabled[client] = false;

	char buffer[64];
	GetClientCookie(client, g_KILLScreen_Cookie, buffer, sizeof(buffer));
	if(StrEqual(buffer,"1"))
		g_IsKSEnabled[client] = true;
}

public Action Command_KILLScreen(int client, int args) 
{
	if(g_IsKSEnabled[client])
	{
		PrintToChat(client, "\x02KILL Screen is now off");
		g_IsKSEnabled[client] = false;
		SetClientCookie(client, g_KILLScreen_Cookie, "0");
	}
	else
	{
		PrintToChat(client, "\x04KILL Screen is now on");
		g_IsKSEnabled[client] = true;
		SetClientCookie(client, g_KILLScreen_Cookie, "1");
	}

	return Plugin_Handled;
}

Action OnPlayerDeath(Event hEvent, const char[] name, bool dont_broadcast)
{
	int iAttacker = GetClientOfUserId(hEvent.GetInt("attacker"));

	if(iAttacker <= 0 || IsFakeClient(iAttacker) || !IsPlayerAlive(iAttacker))
	{
		return Plugin_Continue;
	}

        if (g_IsKSEnabled[iAttacker] && IsClientInGame(iAttacker))  
        {  
		SetEntPropFloat(iAttacker, Prop_Send, "m_flHealthShotBoostExpirationTime", GetGameTime() + 1.0);
	}

	return Plugin_Continue;
}
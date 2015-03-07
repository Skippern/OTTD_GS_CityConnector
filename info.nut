/*
*  info.nut
*  CityConnecter
*
*  Created by Aun Johnsen on 14/10/2014.
*  Copyright (c) 2014. All rights reserved.
*
*/

class CityConnecter extends GSInfo {
    function GetAuthor()        { return "Aun Johnsen"; }
    function GetName()          { return "CityConnecter"; }
    function GetShortName()     { return "NRCC"; } // Change this to a 4 letter combination not previously used
    function GetDescription()   { return "A simple GS that builds roads between cities"; }
    function GetVersion()       { return 1; }
    function MinVersionToLoad() { return 1; }
    function GetDate()          { return "14/10/2014"; }
    function CreateInstance()   { return "CityConnecter"; }
    function GetAPIVersion()    { return "1.4"; }
}

RegisterGS(CityConnecter());

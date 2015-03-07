/*
 *  main.nut
 *  CityConnecter
 *
 *  Created by Aun Johnsen on 14/10/2014.
 *  Copyright (c) 2014. All rights reserved.
 *
 */

local townList = {};
local cityList = {};

class CityConnecter extends GSController
{
    constructor()
    {
    }
}

function CityConnecter::TimeStamp(filter = "Unknown", msg = "")
{
    local now = GSDate.GetCurrentDate();
    local month = GSDate.GetMonth(now);
    local day = GSDate.GetDayOfMonth(now);
    local aMonth = "";
    local aDay = "";
    local tick = "."+GSController.GetTick();
    if (month < 10) aMonth = "0";
    if (day < 10) aDay = "0";
    return "[" + GSDate.GetYear(now)+"-"+aMonth+month+"-"+aDay+day + tick +"][" + filter + "] " + msg;
}

function CityConnecter::News(story)
{
    GSLog.Warning(TimeStamp("News", "Broadcast: "+ story));
    GSNews.Create(GSNews.NT_GENERAL, story, GSCompany.COMPANY_INVALID);
}

function CityConnecter::Init()
{
}

function CityConnecter::TownAction(townID)
{
    GSLog.Info(TimeStamp("Info", "This is a town action with population " + GSTown.GetPopulation(townID) +"."));
    local neighbourTowns = GSTownList();
    local neighbour;
    neighbourTowns.Valuate(function(townid_onlist, townid_location) {
        return GSMap.DistanceManhattan(GSTown.GetLocation(townid_onlist), townid_location) } ,
        GSTown.GetLocation(townID));
    neighbourTowns.Sort(GSList.SORT_BY_VALUE, GSList.SORT_ASCENDING);
    neighbour = neighbourTowns.Begin();
    neighbour = neighbourTowns.Next();
    GSLog.Info(TimeStamp("Info", "Nearest Neighbour is " + GSTown.GetName(neighbour) + ", " + GSMap.DistanceManhattan(GSTown.GetLocation(townID), GSTown.GetLocation(neighbour)) + " tiles away."));
}
function CityConnecter::CityAction(townID)
{
    GSLog.Info(TimeStamp("Info", "This is actually a city."));
}

function CityConnecter::TownWalking()
{
    local townList = GSTownList();
    local cityList = GSTownList();
    cityList.Valuate(function(id) { if (GSTown.IsCity(id)) return 1; return 0; } );
    cityList.KeepValue(1);
    townList.Valuate(GSTown.GetPopulation);
    cityList.Valuate(GSTown.GetPopulation);

    local currentTown = townList.Begin();
    while (1) {
        if (townList.IsEnd()) {
            GSLog.Info(TimeStamp("Info", "End of list, all tasks completed."));
            return;
        }
        GSLog.Info(TimeStamp("Info", "Working with the town of " + GSTown.GetName(currentTown)));
        TownAction(currentTown);
        if (GSTown.IsCity(currentTown)) {
            CityAction(currentTown);
        }
        currentTown = townList.Next();
    }
}

function CityConnecter::MainLoop()
{
    while (1) {
        TownWalking();
        this.Sleep(365*60);
        GSLog.Info(TimeStamp("Info", "A year have gone"));
    }
}

/* This function is called to start the game. It allows to initiate different functions.
 */
function CityConnecter::Start()
{
    GSLog.Info(TimeStamp("Info", "We start here"));


    this.Sleep(10); // Startup delay to make sure all necessary objects are loaded before executing.

    News("Congress decide cities responsable for national road network.");

    local townList = GSTownList();
    local cityList = GSTownList();
    cityList.Valuate(function(id) { if (GSTown.IsCity(id)) return 1; return 0; } );
    cityList.KeepValue(1);

    GSLog.Info(TimeStamp("Info", "We have "+GSTown.GetTownCount()+" Towns, whereof "+cityList.Count()+" Cities."));

    MainLoop();
}

/* This function is called to load data, when loading from a save game, this allows for continuity of a game.
 */
function CityConnecter::Load(version, data)
{
}

/* This function is called when the game is saved, allowing for variables to be saved for loading and continuing a game.
 */
function CityConnecter::Save()
{
    local _save_date = { };

    return _save_date;
}

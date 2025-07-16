-- GridStatusReadyCheck.lua
--
-- Created By: Greltok
-- Modified By: Thef for 2.4.3

--{{{ Libraries
local RL = AceLibrary("Roster-2.1")
local L = AceLibrary("AceLocale-2.2"):new("GridStatusReadyCheck")
local AceTimer = AceLibrary("AceTimer-3.0")
--}}}

GridStatusReadyCheck = GridStatus:NewModule("GridStatusReadyCheck")
GridStatusReadyCheck.menuName = L["ReadyCheck"]

local readystatus = {
    [1] = { c = { r = 1, g = 1, b = 0, a = 1 }, t = L["?"], i = READY_CHECK_WAITING_TEXTURE },
    [2] = { c = { r = 0, g = 1, b = 0, a = 1 }, t = L["R"], i = READY_CHECK_READY_TEXTURE },
    [3] = { c = { r = 1, g = 0, b = 0, a = 1 }, t = L["X"], i = READY_CHECK_NOT_READY_TEXTURE },
}

--{{{ AceDB defaults
GridStatusReadyCheck.defaultDB = {
    debug = false,
    readycheck = {
        text = L["ReadyCheck"],
        enable = true,
        color = { r = 1, g = 1, b = 1, a = 1 },
        priority = 90,
        range = false,
    },
}
--}}}

GridStatusReadyCheck.options = false

function GridStatusReadyCheck:OnInitialize()
    self.super.OnInitialize(self)
    self:RegisterStatus("readycheck", L["ReadyCheck"], nil, true)
end

function GridStatusReadyCheck:OnEnable()
    self:RegisterEvent("READY_CHECK")
    self:RegisterEvent("READY_CHECK_CONFIRM")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
end

function GridStatusReadyCheck:GainStatus(name, status, settings)
    self.core:SendStatusGained(name,
                                "readycheck",
                                settings.priority,
                                nil,
                                status.c,
                                status.t,
                                nil,
                                nil,
                                status.i)
end

function GridStatusReadyCheck:READY_CHECK(originator)
    local settings = self.db.profile.readycheck
    if settings.enable and (IsRaidLeader() or IsRaidOfficer()) then
        self:StartTimer()
        local originatorid = RL:GetUnitIDFromName(originator)
        for unit in RL:IterateRoster(false) do
            if not UnitIsUnit(unit.unitid, originatorid) then
                self:GainStatus(unit.name, readystatus[1], settings)
            else
                self:GainStatus(unit.name, readystatus[2], settings)
            end
        end
    end
end

function GridStatusReadyCheck:READY_CHECK_CONFIRM(id, confirm)
    local settings = self.db.profile.readycheck
    if settings.enable then
        local unitid = ((GetNumRaidMembers() > 0) and ("raid"..id)) or ("party"..id)
        local name = UnitName(unitid)
        if confirm == 1 then
            self:GainStatus(name, readystatus[2], settings)
        else
            self:GainStatus(name, readystatus[3], settings)
        end
    end
end

function GridStatusReadyCheck:PLAYER_REGEN_DISABLED()
    self:ResetStatus()
end

function GridStatusReadyCheck:ResetStatus()
    local settings = self.db.profile.readycheck
    if settings.enable then
        for unit in RL:IterateRoster(false) do
            self.core:SendStatusLost(unit.name, "readycheck")
        end
    end
end

function GridStatusReadyCheck:StartTimer(duration)
    duration = duration or 30
    DEFAULT_CHAT_FRAME:AddMessage('Timer started', 1,1,1)
    AceTimer:ScheduleTimer(function()
        GridStatusReadyCheck:ResetStatus()
        DEFAULT_CHAT_FRAME:AddMessage('Timer ended', 1,1,1)
    end, duration)
end
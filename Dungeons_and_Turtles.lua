-- Dungeons_and_Turtles.lua
-- Main file for the DM's Toolkit addon
-- Author: Your Name
-- Version: 1.0.0

-- Create addon using AceLibrary and register required libraries
DT = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0")

-- Default settings
DT.defaults = {
    profile = {
        enabled = true,
        debug = false,
        minimap = {
            show = true,
            position = 45,
        },
        ui = {
            scale = 1.0,
            locked = false,
        },
    }
}

-- Initialize addon
function DT:OnInitialize()
    -- Register database
    self:RegisterDB("DungeonsAndTurtlesDB", "DungeonsAndTurtlesDBPC")
    self:RegisterDefaults("profile", self.defaults.profile)
    
    -- Register chat commands
    self:RegisterChatCommand({"/dt", "/dungeons", "/turtles"}, {
        type = "group",
        args = {
            config = {
                type = "execute",
                name = "Configuration",
                desc = "Open the configuration window",
                func = function() self:ShowConfig() end,
            },
            enable = {
                type = "execute",
                name = "Enable",
                desc = "Enable the addon",
                func = function() self:Enable() end,
            },
            disable = {
                type = "execute",
                name = "Disable",
                desc = "Disable the addon",
                func = function() self:Disable() end,
            },
        },
    })
end

-- Called when addon is enabled
function DT:OnEnable()
    self:Print("Dungeons and Turtles loaded successfully!")
    
    -- Initialize modules with error handling
    local modules = {
        "Database",
        "CampaignManager",
        "PlayerTracker",
        "EventTrigger",
        "MapIntegration",
        "ChatChannel",
        "NarrativeTools",
        "UI"
    }
    
    for _, module in ipairs(modules) do
        if self[module] and type(self[module].Initialize) == "function" then
            local success, err = pcall(function() self[module]:Initialize() end)
            if not success then
                self:Print("|cFFFF0000Error initializing " .. module .. ": " .. (err or "Unknown error"))
                if self.db.profile.debug then
                    self:Print("Debug info:", debugstack())
                end
            end
        end
    end
    
    -- Register events
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end

-- Called when addon is disabled
function DT:OnDisable()
    self:Print("Dungeons and Turtles disabled.")
    -- Unregister all events
    self:UnregisterAllEvents()
end

-- Event handlers
function DT:PLAYER_ENTERING_WORLD()
    if self.db.profile.enabled then
        -- Refresh UI and map data
        if self.UI then self.UI:Refresh() end
        if self.MapIntegration then self.MapIntegration:Refresh() end
    end
end

function DT:ZONE_CHANGED_NEW_AREA()
    if self.db.profile.enabled then
        -- Update map and campaign data for new zone
        if self.MapIntegration then self.MapIntegration:UpdateZone() end
        if self.CampaignManager then self.CampaignManager:CheckZoneEvents() end
    end
end

-- Configuration window
function DT:ShowConfig()
    if not self.configFrame then
        -- Create config UI (implement in UI module)
        if self.UI and self.UI.CreateConfigFrame then
            self.configFrame = self.UI:CreateConfigFrame()
        else
            self:Print("Configuration UI not available.")
        end
    end
    
    if self.configFrame then
        self.configFrame:Show()
    end
end

-- Debug logging
function DT:Debug(...)
    if self.db.profile.debug then
        self:Print("|cFF666666Debug:|r", ...)
    end
end
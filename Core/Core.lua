-- Core.lua
-- Core functionality and initialization

function DT:Initialize()
    -- Initialize all core systems
    self.Database:Initialize()
    
    -- Initialize modules
    self:InitializeModules()
    
    -- Set up event handlers
    self:SetupEventHandlers()
    
    -- Create main UI
    self:CreateMainUI()
    
    self:Print("Dungeons & Turtles initialized successfully!")
end

function DT:InitializeModules()
    -- Initialize each module
    local modules = {
        "CampaignManager",
        "PlayerTracker",
        "EventTrigger",
        "MapIntegration",
        "ChatChannel",
        "NarrativeTools"
    }
    
    for _, moduleName in ipairs(modules) do
        if self[moduleName] and type(self[moduleName].Initialize) == "function" then
            local success, err = pcall(function()
                self[moduleName]:Initialize()
            end)
            
            if not success then
                self:Print("Error initializing " .. moduleName .. ": " .. tostring(err))
            end
        end
    end
end

function DT:SetupEventHandlers()
    -- Register for WoW events
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterEvent("CHAT_MSG_PARTY")
    self:RegisterEvent("CHAT_MSG_RAID")
    
    -- Set up custom event handlers
    self:RegisterCustomEvents()
end

function DT:RegisterCustomEvents()
    -- Campaign events
    self:RegisterEvent(self.Constants.EVENTS.CAMPAIGN_CREATED)
    self:RegisterEvent(self.Constants.EVENTS.CAMPAIGN_UPDATED)
    self:RegisterEvent(self.Constants.EVENTS.CAMPAIGN_DELETED)
    
    -- Player events
    self:RegisterEvent(self.Constants.EVENTS.PLAYER_JOINED)
    self:RegisterEvent(self.Constants.EVENTS.PLAYER_LEFT)
    
    -- DM events
    self:RegisterEvent(self.Constants.EVENTS.DM_EVENT)
end

function DT:CreateMainUI()
    if not self.mainFrame and self.UI then
        self.mainFrame = self.UI:CreateMainFrame()
    end
end

-- Event handlers
function DT:PLAYER_ENTERING_WORLD()
    if self.MapIntegration then
        self.MapIntegration:RefreshMarkers()
    end
end

function DT:ZONE_CHANGED_NEW_AREA()
    if self.MapIntegration then
        self.MapIntegration:RefreshMarkers()
    end
    
    if self.CampaignManager then
        self.CampaignManager:CheckZoneEvents()
    end
end

function DT:CHAT_MSG_PARTY(msg, sender)
    self:HandleChatMessage(msg, sender, "PARTY")
end

function DT:CHAT_MSG_RAID(msg, sender)
    self:HandleChatMessage(msg, sender, "RAID")
end

function DT:HandleChatMessage(msg, sender, chatType)
    -- Check for DM commands
    if msg:match("^/dm ") then
        local dmMessage = msg:sub(5)
        if self.ChatChannel then
            self.ChatChannel:HandleDMMessage(dmMessage, sender)
        end
        return
    end
    
    -- Handle other custom chat commands
    if self.ChatChannel then
        self.ChatChannel:HandleMessage(msg, sender, chatType)
    end
end
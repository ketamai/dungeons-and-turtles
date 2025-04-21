-- MainFrame.lua
-- Main UI frame functionality

DT.UI = {
    frame = nil,
    tabs = {},
    currentTab = nil
}

function DT.UI:Initialize()
    -- Create main frame if it doesn't exist
    if not self.frame then
        self.frame = _G["DTMainFrame"]
        if not self.frame then
            error("DTMainFrame not found!")
            return
        end
    end
    
    -- Initialize tabs
    self:InitializeTabs()
    
    -- Set up event handlers
    self:SetupEventHandlers()
    
    -- Register slash commands
    self:RegisterSlashCommands()
end

function DT.UI:InitializeTabs()
    -- Define tab data
    self.tabs = {
        {name = "Campaign", frame = "DTCampaignFrame"},
        {name = "Players", frame = "DTPlayerFrame"},
        {name = "Events", frame = "DTEventFrame"},
        {name = "Map", frame = "DTMapFrame"},
        {name = "Chat", frame = "DTChatFrame"},
        {name = "Narrative", frame = "DTNarrativeFrame"}
    }
    
    -- Set up tab buttons
    for i, tab in ipairs(self.tabs) do
        local button = _G["DTMainFrameTab"..i]
        if button then
            button:SetText(tab.name)
            button:SetScript("OnClick", function()
                self:SelectTab(i)
            end)
        end
    end
    
    -- Show first tab by default
    self:SelectTab(1)
end

function DT.UI:SelectTab(index)
    -- Hide all tab frames
    for _, tab in ipairs(self.tabs) do
        local frame = _G[tab.frame]
        if frame then
            frame:Hide()
        end
    end
    
    -- Show selected tab frame
    local selectedFrame = _G[self.tabs[index].frame]
    if selectedFrame then
        selectedFrame:Show()
    end
    
    -- Update tab button appearances
    for i = 1, #self.tabs do
        local button = _G["DTMainFrameTab"..i]
        if button then
            if i == index then
                button:LockHighlight()
            else
                button:UnlockHighlight()
            end
        end
    end
    
    self.currentTab = index
end

function DT.UI:SetupEventHandlers()
    -- Register for relevant events
    DT:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        self:RefreshUI()
    end)
    
    -- Register for custom events
    DT:RegisterEvent(DT.Constants.EVENTS.CAMPAIGN_UPDATED, function()
        self:RefreshUI()
    end)
    
    DT:RegisterEvent(DT.Constants.EVENTS.PLAYER_JOINED, function()
        self:RefreshUI()
    end)
end

function DT.UI:RegisterSlashCommands()
    -- Register main slash command
    SLASH_DT1 = "/dt"
    SLASH_DT2 = "/dungeons"
    SLASH_DT3 = "/turtles"
    
    SlashCmdList["DT"] = function(msg)
        self:HandleSlashCommand(msg)
    end
end

function DT.UI:HandleSlashCommand(msg)
    local command = string.lower(msg)
    
    if command == "" then
        self:Toggle()
    elseif command == "config" then
        self:ShowConfig()
    elseif command == "help" then
        self:ShowHelp()
    else
        -- Pass to module handlers
        DT:HandleCommand(msg)
    end
end

function DT.UI:Toggle()
    if self.frame:IsShown() then
        self.frame:Hide()
    else
        self.frame:Show()
    end
end

function DT.UI:ShowConfig()
    -- Show configuration panel
    if DT.ConfigFrame then
        DT.ConfigFrame:Show()
    else
        DT:Print("Configuration not available")
    end
end

function DT.UI:ShowHelp()
    DT:Print("Dungeons & Turtles Commands:")
    DT:Print("/dt - Toggle main window")
    DT:Print("/dt config - Open configuration")
    DT:Print("/dt help - Show this help message")
end

function DT.UI:RefreshUI()
    -- Refresh current tab
    if self.currentTab then
        self:SelectTab(self.currentTab)
    end
end

function DT.UI:OnMainFrameLoad(frame)
    -- Store reference to main frame
    self.frame = frame
    
    -- Set up frame properties
    frame:SetClampedToScreen(true)
    frame:SetUserPlaced(true)
    
    -- Initialize UI when frame loads
    self:Initialize()
end
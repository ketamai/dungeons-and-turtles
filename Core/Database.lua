-- Database.lua
-- Handles all database operations

DT.Database = {
    db = nil,
}

function DT.Database:Initialize()
    -- Set up database with defaults
    local defaults = {
        profile = {
            campaigns = {},
            players = {},
            settings = {
                enableDMPrefix = true,
                enableMapMarkers = true,
                enableChatLogging = true,
                uiScale = 1.0,
            },
            maps = {},
        },
    }
    
    -- Initialize database
    self.db = DT:AcquireDBNamespace("Database")
    DT:RegisterDefaults("Database", defaults)
    
    -- Migrate old data if needed
    self:MigrateData()
end

function DT.Database:MigrateData()
    -- Add migration code here if needed in future versions
end

-- Campaign functions
function DT.Database:SaveCampaign(campaign)
    if not campaign.id then
        campaign.id = self:GenerateUUID()
    end
    self.db.profile.campaigns[campaign.id] = campaign
    DT:TriggerEvent(DT.Constants.EVENTS.CAMPAIGN_UPDATED, campaign)
end

function DT.Database:GetCampaign(id)
    return self.db.profile.campaigns[id]
end

function DT.Database:DeleteCampaign(id)
    local campaign = self.db.profile.campaigns[id]
    if campaign then
        self.db.profile.campaigns[id] = nil
        DT:TriggerEvent(DT.Constants.EVENTS.CAMPAIGN_DELETED, campaign)
    end
end

-- Player functions
function DT.Database:SavePlayer(player)
    if not player.id then
        player.id = self:GenerateUUID()
    end
    self.db.profile.players[player.id] = player
    DT:TriggerEvent(DT.Constants.EVENTS.PLAYER_UPDATED, player)
end

function DT.Database:GetPlayer(id)
    return self.db.profile.players[id]
end

function DT.Database:DeletePlayer(id)
    local player = self.db.profile.players[id]
    if player then
        self.db.profile.players[id] = nil
        DT:TriggerEvent(DT.Constants.EVENTS.PLAYER_DELETED, player)
    end
end

-- Settings functions
function DT.Database:GetSetting(key)
    return self.db.profile.settings[key]
end

function DT.Database:SetSetting(key, value)
    self.db.profile.settings[key] = value
    DT:TriggerEvent("DT_SETTING_CHANGED", key, value)
end

-- Map functions
function DT.Database:SaveMapMarker(marker)
    if not marker.id then
        marker.id = self:GenerateUUID()
    end
    self.db.profile.maps[marker.id] = marker
    DT:TriggerEvent("DT_MAP_MARKER_UPDATED", marker)
end

function DT.Database:GetMapMarker(id)
    return self.db.profile.maps[id]
end

function DT.Database:DeleteMapMarker(id)
    local marker = self.db.profile.maps[id]
    if marker then
        self.db.profile.maps[id] = nil
        DT:TriggerEvent("DT_MAP_MARKER_DELETED", marker)
    end
end

-- Utility functions
function DT.Database:GenerateUUID()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end
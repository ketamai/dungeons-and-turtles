-- Constants.lua
-- Contains all constant values used throughout the addon

DT.Constants = {
    -- Version information
    VERSION = "1.0.0",
    
    -- Event names
    EVENTS = {
        CAMPAIGN_CREATED = "DT_CAMPAIGN_CREATED",
        CAMPAIGN_UPDATED = "DT_CAMPAIGN_UPDATED",
        CAMPAIGN_DELETED = "DT_CAMPAIGN_DELETED",
        PLAYER_JOINED = "DT_PLAYER_JOINED",
        PLAYER_LEFT = "DT_PLAYER_LEFT",
        DM_EVENT = "DT_DM_EVENT",
    },
    
    -- Chat prefixes
    CHAT = {
        DM_PREFIX = "|cFFFF0000[DM]|r",
        SYSTEM_PREFIX = "|cFF00FF00[D&T]|r",
    },
    
    -- Database keys
    DB_KEYS = {
        CAMPAIGNS = "campaigns",
        PLAYERS = "players",
        SETTINGS = "settings",
        MAPS = "maps",
    },
    
    -- UI elements
    UI = {
        MAIN_FRAME_WIDTH = 800,
        MAIN_FRAME_HEIGHT = 600,
        MIN_SCALE = 0.5,
        MAX_SCALE = 2.0,
    },
    
    -- Character stats
    STATS = {
        STRENGTH = "strength",
        DEXTERITY = "dexterity",
        CONSTITUTION = "constitution",
        INTELLIGENCE = "intelligence",
        WISDOM = "wisdom",
        CHARISMA = "charisma",
    },
    
    -- Map markers
    MARKERS = {
        QUEST = "quest",
        NPC = "npc",
        POINT_OF_INTEREST = "poi",
        DANGER = "danger",
    },
}
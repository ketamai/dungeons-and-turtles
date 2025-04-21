local MAJOR_VERSION = "AceDB-2.0"
local MINOR_VERSION = "$Revision: 1 $"

if not AceLibrary then error(MAJOR_VERSION .. " requires AceLibrary") end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end

if not AceLibrary:HasInstance("AceOO-2.0") then error(MAJOR_VERSION .. " requires AceOO-2.0") end
if not AceLibrary:HasInstance("AceEvent-2.0") then error(MAJOR_VERSION .. " requires AceEvent-2.0") end

local AceOO = AceLibrary:GetInstance("AceOO-2.0")
local AceEvent = AceLibrary:GetInstance("AceEvent-2.0")
local AceDB = AceOO.Mixin {
    "RegisterDB",
    "RegisterDefaults",
    "ResetDB",
}

function AceDB:RegisterDB(name, char)
    if not name then
        error("Usage: RegisterDB(name[, char]): 'name' - string expected.", 2)
    end
    
    -- Create the DB if it doesn't exist
    if not _G[name] then
        _G[name] = {}
    end
    
    self.db = _G[name]
    
    -- Initialize defaults
    if not self.db.profiles then
        self.db.profiles = {}
    end
    
    -- Set up character specific DB if requested
    if char then
        if not _G[char] then
            _G[char] = {}
        end
        self.chardb = _G[char]
    end
end

function AceDB:RegisterDefaults(kind, defaults)
    if not kind or not defaults then
        error("Usage: RegisterDefaults(kind, defaults): both arguments expected.", 2)
    end
    
    if not self.db then
        error("Cannot call RegisterDefaults before RegisterDB.", 2)
    end
    
    -- Store defaults
    if not self.db.defaults then
        self.db.defaults = {}
    end
    
    self.db.defaults[kind] = defaults
    
    -- Apply defaults
    if kind == "profile" then
        for k, v in pairs(defaults) do
            if self.db.profiles[k] == nil then
                self.db.profiles[k] = v
            end
        end
    end
end

function AceDB:ResetDB()
    if not self.db then
        error("Cannot call ResetDB before RegisterDB.", 2)
    end
    
    -- Clear all data
    for k in pairs(self.db) do
        self.db[k] = nil
    end
    
    -- Reapply defaults
    if self.db.defaults then
        for kind, defaults in pairs(self.db.defaults) do
            if kind == "profile" then
                self.db.profiles = {}
                for k, v in pairs(defaults) do
                    self.db.profiles[k] = v
                end
            end
        end
    end
end

AceLibrary:Register(AceDB, MAJOR_VERSION, MINOR_VERSION)
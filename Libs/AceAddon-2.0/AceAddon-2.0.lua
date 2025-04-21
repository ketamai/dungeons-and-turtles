local MAJOR_VERSION = "AceAddon-2.0"
local MINOR_VERSION = "$Revision: 1 $"

if not AceLibrary then error(MAJOR_VERSION .. " requires AceLibrary") end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end

if not AceLibrary:HasInstance("AceOO-2.0") then error(MAJOR_VERSION .. " requires AceOO-2.0") end
if not AceLibrary:HasInstance("AceEvent-2.0") then error(MAJOR_VERSION .. " requires AceEvent-2.0") end

local AceOO = AceLibrary:GetInstance("AceOO-2.0")
local AceEvent = AceLibrary:GetInstance("AceEvent-2.0")
local AceAddon = AceOO.Class()

function AceAddon.prototype:Initialize()
    -- To be overridden
end

function AceAddon.prototype:Enable()
    -- To be overridden
end

function AceAddon.prototype:Disable()
    -- To be overridden
end

function AceAddon:new(...)
    local class = AceOO.Mixin(self, AceEvent)
    class.super = self
    
    local object = class:New()
    object.class = class
    
    if object.Initialize then
        object:Initialize(...)
    end
    
    return object
end

AceLibrary:Register(AceAddon, MAJOR_VERSION, MINOR_VERSION)
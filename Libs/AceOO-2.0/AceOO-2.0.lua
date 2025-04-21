local MAJOR_VERSION = "AceOO-2.0"
local MINOR_VERSION = 90000 + tonumber(("$Revision: 1 $"):match("(%d+)"))

if not AceLibrary then error(MAJOR_VERSION .. " requires AceLibrary") end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end

local AceOO = {}

-- Class creation and inheritance
function AceOO.Class(parent)
    local class = {}
    class.__index = class
    class.class = class
    class.super = parent
    
    if parent then
        setmetatable(class, parent)
    end
    
    function class:New(...)
        local obj = {}
        setmetatable(obj, class)
        if obj.Initialize then
            obj:Initialize(...)
        end
        return obj
    end
    
    return class
end

-- Mixin support
function AceOO.Mixin(class, ...)
    for i = 1, select('#', ...) do
        local mixin = select(i, ...)
        for k, v in pairs(mixin) do
            if k ~= "class" and k ~= "super" and k ~= "__index" then
                class[k] = v
            end
        end
    end
    return class
end

AceLibrary:Register(MAJOR_VERSION, MINOR_VERSION, AceOO)
_G[MAJOR_VERSION] = AceOO
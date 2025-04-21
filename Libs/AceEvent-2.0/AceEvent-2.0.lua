local MAJOR_VERSION = "AceEvent-2.0"
local MINOR_VERSION = "$Revision: 1 $"

if not AceLibrary then error(MAJOR_VERSION .. " requires AceLibrary") end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end

if not AceLibrary:HasInstance("AceOO-2.0") then error(MAJOR_VERSION .. " requires AceOO-2.0") end

local AceOO = AceLibrary:GetInstance("AceOO-2.0")
local AceEvent = AceOO.Mixin {
    "RegisterEvent",
    "UnregisterEvent",
    "UnregisterAllEvents",
    "TriggerEvent",
}

function AceEvent:RegisterEvent(event, method, once)
    if type(event) ~= "string" then
        error("Bad argument #1 to `RegisterEvent' (string expected, got " .. type(event) .. ")", 2)
    end
    if not method then method = event end
    
    if type(method) ~= "string" and type(method) ~= "function" then
        error("Bad argument #2 to `RegisterEvent' (string or function expected, got " .. type(method) .. ")", 2)
    end
    
    if not self.frame then
        self.frame = CreateFrame("Frame")
        self.frame.obj = self
        self.frame:SetScript("OnEvent", function()
            this.obj:OnEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
        end)
    end
    
    if not self.events then self.events = {} end
    if not self.events[event] then
        self.frame:RegisterEvent(event)
    end
    self.events[event] = {method = method, once = once}
end

function AceEvent:UnregisterEvent(event)
    if not self.events or not self.events[event] then return end
    if self.frame then
        self.frame:UnregisterEvent(event)
    end
    self.events[event] = nil
end

function AceEvent:UnregisterAllEvents()
    if not self.events then return end
    if self.frame then
        self.frame:UnregisterAllEvents()
    end
    self.events = {}
end

function AceEvent:OnEvent(event, ...)
    if not self.events or not self.events[event] then return end
    
    local handler = self.events[event]
    if handler.once then
        self:UnregisterEvent(event)
    end
    
    if type(handler.method) == "string" then
        if type(self[handler.method]) == "function" then
            self[handler.method](self, event, ...)
        else
            error("Method " .. handler.method .. " not found", 2)
        end
    else
        handler.method(self, event, ...)
    end
end

function AceEvent:TriggerEvent(event, ...)
    if not event then
        error("Bad argument #1 to `TriggerEvent' (string expected, got nil)", 2)
    elseif type(event) ~= "string" then
        error("Bad argument #1 to `TriggerEvent' (string expected, got " .. type(event) .. ")", 2)
    end
    if not self.events or not self.events[event] then return end
    self:OnEvent(event, ...)
end

AceLibrary:Register(AceEvent, MAJOR_VERSION, MINOR_VERSION)
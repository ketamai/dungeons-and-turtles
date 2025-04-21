local MAJOR_VERSION = "AceConsole-2.0"
local MINOR_VERSION = "$Revision: 1 $"

if not AceLibrary then error(MAJOR_VERSION .. " requires AceLibrary") end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end

if not AceLibrary:HasInstance("AceOO-2.0") then error(MAJOR_VERSION .. " requires AceOO-2.0") end

local AceOO = AceLibrary:GetInstance("AceOO-2.0")
local AceConsole = AceOO.Mixin {
    "Print",
    "RegisterChatCommand",
    "UnregisterChatCommand",
    "UnregisterAllChatCommands",
}

function AceConsole:Print(...)
    DEFAULT_CHAT_FRAME:AddMessage(strjoin(" ", tostringall(...)))
end

function AceConsole:RegisterChatCommand(commands, options)
    if type(commands) ~= "table" then
        commands = {commands}
    end
    
    if not self.chatCommands then
        self.chatCommands = {}
    end
    
    for _, command in ipairs(commands) do
        if not command:match("^/") then
            error("Chat commands must start with /")
        end
        
        local name = command:sub(2):upper()
        _G["SLASH_" .. name .. "1"] = command
        
        if options then
            self.chatCommands[name] = options
            SlashCmdList[name] = function(msg)
                self:HandleChatCommand(name, msg)
            end
        end
    end
end

function AceConsole:UnregisterChatCommand(command)
    if not command:match("^/") then
        error("Chat commands must start with /")
    end
    
    local name = command:sub(2):upper()
    if self.chatCommands and self.chatCommands[name] then
        self.chatCommands[name] = nil
        _G["SLASH_" .. name .. "1"] = nil
        SlashCmdList[name] = nil
    end
end

function AceConsole:UnregisterAllChatCommands()
    if not self.chatCommands then return end
    
    for name in pairs(self.chatCommands) do
        _G["SLASH_" .. name .. "1"] = nil
        SlashCmdList[name] = nil
    end
    
    self.chatCommands = {}
end

function AceConsole:HandleChatCommand(name, msg)
    local options = self.chatCommands[name]
    if not options then return end
    
    local args = {}
    for arg in msg:gmatch("%S+") do
        table.insert(args, arg)
    end
    
    local command = args[1] or ""
    if options.args and options.args[command] then
        local handler = options.args[command]
        if handler.type == "execute" and type(handler.func) == "function" then
            handler.func()
        end
    elseif options.args and options.args[""] then
        local handler = options.args[""]
        if handler.type == "execute" and type(handler.func) == "function" then
            handler.func()
        end
    end
end

AceLibrary:Register(AceConsole, MAJOR_VERSION, MINOR_VERSION)
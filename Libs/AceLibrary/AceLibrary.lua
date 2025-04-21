--[[ AceLibrary - A library registration and loading system ]]--
local MAJOR_VERSION = "AceLibrary"
local MINOR_VERSION = 90000 + tonumber(("$Revision: 1 $"):match("(%d+)"))

if not AceLibrary then
    AceLibrary = {}
end

if not AceLibrary.libs then
    AceLibrary.libs = {}
end

if not AceLibrary.versions then
    AceLibrary.versions = {}
end

function AceLibrary:Register(major, minor, library, oldLib, parent)
    if not major then
        error("Bad argument #2 to `Register' (string expected)", 2)
    end
    if not minor then
        error("Bad argument #3 to `Register' (number expected)", 2)
    end
    if not library then
        error("Bad argument #4 to `Register' (table expected)", 2)
    end
    
    if not self.libs[major] then
        self.libs[major] = library
        self.versions[major] = minor
        return
    end
    
    if self.versions[major] and self.versions[major] >= minor then
        return
    end
    
    self.libs[major] = library
    self.versions[major] = minor
end

function AceLibrary:HasInstance(major)
    if not major then
        error("Bad argument #2 to `HasInstance' (string expected)", 2)
    end
    
    return self.libs[major] ~= nil
end

function AceLibrary:GetInstance(major)
    if not major then
        error("Bad argument #2 to `GetInstance' (string expected)", 2)
    end
    
    if not self.libs[major] then
        error(format("Cannot find a library instance of %s", major), 2)
    end
    
    return self.libs[major]
end
local OonuInvite = CreateFrame("Frame");
local Phrase = "oonutribeisthebest";

local function OonuSplit(string, delimiter)
  if delimiter == nil then
    delimiter = "_"
  end

  local length = strlen(string);
  local split = {};

  for c in string.gmatch(string, "([^"..delimiter.."]+)") do
    table.insert(split, c);
  end

  if #split > 0 then
    return split
  else
    return string
  end
end

local function contains(arr, value)
  for k,v in ipairs(arr) do
    if type(value) ~= "table" then
      if v == value then
        return true;
      end
    else
      for k1,v1 in ipairs(value) do
        if v1 == v then
          return true;
        end
      end
    end
  end
  return false;
end

local function IsOonu(name)
  local split = OonuSplit(name, "-");
  if type(split) == "table" then
    name = split[1];
  end

  if strlen(name) == 5 then
    if strsub(name, 2) == "oonu" then
      return true;
    end
  end
  return false;
end

local function LoopPopus(search)
  for k,v in pairs(StaticPopupDialogs) do
    local splitted = OonuSplit(k);

    if contains(splitted, search) then
      print(k);
    end
  end
end

--local KeyWords = {"PARTY", "CONFIRMATION", "GROUP", "INVITE"};
--LoopPopus(KeyWords);

local OonuEvents = {
  ["PARTY_INVITE_REQUEST"] = function(self, ...)
    local leader = ...;
    if IsOonu(leader) then
      AcceptGroup();
      StaticPopup_Hide("PARTY_INVITE");
      return true;
    else
      return false;
    end
  end,
  ["CHAT_MSG_WHISPER"] = function(self, ...)
    local msg, sender = ...;
    if IsOonu(sender) then
      if msg == Phrase then
        if IsInGroup() == true and C_PartyInfo.IsPartyFull() == true then
          SendChatMessage("The party is currently full", "WHISPER", GetDefaultLanguage("player"), sender);
        else
          C_PartyInfo.ConfirmInviteUnit(sender);
        end
      end
    end
  end,
}

for k,v in pairs(OonuEvents) do
  OonuInvite:RegisterEvent(k);
end

OonuInvite:SetScript("OnEvent", function(self, event, ...)
  if(OonuEvents[event] ~= nil) then
    OonuEvents[event](self, ...);
  end
end);

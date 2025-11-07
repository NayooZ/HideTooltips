local Addon = LibStub("AceAddon-3.0"):NewAddon("HideTooltips", "AceConsole-3.0")
local LSM = LibStub("AceConfigDialog-3.0")
local LDB = LibStub("LibDataBroker-1.1")
local LDI = LibStub("LibDBIcon-1.0")
function Addon:UpdateMinimapIcon()
    local enabled = self.db.profile.enabled
    local icon = enabled
        and "Interface\\AddOns\\HideTooltips\\media\\icon_on.tga"
        or "Interface\\AddOns\\HideTooltips\\media\\icon_off.tga"
    LibStub("LibDataBroker-1.1"):GetDataObjectByName("HideTooltips").icon = icon
end


-- Setup vars for tooltip groups
local BOBBER = {
    ["Fishing Bobber"] = true,
}

local POOLS = {
    ["Emperor Salmon School"] = true,
    ["Jade Lungfish School"] = true,
    ["Redbelly Mandarin School"] = true,
    ["Reef Octopus Swarm"] = true,
    ["Giant Mantis Shrimp Swarm"] = true,
    ["Tiger Gourami School"] = true,
    ["Jewel Danio School"] = true,
    ["Spinefish School"] = true,
    ["Krasarang Paddlefish School"] = true,
    ["Shipwreck Debris"] = true,
}

local MAILBOX = {
    ["Mailbox"] = true,
}

-------------------------------------------------------
-- TOOLTIP CHECK
-------------------------------------------------------
local function ShouldHideTooltip(tt)
    if not Addon.db.profile.enabled then return false end

    local name, unit = tt:GetUnit()
    local unitName

    if unit then
        unitName = UnitName(unit)
    else
        local left1 = _G[tt:GetName().."TextLeft1"]
        if left1 then unitName = left1:GetText() end
    end

    if not unitName then return false end

    if Addon.db.profile.hideBobber and BOBBER[unitName] then return true end
    if Addon.db.profile.hidePools and POOLS[unitName] then return true end
    if Addon.db.profile.hideMailbox and MAILBOX[unitName] then return true end

    return false
end

local function TooltipHook(tt)
    if ShouldHideTooltip(tt) then
        tt:Hide()
    end
end

-------------------------------------------------------
-- ADDON INITIALIZATION
-------------------------------------------------------
function Addon:OnInitialize()
self.db = LibStub("AceDB-3.0"):New("HideTooltipsDB", {
    profile = {
        enabled = true,
        hideBobber = true,
        hidePools = true,
        hideMailbox = true,

        minimap = {
            hide = false,   -- LibDBIcon requires this exact key
        },
    }
}, true)
end

-- LDB Object Start
local ldbObject = LDB:NewDataObject("HideTooltips", {
    type = "data source",
    text = "HideTooltips",
    icon = "Interface\\AddOns\\HideTooltips\\media\\icon_red.tga", -- default

    OnClick = function(_, button)
        if button == "LeftButton" then
            -- Toggle addon enabled state
            local db = Addon.db.profile
            db.enabled = not db.enabled

            print("HideTooltips: addon is now " ..
                (db.enabled and "|cff00ff00ENABLED|r" or "|cffff0000DISABLED|r"))

            Addon:UpdateMinimapIcon()  -- update the icon after each click

        elseif button == "RightButton" then
            -- Open AceConfig Options
            LibStub("AceConfigDialog-3.0"):Open("HideTooltips")
        end
    end,

    OnTooltipShow = function(tt)
        tt:AddLine("Hide Tooltips")
        tt:AddLine(" ")

        tt:AddLine("|cff00ff00Left-click|r – Toggle addon")
        tt:AddLine("|cff00ff00Right-click|r – Open options")
    end,
})
-- LDB Object end

function Addon:OnEnable()
    GameTooltip:HookScript("OnShow", TooltipHook)
    GameTooltip:HookScript("OnTooltipSetUnit", TooltipHook)
	    -- Register minimap icon
    LDI:Register("HideTooltips", ldbObject, self.db.profile.minimap)
	Addon:UpdateMinimapIcon()  -- Set correct icon on load
    -- Respect saved hide state
    if self.db.profile.minimap.hide then
        LDI:Hide("HideTooltips")
    else
        LDI:Show("HideTooltips")
    end

	self:RegisterChatCommand("htt", function()
    self.db.profile.enabled = not self.db.profile.enabled
    local msg = self.db.profile.enabled and "|cff00ff00ENABLED|r" or "|cffff0000DISABLED|r"
    print("HideTooltips: addon is now " .. msg)
    Addon:UpdateMinimapIcon()  -- apply new icon
	end)
	
end

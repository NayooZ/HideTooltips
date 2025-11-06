-- List of tooltips to be hidden
local HIDDEN_TOOLTIPS = {
    ["Fishing Bobber"] = true,
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

local hideTooltips = true  -- Initial setting to hide tooltips

local function isHiddenTooltip(tt)
    local name, unit = tt:GetUnit()
    if unit and UnitExists(unit) then
        local unitName = UnitName(unit)
        if HIDDEN_TOOLTIPS[unitName] then
            return true
        end
    end

    local left1 = _G[tt:GetName().."TextLeft1"]
    if left1 and HIDDEN_TOOLTIPS[left1:GetText()] then
        return true
    end

    return false
end

local function ttHide(tt)
    if tt:IsShown() and hideTooltips and isHiddenTooltip(tt) then
        tt:Hide()
    end
end

local function toggleTooltipVisibility()
    hideTooltips = not hideTooltips
    local status = hideTooltips and "hidden" or "shown"
    print("Tooltip visibility is now: " .. status)
end

-- Hook functions
GameTooltip:HookScript("OnTooltipSetUnit", ttHide)
GameTooltip:HookScript("OnShow", ttHide)

-- Slash command for toggling tooltip visibility
SLASH_TOOLTIPTOGGLE1 = "/htt"
SlashCmdList["TOOLTIPTOGGLE"] = function()
    hideTooltips = not hideTooltips
    local statusText = hideTooltips and "|cFFFF0000hidden|r" or "|cFF00FF00shown|r"  -- Red or Green text
    print("Tooltip visibility is now: " .. statusText)
end
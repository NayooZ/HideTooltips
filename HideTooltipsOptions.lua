local Addon = LibStub("AceAddon-3.0"):GetAddon("HideTooltips")
local AceConfig = LibStub("AceConfig-3.0")
local AceDialog = LibStub("AceConfigDialog-3.0")

-------------------------------------------------------
-- OPTIONS TABLE
-------------------------------------------------------
local options = {
    type = "group",
    name = "Hide Tooltips",
    args = {

        -- ======================
        -- Enable Addon & Minimap Icon
        -- ======================
        enabled = {
            type = "toggle",
            name = "Enable Addon",
            desc = "Master switch: when disabled, no tooltips are hidden.",
            width = "full",
            order = 1,
            get = function() return Addon.db.profile.enabled end,
			set = function(_, val)
			Addon.db.profile.enabled = val
			Addon:UpdateMinimapIcon()
			end
        },
		minimapToggle = {
			type = "toggle",
			name = "Show Minimap Icon",
			desc = "Toggle the HideTooltips minimap button.",
			width = "full",
			order = 2,
			get = function() return not Addon.db.profile.minimap.hide end,
			set = function(_, val)
				Addon.db.profile.minimap.hide = not val
				if val then
					LibStub("LibDBIcon-1.0"):Show("HideTooltips")
				else
					LibStub("LibDBIcon-1.0"):Hide("HideTooltips")
				end
			end
			},

        -- Blank space because UX
        blank1 = {
            type = "description",
            name = " ",
            order = 3,
        },

        -- ======================
        -- Tooltip toggles, start index at 3 to account for above options
        -- ======================

        hideBobber = {
            type = "toggle",
            name = "Hide Fishing Bobber",
            desc = "Hide tooltip for Fishing Bobber.",
            width = "full",
            order = 3,
            get = function() return Addon.db.profile.hideBobber end,
            set = function(_, val) Addon.db.profile.hideBobber = val end,
        },

        hidePools = {
            type = "toggle",
            name = "Hide Fishing Pools",
            desc = "Hide all fishing pool and debris tooltips.",
            width = "full",
            order = 4,
            get = function() return Addon.db.profile.hidePools end,
            set = function(_, val) Addon.db.profile.hidePools = val end,
        },

        hideMailbox = {
            type = "toggle",
            name = "Hide Mailbox",
            desc = "Hide tooltip for Mailboxes.",
            width = "full",
            order = 5,
            get = function() return Addon.db.profile.hideMailbox end,
            set = function(_, val) Addon.db.profile.hideMailbox = val end,
        },

    }
}

-------------------------------------------------------
-- REGISTER OPTIONS
-------------------------------------------------------
AceConfig:RegisterOptionsTable("HideTooltips", options)
AceDialog:AddToBlizOptions("HideTooltips", "Hide Tooltips")

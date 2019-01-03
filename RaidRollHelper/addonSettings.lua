local addon = RAID_ROLL_HELPER
local interface = addon.interface
local settings = addon.settings
local size = settings.interface.size
local fn = addon.functions
local L = addon.L
local Prefix = addon.settings.prefix
local color = settings.color
local RaidRollHelper = addon.lib
local Ace = LibStub("AceKGUI-3.0")


interface.addSet = Ace:Create('Frame')
local addSet = interface.addSet
addSet:SetTitle("Raid Roll Helper")
addSet:SetWidth(size.settingsW)
addSet:SetHeight(size.settingsH)

addSet.closeButton = Ace:Create('Button')
local frame = addSet.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
frame:SetCallback('OnClick', function()
	addSet:Hide()
end)
addSet:AddChild(frame)

addSet.winAlert = Ace:Create('CheckBox')
local frame = addSet.winAlert
frame:SetWidth(180)
frame:SetLabel('Оповещение о победе')
frame:SetTooltip('Показывать окно с оповещением о победе')
frame:SetCallback('OnValueChanged', function()
	RaidRollHelper.db.global.addonSettings.winAlert = frame:GetValue()
end)
addSet:AddChild(frame)

addSet.easyRoll = Ace:Create('CheckBox')
local frame = addSet.easyRoll
frame:SetWidth(180)
frame:SetLabel('easy roll')
frame:SetTooltip('Показывать окно с предложением выставить предмет на ролл')
frame:SetCallback('OnValueChanged', function()
	RaidRollHelper.db.char.addonSettings.easyRoll = frame:GetValue()
end)
addSet:AddChild(frame)




-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	addSet.closeButton:ClearAllPoints()
	addSet.closeButton:SetPoint("CENTER", addSet.frame, "TOPRIGHT", -8, -8)
	
	addSet.winAlert:ClearAllPoints()
	addSet.winAlert:SetPoint("TOPLEFT", addSet.frame, "TOPLEFT", 15, -20)
	addSet.winAlert:SetValue(RaidRollHelper.db.global.addonSettings.winAlert)
	
	addSet.easyRoll:SetValue(RaidRollHelper.db.char.addonSettings.easyRoll)
	
	addSet:Hide()
end)

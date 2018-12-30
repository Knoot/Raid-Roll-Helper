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



interface.rollFrame = Ace:Create('Frame')
local rollFrame = interface.rollFrame
--rollFrame:Hide()

rollFrame:SetTitle("Raid Roll Helper")
rollFrame:SetWidth(size.frameW)
rollFrame:SetHeight(size.frameH)

rollFrame.title:SetScript('OnMouseUp', function(mover)
	local DB = addon.lib.db.global
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = rollFrame.frame:GetPoint(1)
	DB.rollFrame = {}
	DB.rollFrame.point=point
	DB.rollFrame.relativeTo=relativeTo
	DB.rollFrame.relativePoint=relativePoint
	DB.rollFrame.xOfs=xOfs
	DB.rollFrame.yOfs=yOfs
end)

rollFrame.closeButton = Ace:Create('Button')
local frame = rollFrame.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
frame:SetCallback('OnClick', function()
	interface.rollFrame:Hide()
	settings.forceHide = true
end)
rollFrame:AddChild(frame)

interface.rollFrame.rollBar = Ace:Create('SimpleGroup')
local rollBar = interface.rollFrame.rollBar
rollBar:SetLayout("List")
rollBar:SetWidth(size.rollBarW)
rollFrame:AddChild(rollBar)

interface.rollFrame.timer = Ace:Create('Label')
local frame = interface.rollFrame.timer
frame:SetText('roll timer')
frame:SetFont(settings.ruFont, 14)
rollBar:AddChild(frame)

interface.rollFrame.ico = Ace:Create('Icon')
local frame = interface.rollFrame.ico
frame:SetImageSize(size.rollBarW, size.rollBarW)
frame:SetImage(134414)
rollBar:AddChild(frame)

interface.rollFrame.ilvls = Ace:Create('ScrollFrame')
local frame = interface.rollFrame.ilvls
frame:SetLayout("List")
frame:SetWidth(size.rollBarW)
frame:SetHeight(size.ilvlsH)
rollBar:AddChild(frame)

interface.rollFrame.ilvls.items = Ace:Create('SimpleHTML')
local frame = interface.rollFrame.ilvls.items
frame:SetFont(settings.ruFont, 12)
frame:SetFullWidth(true)
frame:SetFullHeight(true)
frame:SetText('<html><body><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p><p>ilvls List</p></body></html>');
interface.rollFrame.ilvls:AddChild(frame)

interface.rollFrame.needBtn = Ace:Create('Icon')
local frame = interface.rollFrame.needBtn
frame:SetTooltip(L["Нужно"])
frame.frame:SetSize(25,25)
frame:SetImageSize(25, 25)
frame:SetTex("Interface\\Buttons\\UI-GroupLoot-Dice-Up", "Interface\\Buttons\\UI-GroupLoot-Dice-Highlight", "Interface\\Buttons\\UI-GroupLoot-Dice-Down", "Interface\\Buttons\\UI-GroupLoot-Dice-Down")
rollBar:AddChild(frame)

interface.rollFrame.offSpecBtn = Ace:Create('Icon')
local frame = interface.rollFrame.offSpecBtn
frame.frame:SetSize(25,25)
frame:SetImageSize(25, 25)
frame:SetTooltip(L["На офф спек"])
frame:SetTex("Interface\\Buttons\\UI-GroupLoot-Coin-Up", "Interface\\Buttons\\UI-GroupLoot-Coin-Highlight", "Interface\\Buttons\\UI-GroupLoot-Coin-Down", "Interface\\Buttons\\UI-GroupLoot-Coin-Down")
rollBar:AddChild(frame)

interface.rollFrame.transmogBtn = Ace:Create('Icon')
local frame = interface.rollFrame.transmogBtn
frame:SetTooltip(L["На трансмог"])
frame.frame:SetSize(20,20)
frame:SetImageSize(20, 20)
frame:SetTex("Interface\\AddOns\\RaidRollHelper\\Textures\\inv_alchemy_potion_Up", "Interface\\AddOns\\RaidRollHelper\\Textures\\inv_alchemy_potion_Highlight", "Interface\\AddOns\\RaidRollHelper\\Textures\\inv_alchemy_potion_Down", "Interface\\AddOns\\RaidRollHelper\\Textures\\inv_alchemy_potion_Down")
rollBar:AddChild(frame)

interface.rollFrame.falseBtn = Ace:Create('Icon')
local frame = interface.rollFrame.falseBtn
frame:SetTooltip(L["Отказаться"])
frame.frame:SetSize(20,20)
frame:SetImageSize(20, 20)
frame:SetTex("Interface\\Buttons\\UI-GroupLoot-Pass-Up", "Interface\\Buttons\\UI-GroupLoot-Pass-Highlight", "Interface\\Buttons\\UI-GroupLoot-Pass-Down")
rollBar:AddChild(frame)

interface.rollFrame.rollResult = Ace:Create('ScrollFrame')
local frame = interface.rollFrame.rollResult
frame:SetLayout("Flow")
frame:SetWidth(size.frameW - size.rollBarW - 40)
frame:SetHeight(size.frameH - 30)
rollFrame:AddChild(frame)

interface.rollFrame.rollResult.result = Ace:Create('SimpleHTML')
local frame = interface.rollFrame.rollResult.result
frame:SetFont(settings.ruFont, 14)
frame:SetText('<html><body><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p><p>resultsssssssssssssssssssssssssssssssssssssssss</p><p>result</p></body></html>');
frame:SetFullHeight(true)
frame:SetFullWidth(true)
interface.rollFrame.rollResult:AddChild(frame)








interface.easyRoll = Ace:Create('Frame')
local frame = interface.easyRoll
frame:SetTitle('easy Roll')
frame:SetWidth(size.easyRollW)
frame:SetHeight(size.easyRollH)

frame.title:SetScript('OnMouseUp', function(mover)
	local DB = addon.lib.db.global
	local frame = mover:GetParent()
	frame:StopMovingOrSizing()
	local self = frame.obj
	local status = self.status or self.localstatus
	status.width = frame:GetWidth()
	status.height = frame:GetHeight()
	status.top = frame:GetTop()
	status.left = frame:GetLeft()
	
	local point, relativeTo,relativePoint, xOfs, yOfs = interface.easyRoll.frame:GetPoint(1)
	DB.easyRoll = {}
	DB.easyRoll.point=point
	DB.easyRoll.relativeTo=relativeTo
	DB.easyRoll.relativePoint=relativePoint
	DB.easyRoll.xOfs=xOfs
	DB.easyRoll.yOfs=yOfs
end)

interface.easyRoll.ico = Ace:Create('Icon')
local frame = interface.easyRoll.ico
frame:SetImageSize(interface.easyRoll.frame:GetHeight()-60, interface.easyRoll.frame:GetHeight()-60)
frame:SetImage(134414)
frame.tooltip = CreateFrame("GameTooltip", "easyRollItemTooltip", frame.frame, "GameTooltipTemplate")
interface.easyRoll:AddChild(frame)

interface.easyRoll.isTransmog = Ace:Create('CheckBox')
local frame = interface.easyRoll.isTransmog
frame:SetWidth(160)
frame:SetLabel(L["На трансмог"])
frame:SetTooltip(L["Разрешить роллить на трансмог"])
frame:SetValue(true)
interface.easyRoll:AddChild(frame)

interface.easyRoll.isOffSpec = Ace:Create('CheckBox')
local frame = interface.easyRoll.isOffSpec
frame:SetWidth(160)
frame:SetLabel(L["На офф спек"])
frame:SetTooltip(L["Разрешить роллить на офф спек"])
frame:SetValue(true)
frame:SetCallback("OnValueChanged", function()
	interface.easyRoll.isTransmog:SetDisabled(not frame:GetValue())
end)
interface.easyRoll:AddChild(frame)

interface.easyRoll.yesBtn = Ace:Create('Button')
local frame = interface.easyRoll.yesBtn
frame:SetText(L["Отправить"])
frame:SetWidth(120)
interface.easyRoll:AddChild(frame)

interface.easyRoll.noBtn = Ace:Create('Button')
local frame = interface.easyRoll.noBtn
frame:SetText(L["Не отправлять"])
frame:SetWidth(120)
frame:SetCallback('OnClick', function()
	interface.easyRoll:Hide()
end)
interface.easyRoll:AddChild(frame)

local frame = CreateFrame('Frame')
frame:RegisterEvent('SHOW_LOOT_TOAST')
frame:SetScript('OnEvent', function(self, event, type, link)
	if not RaidRollHelper.db.char.addonSettings.easyRoll then return end
	--if event == 'SHOW_LOOT_TOAST' then
		--item [Печать королевского лоа] 1 0 2 true 3 false false
		if not (IsInRaid(LE_PARTY_CATEGORY_HOME) or IsInGroup(LE_PARTY_CATEGORY_HOME)) then return end
		if not type=='item' then return end
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID,bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(link)
	-- if green or lower
		if itemRarity<3 then return end
	-- if not armor or weapon
		if not itemType == L["Доспехи"] and not itemType == L["Оружие"] then return end
		if itemName == nil then fn:debug('fatalError', 'easyRoll itemName == nil') end
		local frame = interface.easyRoll.ico
		frame:SetImage(iconFileDataID)
		frame:SetCallback('OnEnter', function(frame)
			frame.tooltip:SetOwner(frame.frame, "ANCHOR_LEFT")
			frame.tooltip:SetHyperlink(link)
			frame.tooltip:Show()
		end)
		frame:SetCallback("OnLeave", function(frame)
			frame.tooltip:Hide()
		end)
		interface.easyRoll:Show()
		interface.easyRoll.yesBtn:SetCallback('OnClick', function()
			C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.roll.new..itemLink, fn:RRH_msg_loc())
			interface.easyRoll:Hide()
		end)
	--end
end)




interface.winRoll = Ace:Create('Frame')
local winRoll = interface.winRoll
winRoll:SetTitle("Raid Roll Helper")
winRoll:SetWidth(size.winRollW)
winRoll:SetHeight(size.winRollH)
winRoll.list = {}

winRoll.closeButton = Ace:Create('Button')
local frame = winRoll.closeButton
frame:SetText('Ok')
frame:SetWidth(30)
frame:SetCallback('OnClick', function()
	table.remove(winRoll.list, 1)
	winRoll:Hide()
	if #winRoll.list == 0 then return end
	fn:showWinFrame()
end)
winRoll:AddChild(frame)

winRoll.ico = Ace:Create('Icon')
local frame = winRoll.ico
frame:SetWidth(size.winRollH-20)
frame:SetHeight(frame.frame:GetWidth())
frame:SetImage(134414)
frame.tooltip = CreateFrame("GameTooltip", "winRollItemTooltip", frame.frame, "GameTooltipTemplate")
frame:SetCallback('OnEnter', function(frame)
	if not frame.link then return end
	frame.tooltip:SetOwner(frame.frame, "ANCHOR_LEFT")
	frame.tooltip:SetHyperlink(frame.link)
	frame.tooltip:Show()
end)
frame:SetCallback("OnLeave", function(frame)
	frame.tooltip:Hide()
end)
winRoll:AddChild(frame)

winRoll.leader = Ace:Create('Label')
local frame = winRoll.leader
frame:SetWidth(size.winRollW - winRoll.ico.frame:GetWidth() - 20)
frame:SetText('take loot')
winRoll:AddChild(frame)





-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	interface.rollFrame.closeButton:ClearAllPoints()
	interface.rollFrame.closeButton:SetPoint("CENTER", interface.rollFrame.frame, "TOPRIGHT", -8, -8)
	
	interface.rollFrame.ico:ClearAllPoints()
	interface.rollFrame.ico:SetPoint("TOPLEFT", interface.rollFrame.timer.frame, "BOTTOMLEFT", -5, -5)
	
	interface.rollFrame.rollBar:ClearAllPoints()
	interface.rollFrame.rollBar:SetPoint("TOPLEFT", interface.rollFrame.frame, "TOPLEFT", 15, -20)
	
	interface.rollFrame.offSpecBtn:ClearAllPoints()
	interface.rollFrame.offSpecBtn:SetPoint("TOPLEFT", interface.rollFrame.needBtn.frame, "TOPRIGHT", 5, 0)
	
	interface.rollFrame.transmogBtn:ClearAllPoints()
	interface.rollFrame.transmogBtn:SetPoint("TOPLEFT", interface.rollFrame.offSpecBtn.frame, "TOPRIGHT", 5, 0)
	
	interface.rollFrame.falseBtn:ClearAllPoints()
	interface.rollFrame.falseBtn:SetPoint("TOPLEFT", interface.rollFrame.transmogBtn.frame, "TOPRIGHT", 5, 0)
	
	interface.rollFrame.rollResult:ClearAllPoints()
	interface.rollFrame.rollResult:SetPoint("TOPRIGHT", interface.rollFrame.frame, "TOPRIGHT", -10, -22)
	
	interface.easyRoll.ico:ClearAllPoints()
	interface.easyRoll.ico:SetPoint("TOPLEFT", interface.easyRoll.frame, "TOPLEFT", 5, -15)
	
	interface.easyRoll.isOffSpec:ClearAllPoints()
	interface.easyRoll.isOffSpec:SetPoint("TOPLEFT", interface.easyRoll.ico.frame, "TOPRIGHT", 10, -10)
	
	interface.easyRoll.isTransmog:ClearAllPoints()
	interface.easyRoll.isTransmog:SetPoint("TOPLEFT", interface.easyRoll.isOffSpec.frame, "BOTTOMLEFT", 0, 0)
	
	interface.easyRoll.yesBtn:ClearAllPoints()
	interface.easyRoll.yesBtn:SetPoint("TOPLEFT", interface.easyRoll.ico.frame, "BOTTOMLEFT", 15, 0)
	
	interface.easyRoll.noBtn:ClearAllPoints()
	interface.easyRoll.noBtn:SetPoint("TOPLEFT", interface.easyRoll.yesBtn.frame, "TOPRIGHT", 20, 0)
	
	interface.easyRoll:Hide()
	
	winRoll.closeButton:ClearAllPoints()
	winRoll.closeButton:SetPoint("BOTTOMRIGHT", winRoll.frame, "BOTTOMRIGHT", -10, 10)
	
	winRoll.ico:ClearAllPoints()
	winRoll.ico:SetPoint("TOPLEFT", winRoll.frame, "TOPLEFT", 2, -20)
	
	winRoll.leader:ClearAllPoints()
	winRoll.leader:SetPoint("TOPLEFT", winRoll.ico.frame, "TOPRIGHT", 0, -10)
	
	winRoll:Hide()
end)

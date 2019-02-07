local addon = RAID_ROLL_HELPER
local settings = addon.settings
local Prefix = addon.settings.prefix
local fn = addon.functions
local interface = addon.interface
local L = addon.L
local data = addon.data
local color = settings.color


local Console = LibStub("AceConsole-3.0")
local AceGUI = LibStub("AceKGUI-3.0")
local RaidRollHelper = addon.lib
local DB

function RaidRollHelper:OnEnable()
	fn:settingsReplace()
	if DB.rollFrame then
		if DB.rollFrame.point==nil then return fn:debug('fatalError', 'fatal error anchor 23') end
		interface.rollFrame:ClearAllPoints()
		interface.rollFrame:SetPoint(
			DB.rollFrame.point,
			DB.rollFrame.relativeTo,
			DB.rollFrame.relativePoint,
			DB.rollFrame.xOfs,
			DB.rollFrame.yOfs
		)
	end
	if DB.easyRoll then
		if DB.easyRoll.point==nil then return fn:debug('fatalError', 'fatal error anchor 34') end
		interface.easyRoll.frame:ClearAllPoints()
		interface.easyRoll.frame:SetPoint(
			DB.easyRoll.point,
			DB.easyRoll.relativeTo,
			DB.easyRoll.relativePoint,
			DB.easyRoll.xOfs,
			DB.easyRoll.yOfs
		)
	end
	C_ChatInfo.RegisterAddonMessagePrefix(Prefix.addon)
	
	local frame=CreateFrame("Frame")
	frame:RegisterEvent('GROUP_ROSTER_UPDATE')
	frame:RegisterEvent('PLAYER_ENTERING_WORLD')
	frame:SetScript('OnEvent', function(_, event)
		if event == 'PLAYER_ENTERING_WORLD' then
			if not settings.beta and not settings.version_verified and (settings.versionCheck - time()) <= 0 then
				settings.versionCheck = settings.versionCheckTime + time()
				C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.version..settings.version,'GUILD')
			end
		end
		if IsInRaid(LE_PARTY_CATEGORY_HOME) or IsInGroup(LE_PARTY_CATEGORY_HOME) then
			fn:RRH_raid_list_update()
		end
	end)
	
	
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("CHAT_MSG_ADDON")
	frame:SetScript("OnEvent", function(...) fn:itemListDistribution(...) end)
		
	Console:RegisterChatCommand('ro', 'RaidRollHelperStart')
	Console:RegisterChatCommand('rrh', 'RaidRollHelperStart')
end

function RaidRollHelper:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("RaidRollHelperDB")
	
	DB = self.db.global
	
	
																			--{		frames pos
	DB.rollFrame = type(DB.rollFrame) == 'table' and DB.rollFrame or nil	--
	DB.easyRoll = type(DB.easyRoll) == 'table' and DB.easyRoll or nil		--}
	
	DB.addonSettings = type(DB.addonSettings) == 'table' and DB.addonSettings or {}
	DB.addonSettings.winAlert = DB.addonSettings.winAlert == nil and true or DB.addonSettings.winAlert
	
	self.db.char.addonSettings = type(self.db.char.addonSettings) == 'table' and self.db.char.addonSettings or {}
	self.db.char.addonSettings.easyRoll = self.db.char.addonSettings.easyRoll == nil and true or self.db.char.addonSettings.easyRoll
	
	
	
	DB.debug 								= type(DB.debug) == 'table' and DB.debug or {}
	DB.debug.state							= DB.debug.state or false
	DB.debug.MSG 							= type(DB.debug.MSG) == 'table' and DB.debug.MSG or {}
	DB.debug.MSG.state 						= DB.debug.MSG.state or false
	DB.debug.MSG.types 						= type(DB.debug.MSG.types) == 'table' and DB.debug.MSG.types or {}
	DB.debug.MSG.types.message 				= type(DB.debug.MSG.types.message) == 'table' and DB.debug.MSG.types.message or {}
	DB.debug.MSG.types.message.newroll 		= DB.debug.MSG.types.message.newroll or false
	DB.debug.MSG.types.message.getSetRoll 	= DB.debug.MSG.types.message.getSetRoll or false
	DB.debug.MSG.types.message.ver 			= DB.debug.MSG.types.message.ver or false
	DB.debug.MSG.types.message.count 		= DB.debug.MSG.types.message.count or false
	DB.debug.MSG.types.message.filters 		= DB.debug.MSG.types.message.filters or false
	DB.debug.MSG.types.message.companions 	= DB.debug.MSG.types.message.companions or false
	DB.debug.MSG.types.message.functions 	= DB.debug.MSG.types.message.functions or false
	DB.debug.MSG.types.message.log 			= DB.debug.MSG.types.message.log or false
	
	
	
	DB.filters = type(DB.filters) == 'table' and DB.filters or {}
	DB.filters.skipBagSearch = DB.filters.skipBagSearch or false
	DB.filters.seeMyRoll = DB.filters.seeMyRoll or false
end

function Console:RaidRollHelperStart(str)
	if str=='' then return Console:RaidRollHelperHelp()end
	if str=='reset' then
		DB.point = nil
		interface.rollFrame.frame:ClearAllPoints()
		interface.rollFrame.frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
		
		DB.easyRoll = nil
		interface.easyRoll.frame:ClearAllPoints()
		interface.easyRoll.frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
		
		return fn:Print(L["Позиция по умолчанию"])
	elseif str=='find' then
	--	игроки с аддоном
		return fn:findAddon()
	elseif str=='debug' then
		--DB.debug.state=not DB.debug.state
		--settings.timeToRoll=DB.debug.state and 10 or 60
		return interface.debug.DebugFrame:Show()
		--return fn:Print('RRH-Debug '..(DB.debug.state and color['green']..'on|r' or color['red']..'off|r' ))
	elseif str=='guild' then
		fn:Print(L["Аддон установлен у:"])
		return C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.version..'1', 'GUILD')
	elseif str=='test' then
		return fn:NewTestRoll()
	elseif str=='settings' then
		return interface.addSet:Show()
	end
	
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID,bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(str)
	
--	if str not item
	if itemName==nil then fn:Print(color['red']..'RRH: |r'..L["Некорректная команда"]..': '..color['yellow']..str); return Console:RaidRollHelperHelp() end
--	if item not exist in bags	
	if not fn:ifItemExist(itemLink) and not DB.filters.skipBagSearch then return fn:Print(L["Предмет не найден в сумках"]) end
--	if not armor or weapon
	if not itemType == L["Доспехи"] and not itemType == L["Оружие"] then return fn:Print(L["Предмет не является частью экипировки"]) end
	
	local frame = interface.easyRoll.ico
		frame:SetImage(iconFileDataID)
		frame:SetCallback('OnEnter', function()
			frame.tooltip:SetOwner(frame.frame, "ANCHOR_LEFT")
			frame.tooltip:SetHyperlink(itemLink)
			frame.tooltip:Show()
		end)
		frame:SetCallback("OnLeave", function()
			frame.tooltip:Hide()
		end)
	interface.easyRoll.yesBtn:SetCallback('OnClick', function()
			local isOff = interface.easyRoll.isOffSpec:GetValue() and 1 or 0
			local isMog = (isOff == 1 and interface.easyRoll.isTransmog:GetValue()) and 1 or 0
			C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.roll.new..itemLink..';'..isOff..';'..isMog, fn:RRH_msg_loc())
			interface.easyRoll:Hide()
		end)
		
	interface.easyRoll.isTransmog:SetValue(not fn:isTransmogNotCollected(itemLink))
	interface.easyRoll:Show()
end

function Console:RaidRollHelperHelp() -- Подсказки в игре
	fn:Print("|cFFFFFFFFRaidRollHelper v_"..settings.version..(settings.beta and "_beta" or '').."|r |cFFFF99FF(=^..^=)|r:")
	fn:Print("/|cFFFF99FFro|r find - "..L["подсчет количества игроков в рейде с аддоном Raid Roll Helper"])
	fn:Print("/|cFFFF99FFro|r reset - "..L["вернуть окно ролла в середину экрана"])
	fn:Print("/|cFFFF99FFro|r test - "..L["команда предназначена для ознакомления с аддоном"])
	fn:Print("/|cFFFF99FFro|r settings - "..L["открыть окно настроек аддона"])
	--[[fn:Print("/|cFFFF99FFro|r itemLink - "..L["отправить предмет на ролл"].."\n"..
			L["itemLink help"].."\n"..
			"|cFFFF99FFitemLink|r - |cffa335ee|Hitem:151311::::::::110:270::2:3:1726:1517:3528:::|h[Печать Триумвирата]|h|r")]]
	if DB.debug.MSG.state then
		fn:Print('RRH-Debug '..color['green']..'on|r')
		fn:Print("/|cFFFF99FFro|r guild - люди в гильдии с аддоном")
	end
end

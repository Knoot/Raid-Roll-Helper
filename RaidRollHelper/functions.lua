local addon=RAID_ROLL_HELPER
local fn=addon.functions
local L = addon.L
local interface = addon.interface
local settings = addon.settings
local color = settings.color
local Prefix = settings.prefix
local data = addon.data
local RaidRollHelper = addon.lib
local DB
local ITEM_INFO_RECEIVED = CreateFrame('Frame')



function fn:rollSet(item, Type)	--	item = playerName#itemName#roll(string), Type = rollType(string)
	if type(item) ~= 'string' or  type(Type) ~= 'string' then return fn:debug('functions', 'rollSet(item(string|'..type(item)..') - playerName#itemName#roll, Type(string|'..type(Type)..') - rollType)') end
	local i=0
	local name,itemName,ROLL=fn:split(item,'#')
--	GET i
	for n=1,#data.roll_list do
		if data.roll_list[n][itemName] then i=n;break end
	end
	if i==0 then return fn:debug('error', 'item i='..i..' not exist') end
	
--	if double roll
	local exist=false
	item = data.roll_list[i][itemName][Type]
	for n=1,#item do
		if item[n].name==name then
			exist=true
			fn:debug('roll', color['red']..'Ролл не засчитан|r, пользователь уже отправлял ролл на этот предмет')
			break
		end
	end
	
	if not exist then
		table.insert(item, {['name']=name,['roll']=ROLL})
		item=fn:sortRoll(item)
	end
end

function fn:updateItemList(item, offSpec, transmog, sender, socket)	--	item = data.roll_list[n][itemName](table), offSpec = canOffSpecRoll(boolean), transmog = canTransmogRoll(boolean), sender = playerName(string), socket = socket(number)
	if type(item) ~= 'table' or  type(offSpec) ~= 'boolean' or  type(transmog) ~= 'boolean' or type(sender) ~= 'string'  or type(socket) ~= 'number' then return fn:debug('functions', 'updateItemList(item(table|'..type(item)..') - item data, sender(string|'..type(sender)..') - playerName, socket(number|'..type(socket)..') - socketWeight)') end
	for i=1,#item.ilvls do
		if item.ilvls[i].sender==sender then return end
	end
	
	table.insert(item.ilvls, {
		sender = sender,
		ilvl = itemLevel,
		Item_link = item,
		socket = socket,
		isTransmog = transmog,
		isOffSpec = offSpec,
	})
	item.endTime = GetTime() + settings.timeToRoll
end

function fn:isTransmogNotCollected(item)
	local invType = select(9, GetItemInfo(item))
	local isTransmog = true
	if invType == "INVTYPE_FINGER" or invType == "INVTYPE_NECK" or invType == "INVTYPE_TRINKET" then
		isTransmog = false
	else
		local appearanceID = C_TransmogCollection.GetItemInfo(item)
		if appearanceID then
			local sourceID = C_TransmogCollection.GetAllAppearanceSources(appearanceID)[1]
			if sourceID then
				local data = C_TransmogCollection.GetSourceInfo(sourceID)
				if data then
					isTransmog = not data.isCollected
				end
			end
		end
	end
	return isTransmog
end

function fn:itemListNew(item, itemName, itemLevel, iconFileDataID, offSpec, transmog, hide, sender, endTime, socket, lootSpec, itemEquipLoc, testRoll)	--	item = itemLink(string), itemName(string), itemLevel(number), iconFileDataID(number), offSpec = canOffSpecRoll(boolean), transmog = canTransmogRoll(boolean), hide = hideRoll(boolean), sender = playerName(string), endTime = timeOfEndRoll(number), socket(number) - socketWeight, lootSpec = needLootForSpec(number), itemEquipLoc(string), testRoll(boolean)
	if type(item) ~= 'string' or type(itemName) ~= 'string' or type(itemLevel) ~= 'number' or type(iconFileDataID) ~= 'number' or  type(offSpec) ~= 'boolean' or  type(transmog) ~= 'boolean' or type(hide) ~= 'boolean' or type(sender) ~= 'string' or type(endTime) ~= 'number' or type(socket) ~= 'number' or type(lootSpec) ~= 'number' or type(itemEquipLoc) ~= 'string' or type(testRoll) ~= 'boolean' then
		return fn:debug('functions', 'itemListNew('..
		'item(string|'..type(item)..') - item Link,'..
		'itemName(string|'..type(itemName)..') - item Name, '..
		'itemLevel(number|'..type(itemLevel)..') - item Level, '..
		'iconFileDataID(number|'..type(iconFileDataID)..') - icon file, '..
		'offSpec(boolean|'..type(offSpec)..') - can offspec roll, '..
		'transmog(boolean|'..type(transmog)..') - can transmog roll, '..
		'hide(boolean|'..type(hide)..') - hide item roll, '..
		'sender(string|'..type(sender)..') - playerName, '..
		'endTime(number|'..type(endTime)..') - time Of End Roll, '..
		'socket(number|'..type(socket)..') - socketWeight, '..
		'lootSpec(number|'..type(lootSpec)..') - needLootForSpec[0-2], '..
		'itemEquipLoc(string|'..type(itemEquipLoc)..') - item Equip Location, '..
		'testRoll(boolean|'..type(testRoll)..') - is test roll'..
		')')
	end
	local isTransmog = fn:isTransmogNotCollected(item)
	
	table.insert(data.roll_list, {
		[itemName]={
			link = item,
			ico = iconFileDataID,
			need = {},
			offSpec = {},
			transmog = {},
			lootSpec = lootSpec,
			isTransmog = isTransmog,
			ilvls = {},
			endTime = endTime,
			hide = hide,
			test = testRoll or false,
		}
	})
	table.insert(data.roll_list[#data.roll_list][itemName].ilvls, {
		sender = sender,
		ilvl = itemLevel,
		Item_link = item,
		socket = socket,
		isTransmog = transmog,
		isOffSpec = offSpec,
	})
--	Print info new roll
	if sender==settings.playerName then
		fn:Print(string.format(L["Ролл был успешно отправлен. %s"],item))
	else
		fn:Print(string.format(L["Новый ролл был отправлен. %s"],item))
	end
end

function fn:NewTestRoll()
	--[[
	
	"|cff0070dd|Hitem:159665::::::::120:66:512:18:1:4776:116:::|h[Щит древнего смотрителя]|h|r"
	"|cffa335ee|Hitem:160649::::::::120:66::5:1:3524:::|h[Укрепляющий экстракт]|h|r"
	"|cff0070dd|Hitem:159611::::::::120:66:512:19:1:4776:118:::|h[Большая красная кнопка Разданка]|h|r"
	"|cffa335ee|Hitem:160681:5963:153712::::::120:581::5:4:4799:1808:1492:4786:::|h[Боевой клинок хранителей]|h|r"
	]]
	local item = settings.prefix.roll.new.."|cffa335ee|Hitem:151311::::::::110:270::2:3:1726:1517:3528:::|h[Печать Триумвирата]|h|r"
	local sender = settings.playerName
	local prefix = settings.prefix.addon
	local _=nil
	local testRoll = true
	fn:itemListDistribution(_, _, prefix, item, _, sender, testRoll)
end

function fn:NewRoll(item, itemName, itemLevel, iconFileDataID, itemSubType, itemEquipLoc, offSpec, transmog, sender, endTime, testRoll)	--	item = itemLink(string), itemName(string), itemLevel(number), iconFileDataID(number), itemSubType(string), itemEquipLoc(string), offSpec = canOffSpecRoll(boolean), transmog = canTransmogRoll(boolean), sender(string) = playerName, endTime = timeOfEndRoll(number), testRoll(boolean)
	if type(item) ~= 'string' or  type(itemName) ~= 'string' or  type(itemLevel) ~= 'number' or  type(iconFileDataID) ~= 'number' or  type(offSpec) ~= 'boolean' or  type(transmog) ~= 'boolean' or  type(itemSubType) ~= 'string' or  type(itemEquipLoc) ~= 'string' or  type(sender) ~= 'string' or  type(endTime) ~= 'number' or  type(testRoll) ~= 'boolean' then
		return fn:debug('functions', 'NewRoll('..
		'item(string|'..type(item)..') - item Link, '..
		'itemName(string|'..type(itemName)..') - item Name, '..
		'itemLevel(number|'..type(itemLevel)..') - item Level, '..
		'iconFileDataID(number|'..type(iconFileDataID)..') - icon ID, '..
		'offSpec(boolean|'..type(offSpec)..') - can offspec roll, '..
		'transmog(boolean|'..type(transmog)..') - can transmog roll, '..
		'itemSubType(string|'..type(itemSubType)..') - item Sub Type, '..
		'itemEquipLoc(string|'..type(itemEquipLoc)..') - item Equip Location, '..
		'sender(string|'..type(sender)..') - player Name, '..
		'endTime(number|'..type(endTime)..') - time Of End Roll, '..
		'testRoll(boolean|'..type(testRoll)..') - is test roll'..
		')')
	end
	settings.forceHide=false
	local hide=false
	local isEquipable=false
	for k,v in pairs(settings.itemClassNeed[settings.playerClass]) do
		if(v==itemSubType) then
			isEquipable = true;
			break;
		end
	end
	
	local isEquipable = isEquipable or itemSubType == L["Разное"] or itemEquipLoc == "INVTYPE_CLOAK";
	hide = not isEquipable
	
--	double send item
	local exist=false
	for i=1,#data.roll_list do
		if data.roll_list[i][itemName]~=nil then exist=i;break; end
	end
--	sender FILTER
	if sender==settings.playerName and not DB.debug.solo and not DB.filters.seeMyRoll and not testRoll then
		hide=true
		fn:debug('roll', color['red']..'Ролл спрятан|r, отправитель=пользователь')
	end
	
	local needState = 0
	local itemStats = GetItemStats(item)
	local spec = GetLootSpecialization() == 0 and GetSpecializationInfo(GetSpecialization()) or GetLootSpecialization()
	local socket = (itemStats.EMPTY_SOCKET_PRISMATIC or 0)*settings.socketWeight
	
--	spec filter
	for k,v in pairs(GetItemSpecInfo(item)) do
		if v == spec then needState = 2; break end
		for i=1, GetNumSpecializations() do
			if GetSpecializationInfo(i) == v then needState = 1; break end
		end
	end
	needState = itemEquipLoc == "INVTYPE_FINGER" and 2 or needState
	if needState == 0 then 
		hide = true
	end
	
--	test Roll: always show, small time
	if testRoll then
		hide = false
		endTime = GetTime()+settings.timeToTestRoll
	end
	
	if exist then	--	if double new_roll
		fn:updateItemList(data.roll_list[exist][itemName], offSpec, transmog,sender, socket)
	else
		fn:itemListNew(item, itemName, itemLevel, iconFileDataID, offSpec, transmog, hide, sender, endTime, socket, needState, itemEquipLoc, testRoll)
	end
	fn:startTimer()
end

function fn:itemListDistribution(self, event, ...)	--	... -> prefix = parefixName(string), msg(string), channel = channelName(string), sender = playerName(string), testRoll(boolean or nil)
	local prefix,msg,channel,sender,testRoll=...
--	addon && addon_ver FILTER
	if prefix~=Prefix.addon then return end
	local senderFULL=sender
	sender=fn:split(sender,'-')
	testRoll = testRoll==true and true or false
	local offSpec, transmog
	
	prefix=fn:clearPrefix(msg)				-- prefix new_/get_/...
	local item = fn:clearPrefix(msg,prefix)	-- MSG without prefix
	local itemRoll, version = item, tonumber(item)
	
	item, offSpec, transmog = fn:split(item, ';')
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID,bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(item)
	local itemID=tonumber(string.match(item,'item:([0-9]+):'))
	if prefix==Prefix.roll.new then
	fn:debug('newroll', prefix,item,channel,sender)
		offSpec = offSpec == 1 and true or false
		transmog = transmog == 1 and true or false
		local lootSpecID = select(11, strsplit(':',  item))
		item = string.gsub(item, lootSpecID, GetLootSpecialization() == 0 and GetSpecializationInfo(GetSpecialization()) or GetLootSpecialization())
		local endTime = GetTime()+settings.timeToRoll
		if itemName==nil then
			ITEM_INFO_RECEIVED:RegisterEvent("GET_ITEM_INFO_RECEIVED")
			ITEM_INFO_RECEIVED:SetScript('OnEvent', function(self, event, id)
				if id==itemID then
					itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID,bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(item)
					if itemName == nil then
						return fn:debug('fatalError', 'itemName == nil')
					else
						ITEM_INFO_RECEIVED:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
						fn:NewRoll(item, itemName, itemLevel, iconFileDataID, itemSubType, itemEquipLoc, offSpec, transmog, sender, endTime, testRoll)
					end
				end
			end)
		else
			fn:NewRoll(item, itemName, itemLevel, iconFileDataID, itemSubType, itemEquipLoc, offSpec, transmog, sender, endTime, testRoll)
		end
	elseif prefix==Prefix.roll.get.need then
		fn:debug('getSetRoll', itemRoll, sender, prefix)
		fn:serverINITroll(itemRoll, sender, 'need')
	elseif prefix==Prefix.roll.set.need then
		fn:debug('getSetRoll', itemRoll, sender, prefix)
		fn:rollSet(itemRoll, 'need')
	elseif prefix==Prefix.roll.get.offSpec then
		fn:debug('getSetRoll', itemRoll, sender, prefix)
		fn:serverINITroll(itemRoll, sender, 'offSpec')
	elseif prefix==Prefix.roll.set.offSpec then
		fn:debug('getSetRoll', itemRoll, sender, prefix)
		fn:rollSet(itemRoll, 'offSpec')
	elseif prefix==Prefix.roll.get.transmog then
		fn:debug('getSetRoll', itemRoll, sender, prefix)
		fn:serverINITroll(itemRoll, sender, 'transmog')
	elseif prefix==Prefix.roll.set.transmog then
		fn:debug('getSetRoll', itemRoll, sender, prefix)
		fn:rollSet(itemRoll, 'transmog')
	elseif prefix==Prefix.version then
		if version == 1 then return end
		fn:debug('ver', (version<settings.version and color.red or color.green)..version..'|r', senderFULL)
		if sender~=settings.playerName then return end
		if settings.version>version and channel~='WHISPER' and not settings.beta then
			C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.version..settings.version, 'WHISPER', senderFULL)
		elseif settings.version<version then
			fn:debug('ver', color['green']..'Найдена новая версия|r', version, sender)
			fn:newVerSound()
		end
	elseif (prefix==Prefix.countGet or prefix==Prefix.countSet) then
		fn:debug('count', (version<settings.version and color.red or color.green)..version..'|r', sender)
		if sender == settings.playerName then return end
		if prefix == Prefix.countSet then
			if not data.raid_list[sender] then
				data.raid_list[sender]={}
			end
			
			data.raid_list[sender].ver=version
		elseif prefix==Prefix.countGet then
			C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.countSet..settings.version, 'WHISPER', senderFULL)
		end
	else
		fn:debug('error', 'Unregister prefix '..color['red']..prefix..'|r', senderFULL)
	end
end

function fn:settingsReplace()
	DB = RaidRollHelper.db.global
	settings.timeToRoll = DB.debug.solo and 10 or 60
end

function fn:rollResultResize()
	local frame = interface.rollFrame
	frame.rollResult:SetWidth(frame.rollBar.frame:IsVisible() and frame.frame:GetWidth() - 20 - frame.rollBar.frame:GetWidth() - 8 or frame.frame:GetWidth() - 16 - 10)
end

function fn:debug(type, ...)
	local DB = DB.debug.MSG
	local Addon = DB.types.message
	if type == 'fatalError' then
		return fn:Print(color['green']..'Debug|r:('..color['red']..'fatalError|r)', color.red, ...)
	elseif type == 'functions' and Addon.functions then
		return fn:Print(color['green']..'Debug|r:('..color['red']..'function|r)', color.red, ...)
	end
	if not DB.state then return end
	if type == 'newroll' and Addon.newroll  then
		return fn:Print(color['green']..'Debug|r:('..color['blue']..'newroll|r)',...)
	elseif type == 'getSetRoll' and Addon.getSetRoll then
		return fn:Print(color['green']..'Debug|r:('..color['blue']..'getSetRoll|r)',...)
	elseif type == 'ver' and Addon.ver then
		return fn:Print(color['green']..'Debug|r:('..color['blue']..'ver|r)',...)
	elseif type == 'count' and Addon.count then
		return fn:Print(color['green']..'Debug|r:('..color['blue']..'count|r)',...)
	elseif type == 'filter' and Addon.filters then
		return fn:Print(color['green']..'Debug|r:('..color['orange']..'filter|r)',...)
	elseif type == 'companions' and Addon.companions then
		return fn:Print(color['green']..'Debug|r:('..color['green']..'companions|r)',...)
	elseif type == 'log' and Addon.log then
		return fn:Print(color['green']..'Debug|r:('..color['yellow']..'log|r)',...)
	elseif type == 'debug' then
		return fn:Print(color['green']..'Debug|r:('..color['yellow']..'debug|r)',...)
	elseif type == 'error' then
		return fn:Print(color['green']..'Debug|r:('..color['yellow']..'error|r)',...)
	elseif type == 'roll' then
		return fn:Print(color['green']..'Debug|r:(roll)',...)
	end
end

function fn:RRH_msg_loc(testRoll)	--	testRoll(boolean or nil)
	if type(testRoll) ~= 'boolean' and type(testRoll) ~= 'nil' then return fn:debug('functions', 'RRH_msg_loc(testRoll(boolean or nil|'..type(testRoll)..') - is test roll)') end
	if (RaidRollHelperDB.global.debug.solo or testRoll) then
		return "WHISPER", settings.playerName
	end
	if IsInRaid(LE_PARTY_CATEGORY_HOME) then
		return "RAID"
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
end
	
function fn:Print(...)
	print(...)
end

function fn:RRH_FRAME_stop_move()
	interface.frame:StopMovingOrSizing()
	local point, relativeTo,relativePoint, xOfs, yOfs = interface.frame:GetPoint(1)
	RaidRollHelperDB.global.point=point
	RaidRollHelperDB.global.relativeTo=relativeTo
	RaidRollHelperDB.global.relativePoint=relativePoint
	RaidRollHelperDB.global.xOfs=xOfs
	RaidRollHelperDB.global.yOfs=yOfs
end

function fn:RRH_raid_list_update()
	local newPlayer = #data.raid_list ~= GetNumGroupMembers(1) and true or false
	for i=1,GetNumGroupMembers(1) do
		local name,rank,subgroup,level,class,fileName,zone,online,isDead,role,isML,combatRole=GetRaidRosterInfo(i)
--		add new player
		if name~=nil and data.raid_list[name]==nil and name~=settings.playerName then
	--	add player
		fn:debug('log', 'create new player: '..name)
			data.raid_list[name]={
				--[[rank=rank,
				subgroup=subgroup,
				level=level,
				class=class,
				zone=zone,
				isDead=isDead,
				role=role,
				isML=isML,
				combatRole=combatRole,]]
				online=online,
				className=fileName,
				ver=false,
				check = true,
			}
--		player was find, re-registration
		elseif name~=nil and data.raid_list[name]~=nil and name~=settings.playerName then
			fn:debug('log', 're-registration player: '..name)
			data.raid_list[name].check = true
			data.raid_list[name].online = online
		end
	end
	for name,v in pairs(data.raid_list) do
		local player = data.raid_list[name]
		fn:debug('log', 'player '..name, 'check: '..tostring(player.check), 'online: '..tostring(player.online))
--		survey of non-responding players
		if player.check and not player.ver and player.online and newPlayer then
			fn:debug('log', 'survey player: '..name)
			C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.countGet..settings.version, 'WHISPER', name)
		end
--		delete if player is not in raid
		if not player.check then
			fn:debug('log', 'delete player: '..name)
			data.raid_list[name] = nil
		end
		if data.raid_list[name] then
			data.raid_list[name].check = false
		end
	end
end

function fn:declOfNum(number,Type)	--	number = count(number), Type = transformationType(string)
	if type(number) ~= 'number' or type(Type) ~= 'string' then return fn:debug('functions', 'declOfNum(number(number|'..type(number)..'),Type(string|'..type(Type)..'))') end
    --number= type(number) == "number" and number or 0
    local cases = {[0]=3, [1]=1, [2]=2, [3]=2, [4]=2, [5]=3}
    local titles
	if Type == 'player' then
		titles = {L["игрока"], L["игроков"], L["игроков"]}
	end
    number = math.ceil(math.abs(number))
    return number..' '..titles[(math.fmod(number,100)>4 and math.fmod(number,100)<20) and 3 or cases[(math.fmod(number,10)<5)and math.fmod(number,10) or 5] ];
end

function fn:findAddon()
	local DB={['yes']={
			[settings.version]={
				[1]={['name']=settings.playerName,['color']=color[settings.playerClass]}
			}
		},['no']={}}
		for name,tab in pairs(data.raid_list)do
			if tab.ver then
				if not DB.yes[tab.ver] then DB.yes[tab.ver]={} end
				--DB.yes[tab.ver][#DB.yes[tab.ver]+1]={['name']=name,['color']=color[tab.className]}
				table.insert(DB.yes[tab.ver], {['name']=name,['color']=color[tab.className]})
			else
				--DB.no[#DB.no+1]={['name']=name,['color']=color[tab.className] or '|cffffffff'}
				table.insert(DB.no, {['name']=name,['color']=color[tab.className] or '|cffffffff'})
			end
		end
		local str=''
		local count=0
		local withOUT_RRH=''
		local form=L["Аддон Raid Roll Helper найден у %s."].."\n%s \n "..L["Игроки без аддона %u: %s"]
		for ver,names in pairs(DB.yes) do
			str=str..(ver==settings.version and '|cFF00FF96' or '|cFFC41F3B')..ver..'|r-'
			for i=1,#names do
				str=str..names[i].color..names[i].name..'|r, '
				count=count+1
			end
			str=string.gsub(str,', $', '\n')
		end
		for i=1,#DB.no do
			withOUT_RRH=withOUT_RRH..DB.no[i].color..DB.no[i].name..'|r, '
		end
		withOUT_RRH=string.gsub(withOUT_RRH,', $','')
		str=string.format(form,fn:declOfNum(count,'player'),str,#DB.no,withOUT_RRH)
		fn:Print(str)
end

function fn:newVerSound()
	if not settings.version_verified then
		PlaySound(8959, "Master")
		fn:Print(L["Ваша версия RaidRollHelper устарела."])
		settings.version_verified=true
	end
end

function fn:clearPrefix(str,prefix)	--	str = stringWithPrefix(string), prefix = stringForRemove(string)
	if type(str) ~= 'string' then return fn:debug('functions', 'clearPrefix(str(string|'..type(str)..'),prefix(string[ maybe nil for get prefix]|'..type(prefix)..'))') end
	if prefix==nil then
		local prefix='^%w+_'
		if string.find(str,prefix) then
			str=string.match(str,prefix)
			return str
		else
			return false
		end
	else
		local _prefix='^'..prefix
		if string.find(str,_prefix) then
			str=string.gsub(str,_prefix,'')
			return str
		else
			return false
		end
	end
	
end

function fn:serverINITroll(itemName,sender, mode)	--	itemName(string) ,sender = playerName(string) , mode = rollMod(string)
	if type(itemName) ~= 'string' or type(sender) ~= 'string' or type(mode) ~= 'string' then return fn:debug('functions', 'itemName(string|'..type(itemName)..'),sender(string|'..type(sender)..'), mode(string|'..type(mode)..')') end
	for i=1,#data.roll_list do
	local item = data.roll_list[i][itemName]
		if item then
			if item.ilvls[1]['sender']==settings.playerName then
				C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.roll.set[mode]..sender..'#'..itemName..'#'..fn:GetRoll(itemName, mode), fn:RRH_msg_loc(item.test))
			end
		end
	end
end

function fn:startTimer()
	fn:debug('companions', 'startTimer')
	RRH_TICKER:Cancel()
	RRH_TICKER = C_Timer.NewTicker(1, function() fn:rollTimer() end)
end

function fn:ifItemExist(itemLink)	--	itemLink(string)
	if type(itemLink) ~= 'string' then return fn:debug('functions', 'ifItemExist(itemLink(string|'..type(itemLink)..'))') end
	for bag=0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			if GetContainerItemLink(bag,slot)==itemLink then return true end
		end
	end
	return false
end

function fn:deleteRoll(i)
	table.remove(data.roll_list, 1)
end

function fn:sendWinner(itemName)	--	itemName(string)
	if type(itemName) ~= 'string' then return fn:debug('functions', 'sendWinner(itemName(string|'..type(itemName)..'))') end
	local i=0
	for n=1,#data.roll_list do
		if data.roll_list[n][itemName] then i=n;break end
	end
	if i==0 then return end
	
	local item=data.roll_list[i][itemName]
	for n=1,#item.ilvls do
		if item.ilvls[n].sender==settings.playerName then
			if item.need[n] then
				local MSG=item.ilvls[n].Item_link..L[" победитель "]..item.need[n].name
				fn:Print(MSG)
				if (IsInRaid(LE_PARTY_CATEGORY_HOME) or IsInGroup(LE_PARTY_CATEGORY_HOME)) and not item.test and not DB.debug.solo then
					SendChatMessage(MSG, fn:RRH_msg_loc(item.test))
				end
				for m=1,#item.need do
					fn:Print(color['yellow']..item.need[m].name..L[" выбрасывает "]..item.need[m].roll..' (1-100)|r')
				end
			elseif item.offSpec[n-#item.need] then
				local MSG=item.ilvls[n].Item_link..L[" победитель "]..item.offSpec[n-#item.need].name..L['(На офф спек)']
				fn:Print(MSG)
				if (IsInRaid(LE_PARTY_CATEGORY_HOME) or IsInGroup(LE_PARTY_CATEGORY_HOME)) and not item.test and not DB.debug.solo then
					SendChatMessage(MSG, fn:RRH_msg_loc(item.test))
				end
				for m=1,#item.offSpec do
					fn:Print(color['yellow']..item.offSpec[m].name..L[" выбрасывает "]..item.offSpec[m].roll..' (1-100)|r'..L['(На офф спек)'])
				end
			elseif item.transmog[n-#item.need-#item.offSpec] then
				local MSG=item.ilvls[n].Item_link..L[" победитель "]..item.transmog[n-#item.need-#item.offSpec].name..L['(На трансмог)']
				fn:Print(MSG)
				if (IsInRaid(LE_PARTY_CATEGORY_HOME) or IsInGroup(LE_PARTY_CATEGORY_HOME)) and not item.test and not DB.debug.solo then
					SendChatMessage(MSG, fn:RRH_msg_loc(item.test))
				end
				for m=1,#item.transmog do
					fn:Print(color['yellow']..item.transmog[m].name..L[" выбрасывает "]..item.transmog[m].roll..' (1-100)|r'..L['(На трансмог)'])
				end
			else
				if (IsInRaid(LE_PARTY_CATEGORY_HOME) or IsInGroup(LE_PARTY_CATEGORY_HOME)) and not item.test and not DB.debug.solo then
					SendChatMessage(item.ilvls[n].Item_link..L[' никому не нужно'], fn:RRH_msg_loc(item.test))
				end
				fn:Print(item.ilvls[n].Item_link..L[' никому не нужно'])
			end
		end
	end
end

function fn:showWinFrame(item)	--	item(table [maybe nil if #list>0])
	local list = interface.winRoll.list
	if type(item) ~= 'table' and #list == 0 then fn:debug('functions', 'showWinFrame(item(table [maybe nil if #list>0]|'..type(item)..'))') end
	
	if not DB.addonSettings.winAlert then return end
	local ico = type(item) == 'table' and select(10, GetItemInfo(item.Item_link)) or nil
	if item ~= nil and ico ~= nil then table.insert(list, {link = item.Item_link, ico = ico, sender = item.sender}) end
	if #list==0 then return end
	local player = settings.playerName
	interface.winRoll:Show()
	interface.winRoll.ico.link = list[1].link
	interface.winRoll.ico:SetImage(list[1].ico)
	interface.winRoll.leader:SetText(string.format(L["Заберите у %s"], list[1].sender))
end

function fn:printRolls(itemName)	--	itemName(string)
	if type(itemName) ~= 'string' then return fn:debug('functions', 'printRolls(itemName(string|'..type(itemName)..'))') end
	for i=1,#data.roll_list do
		if data.roll_list[i][itemName] then
			for r=1,#data.roll_list[i][itemName].need do
				if data.roll_list[i][itemName].need[r].name==settings.playerName then
					fn:showWinFrame(data.roll_list[i][itemName].ilvls[r])
					for j=1,#data.roll_list[i][itemName].need do
						fn:Print(color['yellow']..data.roll_list[i][itemName].need[j].name..L[" выбрасывает "]..data.roll_list[i][itemName].need[j].roll..' (1-100)|r')
					end
				end
			end
			for r=1,#data.roll_list[i][itemName].offSpec do
				if data.roll_list[i][itemName].offSpec[r].name==settings.playerName then
					fn:showWinFrame(data.roll_list[i][itemName].ilvls[r])
					for j=1,#data.roll_list[i][itemName].offSpec do
						fn:Print(color['yellow']..data.roll_list[i][itemName].offSpec[j].name..L[" выбрасывает "]..data.roll_list[i][itemName].offSpec[j].roll..' (1-100)|r'..L['(На офф спек)'])
					end
				end
			end
			for r=1,#data.roll_list[i][itemName].transmog do
				if data.roll_list[i][itemName].transmog[r].name==settings.playerName then
					fn:showWinFrame(data.roll_list[i][itemName].ilvls[r])
					for j=1,#data.roll_list[i][itemName].transmog do
						fn:Print(color['yellow']..data.roll_list[i][itemName].transmog[j].name..L[" выбрасывает "]..data.roll_list[i][itemName].transmog[j].roll..' (1-100)|r'..L['(На трансмог)'])
					end
				end
			end
		end
	end
end

function fn:rollTimer()
	local cancel_timer=false
	local item=''
	local itemLink
	for i=1,#data.roll_list do
	if cancel_timer then break end
		for k,v in pairs(data.roll_list[i]) do
			local arr=data.roll_list[i][k].ilvls
			local end_of_timer=data.roll_list[i][k].endTime
			--for ii=1,#arr do
				if end_of_timer<GetTime() then
					cancel_timer=true
					item=k
					--break
				end
			--end
		end
	end
	if cancel_timer then
		fn:sendWinner(item)
		fn:printRolls(item)
	end
	fn:upd_roll()
	if #data.roll_list==0 then RRH_TICKER:Cancel();fn:upd_roll() end
end

function fn:linkReplace(link, socket)	--	link = itemLink(string), socket = socketWeight(number)
	if type(link) ~= 'string' or type(socket) ~= 'number' then return fn:debug('functions', 'linkReplace(link(string|'..type(link)..') - itemLink, socket(number|'..type(socket)..') - socket Weight)') end
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID,bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(link)
	link=string.gsub(link,'\124','|')
	link=string.gsub(link,itemName,itemLevel..(socket>0 and '*' or ''))
	link=string.gsub(link,'|','\124')
	return link
end

function fn:randRoll(rolls)	--	rolls(table) = roll table
	if type(rolls) ~= 'table' then return fn:debug('functions', 'randRoll(rolls(table|'..type(rolls)..') - roll table)') end
	local roll=math.random(1,100)
	for i=1,#rolls do
		if rolls[i]==roll then
			roll=Roll(rolls)
		end
	end
	return roll
end

function fn:GetRoll(item, mode)	--	item = itemName(string), mode = rollMod(string)
	if type(item) ~= 'string' or type(mode) ~= 'string' then return fn:debug('functions', 'GetRoll(item(string|'..type(item)..'), mode(string|'..type(mode)..'))') end
	for i=1,#data.roll_list do
		if data.roll_list[i][item] then
			local rolls={}
			for r=1,#data.roll_list[i][item][mode] do
				--rolls[#rolls+1]=data.roll_list[i][item][mode][r].roll
				table.insert(rolls, data.roll_list[i][item][mode][r].roll)
			end
			return fn:randRoll(rolls)
		end
	end
end

function fn:updateIco(texture)
	interface.rollFrame.ico:SetImage(texture)
	--interface.rollFrame.ico:SetAllPoints()
end

function fn:dump(o)
	if type(o) == 'table' then
		local s = '{ \n'
		for k,v in pairs(o) do
		if k~=nil then
			if v==nil then v='nil' end
			if type(k) ~= 'number' then k = '"'..k..'"' end
				s = s .. '['..k..'] = ' .. fn:dump(v) .. ',\n'
			end
		end
			return s .. '} \n'
		else
			return tostring(o)
	end
end

function fn:split(inputstr, sep)
	if sep == nil then sep = "%s" end
	if not inputstr:find(sep) then return inputstr end
	local t={}-- ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, tonumber(str)==nil and str or tonumber(str))
		--[[t[i] = str
		i = i + 1]]
	end
	return unpack(t)
end

function fn:makeHash(leng)
	if leng==nil then leng=10 end
		local text = "";
		local possible = "abcdefghijklmnopqrstuvwxyzQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
		for i=0,leng do
		local charAt=math.floor(math.random()*string.len(possible))
		text=text..possible:sub(charAt,charAt)
	end
		return text;
end

function fn:spairs(t, order)
		-- collect the keys
		local keys = {}
		for k in pairs(t) do --[[keys[#keys+1] = k]] table.insert(keys, k) end

		-- if order function given, sort by it by passing the table and keys a, b,
		-- otherwise just sort the keys 
		if order then
				table.sort(keys, function(a,b) return order(t, a, b) end)
		else
				table.sort(keys)
		end

		-- return the iterator function
		local i = 0
		return function()
				i = i + 1
				if keys[i] then
						return keys[i], t[keys[i]]
				end
		end
end

function fn:comma_value(amount)
	local formatted = amount
	while true do	
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

function fn:round(val, decimal)
	if (decimal) then
		return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
	else
		return math.floor(val+0.5)
	end
end

function fn:format_num(amount, decimal, prefix, neg_prefix)
	local str_amount,	formatted, famount, remain

	decimal = decimal or 2	-- default 2 decimal places
	neg_prefix = neg_prefix or "-" -- default negative sign

	famount = math.abs(round(amount,decimal))
	famount = math.floor(famount)

	remain = round(math.abs(amount) - famount, decimal)

				-- comma to separate the thousands
	formatted = comma_value(famount)

				-- attach the decimal portion
	if (decimal > 0) then
		remain = string.sub(tostring(remain),3)
		formatted = formatted .. "," .. remain ..
								string.rep("0", decimal - string.len(remain))
	end

				-- attach prefix string e.g '$' 
	formatted = (prefix or "") .. formatted 

				-- if value is negative then format accordingly
	if (amount<0) then
		if (neg_prefix=="()") then
			formatted = "("..formatted ..")"
		else
			formatted = neg_prefix .. formatted 
		end
	end

	return formatted
end

function fn:sortRoll(arr)
	table.sort(arr, function(a,b) return(a.roll > b.roll) end)
	return arr
end

function fn:sortilvls(arr)
	table.sort(arr, function(a,b) return(a.ilvl + a.socket > b.ilvl + b.socket) end)
	return arr
end

function fn:needListUpdate()
	local needListText='<html><body></body></html>'
	local needList=''--string.match(needListText,"<body>(.*)</body>")
	local exist=false
	for i=1,#data.roll_list do
		for k,v in pairs(data.roll_list[i]) do
			for ii=1,#data.roll_list[i][k].need do
				if data.roll_list[i][k].need[ii].name==settings.playerName then exist=true;break; end
			end
			if not exist then
				for ii=1,#data.roll_list[i][k].offSpec do
					if data.roll_list[i][k].offSpec[ii].name==settings.playerName then exist=true;break; end
				end
			end
			if not exist then
				for ii=1,#data.roll_list[i][k].transmog do
					if data.roll_list[i][k].transmog[ii].name==settings.playerName then exist=true;break; end
				end
			end
			
			if exist then
				if #data.roll_list[i][k].need>0 then
					local link=data.roll_list[i][k].ilvls[1].Item_link
					needList=needList..'<p>'..link..' '..math.ceil(data.roll_list[i][k].endTime-GetTime())..'</p>'
					for ii=1,#data.roll_list[i][k].need do
						needList=needList..'<p>'..data.roll_list[i][k].need[ii].name..':'..data.roll_list[i][k].need[ii].roll..'</p>'
					end
				end
				
				if #data.roll_list[i][k].need==0 and #data.roll_list[i][k].offSpec>0 then
					local link=data.roll_list[i][k].ilvls[1].Item_link
					needList=needList..'<p>'..link..' '..math.ceil(data.roll_list[i][k].endTime-GetTime())..'</p>'
					for ii=1,#data.roll_list[i][k].offSpec do
						needList=needList..'<p>'..data.roll_list[i][k].offSpec[ii].name..':'..data.roll_list[i][k].offSpec[ii].roll..L["(На офф спек)"]..'</p>'
					end
				end
						
				if #data.roll_list[i][k].need==0 and #data.roll_list[i][k].offSpec==0 and  #data.roll_list[i][k].transmog>0 then
					local link=data.roll_list[i][k].ilvls[1].Item_link
					needList=needList..'<p>'..link..' '..math.ceil(data.roll_list[i][k].endTime-GetTime())..'</p>'
					for ii=1,#data.roll_list[i][k].transmog do
						needList=needList..'<p>'..data.roll_list[i][k].transmog[ii].name..':'..data.roll_list[i][k].transmog[ii].roll..L["(На трансмог)"]..'</p>'
					end
				end
			end
			needList = needList..'<p></p>'
		end
	end
	if not interface.rollFrame.rollBar.frame:IsVisible() and not exist then
		interface.rollFrame:Hide()
	elseif not settings.forceHide then
		interface.rollFrame:Show()
	end
	needListText=needListText:gsub(needListText:match("<body>.*(</body>)"),needList.."%1")
	interface.rollFrame.rollResult.result:SetText(needListText)
	fn:rollResultResize()

end

function fn:rollAccess(item, rollType)	--	item = itemData(table), rollType(string)
if type(item) ~= 'table' or type(rollType) ~= 'string' then return fn:debug('functions', 'rollAccess(item(table|'..type(item)..'), rollType(string'..type(rollType)..'))') end
	for _,v in pairs(item.ilvls) do
		if v[rollType] then return true end
	end
	return false
end

function fn:upd_roll()
	if #data.roll_list==0 then
		--[[interface.rollFrame.needBtn:SetCallback('OnClick', function() end)
		interface.rollFrame.falseBtn:SetCallback('OnClick', function() end)
		interface.rollFrame.offSpecBtn:SetCallback('OnClick', function() end)
		interface.rollFrame.transmogBtn:SetCallback('OnClick', function() end)]]
		interface.rollFrame.rollBar.frame:Hide()
		GameTooltip:Hide()
	end
	local isDel=false
	for i=1,#data.roll_list do
		local isShow=false
		if isDel then fn:upd_roll();break end
		for k,v in pairs(data.roll_list[i]) do
			local item = data.roll_list[i][k]
			if item.endTime<GetTime()  then
				fn:deleteRoll(i);isDel=true
			else
				if item.hide or (not fn:rollAccess(item, 'isTransmog') and not fn:rollAccess(item, 'isOffSpec') and item.lootSpec~=2) then break end
				
				if not settings.forceHide then
					interface.rollFrame:Show();
					interface.rollFrame.rollBar.frame:Show()
				end
				interface.rollFrame.timer:SetText(string.format(L["Осталось: %u сек"],math.ceil(item.endTime-GetTime())))
				
				fn:updateIco(item.ico)
				
				
				local ilvls=''
				item.ilvls=fn:sortilvls(item.ilvls)
				for ii=1,#item.ilvls do
					local link=item.ilvls[ii].Item_link
					local socket = item.ilvls[ii].socket
					ilvls=ilvls..'<h1 align="center">'..fn:linkReplace(link, socket)..'</h1>'..'\n'
				end
			--	interface.ilvls - 8 strings
				interface.rollFrame.ilvls.items:SetText('<html><body>'..ilvls..'</body></html>')
				interface.rollFrame.ilvls.items.frame:SetScript('OnHyperlinkEnter',function(self,link)
					GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
					GameTooltip:SetHyperlink(link)
				end)
				
				interface.rollFrame.rollResult.result.frame:SetScript('OnHyperlinkEnter',function(self,link)
					GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
					GameTooltip:SetHyperlink(link)
				end)
				interface.rollFrame.rollResult.result.frame:SetScript('OnHyperlinkLeave',function() GameTooltip:Hide() end)
				interface.rollFrame.ilvls.items.frame:SetScript('OnHyperlinkLeave',function() GameTooltip:Hide() end)
				
				interface.rollFrame.needBtn:SetDisabled(false)
				interface.rollFrame.needBtn:SetCallback('OnClick', function()
					item.hide=true
					C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.roll.get.need..k, fn:RRH_msg_loc(item.test))
					fn:upd_roll()
				end)
				interface.rollFrame.offSpecBtn:SetCallback('OnClick', function()
					item.hide=true
					C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.roll.get.offSpec..k, fn:RRH_msg_loc(item.test))
					fn:upd_roll()
				end)
				interface.rollFrame.transmogBtn:SetDisabled(false)
				interface.rollFrame.transmogBtn:SetCallback('OnClick', function()
					item.hide=true
					C_ChatInfo.SendAddonMessage(Prefix.addon, Prefix.roll.get.transmog..k, fn:RRH_msg_loc(item.test))
					fn:upd_roll()
				end)
				interface.rollFrame.falseBtn:SetCallback('OnClick', function()
					item.hide=true
					fn:upd_roll() 
				end)
				isShow=true
				
				if not item.isTransmog or not fn:rollAccess(item, 'isTransmog') then interface.rollFrame.transmogBtn:SetDisabled(true) end
				
				if item.lootSpec==1 then
					interface.rollFrame.needBtn:SetDisabled(true)
				else
					interface.rollFrame.needBtn:SetDisabled(false)
				end
				if not fn:rollAccess(item, 'isOffSpec') then
					interface.rollFrame.offSpecBtn:SetDisabled(true)
				else
					interface.rollFrame.offSpecBtn:SetDisabled(false)
				end
			end
		end
		if isShow then
			break
		else
			--[[interface.rollFrame.needBtn:SetCallback('OnClick', function() end)
			interface.rollFrame.offSpecBtn:SetCallback('OnClick', function() end)
			interface.rollFrame.transmogBtn:SetCallback('OnClick', function() end)
			interface.rollFrame.falseBtn:SetCallback('OnClick', function() end)]]
			interface.rollFrame.rollBar.frame:Hide()
		end
		
	end
	fn:needListUpdate()
end

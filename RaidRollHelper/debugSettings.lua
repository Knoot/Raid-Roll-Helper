local addon = RAID_ROLL_HELPER
local interface = addon.interface
local settings = addon.settings
local size = settings.interface.debug.size
local fn = addon.functions
local L = addon.L
local color = settings.color
local RaidRollHelper = addon.lib
local Ace = LibStub("AceKGUI-3.0")

interface.debug = {}
interface.debug.DebugFrame = Ace:Create('Frame')
local DebugFrame = interface.debug.DebugFrame
DebugFrame:clearFrame(true)
DebugFrame:SetTitle("Raid Roll Helper Debug")
DebugFrame:SetWidth(size.frameW)
DebugFrame:SetHeight(size.frameH)

DebugFrame.closeButton = Ace:Create('Button')
local frame = DebugFrame.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
frame:SetCallback('OnClick', function()
	DebugFrame:Hide()
end)
DebugFrame:AddChild(frame)





DebugFrame.bots = Ace:Create('ScrollFrame')
local BotsScroll = DebugFrame.bots
BotsScroll:SetWidth(size.botsW)
BotsScroll:SetLayout("List")
BotsScroll:SetHeight(DebugFrame.frame:GetHeight()-30)
DebugFrame:AddChild(BotsScroll)

BotsScroll.allOnOffBtn = Ace:Create('Button')
local frame = BotsScroll.allOnOffBtn
frame.onAll=false
frame:SetWidth(120)
frame:SetText('Вкл/Выкл всех')
frame:SetCallback("OnClick", function(self)
	for i=1, #BotsScroll.bot do
		BotsScroll.bot[i].state:SetValue(not self.onAll)
	end
	self.onAll = not self.onAll
end)
BotsScroll:AddChild(frame)

BotsScroll.setRndBtn = Ace:Create('Button')
local frame = BotsScroll.setRndBtn
frame:SetText('Все случайные')
frame:SetWidth(120)
frame:SetCallback("OnClick", function()
	for i=1, #BotsScroll.bot do
		BotsScroll.bot[i].roll:SetText(0)
	end
end)
BotsScroll:AddChild(frame)

BotsScroll.bot = {}
for i=1, settings.debug.bots.count do
	BotsScroll.bot[i] = Ace:Create('SimpleGroup')
	local bot = BotsScroll.bot[i]
	bot:SetLayout("List")
	bot.name = 'Bot '..i
	BotsScroll:AddChild(bot)
	
	bot.label = Ace:Create('Label')
	local frame = bot.label
	frame:SetText('Бот №'..i)
	bot:AddChild(frame)
	
	bot.roll = Ace:Create('EditBox')
	local frame = bot.roll
	frame:SetWidth(80)
	frame:SetText(0)
	frame.editbox:SetScript("OnEnter", function(self)
		local number = tonumber(self:GetText())
		self.lasttext = number
	end)
	frame.editbox:SetScript("OnEscapePressed", function(self)
		self:SetText(self.lasttext)
		self:ClearFocus()
	end)
	frame.editbox:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		local number = tonumber(self:GetText())
		if number~=nil then
			self.lasttext = number
		else
			self:SetText(self.lasttext)
		end
	end)
	bot:AddChild(frame)
	
	bot.state = Ace:Create('CheckBox')
	local frame = bot.state
	frame:SetLabel('Вкл/Выкл бота')
	frame:SetValue(false)
	bot:AddChild(frame)
	
end








DebugFrame.MSG = Ace:Create('SimpleGroup')
local MSG = DebugFrame.MSG
MSG:SetWidth(150)
MSG:SetLayout("List")
DebugFrame:AddChild(MSG)

MSG.debugState = Ace:Create('CheckBox')
local frame = MSG.debugState
frame:SetWidth(90)
frame:SetLabel('Отладка')
frame:SetTooltip('Вкл/Выкл сообщения отладки')
frame:SetCallback("OnValueChanged", function(self)
	RaidRollHelper.db.global.debug.MSG.state = self:GetValue()
	fn:Print('RRH-Debug '..(RaidRollHelper.db.global.debug.MSG.state and color['green']..'on|r' or color['red']..'off|r' ))
end)
MSG:AddChild(frame)

MSG.newroll = Ace:Create('CheckBox')
local frame = MSG.newroll
frame:SetWidth(100)
frame:SetLabel('Новый ролл')
frame:SetTooltip('Вкл/Выкл сообщения о новом ролле')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.debug.MSG.types.message.newroll = frame:GetValue()
end)

MSG:AddChild(frame)

MSG.getSetRoll = Ace:Create('CheckBox')
local frame = MSG.getSetRoll
frame:SetWidth(100)
frame:SetLabel('Get/Set Roll')
frame:SetTooltip('Вкл/Выкл сообщения о входящем/исходящем роле')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.debug.MSG.types.message.getSetRoll = frame:GetValue()
end)
MSG:AddChild(frame)

MSG.ver = Ace:Create('CheckBox')
local frame = MSG.ver
frame:SetWidth(120)
frame:SetLabel('Запрос версии')
frame:SetTooltip('Вкл/Выкл сообщения запроса версий')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.debug.MSG.types.message.ver = frame:GetValue()
end)
MSG:AddChild(frame)

MSG.count = Ace:Create('CheckBox')
local frame = MSG.count
frame:SetWidth(110)
frame:SetLabel('Поиск аддона')
frame:SetTooltip('Вкл/Выкл сообщения поиска аддона')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.debug.MSG.types.message.count = frame:GetValue()
end)
MSG:AddChild(frame)

MSG.filters = Ace:Create('CheckBox')
local frame = MSG.filters
frame:SetWidth(110)
frame:SetLabel('Тип фильтры')
frame:SetTooltip('Вкл/Выкл сообщения отладки типа фильтры')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.debug.MSG.types.message.filters = frame:GetValue()
end)
MSG:AddChild(frame)

MSG.companions = Ace:Create('CheckBox')
local frame = MSG.companions
frame:SetWidth(120)
frame:SetLabel('Тип попутчики')
frame:SetTooltip('Вкл/Выкл сообщения отладки типа попутчики')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.debug.MSG.types.message.companions = frame:GetValue()
end)
MSG:AddChild(frame)

MSG.functions = Ace:Create('CheckBox')
local frame = MSG.functions
frame:SetWidth(120)
frame:SetLabel('Тип функции')
frame:SetTooltip('Вкл/Выкл сообщения отладки типа функции')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.debug.MSG.types.message.functions = frame:GetValue()
end)
MSG:AddChild(frame)

MSG.log = Ace:Create('CheckBox')
local frame = MSG.log
frame:SetWidth(90)
frame:SetLabel('Тип лог')
frame:SetTooltip('Вкл/Выкл сообщения отладки типа лог')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.debug.MSG.types.message.log = frame:GetValue()
end)
MSG:AddChild(frame)

DebugFrame.DebugSettings = Ace:Create('SimpleGroup')
local DebugSettings = DebugFrame.DebugSettings
DebugSettings:SetWidth(150)
MSG:SetLayout("List")
DebugFrame:AddChild(DebugSettings)

DebugSettings.instantRoll = Ace:Create('CheckBox')
local frame = DebugSettings.instantRoll
frame:SetWidth(120)
frame:SetLabel('Режим соло')
frame:SetTooltip('Имитация рола без отправки')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.debug.solo = frame:GetValue()
	settings.timeToRoll = frame:GetValue() and 10 or 60
end)
DebugSettings:AddChild(frame)

DebugSettings.skipBagSearch = Ace:Create('CheckBox')
local frame = DebugSettings.skipBagSearch
frame:SetWidth(150)
frame:SetLabel('Выкл фильтр сумки')
frame:SetTooltip('Пропускать фильтр поиска в сумках')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.filters.skipBagSearch = frame:GetValue()
end)
DebugSettings:AddChild(frame)

DebugSettings.seeMyRoll = Ace:Create('CheckBox')
local frame = DebugSettings.seeMyRoll
frame:SetWidth(160)
frame:SetLabel('Показывать свой ролл')
frame:SetTooltip('Не скрывать свои роллы')
frame:SetCallback("OnValueChanged", function()
	RaidRollHelper.db.global.filters.seeMyRoll = frame:GetValue()
end)
DebugSettings:AddChild(frame)





-- set points
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function()
	DebugFrame:Hide()
	
	local DB = RaidRollHelper.db.global
	DebugFrame.closeButton:ClearAllPoints()
	DebugFrame.closeButton:SetPoint("CENTER", DebugFrame.frame, "TOPRIGHT", -8, -8)
	
	DebugFrame.bots:ClearAllPoints()
	DebugFrame.bots:SetPoint("TOPLEFT", DebugFrame.frame, "TOPLEFT", 15, -20)
	
	for i=1, settings.debug.bots.count do
		local frame = BotsScroll.bot[i]
		frame.state:ClearAllPoints()
		frame.state:SetPoint("TOPLEFT", frame.roll.frame, "TOPRIGHT")
	end
	
	DebugFrame.MSG:ClearAllPoints()
	DebugFrame.MSG:SetPoint("TOPLEFT", BotsScroll.frame, "TOPRIGHT", 10, 0)
	
	MSG.newroll:ClearAllPoints()
	MSG.newroll:SetPoint("TOPLEFT", MSG.debugState.frame, "BOTTOMLEFT", 20, 0)
	
	DebugFrame.DebugSettings:ClearAllPoints()
	DebugFrame.DebugSettings:SetPoint("TOPLEFT", DebugFrame.MSG.frame, "TOPRIGHT", 10, 0)
	
	MSG.debugState:SetValue(DB.debug.MSG.state)
	MSG.newroll:SetValue(DB.debug.MSG.types.message.newroll)
	MSG.getSetRoll:SetValue(DB.debug.MSG.types.message.getSetRoll)
	MSG.ver:SetValue(DB.debug.MSG.types.message.ver)
	MSG.count:SetValue(DB.debug.MSG.types.message.count)
	MSG.filters:SetValue(DB.debug.MSG.types.message.filters)
	MSG.companions:SetValue(DB.debug.MSG.types.message.companions)
	MSG.functions:SetValue(DB.debug.MSG.types.message.functions)
	MSG.log:SetValue(DB.debug.MSG.types.message.log)
	
	DebugSettings.instantRoll:SetValue(DB.debug.solo)
	DebugSettings.skipBagSearch:SetValue(DB.filters.skipBagSearch)
	DebugSettings.seeMyRoll:SetValue(DB.filters.seeMyRoll)
end)

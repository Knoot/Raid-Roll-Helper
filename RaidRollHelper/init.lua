--[[		new
	
]]

--[[		тз
?	-	+15 к илвл при наличии EMPTY_SOCKET_PRISMATIC	GetItemStats
	-	глубокая настройка отладки
+		-	окно настроек
+		-	имитация рола без отправки						debug.instantRoll = true/false
+		-	боты для рола	*								debug.bots = {}
			-	тип броска									debug.bots[i].type = {}
+			-	результат броска							debug.bots[i].result = number
+		-	режим соло										debug.solo = true/false
		-	запись событий /dump/	*						debug.dump = true/false			storage -> RaidRollHelperDebug
			- типы событий
			!!!	запись ошибок вызванных аддоном
]]

RAID_ROLL_HELPER = {}
RRH = RAID_ROLL_HELPER
local addon = RAID_ROLL_HELPER

addon.lib = LibStub("AceAddon-3.0"):NewAddon("RaidRollHelper")
LibStub("AceEvent-3.0"):Embed(addon.lib)

addon.functions = {}
addon.L = {}
addon.interface = {}
addon.settings = {
	addonName = 'RaidRollHelper',
	version = tonumber(GetAddOnMetadata('RaidRollHelper', 'Version')),
	version_verified = false,
	versionCheck = 0,
	versionCheckTime = 5*60,	-- 5 min
	beta = false,
	ruFont = 'Interface\\AddOns\\RaidRollHelper\\fonts\\PT_Sans_Narrow.ttf',
	playerName = GetUnitName('player', false),
	playerClass = select(2, UnitClass("player")),
	timeToRoll = 60,
	timeToTestRoll = 10,
	forseHide = false,
	socketWeight = 15,
	prefix = {
		addon = 'RRHelp',
		roll = {
			new = 'new_',
			get = {
				need = 'get_',
				offSpec = 'getoff_',
				transmog = 'gettrans_'
			},
			set = {
				need = 'set_',
				offSpec = 'setoff_',
				transmog = 'settrans_'
			},
		},
		version = 'ver_',
		countGet = 'GetCount_',
		countSet = 'SetCount_',
	},
	color = {
		WARRIOR='|cffc79c6e',
		PALADIN='|cfff58cba',
		HUNTER='|cffabd473',
		ROGUE='|cfffff569',
		PRIEST='|cffffffff',
		DEATHKNIGHT='|cffc41f3b',
		SHAMAN='|cff0070de',
		MAGE='|cff3fc7eb',
		WARLOCK='|cff8788ee',
		MONK='|cff00ff96',
		DRUID='|cffff7d0a',
		DEMONHUNTER='|cffa330c9',
		green='|cff00ff00',
		red='|cffff0000',
		yellow='|cffffff00',
		orange='|cffFFA500',
		blue='|cff00BFFF',
	},
	interface = {
		size = {
			frameW = 350,
			frameH = 360,
			rollBarH = 90,
			timerH = 25,
			ilvlsH = 100,
			easyRollW = 300,
			easyRollH = 140,
			winRollW = 250,
			winRollH = 100,
			settingsW = 250,
			settingsH = 100,
		},
		debug = {
			size = {
				frameW = 650,
				frameH = 350,
				botsW = 250,
			},
		}
	},
	debug = {
		bots = {
			count = 5,
		},
	},
	itemClassNeed = {
		DEATHKNIGHT = {"Латные","Одноручные топоры","Двуручные топоры","Одноручные мечи","Двуручные мечи","Одноручное дробящее", "Двуручное дробящее","Древковое"},
		DEMONHUNTER = {"Кожаные","Боевые клинки","Кистевое", "Одноручные топоры", "Одноручные мечи"},
		DRUID = 	  {"Кожаные","Одноручное дробящее","Двуручное дробящее","Древковое","Посохи","Кинжалы","Кистевое"},
		HUNTER = 	  {"Кольчужные","Одноручные топоры","Двуручные топоры","Одноручные мечи","Двуручные мечи","Древковое","Посохи","Кинжалы","Кистевое","Луки","Арбалеты","Огнестрельное"},
		MAGE = 		  {"Тканевые","Одноручные мечи","Посохи","Кинжалы","Жезлы"},
		MONK = 		  {"Кожаные","Одноручные топоры","Одноручные мечи","Одноручное дробящее","Древковое","Посохи","Кистевое"},
		PALADIN = 	  {"Латные","Щиты","Одноручные топоры","Двуручные топоры","Одноручные мечи","Двуручные мечи","Одноручное дробящее","Двуручное дробящее", "Древковое"},
		PRIEST = 	  {"Тканевые","Одноручное дробящее","Посохи","Кинжалы","Жезлы"},
		ROGUE = 	  {"Кожаные","Одноручные топоры","Одноручные мечи","Одноручное дробящее","Кинжалы","Кистевое","Луки","Арбалеты","Огнестрельное"},
		SHAMAN = 	  {"Кольчужные","Щиты","Одноручные топоры","Двуручные топоры","Одноручное дробящее","Двуручное дробящее","Посохи","Кинжалы","Кистевое"},
		WARLOCK = 	  {"Тканевые","Одноручные мечи","Посохи","Кинжалы","Жезлы"},
		WARRIOR = 	  {"Латные","Щиты","Одноручные топоры","Двуручные топоры","Одноручные мечи","Двуручные мечи","Одноручное дробящее","Двуручное дробящее","Древковое","Посохи","Кинжалы","Кистевое","Луки","Арбалеты","Огнестрельное"},
	},
	--[[specFilter = {
	--WARRIOR
		[71] = {ITEM_MOD_STRENGTH_SHORT=2, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=1},
		[72] = {ITEM_MOD_STRENGTH_SHORT=2, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=1},
		[73] = {ITEM_MOD_STRENGTH_SHORT=2, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=2},
	--PALADIN
		[65] = {ITEM_MOD_STRENGTH_SHORT=1, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=1},
		[66] = {ITEM_MOD_STRENGTH_SHORT=2, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=2},
		[70] = {ITEM_MOD_STRENGTH_SHORT=2, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=1},
	--HUNTER
		[253] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=0},
		[254] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=0},
		[255] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=0},
	--ROGUE
		[259] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=0},
		[260] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=0},
		[261] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=0},
	--PRIEST
		[256] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=0},
		[257] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=0},
		[258] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=0},
	--DEATHKNIGHT
		[250] = {ITEM_MOD_STRENGTH_SHORT=2, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=2},
		[251] = {ITEM_MOD_STRENGTH_SHORT=2, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=1},
		[252] = {ITEM_MOD_STRENGTH_SHORT=2, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=1},
	--SHAMAN
		[262] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=1, ITEM_MOD_STAMINA_SHORT=0},
		[263] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=0},
		[264] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=1, ITEM_MOD_STAMINA_SHORT=0},
	--MAGE
		[62] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=0},
		[63] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=0},
		[64] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=0},
	--WARLOCK
		[265] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=0},
		[266] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=0},
		[267] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=0, ITEM_MOD_STAMINA_SHORT=0},
	--MONK	
		[268] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=2},
		[270] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=1, ITEM_MOD_STAMINA_SHORT=1},
		[269] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=1},
	--DRUID
		[102] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=1, ITEM_MOD_STAMINA_SHORT=1},
		[103] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=1},
		[104] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=1, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=2},
		[105] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=2, ITEM_MOD_AGILITY_SHORT=1, ITEM_MOD_STAMINA_SHORT=1},
	--DEMONHUNTER
		[577] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=1},
		[581] = {ITEM_MOD_STRENGTH_SHORT=0, ITEM_MOD_INTELLECT_SHORT=0, ITEM_MOD_AGILITY_SHORT=2, ITEM_MOD_STAMINA_SHORT=2},
	},]]
}
addon.data = {
	raid_list = {},
	roll_list = {},
}
addon.dump={}

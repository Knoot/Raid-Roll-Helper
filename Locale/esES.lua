if not(GetLocale() == "esES") then
  return
end
--[[
ITEM_CLASS_NEED["Cloth"]=ITEM_CLASS_NEED["Тканевые"]
ITEM_CLASS_NEED["Leather"]=ITEM_CLASS_NEED["Кожаные"]
ITEM_CLASS_NEED["Mail"]=ITEM_CLASS_NEED["Кольчужные"]
ITEM_CLASS_NEED["Plate"]=ITEM_CLASS_NEED["Латные"]
ITEM_CLASS_NEED['Miscellaneous']=ITEM_CLASS_NEED['Разное']
]]
local L = RAID_ROLL_HELPER.L
--SYSTEM
L["Самоцвет"]="Gem"
L["Реликвия артефакта"]="Artifact Relic"
L["Доспехи"]="Armor"
L["Тканевые"]="Cloth"
L["Кожаные"]="Leather"
L["Кольчужные"]="Mail"
L["Латные"]="Plate"
L["Разное"]="Miscellaneous"
L["Оружие"]="Armas"
L["спеки"] = {
	WARRIOR = {"Arms", "Fury", "Protection"},
	DRUID = {"Balance", "Feral", "Guardian", "Restoration"},
	PRIEST = {"Discipline", "Holy", "Shadow"},
	MAGE = {"Arcane", "Fire", "Frost"},
	MONK = {"Brewmaster", "Mistweaver", "Windwalker"},
	HUNTER = {"Beast Mastery", "Marksmanship", "Survival"},
	DEMONHUNTER = {"Havoc", "Vengeance"},
	PALADIN = {"Holy", "Protection", "Retribution"},
	ROGUE = {"Assassination", "Outlaw", "Subtlety"},
	DEATHKNIGHT = {"Blood", "Frost", "Unholy"},
	WARLOCK = {"Affliction", "Demonology", "Destruction"},
	SHAMAN = {"Elemental", "Enhancement", "Restoration"},
}

-- error
L["Предмет не найден в сумках"] = "Item not found in bags"
L["Предмет не является частью экипировки"] = "The item is not an armor or a relic of an artifact"

-- help
L["itemLink help"] = "To get the |cFFFF99FFitemLink|r, click on the item with the |cFFFF99FFShift|r key pressed."
L["вернуть окно ролла в середину экрана"] = "Return the roll window to the middle of the screen"
L["отправить предмет на ролл"] = "send item to the roll"
L["подсчет количества игроков в рейде с аддоном Raid Roll Helper"] = "Counting the number of players in the raid with the addon"
L["команда предназначена для ознакомления с аддоном"] = "команда предназначена для ознакомления с аддоном"
L["открыть окно настроек аддона"] = "открыть окно настроек аддона"

-- interface
L["Закрыть"] = "Close"
L["Нужно"] = "Need"
L["Трансмог"] = "Transmog"
L["Офф спек"] = "Off spec"
L["Распылить"] = "Disenchant"
L["Осталось: %u сек"] = "Remaining: %u sec "
L["Отказаться"] = "Refuse"
L["На трансмог"] = "On transmog"
L["Разрешить роллить на трансмог"] = "Allow roll on transmog"
L["На офф спек"] = "On off spec"
L["Разрешить роллить на офф спек"] = "Allow roll on off spec"
L["Отправить"] = "Send"
L["Не отправлять"] = "Don't send"
L["Заберите у %s"] = "Take away from %s"

-- print
L["(На трансмог)"] = "(На трансмог)"
L["(На офф спек)"] = "(На офф спек)"
L["Некорректная команда"] = "Некорректная команда"
L[" никому не нужно"] = " никому не нужно"
L[" выбрасывает "] = " roll "
L[" победитель "] = " winner "
L["Аддон Raid Roll Helper найден у %s."] = "Addon |cFFFF99FFRaid Roll Helper|r found in %s."
L["Ваша версия RaidRollHelper устарела."] = "|cFFFF99FFYou version of the RaidRollHelper out of date.|r"
L["игрока"] = "player"
L["Игроки без аддона %u: %s"] = "Players without addon %u: %s"
L["игроков"] = "players"
L["Позиция по умолчанию"] = "Default window position"
L["Ролл был успешно отправлен. %s"] = "The roll was successfully sent. %s"
L["Новый ролл был отправлен. %s"] = "The new roll was sent. %s"
L["Аддон установлен у:"] = "People with addon:"

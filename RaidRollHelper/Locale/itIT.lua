if not(GetLocale() == "itIT") then
  return
end

local L = RAID_ROLL_HELPER.L
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

--SYSTEM
L["игрока"] = "player"
L["игроков"] = "players"
L["Самоцвет"]="Gemme"
L["Реликвия артефакта"]="Reliquie dell'Artefatto"
L["Доспехи"]="Armature"
L["Тканевые"]="Stoffa"
L["Кожаные"]="Cuoio"
L["Кольчужные"]="Maglia"
L["Латные"]="Piastre"
L["Разное"]="Varie"
L["Оружие"]="Armi"

-- error
L["Некорректная команда"] = "Invalid command"
L["Предмет не найден в сумках"] = "Item not found in bags"
L["Предмет не является частью экипировки"] = "The item is not an armor"

-- FAQ
L["itemLink help"] = "To get the |cFFFF99FFitemLink|r, click on the item with the |cFFFF99FFShift|r key pressed."
L["вернуть окно ролла в середину экрана"] = "Return the roll window to the middle of the screen"
L["команда предназначена для ознакомления с аддоном"] = "the command is intended for familiarization with addon"
L["открыть окно настроек аддона"] = "open addon settings window"
L["отправить предмет на ролл"] = "send item to the roll"
L["подсчет количества игроков в рейде с аддоном Raid Roll Helper"] = "Counting the number of players in the raid with the addon Raid Roll Helper"

-- interface
L["Заберите у %s"] = "Take away from %s"
L["Закрыть"] = "Close"
L["На офф спек"] = "On off spec"
L["На трансмог"] = "On transmog"
L["Не отправлять"] = "Don't send"
L["Нужно"] = "Need"
L["Оповещение о победе"] = "Win Alert"
L["Осталось: %u сек"] = "Remaining: %u sec"
L["Отказаться"] = "Refuse"
L["Отправить"] = "Send"
L["Офф спек"] = "Off spec"
L["Показывать окно с оповещением о победе"] = "Show Win Alert Window"
L["При получении добычи показывать окно с предложением выставить предмет на ролл"] = "When receiving loot, show a window with a proposal to put the item on the roll"
L["Разрешить роллить на офф спек"] = "Allow roll on off spec"
L["Разрешить роллить на трансмог"] = "Allow roll on transmog"
L["Распылить"] = "Disenchant"
L["Трансмог"] = "Transmog"

-- print
L[" выбрасывает "] = " roll "
L[" никому не нужно"] = " nobody needs"
L[" победитель "] = " winner "
L["(На офф спек)"] = "(On off spec)"
L["(На трансмог)"] = "(On transmog)"
L["Аддон Raid Roll Helper найден у %s."] = "Addon |cFFFF99FFRaid Roll Helper|r found in %s."
L["Аддон установлен у:"] = "People with addon:"
L["Ваша версия RaidRollHelper устарела."] = "|cFFFF99FFYou version of the RaidRollHelper out of date.|r"
L["Игроки без аддона %u: %s"] = "Players without addon %u: %s"
L["Новый ролл был отправлен. %s"] = "The new roll was sent. %s"
L["Позиция по умолчанию"] = "Default window position"
L["Ролл был успешно отправлен. %s"] = "The roll was successfully sent. %s"

-- DEBUG
L["Найдена новая версия"] = "New version found"
L["неподходящая реликвия артефакта"] = "unsuitable artifact relic"
L["неподходящий сет"] = "unsuitable set"
L["неподходящий тип доспехов"] = "unsuitable type of armor"
L["отправитель=игрок"] = "sender=player"
L["пользователь уже отправлял этот предмет"] = "user already sent this item"
L["Ролл не добавлен"] = "Roll was not added"
L["Ролл спрятан"] = "Roll hidden"

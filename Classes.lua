local function pack(...)
    return { n = select("#", ...), ... }
end
function KnootTableClass(tbl)
    local tbl = tbl or {}

    local methods = {
        create = _create_instance,
        shift = function()
            local temp = tbl[1]
            table.remove(tbl,1)
            return temp
        end,
        pop = function()
            local temp = tbl[#tbl]
            tbl[#tbl] = nil
            return temp
        end,
        push = function(t, ...)
            local t = pack(...)
            for i = 0, #t do
                table.insert(tbl,t[i])
            end
            return #tbl
        end,
        unshift = function(t,...)
            local t = pack(...)
            for i=#t, 1, -1 do
                table.insert(tbl, 1, t[i])
            end
            return #tbl
        end,
        dump = function(tbl,l)
            local str = '{'
            l = l or 1
            if l>100 then return '100 level break' end
            for k,v in pairs(tbl) do
                str = str.."\n"..string.rep('   ', l)..'['..k.."] = "
                if type(v) == 'table' then
					print('dump',k)
                    str = str..v:dump(l+1)
                elseif type(v) == 'function' then
                    str = str..'function'
                else
                    str = str..tostring(v)
                end
            end
            str = str..'\n'..string.rep('   ', l-1)..'}'
            return str
        end
    }

    setmetatable(tbl, {
        __index = methods,
        __newindex = function(t, k, v)
            local function meta(t)
                if type (t)~='table' then return t end
                KnootTableClass(t)
				print('-subTable',k)
                for k,v in pairs (t) do
                    if type(v)=='table' then  meta(v) end
                end
                return t
            end

            rawset(t, k, v)
            t = meta(t)
        end
    })

    return tbl
end

--[[local t = KnootTableClass()
t.test = 123
t:push(7,14,{18,['test']={21,17}})
t[3]['���� �'] = {123, 321}
t["���� �"] = {1,2,{5}}
table.insert(t, {
		['itemName']={
			link = 'item',
			ico = 'iconFileDataID',
			need = {2},
			offSpec = {4},
			transmog = {1},
			lootSpec = 'lootSpec',
			isTransmog = 'isTransmog',
			ilvls = {{},{},{}},
			endTime = 'endTime',
			hide = 'hide',
			test = testRoll or false,
		}
	})
table.insert(t, {15,21})
t[#t+1]={15,21}
print(t:dump())]]

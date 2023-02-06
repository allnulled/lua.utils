function limpiar_debug()
    local fichero_de_debugar = "C:\\Users\\vboxuser\\Desktop\\codigo\\ficheros-temporales\\debugar-lua.txt"
    local file_descriptor = io.open(fichero_de_debugar, "w")
    file_descriptor:write("")
    file_descriptor:close()
end

function debugar (dato, tabulacion) 
    local fichero_de_debugar = "C:\\Users\\vboxuser\\Desktop\\codigo\\ficheros-temporales\\debugar-lua.txt"
    local tipo_de_dato = type(dato)
    local file_descriptor = io.open(fichero_de_debugar, "a")
    local debugacion = debugar_como_texto(dato)
    file_descriptor:write("[" .. tipo_de_dato .. "] = "..debugacion.."\n")
    file_descriptor:close()
end

function debugar_como_texto(obj,level)
    local s,t = '', type(obj)
    level = level or ' '
    if (t=='nil') or (t=='boolean') or (t=='number') or (t=='string') then
      s = tostring(obj)
      if t=='string' then
        s = '"' .. s .. '"'
      end
    elseif t=='function' then
      s='function'
    elseif t=='userdata' then
      s='userdata'
      for n,v in pairs(getmetatable(obj)) do
        s = s .. "\n" .. level .. "[" .. n .. "," .. debugar_como_texto(v) .. "]"
    end
    elseif t=='thread' then 
      s='thread'
    elseif t=='table' then
      s = '{'
      for k,v in pairs(obj) do
        local k_str = tostring(k)
        if type(k)=='string' then
          k_str = "\n" .. level .. '["' .. k_str .. '"]'
        end
        s = s .. k_str .. ' = ' .. debugar_como_texto(v,level .. level) .. ','
      end
      s = string.sub(s, 1, -3)
      s = s .. '\n}'
    end
    return s
end
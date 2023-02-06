script_name = "Separar solapamientos"
script_description = "Separa solapamientos de subtítulos"
script_author = "https://github.com/allnulled"
script_version = "1"

function separar_solapamientos(subtitulos, seleccion, arg3, arg4)
    local filepath = aegisub.decode_path("?script") .. "\\" .. aegisub.file_name()
    local botones, valores = aegisub.dialog.display({
        { x=0, y=0, width=1, height=1, class="label", label="Fichero: "}, 
        { x=1, y=0, width=1, height=1, class="label", label=filepath }, 
        { x=0, y=1, width=1, height=1, class="label", label="Separación (segundos):" }, 
        { x=1, y=1, width=3, height=1, class="floatedit", name="separacion", value=0.17 }, 
        { x=0, y=2, width=1, height=1, class="label", label="Incluir estilos:" }, 
        { x=1, y=2, width=3, height=1, class="edit", name="estilos_incluidos", value="" }, 
        { x=0, y=3, width=1, height=1, class="label", label="Excluir estilos:" }, 
        { x=1, y=3, width=3, height=1, class="edit", name="estilos_excluidos", value="" }, 
        { x=0, y=4, width=1, height=1, class="label", label="Carga izquierda:" }, 
        { x=1, y=4, width=3, height=1, class="floatedit", name="carga_izquierda", value=50 }, 
        { x=0, y=5, width=1, height=1, class="label", label="Carga derecha:" }, 
        { x=1, y=5, width=3, height=1, class="floatedit", name="carga_derecha", value=50 }
    },  { "Separar", "Cancelar" })
    if botones == "Cancelar" then return end
    local comando_xass_separar = "xass -x separar"
    if valores.separacion then 
      comando_xass_separar = comando_xass_separar .. " --separacion " .. valores.separacion
    end
    if valores.estilos_incluidos ~= "" then 
      comando_xass_separar = comando_xass_separar .. " --incluir-estilo \"" .. valores.estilos_incluidos .. "\""
    end
    if valores.estilos_excluidos ~= "" then 
      comando_xass_separar = comando_xass_separar .. " --excluir-estilo \"" .. valores.estilos_excluidos .. "\""
    end
    if valores.carga_izquierda then 
      comando_xass_separar = comando_xass_separar .. " --carga-izquierda " .. valores.carga_izquierda
    end
    if valores.carga_derecha then 
      comando_xass_separar = comando_xass_separar .. " --carga-derecha " .. valores.carga_derecha
    end
    local comando_bonito = "\r\n"..comando_xass_separar.."\r\n"
    comando_bonito = string.gsub(comando_bonito, " %-%-separacion", "\r\n      %0")
    comando_bonito = string.gsub(comando_bonito, " %-%-incluir%-estilo", "\r\n      %0")
    comando_bonito = string.gsub(comando_bonito, " %-%-excluir%-estilo", "\r\n      %0")
    comando_bonito = string.gsub(comando_bonito, " %-%-carga%-izquierda", "\r\n      %0")
    comando_bonito = string.gsub(comando_bonito, " %-%-carga%-derecha", "\r\n      %0")
    comando_bonito = comando_bonito .. "      \"" .. filepath .. "\"\r\n"
    local botones2 = aegisub.dialog.display({
      { x=0, y=0, width=1, height=1, class="label", label="Se ejecutará el comando de consola:" }, 
      { x=0, y=1, width=1, height=1, class="label", label=comando_bonito}, 
      { x=0, y=2, width=1, height=1, class="label", label="¿Estás de acuerdo?" }, 
    }, { "Si, ejecutar", "Cancelar" })
    comando_xass_separar = comando_xass_separar .. " \"" .. filepath .. "\""
    if botones2 == "Si, ejecutar" then 
      os.execute(comando_xass_separar)
      aegisub.dialog.display({
        { x=0, y=0, width=1, height=1, class="label", label="El comando se ejecutó." }, 
        { x=0, y=1, width=1, height=1, class="label", label="Para ver los cambios, abre el fichero nuevamente." }, 
        { x=0, y=2, width=1, height=1, class="label", label="Puedes hacer 'Archivo' > 'Reciente' > '"..aegisub.file_name().."'" }, 
      }, { "Aceptar" })
    end
end

aegisub.register_macro(script_name, script_description, separar_solapamientos)


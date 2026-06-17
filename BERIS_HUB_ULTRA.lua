--====================================================================
-- SCRIPT: Tycoon de Clones - Operador Multimillonario V2
-- Enfoque: Recolección Directa por Escaneo de Proximidad y Textos
--====================================================================

_G.BerisHacker = true -- Cambiar a false si deseas apagarlo

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Función para simular la recolección táctil/física sin mover tu personaje
local function recolectarFajoclon(objeto)
    -- 1. Si el juego usa ProximityPrompts (Botones de interactuar ocultos)
    local prompt = objeto:FindFirstChildOfClass("ProximityPrompt") or objeto.Parent:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        fireproximityprompt(prompt)
        return
    end
    
    -- 2. Si el objeto requiere un toque físico (Touch), simulamos el choque de tu personaje
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local fireTouch = firetouchinterest or txtouchinterest
        if fireTouch then
            fireTouch(character.HumanoidRootPart, objeto, 0) -- Simula que lo tocas
            task.wait(0.01)
            fireTouch(character.HumanoidRootPart, objeto, 1) -- Libera el toque
        end
    end
end

-- BUCLE ULTRA RÁPIDO: Detector de Sacos de Dinero Flotantes
task.spawn(function()
    while true do
        task.wait(0.3) -- Escanea el piso en ráfagas rápidas de 0.3 segundos
        
        if _G.BerisHacker and LocalPlayer.Character then
            -- Buscamos de forma directa en todos los elementos del mapa
            local desc = Workspace:GetDescendants()
            
            for i = 1, #desc do
                if not _G.BerisHacker then break end
                
                local obj = desc[i]
                if obj:IsA("BasePart") then
                    local nombre = obj.Name:lower()
                    
                    -- FILTRO DE DETECCIÓN: Buscamos cualquier parte que tenga un texto flotante (BillboardGui)
                    -- o que se llame como los recolectables del Tycoon (Drop, Cash, Money, Recoger)
                    local tieneTexto = obj:FindFirstChildOfClass("BillboardGui") or obj.Parent:FindFirstChildOfClass("BillboardGui")
                    
                    if tieneTexto or nombre:find("drop") or nombre:find("cash") or nombre:find("money") or nombre:find("recoger") or nombre:find("claim") then
                        -- Evitamos tocar partes de la interfaz de la tienda o el elevador de pisos
                        if not nombre:find("tienda") and not nombre:find("piso") and not nombre:find("elevator") and not obj:IsDescendantOf(LocalPlayer.Character) then
                            
                            pcall(function()
                                recolectarFajoclon(obj)
                            end)
                            
                        end
                    end
                end
            end
        end
    end
end)
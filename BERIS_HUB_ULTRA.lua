--====================================================================
-- SCRIPT: Tycoon de Clones - Operación Multimillonario
-- Enfoque: Auto-Recoger Dinero Flotante de los Pisos Masivo
--====================================================================

_G.AutoRecogerDinero = true -- true para encender, false para apagar

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Buscar la central de eventos remotos del Tycoon
local Remotes = ReplicatedStorage:FindFirstChild("RemoteEvents") or ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage

-- Función para buscar los sacos de dinero o botones de "Recoger" en los pisos
local function buscarBotonesDeDinero(parent)
    local botones = {}
    for _, objeto in ipairs(parent:GetChildren()) do
        -- Buscamos partes interactivas que tengan nombres relacionados con dinero, recoger, drop o cash
        if objeto:IsA("BasePart") or objeto:IsA("Model") then
            local name = objeto.Name:lower()
            
            -- Filtramos los objetos flotantes de dinero (drops/recogibles)
            if name:find("drop") or name:find("cash") or name:find("money") or name:find("recoger") or name:find("collect") or name:find("saco") then
                if objeto:IsA("Model") then
                    local part = objeto.PrimaryPart or objeto:FindFirstChildWhichIsA("BasePart")
                    if part then table.insert(botones, part) end
                else
                    table.insert(botones, objeto)
                end
            end
        end
        
        -- Escaneo recursivo por si los clones o los drops están metidos en carpetas por pisos ("pisos")
        if #objeto:GetChildren() > 0 then
            for _, subBotone in ipairs(buscarBotonesDeDinero(objeto)) do
                table.insert(botones, subBotone)
            end
        end
    end
    return botones
end

-- BUCLE PRINCIPAL: Absorción instantánea de todas las ganancias del piso
task.spawn(function()
    while true do
        task.wait(0.5) -- Revisa el piso dos veces por segundo para recolectar lo nuevo
        
        if _G.AutoRecogerDinero and LocalPlayer.Character then
            -- Escaneamos todo el Workspace, enfocándonos en carpetas comunes de Tycoons (Drops, Tycoons, Map)
            local dineroEnPantalla = buscarBotonesDeDinero(Workspace)
            
            for _, fianza in ipairs(dineroEnPantalla) do
                if not _G.AutoRecogerDinero then break end
                
                pcall(function()
                    -- Intentamos activar la recolección simulando el click o el trigger del servidor
                    -- Los Tycoons suelen usar eventos llamados 'Claim', 'Collect', 'Pickup' o 'Interact'
                    local remoteEvent = Remotes:FindFirstChild("Collect") or Remotes:FindFirstChild("Pickup") or Remotes:FindFirstChild("Claim") or Remotes:FindFirstChild("Interact")
                    
                    if remoteEvent then
                        remoteEvent:FireServer(fianza)
                    else
                        -- Si el juego usa proximidad física (ProximityPrompts) para recoger, las activa al instante
                        local prompt = fianza:FindFirstChildOfClass("ProximityPrompt") or fianza.Parent:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            fireproximityprompt(prompt)
                        end
                    end
                end)
            end
        end
    end
end)
-- [[ 99 Nights in the Forest - Auto-Farm Base ]]
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Configuraciones del Script
_G.AutoFarm = true
_G.DistanciaMaxima = 150 -- Radio de búsqueda de árboles

print("Cargando módulos de optimización y farmeo...")

-- Antiafk para que Roblox no te saque del servidor tras 20 minutos
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Función para equipar el hacha automáticamente si está en el inventario
local function equiparHerramienta()
    local character = LocalPlayer.Character
    if character and not character:FindFirstChildOfClass("Tool") then
        local mochila = LocalPlayer.Backpack
        for _, tool in pairs(mochila:GetChildren()) do
            -- Busca cualquier herramienta que sirva para talar (Axe / Chainsaw)
            if string.find(string.lower(tool.Name), "axe") or string.find(string.lower(tool.Name), "chainsaw") then
                tool.Parent = character
                break
            end
        end
    end
end

-- Bucle Principal de Auto-Farm
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.5)
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            equiparHerramienta()
            
            -- Recorremos el mapa buscando árboles o estructuras destruibles
            for _, objeto in pairs(workspace:GetChildren()) do
                -- El juego suele agrupar los árboles bajo nombres clave como "Tree", "BigTree" o modelos de recursos
                if objeto:IsA("Model") and (string.find(string.lower(objeto.Name), "tree") or string.find(string.lower(objeto.Name), "scrap")) then
                    local pPart = objeto:FindFirstChildWhichIsA("BasePart")
                    
                    if pPart then
                        local distancia = (rootPart.Position - pPart.Position).Magnitude
                        
                        -- Si está dentro del rango establecido, vamos por él
                        if distancia <= _G.DistanciaMaxima then
                            -- Teletransporte seguro al lado del recurso
                            rootPart.CFrame = pPart.CFrame * CFrame.new(0, 0, 3)
                            task.wait(0.2)
                            
                            -- Simula clics continuos para golpear el árbol hasta destruirlo
                            local herramienta = character:FindFirstChildOfClass("Tool")
                            if herramienta then
                                herramienta:Activate() -- Activa el hacha
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton1(Vector2.new(0,0)) -- Fuerza el clic en pantalla
                            end
                            
                            -- Espera un momento a que caiga el recurso antes de pasar al siguiente
                            task.wait(0.3)
                        end
                    end
                end
                if not _G.AutoFarm then break end
            end
        end
    end
end)
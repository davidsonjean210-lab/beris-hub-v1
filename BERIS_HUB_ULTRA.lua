local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local StarterGuid = game:GetService("StarterGui")

local function notificar(texto)
    StarterGuid:SetCore("ChatMakeSystemMessage", {
        Text = "[beris Scanner]: " .. texto,
        Color = Color3.fromRGB(255, 165, 0),
        Font = Enum.Font.SourceSansBold
    })
end

notificar("Escaneando entorno...")
local encontrados = {}

for _, v in pairs(Workspace:GetDescendants()) do
    if v:IsA("BasePart") and not v:IsDescendantOf(Players) and v.Anchored == false then
        if #encontrados < 5 then
            table.insert(encontrados, v.Name .. " (Clase: " .. v.ClassName .. ")")
        end
    end
end

if #encontrados > 0 then
    for _, nombre in pairs(encontrados) do
        notificar("Objeto libre encontrado: " .. nombre)
    end
else
    notificar("No se encontraron objetos sueltos con físicas activas.")
end
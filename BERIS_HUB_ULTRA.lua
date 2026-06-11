local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

------------------------------------------------
-- REMOTE EVENT
------------------------------------------------
local event = Instance.new("RemoteEvent")
event.Name = "GiveMoney"
event.Parent = ReplicatedStorage

------------------------------------------------
-- MODOS DE INGRESO
------------------------------------------------
local modes = {
    BASICO = {money = 100, delay = 2},
    PREMIUM = {money = 10000, delay = 1.5},
    PLUS = {money = 20000, delay = 1}
}

------------------------------------------------
-- MODO GLOBAL (puedes cambiarlo luego con UI)
------------------------------------------------
local incomeMode = "BASICO"

------------------------------------------------
-- LOOP REAL DE DINERO
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(1)

        for _, player in pairs(Players:GetPlayers()) do
            local data = modes[incomeMode]
            if not data then return end

            local stats = player:FindFirstChild("leaderstats")
            if stats then
                for _, v in pairs(stats:GetChildren()) do
                    if v:IsA("IntValue") then
                        v.Value += data.money
                        break
                    end
                end
            end
        end
    end
end)

------------------------------------------------
-- (OPCIONAL) recibir cambios desde cliente
------------------------------------------------
event.OnServerEvent:Connect(function(player, newMode)
    if modes[newMode] then
        incomeMode = newMode
    end
end)
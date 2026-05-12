-- NO UI. Pure logic test to isolate the failure point.
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Create a Neon Purple FOV Circle to confirm execution
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = 300
FOVCircle.Color = Color3.fromRGB(150, 0, 255) -- Neon Purple
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = true

-- Simplified targeting (No wallcheck for testing)
local function getTarget()
    local target = nil
    local dist = 300
    local mousePos = UserInputService:GetMouseLocation()

    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        -- Removed Team Check temporarily to guarantee a target is found
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if magnitude < dist then
                    target = head
                    dist = magnitude
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    -- Lock FOV circle to mouse
    local currentMousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = currentMousePos
    
    -- ONLY LOCK ON WHEN RIGHT CLICK IS HELD
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getTarget()
        if target then
            local screenPos, _ = Camera:WorldToViewportPoint(target.Position)
            
            -- Pixel delta calculation
            local moveX = (screenPos.X - currentMousePos.X) * 0.2
            local moveY = (screenPos.Y - currentMousePos.Y) * 0.2
            
            -- Hardware input
            if mousemoverel then
                mousemoverel(moveX, moveY)
            else
                print("[NYKLYX ERROR]: mousemoverel function is missing or blocked!")
            end
        end
    end
end)

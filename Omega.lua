-- =====================================================================
-- MONOCHROME + PORTAL GUN // COMBINED v21
--  - Портал ставится ТОЧНО в точку выстрела (убран wallYShift)
--  - Взрыв после [Q]: вспышка, огненный шар, дым, искры,
--    обломки дрона, пыль и камни (без ударной волны)
--  - ★ КИНО-БОМБА v21: [B] — выбрать точку, аниме-портал, кино-камера,
--    letterbox, speed-lines, обратный отсчёт, impact-frame,
--    новый взрыв (грибовидное облако, световой столб, кратер, камни)
--  - [B] — выбрать точку · Backspace — пропустить/отмена
--  - Фиолетовая бомба: БЕЗ свечения, с пиканьем 91476644853368,
--    серые камни после взрыва
-- =====================================================================

local M = {}
M.CLR, M.TM, M.SND, M.EK, M.FLY, M.DM, M.SC, M.LB, M.W = {}, {}, {}, {}, {}, {}, {}, {}, {}

do -- COLORS
    local RED = Color3.fromRGB(232,28,28)
    M.CLR.RED        = RED
    M.CLR.WHITE      = Color3.fromRGB(255,255,255)
    M.CLR.ICE        = Color3.fromRGB(190,225,255)
    M.CLR.BLOOD      = RED
    M.CLR.BLOOD_DARK = RED
    M.CLR.BLOOD_LT   = RED
    M.CLR.BLOOD_OLD  = RED
    M.CLR.GORE_A     = RED
    M.CLR.GORE_B     = RED
    M.CLR.GORE_C     = RED
    M.CLR.STREAK     = RED
    M.CLR.SPLAT      = RED
    M.CLR.NERVE_A    = Color3.fromRGB(30,85,210)
    M.CLR.NERVE_B    = Color3.fromRGB(55,115,230)
    M.CLR.MUSCLE_A   = Color3.fromRGB(125,55,45)
    M.CLR.MUSCLE_B   = Color3.fromRGB(92,40,36)
    M.CLR.BONE       = Color3.fromRGB(255,255,255)
    M.CLR.THREAD     = Color3.fromRGB(35,30,40)
    M.CLR.SHARD      = Color3.fromRGB(14,12,18)
    M.CLR.DUST       = Color3.fromRGB(200,195,185)
    M.CLR.GHOST      = Color3.fromRGB(170,200,255)
    M.CLR.MIST       = Color3.fromRGB(195,220,240)
end

do -- TIMING
    M.TM.CHAOS        = 0.42
    M.TM.TURN         = 0.10
    M.TM.STREAK       = 0.22
    M.TM.STREAK_JIT   = 0.08
    M.TM.GHOST_START  = 0.48
    M.TM.GHOST_TIME   = 0.40
    M.TM.TOTAL        = 0.86
    M.TM.SPLAT_LIFE   = 2.0
    M.TM.SPLAT_FADE   = 0.5
    M.TM.FLASH        = 0.3
    M.TM.FRAG_LIFE    = 2.4
    M.TM.PRINT_SND    = 8
    M.TM.BLOOD_POOL   = 3.5
end

do -- SOUNDS
    M.SND.REGEN        = "rbxassetid://84312631986360"
    M.SND.DISINTEGRATE = "rbxassetid://139916424589528"
    M.SND.DECAL        = "rbxassetid://80559445961612"
    M.SND.SPAWN        = "rbxassetid://74562584385247"
    M.SND.ENTER        = "rbxassetid://102568033872947"
    M.SND.SCANNER      = "rbxassetid://129289790297292"
    M.SND.EXPLOSION    = "rbxassetid://138533090376585"
    M.SND.BOMB_BEEP    = "rbxassetid://91476644853368"
end

do -- REGEN MODEL ASSETS
    M.RGN_IDS = {
        bone       = "rbxassetid://70473244410151",
        muscleRed  = "rbxassetid://120986606825859",
        muscleBlue = "rbxassetid://128534142433183",
        root       = "rbxassetid://140378954130619",
    }
end

do -- FLIGHT
    M.FLY.ID    = "rbxassetid://98316282912132"
    M.FLY.SPEED = 70
    M.FLY.FAST  = 140
    M.FLY.VERT  = 55
end

getgenv().RegenModelConfig = {
    bone       = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    muscleRed  = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    muscleBlue = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    root       = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    decal      = {offX=0, offY=2.2, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
}

getgenv().FlyModelConfig = {
    offX=0.00, offY=-0.10, offZ=-0.70,
    rotX=0, rotY=0, rotZ=0,
    scale=0.90, gap=1.30,
    lean=18, armX=138, armZ=14, elbow=-32,
    legFwd=62, legSpread=9, kneeBend=78, grip=2.5,
}

do -- DIMENSIONS
    M.DM.RANGE        = 10000
    M.DM.PORTAL_GAP   = 0.03
    M.DM.PORTAL_SIZE  = 8.5
    M.DM.COOLDOWN     = 0.25
    M.DM.PORTAL_LIFE  = 15
    M.DM.EXIT_H       = 5
    M.DM.GARAGE_SCALE = 0.75
    M.DM.RETRO_SCALE  = 0.70
    M.DM.OMEGA_SCALE  = 0.5
    M.DM.GARAGE_C     = Vector3.new(0,32000,0)
    M.DM.RETRO_C      = Vector3.new(0,56000,0)
    M.DM.OMEGA_C      = Vector3.new(0,72000,0)
    M.DM.GARAGE_O_Y   = 5
    M.DM.OMEGA_O_Y    = 5
    M.DM.GARAGE_ID    = "rbxassetid://116913770111820"
    M.DM.RETRO_ID     = "rbxassetid://1583359288"
    M.DM.OMEGA_ID     = "rbxassetid://126041705531931"
end

do -- WALK / SCANNER
    M.W.CALM   = 10
    M.W.NORMAL = 16
    M.SC.LOOK_ANGLE   = 45
    M.SC.STICKY_ANGLE = 80
    M.SC.LOOK_DIST    = 60
    M.SC.STICKY_DIST  = 90
end

do -- EMOTE KEYFRAMES
    M.EK.SPEED      = 1.0
    M.EK.HEAD_TRACK = true
    M.EK.TORSO_LEAN = true
    M.EK.IDLE       = true
    M.EK.IDLE_AMP   = 0.8
    M.EK.IDLE_SPD   = 1.6
    M.EK.SHOULDER = {
        {0.000,0,0,0},{0.050,-9,3,4},{0.100,78,-9,-18},{0.166,150,-18,-37},
        {0.233,166,-21,-40},{0.300,156,-22,-38},{0.366,146,-21,-44},
        {0.433,122,9,-36},{0.500,96,26,-28},{0.566,75,39,-25},
        {0.633,60,22,-9},{0.700,22,6,-3},{0.750,-5,1,2},{0.800,0,0,0},
    }
    M.EK.ELBOW = {
        {0.000,0,0,0},{0.050,-12,0,0},{0.100,-22,0,0},{0.166,-52,0,0},
        {0.233,-60,0,0},{0.300,-56,0,0},{0.366,-48,0,0},{0.433,-34,0,0},
        {0.500,-20,0,0},{0.566,-10,0,0},{0.633,-4,0,0},{0.700,0,0,0},
    }
    M.EK.WRIST = {
        {0.000,0,0,0},{0.100,-6,0,12},{0.166,-12,0,22},{0.233,-14,0,24},
        {0.300,-11,0,19},{0.366,-6,0,11},{0.433,0,0,4},{0.500,5,0,-9},
        {0.566,9,0,-16},{0.633,4,0,-8},{0.700,0,0,0},
    }
    M.EK.NECK = {
        {0.000,0,0,0},{0.100,4,0,-6},{0.166,7,0,-10},{0.233,8,0,-11},
        {0.300,6,0,-8},{0.366,3,0,-3},{0.433,1,0,3},{0.500,0,0,6},
        {0.566,-1,0,5},{0.633,0,0,2},{0.700,0,0,0},
    }
    M.EK.TORSO = {
        {0.000,0,0,0},{0.100,-2.5,0,-4},{0.166,-3.5,0,-7},{0.233,-3.5,0,-8},
        {0.300,-2.5,0,-5},{0.366,-1,0,-2},{0.433,0,0,2},{0.500,1,0,3.5},
        {0.566,1,0,2.5},{0.633,0,0,1},{0.700,0,0,0},
    }
end

do -- LIMB TABLES
    M.LB.R6 = {
        RightArm={"Right Arm"}, LeftArm={"Left Arm"},
        RightLeg={"Right Leg"}, LeftLeg={"Left Leg"},
    }
    M.LB.R15 = {
        RightArm={"RightUpperArm","RightLowerArm","RightHand"},
        LeftArm ={"LeftUpperArm","LeftLowerArm","LeftHand"},
        RightLeg={"RightUpperLeg","RightLowerLeg","RightFoot"},
        LeftLeg ={"LeftUpperLeg","LeftLowerLeg","LeftFoot"},
    }
    M.LB.TORSO = { R6={"Torso"}, R15={"UpperTorso","LowerTorso"} }
    M.LB.REGEN_ORDER = {"Head","Torso","RightArm","LeftArm","RightLeg","LeftLeg"}
end

local function svc(n)
    local ok, s = pcall(function() return game:GetService(n) end)
    return ok and s or nil
end
local Players          = svc("Players")
local CoreGui          = svc("CoreGui")
local RunService       = svc("RunService")
local TweenService     = svc("TweenService")
local UserInputService = svc("UserInputService")
local Lighting         = svc("Lighting")
local SoundService     = svc("SoundService")
local StarterGui       = svc("StarterGui")
local InsertService    = svc("InsertService")

local LocalPlayer = Players and Players.LocalPlayer
if not LocalPlayer then
    local t0 = os.clock()
    repeat task.wait(0.1) LocalPlayer = Players.LocalPlayer until LocalPlayer or os.clock()-t0 > 15
end
if not LocalPlayer then warn("[MONO] LocalPlayer не найден"); return end

local Camera = workspace.CurrentCamera
if not Camera then
    local t0 = os.clock()
    repeat task.wait(0.1) Camera = workspace.CurrentCamera until Camera or os.clock()-t0 > 10
end

local p = LocalPlayer

pcall(function()
    if CoreGui then
        for _, n in ipairs({"MonoPortalGunGui","MonoMobileBombGui"}) do
            local o = CoreGui:FindFirstChild(n); if o then o:Destroy() end
        end
    end
end)
if workspace:FindFirstChild("MonoRegenFX") then workspace.MonoRegenFX:Destroy() end
if workspace:FindFirstChild("MonoFlyModel") then workspace.MonoFlyModel:Destroy() end
if workspace:FindFirstChild("MonoAntiFling") then workspace.MonoAntiFling:Destroy() end
pcall(function() RunService:UnbindFromRenderStep("MonoDeathCam") end)
pcall(function() RunService:UnbindFromRenderStep("MonoCine") end)
if getgenv and getgenv().hardStopFlight then pcall(getgenv().hardStopFlight); getgenv().hardStopFlight = nil end
if getgenv then getgenv().toggleFlight = nil end
if getgenv and getgenv().MonoConnections then
    for _, c in ipairs(getgenv().MonoConnections) do
        pcall(function() if c.Connected then c:Disconnect() end end)
    end
end
if getgenv then getgenv().MonoConnections = {} end
if getgenv and getgenv().MonoHoleParts then
    for part in pairs(getgenv().MonoHoleParts) do
        if part and part.Parent then pcall(function() part.CanCollide = true end) end
    end
end
if getgenv then getgenv().MonoHoleParts = {} end

local function track(c) if getgenv then table.insert(getgenv().MonoConnections, c) end; return c end
local function log(...) print("[MONO]", ...) end
log("=== COMBINED v21 LOADING ===")

local destroyPortalPart
local shoot

getgenv().PrimePrinterConfig = {
    AutoRegen=false, AutoShatter=false, ShatterHP=20,
    LimbLossRegen=true, LimbLossHP=15, LimbLossCooldown=1.5,
    RespawnAtDeathSpot=true, RespawnFromOneLimb=true,
    HideForceField=true, LockCameraOnDeath=false,
    SecondWind=false, SecondWindHP=25, SecondWindHeal=0.5, SecondWindCD=75,
    RegenSpeed=1.0, RegenRedFlash=false,
}
local config = getgenv().PrimePrinterConfig

local function isClothingDecal(d)
    if not d or not d:IsA("Decal") then return false end
    local par = d.Parent; if not par then return false end
    if par:IsA("Shirt") or par:IsA("Pants") or par:IsA("TShirt") or par:IsA("Clothing") then return true end
    local pn = string.lower(par.Name or "")
    if pn=="shirt" or pn=="pants" or pn=="tshirt" or pn=="clothing"
        or pn=="classic shirt" or pn=="classic pants" or pn=="classic tshirt" then return true end
    local dn = string.lower(d.Name or "")
    if dn=="shirt" or dn=="pants" or dn=="tshirt" then return true end
    return false
end
local function isAccessoryHandle(part)
    if not part or not part:IsA("BasePart") then return false end
    local par = part.Parent
    if not par then return false end
    return par:IsA("Accessory") or par:IsA("Hat")
end
local function isInsideAccessory(obj)
    if not obj then return false end
    local par = obj.Parent
    while par and par ~= workspace do
        if par:IsA("Accessory") or par:IsA("Hat") then return true end
        par = par.Parent
    end
    return false
end
local function isInsideTool(obj) return obj:FindFirstAncestorWhichIsA("Tool") ~= nil end

local walkMode, savedWalkSpeed = false, M.W.NORMAL
local function applyWalkMode()
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.WalkSpeed == 0 and walkMode then return end
    hum.WalkSpeed = walkMode and M.W.CALM or savedWalkSpeed
end
local function setWalkMode(state, silent)
    walkMode = state; applyWalkMode()
    if not silent then
        pcall(function() StarterGui:SetCore("SendNotification",
            {Title=walkMode and "Походка: СПОКОЙНАЯ" or "Походка: ОБЫЧНАЯ", Text="[H]", Duration=3}) end)
    end
end
local function toggleWalkMode() setWalkMode(not walkMode) end

local function hideForceFields(char)
    if not config.HideForceField then return end
    local function hide(ff) if ff and ff:IsA("ForceField") then pcall(function() ff.Visible=false end) end end
    for _, d in ipairs(char:GetDescendants()) do hide(d) end
    track(char.DescendantAdded:Connect(hide))
end

local function cameraShake(intensity, duration)
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    task.spawn(function()
        local t0 = os.clock()
        while os.clock()-t0 < duration do
            local d = 1 - (os.clock()-t0)/duration
            hum.CameraOffset = Vector3.new(
                (math.random()-0.5)*2*intensity*d,
                (math.random()-0.5)*2*intensity*d,
                (math.random()-0.5)*2*intensity*d*0.5)
            RunService.RenderStepped:Wait()
        end
        hum.CameraOffset = Vector3.new(0,0,0)
    end)
end

-- =====================================================================
-- GUNS
-- =====================================================================
local GUN_DEFS = {
    evil_morty = {
        id="evil_morty", name="Evil Morty Portal Gun",
        assetId="rbxassetid://113344864471588",
        muzzleOffset=CFrame.new(0,0,-2),
        portalTexture="rbxassetid://129332930839385",
        beamColor=Color3.fromRGB(190,255,205),
        recolor=true,
        defaultConfig={posX=0.00,posY=0.65,posZ=-0.25,rotX=180,rotY=180,rotZ=180,scale=1.25},
    },
    rick_portal = {
        id="rick_portal", name="Rick Portal Gun",
        assetId="rbxassetid://126868848475018",
        muzzleOffset=CFrame.new(0,0,-2),
        portalTexture="rbxassetid://111394501324479",
        portalModelId="rbxassetid://75803396857476",
        beamColor=Color3.fromRGB(190,255,205),
        recolor=false,
        defaultConfig={posX=0.00,posY=0.65,posZ=-0.25,rotX=180,rotY=180,rotZ=180,scale=1.25},
    },
}
local GUN_ORDER = { "evil_morty", "rick_portal" }
local GUN_PORTAL_STYLE = {
    portalSize=8.5, spinSpeed=0.65, disappearTime=0.30, imageFinalTrans=0,
    openSlitW=0.045, openSlitH=1.30, openWideW=1.50, openWideH=0.50,
    openSettleW=0.85, openSettleH=1.15, openT1=0.11, openT2=0.12, openT3=0.14,
}
local HEROES = {
    evil_morty_2 = {
        id="evil_morty_2", name="Evil Morty", accent=Color3.fromRGB(255,200,90),
        desc="[R] сканер · [H] ходьба · [6] распад\n[Q] полёт · [8] щит · [N] пушка\n[B] кино-бомба · [Backspace] отмена\nПорталы [Z C X E V]\nЛКМ с бомбой = бросок",
        abilities={walk=true, modes=true, scanner=true},
    },
}
local currentHero = HEROES.evil_morty_2
getgenv().currentHeroId = currentHero.id

local currentDestination = "Normal"
local spawnedGarage, spawnedRetro, spawnedOmega
local garageSpawnPoint, omegaSpawnPoint
local nextPortal, returnPosition = 1, nil
local Guns = {}
local activeGunId = "evil_morty"
local portal1, portal2
local lastTeleport, arrivedAt, isTeleporting = 0, nil, false
local screenGui, configFrame, codeBox
local configRows, gunSelectorButtons = {}, {}
local emoteActive, emoteToken, idleClock, lastMoveStateAnim = false, 0, 0, nil
local scannerActive, hasTarget, stickyTarget = false, false, nil
local gunShotT = -10
local flight = {active=false, vel=Vector3.zero, t0=0}
local EXT = {}

local function getActiveGun() return Guns[activeGunId] end

local sSnd = Instance.new("Sound"); sSnd.SoundId=M.SND.SPAWN; sSnd.Volume=1.5; sSnd.Parent=workspace
local tSnd = Instance.new("Sound"); tSnd.SoundId=M.SND.SPAWN; tSnd.Volume=1.5; tSnd.Parent=workspace
local enterSnd = Instance.new("Sound"); enterSnd.SoundId=M.SND.ENTER; enterSnd.Volume=1.5; enterSnd.Parent=workspace

local function notify(t, x)
    pcall(function() StarterGui:SetCore("SendNotification",{Title=t,Text=x,Duration=3}) end)
end
local function gunCFrame(cfg)
    return CFrame.new(cfg.posX,cfg.posY,cfg.posZ)
        * CFrame.Angles(math.rad(cfg.rotX),math.rad(cfg.rotY),math.rad(cfg.rotZ))
end

local function loadAssetModel(assetId)
    if not assetId then return nil end
    local clean = tostring(assetId):gsub("rbxassetid://", "")
    local ids = {clean, "rbxassetid://" .. clean}
    for _, id in ipairs(ids) do
        local ok, objs = pcall(function() return game:GetObjects(id) end)
        if ok and objs and objs[1] then
            local obj = objs[1]
            if obj:IsA("Tool") then
                local m = Instance.new("Model"); obj.Parent = m; return m
            elseif obj:IsA("Model") then
                return obj
            elseif obj:IsA("BasePart") then
                local m = Instance.new("Model"); obj.Parent = m; return m
            end
        end
    end
    if InsertService then
        local num = tonumber(clean:match("%d+"))
        if num then
            local ok, model = pcall(function() return InsertService:LoadAsset(num) end)
            if ok and model then
                for _, child in ipairs(model:GetChildren()) do
                    if child:IsA("Model") then return child end
                    if child:IsA("Tool") then
                        local m = Instance.new("Model"); child.Parent = m; return m
                    end
                    if child:IsA("BasePart") then
                        local m = Instance.new("Model"); child.Parent = m; return m
                    end
                end
                return model
            end
        end
    end
    warn("[MONO] Не удалось загрузить модель: " .. tostring(assetId))
    return nil
end

local function recolorGunModel(folder)
    if not folder then return end
    for _, part in ipairs(folder:GetDescendants()) do
        if part:IsA("BasePart") then
            local c = part.Color
            if c.R>0.5 and c.G>0.4 and c.B<0.45 and (c.R+c.G)>c.B*2 then
                part.Color = Color3.fromRGB(60,62,75)
                if part.Material==Enum.Material.Neon then part.Material=Enum.Material.Metal end
            end
        end
    end
end

local function buildGunInstance(def)
    local gc = def.config
    local gun = {def=def, config=gc, tool=nil, handle=nil, muzzle=nil, bodyFolder=nil, welds={}, muzzleWeld=nil}
    local t = Instance.new("Tool")
    t.Name=def.name; t.RequiresHandle=true; t.CanBeDropped=false
    local h = Instance.new("Part")
    h.Name="Handle"; h.Size=Vector3.new(0.2,0.2,0.2); h.Transparency=1
    h.CanCollide=false; h.CanTouch=false; h.CanQuery=false; h.Massless=true
    h.Parent=t
    local snd = Instance.new("Sound"); snd.Name="ShotSound"; snd.SoundId=M.SND.SPAWN; snd.Volume=1.2; snd.Parent=h
    t.PrimaryPart = h
    gun.tool=t; gun.handle=h
    local folder = Instance.new("Folder"); folder.Name="GunBody"; folder.Parent=t
    gun.bodyFolder = folder
    local src = loadAssetModel(def.assetId)
    if src then
        if not src:IsA("Model") then
            local w = Instance.new("Model"); src.Parent = w; src = w
        end
        local sp = src:GetPivot()
        for _, o in ipairs(src:GetDescendants()) do
            if o:IsA("Script") or o:IsA("LocalScript") or o:IsA("ModuleScript") then o:Destroy() end
        end
        for _, part in ipairs(src:GetDescendants()) do
            if part:IsA("BasePart") then
                local rel = sp:ToObjectSpace(part.CFrame)
                local bs = part.Size
                part.Anchored=false; part.CanCollide=false
                part.CanTouch=false; part.CanQuery=false; part.Massless=true
                part.Parent = folder
                local weld = Instance.new("Weld")
                weld.Part0=h; weld.Part1=part
                weld.C0 = gunCFrame(gc)*rel; weld.C1 = CFrame.new()
                weld.Parent=h
                table.insert(gun.welds, {weld=weld, baseCF=rel, part=part, baseSize=bs})
            end
        end
        src:Destroy()
    end
    if def.recolor then recolorGunModel(folder) end
    if #gun.welds == 0 then
        local function mkFb(name, size, color, material, relCF)
            local fb = Instance.new("Part")
            fb.Name=name; fb.Size=size
            fb.Color=color; fb.Material=material or Enum.Material.Metal
            fb.Anchored=false; fb.CanCollide=false
            fb.CanTouch=false; fb.CanQuery=false; fb.Massless=true
            fb.Parent=folder
            local weld = Instance.new("Weld")
            weld.Part0=h; weld.Part1=fb
            weld.C0 = gunCFrame(gc)*relCF; weld.C1=CFrame.new()
            weld.Parent=h
            table.insert(gun.welds, {weld=weld, baseCF=relCF, part=fb, baseSize=size})
        end
        mkFb("FbBody", Vector3.new(0.55,0.55,1.5), Color3.fromRGB(60,62,75), Enum.Material.Metal, CFrame.new(0,0,-0.4))
        mkFb("FbBarrel", Vector3.new(0.32,0.32,1.6), Color3.fromRGB(75,78,92), Enum.Material.Metal, CFrame.new(0,0,-1.7))
        mkFb("FbGrip", Vector3.new(0.28,0.7,0.35), Color3.fromRGB(40,42,52), Enum.Material.Metal, CFrame.new(0,-0.5,0.1)*CFrame.Angles(math.rad(15),0,0))
        mkFb("FbMuzzle", Vector3.new(0.42,0.42,0.2), Color3.fromRGB(140,255,180), Enum.Material.Neon, CFrame.new(0,0,-2.5))
    end
    local muzzle = Instance.new("Part")
    muzzle.Name="Muzzle"; muzzle.Size=Vector3.new(0.2,0.2,0.2)
    muzzle.Transparency=1; muzzle.CanCollide=false; muzzle.Massless=true
    muzzle.Parent=t
    gun.muzzle = muzzle
    local mw = Instance.new("Weld")
    mw.Part0=h; mw.Part1=muzzle
    mw.C0 = gunCFrame(gc)*(def.muzzleOffset or CFrame.new(0,0,-1))
    mw.C1 = CFrame.new(); mw.Parent=h
    gun.muzzleWeld = mw
    return gun
end

local function applyGunConfig(gun)
    gun = gun or getActiveGun()
    if not gun or not gun.welds then return end
    local gc = gun.config
    local s = gc.scale
    local gcf = gunCFrame(gc)
    for _, e in ipairs(gun.welds) do
        if e.weld and e.weld.Parent then
            local sc = CFrame.new(e.baseCF.Position*s)*(e.baseCF-e.baseCF.Position)
            e.weld.C0 = gcf*sc
            if e.part and e.part.Parent and e.baseSize then e.part.Size = e.baseSize*s end
        end
    end
    if gun.muzzleWeld and gun.muzzleWeld.Parent then
        local mo = gun.def.muzzleOffset or CFrame.new(0,0,-1)
        local sm = CFrame.new(mo.Position*s)*(mo-mo.Position)
        gun.muzzleWeld.C0 = gcf*sm
    end
end

local function updateCodeBox()
    if not codeBox then return end
    local gun = getActiveGun(); if not gun then return end
    local c = gun.config
    codeBox.Text = string.format("[%s]\nGUN_POS=Vector3.new(%.2f,%.2f,%.2f)\nGUN_ROT=CFrame.Angles(math.rad(%.0f),math.rad(%.0f),math.rad(%.0f))\nGUN_SCALE=%.2f",
        gun.def.name, c.posX,c.posY,c.posZ, c.rotX,c.rotY,c.rotZ, c.scale)
end
local function refreshAllConfigRows()
    local gun = getActiveGun(); if not gun then return end
    for _, e in ipairs(configRows) do
        if e.valLbl and e.valLbl.Parent then e.valLbl.Text = string.format("%.2f", gun.config[e.key]) end
    end
end
local function refreshGunSelectorStyles()
    for id, btn in pairs(gunSelectorButtons) do
        if btn and btn.Parent then
            local a = id==activeGunId
            btn.BackgroundColor3 = a and Color3.fromRGB(70,90,130) or Color3.fromRGB(30,30,44)
            local s = btn:FindFirstChild("Stroke")
            if s then s.Color = a and Color3.fromRGB(140,180,255) or Color3.fromRGB(75,75,105) end
        end
    end
end
local function setActiveGun(id)
    if not GUN_DEFS[id] then return end
    activeGunId = id
    refreshGunSelectorStyles(); refreshAllConfigRows(); updateCodeBox()
end

local function removeAllGunTools()
    local names = {}
    for _, def in pairs(GUN_DEFS) do names[def.name]=true end
    local bp = p:FindFirstChild("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") and names[v.Name] then v:Destroy() end
        end
    end
    if p.Character then
        for _, v in ipairs(p.Character:GetChildren()) do
            if v:IsA("Tool") and names[v.Name] then v:Destroy() end
        end
    end
end

local function giveGuns()
    if portal1 and destroyPortalPart then destroyPortalPart(portal1) end
    if portal2 and destroyPortalPart then destroyPortalPart(portal2) end
    portal1, portal2 = nil, nil
    arrivedAt = nil; isTeleporting = false; nextPortal = 1
    removeAllGunTools(); Guns = {}
    for _, id in ipairs(GUN_ORDER) do
        local def = GUN_DEFS[id]
        def.config = def.config or {}
        for k, v in pairs(def.defaultConfig) do
            if def.config[k]==nil then def.config[k]=v end
        end
        local ok, gun = pcall(buildGunInstance, def)
        if ok and gun then
            Guns[id] = gun
            if not def.noShoot then
                gun.tool.Activated:Connect(function() if shoot then shoot(gun) end end)
            end
            applyGunConfig(gun)
        else
            warn("[giveGuns] Не удалось собрать "..tostring(id))
        end
    end
    local bp = p:FindFirstChild("Backpack") or p:WaitForChild("Backpack", 10)
    if not bp then warn("[giveGuns] Backpack нет!"); return end
    for _, id in ipairs(GUN_ORDER) do
        if Guns[id] and Guns[id].tool then Guns[id].tool.Parent = bp end
    end
    local names = {}
    for _, id in ipairs(GUN_ORDER) do table.insert(names, GUN_DEFS[id].name) end
    notify("Оружие выдано", table.concat(names, " · "))
end

local function saveReturnPosition()
    if not returnPosition and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        returnPosition = p.Character.HumanoidRootPart.Position
    end
end
local function positionModel(model, targetPos)
    local ok = pcall(function() model:PivotTo(CFrame.new(targetPos)) end)
    if not ok then
        local cf = model:GetBoundingBox()
        local off = targetPos - cf.Position
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then part.CFrame = part.CFrame + off end
        end
    end
end
local function ignoreList()
    local list = {}
    if p.Character then table.insert(list, p.Character) end
    for _, gun in pairs(Guns) do if gun and gun.tool then table.insert(list, gun.tool) end end
    if portal1 and portal1.part then table.insert(list, portal1.part) end
    if portal2 and portal2.part then table.insert(list, portal2.part) end
    local fm = workspace:FindFirstChild("MonoFlyModel")
    if fm then table.insert(list, fm) end
    local afm = workspace:FindFirstChild("MonoAntiFling")
    if afm then table.insert(list, afm) end
    return list
end
local function findGround(pos, fromY)
    if fromY == nil then fromY = 400 end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = ignoreList()
    local o = pos + Vector3.new(0,fromY,0)
    local r = workspace:Raycast(o, Vector3.new(0,-2000,0), rp)
    return r and r.Position or pos
end
local function createBeam(a, b, color)
    local dist = (b-a).Magnitude
    if dist < 0.1 then return end
    local beam = Instance.new("Part")
    beam.Anchored=true; beam.CanCollide=false; beam.CanTouch=false; beam.CanQuery=false
    beam.Size=Vector3.new(0.2,0.2,dist)
    beam.Color=color or Color3.fromRGB(200,220,255)
    beam.Material=Enum.Material.Neon
    beam.CFrame=CFrame.lookAt(a,b)*CFrame.new(0,0,-dist/2)
    beam.Parent=workspace
    local tw = TweenService:Create(beam, TweenInfo.new(0.15), {Size=Vector3.new(0,0,dist), Transparency=1})
    tw:Play(); tw.Completed:Connect(function() beam:Destroy() end)
end

local function getFxFolder()
    local f = workspace:FindFirstChild("MonoRegenFX")
    if not f then f = Instance.new("Folder"); f.Name="MonoRegenFX"; f.Parent=workspace end
    return f
end
local function lookCF(from, to)
    local dir = to - from
    if dir.Magnitude < 1e-4 then return CFrame.new(from) end
    local up = (math.abs(dir.Unit.Y) > 0.98) and Vector3.new(1,0,0) or Vector3.new(0,1,0)
    return CFrame.lookAt(from, to, up)
end
local function randUnit()
    for _=1,20 do
        local v = Vector3.new(math.random()*2-1, math.random()*2-1, math.random()*2-1)
        local mg = v.Magnitude
        if mg>0.1 and mg<=1 then return v/mg end
    end
    return Vector3.new(0,1,0)
end
local function safeUnit(v, fb) if v.Magnitude > 0.05 then return v.Unit end; return fb end

-- =====================================================================
-- REGEN MODEL HELPERS
-- =====================================================================
local REGEN_MODEL_CACHE = {}
local function getRegenModelSrc(key)
    if REGEN_MODEL_CACHE[key] ~= nil then return REGEN_MODEL_CACHE[key] end
    local id = M.RGN_IDS[key]
    if not id then REGEN_MODEL_CACHE[key] = false; return false end
    local ok, mdl = pcall(loadAssetModel, id)
    if ok and mdl then
        REGEN_MODEL_CACHE[key] = mdl
        return mdl
    end
    REGEN_MODEL_CACHE[key] = false
    return false
end
local function getRegenModelCfg(key)
    local t = getgenv().RegenModelConfig
    if not t then return nil end
    return t[key]
end
local function applyRegenModelCfg(key, model)
    local cfg = getRegenModelCfg(key)
    if not cfg or not model then return end
    pcall(function() model:ScaleTo(cfg.scale or 1) end)
end
local function regenModelCF(key, baseCF)
    local cfg = getRegenModelCfg(key)
    if not cfg then return baseCF end
    local off = CFrame.new(cfg.offX or 0, cfg.offY or 0, cfg.offZ or 0)
        * CFrame.Angles(math.rad(cfg.rotX or 0), math.rad(cfg.rotY or 0), math.rad(cfg.rotZ or 0))
    return baseCF * off
end
local function buildRegenModel(key)
    local src = getRegenModelSrc(key)
    if not src then return nil end
    local clone = src:Clone()
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
            d:Destroy()
        elseif d:IsA("BasePart") then
            d.Anchored = true
            d.CanCollide = false
            d.CanTouch = false
            d.CanQuery = false
            d.CastShadow = false
        end
    end
    applyRegenModelCfg(key, clone)
    return clone
end
local function hideRegenModel(model)
    if not model then return end
    pcall(function() model:PivotTo(CFrame.new(0, -5000, 0)) end)
end

-- =====================================================================
-- EMOTE
-- =====================================================================
local function getRightShoulder(char)
    if not char then return nil end
    return char:FindFirstChild("Right Shoulder", true) or char:FindFirstChild("RightShoulder", true)
end
local function findJoint(char, ...)
    if not char then return nil end
    for _, n in ipairs({...}) do
        local j = char:FindFirstChild(n, true)
        if j and (j:IsA("Motor6D") or j:IsA("JointInstance")) then return j end
    end
end
local function collectEmoteJoints(char)
    if not char then return {} end
    return {
        shoulder = getRightShoulder(char),
        elbow    = findJoint(char, "RightElbow"),
        wrist    = findJoint(char, "RightWrist"),
        neck     = findJoint(char, "Neck"),
        torso    = findJoint(char, "Waist"),
    }
end
local function catmull(p0,p1,p2,p3,u)
    local u2,u3 = u*u, u*u*u
    return 0.5*((2*p1)+(-p0+p2)*u+(2*p0-5*p1+4*p2-p3)*u2+(-p0+3*p1-3*p2+p3)*u3)
end
local function sampleKeys(keys, t)
    local n = #keys
    if t <= keys[1][1] then return keys[1][2],keys[1][3],keys[1][4] end
    if t >= keys[n][1] then return keys[n][2],keys[n][3],keys[n][4] end
    for i=1,n-1 do
        local k1,k2 = keys[i],keys[i+1]
        if t>=k1[1] and t<=k2[1] then
            local k0=keys[math.max(i-1,1)]
            local k3=keys[math.min(i+2,n)]
            local u=(t-k1[1])/(k2[1]-k1[1])
            return catmull(k0[2],k1[2],k2[2],k3[2],u),
                   catmull(k0[3],k1[3],k2[3],k3[3],u),
                   catmull(k0[4],k1[4],k2[4],k3[4],u)
        end
    end
    return 0,0,0
end
local function applyJointRot(joint, cache, rx, ry, rz)
    if not joint or not joint.Parent then return end
    local c = cache[joint]
    if not c then
        local c0 = joint.C0
        local rc = c0 - c0.Position
        c = {rc=rc, rcInv=rc:Inverse()}; cache[joint] = c
    end
    local R = CFrame.Angles(math.rad(rx), math.rad(ry), math.rad(rz))
    joint.Transform = c.rcInv * R * c.rc
end
local function resetJoint(j) if j and j.Parent then j.Transform = CFrame.new() end end

local function playEmote()
    if emoteActive or flight.active then return end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local joints = collectEmoteJoints(char)
    if not joints.shoulder then return end
    emoteActive = true; emoteToken = emoteToken + 1
    local token = emoteToken
    local cache = {}
    local total = M.EK.SHOULDER[#M.EK.SHOULDER][1]
    local t0 = os.clock()
    local conns = {}
    local function finish()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        for _, j in pairs(joints) do resetJoint(j) end
        if token == emoteToken then emoteActive = false; lastMoveStateAnim = nil end
    end
    local function step()
        local t = (os.clock()-t0)*M.EK.SPEED
        if token ~= emoteToken or not joints.shoulder.Parent or hum.Health<=0 or t>=total then
            finish(); return
        end
        local sx,sy,sz = sampleKeys(M.EK.SHOULDER, t)
        applyJointRot(joints.shoulder, cache, sx,sy,sz)
        if joints.elbow then
            local ex,ey,ez = sampleKeys(M.EK.ELBOW, t)
            applyJointRot(joints.elbow, cache, ex,ey,ez)
        end
        if joints.wrist then
            local wx,wy,wz = sampleKeys(M.EK.WRIST, t)
            applyJointRot(joints.wrist, cache, wx,wy,wz)
        end
        if M.EK.HEAD_TRACK and joints.neck then
            local nx,ny,nz = sampleKeys(M.EK.NECK, t)
            applyJointRot(joints.neck, cache, nx,ny,nz)
        end
        if M.EK.TORSO_LEAN and joints.torso then
            local tx,ty,tz = sampleKeys(M.EK.TORSO, t)
            applyJointRot(joints.torso, cache, tx,ty,tz)
        end
    end
    table.insert(conns, RunService.Stepped:Connect(step))
    table.insert(conns, RunService.Heartbeat:Connect(step))
    table.insert(conns, RunService.RenderStepped:Connect(step))
    for _, c in ipairs(conns) do track(c) end
end

-- =====================================================================
-- СУСТАВЫ (R6 + R15)
-- =====================================================================
local rotCache = setmetatable({}, {__mode="k"})
local jointsCache = setmetatable({}, {__mode="k"})

local function smooth01(x) x = math.clamp(x,0,1); return x*x*(3-2*x) end

local function getBodyJoints(char)
    local c = jointsCache[char]
    if c and c.shoulderR and c.shoulderR.Parent then return c end
    c = {
        root      = findJoint(char, "RootJoint", "Root"),
        waist     = findJoint(char, "Waist"),
        neck      = findJoint(char, "Neck"),
        shoulderR = findJoint(char, "Right Shoulder", "RightShoulder"),
        shoulderL = findJoint(char, "Left Shoulder", "LeftShoulder"),
        elbowR    = findJoint(char, "RightElbow"),
        elbowL    = findJoint(char, "LeftElbow"),
        wristR    = findJoint(char, "RightWrist"),
        wristL    = findJoint(char, "LeftWrist"),
        hipR      = findJoint(char, "Right Hip", "RightHip"),
        hipL      = findJoint(char, "Left Hip", "LeftHip"),
        kneeR     = findJoint(char, "RightKnee"),
        kneeL     = findJoint(char, "LeftKnee"),
    }
    jointsCache[char] = c
    return c
end
local function rot(j, x, y, z)
    if j then applyJointRot(j, rotCache, x, y, z) end
end
local function getHeldGun(char)
    for _, gun in pairs(Guns) do
        if gun and gun.tool and gun.tool.Parent == char then return gun end
    end
    return nil
end
local function gunRaiseAmount()
    local dt = os.clock() - gunShotT
    if dt < 0 then return 0 end
    local UP, HOLD, DOWN = 0.12, 0.30, 0.35
    if dt < UP then return smooth01(dt/UP)
    elseif dt < UP+HOLD then return 1
    elseif dt < UP+HOLD+DOWN then return 1 - smooth01((dt-UP-HOLD)/DOWN)
    end
    return 0
end

-- =====================================================================
-- ПОЛЁТ: модель
-- =====================================================================
local flyModelSrc = nil
local function getFlyModelSrc()
    if flyModelSrc ~= nil then return flyModelSrc end
    local ok, m = pcall(loadAssetModel, M.FLY.ID)
    flyModelSrc = (ok and m) or false
    return flyModelSrc
end

local function buildFlyModel(hrp)
    local src = getFlyModelSrc()
    if not src then return nil end
    local cfg = getgenv().FlyModelConfig
    local model = src:Clone()
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
            or d:IsA("JointInstance") or d:IsA("WeldConstraint") then
            d:Destroy()
        end
    end
    local parts = {}
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then table.insert(parts, d) end
    end
    if #parts == 0 then model:Destroy(); return nil end
    model.Name = "MonoFlyModel"
    model.Parent = workspace
    for _, pt in ipairs(parts) do
        pt.Anchored = true; pt.CanCollide = false; pt.CanTouch = false; pt.CanQuery = false
        pt.Massless = true
    end
    pcall(function() model:ScaleTo(cfg.scale or 1) end)

    local primary, bestVol = parts[1], -1
    for _, pt in ipairs(parts) do
        local v = pt.Size.X * pt.Size.Y * pt.Size.Z
        if v > bestVol then bestVol = v; primary = pt end
    end
    pcall(function() model.PrimaryPart = primary end)

    local bbCF, bbSize = model:GetBoundingBox()
    local pivotToBB = model:GetPivot():ToObjectSpace(bbCF)

    local function computePivotInHrp()
        local c = getgenv().FlyModelConfig
        local depth = (math.abs(math.sin(math.rad(c.rotY or 0))) > 0.5) and bbSize.X or bbSize.Z
        local want = CFrame.new(c.offX or 0, c.offY or 0, (c.offZ or 0) - (depth/2 + (c.gap or 1.3)))
            * CFrame.Angles(math.rad(c.rotX or 0), math.rad(c.rotY or 0), math.rad(c.rotZ or 0))
        return want * pivotToBB:Inverse()
    end

    model:PivotTo(hrp.CFrame * computePivotInHrp())

    for _, pt in ipairs(parts) do
        if pt ~= primary then
            local w = Instance.new("Weld")
            w.Part0 = primary; w.Part1 = pt
            w.C0 = primary.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
            w.Parent = pt
        end
    end
    local hw = Instance.new("Weld")
    hw.Name = "MonoFlyWeld"
    hw.Part0 = hrp; hw.Part1 = primary
    hw.C0 = hrp.CFrame:ToObjectSpace(primary.CFrame); hw.C1 = CFrame.new()
    hw.Parent = primary
    for _, pt in ipairs(parts) do pt.Anchored = false end
    return model, {weld=hw, computePivotInHrp=computePivotInHrp}
end

-- =====================================================================
-- ★ ОБЩИЕ ЭФФЕКТЫ ВЗРЫВОВ (FXH)
-- =====================================================================
local FXH = {}
do
    local NSK = NumberSequenceKeypoint.new
    local GRAV = Vector3.new(0, -130, 0)
    local bodies = {}
    local stepConn = nil
    local ROCK_MATS = {
        Enum.Material.Slate, Enum.Material.Basalt, Enum.Material.Granite,
        Enum.Material.Concrete, Enum.Material.Rock,
    }

    local function rayParams()
        local ex = {getFxFolder()}
        if p.Character then table.insert(ex, p.Character) end
        for _, gun in pairs(Guns) do if gun and gun.tool then table.insert(ex, gun.tool) end end
        local fm = workspace:FindFirstChild("MonoFlyModel"); if fm then table.insert(ex, fm) end
        local af = workspace:FindFirstChild("MonoAntiFling"); if af then table.insert(ex, af) end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= p and pl.Character then table.insert(ex, pl.Character) end
        end
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = ex
        rp.IgnoreWater = true
        return rp
    end
    FXH.rayParams = rayParams

    local function anchorAt(pos, life)
        local a = Instance.new("Part")
        a.Anchored = true; a.CanCollide = false; a.CanTouch = false; a.CanQuery = false
        a.CastShadow = false; a.Transparency = 1; a.Size = Vector3.new(0.2,0.2,0.2)
        a.CFrame = CFrame.new(pos); a.Parent = getFxFolder()
        if life then task.delay(life, function() if a then a:Destroy() end end) end
        return a
    end
    FXH.anchorAt = anchorAt

    local function lifeFade(part, life)
        task.delay(life, function()
            if part and part.Parent then
                TweenService:Create(part, TweenInfo.new(1, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
                task.delay(1.05, function() if part then part:Destroy() end end)
            end
        end)
    end

    local function groundColor(hit)
        local c = Color3.fromRGB(125,122,118)
        local inst = hit and hit.Instance
        if inst and inst:IsA("BasePart") and not inst:IsA("Terrain") then
            c = c:Lerp(inst.Color, 0.55)
        end
        return c
    end

    local function step(dt)
        dt = math.min(dt, 0.05)
        if #bodies == 0 then
            if stepConn then stepConn:Disconnect(); stepConn = nil end
            return
        end
        local rp = rayParams()
        for i = #bodies, 1, -1 do
            local b = bodies[i]
            local part = b.part
            if not part or not part.Parent then
                table.remove(bodies, i)
            elseif not b.rest then
                b.vel = b.vel + GRAV*dt
                local sv = b.vel*dt
                local hit = nil
                if sv.Magnitude > 1e-4 then
                    hit = workspace:Raycast(b.pos, sv + sv.Unit*b.rad, rp)
                end
                if hit then
                    local n = hit.Normal
                    b.pos = hit.Position + n*(b.rad*0.9)
                    local vn = n*b.vel:Dot(n)
                    local vt = b.vel - vn
                    b.vel = vt*0.6 - vn*0.32
                    b.spin = b.spin*0.55
                    b.bounces = b.bounces + 1
                    if b.onImpact then
                        local f = b.onImpact; b.onImpact = nil
                        pcall(f, b, hit)
                    end
                    if b.vel.Magnitude < 8 or b.bounces >= 4 then
                        b.rest = true
                        local base = lookCF(b.pos, b.pos + n) * CFrame.Angles(-math.pi/2, 0, 0)
                        local restCF = base * CFrame.Angles(
                            (math.random()-0.5)*0.5, math.random()*6.283, (math.random()-0.5)*0.5)
                        part.CFrame = restCF + (-n*(b.rad*0.35))
                    else
                        b.rot = CFrame.Angles(b.spin.X*dt, b.spin.Y*dt, b.spin.Z*dt) * b.rot
                        part.CFrame = CFrame.new(b.pos) * b.rot
                    end
                else
                    b.pos = b.pos + sv
                    b.rot = CFrame.Angles(b.spin.X*dt, b.spin.Y*dt, b.spin.Z*dt) * b.rot
                    part.CFrame = CFrame.new(b.pos) * b.rot
                    if b.pos.Y < -500 then
                        table.remove(bodies, i); part:Destroy()
                    end
                end
            end
        end
    end

    function FXH.addBody(part, vel, spin, rad, life, onImpact)
        local cf = part.CFrame
        local b = {
            part = part, pos = cf.Position, rot = cf - cf.Position,
            vel = vel, spin = spin, rad = rad, bounces = 0, rest = false,
            onImpact = onImpact,
        }
        table.insert(bodies, b)
        if not stepConn then stepConn = RunService.Heartbeat:Connect(step) end
        lifeFade(part, life or 4)
    end

    function FXH.groundHit(pos, maxDist)
        local hit = workspace:Raycast(pos + Vector3.new(0,3,0),
            Vector3.new(0, -((maxDist or 20) + 3), 0), rayParams())
        if hit and hit.Normal.Y > 0.6 then return hit end
        return nil
    end

    function FXH.trail(part, dur, color, size)
        local e = Instance.new("ParticleEmitter")
        e.Rate = 40; e.Lifetime = NumberRange.new(0.5, 1.1)
        e.Speed = NumberRange.new(0.5, 3)
        e.SpreadAngle = Vector2.new(180, 180)
        e.Color = ColorSequence.new(color or Color3.fromRGB(80,76,72))
        e.Size = NumberSequence.new({NSK(0, size or 1), NSK(1, (size or 1)*3)})
        e.Transparency = NumberSequence.new({NSK(0, 0.5), NSK(1, 1)})
        e.LightInfluence = 1
        e.Parent = part
        task.delay(dur, function() if e and e.Parent then e.Enabled = false end end)
    end

    function FXH.shell(pos, color, material, startS, endS, dur, trStart, style)
        local s = Instance.new("Part")
        s.Shape = Enum.PartType.Ball; s.Anchored = true
        s.CanCollide = false; s.CanTouch = false; s.CanQuery = false; s.CastShadow = false
        s.Material = material or Enum.Material.Neon
        s.Color = color
        s.Transparency = trStart or 0
        s.Size = Vector3.new(startS, startS, startS)
        s.Position = pos
        s.Parent = getFxFolder()
        TweenService:Create(s, TweenInfo.new(dur, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = Vector3.new(endS, endS, endS), Transparency = 1}):Play()
        task.delay(dur + 0.1, function() if s then s:Destroy() end end)
        return s
    end

    function FXH.light(pos, color, brightness, range, dur)
        local a = anchorAt(pos, dur + 0.3)
        local l = Instance.new("PointLight")
        l.Color = color; l.Brightness = brightness; l.Range = range; l.Shadows = false
        l.Parent = a
        TweenService:Create(l, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Brightness = 0, Range = range*0.4}):Play()
    end

    function FXH.sound(pos, id, vol, maxDist)
        local a = anchorAt(pos, 10)
        local s = Instance.new("Sound")
        s.SoundId = id; s.Volume = vol or 3
        s.RollOffMaxDistance = maxDist or 600
        s.RollOffMode = Enum.RollOffMode.InverseTapered
        s.Parent = a
        s:Play()
    end

    function FXH.shake(pos, intensity, dur, maxDist)
        local cam = workspace.CurrentCamera
        local ref = cam and cam.CFrame.Position
        if not ref then
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            ref = hrp and hrp.Position
        end
        if not ref then return end
        local k = math.clamp(1 - (ref - pos).Magnitude/(maxDist or 200), 0, 1)
        if k > 0.02 then cameraShake(intensity*k, dur) end
    end

    function FXH.ring(center, color, maxR, dur, height, segs)
        segs = segs or 32
        local fx = getFxFolder()
        local parts = {}
        for i = 1, segs do
            local pt = Instance.new("Part")
            pt.Anchored = true; pt.CanCollide = false; pt.CanTouch = false; pt.CanQuery = false
            pt.CastShadow = false; pt.Material = Enum.Material.Neon; pt.Color = color
            pt.Transparency = 0.2; pt.Size = Vector3.new(1, height, 1)
            pt.Parent = fx
            parts[i] = pt
        end
        task.spawn(function()
            local t0 = os.clock()
            while true do
                local u = (os.clock() - t0)/dur
                if u >= 1 then break end
                local e = 1 - (1-u)^3
                local r = 2 + (maxR - 2)*e
                local segLen = (2*math.pi*r/segs)*1.2
                local th = math.max(height*(1 - u*0.6), 0.05)
                local thick = math.max(0.5, 2.4*(1-u))
                local tr = 0.2 + 0.8*(u^1.5)
                for i = 1, segs do
                    local a = (i/segs)*math.pi*2
                    local dir = Vector3.new(math.cos(a), 0, math.sin(a))
                    local pos = center + dir*r + Vector3.new(0, th*0.5, 0)
                    local pt = parts[i]
                    pt.Size = Vector3.new(segLen, th, thick)
                    pt.CFrame = CFrame.lookAt(pos, pos + dir)
                    pt.Transparency = tr
                end
                RunService.Heartbeat:Wait()
            end
            for _, pt in ipairs(parts) do pt:Destroy() end
        end)
    end

    function FXH.dust(hit, o)
        o = o or {}
        local power = o.power or 1
        local col = groundColor(hit):Lerp(Color3.fromRGB(190,180,165), 0.5)
        local a = anchorAt(hit.Position + Vector3.new(0, 0.5, 0), 5)
        local e = Instance.new("ParticleEmitter")
        e.Rate = 0
        e.Lifetime = NumberRange.new(1.3, 2.6)
        e.Speed = NumberRange.new(12*power, 36*power)
        e.SpreadAngle = Vector2.new(85, 85)
        e.Drag = 3
        e.Acceleration = Vector3.new(0, 2, 0)
        e.Color = ColorSequence.new(col)
        e.Size = NumberSequence.new({NSK(0, 2*power), NSK(1, 9*power)})
        e.Transparency = NumberSequence.new({NSK(0, 0.45), NSK(0.6, 0.72), NSK(1, 1)})
        e.Rotation = NumberRange.new(0, 360)
        e.RotSpeed = NumberRange.new(-40, 40)
        e.LightInfluence = 1
        e.Parent = a
        e:Emit(o.count or 40)
    end

    function FXH.spawnRocks(hit, o)
        o = o or {}
        local count = o.count or 22
        local power = o.power or 1
        local life = o.life or 4
        local sizeMul = o.sizeMul or 1
        local spread = o.spread or 1
        local gp = hit.Position
        local gcol = groundColor(hit)
        if o.greyer then
            local grey = (gcol.R + gcol.G + gcol.B) / 3
            gcol = Color3.new(grey, grey, grey):Lerp(Color3.fromRGB(160,158,155), 0.5)
        end
        local dustCol = Color3.fromRGB(95,90,84)
        local fx = getFxFolder()
        for _ = 1, count do
            local big = math.random() < 0.2
            local sz = (big and (1.3 + math.random()*1.5) or (0.35 + math.random()*0.85)) * sizeMul
            local part = Instance.new((math.random() < 0.3) and "WedgePart" or "Part")
            part.Name = "MonoRock"
            part.Anchored = true; part.CanCollide = false; part.CanTouch = false; part.CanQuery = false
            part.CastShadow = big
            part.Material = ROCK_MATS[math.random(1, #ROCK_MATS)]
            local shade = o.greyer and (1.00 + math.random()*0.35) or (0.72 + math.random()*0.5)
            part.Color = Color3.new(
                math.clamp(gcol.R*shade, 0, 1), math.clamp(gcol.G*shade, 0, 1), math.clamp(gcol.B*shade, 0, 1))
            part.Size = Vector3.new(sz, sz*(0.45 + math.random()*0.6), sz*(0.65 + math.random()*0.7))
            part.CFrame = CFrame.new(gp + Vector3.new(
                    (math.random()-0.5)*3*spread, 0.8 + math.random()*0.8, (math.random()-0.5)*3*spread))
                * CFrame.Angles(math.random()*6.283, math.random()*6.283, math.random()*6.283)
            part.Parent = fx
            local ang = math.random()*math.pi*2
            local h = (7 + math.random()*26) * power * (big and 0.7 or 1)
            local up = (26 + math.random()*38) * power * (big and 0.85 or 1)
            local vel = Vector3.new(math.cos(ang)*h, up, math.sin(ang)*h)
            local spin = Vector3.new((math.random()-0.5)*16, (math.random()-0.5)*16, (math.random()-0.5)*16)
            local rad = math.max(part.Size.X, part.Size.Y, part.Size.Z)*0.38
            FXH.addBody(part, vel, spin, rad, life + math.random()*0.6)
            if big then FXH.trail(part, 1.4, dustCol, sz*0.9) end
        end
    end

    function FXH.spawnPebbles(hit, radius, count, life, o)
        o = o or {}
        task.delay(0.1, function()
            local rp = rayParams()
            local gp = hit.Position
            local gcol = groundColor(hit)
            if o.greyer then
                local grey = (gcol.R + gcol.G + gcol.B) / 3
                gcol = Color3.new(grey, grey, grey):Lerp(Color3.fromRGB(155,153,150), 0.5)
            end
            local fx = getFxFolder()
            for _ = 1, count do
                local ang = math.random()*math.pi*2
                local r = radius*(0.2 + math.sqrt(math.random())*0.9)
                local from = gp + Vector3.new(math.cos(ang)*r, 4, math.sin(ang)*r)
                local h = workspace:Raycast(from, Vector3.new(0, -10, 0), rp)
                if h and h.Normal.Y > 0.6 then
                    local sz = 0.15 + math.random()*0.45
                    local pb = Instance.new("Part")
                    pb.Name = "MonoPebble"
                    pb.Anchored = true; pb.CanCollide = false; pb.CanTouch = false; pb.CanQuery = false
                    pb.CastShadow = false
                    pb.Material = ROCK_MATS[math.random(1, #ROCK_MATS)]
                    local shade = o.greyer and (1.00 + math.random()*0.35) or (0.7 + math.random()*0.5)
                    pb.Color = Color3.new(
                        math.clamp(gcol.R*shade, 0, 1), math.clamp(gcol.G*shade, 0, 1), math.clamp(gcol.B*shade, 0, 1))
                    pb.Size = Vector3.new(sz, sz*(0.5 + math.random()*0.5), sz*(0.7 + math.random()*0.6))
                    pb.CFrame = lookCF(h.Position, h.Position + h.Normal) * CFrame.Angles(-math.pi/2, 0, 0)
                        * CFrame.Angles((math.random()-0.5)*0.6, math.random()*6.283, (math.random()-0.5)*0.6)
                        + h.Normal*(sz*0.12)
                    pb.Parent = fx
                    lifeFade(pb, life + math.random()*0.8)
                end
            end
        end)
    end
end

-- =====================================================================
-- ★ ВЗРЫВ ДРОНА ПОСЛЕ [Q] (без ударных волн)
-- =====================================================================
local function flyExplosion(model)
    if not model or not model.Parent then return end
    local okPivot, cf = pcall(function() return model:GetPivot() end)
    if not okPivot or not cf then return end
    local pos = cf.Position
    local fx = getFxFolder()
    local NSK = NumberSequenceKeypoint.new
    local CSK = ColorSequenceKeypoint.new

    FXH.sound(pos, M.SND.EXPLOSION, 3.5, 800)
    FXH.light(pos, Color3.fromRGB(255,170,70), 18, 95, 0.7)

    FXH.shell(pos, Color3.fromRGB(255,252,230), Enum.Material.Neon, 3, 16, 0.16, 0)
    FXH.shell(pos, Color3.fromRGB(255,150,40), Enum.Material.Neon, 4, 27, 0.5, 0.1)
    task.delay(0.04, function()
        FXH.shell(pos + Vector3.new(0, 1.5, 0), Color3.fromRGB(255,75,18), Enum.Material.Neon, 2, 19, 0.55, 0.3)
    end)
    for i = 1, 6 do
        task.delay(0.03*i + math.random()*0.03, function()
            FXH.shell(pos + randUnit()*(3 + math.random()*5),
                (i % 2 == 0) and Color3.fromRGB(255,90,25) or Color3.fromRGB(255,195,90),
                Enum.Material.Neon, 1.5, 6 + math.random()*4, 0.4, 0.25)
        end)
    end

    local la = FXH.anchorAt(pos, 6)

    local sparks = Instance.new("ParticleEmitter")
    sparks.Rate = 0; sparks.Lifetime = NumberRange.new(0.6, 1.5)
    sparks.Speed = NumberRange.new(40, 110)
    sparks.SpreadAngle = Vector2.new(180, 180)
    sparks.Acceleration = Vector3.new(0, -60, 0)
    sparks.Drag = 0.5
    sparks.LightEmission = 1; sparks.LightInfluence = 0
    pcall(function() sparks.Orientation = Enum.ParticleOrientation.VelocityParallel end)
    sparks.Color = ColorSequence.new(Color3.fromRGB(255,235,150), Color3.fromRGB(255,70,15))
    sparks.Size = NumberSequence.new({NSK(0, 0.55), NSK(1, 0)})
    sparks.Transparency = NumberSequence.new({NSK(0, 0), NSK(1, 1)})
    sparks.Parent = la

    local fireP = Instance.new("ParticleEmitter")
    fireP.Rate = 0; fireP.Lifetime = NumberRange.new(0.3, 0.75)
    fireP.Speed = NumberRange.new(18, 52)
    fireP.SpreadAngle = Vector2.new(180, 180)
    fireP.Drag = 3
    fireP.LightEmission = 1; fireP.LightInfluence = 0
    fireP.Rotation = NumberRange.new(0, 360)
    fireP.Color = ColorSequence.new({
        CSK(0, Color3.fromRGB(255,245,200)),
        CSK(0.5, Color3.fromRGB(240,100,20)),
        CSK(1, Color3.fromRGB(70,25,10)),
    })
    fireP.Size = NumberSequence.new({NSK(0, 3), NSK(0.4, 6), NSK(1, 1)})
    fireP.Transparency = NumberSequence.new({NSK(0, 0.1), NSK(0.5, 0.45), NSK(1, 1)})
    fireP.Parent = la

    local smoke = Instance.new("ParticleEmitter")
    smoke.Rate = 0; smoke.Lifetime = NumberRange.new(2.5, 4.5)
    smoke.Speed = NumberRange.new(6, 22)
    smoke.SpreadAngle = Vector2.new(180, 180)
    smoke.Acceleration = Vector3.new(0, 5, 0)
    smoke.Drag = 1.5
    smoke.LightInfluence = 1
    smoke.Rotation = NumberRange.new(0, 360)
    smoke.RotSpeed = NumberRange.new(-30, 30)
    smoke.Color = ColorSequence.new(Color3.fromRGB(62,58,54), Color3.fromRGB(24,24,24))
    smoke.Size = NumberSequence.new({NSK(0, 5), NSK(1, 21)})
    smoke.Transparency = NumberSequence.new({NSK(0, 0.35), NSK(0.5, 0.65), NSK(1, 1)})
    smoke.Parent = la

    local embers = Instance.new("ParticleEmitter")
    embers.Rate = 0; embers.Lifetime = NumberRange.new(1.5, 3)
    embers.Speed = NumberRange.new(5, 22)
    embers.SpreadAngle = Vector2.new(180, 180)
    embers.Acceleration = Vector3.new(0, 8, 0)
    embers.Drag = 1
    embers.LightEmission = 1; embers.LightInfluence = 0
    embers.Color = ColorSequence.new(Color3.fromRGB(255,170,60), Color3.fromRGB(255,60,10))
    embers.Size = NumberSequence.new({NSK(0, 0.3), NSK(1, 0)})
    embers.Transparency = NumberSequence.new({NSK(0, 0), NSK(0.8, 0.3), NSK(1, 1)})
    embers.Parent = la

    pcall(function()
        sparks:Emit(95)
        fireP:Emit(55)
        smoke:Emit(34)
        embers:Emit(32)
    end)

    local count = 0
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") and count < 16 then
            count = count + 1
            local c = d:Clone()
            for _, ch in ipairs(c:GetChildren()) do
                if not (ch:IsA("DataModelMesh") or ch:IsA("Decal") or ch:IsA("SurfaceAppearance")) then
                    ch:Destroy()
                end
            end
            c.Anchored = true; c.CanCollide = false; c.CanTouch = false; c.CanQuery = false
            c.CastShadow = false; c.Massless = true
            c.CFrame = d.CFrame
            c.Parent = fx
            local dir = d.Position - pos
            if dir.Magnitude < 0.1 then dir = randUnit() end
            dir = (dir.Unit + Vector3.new(0, 0.6, 0) + randUnit()*0.4).Unit
            local vel = dir*(30 + math.random()*45)
            local spin = Vector3.new((math.random()-0.5)*20, (math.random()-0.5)*20, (math.random()-0.5)*20)
            local rad = math.clamp(d.Size.Magnitude*0.25, 0.3, 2.5)
            FXH.addBody(c, vel, spin, rad, 4.5)
            FXH.trail(c, 1.6, Color3.fromRGB(45,43,41), math.clamp(rad*1.3, 0.8, 2.5))
        end
    end

    local gh = FXH.groundHit(pos, 24)
    if gh then
        local h = pos.Y - gh.Position.Y
        local k = math.clamp(1 - h/28, 0.15, 1)
        FXH.dust(gh, {count = math.floor(45*k) + 8, power = 1})
        FXH.spawnRocks(gh, {count = math.floor(24*k) + 4, power = 1, life = 4})
        FXH.spawnPebbles(gh, 8, math.floor(20*k) + 4, 4)
    end

    FXH.shake(pos, 1.3, 0.8, 220)
    return pos
end

local function applyFlightPose(char)
    local J = getBodyJoints(char)
    local cfg = getgenv().FlyModelConfig
    local t = os.clock()
    local b = smooth01((t - flight.t0)/0.35)
    local sp = math.clamp(flight.vel.Magnitude / M.FLY.FAST, 0, 1)
    local lean = (cfg.lean + sp*12) * b
    local trem = math.sin(t*13) * (cfg.grip or 2.5) * (0.4 + sp)
    local sway = math.sin(t*2.2) * 1.2

    rot(J.root,  -lean, 0, 0)
    rot(J.waist, 6*b, 0, 0)
    rot(J.neck,  lean*0.9 + 6*b, 0, 0)

    rot(J.shoulderR, (cfg.armX + trem + sway)*b, 0, -cfg.armZ*b)
    rot(J.shoulderL, (cfg.armX - trem - sway)*b, 0,  cfg.armZ*b)
    rot(J.elbowR, (cfg.elbow - trem)*b, 0, 0)
    rot(J.elbowL, (cfg.elbow + trem)*b, 0, 0)
    rot(J.wristR, -22*b, 0, 0)
    rot(J.wristL, -22*b, 0, 0)

    rot(J.hipR, (cfg.legFwd + trem*0.7)*b, 0,  cfg.legSpread*b)
    rot(J.hipL, (cfg.legFwd - trem*0.7)*b, 0, -cfg.legSpread*b)
    rot(J.kneeR, -(cfg.kneeBend + trem)*b, 0, 0)
    rot(J.kneeL, -(cfg.kneeBend - trem)*b, 0, 0)
end

local function stopFlight(silent)
    if not flight.active and not flight.model then return end
    flight.active = false
    if flight.conn then pcall(function() flight.conn:Disconnect() end); flight.conn = nil end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    local explodePos = nil
    if not silent and flight.model and flight.model.Parent then
        local okE, posE = pcall(flyExplosion, flight.model)
        if okE then explodePos = posE end
    end

    for _, k in ipairs({"lv","ao","att","model"}) do
        local o = flight[k]
        if o then pcall(function() o:Destroy() end); flight[k] = nil end
    end
    flight.weld = nil; flight.computePivotInHrp = nil
    if char then
        local J = getBodyJoints(char)
        for _, j in pairs(J) do resetJoint(j) end
    end
    if hum and hum.Parent then
        hum.PlatformStand = false
        hum.AutoRotate = true
        if hum.Health > 0 then pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
    end
    if hrp and hrp.Parent then
        local lv = hrp.CFrame.LookVector
        local flat = Vector3.new(lv.X, 0, lv.Z)
        if flat.Magnitude < 0.01 then flat = Vector3.new(0,0,-1) end
        hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat.Unit)
        hrp.AssemblyAngularVelocity = Vector3.zero
        if explodePos then
            local away = hrp.Position - explodePos
            if away.Magnitude < 0.1 then away = -flat end
            hrp.AssemblyLinearVelocity = away.Unit*26 + Vector3.new(0, 16, 0)
        end
    end
    flight.vel = Vector3.zero
    lastMoveStateAnim = nil
    if not silent then notify("Полёт", "ВЫКЛ [Q] · БАБАХ!") end
end
getgenv().hardStopFlight = function() stopFlight(true) end

local function startFlight()
    if flight.active then return end
    if getgenv().ShatterActive then return end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return end
    if hum.SeatPart then hum.Sit = false end
    pcall(function() hum:UnequipTools() end)
    emoteToken = emoteToken + 1; emoteActive = false

    local model, meta = buildFlyModel(hrp)
    if not model then notify("Полёт", "Модель не загрузилась"); return end
    flight.model = model
    if meta then flight.weld = meta.weld; flight.computePivotInHrp = meta.computePivotInHrp end

    local att = Instance.new("Attachment"); att.Name = "MonoFlyAtt"; att.Parent = hrp
    local lv = Instance.new("LinearVelocity")
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Parent = hrp
    local ao = Instance.new("AlignOrientation")
    ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
    ao.Attachment0 = att
    ao.RigidityEnabled = false
    ao.MaxTorque = math.huge
    ao.MaxAngularVelocity = math.huge
    ao.Responsiveness = 50
    local lk0 = hrp.CFrame.LookVector
    local f0 = Vector3.new(lk0.X, 0, lk0.Z)
    if f0.Magnitude < 0.01 then f0 = Vector3.new(0,0,-1) end
    ao.CFrame = CFrame.lookAt(Vector3.zero, f0.Unit)
    ao.Parent = hrp
    flight.att, flight.lv, flight.ao = att, lv, ao

    hum.PlatformStand = true
    hum.AutoRotate = false
    flight.vel = Vector3.zero
    flight.t0 = os.clock()
    flight.active = true
    lastMoveStateAnim = nil
    notify("Полёт", "ВКЛ · WASD · Space/Ctrl · Shift · [Q] выкл (взрыв)")

    flight.conn = RunService.Heartbeat:Connect(function(dt)
        if not flight.active then return end
        local ch = p.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not ch or not h or not root or not root.Parent or h.Health <= 0
            or not flight.model or not flight.model.Parent or not flight.lv or not flight.lv.Parent then
            stopFlight(true); return
        end
        if flight.weld and flight.weld.Parent and flight.computePivotInHrp then
            flight.weld.C0 = flight.computePivotInHrp()
        end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local look = cam.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude < 0.01 then
            local rl = root.CFrame.LookVector
            flat = Vector3.new(rl.X, 0, rl.Z)
            if flat.Magnitude < 0.01 then flat = Vector3.new(0,0,-1) end
        end
        flat = flat.Unit
        local right = flat:Cross(Vector3.new(0,1,0))
        local f, s, v = 0, 0, 0
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then f = f + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then f = f - 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then s = s + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then s = s - 1 end
        if f == 0 and s == 0 then
            local md = h.MoveDirection
            if md.Magnitude > 0.1 then f = md:Dot(flat); s = md:Dot(right) end
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v = v + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then v = v - 1 end
        local dir = look*f + right*s + Vector3.new(0, v, 0)
        if dir.Magnitude > 1 then dir = dir.Unit end
        local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and M.FLY.FAST or M.FLY.SPEED
        local vertOnly = Vector3.new(0, v*M.FLY.VERT, 0)
        local target = Vector3.new(dir.X*speed, 0, dir.Z*speed) + Vector3.new(0, dir.Y*speed, 0)
        if f == 0 and s == 0 then target = vertOnly end
        flight.vel = flight.vel:Lerp(target, math.clamp(dt*6, 0, 1))
        flight.lv.VectorVelocity = flight.vel
        if flight.ao and flight.ao.Parent then
            flight.ao.CFrame = CFrame.lookAt(Vector3.zero, flat)
        end
    end)
    track(flight.conn)
end

local function toggleFlight()
    if flight.active then stopFlight(false) else startFlight() end
end
getgenv().toggleFlight = toggleFlight

-- =====================================================================
-- ★ КИНО-БОМБА v21 (без зума и без текста на экране)
-- =====================================================================
do
    local NSK = NumberSequenceKeypoint.new
    local CSK = ColorSequenceKeypoint.new

    local BOMB = {
        id = "rbxassetid://81798377551721",
        scale = 1.6,
        throwSpeed = 24,
        upBoost = 7,
        fuse = 3,
        dropFuse = 4.2,
        portalHeight = 34,
        rollDamping = 0.55,
        maxRollSpeed = 20,
        blastRadius = 38,
        shatterRadius = 30,
    }
    getgenv().BombConfig = BOMB
    if getgenv().BombCine == nil then getgenv().BombCine = true end

    local GREEN   = Color3.fromRGB(90, 255, 130)
    local GREEN_L = Color3.fromRGB(190, 255, 210)
    local GREEN_D = Color3.fromRGB(8, 60, 28)
    local PURPLE   = Color3.fromRGB(165, 50, 255)
    local PURPLE_L = Color3.fromRGB(215, 150, 255)
    local PURPLE_D = Color3.fromRGB(85, 15, 150)
    local WHITE    = Color3.fromRGB(250, 235, 255)
    local SMOKE_TEX = "rbxasset://textures/particles/smoke_main.dds"

    local busy = false

    local ease = {
        out = function(x) x = math.clamp(x, 0, 1); return 1 - (1 - x)^3 end,
        inOut = function(x)
            x = math.clamp(x, 0, 1)
            if x < 0.5 then return 4*x*x*x end
            return 1 - ((-2*x + 2)^3)/2
        end,
        back = function(x)
            x = math.clamp(x, 0, 1)
            local c1 = 1.70158; local c3 = c1 + 1
            return 1 + c3*(x-1)^3 + c1*(x-1)^2
        end,
    }

    -- КАМЕРА
    local CINE = {
        active = false, skip = false,
        cf = CFrame.new(), fov = 70,
        shakeAmp = 0, shakeT0 = 0, shakeDur = 0,
        punchAmt = 0, punchT0 = 0, punchDur = 0.4,
        saved = nil,
    }

    function CINE.shake(amp, dur)
        CINE.shakeAmp = amp; CINE.shakeT0 = os.clock(); CINE.shakeDur = dur
    end
    function CINE.punch(amt, dur)
        CINE.punchAmt = amt; CINE.punchT0 = os.clock(); CINE.punchDur = dur or 0.4
    end

    function CINE.begin()
        if CINE.active then return false end
        local cam = workspace.CurrentCamera
        if not cam then return false end
        CINE.saved = {type = cam.CameraType, cf = cam.CFrame, fov = cam.FieldOfView}
        CINE.cf = cam.CFrame; CINE.fov = cam.FieldOfView
        CINE.shakeDur = 0; CINE.punchAmt = 0
        CINE.skip = false
        CINE.active = true
        cam.CameraType = Enum.CameraType.Scriptable
        pcall(function() RunService:UnbindFromRenderStep("MonoCine") end)
        RunService:BindToRenderStep("MonoCine", Enum.RenderPriority.Camera.Value + 2, function()
            local c = workspace.CurrentCamera
            if not c or not CINE.active then return end
            c.CameraType = Enum.CameraType.Scriptable
            local sh = CFrame.new()
            local el = os.clock() - CINE.shakeT0
            if el < CINE.shakeDur then
                local k = ((1 - el/CINE.shakeDur)^2) * CINE.shakeAmp
                sh = CFrame.new((math.random()-0.5)*k*0.12, (math.random()-0.5)*k*0.12, 0)
                    * CFrame.Angles((math.random()-0.5)*k*0.006, (math.random()-0.5)*k*0.006, (math.random()-0.5)*k*0.01)
            end
            c.CFrame = CINE.cf * sh
            -- FOV зафиксирован: без зума
            c.FieldOfView = CINE.saved and CINE.saved.fov or 70
        end)
        return true
    end

    function CINE.finish()
        if not CINE.active then return end
        CINE.active = false
        pcall(function() RunService:UnbindFromRenderStep("MonoCine") end)
        local cam = workspace.CurrentCamera
        if cam then
            cam.CameraType = Enum.CameraType.Custom
            if CINE.saved then cam.FieldOfView = CINE.saved.fov end
            local ch = p.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end
    end

    function CINE.tween(toCF, toFov, dur, fn)
        fn = fn or ease.inOut
        local fromCF = CINE.cf
        local t0 = os.clock()
        while CINE.active do
            local d = CINE.skip and 0.2 or dur
            local u = (os.clock() - t0)/d
            if u >= 1 then break end
            local e = fn(u)
            CINE.cf = fromCF:Lerp(toCF, e)
            -- FOV игнорируется (без зума)
            RunService.RenderStepped:Wait()
        end
        if CINE.active then CINE.cf = toCF end
    end

    function CINE.run(dur, fn)
        local t0 = os.clock()
        local dt = 1/60
        while CINE.active and not CINE.skip do
            local u = (os.clock() - t0)/dur
            if u >= 1 then fn(1, dt); break end
            fn(u, dt)
            dt = RunService.RenderStepped:Wait()
        end
    end

    -- ОВЕРЛЕЙ (текст отключён)
    local function makeOverlay()
        local noop = function() end
        local stub = {bars = noop, lines = noop, text = noop, flash = noop, destroy = noop}
        local pg = p:FindFirstChild("PlayerGui")
        if not pg then return stub end
        local old = pg:FindFirstChild("MonoCineGui"); if old then old:Destroy() end
        local g = Instance.new("ScreenGui")
        g.Name = "MonoCineGui"; g.IgnoreGuiInset = true; g.ResetOnSpawn = false
        g.DisplayOrder = 900; g.Parent = pg

        local function bar(top)
            local f = Instance.new("Frame")
            f.BackgroundColor3 = Color3.new(0,0,0); f.BorderSizePixel = 0
            f.AnchorPoint = Vector2.new(0, top and 0 or 1)
            f.Position = UDim2.fromScale(0, top and 0 or 1)
            f.Size = UDim2.fromScale(1, 0); f.ZIndex = 10; f.Parent = g
            return f
        end
        local ov = {gui = g, top = bar(true), bot = bar(false)}

        function ov.bars(on, dur)
            local sz = UDim2.fromScale(1, on and 0.12 or 0)
            local ti = TweenInfo.new(dur or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(ov.top, ti, {Size = sz}):Play()
            TweenService:Create(ov.bot, ti, {Size = sz}):Play()
        end

        function ov.flash(color, alpha, dur)
            local f = Instance.new("Frame")
            f.Size = UDim2.fromScale(1,1); f.BorderSizePixel = 0
            f.BackgroundColor3 = color or Color3.new(1,1,1)
            f.BackgroundTransparency = 1 - (alpha or 0.8); f.ZIndex = 30; f.Parent = g
            TweenService:Create(f, TweenInfo.new(dur or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 1}):Play()
            task.delay((dur or 0.4) + 0.1, function() if f then f:Destroy() end end)
        end

        -- заглушка: никакого текста на экране
        function ov.text() end

        function ov.lines(dur, color)
            local N = 30
            local fr = {}
            for i = 1, N do
                local f = Instance.new("Frame")
                f.AnchorPoint = Vector2.new(0.5, 0.5); f.BorderSizePixel = 0
                f.BackgroundColor3 = color or Color3.new(1,1,1); f.ZIndex = 5; f.Parent = g
                fr[i] = {f = f, a = (i/N)*math.pi*2 + math.random()*0.1,
                    r0 = 0.28 + math.random()*0.14, len = 0.18 + math.random()*0.28}
            end
            task.spawn(function()
                local t0 = os.clock()
                while true do
                    local u = (os.clock() - t0)/dur
                    if u >= 1 or not g.Parent then break end
                    local vs = g.AbsoluteSize
                    local m = math.max(vs.X, vs.Y)
                    for _, l in ipairs(fr) do
                        local r = (l.r0 + u*0.35) * (0.85 + math.random()*0.3) * m
                        local len = l.len * m * (1 - u*0.5)
                        l.f.Position = UDim2.fromOffset(vs.X/2 + math.cos(l.a)*r, vs.Y/2 + math.sin(l.a)*r)
                        l.f.Size = UDim2.fromOffset(len, 2 + math.random()*3)
                        l.f.Rotation = math.deg(l.a)
                        l.f.BackgroundTransparency = 0.15 + u*0.85
                    end
                    RunService.RenderStepped:Wait()
                end
                for _, l in ipairs(fr) do if l.f then l.f:Destroy() end end
            end)
        end

        function ov.destroy() if g then g:Destroy() end end
        return ov
    end

    -- ПОСТ-ЭФФЕКТЫ
    local function impactFrame(k)
        pcall(function()
            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "MonoImpactCC"
            cc.Saturation = -1; cc.Contrast = 1.4*k; cc.Brightness = 0.18*k
            cc.Parent = Lighting
            task.delay(0.1, function()
                if not cc.Parent then return end
                TweenService:Create(cc, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Saturation = 0, Contrast = 0, Brightness = 0}):Play()
                task.delay(0.45, function() if cc then cc:Destroy() end end)
            end)
        end)
    end

    local function postFx(k)
        pcall(function()
            local bl = Instance.new("BloomEffect")
            bl.Intensity = 2.4*k; bl.Size = 42; bl.Threshold = 0.7; bl.Parent = Lighting
            TweenService:Create(bl, TweenInfo.new(2.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Intensity = 0}):Play()
            task.delay(2.6, function() if bl then bl:Destroy() end end)

            local sr = Instance.new("SunRaysEffect")
            sr.Intensity = 0.5*k; sr.Spread = 1; sr.Parent = Lighting
            TweenService:Create(sr, TweenInfo.new(2.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Intensity = 0}):Play()
            task.delay(2.2, function() if sr then sr:Destroy() end end)

            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "MonoBombCC"
            cc.TintColor = Color3.fromRGB(215, 160, 255)
            cc.Brightness = 0.35*k; cc.Contrast = 0.2*k; cc.Saturation = 0.2*k
            cc.Parent = Lighting
            TweenService:Create(cc, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Brightness = 0, Contrast = 0, Saturation = 0, TintColor = Color3.new(1,1,1)}):Play()
            task.delay(1.8, function() if cc then cc:Destroy() end end)

            local pg = p:FindFirstChild("PlayerGui")
            if pg and k > 0.2 then
                local g = Instance.new("ScreenGui")
                g.IgnoreGuiInset = true; g.ResetOnSpawn = false; g.DisplayOrder = 999; g.Parent = pg
                local f = Instance.new("Frame")
                f.Size = UDim2.fromScale(1,1); f.BorderSizePixel = 0
                f.BackgroundColor3 = Color3.fromRGB(240, 215, 255)
                f.BackgroundTransparency = 1 - 0.9*k; f.Parent = g
                task.delay(0.1, function()
                    TweenService:Create(f, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundTransparency = 1}):Play()
                end)
                task.delay(1.3, function() if g then g:Destroy() end end)
            end
        end)
    end

    -- ЧАСТИЦЫ
    local function mkEmitter(parent, o)
        local e = Instance.new("ParticleEmitter")
        e.Rate = 0
        e.Lifetime = NumberRange.new(o.life[1], o.life[2])
        e.Speed = NumberRange.new(o.speed[1], o.speed[2])
        e.SpreadAngle = o.spread or Vector2.new(180, 180)
        e.Drag = o.drag or 0
        e.Acceleration = o.acc or Vector3.zero
        e.LightEmission = o.emit or 0
        e.LightInfluence = o.inf or 0
        e.Rotation = NumberRange.new(0, 360)
        local rs = o.rot or 0
        e.RotSpeed = NumberRange.new(-rs, rs)
        if o.tex then e.Texture = o.tex end
        e.Color = o.color
        e.Size = o.size
        e.Transparency = o.trans
        if o.vp then pcall(function() e.Orientation = Enum.ParticleOrientation.VelocityParallel end) end
        e.Parent = parent
        return e
    end

    -- КАМНИ
    local ROCKS = {
        Enum.Material.Slate, Enum.Material.Basalt, Enum.Material.Granite,
        Enum.Material.Concrete, Enum.Material.Rock, Enum.Material.Cobblestone,
    }

    local function dustPuff(pos, size)
        local a = FXH.anchorAt(pos, 3)
        local e = mkEmitter(a, {
            life = {0.8, 1.6}, speed = {2, 8}, drag = 2, acc = Vector3.new(0, 1.5, 0),
            tex = SMOKE_TEX, inf = 1,
            color = ColorSequence.new(Color3.fromRGB(150, 145, 138)),
            size = NumberSequence.new({NSK(0, size), NSK(1, size*3.2)}),
            trans = NumberSequence.new({NSK(0, 0.55), NSK(1, 1)}),
            rot = 40,
        })
        e:Emit(5)
    end

    function FXH.spawnBoulders(hit, o)
        o = o or {}
        local count = o.count or 60
        local power = o.power or 1
        local life = o.life or 4
        local sizeMul = o.sizeMul or 1
        local spread = o.spread or 1
        local gp = hit.Position
        local gcol = Color3.fromRGB(125, 122, 118)
        local inst = hit.Instance
        if inst and inst:IsA("BasePart") then gcol = gcol:Lerp(inst.Color, 0.5) end
        if o.greyer then
            local gr = (gcol.R + gcol.G + gcol.B)/3
            gcol = Color3.new(gr, gr, gr):Lerp(Color3.fromRGB(165, 162, 158), 0.5)
        end
        local fx = getFxFolder()
        for _ = 1, count do
            local big = math.random() < 0.18
            local sz = (big and (1.6 + math.random()*2.2) or (0.5 + math.random()*1.1)) * sizeMul
            local kind = math.random(1, 4)
            local part
            if kind == 1 then part = Instance.new("WedgePart")
            elseif kind == 2 then part = Instance.new("CornerWedgePart")
            else part = Instance.new("Part") end
            part.Name = "MonoRock"
            part.Anchored = true; part.CanCollide = false; part.CanTouch = false; part.CanQuery = false
            part.CastShadow = big
            part.Material = ROCKS[math.random(1, #ROCKS)]
            local shade = o.greyer and (1.0 + math.random()*0.35) or (0.7 + math.random()*0.55)
            local rockCol = Color3.new(
                math.clamp(gcol.R*shade, 0, 1), math.clamp(gcol.G*shade, 0, 1), math.clamp(gcol.B*shade, 0, 1))
            part.Color = rockCol
            part.Size = Vector3.new(sz*(0.7 + math.random()*0.8), sz*(0.5 + math.random()*0.7), sz*(0.7 + math.random()*0.8))
            if kind == 4 then
                local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = part
            end
            part.CFrame = CFrame.new(gp + Vector3.new(
                    (math.random()-0.5)*4*spread, 0.8 + math.random()*1.0, (math.random()-0.5)*4*spread))
                * CFrame.Angles(math.random()*6.283, math.random()*6.283, math.random()*6.283)
            part.Parent = fx

            local hot = math.random() < 0.35
            if hot then
                part.Material = Enum.Material.Neon
                part.Color = (math.random() < 0.5) and PURPLE_L or Color3.fromRGB(255, 190, 120)
                TweenService:Create(part, TweenInfo.new(1.3, Enum.EasingStyle.Quad), {Color = rockCol}):Play()
                task.delay(1.3, function()
                    if part and part.Parent then part.Material = ROCKS[math.random(1, #ROCKS)] end
                end)
                FXH.trail(part, 1.3, Color3.fromRGB(70, 55, 85), math.clamp(sz*0.8, 0.5, 2))
            end

            local ang = math.random()*math.pi*2
            local h = (10 + math.random()*45) * power * (big and 0.6 or 1)
            local up = (30 + math.random()*55) * power * (big and 0.8 or 1)
            local vel = Vector3.new(math.cos(ang)*h, up, math.sin(ang)*h)
            local spin = Vector3.new((math.random()-0.5)*18, (math.random()-0.5)*18, (math.random()-0.5)*18)
            local rad = math.max(part.Size.X, part.Size.Y, part.Size.Z)*0.38
            local onImpact = nil
            if big then onImpact = function(_, h2) dustPuff(h2.Position, 2) end end
            FXH.addBody(part, vel, spin, rad, life + math.random()*0.8, onImpact)
            if big and not hot then FXH.trail(part, 1.2, Color3.fromRGB(95, 90, 84), sz*0.7) end
        end
    end

    -- ВЗРЫВ
    local bombSrcCache = nil
    local function getBombSrc()
        if bombSrcCache ~= nil then return bombSrcCache end
        local ok, m = pcall(loadAssetModel, BOMB.id)
        bombSrcCache = (ok and m) or false
        return bombSrcCache
    end
    local function buildBombVisual()
        local src = getBombSrc()
        if not src then return nil, nil end
        local model = src:Clone()
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
                or d:IsA("JointInstance") or d:IsA("WeldConstraint") then
                d:Destroy()
            end
        end
        local parts = {}
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") then table.insert(parts, d) end
        end
        if #parts == 0 then model:Destroy(); return nil, nil end
        for _, pt in ipairs(parts) do
            pt.Anchored = false; pt.CanCollide = false; pt.CanTouch = false
            pt.CanQuery = false; pt.Massless = true
        end
        pcall(function() model:ScaleTo(BOMB.scale) end)
        return model, parts
    end

    local function bombExplosion(pos)
        local fx = getFxFolder()
        local R = BOMB.blastRadius
        local cam = workspace.CurrentCamera
        local dist = cam and (cam.CFrame.Position - pos).Magnitude or 9999
        local k = CINE.active and 1 or math.clamp(1 - dist/(R*5), 0, 1)

        FXH.sound(pos, M.SND.EXPLOSION, 6, 2000)
        FXH.light(pos, WHITE, 60, 140, 0.3)
        FXH.light(pos + Vector3.new(0, 8, 0), PURPLE, 35, 190, 2.2)

        if k > 0.05 then impactFrame(k); postFx(k) end
        -- без CINE.punch: FOV не пульсирует
        if CINE.active then CINE.shake(18, 2.0)
        else FXH.shake(pos, 2.4, 1.2, 320) end

        FXH.shell(pos, WHITE, Enum.Material.Neon, 4, R*0.9, 0.25, 0)
        FXH.shell(pos, PURPLE, Enum.Material.Neon, 6, R*2.1, 0.8, 0.1)
        FXH.shell(pos, PURPLE_L, Enum.Material.Neon, 4, R*1.4, 0.55, 0.3)
        FXH.shell(pos, PURPLE, Enum.Material.ForceField, 8, R*2.7, 1.2, 0.35)
        task.delay(0.08, function() FXH.shell(pos, WHITE, Enum.Material.Neon, 6, R*1.1, 0.35, 0.2) end)

        local pillar = Instance.new("Part")
        pillar.Shape = Enum.PartType.Cylinder
        pillar.Anchored = true; pillar.CanCollide = false; pillar.CanTouch = false; pillar.CanQuery = false
        pillar.CastShadow = false; pillar.Material = Enum.Material.Neon; pillar.Color = PURPLE_L
        pillar.Transparency = 0.1
        pillar.Size = Vector3.new(R*5, 10, 10)
        pillar.CFrame = CFrame.new(pos + Vector3.new(0, R*2.5, 0)) * CFrame.Angles(0, 0, math.pi/2)
        pillar.Parent = fx
        TweenService:Create(pillar, TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = Vector3.new(R*5, 0.5, 0.5), Transparency = 1}):Play()
        task.delay(1.4, function() if pillar then pillar:Destroy() end end)

        for i = 1, 22 do
            local dir = randUnit()
            local ray = Instance.new("Part")
            ray.Anchored = true; ray.CanCollide = false; ray.CanTouch = false; ray.CanQuery = false
            ray.CastShadow = false; ray.Material = Enum.Material.Neon
            ray.Color = (i % 2 == 0) and PURPLE_L or WHITE
            ray.Size = Vector3.new(0.7, 0.7, 2)
            ray.CFrame = lookCF(pos, pos + dir)
            ray.Parent = fx
            local len = R*(1.6 + math.random()*1.4)
            local d = 0.5 + math.random()*0.35
            TweenService:Create(ray, TweenInfo.new(d, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = Vector3.new(0.2, 0.2, len*2), Transparency = 1}):Play()
            task.delay(d + 0.1, function() if ray then ray:Destroy() end end)
        end

        local gh = FXH.groundHit(pos, 28)
        local ringC = gh and (gh.Position + Vector3.new(0, 0.4, 0)) or pos
        FXH.ring(ringC, PURPLE_L, R*2.4, 1.0, 1.6, 52)
        task.delay(0.12, function() FXH.ring(ringC, PURPLE, R*1.8, 0.85, 1.1, 44) end)
        task.delay(0.30, function() FXH.ring(ringC, WHITE, R*1.3, 0.7, 0.7, 36) end)

        local la = FXH.anchorAt(pos, 9)

        local flashSprite = mkEmitter(la, {
            life = {0.18, 0.28}, speed = {0, 0}, emit = 1,
            color = ColorSequence.new(WHITE, PURPLE_L),
            size = NumberSequence.new({NSK(0, R*1.4), NSK(1, R*2.6)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(1, 1)}),
        })
        local sparks = mkEmitter(la, {
            life = {0.9, 2.2}, speed = {60, 190}, drag = 0.4, acc = Vector3.new(0, -50, 0), emit = 1, vp = true,
            color = ColorSequence.new(PURPLE_L, PURPLE_D),
            size = NumberSequence.new({NSK(0, 1.0), NSK(1, 0)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(1, 1)}),
        })
        local energy = mkEmitter(la, {
            life = {0.5, 1.2}, speed = {20, 85}, drag = 3, emit = 1, rot = 60,
            color = ColorSequence.new({CSK(0, WHITE), CSK(0.4, PURPLE), CSK(1, PURPLE_D)}),
            size = NumberSequence.new({NSK(0, 6), NSK(0.4, 15), NSK(1, 2)}),
            trans = NumberSequence.new({NSK(0, 0.1), NSK(0.6, 0.5), NSK(1, 1)}),
        })
        local smoke = mkEmitter(la, {
            life = {3, 5.5}, speed = {8, 38}, drag = 2, acc = Vector3.new(0, 6, 0), inf = 0.5, rot = 25,
            tex = SMOKE_TEX,
            color = ColorSequence.new(Color3.fromRGB(105, 60, 145), Color3.fromRGB(30, 18, 45)),
            size = NumberSequence.new({NSK(0, 10), NSK(1, 36)}),
            trans = NumberSequence.new({NSK(0, 0.3), NSK(0.5, 0.6), NSK(1, 1)}),
        })
        local embers = mkEmitter(la, {
            life = {3, 6}, speed = {6, 30}, drag = 1, acc = Vector3.new(0, 9, 0), emit = 1,
            color = ColorSequence.new(PURPLE_L, PURPLE),
            size = NumberSequence.new({NSK(0, 0.45), NSK(1, 0)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(0.8, 0.3), NSK(1, 1)}),
        })
        pcall(function()
            flashSprite:Emit(3)
            sparks:Emit(170)
            energy:Emit(85)
            smoke:Emit(70)
            embers:Emit(70)
        end)

        local stem = FXH.anchorAt(pos, 6)
        local stemE = mkEmitter(stem, {
            life = {1.8, 3}, speed = {2, 10}, spread = Vector2.new(35, 35), drag = 1.5, rot = 20,
            inf = 0.4, emit = 0.3, tex = SMOKE_TEX,
            color = ColorSequence.new(Color3.fromRGB(150, 70, 215), Color3.fromRGB(50, 22, 80)),
            size = NumberSequence.new({NSK(0, 9), NSK(1, 26)}),
            trans = NumberSequence.new({NSK(0, 0.2), NSK(0.6, 0.55), NSK(1, 1)}),
        })
        stemE.Rate = 170
        TweenService:Create(stem, TweenInfo.new(1.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            {Position = pos + Vector3.new(0, R*1.5, 0)}):Play()
        task.delay(1.7, function() if stemE then stemE.Enabled = false end end)

        task.delay(1.1, function()
            local topPos = pos + Vector3.new(0, R*1.35, 0)
            local cap = FXH.anchorAt(topPos, 7)
            local capE = mkEmitter(cap, {
                life = {2.5, 4}, speed = {22, 48}, drag = 2, acc = Vector3.new(0, -5, 0), rot = 20,
                inf = 0.4, emit = 0.3, tex = SMOKE_TEX,
                color = ColorSequence.new(Color3.fromRGB(160, 80, 225), Color3.fromRGB(45, 18, 75)),
                size = NumberSequence.new({NSK(0, 12), NSK(1, 40)}),
                trans = NumberSequence.new({NSK(0, 0.25), NSK(0.6, 0.6), NSK(1, 1)}),
            })
            pcall(function() capE:Emit(90) end)
            local disc = Instance.new("Part")
            disc.Shape = Enum.PartType.Ball; disc.Anchored = true
            disc.CanCollide = false; disc.CanTouch = false; disc.CanQuery = false; disc.CastShadow = false
            disc.Material = Enum.Material.Neon; disc.Color = PURPLE
            disc.Transparency = 0.45; disc.Size = Vector3.new(6, 3, 6)
            disc.Position = topPos; disc.Parent = fx
            TweenService:Create(disc, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = Vector3.new(R*1.7, R*0.45, R*1.7), Transparency = 1}):Play()
            task.delay(1.7, function() if disc then disc:Destroy() end end)
        end)

        if gh then
            local scorch = Instance.new("Part")
            scorch.Shape = Enum.PartType.Cylinder
            scorch.Anchored = true; scorch.CanCollide = false; scorch.CanTouch = false; scorch.CanQuery = false
            scorch.CastShadow = false; scorch.Material = Enum.Material.Slate
            scorch.Color = Color3.fromRGB(22, 14, 30); scorch.Transparency = 0.25
            scorch.Size = Vector3.new(0.12, 2, 2)
            scorch.CFrame = CFrame.new(gh.Position + gh.Normal*0.08) * CFrame.Angles(0, 0, math.pi/2)
            scorch.Parent = fx
            TweenService:Create(scorch, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = Vector3.new(0.12, R*1.1, R*1.1)}):Play()
            task.delay(4.2, function()
                if scorch and scorch.Parent then
                    TweenService:Create(scorch, TweenInfo.new(1), {Transparency = 1}):Play()
                    task.delay(1.1, function() if scorch then scorch:Destroy() end end)
                end
            end)

            FXH.dust(gh, {count = 120, power = 2.3})
            FXH.spawnBoulders(gh, {count = 62, power = 1.7, sizeMul = 1.4, life = 4, spread = 2, greyer = true})
            FXH.spawnPebbles(gh, 18, 50, 4, {greyer = true})
        end

        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and (hrp.Position - pos).Magnitude < BOMB.shatterRadius then
            if getgenv().shatterBody then
                task.spawn(function() pcall(getgenv().shatterBody) end)
            end
        end
    end

    -- БРОСОК / ПАДЕНИЕ
    local function spawnThrownBomb(startPos, velocity, opts)
        opts = opts or {}
        local model, parts = buildBombVisual()
        if not model then return nil end

        local _, bbSize = model:GetBoundingBox()
        local diameter = math.clamp(math.max(bbSize.X, bbSize.Y, bbSize.Z), 1.5, 8)
        local radius = diameter/2

        local ball = Instance.new("Part")
        ball.Name = "MonoBombPhysics"
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(diameter, diameter, diameter)
        ball.Transparency = 1
        ball.CanCollide = true; ball.CanTouch = false; ball.CanQuery = false
        ball.Anchored = true
        ball.CustomPhysicalProperties = PhysicalProperties.new(2.5, 0.9, 0, 100, 100)
        ball.CFrame = CFrame.new(startPos)
        ball.Parent = workspace

        for _, pt in ipairs(parts) do pt.Anchored = true end
        model.Parent = workspace
        local bbCF = model:GetBoundingBox()
        model:PivotTo(CFrame.new(startPos) * bbCF:ToObjectSpace(model:GetPivot()))
        for _, pt in ipairs(parts) do
            local w = Instance.new("Weld")
            w.Part0 = ball; w.Part1 = pt
            w.C0 = ball.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
            w.Parent = ball
        end
        for _, pt in ipairs(parts) do
            pt.Anchored = false; pt.CanCollide = false; pt.Massless = true
        end

        local beep = Instance.new("Sound")
        beep.Name = "MonoBombBeep"; beep.SoundId = M.SND.BOMB_BEEP
        beep.Volume = 2.5; beep.RollOffMaxDistance = 140
        beep.RollOffMode = Enum.RollOffMode.InverseTapered
        beep.Parent = ball

        ball.Anchored = false
        ball.AssemblyLinearVelocity = velocity
        local h0 = Vector3.new(velocity.X, 0, velocity.Z)
        ball.AssemblyAngularVelocity = Vector3.new(0, 1, 0):Cross(h0)/radius

        local fuse = opts.fuse or BOMB.fuse
        local handle = {
            pos = startPos, t = 0, fuse = fuse, grounded = false,
            exploded = false, explodePos = nil,
            dir = (h0.Magnitude > 1) and h0.Unit or nil,
        }

        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = {ball, model, getFxFolder()}
        rp.IgnoreWater = true

        local t0 = os.clock()
        local done = false
        local beepT = 0.5
        local hb
        hb = RunService.Heartbeat:Connect(function(dt)
            if done then return end
            if not ball.Parent then
                done = true; hb:Disconnect()
                if model then model:Destroy() end
                handle.exploded = true; handle.dead = true; handle.explodePos = handle.pos
                return
            end
            local t = os.clock() - t0
            handle.t = t
            handle.pos = ball.Position

            local v = ball.AssemblyLinearVelocity
            local ch = p.Character
            if ch then rp.FilterDescendantsInstances = {ball, model, getFxFolder(), ch} end
            local grounded = workspace:Raycast(ball.Position, Vector3.new(0, -(radius + 0.6), 0), rp) ~= nil
            handle.grounded = grounded
            if grounded then
                local h = Vector3.new(v.X, 0, v.Z)
                h = h*math.max(0, 1 - BOMB.rollDamping*dt)
                if h.Magnitude > BOMB.maxRollSpeed then h = h.Unit*BOMB.maxRollSpeed end
                ball.AssemblyLinearVelocity = Vector3.new(h.X, v.Y, h.Z)
                ball.AssemblyAngularVelocity = Vector3.new(0, 1, 0):Cross(h)/radius
            end

            beepT = beepT - dt
            if beepT <= 0 and t < fuse then
                pcall(function() beep.TimePosition = 0; beep:Play() end)
                local freq = math.clamp(t/fuse, 0, 1)
                beepT = math.max(0.1, 0.55 - 0.45*freq*freq)
            end

            if t >= fuse or ball.Position.Y < -500 then
                done = true; hb:Disconnect()
                local ep = ball.Position
                ball:Destroy()
                if model then model:Destroy() end
                handle.exploded = true
                handle.explodePos = ep
                pcall(bombExplosion, ep)
            end
        end)
        return handle
    end

    -- АНИМЕ-ПОРТАЛ
    local function animePortal(center, radius, groundY)
        local fx = getFxFolder()
        local P = {mode = "hidden", t0 = os.clock(), spin = 0, alive = true}
        local all = {}

        local function cyl(color, mat, tr)
            local c = Instance.new("Part")
            c.Shape = Enum.PartType.Cylinder
            c.Anchored = true; c.CanCollide = false; c.CanTouch = false; c.CanQuery = false; c.CastShadow = false
            c.Material = mat; c.Color = color; c.Transparency = tr
            c.Size = Vector3.new(0.1, 0.1, 0.1); c.CFrame = CFrame.new(center)
            c.Parent = fx
            table.insert(all, c)
            return c
        end

        local rim   = cyl(GREEN, Enum.Material.Neon, 0.05)
        local core  = cyl(GREEN_D, Enum.Material.SmoothPlastic, 0)
        local swirl = cyl(GREEN_L, Enum.Material.Neon, 0.5)
        local beamH = math.max(center.Y - (groundY or (center.Y - 30)), 4)
        local beam  = cyl(GREEN, Enum.Material.Neon, 0.88)

        local rings = {}
        for i = 1, 3 do
            local n = 18 + i*4
            local blocks = {}
            for j = 1, n do
                local b = Instance.new("Part")
                b.Anchored = true; b.CanCollide = false; b.CanTouch = false; b.CanQuery = false; b.CastShadow = false
                b.Material = Enum.Material.Neon
                b.Color = (j % 2 == 0) and GREEN or GREEN_L
                b.Size = Vector3.new(0.1, 0.1, 0.1)
                b.Parent = fx
                blocks[j] = b
                table.insert(all, b)
            end
            rings[i] = {blocks = blocks, n = n, r = radius*(1.12 + 0.16*i),
                dir = (i % 2 == 0) and 1 or -1, spd = 0.8 + 0.5*i}
        end

        local em = FXH.anchorAt(center, nil)
        table.insert(all, em)
        em.Size = Vector3.new(radius*2, 0.2, radius*2)
        local light = Instance.new("PointLight")
        light.Color = GREEN; light.Range = 55; light.Brightness = 0; light.Shadows = false
        light.Parent = em
        local spark = mkEmitter(em, {
            life = {0.6, 1.3}, speed = {14, 32}, spread = Vector2.new(22, 22), acc = Vector3.new(0, -18, 0), emit = 1,
            color = ColorSequence.new(WHITE, GREEN),
            size = NumberSequence.new({NSK(0, 0.7), NSK(1, 0)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(1, 1)}),
        })
        spark.EmissionDirection = Enum.NormalId.Bottom
        pcall(function() spark.Shape = Enum.ParticleEmitterShape.Disc end)

        local base = CFrame.new(center) * CFrame.Angles(0, 0, math.pi/2)
        local function apply(s)
            s = math.max(s, 0.001)
            local d = radius*2*s
            rim.Size = Vector3.new(0.3, d*1.05, d*1.05); rim.CFrame = base
            core.Size = Vector3.new(0.2, d*0.9, d*0.9); core.CFrame = base * CFrame.new(-0.14, 0, 0)
            swirl.Size = Vector3.new(0.12, d*0.65, d*0.65); swirl.CFrame = base * CFrame.new(-0.26, 0, 0)
            beam.Size = Vector3.new(beamH, d*0.8, d*0.8)
            beam.CFrame = CFrame.new(center.X, center.Y - beamH/2, center.Z) * CFrame.Angles(0, 0, math.pi/2)
            for _, rg in ipairs(rings) do
                local r = rg.r*s
                local segLen = math.max((2*math.pi*r/rg.n)*0.6, 0.05)
                for j, b in ipairs(rg.blocks) do
                    local a = (j/rg.n)*math.pi*2 + P.spin*rg.dir*rg.spd
                    local pos = center + Vector3.new(math.cos(a)*r, math.sin(a*3 + P.spin*4)*0.35*s, math.sin(a)*r)
                    local tan = Vector3.new(-math.sin(a), 0, math.cos(a))
                    b.Size = Vector3.new(0.35*s + 0.01, 0.35*s + 0.01, segLen)
                    b.CFrame = CFrame.lookAt(pos, pos + tan)
                end
            end
        end

        function P.destroy()
            if not P.alive then return end
            P.alive = false
            if P.conn then P.conn:Disconnect() end
            for _, o in ipairs(all) do if o then o:Destroy() end end
        end
        function P.open()
            P.mode = "open"; P.t0 = os.clock()
            spark.Rate = 140
            TweenService:Create(light, TweenInfo.new(0.4), {Brightness = 5}):Play()
            FXH.sound(center, M.SND.SPAWN, 3, 500)
            FXH.ring(center, GREEN, radius*3, 0.55, 0.5, 40)
            pcall(function() spark:Emit(80) end)
        end
        function P.close()
            if P.mode == "close" or not P.alive then return end
            P.mode = "close"; P.t0 = os.clock()
            spark.Rate = 0
            TweenService:Create(light, TweenInfo.new(0.35), {Brightness = 0}):Play()
            FXH.sound(center, M.SND.ENTER, 2.5, 500)
            FXH.ring(center, GREEN_L, radius*2.2, 0.4, 0.4, 32)
        end

        apply(0)
        P.conn = RunService.RenderStepped:Connect(function(dt)
            if not P.alive then return end
            P.spin = P.spin + dt
            local el = os.clock() - P.t0
            local s = 0
            if P.mode == "open" then
                s = ease.back(el/0.45)
                if el >= 0.45 then P.mode = "idle" end
            elseif P.mode == "idle" then
                s = 1 + math.sin(P.spin*6)*0.02
            elseif P.mode == "close" then
                local u = el/0.4
                if u >= 1 then P.destroy(); return end
                s = 1 - ease.inOut(u)
            end
            apply(s)
        end)
        return P
    end

    -- ФАЗЫ КАМЕРЫ
    local function cineBombPhases(handle, ov, opts)
        opts = opts or {}
        local fl = CINE.cf.LookVector
        local flat = Vector3.new(fl.X, 0, fl.Z)
        local dir = opts.dir or handle.dir or ((flat.Magnitude > 0.01) and flat.Unit or Vector3.new(0, 0, -1))
        local rightV = dir:Cross(Vector3.new(0, 1, 0))
        local cur = CINE.cf

        local t0 = os.clock()
        while CINE.active and not CINE.skip and not handle.exploded do
            local dt = RunService.RenderStepped:Wait()
            local bp = handle.pos
            local desired = CFrame.lookAt(bp - dir*17 + rightV*6 + Vector3.new(0, 7, 0), bp)
            cur = cur:Lerp(desired, 1 - math.exp(-5*dt)); CINE.cf = cur
            -- без FOV-зума
            if opts.onTick then opts.onTick(bp) end
            local el = os.clock() - t0
            if (handle.grounded and el > 0.4) or el > 4 then break end
        end

        local ang = math.atan2(cur.Position.Z - handle.pos.Z, cur.Position.X - handle.pos.X)
        local lastShown = -1
        while CINE.active and not CINE.skip and not handle.exploded do
            local dt = RunService.RenderStepped:Wait()
            local rem = handle.fuse - handle.t
            local prog = math.clamp(handle.t/handle.fuse, 0, 1)
            ang = ang + dt*(0.7 + prog*1.4)
            local r = 16  -- радиус постоянный, без приближения
            local bp = handle.pos
            local desired = CFrame.lookAt(
                bp + Vector3.new(math.cos(ang)*r, 3.5 + 2*(1 - prog), math.sin(ang)*r),
                bp + Vector3.new(0, 1, 0))
            cur = cur:Lerp(desired, 1 - math.exp(-8*dt)); CINE.cf = cur
            -- без FOV-зума
            local n = math.ceil(rem)
            if n >= 1 and n <= 3 and n ~= lastShown then
                lastShown = n
                -- без текста: только shake
                CINE.shake(1.2 + (4 - n), 0.25)
            end
            if rem < 0.45 then CINE.shake(2.5, 0.1) end
        end

        if CINE.active then
            local ep = handle.explodePos or handle.pos
            -- без текста "БАБАХ!"
            if not CINE.skip then task.wait(0.12) end
            local startPos = CINE.cf.Position
            local baseAng = math.atan2(startPos.Z - ep.Z, startPos.X - ep.X)
            local c2 = CINE.cf
            CINE.run(4.6, function(u, dt)
                local e = ease.out(u)
                local r = 24 + 70*e
                local a = baseAng + u*0.9
                local h = 6 + 38*e
                local look = ep + Vector3.new(0, 4 + 46*e, 0)
                local desired = CFrame.lookAt(ep + Vector3.new(math.cos(a)*r, h, math.sin(a)*r), look)
                c2 = c2:Lerp(desired, 1 - math.exp(-4*dt)); CINE.cf = c2
                -- без FOV-зума
            end)
        end

        if CINE.active and CINE.saved then
            CINE.tween(CINE.saved.cf, CINE.saved.fov, 1.2, ease.inOut)
        end
    end

    local function endCinematic(ov)
        pcall(function() ov.bars(false, 0.4) end)
        task.wait(0.4)
        pcall(function() ov.destroy() end)
        CINE.finish()
    end

    local function runPortalSequence(target)
        if CINE.active or busy then return end
        busy = true
        local ov = makeOverlay()
        CINE.begin()
        local portal
        local ok, err = pcall(function()
            local H = BOMB.portalHeight
            local portalPos = target + Vector3.new(0, H, 0)
            local camPos = CINE.cf.Position
            local back = Vector3.new(camPos.X - target.X, 0, camPos.Z - target.Z)
            if back.Magnitude < 5 then back = Vector3.new(0, 0, 1) end
            back = back.Unit
            local right = back:Cross(Vector3.new(0, 1, 0))

            ov.bars(true, 0.4)
            ov.lines(0.7, Color3.new(1, 1, 1))
            local shot1 = CFrame.lookAt(
                target + back*58 + right*14 + Vector3.new(0, H*0.5, 0),
                target + Vector3.new(0, H*0.62, 0))
            CINE.tween(shot1, CINE.fov, 0.95, ease.inOut) -- FOV не меняется

            portal = animePortal(portalPos, 9, target.Y)
            portal.open()
            ov.flash(GREEN_L, 0.55, 0.35)
            CINE.shake(5, 0.5)
            -- долли-ин удалён: камера не приближается

            local handle = spawnThrownBomb(portalPos - Vector3.new(0, 4, 0), Vector3.new(0, -26, 0),
                {fuse = BOMB.dropFuse})
            if not handle then error("модель бомбы не загрузилась") end

            local closed = false
            cineBombPhases(handle, ov, {
                dir = -back,
                onTick = function(bp)
                    if not closed and bp.Y < portalPos.Y - 10 then
                        closed = true; portal.close()
                    end
                end,
            })
        end)
        if not ok then warn("[MONO] cine:", err) end
        if portal then portal.destroy() end
        endCinematic(ov)
        busy = false
    end

    local function runThrowCinematic(handle)
        if not handle or CINE.active or busy then return end
        busy = true
        local ov = makeOverlay()
        CINE.begin()
        local ok, err = pcall(function()
            ov.bars(true, 0.35)
            cineBombPhases(handle, ov, {})
        end)
        if not ok then warn("[MONO] cine:", err) end
        endCinematic(ov)
        busy = false
    end

    -- ВЫБОР ТОЧКИ
    local pick = {active = false}
    local stopPick
    stopPick = function()
        pick.active = false
        if pick.hb then pick.hb:Disconnect(); pick.hb = nil end
        if pick.click then pick.click:Disconnect(); pick.click = nil end
        if pick.marker then pick.marker:Destroy(); pick.marker = nil end
    end
    local function startPick()
        if pick.active then stopPick(); return end
        if CINE.active or busy then return end
        pick.active = true
        notify("Бомба", "Кликни по земле · Backspace — отмена")
        local marker = Instance.new("Part")
        marker.Shape = Enum.PartType.Cylinder
        marker.Anchored = true; marker.CanCollide = false; marker.CanTouch = false; marker.CanQuery = false
        marker.CastShadow = false; marker.Material = Enum.Material.Neon
        marker.Color = GREEN; marker.Transparency = 0.4
        marker.Size = Vector3.new(0.2, 8, 8)
        marker.Parent = getFxFolder()
        pick.marker = marker
        local lastHit = nil
        pick.hb = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            local mp = UserInputService:GetMouseLocation()
            local ray = cam:ViewportPointToRay(mp.X, mp.Y)
            local res = workspace:Raycast(ray.Origin, ray.Direction*2000, FXH.rayParams())
            if res and res.Normal.Y > 0.5 then
                lastHit = res
                marker.Transparency = 0.4
                marker.CFrame = CFrame.new(res.Position + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, math.pi/2)
                marker.Size = Vector3.new(0.2, 8 + math.sin(os.clock()*6)*0.8, 8 + math.sin(os.clock()*6)*0.8)
            else
                lastHit = nil
                marker.Transparency = 1
            end
        end)
        pick.click = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not lastHit then notify("Бомба", "Нужна ровная поверхность"); return end
            local target = lastHit.Position
            stopPick()
            task.spawn(runPortalSequence, target)
        end)
    end

    -- ИНСТРУМЕНТ
    local function giveBombTool()
        local toolName = "PurpleBomb"
        local bp = p:FindFirstChild("Backpack")
        if bp then
            for _, v in ipairs(bp:GetChildren()) do
                if v:IsA("Tool") and v.Name == toolName then v:Destroy() end
            end
        end
        if p.Character then
            for _, v in ipairs(p.Character:GetChildren()) do
                if v:IsA("Tool") and v.Name == toolName then v:Destroy() end
            end
        end

        local tool = Instance.new("Tool")
        tool.Name = toolName; tool.RequiresHandle = true; tool.CanBeDropped = false
        tool.ToolTip = "ЛКМ — бросить фиолетовую бомбу"
        local handle = Instance.new("Part")
        handle.Name = "Handle"; handle.Size = Vector3.new(0.6, 0.6, 0.6); handle.Transparency = 1
        handle.CanCollide = false; handle.CanTouch = false; handle.CanQuery = false
        handle.Parent = tool
        tool.PrimaryPart = handle

        local model, parts = buildBombVisual()
        if model then
            model.Parent = tool
            if parts and #parts > 0 then
                local primary = parts[1]
                model:PivotTo(handle.CFrame)
                for _, pt in ipairs(parts) do
                    pt.Anchored = false; pt.CanCollide = false; pt.CanTouch = false
                    pt.CanQuery = false; pt.Massless = true
                    if pt ~= primary then
                        local w = Instance.new("Weld")
                        w.Part0 = primary; w.Part1 = pt
                        w.C0 = primary.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
                        w.Parent = primary
                    end
                end
                local hw = Instance.new("Weld")
                hw.Part0 = handle; hw.Part1 = primary
                hw.C0 = handle.CFrame:ToObjectSpace(primary.CFrame); hw.C1 = CFrame.new()
                hw.Parent = handle
            end
        end

        local lastThrow = 0
        tool.Activated:Connect(function()
            if os.clock() - lastThrow < 0.8 then return end
            if CINE.active or busy then return end
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera
            if not hrp or not cam then return end
            lastThrow = os.clock()
            local look = cam.CFrame.LookVector
            local flat = Vector3.new(look.X, 0, look.Z)
            if flat.Magnitude < 0.05 then
                local rl = hrp.CFrame.LookVector
                flat = Vector3.new(rl.X, 0, rl.Z)
            end
            flat = flat.Unit
            local startPos = hrp.Position + flat*4.5 + Vector3.new(0, 1.2, 0)
            local vel = flat*BOMB.throwSpeed + Vector3.new(0, BOMB.upBoost + math.clamp(look.Y, -0.5, 0.8)*10, 0)
            local h = spawnThrownBomb(startPos, vel)
            if h and getgenv().BombCine then task.spawn(runThrowCinematic, h) end
        end)

        local backpack = p:FindFirstChild("Backpack")
        if backpack then tool.Parent = backpack end
    end

    -- УПРАВЛЕНИЕ / ЭКСПОРТ
    track(UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode == Enum.KeyCode.Backspace then
            if CINE.active then CINE.skip = true
            elseif pick.active then stopPick() end
        elseif input.KeyCode == Enum.KeyCode.B then
            startPick()
        end
    end))

    track(LocalPlayer.CharacterAdded:Connect(function()
        CINE.skip = true
        if pick.active then stopPick() end
    end))

    getgenv().giveBombTool = giveBombTool
    getgenv().spawnThrownBomb = spawnThrownBomb
    getgenv().startBombPick = startPick
    getgenv().toggleBombCine = function()
        getgenv().BombCine = not getgenv().BombCine
        notify("Кино-камера", getgenv().BombCine and "ВКЛ (бросок из рук)" or "ВЫКЛ (бросок из рук)")
    end
end

-- =====================================================================
-- РУКА С ПУШКОЙ
-- =====================================================================
local function stopToolAnims(hum)
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
        local nm = string.lower((tr.Animation and tr.Animation.Name) or tr.Name or "")
        if string.find(nm, "tool", 1, true) then
            pcall(function() tr:Stop(0) end)
        end
    end
end

local gunArmActive = false
local function applyGunArm(char, hum, gun)
    stopToolAnims(hum)
    local J = getBodyJoints(char)
    local raise = gun.def.noShoot and 0 or gunRaiseAmount()
    if raise > 0.001 then
        if J.shoulderR then
            local cam = workspace.CurrentCamera
            local pitch = cam and math.deg(math.asin(math.clamp(cam.CFrame.LookVector.Y, -1, 1))) or 0
            local ang = math.clamp(88 + pitch, 20, 170)
            applyJointRot(J.shoulderR, rotCache, ang*raise, 0, 0)
        end
        resetJoint(J.elbowR)
        resetJoint(J.wristR)
        gunArmActive = true
    elseif gunArmActive then
        resetJoint(J.shoulderR)
        resetJoint(J.elbowR)
        resetJoint(J.wristR)
        gunArmActive = false
    end
end

local function gunArmTick()
    if flight.active or emoteActive then return end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local gun = getHeldGun(char)
    if gun then applyGunArm(char, hum, gun) end
end
track(RunService.Stepped:Connect(gunArmTick))
track(RunService.Heartbeat:Connect(gunArmTick))

track(RunService.RenderStepped:Connect(function(dt)
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    if flight.active then applyFlightPose(char); return end
    if emoteActive then return end

    local gun = getHeldGun(char)
    if gun then
        lastMoveStateAnim = nil
        applyGunArm(char, hum, gun)
        return
    end

    local shoulder = getRightShoulder(char)
    if not shoulder then return end
    local moving = hum.MoveDirection.Magnitude > 0.1
    if moving ~= lastMoveStateAnim then
        lastMoveStateAnim = moving; idleClock = 0
        shoulder.Transform = moving and CFrame.Angles(math.rad(-90),0,0) or CFrame.new()
    end
    if not moving and M.EK.IDLE then
        idleClock = idleClock + dt
        local b = math.sin(idleClock*M.EK.IDLE_SPD)*M.EK.IDLE_AMP
        shoulder.Transform = CFrame.Angles(math.rad(b), 0, math.rad(b*0.25))
    end
end))

-- =====================================================================
-- ANTI-FLING + ЩИТ [8]
-- =====================================================================
getgenv().AntiFlingModelConfig = {
    id = "rbxassetid://84006104714125",
    size = 9,
    offX = 0, offY = 0, offZ = 0,
    rotX = 0, rotY = 0, rotZ = 0,
}

do
    local AF = {
        model = nil, showUntil = 0, manual = false,
        suspendUntil = 0, lastSafeCF = nil, lastPos = nil,
        abnormalAt = -10, lastNotify = -10,
        rollbacks = {}, blockUntil = 0, scanT = 0,
        wasFlying = false, parts = {},
    }
    local srcCache = nil

    local function getSrc()
        if srcCache ~= nil then return srcCache end
        local cfg = getgenv().AntiFlingModelConfig
        local ok, m = pcall(loadAssetModel, cfg.id)
        srcCache = (ok and m) or false
        return srcCache
    end

    local function afHide()
        if AF.model then pcall(function() AF.model:Destroy() end) end
        AF.model = nil
    end

    local function afShow()
        if AF.model and AF.model.Parent then return end
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local src = getSrc()
        if not src then return end
        local cfg = getgenv().AntiFlingModelConfig
        local model = src:Clone()
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
                or d:IsA("JointInstance") or d:IsA("WeldConstraint") then
                d:Destroy()
            end
        end
        local parts = {}
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") then table.insert(parts, d) end
        end
        if #parts == 0 then model:Destroy(); return end
        model.Name = "MonoAntiFling"
        model.Parent = workspace
        for _, pt in ipairs(parts) do
            pt.Anchored = true; pt.CanCollide = false; pt.CanTouch = false
            pt.CanQuery = false; pt.Massless = true
        end
        local primary, bestVol = parts[1], -1
        for _, pt in ipairs(parts) do
            local v = pt.Size.X * pt.Size.Y * pt.Size.Z
            if v > bestVol then bestVol = v; primary = pt end
        end
        pcall(function() model.PrimaryPart = nil end)
        local _, sz0 = model:GetBoundingBox()
        local maxD = math.max(sz0.X, sz0.Y, sz0.Z)
        if maxD > 0.01 then
            pcall(function() model:ScaleTo(model:GetScale() * ((cfg.size or 9) / maxD)) end)
        end
        local bbCF = model:GetBoundingBox()
        local off = CFrame.new(cfg.offX or 0, cfg.offY or 0, cfg.offZ or 0)
            * CFrame.Angles(math.rad(cfg.rotX or 0), math.rad(cfg.rotY or 0), math.rad(cfg.rotZ or 0))
        local target = hrp.CFrame * off
        model:PivotTo(target * bbCF:ToObjectSpace(model:GetPivot()))
        for _, pt in ipairs(parts) do
            if pt ~= primary then
                local w = Instance.new("Weld")
                w.Part0 = primary; w.Part1 = pt
                w.C0 = primary.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
                w.Parent = pt
            end
        end
        local hw = Instance.new("Weld")
        hw.Name = "MonoAFWeld"
        hw.Part0 = hrp; hw.Part1 = primary
        hw.C0 = hrp.CFrame:ToObjectSpace(primary.CFrame); hw.C1 = CFrame.new()
        hw.Parent = primary
        for _, pt in ipairs(parts) do pt.Anchored = false end
        AF.model = model
    end

    local function trigger()
        local now = os.clock()
        AF.showUntil = now + 5
        afShow()
        if now - AF.lastNotify > 4 then
            AF.lastNotify = now
            notify("Anti-Fling", "Атака отражена")
        end
    end

    local function limits()
        if AF.manual then return 50, 75, 15 end
        return 110, 110, 40
    end

    local function nearOther(range)
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= p and pl.Character then
                local r = pl.Character:FindFirstChild("HumanoidRootPart")
                if r and (r.Position - hrp.Position).Magnitude <= range then return true end
            end
        end
        return false
    end

    local function check()
        local char = p.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then
            AF.lastSafeCF = nil; AF.lastPos = nil; return
        end
        local now = os.clock()
        if flight.active then AF.wasFlying = true
        elseif AF.wasFlying then
            AF.wasFlying = false
            AF.suspendUntil = math.max(AF.suspendUntil, now + 1.5)
        end
        local exempt = flight.active or getgenv().ShatterActive or isTeleporting
            or now < AF.suspendUntil or now - lastTeleport < 1.0
            or hum.SeatPart ~= nil or hrp.Anchored
        if exempt then
            AF.lastSafeCF = hrp.CFrame; AF.lastPos = hrp.Position; return
        end

        local lv = hrp.AssemblyLinearVelocity
        local av = hrp.AssemblyAngularVelocity
        local hLim, uLim, aLim = limits()
        local horiz = Vector3.new(lv.X, 0, lv.Z).Magnitude
        local bad = horiz > hLim or lv.Y > uLim or av.Magnitude > aLim

        local jumped = false
        if AF.lastPos and (hrp.Position - AF.lastPos).Magnitude > 60
            and (bad or now - AF.abnormalAt < 0.6 or nearOther(30)) then
            jumped = true
        end

        if bad then
            AF.abnormalAt = now
            hrp.AssemblyLinearVelocity = Vector3.new(0, math.clamp(lv.Y, -80, 30), 0)
            hrp.AssemblyAngularVelocity = Vector3.zero
        end

        if jumped and AF.lastSafeCF and now >= AF.blockUntil then
            local fresh = {}
            for _, t in ipairs(AF.rollbacks) do
                if now - t < 2 then table.insert(fresh, t) end
            end
            table.insert(fresh, now)
            AF.rollbacks = fresh
            if #fresh >= 4 then
                AF.blockUntil = now + 3
            else
                hrp.CFrame = AF.lastSafeCF
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end

        if bad or jumped then
            trigger()
            AF.lastPos = hrp.Position
        else
            AF.lastSafeCF = hrp.CFrame
            AF.lastPos = hrp.Position
        end
    end

    local function disableCollisions()
        for pl, set in pairs(AF.parts) do
            for part in pairs(set) do
                if part.Parent then
                    if part.CanCollide then part.CanCollide = false end
                else
                    set[part] = nil
                end
            end
        end
    end

    local function hookPlayer(pl)
        if pl == p then return end
        local function onChar(ch)
            local set = {}
            AF.parts[pl] = set
            for _, d in ipairs(ch:GetDescendants()) do
                if d:IsA("BasePart") then set[d] = true end
            end
            track(ch.DescendantAdded:Connect(function(d)
                if d:IsA("BasePart") then set[d] = true end
            end))
        end
        if pl.Character then onChar(pl.Character) end
        track(pl.CharacterAdded:Connect(onChar))
    end
    for _, pl in ipairs(Players:GetPlayers()) do hookPlayer(pl) end
    track(Players.PlayerAdded:Connect(hookPlayer))
    track(Players.PlayerRemoving:Connect(function(pl) AF.parts[pl] = nil end))

    track(RunService.Stepped:Connect(function()
        disableCollisions()
        check()
    end))
    track(RunService.Heartbeat:Connect(function(dt)
        check()
        local now = os.clock()
        if AF.model and not AF.model.Parent then AF.model = nil end
        if AF.model and not AF.manual and now > AF.showUntil then afHide() end
        if AF.manual and not AF.model then afShow() end

        AF.scanT = AF.scanT + dt
        if AF.scanT >= 0.2 then
            AF.scanT = 0
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl ~= p and pl.Character then
                        local r = pl.Character:FindFirstChild("HumanoidRootPart")
                        if r and (r.Position - hrp.Position).Magnitude <= 15 then
                            if r.AssemblyAngularVelocity.Magnitude > 50
                                or r.AssemblyLinearVelocity.Magnitude > 140 then
                                tr-- =====================================================================
-- MONOCHROME + PORTAL GUN // COMBINED v21
--  - Портал ставится ТОЧНО в точку выстрела (убран wallYShift)
--  - Взрыв после [Q]: вспышка, огненный шар, дым, искры,
--    обломки дрона, пыль и камни (без ударной волны)
--  - ★ КИНО-БОМБА v21: [B] — выбрать точку, аниме-портал, кино-камера,
--    letterbox, speed-lines, обратный отсчёт, impact-frame,
--    новый взрыв (грибовидное облако, световой столб, кратер, камни)
--  - [B] — выбрать точку · Backspace — пропустить/отмена
--  - Фиолетовая бомба: БЕЗ свечения, с пиканьем 91476644853368,
--    серые камни после взрыва
-- =====================================================================

local M = {}
M.CLR, M.TM, M.SND, M.EK, M.FLY, M.DM, M.SC, M.LB, M.W = {}, {}, {}, {}, {}, {}, {}, {}, {}

do -- COLORS
    local RED = Color3.fromRGB(232,28,28)
    M.CLR.RED        = RED
    M.CLR.WHITE      = Color3.fromRGB(255,255,255)
    M.CLR.ICE        = Color3.fromRGB(190,225,255)
    M.CLR.BLOOD      = RED
    M.CLR.BLOOD_DARK = RED
    M.CLR.BLOOD_LT   = RED
    M.CLR.BLOOD_OLD  = RED
    M.CLR.GORE_A     = RED
    M.CLR.GORE_B     = RED
    M.CLR.GORE_C     = RED
    M.CLR.STREAK     = RED
    M.CLR.SPLAT      = RED
    M.CLR.NERVE_A    = Color3.fromRGB(30,85,210)
    M.CLR.NERVE_B    = Color3.fromRGB(55,115,230)
    M.CLR.MUSCLE_A   = Color3.fromRGB(125,55,45)
    M.CLR.MUSCLE_B   = Color3.fromRGB(92,40,36)
    M.CLR.BONE       = Color3.fromRGB(255,255,255)
    M.CLR.THREAD     = Color3.fromRGB(35,30,40)
    M.CLR.SHARD      = Color3.fromRGB(14,12,18)
    M.CLR.DUST       = Color3.fromRGB(200,195,185)
    M.CLR.GHOST      = Color3.fromRGB(170,200,255)
    M.CLR.MIST       = Color3.fromRGB(195,220,240)
end

do -- TIMING
    M.TM.CHAOS        = 0.42
    M.TM.TURN         = 0.10
    M.TM.STREAK       = 0.22
    M.TM.STREAK_JIT   = 0.08
    M.TM.GHOST_START  = 0.48
    M.TM.GHOST_TIME   = 0.40
    M.TM.TOTAL        = 0.86
    M.TM.SPLAT_LIFE   = 2.0
    M.TM.SPLAT_FADE   = 0.5
    M.TM.FLASH        = 0.3
    M.TM.FRAG_LIFE    = 2.4
    M.TM.PRINT_SND    = 8
    M.TM.BLOOD_POOL   = 3.5
end

do -- SOUNDS
    M.SND.REGEN        = "rbxassetid://84312631986360"
    M.SND.DISINTEGRATE = "rbxassetid://139916424589528"
    M.SND.DECAL        = "rbxassetid://80559445961612"
    M.SND.SPAWN        = "rbxassetid://74562584385247"
    M.SND.ENTER        = "rbxassetid://102568033872947"
    M.SND.SCANNER      = "rbxassetid://129289790297292"
    M.SND.EXPLOSION    = "rbxassetid://138533090376585"
    M.SND.BOMB_BEEP    = "rbxassetid://91476644853368"
end

do -- REGEN MODEL ASSETS
    M.RGN_IDS = {
        bone       = "rbxassetid://70473244410151",
        muscleRed  = "rbxassetid://120986606825859",
        muscleBlue = "rbxassetid://128534142433183",
        root       = "rbxassetid://140378954130619",
    }
end

do -- FLIGHT
    M.FLY.ID    = "rbxassetid://98316282912132"
    M.FLY.SPEED = 70
    M.FLY.FAST  = 140
    M.FLY.VERT  = 55
end

getgenv().RegenModelConfig = {
    bone       = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    muscleRed  = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    muscleBlue = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    root       = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    decal      = {offX=0, offY=2.2, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
}

getgenv().FlyModelConfig = {
    offX=0.00, offY=-0.10, offZ=-0.70,
    rotX=0, rotY=0, rotZ=0,
    scale=0.90, gap=1.30,
    lean=18, armX=138, armZ=14, elbow=-32,
    legFwd=62, legSpread=9, kneeBend=78, grip=2.5,
}

do -- DIMENSIONS
    M.DM.RANGE        = 10000
    M.DM.PORTAL_GAP   = 0.03
    M.DM.PORTAL_SIZE  = 8.5
    M.DM.COOLDOWN     = 0.25
    M.DM.PORTAL_LIFE  = 15
    M.DM.EXIT_H       = 5
    M.DM.GARAGE_SCALE = 0.75
    M.DM.RETRO_SCALE  = 0.70
    M.DM.OMEGA_SCALE  = 0.5
    M.DM.GARAGE_C     = Vector3.new(0,32000,0)
    M.DM.RETRO_C      = Vector3.new(0,56000,0)
    M.DM.OMEGA_C      = Vector3.new(0,72000,0)
    M.DM.GARAGE_O_Y   = 5
    M.DM.OMEGA_O_Y    = 5
    M.DM.GARAGE_ID    = "rbxassetid://116913770111820"
    M.DM.RETRO_ID     = "rbxassetid://1583359288"
    M.DM.OMEGA_ID     = "rbxassetid://126041705531931"
end

do -- WALK / SCANNER
    M.W.CALM   = 10
    M.W.NORMAL = 16
    M.SC.LOOK_ANGLE   = 45
    M.SC.STICKY_ANGLE = 80
    M.SC.LOOK_DIST    = 60
    M.SC.STICKY_DIST  = 90
end

do -- EMOTE KEYFRAMES
    M.EK.SPEED      = 1.0
    M.EK.HEAD_TRACK = true
    M.EK.TORSO_LEAN = true
    M.EK.IDLE       = true
    M.EK.IDLE_AMP   = 0.8
    M.EK.IDLE_SPD   = 1.6
    M.EK.SHOULDER = {
        {0.000,0,0,0},{0.050,-9,3,4},{0.100,78,-9,-18},{0.166,150,-18,-37},
        {0.233,166,-21,-40},{0.300,156,-22,-38},{0.366,146,-21,-44},
        {0.433,122,9,-36},{0.500,96,26,-28},{0.566,75,39,-25},
        {0.633,60,22,-9},{0.700,22,6,-3},{0.750,-5,1,2},{0.800,0,0,0},
    }
    M.EK.ELBOW = {
        {0.000,0,0,0},{0.050,-12,0,0},{0.100,-22,0,0},{0.166,-52,0,0},
        {0.233,-60,0,0},{0.300,-56,0,0},{0.366,-48,0,0},{0.433,-34,0,0},
        {0.500,-20,0,0},{0.566,-10,0,0},{0.633,-4,0,0},{0.700,0,0,0},
    }
    M.EK.WRIST = {
        {0.000,0,0,0},{0.100,-6,0,12},{0.166,-12,0,22},{0.233,-14,0,24},
        {0.300,-11,0,19},{0.366,-6,0,11},{0.433,0,0,4},{0.500,5,0,-9},
        {0.566,9,0,-16},{0.633,4,0,-8},{0.700,0,0,0},
    }
    M.EK.NECK = {
        {0.000,0,0,0},{0.100,4,0,-6},{0.166,7,0,-10},{0.233,8,0,-11},
        {0.300,6,0,-8},{0.366,3,0,-3},{0.433,1,0,3},{0.500,0,0,6},
        {0.566,-1,0,5},{0.633,0,0,2},{0.700,0,0,0},
    }
    M.EK.TORSO = {
        {0.000,0,0,0},{0.100,-2.5,0,-4},{0.166,-3.5,0,-7},{0.233,-3.5,0,-8},
        {0.300,-2.5,0,-5},{0.366,-1,0,-2},{0.433,0,0,2},{0.500,1,0,3.5},
        {0.566,1,0,2.5},{0.633,0,0,1},{0.700,0,0,0},
    }
end

do -- LIMB TABLES
    M.LB.R6 = {
        RightArm={"Right Arm"}, LeftArm={"Left Arm"},
        RightLeg={"Right Leg"}, LeftLeg={"Left Leg"},
    }
    M.LB.R15 = {
        RightArm={"RightUpperArm","RightLowerArm","RightHand"},
        LeftArm ={"LeftUpperArm","LeftLowerArm","LeftHand"},
        RightLeg={"RightUpperLeg","RightLowerLeg","RightFoot"},
        LeftLeg ={"LeftUpperLeg","LeftLowerLeg","LeftFoot"},
    }
    M.LB.TORSO = { R6={"Torso"}, R15={"UpperTorso","LowerTorso"} }
    M.LB.REGEN_ORDER = {"Head","Torso","RightArm","LeftArm","RightLeg","LeftLeg"}
end

local function svc(n)
    local ok, s = pcall(function() return game:GetService(n) end)
    return ok and s or nil
end
local Players          = svc("Players")
local CoreGui          = svc("CoreGui")
local RunService       = svc("RunService")
local TweenService     = svc("TweenService")
local UserInputService = svc("UserInputService")
local Lighting         = svc("Lighting")
local SoundService     = svc("SoundService")
local StarterGui       = svc("StarterGui")
local InsertService    = svc("InsertService")

local LocalPlayer = Players and Players.LocalPlayer
if not LocalPlayer then
    local t0 = os.clock()
    repeat task.wait(0.1) LocalPlayer = Players.LocalPlayer until LocalPlayer or os.clock()-t0 > 15
end
if not LocalPlayer then warn("[MONO] LocalPlayer не найден"); return end

local Camera = workspace.CurrentCamera
if not Camera then
    local t0 = os.clock()
    repeat task.wait(0.1) Camera = workspace.CurrentCamera until Camera or os.clock()-t0 > 10
end

local p = LocalPlayer

pcall(function()
    if CoreGui then
        for _, n in ipairs({"MonoPortalGunGui","MonoMobileBombGui"}) do
            local o = CoreGui:FindFirstChild(n); if o then o:Destroy() end
        end
    end
end)
if workspace:FindFirstChild("MonoRegenFX") then workspace.MonoRegenFX:Destroy() end
if workspace:FindFirstChild("MonoFlyModel") then workspace.MonoFlyModel:Destroy() end
if workspace:FindFirstChild("MonoAntiFling") then workspace.MonoAntiFling:Destroy() end
pcall(function() RunService:UnbindFromRenderStep("MonoDeathCam") end)
pcall(function() RunService:UnbindFromRenderStep("MonoCine") end)
if getgenv and getgenv().hardStopFlight then pcall(getgenv().hardStopFlight); getgenv().hardStopFlight = nil end
if getgenv then getgenv().toggleFlight = nil end
if getgenv and getgenv().MonoConnections then
    for _, c in ipairs(getgenv().MonoConnections) do
        pcall(function() if c.Connected then c:Disconnect() end end)
    end
end
if getgenv then getgenv().MonoConnections = {} end
if getgenv and getgenv().MonoHoleParts then
    for part in pairs(getgenv().MonoHoleParts) do
        if part and part.Parent then pcall(function() part.CanCollide = true end) end
    end
end
if getgenv then getgenv().MonoHoleParts = {} end

local function track(c) if getgenv then table.insert(getgenv().MonoConnections, c) end; return c end
local function log(...) print("[MONO]", ...) end
log("=== COMBINED v21 LOADING ===")

local destroyPortalPart
local shoot

getgenv().PrimePrinterConfig = {
    AutoRegen=false, AutoShatter=false, ShatterHP=20,
    LimbLossRegen=true, LimbLossHP=15, LimbLossCooldown=1.5,
    RespawnAtDeathSpot=true, RespawnFromOneLimb=true,
    HideForceField=true, LockCameraOnDeath=false,
    SecondWind=false, SecondWindHP=25, SecondWindHeal=0.5, SecondWindCD=75,
    RegenSpeed=1.0, RegenRedFlash=false,
}
local config = getgenv().PrimePrinterConfig

local function isClothingDecal(d)
    if not d or not d:IsA("Decal") then return false end
    local par = d.Parent; if not par then return false end
    if par:IsA("Shirt") or par:IsA("Pants") or par:IsA("TShirt") or par:IsA("Clothing") then return true end
    local pn = string.lower(par.Name or "")
    if pn=="shirt" or pn=="pants" or pn=="tshirt" or pn=="clothing"
        or pn=="classic shirt" or pn=="classic pants" or pn=="classic tshirt" then return true end
    local dn = string.lower(d.Name or "")
    if dn=="shirt" or dn=="pants" or dn=="tshirt" then return true end
    return false
end
local function isAccessoryHandle(part)
    if not part or not part:IsA("BasePart") then return false end
    local par = part.Parent
    if not par then return false end
    return par:IsA("Accessory") or par:IsA("Hat")
end
local function isInsideAccessory(obj)
    if not obj then return false end
    local par = obj.Parent
    while par and par ~= workspace do
        if par:IsA("Accessory") or par:IsA("Hat") then return true end
        par = par.Parent
    end
    return false
end
local function isInsideTool(obj) return obj:FindFirstAncestorWhichIsA("Tool") ~= nil end

local walkMode, savedWalkSpeed = false, M.W.NORMAL
local function applyWalkMode()
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.WalkSpeed == 0 and walkMode then return end
    hum.WalkSpeed = walkMode and M.W.CALM or savedWalkSpeed
end
local function setWalkMode(state, silent)
    walkMode = state; applyWalkMode()
    if not silent then
        pcall(function() StarterGui:SetCore("SendNotification",
            {Title=walkMode and "Походка: СПОКОЙНАЯ" or "Походка: ОБЫЧНАЯ", Text="[H]", Duration=3}) end)
    end
end
local function toggleWalkMode() setWalkMode(not walkMode) end

local function hideForceFields(char)
    if not config.HideForceField then return end
    local function hide(ff) if ff and ff:IsA("ForceField") then pcall(function() ff.Visible=false end) end end
    for _, d in ipairs(char:GetDescendants()) do hide(d) end
    track(char.DescendantAdded:Connect(hide))
end

local function cameraShake(intensity, duration)
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    task.spawn(function()
        local t0 = os.clock()
        while os.clock()-t0 < duration do
            local d = 1 - (os.clock()-t0)/duration
            hum.CameraOffset = Vector3.new(
                (math.random()-0.5)*2*intensity*d,
                (math.random()-0.5)*2*intensity*d,
                (math.random()-0.5)*2*intensity*d*0.5)
            RunService.RenderStepped:Wait()
        end
        hum.CameraOffset = Vector3.new(0,0,0)
    end)
end

-- =====================================================================
-- GUNS
-- =====================================================================
local GUN_DEFS = {
    evil_morty = {
        id="evil_morty", name="Evil Morty Portal Gun",
        assetId="rbxassetid://113344864471588",
        muzzleOffset=CFrame.new(0,0,-2),
        portalTexture="rbxassetid://129332930839385",
        beamColor=Color3.fromRGB(190,255,205),
        recolor=true,
        defaultConfig={posX=0.00,posY=0.65,posZ=-0.25,rotX=180,rotY=180,rotZ=180,scale=1.25},
    },
    rick_portal = {
        id="rick_portal", name="Rick Portal Gun",
        assetId="rbxassetid://126868848475018",
        muzzleOffset=CFrame.new(0,0,-2),
        portalTexture="rbxassetid://111394501324479",
        portalModelId="rbxassetid://75803396857476",
        beamColor=Color3.fromRGB(190,255,205),
        recolor=false,
        defaultConfig={posX=0.00,posY=0.65,posZ=-0.25,rotX=180,rotY=180,rotZ=180,scale=1.25},
    },
}
local GUN_ORDER = { "evil_morty", "rick_portal" }
local GUN_PORTAL_STYLE = {
    portalSize=8.5, spinSpeed=0.65, disappearTime=0.30, imageFinalTrans=0,
    openSlitW=0.045, openSlitH=1.30, openWideW=1.50, openWideH=0.50,
    openSettleW=0.85, openSettleH=1.15, openT1=0.11, openT2=0.12, openT3=0.14,
}
local HEROES = {
    evil_morty_2 = {
        id="evil_morty_2", name="Evil Morty", accent=Color3.fromRGB(255,200,90),
        desc="[R] сканер · [H] ходьба · [6] распад\n[Q] полёт · [8] щит · [N] пушка\n[B] кино-бомба · [Backspace] отмена\nПорталы [Z C X E V]\nЛКМ с бомбой = бросок",
        abilities={walk=true, modes=true, scanner=true},
    },
}
local currentHero = HEROES.evil_morty_2
getgenv().currentHeroId = currentHero.id

local currentDestination = "Normal"
local spawnedGarage, spawnedRetro, spawnedOmega
local garageSpawnPoint, omegaSpawnPoint
local nextPortal, returnPosition = 1, nil
local Guns = {}
local activeGunId = "evil_morty"
local portal1, portal2
local lastTeleport, arrivedAt, isTeleporting = 0, nil, false
local screenGui, configFrame, codeBox
local configRows, gunSelectorButtons = {}, {}
local emoteActive, emoteToken, idleClock, lastMoveStateAnim = false, 0, 0, nil
local scannerActive, hasTarget, stickyTarget = false, false, nil
local gunShotT = -10
local flight = {active=false, vel=Vector3.zero, t0=0}
local EXT = {}

local function getActiveGun() return Guns[activeGunId] end

local sSnd = Instance.new("Sound"); sSnd.SoundId=M.SND.SPAWN; sSnd.Volume=1.5; sSnd.Parent=workspace
local tSnd = Instance.new("Sound"); tSnd.SoundId=M.SND.SPAWN; tSnd.Volume=1.5; tSnd.Parent=workspace
local enterSnd = Instance.new("Sound"); enterSnd.SoundId=M.SND.ENTER; enterSnd.Volume=1.5; enterSnd.Parent=workspace

local function notify(t, x)
    pcall(function() StarterGui:SetCore("SendNotification",{Title=t,Text=x,Duration=3}) end)
end
local function gunCFrame(cfg)
    return CFrame.new(cfg.posX,cfg.posY,cfg.posZ)
        * CFrame.Angles(math.rad(cfg.rotX),math.rad(cfg.rotY),math.rad(cfg.rotZ))
end

local function loadAssetModel(assetId)
    if not assetId then return nil end
    local clean = tostring(assetId):gsub("rbxassetid://", "")
    local ids = {clean, "rbxassetid://" .. clean}
    for _, id in ipairs(ids) do
        local ok, objs = pcall(function() return game:GetObjects(id) end)
        if ok and objs and objs[1] then
            local obj = objs[1]
            if obj:IsA("Tool") then
                local m = Instance.new("Model"); obj.Parent = m; return m
            elseif obj:IsA("Model") then
                return obj
            elseif obj:IsA("BasePart") then
                local m = Instance.new("Model"); obj.Parent = m; return m
            end
        end
    end
    if InsertService then
        local num = tonumber(clean:match("%d+"))
        if num then
            local ok, model = pcall(function() return InsertService:LoadAsset(num) end)
            if ok and model then
                for _, child in ipairs(model:GetChildren()) do
                    if child:IsA("Model") then return child end
                    if child:IsA("Tool") then
                        local m = Instance.new("Model"); child.Parent = m; return m
                    end
                    if child:IsA("BasePart") then
                        local m = Instance.new("Model"); child.Parent = m; return m
                    end
                end
                return model
            end
        end
    end
    warn("[MONO] Не удалось загрузить модель: " .. tostring(assetId))
    return nil
end

local function recolorGunModel(folder)
    if not folder then return end
    for _, part in ipairs(folder:GetDescendants()) do
        if part:IsA("BasePart") then
            local c = part.Color
            if c.R>0.5 and c.G>0.4 and c.B<0.45 and (c.R+c.G)>c.B*2 then
                part.Color = Color3.fromRGB(60,62,75)
                if part.Material==Enum.Material.Neon then part.Material=Enum.Material.Metal end
            end
        end
    end
end

local function buildGunInstance(def)
    local gc = def.config
    local gun = {def=def, config=gc, tool=nil, handle=nil, muzzle=nil, bodyFolder=nil, welds={}, muzzleWeld=nil}
    local t = Instance.new("Tool")
    t.Name=def.name; t.RequiresHandle=true; t.CanBeDropped=false
    local h = Instance.new("Part")
    h.Name="Handle"; h.Size=Vector3.new(0.2,0.2,0.2); h.Transparency=1
    h.CanCollide=false; h.CanTouch=false; h.CanQuery=false; h.Massless=true
    h.Parent=t
    local snd = Instance.new("Sound"); snd.Name="ShotSound"; snd.SoundId=M.SND.SPAWN; snd.Volume=1.2; snd.Parent=h
    t.PrimaryPart = h
    gun.tool=t; gun.handle=h
    local folder = Instance.new("Folder"); folder.Name="GunBody"; folder.Parent=t
    gun.bodyFolder = folder
    local src = loadAssetModel(def.assetId)
    if src then
        if not src:IsA("Model") then
            local w = Instance.new("Model"); src.Parent = w; src = w
        end
        local sp = src:GetPivot()
        for _, o in ipairs(src:GetDescendants()) do
            if o:IsA("Script") or o:IsA("LocalScript") or o:IsA("ModuleScript") then o:Destroy() end
        end
        for _, part in ipairs(src:GetDescendants()) do
            if part:IsA("BasePart") then
                local rel = sp:ToObjectSpace(part.CFrame)
                local bs = part.Size
                part.Anchored=false; part.CanCollide=false
                part.CanTouch=false; part.CanQuery=false; part.Massless=true
                part.Parent = folder
                local weld = Instance.new("Weld")
                weld.Part0=h; weld.Part1=part
                weld.C0 = gunCFrame(gc)*rel; weld.C1 = CFrame.new()
                weld.Parent=h
                table.insert(gun.welds, {weld=weld, baseCF=rel, part=part, baseSize=bs})
            end
        end
        src:Destroy()
    end
    if def.recolor then recolorGunModel(folder) end
    if #gun.welds == 0 then
        local function mkFb(name, size, color, material, relCF)
            local fb = Instance.new("Part")
            fb.Name=name; fb.Size=size
            fb.Color=color; fb.Material=material or Enum.Material.Metal
            fb.Anchored=false; fb.CanCollide=false
            fb.CanTouch=false; fb.CanQuery=false; fb.Massless=true
            fb.Parent=folder
            local weld = Instance.new("Weld")
            weld.Part0=h; weld.Part1=fb
            weld.C0 = gunCFrame(gc)*relCF; weld.C1=CFrame.new()
            weld.Parent=h
            table.insert(gun.welds, {weld=weld, baseCF=relCF, part=fb, baseSize=size})
        end
        mkFb("FbBody", Vector3.new(0.55,0.55,1.5), Color3.fromRGB(60,62,75), Enum.Material.Metal, CFrame.new(0,0,-0.4))
        mkFb("FbBarrel", Vector3.new(0.32,0.32,1.6), Color3.fromRGB(75,78,92), Enum.Material.Metal, CFrame.new(0,0,-1.7))
        mkFb("FbGrip", Vector3.new(0.28,0.7,0.35), Color3.fromRGB(40,42,52), Enum.Material.Metal, CFrame.new(0,-0.5,0.1)*CFrame.Angles(math.rad(15),0,0))
        mkFb("FbMuzzle", Vector3.new(0.42,0.42,0.2), Color3.fromRGB(140,255,180), Enum.Material.Neon, CFrame.new(0,0,-2.5))
    end
    local muzzle = Instance.new("Part")
    muzzle.Name="Muzzle"; muzzle.Size=Vector3.new(0.2,0.2,0.2)
    muzzle.Transparency=1; muzzle.CanCollide=false; muzzle.Massless=true
    muzzle.Parent=t
    gun.muzzle = muzzle
    local mw = Instance.new("Weld")
    mw.Part0=h; mw.Part1=muzzle
    mw.C0 = gunCFrame(gc)*(def.muzzleOffset or CFrame.new(0,0,-1))
    mw.C1 = CFrame.new(); mw.Parent=h
    gun.muzzleWeld = mw
    return gun
end

local function applyGunConfig(gun)
    gun = gun or getActiveGun()
    if not gun or not gun.welds then return end
    local gc = gun.config
    local s = gc.scale
    local gcf = gunCFrame(gc)
    for _, e in ipairs(gun.welds) do
        if e.weld and e.weld.Parent then
            local sc = CFrame.new(e.baseCF.Position*s)*(e.baseCF-e.baseCF.Position)
            e.weld.C0 = gcf*sc
            if e.part and e.part.Parent and e.baseSize then e.part.Size = e.baseSize*s end
        end
    end
    if gun.muzzleWeld and gun.muzzleWeld.Parent then
        local mo = gun.def.muzzleOffset or CFrame.new(0,0,-1)
        local sm = CFrame.new(mo.Position*s)*(mo-mo.Position)
        gun.muzzleWeld.C0 = gcf*sm
    end
end

local function updateCodeBox()
    if not codeBox then return end
    local gun = getActiveGun(); if not gun then return end
    local c = gun.config
    codeBox.Text = string.format("[%s]\nGUN_POS=Vector3.new(%.2f,%.2f,%.2f)\nGUN_ROT=CFrame.Angles(math.rad(%.0f),math.rad(%.0f),math.rad(%.0f))\nGUN_SCALE=%.2f",
        gun.def.name, c.posX,c.posY,c.posZ, c.rotX,c.rotY,c.rotZ, c.scale)
end
local function refreshAllConfigRows()
    local gun = getActiveGun(); if not gun then return end
    for _, e in ipairs(configRows) do
        if e.valLbl and e.valLbl.Parent then e.valLbl.Text = string.format("%.2f", gun.config[e.key]) end
    end
end
local function refreshGunSelectorStyles()
    for id, btn in pairs(gunSelectorButtons) do
        if btn and btn.Parent then
            local a = id==activeGunId
            btn.BackgroundColor3 = a and Color3.fromRGB(70,90,130) or Color3.fromRGB(30,30,44)
            local s = btn:FindFirstChild("Stroke")
            if s then s.Color = a and Color3.fromRGB(140,180,255) or Color3.fromRGB(75,75,105) end
        end
    end
end
local function setActiveGun(id)
    if not GUN_DEFS[id] then return end
    activeGunId = id
    refreshGunSelectorStyles(); refreshAllConfigRows(); updateCodeBox()
end

local function removeAllGunTools()
    local names = {}
    for _, def in pairs(GUN_DEFS) do names[def.name]=true end
    local bp = p:FindFirstChild("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") and names[v.Name] then v:Destroy() end
        end
    end
    if p.Character then
        for _, v in ipairs(p.Character:GetChildren()) do
            if v:IsA("Tool") and names[v.Name] then v:Destroy() end
        end
    end
end

local function giveGuns()
    if portal1 and destroyPortalPart then destroyPortalPart(portal1) end
    if portal2 and destroyPortalPart then destroyPortalPart(portal2) end
    portal1, portal2 = nil, nil
    arrivedAt = nil; isTeleporting = false; nextPortal = 1
    removeAllGunTools(); Guns = {}
    for _, id in ipairs(GUN_ORDER) do
        local def = GUN_DEFS[id]
        def.config = def.config or {}
        for k, v in pairs(def.defaultConfig) do
            if def.config[k]==nil then def.config[k]=v end
        end
        local ok, gun = pcall(buildGunInstance, def)
        if ok and gun then
            Guns[id] = gun
            if not def.noShoot then
                gun.tool.Activated:Connect(function() if shoot then shoot(gun) end end)
            end
            applyGunConfig(gun)
        else
            warn("[giveGuns] Не удалось собрать "..tostring(id))
        end
    end
    local bp = p:FindFirstChild("Backpack") or p:WaitForChild("Backpack", 10)
    if not bp then warn("[giveGuns] Backpack нет!"); return end
    for _, id in ipairs(GUN_ORDER) do
        if Guns[id] and Guns[id].tool then Guns[id].tool.Parent = bp end
    end
    local names = {}
    for _, id in ipairs(GUN_ORDER) do table.insert(names, GUN_DEFS[id].name) end
    notify("Оружие выдано", table.concat(names, " · "))
end

local function saveReturnPosition()
    if not returnPosition and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        returnPosition = p.Character.HumanoidRootPart.Position
    end
end
local function positionModel(model, targetPos)
    local ok = pcall(function() model:PivotTo(CFrame.new(targetPos)) end)
    if not ok then
        local cf = model:GetBoundingBox()
        local off = targetPos - cf.Position
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then part.CFrame = part.CFrame + off end
        end
    end
end
local function ignoreList()
    local list = {}
    if p.Character then table.insert(list, p.Character) end
    for _, gun in pairs(Guns) do if gun and gun.tool then table.insert(list, gun.tool) end end
    if portal1 and portal1.part then table.insert(list, portal1.part) end
    if portal2 and portal2.part then table.insert(list, portal2.part) end
    local fm = workspace:FindFirstChild("MonoFlyModel")
    if fm then table.insert(list, fm) end
    local afm = workspace:FindFirstChild("MonoAntiFling")
    if afm then table.insert(list, afm) end
    return list
end
local function findGround(pos, fromY)
    if fromY == nil then fromY = 400 end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = ignoreList()
    local o = pos + Vector3.new(0,fromY,0)
    local r = workspace:Raycast(o, Vector3.new(0,-2000,0), rp)
    return r and r.Position or pos
end
local function createBeam(a, b, color)
    local dist = (b-a).Magnitude
    if dist < 0.1 then return end
    local beam = Instance.new("Part")
    beam.Anchored=true; beam.CanCollide=false; beam.CanTouch=false; beam.CanQuery=false
    beam.Size=Vector3.new(0.2,0.2,dist)
    beam.Color=color or Color3.fromRGB(200,220,255)
    beam.Material=Enum.Material.Neon
    beam.CFrame=CFrame.lookAt(a,b)*CFrame.new(0,0,-dist/2)
    beam.Parent=workspace
    local tw = TweenService:Create(beam, TweenInfo.new(0.15), {Size=Vector3.new(0,0,dist), Transparency=1})
    tw:Play(); tw.Completed:Connect(function() beam:Destroy() end)
end

local function getFxFolder()
    local f = workspace:FindFirstChild("MonoRegenFX")
    if not f then f = Instance.new("Folder"); f.Name="MonoRegenFX"; f.Parent=workspace end
    return f
end
local function lookCF(from, to)
    local dir = to - from
    if dir.Magnitude < 1e-4 then return CFrame.new(from) end
    local up = (math.abs(dir.Unit.Y) > 0.98) and Vector3.new(1,0,0) or Vector3.new(0,1,0)
    return CFrame.lookAt(from, to, up)
end
local function randUnit()
    for _=1,20 do
        local v = Vector3.new(math.random()*2-1, math.random()*2-1, math.random()*2-1)
        local mg = v.Magnitude
        if mg>0.1 and mg<=1 then return v/mg end
    end
    return Vector3.new(0,1,0)
end
local function safeUnit(v, fb) if v.Magnitude > 0.05 then return v.Unit end; return fb end

-- =====================================================================
-- REGEN MODEL HELPERS
-- =====================================================================
local REGEN_MODEL_CACHE = {}
local function getRegenModelSrc(key)
    if REGEN_MODEL_CACHE[key] ~= nil then return REGEN_MODEL_CACHE[key] end
    local id = M.RGN_IDS[key]
    if not id then REGEN_MODEL_CACHE[key] = false; return false end
    local ok, mdl = pcall(loadAssetModel, id)
    if ok and mdl then
        REGEN_MODEL_CACHE[key] = mdl
        return mdl
    end
    REGEN_MODEL_CACHE[key] = false
    return false
end
local function getRegenModelCfg(key)
    local t = getgenv().RegenModelConfig
    if not t then return nil end
    return t[key]
end
local function applyRegenModelCfg(key, model)
    local cfg = getRegenModelCfg(key)
    if not cfg or not model then return end
    pcall(function() model:ScaleTo(cfg.scale or 1) end)
end
local function regenModelCF(key, baseCF)
    local cfg = getRegenModelCfg(key)
    if not cfg then return baseCF end
    local off = CFrame.new(cfg.offX or 0, cfg.offY or 0, cfg.offZ or 0)
        * CFrame.Angles(math.rad(cfg.rotX or 0), math.rad(cfg.rotY or 0), math.rad(cfg.rotZ or 0))
    return baseCF * off
end
local function buildRegenModel(key)
    local src = getRegenModelSrc(key)
    if not src then return nil end
    local clone = src:Clone()
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
            d:Destroy()
        elseif d:IsA("BasePart") then
            d.Anchored = true
            d.CanCollide = false
            d.CanTouch = false
            d.CanQuery = false
            d.CastShadow = false
        end
    end
    applyRegenModelCfg(key, clone)
    return clone
end
local function hideRegenModel(model)
    if not model then return end
    pcall(function() model:PivotTo(CFrame.new(0, -5000, 0)) end)
end

-- =====================================================================
-- EMOTE
-- =====================================================================
local function getRightShoulder(char)
    if not char then return nil end
    return char:FindFirstChild("Right Shoulder", true) or char:FindFirstChild("RightShoulder", true)
end
local function findJoint(char, ...)
    if not char then return nil end
    for _, n in ipairs({...}) do
        local j = char:FindFirstChild(n, true)
        if j and (j:IsA("Motor6D") or j:IsA("JointInstance")) then return j end
    end
end
local function collectEmoteJoints(char)
    if not char then return {} end
    return {
        shoulder = getRightShoulder(char),
        elbow    = findJoint(char, "RightElbow"),
        wrist    = findJoint(char, "RightWrist"),
        neck     = findJoint(char, "Neck"),
        torso    = findJoint(char, "Waist"),
    }
end
local function catmull(p0,p1,p2,p3,u)
    local u2,u3 = u*u, u*u*u
    return 0.5*((2*p1)+(-p0+p2)*u+(2*p0-5*p1+4*p2-p3)*u2+(-p0+3*p1-3*p2+p3)*u3)
end
local function sampleKeys(keys, t)
    local n = #keys
    if t <= keys[1][1] then return keys[1][2],keys[1][3],keys[1][4] end
    if t >= keys[n][1] then return keys[n][2],keys[n][3],keys[n][4] end
    for i=1,n-1 do
        local k1,k2 = keys[i],keys[i+1]
        if t>=k1[1] and t<=k2[1] then
            local k0=keys[math.max(i-1,1)]
            local k3=keys[math.min(i+2,n)]
            local u=(t-k1[1])/(k2[1]-k1[1])
            return catmull(k0[2],k1[2],k2[2],k3[2],u),
                   catmull(k0[3],k1[3],k2[3],k3[3],u),
                   catmull(k0[4],k1[4],k2[4],k3[4],u)
        end
    end
    return 0,0,0
end
local function applyJointRot(joint, cache, rx, ry, rz)
    if not joint or not joint.Parent then return end
    local c = cache[joint]
    if not c then
        local c0 = joint.C0
        local rc = c0 - c0.Position
        c = {rc=rc, rcInv=rc:Inverse()}; cache[joint] = c
    end
    local R = CFrame.Angles(math.rad(rx), math.rad(ry), math.rad(rz))
    joint.Transform = c.rcInv * R * c.rc
end
local function resetJoint(j) if j and j.Parent then j.Transform = CFrame.new() end end

local function playEmote()
    if emoteActive or flight.active then return end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local joints = collectEmoteJoints(char)
    if not joints.shoulder then return end
    emoteActive = true; emoteToken = emoteToken + 1
    local token = emoteToken
    local cache = {}
    local total = M.EK.SHOULDER[#M.EK.SHOULDER][1]
    local t0 = os.clock()
    local conns = {}
    local function finish()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        for _, j in pairs(joints) do resetJoint(j) end
        if token == emoteToken then emoteActive = false; lastMoveStateAnim = nil end
    end
    local function step()
        local t = (os.clock()-t0)*M.EK.SPEED
        if token ~= emoteToken or not joints.shoulder.Parent or hum.Health<=0 or t>=total then
            finish(); return
        end
        local sx,sy,sz = sampleKeys(M.EK.SHOULDER, t)
        applyJointRot(joints.shoulder, cache, sx,sy,sz)
        if joints.elbow then
            local ex,ey,ez = sampleKeys(M.EK.ELBOW, t)
            applyJointRot(joints.elbow, cache, ex,ey,ez)
        end
        if joints.wrist then
            local wx,wy,wz = sampleKeys(M.EK.WRIST, t)
            applyJointRot(joints.wrist, cache, wx,wy,wz)
        end
        if M.EK.HEAD_TRACK and joints.neck then
            local nx,ny,nz = sampleKeys(M.EK.NECK, t)
            applyJointRot(joints.neck, cache, nx,ny,nz)
        end
        if M.EK.TORSO_LEAN and joints.torso then
            local tx,ty,tz = sampleKeys(M.EK.TORSO, t)
            applyJointRot(joints.torso, cache, tx,ty,tz)
        end
    end
    table.insert(conns, RunService.Stepped:Connect(step))
    table.insert(conns, RunService.Heartbeat:Connect(step))
    table.insert(conns, RunService.RenderStepped:Connect(step))
    for _, c in ipairs(conns) do track(c) end
end

-- =====================================================================
-- СУСТАВЫ (R6 + R15)
-- =====================================================================
local rotCache = setmetatable({}, {__mode="k"})
local jointsCache = setmetatable({}, {__mode="k"})

local function smooth01(x) x = math.clamp(x,0,1); return x*x*(3-2*x) end

local function getBodyJoints(char)
    local c = jointsCache[char]
    if c and c.shoulderR and c.shoulderR.Parent then return c end
    c = {
        root      = findJoint(char, "RootJoint", "Root"),
        waist     = findJoint(char, "Waist"),
        neck      = findJoint(char, "Neck"),
        shoulderR = findJoint(char, "Right Shoulder", "RightShoulder"),
        shoulderL = findJoint(char, "Left Shoulder", "LeftShoulder"),
        elbowR    = findJoint(char, "RightElbow"),
        elbowL    = findJoint(char, "LeftElbow"),
        wristR    = findJoint(char, "RightWrist"),
        wristL    = findJoint(char, "LeftWrist"),
        hipR      = findJoint(char, "Right Hip", "RightHip"),
        hipL      = findJoint(char, "Left Hip", "LeftHip"),
        kneeR     = findJoint(char, "RightKnee"),
        kneeL     = findJoint(char, "LeftKnee"),
    }
    jointsCache[char] = c
    return c
end
local function rot(j, x, y, z)
    if j then applyJointRot(j, rotCache, x, y, z) end
end
local function getHeldGun(char)
    for _, gun in pairs(Guns) do
        if gun and gun.tool and gun.tool.Parent == char then return gun end
    end
    return nil
end
local function gunRaiseAmount()
    local dt = os.clock() - gunShotT
    if dt < 0 then return 0 end
    local UP, HOLD, DOWN = 0.12, 0.30, 0.35
    if dt < UP then return smooth01(dt/UP)
    elseif dt < UP+HOLD then return 1
    elseif dt < UP+HOLD+DOWN then return 1 - smooth01((dt-UP-HOLD)/DOWN)
    end
    return 0
end

-- =====================================================================
-- ПОЛЁТ: модель
-- =====================================================================
local flyModelSrc = nil
local function getFlyModelSrc()
    if flyModelSrc ~= nil then return flyModelSrc end
    local ok, m = pcall(loadAssetModel, M.FLY.ID)
    flyModelSrc = (ok and m) or false
    return flyModelSrc
end

local function buildFlyModel(hrp)
    local src = getFlyModelSrc()
    if not src then return nil end
    local cfg = getgenv().FlyModelConfig
    local model = src:Clone()
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
            or d:IsA("JointInstance") or d:IsA("WeldConstraint") then
            d:Destroy()
        end
    end
    local parts = {}
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then table.insert(parts, d) end
    end
    if #parts == 0 then model:Destroy(); return nil end
    model.Name = "MonoFlyModel"
    model.Parent = workspace
    for _, pt in ipairs(parts) do
        pt.Anchored = true; pt.CanCollide = false; pt.CanTouch = false; pt.CanQuery = false
        pt.Massless = true
    end
    pcall(function() model:ScaleTo(cfg.scale or 1) end)

    local primary, bestVol = parts[1], -1
    for _, pt in ipairs(parts) do
        local v = pt.Size.X * pt.Size.Y * pt.Size.Z
        if v > bestVol then bestVol = v; primary = pt end
    end
    pcall(function() model.PrimaryPart = primary end)

    local bbCF, bbSize = model:GetBoundingBox()
    local pivotToBB = model:GetPivot():ToObjectSpace(bbCF)

    local function computePivotInHrp()
        local c = getgenv().FlyModelConfig
        local depth = (math.abs(math.sin(math.rad(c.rotY or 0))) > 0.5) and bbSize.X or bbSize.Z
        local want = CFrame.new(c.offX or 0, c.offY or 0, (c.offZ or 0) - (depth/2 + (c.gap or 1.3)))
            * CFrame.Angles(math.rad(c.rotX or 0), math.rad(c.rotY or 0), math.rad(c.rotZ or 0))
        return want * pivotToBB:Inverse()
    end

    model:PivotTo(hrp.CFrame * computePivotInHrp())

    for _, pt in ipairs(parts) do
        if pt ~= primary then
            local w = Instance.new("Weld")
            w.Part0 = primary; w.Part1 = pt
            w.C0 = primary.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
            w.Parent = pt
        end
    end
    local hw = Instance.new("Weld")
    hw.Name = "MonoFlyWeld"
    hw.Part0 = hrp; hw.Part1 = primary
    hw.C0 = hrp.CFrame:ToObjectSpace(primary.CFrame); hw.C1 = CFrame.new()
    hw.Parent = primary
    for _, pt in ipairs(parts) do pt.Anchored = false end
    return model, {weld=hw, computePivotInHrp=computePivotInHrp}
end

-- =====================================================================
-- ★ ОБЩИЕ ЭФФЕКТЫ ВЗРЫВОВ (FXH)
-- =====================================================================
local FXH = {}
do
    local NSK = NumberSequenceKeypoint.new
    local GRAV = Vector3.new(0, -130, 0)
    local bodies = {}
    local stepConn = nil
    local ROCK_MATS = {
        Enum.Material.Slate, Enum.Material.Basalt, Enum.Material.Granite,
        Enum.Material.Concrete, Enum.Material.Rock,
    }

    local function rayParams()
        local ex = {getFxFolder()}
        if p.Character then table.insert(ex, p.Character) end
        for _, gun in pairs(Guns) do if gun and gun.tool then table.insert(ex, gun.tool) end end
        local fm = workspace:FindFirstChild("MonoFlyModel"); if fm then table.insert(ex, fm) end
        local af = workspace:FindFirstChild("MonoAntiFling"); if af then table.insert(ex, af) end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= p and pl.Character then table.insert(ex, pl.Character) end
        end
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = ex
        rp.IgnoreWater = true
        return rp
    end
    FXH.rayParams = rayParams

    local function anchorAt(pos, life)
        local a = Instance.new("Part")
        a.Anchored = true; a.CanCollide = false; a.CanTouch = false; a.CanQuery = false
        a.CastShadow = false; a.Transparency = 1; a.Size = Vector3.new(0.2,0.2,0.2)
        a.CFrame = CFrame.new(pos); a.Parent = getFxFolder()
        if life then task.delay(life, function() if a then a:Destroy() end end) end
        return a
    end
    FXH.anchorAt = anchorAt

    local function lifeFade(part, life)
        task.delay(life, function()
            if part and part.Parent then
                TweenService:Create(part, TweenInfo.new(1, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
                task.delay(1.05, function() if part then part:Destroy() end end)
            end
        end)
    end

    local function groundColor(hit)
        local c = Color3.fromRGB(125,122,118)
        local inst = hit and hit.Instance
        if inst and inst:IsA("BasePart") and not inst:IsA("Terrain") then
            c = c:Lerp(inst.Color, 0.55)
        end
        return c
    end

    local function step(dt)
        dt = math.min(dt, 0.05)
        if #bodies == 0 then
            if stepConn then stepConn:Disconnect(); stepConn = nil end
            return
        end
        local rp = rayParams()
        for i = #bodies, 1, -1 do
            local b = bodies[i]
            local part = b.part
            if not part or not part.Parent then
                table.remove(bodies, i)
            elseif not b.rest then
                b.vel = b.vel + GRAV*dt
                local sv = b.vel*dt
                local hit = nil
                if sv.Magnitude > 1e-4 then
                    hit = workspace:Raycast(b.pos, sv + sv.Unit*b.rad, rp)
                end
                if hit then
                    local n = hit.Normal
                    b.pos = hit.Position + n*(b.rad*0.9)
                    local vn = n*b.vel:Dot(n)
                    local vt = b.vel - vn
                    b.vel = vt*0.6 - vn*0.32
                    b.spin = b.spin*0.55
                    b.bounces = b.bounces + 1
                    if b.onImpact then
                        local f = b.onImpact; b.onImpact = nil
                        pcall(f, b, hit)
                    end
                    if b.vel.Magnitude < 8 or b.bounces >= 4 then
                        b.rest = true
                        local base = lookCF(b.pos, b.pos + n) * CFrame.Angles(-math.pi/2, 0, 0)
                        local restCF = base * CFrame.Angles(
                            (math.random()-0.5)*0.5, math.random()*6.283, (math.random()-0.5)*0.5)
                        part.CFrame = restCF + (-n*(b.rad*0.35))
                    else
                        b.rot = CFrame.Angles(b.spin.X*dt, b.spin.Y*dt, b.spin.Z*dt) * b.rot
                        part.CFrame = CFrame.new(b.pos) * b.rot
                    end
                else
                    b.pos = b.pos + sv
                    b.rot = CFrame.Angles(b.spin.X*dt, b.spin.Y*dt, b.spin.Z*dt) * b.rot
                    part.CFrame = CFrame.new(b.pos) * b.rot
                    if b.pos.Y < -500 then
                        table.remove(bodies, i); part:Destroy()
                    end
                end
            end
        end
    end

    function FXH.addBody(part, vel, spin, rad, life, onImpact)
        local cf = part.CFrame
        local b = {
            part = part, pos = cf.Position, rot = cf - cf.Position,
            vel = vel, spin = spin, rad = rad, bounces = 0, rest = false,
            onImpact = onImpact,
        }
        table.insert(bodies, b)
        if not stepConn then stepConn = RunService.Heartbeat:Connect(step) end
        lifeFade(part, life or 4)
    end

    function FXH.groundHit(pos, maxDist)
        local hit = workspace:Raycast(pos + Vector3.new(0,3,0),
            Vector3.new(0, -((maxDist or 20) + 3), 0), rayParams())
        if hit and hit.Normal.Y > 0.6 then return hit end
        return nil
    end

    function FXH.trail(part, dur, color, size)
        local e = Instance.new("ParticleEmitter")
        e.Rate = 40; e.Lifetime = NumberRange.new(0.5, 1.1)
        e.Speed = NumberRange.new(0.5, 3)
        e.SpreadAngle = Vector2.new(180, 180)
        e.Color = ColorSequence.new(color or Color3.fromRGB(80,76,72))
        e.Size = NumberSequence.new({NSK(0, size or 1), NSK(1, (size or 1)*3)})
        e.Transparency = NumberSequence.new({NSK(0, 0.5), NSK(1, 1)})
        e.LightInfluence = 1
        e.Parent = part
        task.delay(dur, function() if e and e.Parent then e.Enabled = false end end)
    end

    function FXH.shell(pos, color, material, startS, endS, dur, trStart, style)
        local s = Instance.new("Part")
        s.Shape = Enum.PartType.Ball; s.Anchored = true
        s.CanCollide = false; s.CanTouch = false; s.CanQuery = false; s.CastShadow = false
        s.Material = material or Enum.Material.Neon
        s.Color = color
        s.Transparency = trStart or 0
        s.Size = Vector3.new(startS, startS, startS)
        s.Position = pos
        s.Parent = getFxFolder()
        TweenService:Create(s, TweenInfo.new(dur, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = Vector3.new(endS, endS, endS), Transparency = 1}):Play()
        task.delay(dur + 0.1, function() if s then s:Destroy() end end)
        return s
    end

    function FXH.light(pos, color, brightness, range, dur)
        local a = anchorAt(pos, dur + 0.3)
        local l = Instance.new("PointLight")
        l.Color = color; l.Brightness = brightness; l.Range = range; l.Shadows = false
        l.Parent = a
        TweenService:Create(l, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Brightness = 0, Range = range*0.4}):Play()
    end

    function FXH.sound(pos, id, vol, maxDist)
        local a = anchorAt(pos, 10)
        local s = Instance.new("Sound")
        s.SoundId = id; s.Volume = vol or 3
        s.RollOffMaxDistance = maxDist or 600
        s.RollOffMode = Enum.RollOffMode.InverseTapered
        s.Parent = a
        s:Play()
    end

    function FXH.shake(pos, intensity, dur, maxDist)
        local cam = workspace.CurrentCamera
        local ref = cam and cam.CFrame.Position
        if not ref then
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            ref = hrp and hrp.Position
        end
        if not ref then return end
        local k = math.clamp(1 - (ref - pos).Magnitude/(maxDist or 200), 0, 1)
        if k > 0.02 then cameraShake(intensity*k, dur) end
    end

    function FXH.ring(center, color, maxR, dur, height, segs)
        segs = segs or 32
        local fx = getFxFolder()
        local parts = {}
        for i = 1, segs do
            local pt = Instance.new("Part")
            pt.Anchored = true; pt.CanCollide = false; pt.CanTouch = false; pt.CanQuery = false
            pt.CastShadow = false; pt.Material = Enum.Material.Neon; pt.Color = color
            pt.Transparency = 0.2; pt.Size = Vector3.new(1, height, 1)
            pt.Parent = fx
            parts[i] = pt
        end
        task.spawn(function()
            local t0 = os.clock()
            while true do
                local u = (os.clock() - t0)/dur
                if u >= 1 then break end
                local e = 1 - (1-u)^3
                local r = 2 + (maxR - 2)*e
                local segLen = (2*math.pi*r/segs)*1.2
                local th = math.max(height*(1 - u*0.6), 0.05)
                local thick = math.max(0.5, 2.4*(1-u))
                local tr = 0.2 + 0.8*(u^1.5)
                for i = 1, segs do
                    local a = (i/segs)*math.pi*2
                    local dir = Vector3.new(math.cos(a), 0, math.sin(a))
                    local pos = center + dir*r + Vector3.new(0, th*0.5, 0)
                    local pt = parts[i]
                    pt.Size = Vector3.new(segLen, th, thick)
                    pt.CFrame = CFrame.lookAt(pos, pos + dir)
                    pt.Transparency = tr
                end
                RunService.Heartbeat:Wait()
            end
            for _, pt in ipairs(parts) do pt:Destroy() end
        end)
    end

    function FXH.dust(hit, o)
        o = o or {}
        local power = o.power or 1
        local col = groundColor(hit):Lerp(Color3.fromRGB(190,180,165), 0.5)
        local a = anchorAt(hit.Position + Vector3.new(0, 0.5, 0), 5)
        local e = Instance.new("ParticleEmitter")
        e.Rate = 0
        e.Lifetime = NumberRange.new(1.3, 2.6)
        e.Speed = NumberRange.new(12*power, 36*power)
        e.SpreadAngle = Vector2.new(85, 85)
        e.Drag = 3
        e.Acceleration = Vector3.new(0, 2, 0)
        e.Color = ColorSequence.new(col)
        e.Size = NumberSequence.new({NSK(0, 2*power), NSK(1, 9*power)})
        e.Transparency = NumberSequence.new({NSK(0, 0.45), NSK(0.6, 0.72), NSK(1, 1)})
        e.Rotation = NumberRange.new(0, 360)
        e.RotSpeed = NumberRange.new(-40, 40)
        e.LightInfluence = 1
        e.Parent = a
        e:Emit(o.count or 40)
    end

    function FXH.spawnRocks(hit, o)
        o = o or {}
        local count = o.count or 22
        local power = o.power or 1
        local life = o.life or 4
        local sizeMul = o.sizeMul or 1
        local spread = o.spread or 1
        local gp = hit.Position
        local gcol = groundColor(hit)
        if o.greyer then
            local grey = (gcol.R + gcol.G + gcol.B) / 3
            gcol = Color3.new(grey, grey, grey):Lerp(Color3.fromRGB(160,158,155), 0.5)
        end
        local dustCol = Color3.fromRGB(95,90,84)
        local fx = getFxFolder()
        for _ = 1, count do
            local big = math.random() < 0.2
            local sz = (big and (1.3 + math.random()*1.5) or (0.35 + math.random()*0.85)) * sizeMul
            local part = Instance.new((math.random() < 0.3) and "WedgePart" or "Part")
            part.Name = "MonoRock"
            part.Anchored = true; part.CanCollide = false; part.CanTouch = false; part.CanQuery = false
            part.CastShadow = big
            part.Material = ROCK_MATS[math.random(1, #ROCK_MATS)]
            local shade = o.greyer and (1.00 + math.random()*0.35) or (0.72 + math.random()*0.5)
            part.Color = Color3.new(
                math.clamp(gcol.R*shade, 0, 1), math.clamp(gcol.G*shade, 0, 1), math.clamp(gcol.B*shade, 0, 1))
            part.Size = Vector3.new(sz, sz*(0.45 + math.random()*0.6), sz*(0.65 + math.random()*0.7))
            part.CFrame = CFrame.new(gp + Vector3.new(
                    (math.random()-0.5)*3*spread, 0.8 + math.random()*0.8, (math.random()-0.5)*3*spread))
                * CFrame.Angles(math.random()*6.283, math.random()*6.283, math.random()*6.283)
            part.Parent = fx
            local ang = math.random()*math.pi*2
            local h = (7 + math.random()*26) * power * (big and 0.7 or 1)
            local up = (26 + math.random()*38) * power * (big and 0.85 or 1)
            local vel = Vector3.new(math.cos(ang)*h, up, math.sin(ang)*h)
            local spin = Vector3.new((math.random()-0.5)*16, (math.random()-0.5)*16, (math.random()-0.5)*16)
            local rad = math.max(part.Size.X, part.Size.Y, part.Size.Z)*0.38
            FXH.addBody(part, vel, spin, rad, life + math.random()*0.6)
            if big then FXH.trail(part, 1.4, dustCol, sz*0.9) end
        end
    end

    function FXH.spawnPebbles(hit, radius, count, life, o)
        o = o or {}
        task.delay(0.1, function()
            local rp = rayParams()
            local gp = hit.Position
            local gcol = groundColor(hit)
            if o.greyer then
                local grey = (gcol.R + gcol.G + gcol.B) / 3
                gcol = Color3.new(grey, grey, grey):Lerp(Color3.fromRGB(155,153,150), 0.5)
            end
            local fx = getFxFolder()
            for _ = 1, count do
                local ang = math.random()*math.pi*2
                local r = radius*(0.2 + math.sqrt(math.random())*0.9)
                local from = gp + Vector3.new(math.cos(ang)*r, 4, math.sin(ang)*r)
                local h = workspace:Raycast(from, Vector3.new(0, -10, 0), rp)
                if h and h.Normal.Y > 0.6 then
                    local sz = 0.15 + math.random()*0.45
                    local pb = Instance.new("Part")
                    pb.Name = "MonoPebble"
                    pb.Anchored = true; pb.CanCollide = false; pb.CanTouch = false; pb.CanQuery = false
                    pb.CastShadow = false
                    pb.Material = ROCK_MATS[math.random(1, #ROCK_MATS)]
                    local shade = o.greyer and (1.00 + math.random()*0.35) or (0.7 + math.random()*0.5)
                    pb.Color = Color3.new(
                        math.clamp(gcol.R*shade, 0, 1), math.clamp(gcol.G*shade, 0, 1), math.clamp(gcol.B*shade, 0, 1))
                    pb.Size = Vector3.new(sz, sz*(0.5 + math.random()*0.5), sz*(0.7 + math.random()*0.6))
                    pb.CFrame = lookCF(h.Position, h.Position + h.Normal) * CFrame.Angles(-math.pi/2, 0, 0)
                        * CFrame.Angles((math.random()-0.5)*0.6, math.random()*6.283, (math.random()-0.5)*0.6)
                        + h.Normal*(sz*0.12)
                    pb.Parent = fx
                    lifeFade(pb, life + math.random()*0.8)
                end
            end
        end)
    end
end

-- =====================================================================
-- ★ ВЗРЫВ ДРОНА ПОСЛЕ [Q] (без ударных волн)
-- =====================================================================
local function flyExplosion(model)
    if not model or not model.Parent then return end
    local okPivot, cf = pcall(function() return model:GetPivot() end)
    if not okPivot or not cf then return end
    local pos = cf.Position
    local fx = getFxFolder()
    local NSK = NumberSequenceKeypoint.new
    local CSK = ColorSequenceKeypoint.new

    FXH.sound(pos, M.SND.EXPLOSION, 3.5, 800)
    FXH.light(pos, Color3.fromRGB(255,170,70), 18, 95, 0.7)

    FXH.shell(pos, Color3.fromRGB(255,252,230), Enum.Material.Neon, 3, 16, 0.16, 0)
    FXH.shell(pos, Color3.fromRGB(255,150,40), Enum.Material.Neon, 4, 27, 0.5, 0.1)
    task.delay(0.04, function()
        FXH.shell(pos + Vector3.new(0, 1.5, 0), Color3.fromRGB(255,75,18), Enum.Material.Neon, 2, 19, 0.55, 0.3)
    end)
    for i = 1, 6 do
        task.delay(0.03*i + math.random()*0.03, function()
            FXH.shell(pos + randUnit()*(3 + math.random()*5),
                (i % 2 == 0) and Color3.fromRGB(255,90,25) or Color3.fromRGB(255,195,90),
                Enum.Material.Neon, 1.5, 6 + math.random()*4, 0.4, 0.25)
        end)
    end

    local la = FXH.anchorAt(pos, 6)

    local sparks = Instance.new("ParticleEmitter")
    sparks.Rate = 0; sparks.Lifetime = NumberRange.new(0.6, 1.5)
    sparks.Speed = NumberRange.new(40, 110)
    sparks.SpreadAngle = Vector2.new(180, 180)
    sparks.Acceleration = Vector3.new(0, -60, 0)
    sparks.Drag = 0.5
    sparks.LightEmission = 1; sparks.LightInfluence = 0
    pcall(function() sparks.Orientation = Enum.ParticleOrientation.VelocityParallel end)
    sparks.Color = ColorSequence.new(Color3.fromRGB(255,235,150), Color3.fromRGB(255,70,15))
    sparks.Size = NumberSequence.new({NSK(0, 0.55), NSK(1, 0)})
    sparks.Transparency = NumberSequence.new({NSK(0, 0), NSK(1, 1)})
    sparks.Parent = la

    local fireP = Instance.new("ParticleEmitter")
    fireP.Rate = 0; fireP.Lifetime = NumberRange.new(0.3, 0.75)
    fireP.Speed = NumberRange.new(18, 52)
    fireP.SpreadAngle = Vector2.new(180, 180)
    fireP.Drag = 3
    fireP.LightEmission = 1; fireP.LightInfluence = 0
    fireP.Rotation = NumberRange.new(0, 360)
    fireP.Color = ColorSequence.new({
        CSK(0, Color3.fromRGB(255,245,200)),
        CSK(0.5, Color3.fromRGB(240,100,20)),
        CSK(1, Color3.fromRGB(70,25,10)),
    })
    fireP.Size = NumberSequence.new({NSK(0, 3), NSK(0.4, 6), NSK(1, 1)})
    fireP.Transparency = NumberSequence.new({NSK(0, 0.1), NSK(0.5, 0.45), NSK(1, 1)})
    fireP.Parent = la

    local smoke = Instance.new("ParticleEmitter")
    smoke.Rate = 0; smoke.Lifetime = NumberRange.new(2.5, 4.5)
    smoke.Speed = NumberRange.new(6, 22)
    smoke.SpreadAngle = Vector2.new(180, 180)
    smoke.Acceleration = Vector3.new(0, 5, 0)
    smoke.Drag = 1.5
    smoke.LightInfluence = 1
    smoke.Rotation = NumberRange.new(0, 360)
    smoke.RotSpeed = NumberRange.new(-30, 30)
    smoke.Color = ColorSequence.new(Color3.fromRGB(62,58,54), Color3.fromRGB(24,24,24))
    smoke.Size = NumberSequence.new({NSK(0, 5), NSK(1, 21)})
    smoke.Transparency = NumberSequence.new({NSK(0, 0.35), NSK(0.5, 0.65), NSK(1, 1)})
    smoke.Parent = la

    local embers = Instance.new("ParticleEmitter")
    embers.Rate = 0; embers.Lifetime = NumberRange.new(1.5, 3)
    embers.Speed = NumberRange.new(5, 22)
    embers.SpreadAngle = Vector2.new(180, 180)
    embers.Acceleration = Vector3.new(0, 8, 0)
    embers.Drag = 1
    embers.LightEmission = 1; embers.LightInfluence = 0
    embers.Color = ColorSequence.new(Color3.fromRGB(255,170,60), Color3.fromRGB(255,60,10))
    embers.Size = NumberSequence.new({NSK(0, 0.3), NSK(1, 0)})
    embers.Transparency = NumberSequence.new({NSK(0, 0), NSK(0.8, 0.3), NSK(1, 1)})
    embers.Parent = la

    pcall(function()
        sparks:Emit(95)
        fireP:Emit(55)
        smoke:Emit(34)
        embers:Emit(32)
    end)

    local count = 0
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") and count < 16 then
            count = count + 1
            local c = d:Clone()
            for _, ch in ipairs(c:GetChildren()) do
                if not (ch:IsA("DataModelMesh") or ch:IsA("Decal") or ch:IsA("SurfaceAppearance")) then
                    ch:Destroy()
                end
            end
            c.Anchored = true; c.CanCollide = false; c.CanTouch = false; c.CanQuery = false
            c.CastShadow = false; c.Massless = true
            c.CFrame = d.CFrame
            c.Parent = fx
            local dir = d.Position - pos
            if dir.Magnitude < 0.1 then dir = randUnit() end
            dir = (dir.Unit + Vector3.new(0, 0.6, 0) + randUnit()*0.4).Unit
            local vel = dir*(30 + math.random()*45)
            local spin = Vector3.new((math.random()-0.5)*20, (math.random()-0.5)*20, (math.random()-0.5)*20)
            local rad = math.clamp(d.Size.Magnitude*0.25, 0.3, 2.5)
            FXH.addBody(c, vel, spin, rad, 4.5)
            FXH.trail(c, 1.6, Color3.fromRGB(45,43,41), math.clamp(rad*1.3, 0.8, 2.5))
        end
    end

    local gh = FXH.groundHit(pos, 24)
    if gh then
        local h = pos.Y - gh.Position.Y
        local k = math.clamp(1 - h/28, 0.15, 1)
        FXH.dust(gh, {count = math.floor(45*k) + 8, power = 1})
        FXH.spawnRocks(gh, {count = math.floor(24*k) + 4, power = 1, life = 4})
        FXH.spawnPebbles(gh, 8, math.floor(20*k) + 4, 4)
    end

    FXH.shake(pos, 1.3, 0.8, 220)
    return pos
end

local function applyFlightPose(char)
    local J = getBodyJoints(char)
    local cfg = getgenv().FlyModelConfig
    local t = os.clock()
    local b = smooth01((t - flight.t0)/0.35)
    local sp = math.clamp(flight.vel.Magnitude / M.FLY.FAST, 0, 1)
    local lean = (cfg.lean + sp*12) * b
    local trem = math.sin(t*13) * (cfg.grip or 2.5) * (0.4 + sp)
    local sway = math.sin(t*2.2) * 1.2

    rot(J.root,  -lean, 0, 0)
    rot(J.waist, 6*b, 0, 0)
    rot(J.neck,  lean*0.9 + 6*b, 0, 0)

    rot(J.shoulderR, (cfg.armX + trem + sway)*b, 0, -cfg.armZ*b)
    rot(J.shoulderL, (cfg.armX - trem - sway)*b, 0,  cfg.armZ*b)
    rot(J.elbowR, (cfg.elbow - trem)*b, 0, 0)
    rot(J.elbowL, (cfg.elbow + trem)*b, 0, 0)
    rot(J.wristR, -22*b, 0, 0)
    rot(J.wristL, -22*b, 0, 0)

    rot(J.hipR, (cfg.legFwd + trem*0.7)*b, 0,  cfg.legSpread*b)
    rot(J.hipL, (cfg.legFwd - trem*0.7)*b, 0, -cfg.legSpread*b)
    rot(J.kneeR, -(cfg.kneeBend + trem)*b, 0, 0)
    rot(J.kneeL, -(cfg.kneeBend - trem)*b, 0, 0)
end

local function stopFlight(silent)
    if not flight.active and not flight.model then return end
    flight.active = false
    if flight.conn then pcall(function() flight.conn:Disconnect() end); flight.conn = nil end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    local explodePos = nil
    if not silent and flight.model and flight.model.Parent then
        local okE, posE = pcall(flyExplosion, flight.model)
        if okE then explodePos = posE end
    end

    for _, k in ipairs({"lv","ao","att","model"}) do
        local o = flight[k]
        if o then pcall(function() o:Destroy() end); flight[k] = nil end
    end
    flight.weld = nil; flight.computePivotInHrp = nil
    if char then
        local J = getBodyJoints(char)
        for _, j in pairs(J) do resetJoint(j) end
    end
    if hum and hum.Parent then
        hum.PlatformStand = false
        hum.AutoRotate = true
        if hum.Health > 0 then pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
    end
    if hrp and hrp.Parent then
        local lv = hrp.CFrame.LookVector
        local flat = Vector3.new(lv.X, 0, lv.Z)
        if flat.Magnitude < 0.01 then flat = Vector3.new(0,0,-1) end
        hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat.Unit)
        hrp.AssemblyAngularVelocity = Vector3.zero
        if explodePos then
            local away = hrp.Position - explodePos
            if away.Magnitude < 0.1 then away = -flat end
            hrp.AssemblyLinearVelocity = away.Unit*26 + Vector3.new(0, 16, 0)
        end
    end
    flight.vel = Vector3.zero
    lastMoveStateAnim = nil
    if not silent then notify("Полёт", "ВЫКЛ [Q] · БАБАХ!") end
end
getgenv().hardStopFlight = function() stopFlight(true) end

local function startFlight()
    if flight.active then return end
    if getgenv().ShatterActive then return end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return end
    if hum.SeatPart then hum.Sit = false end
    pcall(function() hum:UnequipTools() end)
    emoteToken = emoteToken + 1; emoteActive = false

    local model, meta = buildFlyModel(hrp)
    if not model then notify("Полёт", "Модель не загрузилась"); return end
    flight.model = model
    if meta then flight.weld = meta.weld; flight.computePivotInHrp = meta.computePivotInHrp end

    local att = Instance.new("Attachment"); att.Name = "MonoFlyAtt"; att.Parent = hrp
    local lv = Instance.new("LinearVelocity")
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Parent = hrp
    local ao = Instance.new("AlignOrientation")
    ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
    ao.Attachment0 = att
    ao.RigidityEnabled = false
    ao.MaxTorque = math.huge
    ao.MaxAngularVelocity = math.huge
    ao.Responsiveness = 50
    local lk0 = hrp.CFrame.LookVector
    local f0 = Vector3.new(lk0.X, 0, lk0.Z)
    if f0.Magnitude < 0.01 then f0 = Vector3.new(0,0,-1) end
    ao.CFrame = CFrame.lookAt(Vector3.zero, f0.Unit)
    ao.Parent = hrp
    flight.att, flight.lv, flight.ao = att, lv, ao

    hum.PlatformStand = true
    hum.AutoRotate = false
    flight.vel = Vector3.zero
    flight.t0 = os.clock()
    flight.active = true
    lastMoveStateAnim = nil
    notify("Полёт", "ВКЛ · WASD · Space/Ctrl · Shift · [Q] выкл (взрыв)")

    flight.conn = RunService.Heartbeat:Connect(function(dt)
        if not flight.active then return end
        local ch = p.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not ch or not h or not root or not root.Parent or h.Health <= 0
            or not flight.model or not flight.model.Parent or not flight.lv or not flight.lv.Parent then
            stopFlight(true); return
        end
        if flight.weld and flight.weld.Parent and flight.computePivotInHrp then
            flight.weld.C0 = flight.computePivotInHrp()
        end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local look = cam.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude < 0.01 then
            local rl = root.CFrame.LookVector
            flat = Vector3.new(rl.X, 0, rl.Z)
            if flat.Magnitude < 0.01 then flat = Vector3.new(0,0,-1) end
        end
        flat = flat.Unit
        local right = flat:Cross(Vector3.new(0,1,0))
        local f, s, v = 0, 0, 0
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then f = f + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then f = f - 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then s = s + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then s = s - 1 end
        if f == 0 and s == 0 then
            local md = h.MoveDirection
            if md.Magnitude > 0.1 then f = md:Dot(flat); s = md:Dot(right) end
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v = v + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then v = v - 1 end
        local dir = look*f + right*s + Vector3.new(0, v, 0)
        if dir.Magnitude > 1 then dir = dir.Unit end
        local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and M.FLY.FAST or M.FLY.SPEED
        local vertOnly = Vector3.new(0, v*M.FLY.VERT, 0)
        local target = Vector3.new(dir.X*speed, 0, dir.Z*speed) + Vector3.new(0, dir.Y*speed, 0)
        if f == 0 and s == 0 then target = vertOnly end
        flight.vel = flight.vel:Lerp(target, math.clamp(dt*6, 0, 1))
        flight.lv.VectorVelocity = flight.vel
        if flight.ao and flight.ao.Parent then
            flight.ao.CFrame = CFrame.lookAt(Vector3.zero, flat)
        end
    end)
    track(flight.conn)
end

local function toggleFlight()
    if flight.active then stopFlight(false) else startFlight() end
end
getgenv().toggleFlight = toggleFlight

-- =====================================================================
-- ★ КИНО-БОМБА v21 (без зума и без текста на экране)
-- =====================================================================
do
    local NSK = NumberSequenceKeypoint.new
    local CSK = ColorSequenceKeypoint.new

    local BOMB = {
        id = "rbxassetid://81798377551721",
        scale = 1.6,
        throwSpeed = 24,
        upBoost = 7,
        fuse = 3,
        dropFuse = 4.2,
        portalHeight = 34,
        rollDamping = 0.55,
        maxRollSpeed = 20,
        blastRadius = 38,
        shatterRadius = 30,
    }
    getgenv().BombConfig = BOMB
    if getgenv().BombCine == nil then getgenv().BombCine = true end

    local GREEN   = Color3.fromRGB(90, 255, 130)
    local GREEN_L = Color3.fromRGB(190, 255, 210)
    local GREEN_D = Color3.fromRGB(8, 60, 28)
    local PURPLE   = Color3.fromRGB(165, 50, 255)
    local PURPLE_L = Color3.fromRGB(215, 150, 255)
    local PURPLE_D = Color3.fromRGB(85, 15, 150)
    local WHITE    = Color3.fromRGB(250, 235, 255)
    local SMOKE_TEX = "rbxasset://textures/particles/smoke_main.dds"

    local busy = false

    local ease = {
        out = function(x) x = math.clamp(x, 0, 1); return 1 - (1 - x)^3 end,
        inOut = function(x)
            x = math.clamp(x, 0, 1)
            if x < 0.5 then return 4*x*x*x end
            return 1 - ((-2*x + 2)^3)/2
        end,
        back = function(x)
            x = math.clamp(x, 0, 1)
            local c1 = 1.70158; local c3 = c1 + 1
            return 1 + c3*(x-1)^3 + c1*(x-1)^2
        end,
    }

    -- КАМЕРА
    local CINE = {
        active = false, skip = false,
        cf = CFrame.new(), fov = 70,
        shakeAmp = 0, shakeT0 = 0, shakeDur = 0,
        punchAmt = 0, punchT0 = 0, punchDur = 0.4,
        saved = nil,
    }

    function CINE.shake(amp, dur)
        CINE.shakeAmp = amp; CINE.shakeT0 = os.clock(); CINE.shakeDur = dur
    end
    function CINE.punch(amt, dur)
        CINE.punchAmt = amt; CINE.punchT0 = os.clock(); CINE.punchDur = dur or 0.4
    end

    function CINE.begin()
        if CINE.active then return false end
        local cam = workspace.CurrentCamera
        if not cam then return false end
        CINE.saved = {type = cam.CameraType, cf = cam.CFrame, fov = cam.FieldOfView}
        CINE.cf = cam.CFrame; CINE.fov = cam.FieldOfView
        CINE.shakeDur = 0; CINE.punchAmt = 0
        CINE.skip = false
        CINE.active = true
        cam.CameraType = Enum.CameraType.Scriptable
        pcall(function() RunService:UnbindFromRenderStep("MonoCine") end)
        RunService:BindToRenderStep("MonoCine", Enum.RenderPriority.Camera.Value + 2, function()
            local c = workspace.CurrentCamera
            if not c or not CINE.active then return end
            c.CameraType = Enum.CameraType.Scriptable
            local sh = CFrame.new()
            local el = os.clock() - CINE.shakeT0
            if el < CINE.shakeDur then
                local k = ((1 - el/CINE.shakeDur)^2) * CINE.shakeAmp
                sh = CFrame.new((math.random()-0.5)*k*0.12, (math.random()-0.5)*k*0.12, 0)
                    * CFrame.Angles((math.random()-0.5)*k*0.006, (math.random()-0.5)*k*0.006, (math.random()-0.5)*k*0.01)
            end
            c.CFrame = CINE.cf * sh
            -- FOV зафиксирован: без зума
            c.FieldOfView = CINE.saved and CINE.saved.fov or 70
        end)
        return true
    end

    function CINE.finish()
        if not CINE.active then return end
        CINE.active = false
        pcall(function() RunService:UnbindFromRenderStep("MonoCine") end)
        local cam = workspace.CurrentCamera
        if cam then
            cam.CameraType = Enum.CameraType.Custom
            if CINE.saved then cam.FieldOfView = CINE.saved.fov end
            local ch = p.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end
    end

    function CINE.tween(toCF, toFov, dur, fn)
        fn = fn or ease.inOut
        local fromCF = CINE.cf
        local t0 = os.clock()
        while CINE.active do
            local d = CINE.skip and 0.2 or dur
            local u = (os.clock() - t0)/d
            if u >= 1 then break end
            local e = fn(u)
            CINE.cf = fromCF:Lerp(toCF, e)
            -- FOV игнорируется (без зума)
            RunService.RenderStepped:Wait()
        end
        if CINE.active then CINE.cf = toCF end
    end

    function CINE.run(dur, fn)
        local t0 = os.clock()
        local dt = 1/60
        while CINE.active and not CINE.skip do
            local u = (os.clock() - t0)/dur
            if u >= 1 then fn(1, dt); break end
            fn(u, dt)
            dt = RunService.RenderStepped:Wait()
        end
    end

    -- ОВЕРЛЕЙ (текст отключён)
    local function makeOverlay()
        local noop = function() end
        local stub = {bars = noop, lines = noop, text = noop, flash = noop, destroy = noop}
        local pg = p:FindFirstChild("PlayerGui")
        if not pg then return stub end
        local old = pg:FindFirstChild("MonoCineGui"); if old then old:Destroy() end
        local g = Instance.new("ScreenGui")
        g.Name = "MonoCineGui"; g.IgnoreGuiInset = true; g.ResetOnSpawn = false
        g.DisplayOrder = 900; g.Parent = pg

        local function bar(top)
            local f = Instance.new("Frame")
            f.BackgroundColor3 = Color3.new(0,0,0); f.BorderSizePixel = 0
            f.AnchorPoint = Vector2.new(0, top and 0 or 1)
            f.Position = UDim2.fromScale(0, top and 0 or 1)
            f.Size = UDim2.fromScale(1, 0); f.ZIndex = 10; f.Parent = g
            return f
        end
        local ov = {gui = g, top = bar(true), bot = bar(false)}

        function ov.bars(on, dur)
            local sz = UDim2.fromScale(1, on and 0.12 or 0)
            local ti = TweenInfo.new(dur or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(ov.top, ti, {Size = sz}):Play()
            TweenService:Create(ov.bot, ti, {Size = sz}):Play()
        end

        function ov.flash(color, alpha, dur)
            local f = Instance.new("Frame")
            f.Size = UDim2.fromScale(1,1); f.BorderSizePixel = 0
            f.BackgroundColor3 = color or Color3.new(1,1,1)
            f.BackgroundTransparency = 1 - (alpha or 0.8); f.ZIndex = 30; f.Parent = g
            TweenService:Create(f, TweenInfo.new(dur or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 1}):Play()
            task.delay((dur or 0.4) + 0.1, function() if f then f:Destroy() end end)
        end

        -- заглушка: никакого текста на экране
        function ov.text() end

        function ov.lines(dur, color)
            local N = 30
            local fr = {}
            for i = 1, N do
                local f = Instance.new("Frame")
                f.AnchorPoint = Vector2.new(0.5, 0.5); f.BorderSizePixel = 0
                f.BackgroundColor3 = color or Color3.new(1,1,1); f.ZIndex = 5; f.Parent = g
                fr[i] = {f = f, a = (i/N)*math.pi*2 + math.random()*0.1,
                    r0 = 0.28 + math.random()*0.14, len = 0.18 + math.random()*0.28}
            end
            task.spawn(function()
                local t0 = os.clock()
                while true do
                    local u = (os.clock() - t0)/dur
                    if u >= 1 or not g.Parent then break end
                    local vs = g.AbsoluteSize
                    local m = math.max(vs.X, vs.Y)
                    for _, l in ipairs(fr) do
                        local r = (l.r0 + u*0.35) * (0.85 + math.random()*0.3) * m
                        local len = l.len * m * (1 - u*0.5)
                        l.f.Position = UDim2.fromOffset(vs.X/2 + math.cos(l.a)*r, vs.Y/2 + math.sin(l.a)*r)
                        l.f.Size = UDim2.fromOffset(len, 2 + math.random()*3)
                        l.f.Rotation = math.deg(l.a)
                        l.f.BackgroundTransparency = 0.15 + u*0.85
                    end
                    RunService.RenderStepped:Wait()
                end
                for _, l in ipairs(fr) do if l.f then l.f:Destroy() end end
            end)
        end

        function ov.destroy() if g then g:Destroy() end end
        return ov
    end

    -- ПОСТ-ЭФФЕКТЫ
    local function impactFrame(k)
        pcall(function()
            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "MonoImpactCC"
            cc.Saturation = -1; cc.Contrast = 1.4*k; cc.Brightness = 0.18*k
            cc.Parent = Lighting
            task.delay(0.1, function()
                if not cc.Parent then return end
                TweenService:Create(cc, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Saturation = 0, Contrast = 0, Brightness = 0}):Play()
                task.delay(0.45, function() if cc then cc:Destroy() end end)
            end)
        end)
    end

    local function postFx(k)
        pcall(function()
            local bl = Instance.new("BloomEffect")
            bl.Intensity = 2.4*k; bl.Size = 42; bl.Threshold = 0.7; bl.Parent = Lighting
            TweenService:Create(bl, TweenInfo.new(2.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Intensity = 0}):Play()
            task.delay(2.6, function() if bl then bl:Destroy() end end)

            local sr = Instance.new("SunRaysEffect")
            sr.Intensity = 0.5*k; sr.Spread = 1; sr.Parent = Lighting
            TweenService:Create(sr, TweenInfo.new(2.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Intensity = 0}):Play()
            task.delay(2.2, function() if sr then sr:Destroy() end end)

            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "MonoBombCC"
            cc.TintColor = Color3.fromRGB(215, 160, 255)
            cc.Brightness = 0.35*k; cc.Contrast = 0.2*k; cc.Saturation = 0.2*k
            cc.Parent = Lighting
            TweenService:Create(cc, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Brightness = 0, Contrast = 0, Saturation = 0, TintColor = Color3.new(1,1,1)}):Play()
            task.delay(1.8, function() if cc then cc:Destroy() end end)

            local pg = p:FindFirstChild("PlayerGui")
            if pg and k > 0.2 then
                local g = Instance.new("ScreenGui")
                g.IgnoreGuiInset = true; g.ResetOnSpawn = false; g.DisplayOrder = 999; g.Parent = pg
                local f = Instance.new("Frame")
                f.Size = UDim2.fromScale(1,1); f.BorderSizePixel = 0
                f.BackgroundColor3 = Color3.fromRGB(240, 215, 255)
                f.BackgroundTransparency = 1 - 0.9*k; f.Parent = g
                task.delay(0.1, function()
                    TweenService:Create(f, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundTransparency = 1}):Play()
                end)
                task.delay(1.3, function() if g then g:Destroy() end end)
            end
        end)
    end

    -- ЧАСТИЦЫ
    local function mkEmitter(parent, o)
        local e = Instance.new("ParticleEmitter")
        e.Rate = 0
        e.Lifetime = NumberRange.new(o.life[1], o.life[2])
        e.Speed = NumberRange.new(o.speed[1], o.speed[2])
        e.SpreadAngle = o.spread or Vector2.new(180, 180)
        e.Drag = o.drag or 0
        e.Acceleration = o.acc or Vector3.zero
        e.LightEmission = o.emit or 0
        e.LightInfluence = o.inf or 0
        e.Rotation = NumberRange.new(0, 360)
        local rs = o.rot or 0
        e.RotSpeed = NumberRange.new(-rs, rs)
        if o.tex then e.Texture = o.tex end
        e.Color = o.color
        e.Size = o.size
        e.Transparency = o.trans
        if o.vp then pcall(function() e.Orientation = Enum.ParticleOrientation.VelocityParallel end) end
        e.Parent = parent
        return e
    end

    -- КАМНИ
    local ROCKS = {
        Enum.Material.Slate, Enum.Material.Basalt, Enum.Material.Granite,
        Enum.Material.Concrete, Enum.Material.Rock, Enum.Material.Cobblestone,
    }

    local function dustPuff(pos, size)
        local a = FXH.anchorAt(pos, 3)
        local e = mkEmitter(a, {
            life = {0.8, 1.6}, speed = {2, 8}, drag = 2, acc = Vector3.new(0, 1.5, 0),
            tex = SMOKE_TEX, inf = 1,
            color = ColorSequence.new(Color3.fromRGB(150, 145, 138)),
            size = NumberSequence.new({NSK(0, size), NSK(1, size*3.2)}),
            trans = NumberSequence.new({NSK(0, 0.55), NSK(1, 1)}),
            rot = 40,
        })
        e:Emit(5)
    end

    function FXH.spawnBoulders(hit, o)
        o = o or {}
        local count = o.count or 60
        local power = o.power or 1
        local life = o.life or 4
        local sizeMul = o.sizeMul or 1
        local spread = o.spread or 1
        local gp = hit.Position
        local gcol = Color3.fromRGB(125, 122, 118)
        local inst = hit.Instance
        if inst and inst:IsA("BasePart") then gcol = gcol:Lerp(inst.Color, 0.5) end
        if o.greyer then
            local gr = (gcol.R + gcol.G + gcol.B)/3
            gcol = Color3.new(gr, gr, gr):Lerp(Color3.fromRGB(165, 162, 158), 0.5)
        end
        local fx = getFxFolder()
        for _ = 1, count do
            local big = math.random() < 0.18
            local sz = (big and (1.6 + math.random()*2.2) or (0.5 + math.random()*1.1)) * sizeMul
            local kind = math.random(1, 4)
            local part
            if kind == 1 then part = Instance.new("WedgePart")
            elseif kind == 2 then part = Instance.new("CornerWedgePart")
            else part = Instance.new("Part") end
            part.Name = "MonoRock"
            part.Anchored = true; part.CanCollide = false; part.CanTouch = false; part.CanQuery = false
            part.CastShadow = big
            part.Material = ROCKS[math.random(1, #ROCKS)]
            local shade = o.greyer and (1.0 + math.random()*0.35) or (0.7 + math.random()*0.55)
            local rockCol = Color3.new(
                math.clamp(gcol.R*shade, 0, 1), math.clamp(gcol.G*shade, 0, 1), math.clamp(gcol.B*shade, 0, 1))
            part.Color = rockCol
            part.Size = Vector3.new(sz*(0.7 + math.random()*0.8), sz*(0.5 + math.random()*0.7), sz*(0.7 + math.random()*0.8))
            if kind == 4 then
                local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = part
            end
            part.CFrame = CFrame.new(gp + Vector3.new(
                    (math.random()-0.5)*4*spread, 0.8 + math.random()*1.0, (math.random()-0.5)*4*spread))
                * CFrame.Angles(math.random()*6.283, math.random()*6.283, math.random()*6.283)
            part.Parent = fx

            local hot = math.random() < 0.35
            if hot then
                part.Material = Enum.Material.Neon
                part.Color = (math.random() < 0.5) and PURPLE_L or Color3.fromRGB(255, 190, 120)
                TweenService:Create(part, TweenInfo.new(1.3, Enum.EasingStyle.Quad), {Color = rockCol}):Play()
                task.delay(1.3, function()
                    if part and part.Parent then part.Material = ROCKS[math.random(1, #ROCKS)] end
                end)
                FXH.trail(part, 1.3, Color3.fromRGB(70, 55, 85), math.clamp(sz*0.8, 0.5, 2))
            end

            local ang = math.random()*math.pi*2
            local h = (10 + math.random()*45) * power * (big and 0.6 or 1)
            local up = (30 + math.random()*55) * power * (big and 0.8 or 1)
            local vel = Vector3.new(math.cos(ang)*h, up, math.sin(ang)*h)
            local spin = Vector3.new((math.random()-0.5)*18, (math.random()-0.5)*18, (math.random()-0.5)*18)
            local rad = math.max(part.Size.X, part.Size.Y, part.Size.Z)*0.38
            local onImpact = nil
            if big then onImpact = function(_, h2) dustPuff(h2.Position, 2) end end
            FXH.addBody(part, vel, spin, rad, life + math.random()*0.8, onImpact)
            if big and not hot then FXH.trail(part, 1.2, Color3.fromRGB(95, 90, 84), sz*0.7) end
        end
    end

    -- ВЗРЫВ
    local bombSrcCache = nil
    local function getBombSrc()
        if bombSrcCache ~= nil then return bombSrcCache end
        local ok, m = pcall(loadAssetModel, BOMB.id)
        bombSrcCache = (ok and m) or false
        return bombSrcCache
    end
    local function buildBombVisual()
        local src = getBombSrc()
        if not src then return nil, nil end
        local model = src:Clone()
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
                or d:IsA("JointInstance") or d:IsA("WeldConstraint") then
                d:Destroy()
            end
        end
        local parts = {}
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") then table.insert(parts, d) end
        end
        if #parts == 0 then model:Destroy(); return nil, nil end
        for _, pt in ipairs(parts) do
            pt.Anchored = false; pt.CanCollide = false; pt.CanTouch = false
            pt.CanQuery = false; pt.Massless = true
        end
        pcall(function() model:ScaleTo(BOMB.scale) end)
        return model, parts
    end

    local function bombExplosion(pos)
        local fx = getFxFolder()
        local R = BOMB.blastRadius
        local cam = workspace.CurrentCamera
        local dist = cam and (cam.CFrame.Position - pos).Magnitude or 9999
        local k = CINE.active and 1 or math.clamp(1 - dist/(R*5), 0, 1)

        FXH.sound(pos, M.SND.EXPLOSION, 6, 2000)
        FXH.light(pos, WHITE, 60, 140, 0.3)
        FXH.light(pos + Vector3.new(0, 8, 0), PURPLE, 35, 190, 2.2)

        if k > 0.05 then impactFrame(k); postFx(k) end
        -- без CINE.punch: FOV не пульсирует
        if CINE.active then CINE.shake(18, 2.0)
        else FXH.shake(pos, 2.4, 1.2, 320) end

        FXH.shell(pos, WHITE, Enum.Material.Neon, 4, R*0.9, 0.25, 0)
        FXH.shell(pos, PURPLE, Enum.Material.Neon, 6, R*2.1, 0.8, 0.1)
        FXH.shell(pos, PURPLE_L, Enum.Material.Neon, 4, R*1.4, 0.55, 0.3)
        FXH.shell(pos, PURPLE, Enum.Material.ForceField, 8, R*2.7, 1.2, 0.35)
        task.delay(0.08, function() FXH.shell(pos, WHITE, Enum.Material.Neon, 6, R*1.1, 0.35, 0.2) end)

        local pillar = Instance.new("Part")
        pillar.Shape = Enum.PartType.Cylinder
        pillar.Anchored = true; pillar.CanCollide = false; pillar.CanTouch = false; pillar.CanQuery = false
        pillar.CastShadow = false; pillar.Material = Enum.Material.Neon; pillar.Color = PURPLE_L
        pillar.Transparency = 0.1
        pillar.Size = Vector3.new(R*5, 10, 10)
        pillar.CFrame = CFrame.new(pos + Vector3.new(0, R*2.5, 0)) * CFrame.Angles(0, 0, math.pi/2)
        pillar.Parent = fx
        TweenService:Create(pillar, TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = Vector3.new(R*5, 0.5, 0.5), Transparency = 1}):Play()
        task.delay(1.4, function() if pillar then pillar:Destroy() end end)

        for i = 1, 22 do
            local dir = randUnit()
            local ray = Instance.new("Part")
            ray.Anchored = true; ray.CanCollide = false; ray.CanTouch = false; ray.CanQuery = false
            ray.CastShadow = false; ray.Material = Enum.Material.Neon
            ray.Color = (i % 2 == 0) and PURPLE_L or WHITE
            ray.Size = Vector3.new(0.7, 0.7, 2)
            ray.CFrame = lookCF(pos, pos + dir)
            ray.Parent = fx
            local len = R*(1.6 + math.random()*1.4)
            local d = 0.5 + math.random()*0.35
            TweenService:Create(ray, TweenInfo.new(d, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = Vector3.new(0.2, 0.2, len*2), Transparency = 1}):Play()
            task.delay(d + 0.1, function() if ray then ray:Destroy() end end)
        end

        local gh = FXH.groundHit(pos, 28)
        local ringC = gh and (gh.Position + Vector3.new(0, 0.4, 0)) or pos
        FXH.ring(ringC, PURPLE_L, R*2.4, 1.0, 1.6, 52)
        task.delay(0.12, function() FXH.ring(ringC, PURPLE, R*1.8, 0.85, 1.1, 44) end)
        task.delay(0.30, function() FXH.ring(ringC, WHITE, R*1.3, 0.7, 0.7, 36) end)

        local la = FXH.anchorAt(pos, 9)

        local flashSprite = mkEmitter(la, {
            life = {0.18, 0.28}, speed = {0, 0}, emit = 1,
            color = ColorSequence.new(WHITE, PURPLE_L),
            size = NumberSequence.new({NSK(0, R*1.4), NSK(1, R*2.6)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(1, 1)}),
        })
        local sparks = mkEmitter(la, {
            life = {0.9, 2.2}, speed = {60, 190}, drag = 0.4, acc = Vector3.new(0, -50, 0), emit = 1, vp = true,
            color = ColorSequence.new(PURPLE_L, PURPLE_D),
            size = NumberSequence.new({NSK(0, 1.0), NSK(1, 0)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(1, 1)}),
        })
        local energy = mkEmitter(la, {
            life = {0.5, 1.2}, speed = {20, 85}, drag = 3, emit = 1, rot = 60,
            color = ColorSequence.new({CSK(0, WHITE), CSK(0.4, PURPLE), CSK(1, PURPLE_D)}),
            size = NumberSequence.new({NSK(0, 6), NSK(0.4, 15), NSK(1, 2)}),
            trans = NumberSequence.new({NSK(0, 0.1), NSK(0.6, 0.5), NSK(1, 1)}),
        })
        local smoke = mkEmitter(la, {
            life = {3, 5.5}, speed = {8, 38}, drag = 2, acc = Vector3.new(0, 6, 0), inf = 0.5, rot = 25,
            tex = SMOKE_TEX,
            color = ColorSequence.new(Color3.fromRGB(105, 60, 145), Color3.fromRGB(30, 18, 45)),
            size = NumberSequence.new({NSK(0, 10), NSK(1, 36)}),
            trans = NumberSequence.new({NSK(0, 0.3), NSK(0.5, 0.6), NSK(1, 1)}),
        })
        local embers = mkEmitter(la, {
            life = {3, 6}, speed = {6, 30}, drag = 1, acc = Vector3.new(0, 9, 0), emit = 1,
            color = ColorSequence.new(PURPLE_L, PURPLE),
            size = NumberSequence.new({NSK(0, 0.45), NSK(1, 0)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(0.8, 0.3), NSK(1, 1)}),
        })
        pcall(function()
            flashSprite:Emit(3)
            sparks:Emit(170)
            energy:Emit(85)
            smoke:Emit(70)
            embers:Emit(70)
        end)

        local stem = FXH.anchorAt(pos, 6)
        local stemE = mkEmitter(stem, {
            life = {1.8, 3}, speed = {2, 10}, spread = Vector2.new(35, 35), drag = 1.5, rot = 20,
            inf = 0.4, emit = 0.3, tex = SMOKE_TEX,
            color = ColorSequence.new(Color3.fromRGB(150, 70, 215), Color3.fromRGB(50, 22, 80)),
            size = NumberSequence.new({NSK(0, 9), NSK(1, 26)}),
            trans = NumberSequence.new({NSK(0, 0.2), NSK(0.6, 0.55), NSK(1, 1)}),
        })
        stemE.Rate = 170
        TweenService:Create(stem, TweenInfo.new(1.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            {Position = pos + Vector3.new(0, R*1.5, 0)}):Play()
        task.delay(1.7, function() if stemE then stemE.Enabled = false end end)

        task.delay(1.1, function()
            local topPos = pos + Vector3.new(0, R*1.35, 0)
            local cap = FXH.anchorAt(topPos, 7)
            local capE = mkEmitter(cap, {
                life = {2.5, 4}, speed = {22, 48}, drag = 2, acc = Vector3.new(0, -5, 0), rot = 20,
                inf = 0.4, emit = 0.3, tex = SMOKE_TEX,
                color = ColorSequence.new(Color3.fromRGB(160, 80, 225), Color3.fromRGB(45, 18, 75)),
                size = NumberSequence.new({NSK(0, 12), NSK(1, 40)}),
                trans = NumberSequence.new({NSK(0, 0.25), NSK(0.6, 0.6), NSK(1, 1)}),
            })
            pcall(function() capE:Emit(90) end)
            local disc = Instance.new("Part")
            disc.Shape = Enum.PartType.Ball; disc.Anchored = true
            disc.CanCollide = false; disc.CanTouch = false; disc.CanQuery = false; disc.CastShadow = false
            disc.Material = Enum.Material.Neon; disc.Color = PURPLE
            disc.Transparency = 0.45; disc.Size = Vector3.new(6, 3, 6)
            disc.Position = topPos; disc.Parent = fx
            TweenService:Create(disc, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = Vector3.new(R*1.7, R*0.45, R*1.7), Transparency = 1}):Play()
            task.delay(1.7, function() if disc then disc:Destroy() end end)
        end)

        if gh then
            local scorch = Instance.new("Part")
            scorch.Shape = Enum.PartType.Cylinder
            scorch.Anchored = true; scorch.CanCollide = false; scorch.CanTouch = false; scorch.CanQuery = false
            scorch.CastShadow = false; scorch.Material = Enum.Material.Slate
            scorch.Color = Color3.fromRGB(22, 14, 30); scorch.Transparency = 0.25
            scorch.Size = Vector3.new(0.12, 2, 2)
            scorch.CFrame = CFrame.new(gh.Position + gh.Normal*0.08) * CFrame.Angles(0, 0, math.pi/2)
            scorch.Parent = fx
            TweenService:Create(scorch, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = Vector3.new(0.12, R*1.1, R*1.1)}):Play()
            task.delay(4.2, function()
                if scorch and scorch.Parent then
                    TweenService:Create(scorch, TweenInfo.new(1), {Transparency = 1}):Play()
                    task.delay(1.1, function() if scorch then scorch:Destroy() end end)
                end
            end)

            FXH.dust(gh, {count = 120, power = 2.3})
            FXH.spawnBoulders(gh, {count = 62, power = 1.7, sizeMul = 1.4, life = 4, spread = 2, greyer = true})
            FXH.spawnPebbles(gh, 18, 50, 4, {greyer = true})
        end

        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and (hrp.Position - pos).Magnitude < BOMB.shatterRadius then
            if getgenv().shatterBody then
                task.spawn(function() pcall(getgenv().shatterBody) end)
            end
        end
    end

    -- БРОСОК / ПАДЕНИЕ
    local function spawnThrownBomb(startPos, velocity, opts)
        opts = opts or {}
        local model, parts = buildBombVisual()
        if not model then return nil end

        local _, bbSize = model:GetBoundingBox()
        local diameter = math.clamp(math.max(bbSize.X, bbSize.Y, bbSize.Z), 1.5, 8)
        local radius = diameter/2

        local ball = Instance.new("Part")
        ball.Name = "MonoBombPhysics"
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(diameter, diameter, diameter)
        ball.Transparency = 1
        ball.CanCollide = true; ball.CanTouch = false; ball.CanQuery = false
        ball.Anchored = true
        ball.CustomPhysicalProperties = PhysicalProperties.new(2.5, 0.9, 0, 100, 100)
        ball.CFrame = CFrame.new(startPos)
        ball.Parent = workspace

        for _, pt in ipairs(parts) do pt.Anchored = true end
        model.Parent = workspace
        local bbCF = model:GetBoundingBox()
        model:PivotTo(CFrame.new(startPos) * bbCF:ToObjectSpace(model:GetPivot()))
        for _, pt in ipairs(parts) do
            local w = Instance.new("Weld")
            w.Part0 = ball; w.Part1 = pt
            w.C0 = ball.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
            w.Parent = ball
        end
        for _, pt in ipairs(parts) do
            pt.Anchored = false; pt.CanCollide = false; pt.Massless = true
        end

        local beep = Instance.new("Sound")
        beep.Name = "MonoBombBeep"; beep.SoundId = M.SND.BOMB_BEEP
        beep.Volume = 2.5; beep.RollOffMaxDistance = 140
        beep.RollOffMode = Enum.RollOffMode.InverseTapered
        beep.Parent = ball

        ball.Anchored = false
        ball.AssemblyLinearVelocity = velocity
        local h0 = Vector3.new(velocity.X, 0, velocity.Z)
        ball.AssemblyAngularVelocity = Vector3.new(0, 1, 0):Cross(h0)/radius

        local fuse = opts.fuse or BOMB.fuse
        local handle = {
            pos = startPos, t = 0, fuse = fuse, grounded = false,
            exploded = false, explodePos = nil,
            dir = (h0.Magnitude > 1) and h0.Unit or nil,
        }

        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = {ball, model, getFxFolder()}
        rp.IgnoreWater = true

        local t0 = os.clock()
        local done = false
        local beepT = 0.5
        local hb
        hb = RunService.Heartbeat:Connect(function(dt)
            if done then return end
            if not ball.Parent then
                done = true; hb:Disconnect()
                if model then model:Destroy() end
                handle.exploded = true; handle.dead = true; handle.explodePos = handle.pos
                return
            end
            local t = os.clock() - t0
            handle.t = t
            handle.pos = ball.Position

            local v = ball.AssemblyLinearVelocity
            local ch = p.Character
            if ch then rp.FilterDescendantsInstances = {ball, model, getFxFolder(), ch} end
            local grounded = workspace:Raycast(ball.Position, Vector3.new(0, -(radius + 0.6), 0), rp) ~= nil
            handle.grounded = grounded
            if grounded then
                local h = Vector3.new(v.X, 0, v.Z)
                h = h*math.max(0, 1 - BOMB.rollDamping*dt)
                if h.Magnitude > BOMB.maxRollSpeed then h = h.Unit*BOMB.maxRollSpeed end
                ball.AssemblyLinearVelocity = Vector3.new(h.X, v.Y, h.Z)
                ball.AssemblyAngularVelocity = Vector3.new(0, 1, 0):Cross(h)/radius
            end

            beepT = beepT - dt
            if beepT <= 0 and t < fuse then
                pcall(function() beep.TimePosition = 0; beep:Play() end)
                local freq = math.clamp(t/fuse, 0, 1)
                beepT = math.max(0.1, 0.55 - 0.45*freq*freq)
            end

            if t >= fuse or ball.Position.Y < -500 then
                done = true; hb:Disconnect()
                local ep = ball.Position
                ball:Destroy()
                if model then model:Destroy() end
                handle.exploded = true
                handle.explodePos = ep
                pcall(bombExplosion, ep)
            end
        end)
        return handle
    end

    -- АНИМЕ-ПОРТАЛ
    local function animePortal(center, radius, groundY)
        local fx = getFxFolder()
        local P = {mode = "hidden", t0 = os.clock(), spin = 0, alive = true}
        local all = {}

        local function cyl(color, mat, tr)
            local c = Instance.new("Part")
            c.Shape = Enum.PartType.Cylinder
            c.Anchored = true; c.CanCollide = false; c.CanTouch = false; c.CanQuery = false; c.CastShadow = false
            c.Material = mat; c.Color = color; c.Transparency = tr
            c.Size = Vector3.new(0.1, 0.1, 0.1); c.CFrame = CFrame.new(center)
            c.Parent = fx
            table.insert(all, c)
            return c
        end

        local rim   = cyl(GREEN, Enum.Material.Neon, 0.05)
        local core  = cyl(GREEN_D, Enum.Material.SmoothPlastic, 0)
        local swirl = cyl(GREEN_L, Enum.Material.Neon, 0.5)
        local beamH = math.max(center.Y - (groundY or (center.Y - 30)), 4)
        local beam  = cyl(GREEN, Enum.Material.Neon, 0.88)

        local rings = {}
        for i = 1, 3 do
            local n = 18 + i*4
            local blocks = {}
            for j = 1, n do
                local b = Instance.new("Part")
                b.Anchored = true; b.CanCollide = false; b.CanTouch = false; b.CanQuery = false; b.CastShadow = false
                b.Material = Enum.Material.Neon
                b.Color = (j % 2 == 0) and GREEN or GREEN_L
                b.Size = Vector3.new(0.1, 0.1, 0.1)
                b.Parent = fx
                blocks[j] = b
                table.insert(all, b)
            end
            rings[i] = {blocks = blocks, n = n, r = radius*(1.12 + 0.16*i),
                dir = (i % 2 == 0) and 1 or -1, spd = 0.8 + 0.5*i}
        end

        local em = FXH.anchorAt(center, nil)
        table.insert(all, em)
        em.Size = Vector3.new(radius*2, 0.2, radius*2)
        local light = Instance.new("PointLight")
        light.Color = GREEN; light.Range = 55; light.Brightness = 0; light.Shadows = false
        light.Parent = em
        local spark = mkEmitter(em, {
            life = {0.6, 1.3}, speed = {14, 32}, spread = Vector2.new(22, 22), acc = Vector3.new(0, -18, 0), emit = 1,
            color = ColorSequence.new(WHITE, GREEN),
            size = NumberSequence.new({NSK(0, 0.7), NSK(1, 0)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(1, 1)}),
        })
        spark.EmissionDirection = Enum.NormalId.Bottom
        pcall(function() spark.Shape = Enum.ParticleEmitterShape.Disc end)

        local base = CFrame.new(center) * CFrame.Angles(0, 0, math.pi/2)
        local function apply(s)
            s = math.max(s, 0.001)
            local d = radius*2*s
            rim.Size = Vector3.new(0.3, d*1.05, d*1.05); rim.CFrame = base
            core.Size = Vector3.new(0.2, d*0.9, d*0.9); core.CFrame = base * CFrame.new(-0.14, 0, 0)
            swirl.Size = Vector3.new(0.12, d*0.65, d*0.65); swirl.CFrame = base * CFrame.new(-0.26, 0, 0)
            beam.Size = Vector3.new(beamH, d*0.8, d*0.8)
            beam.CFrame = CFrame.new(center.X, center.Y - beamH/2, center.Z) * CFrame.Angles(0, 0, math.pi/2)
            for _, rg in ipairs(rings) do
                local r = rg.r*s
                local segLen = math.max((2*math.pi*r/rg.n)*0.6, 0.05)
                for j, b in ipairs(rg.blocks) do
                    local a = (j/rg.n)*math.pi*2 + P.spin*rg.dir*rg.spd
                    local pos = center + Vector3.new(math.cos(a)*r, math.sin(a*3 + P.spin*4)*0.35*s, math.sin(a)*r)
                    local tan = Vector3.new(-math.sin(a), 0, math.cos(a))
                    b.Size = Vector3.new(0.35*s + 0.01, 0.35*s + 0.01, segLen)
                    b.CFrame = CFrame.lookAt(pos, pos + tan)
                end
            end
        end

        function P.destroy()
            if not P.alive then return end
            P.alive = false
            if P.conn then P.conn:Disconnect() end
            for _, o in ipairs(all) do if o then o:Destroy() end end
        end
        function P.open()
            P.mode = "open"; P.t0 = os.clock()
            spark.Rate = 140
            TweenService:Create(light, TweenInfo.new(0.4), {Brightness = 5}):Play()
            FXH.sound(center, M.SND.SPAWN, 3, 500)
            FXH.ring(center, GREEN, radius*3, 0.55, 0.5, 40)
            pcall(function() spark:Emit(80) end)
        end
        function P.close()
            if P.mode == "close" or not P.alive then return end
            P.mode = "close"; P.t0 = os.clock()
            spark.Rate = 0
            TweenService:Create(light, TweenInfo.new(0.35), {Brightness = 0}):Play()
            FXH.sound(center, M.SND.ENTER, 2.5, 500)
            FXH.ring(center, GREEN_L, radius*2.2, 0.4, 0.4, 32)
        end

        apply(0)
        P.conn = RunService.RenderStepped:Connect(function(dt)
            if not P.alive then return end
            P.spin = P.spin + dt
            local el = os.clock() - P.t0
            local s = 0
            if P.mode == "open" then
                s = ease.back(el/0.45)
                if el >= 0.45 then P.mode = "idle" end
            elseif P.mode == "idle" then
                s = 1 + math.sin(P.spin*6)*0.02
            elseif P.mode == "close" then
                local u = el/0.4
                if u >= 1 then P.destroy(); return end
                s = 1 - ease.inOut(u)
            end
            apply(s)
        end)
        return P
    end

    -- ФАЗЫ КАМЕРЫ
    local function cineBombPhases(handle, ov, opts)
        opts = opts or {}
        local fl = CINE.cf.LookVector
        local flat = Vector3.new(fl.X, 0, fl.Z)
        local dir = opts.dir or handle.dir or ((flat.Magnitude > 0.01) and flat.Unit or Vector3.new(0, 0, -1))
        local rightV = dir:Cross(Vector3.new(0, 1, 0))
        local cur = CINE.cf

        local t0 = os.clock()
        while CINE.active and not CINE.skip and not handle.exploded do
            local dt = RunService.RenderStepped:Wait()
            local bp = handle.pos
            local desired = CFrame.lookAt(bp - dir*17 + rightV*6 + Vector3.new(0, 7, 0), bp)
            cur = cur:Lerp(desired, 1 - math.exp(-5*dt)); CINE.cf = cur
            -- без FOV-зума
            if opts.onTick then opts.onTick(bp) end
            local el = os.clock() - t0
            if (handle.grounded and el > 0.4) or el > 4 then break end
        end

        local ang = math.atan2(cur.Position.Z - handle.pos.Z, cur.Position.X - handle.pos.X)
        local lastShown = -1
        while CINE.active and not CINE.skip and not handle.exploded do
            local dt = RunService.RenderStepped:Wait()
            local rem = handle.fuse - handle.t
            local prog = math.clamp(handle.t/handle.fuse, 0, 1)
            ang = ang + dt*(0.7 + prog*1.4)
            local r = 16  -- радиус постоянный, без приближения
            local bp = handle.pos
            local desired = CFrame.lookAt(
                bp + Vector3.new(math.cos(ang)*r, 3.5 + 2*(1 - prog), math.sin(ang)*r),
                bp + Vector3.new(0, 1, 0))
            cur = cur:Lerp(desired, 1 - math.exp(-8*dt)); CINE.cf = cur
            -- без FOV-зума
            local n = math.ceil(rem)
            if n >= 1 and n <= 3 and n ~= lastShown then
                lastShown = n
                -- без текста: только shake
                CINE.shake(1.2 + (4 - n), 0.25)
            end
            if rem < 0.45 then CINE.shake(2.5, 0.1) end
        end

        if CINE.active then
            local ep = handle.explodePos or handle.pos
            -- без текста "БАБАХ!"
            if not CINE.skip then task.wait(0.12) end
            local startPos = CINE.cf.Position
            local baseAng = math.atan2(startPos.Z - ep.Z, startPos.X - ep.X)
            local c2 = CINE.cf
            CINE.run(4.6, function(u, dt)
                local e = ease.out(u)
                local r = 24 + 70*e
                local a = baseAng + u*0.9
                local h = 6 + 38*e
                local look = ep + Vector3.new(0, 4 + 46*e, 0)
                local desired = CFrame.lookAt(ep + Vector3.new(math.cos(a)*r, h, math.sin(a)*r), look)
                c2 = c2:Lerp(desired, 1 - math.exp(-4*dt)); CINE.cf = c2
                -- без FOV-зума
            end)
        end

        if CINE.active and CINE.saved then
            CINE.tween(CINE.saved.cf, CINE.saved.fov, 1.2, ease.inOut)
        end
    end

    local function endCinematic(ov)
        pcall(function() ov.bars(false, 0.4) end)
        task.wait(0.4)
        pcall(function() ov.destroy() end)
        CINE.finish()
    end

    local function runPortalSequence(target)
        if CINE.active or busy then return end
        busy = true
        local ov = makeOverlay()
        CINE.begin()
        local portal
        local ok, err = pcall(function()
            local H = BOMB.portalHeight
            local portalPos = target + Vector3.new(0, H, 0)
            local camPos = CINE.cf.Position
            local back = Vector3.new(camPos.X - target.X, 0, camPos.Z - target.Z)
            if back.Magnitude < 5 then back = Vector3.new(0, 0, 1) end
            back = back.Unit
            local right = back:Cross(Vector3.new(0, 1, 0))

            ov.bars(true, 0.4)
            ov.lines(0.7, Color3.new(1, 1, 1))
            local shot1 = CFrame.lookAt(
                target + back*58 + right*14 + Vector3.new(0, H*0.5, 0),
                target + Vector3.new(0, H*0.62, 0))
            CINE.tween(shot1, CINE.fov, 0.95, ease.inOut) -- FOV не меняется

            portal = animePortal(portalPos, 9, target.Y)
            portal.open()
            ov.flash(GREEN_L, 0.55, 0.35)
            CINE.shake(5, 0.5)
            -- долли-ин удалён: камера не приближается

            local handle = spawnThrownBomb(portalPos - Vector3.new(0, 4, 0), Vector3.new(0, -26, 0),
                {fuse = BOMB.dropFuse})
            if not handle then error("модель бомбы не загрузилась") end

            local closed = false
            cineBombPhases(handle, ov, {
                dir = -back,
                onTick = function(bp)
                    if not closed and bp.Y < portalPos.Y - 10 then
                        closed = true; portal.close()
                    end
                end,
            })
        end)
        if not ok then warn("[MONO] cine:", err) end
        if portal then portal.destroy() end
        endCinematic(ov)
        busy = false
    end

    local function runThrowCinematic(handle)
        if not handle or CINE.active or busy then return end
        busy = true
        local ov = makeOverlay()
        CINE.begin()
        local ok, err = pcall(function()
            ov.bars(true, 0.35)
            cineBombPhases(handle, ov, {})
        end)
        if not ok then warn("[MONO] cine:", err) end
        endCinematic(ov)
        busy = false
    end

    -- ВЫБОР ТОЧКИ
    local pick = {active = false}
    local stopPick
    stopPick = function()
        pick.active = false
        if pick.hb then pick.hb:Disconnect(); pick.hb = nil end
        if pick.click then pick.click:Disconnect(); pick.click = nil end
        if pick.marker then pick.marker:Destroy(); pick.marker = nil end
    end
    local function startPick()
        if pick.active then stopPick(); return end
        if CINE.active or busy then return end
        pick.active = true
        notify("Бомба", "Кликни по земле · Backspace — отмена")
        local marker = Instance.new("Part")
        marker.Shape = Enum.PartType.Cylinder
        marker.Anchored = true; marker.CanCollide = false; marker.CanTouch = false; marker.CanQuery = false
        marker.CastShadow = false; marker.Material = Enum.Material.Neon
        marker.Color = GREEN; marker.Transparency = 0.4
        marker.Size = Vector3.new(0.2, 8, 8)
        marker.Parent = getFxFolder()
        pick.marker = marker
        local lastHit = nil
        pick.hb = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            local mp = UserInputService:GetMouseLocation()
            local ray = cam:ViewportPointToRay(mp.X, mp.Y)
            local res = workspace:Raycast(ray.Origin, ray.Direction*2000, FXH.rayParams())
            if res and res.Normal.Y > 0.5 then
                lastHit = res
                marker.Transparency = 0.4
                marker.CFrame = CFrame.new(res.Position + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, math.pi/2)
                marker.Size = Vector3.new(0.2, 8 + math.sin(os.clock()*6)*0.8, 8 + math.sin(os.clock()*6)*0.8)
            else
                lastHit = nil
                marker.Transparency = 1
            end
        end)
        pick.click = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not lastHit then notify("Бомба", "Нужна ровная поверхность"); return end
            local target = lastHit.Position
            stopPick()
            task.spawn(runPortalSequence, target)
        end)
    end

    -- ИНСТРУМЕНТ
    local function giveBombTool()
        local toolName = "PurpleBomb"
        local bp = p:FindFirstChild("Backpack")
        if bp then
            for _, v in ipairs(bp:GetChildren()) do
                if v:IsA("Tool") and v.Name == toolName then v:Destroy() end
            end
        end
        if p.Character then
            for _, v in ipairs(p.Character:GetChildren()) do
                if v:IsA("Tool") and v.Name == toolName then v:Destroy() end
            end
        end

        local tool = Instance.new("Tool")
        tool.Name = toolName; tool.RequiresHandle = true; tool.CanBeDropped = false
        tool.ToolTip = "ЛКМ — бросить фиолетовую бомбу"
        local handle = Instance.new("Part")
        handle.Name = "Handle"; handle.Size = Vector3.new(0.6, 0.6, 0.6); handle.Transparency = 1
        handle.CanCollide = false; handle.CanTouch = false; handle.CanQuery = false
        handle.Parent = tool
        tool.PrimaryPart = handle

        local model, parts = buildBombVisual()
        if model then
            model.Parent = tool
            if parts and #parts > 0 then
                local primary = parts[1]
                model:PivotTo(handle.CFrame)
                for _, pt in ipairs(parts) do
                    pt.Anchored = false; pt.CanCollide = false; pt.CanTouch = false
                    pt.CanQuery = false; pt.Massless = true
                    if pt ~= primary then
                        local w = Instance.new("Weld")
                        w.Part0 = primary; w.Part1 = pt
                        w.C0 = primary.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
                        w.Parent = primary
                    end
                end
                local hw = Instance.new("Weld")
                hw.Part0 = handle; hw.Part1 = primary
                hw.C0 = handle.CFrame:ToObjectSpace(primary.CFrame); hw.C1 = CFrame.new()
                hw.Parent = handle
            end
        end

        local lastThrow = 0
        tool.Activated:Connect(function()
            if os.clock() - lastThrow < 0.8 then return end
            if CINE.active or busy then return end
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera
            if not hrp or not cam then return end
            lastThrow = os.clock()
            local look = cam.CFrame.LookVector
            local flat = Vector3.new(look.X, 0, look.Z)
            if flat.Magnitude < 0.05 then
                local rl = hrp.CFrame.LookVector
                flat = Vector3.new(rl.X, 0, rl.Z)
            end
            flat = flat.Unit
            local startPos = hrp.Position + flat*4.5 + Vector3.new(0, 1.2, 0)
            local vel = flat*BOMB.throwSpeed + Vector3.new(0, BOMB.upBoost + math.clamp(look.Y, -0.5, 0.8)*10, 0)
            local h = spawnThrownBomb(startPos, vel)
            if h and getgenv().BombCine then task.spawn(runThrowCinematic, h) end
        end)

        local backpack = p:FindFirstChild("Backpack")
        if backpack then tool.Parent = backpack end
    end

    -- УПРАВЛЕНИЕ / ЭКСПОРТ
    track(UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode == Enum.KeyCode.Backspace then
            if CINE.active then CINE.skip = true
            elseif pick.active then stopPick() end
        elseif input.KeyCode == Enum.KeyCode.B then
            startPick()
        end
    end))

    track(LocalPlayer.CharacterAdded:Connect(function()
        CINE.skip = true
        if pick.active then stopPick() end
    end))

    getgenv().giveBombTool = giveBombTool
    getgenv().spawnThrownBomb = spawnThrownBomb
    getgenv().startBombPick = startPick
    getgenv().toggleBombCine = function()
        getgenv().BombCine = not getgenv().BombCine
        notify("Кино-камера", getgenv().BombCine and "ВКЛ (бросок из рук)" or "ВЫКЛ (бросок из рук)")
    end
end

-- =====================================================================
-- РУКА С ПУШКОЙ
-- =====================================================================
local function stopToolAnims(hum)
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
        local nm = string.lower((tr.Animation and tr.Animation.Name) or tr.Name or "")
        if string.find(nm, "tool", 1, true) then
            pcall(function() tr:Stop(0) end)
        end
    end
end

local gunArmActive = false
local function applyGunArm(char, hum, gun)
    stopToolAnims(hum)
    local J = getBodyJoints(char)
    local raise = gun.def.noShoot and 0 or gunRaiseAmount()
    if raise > 0.001 then
        if J.shoulderR then
            local cam = workspace.CurrentCamera
            local pitch = cam and math.deg(math.asin(math.clamp(cam.CFrame.LookVector.Y, -1, 1))) or 0
            local ang = math.clamp(88 + pitch, 20, 170)
            applyJointRot(J.shoulderR, rotCache, ang*raise, 0, 0)
        end
        resetJoint(J.elbowR)
        resetJoint(J.wristR)
        gunArmActive = true
    elseif gunArmActive then
        resetJoint(J.shoulderR)
        resetJoint(J.elbowR)
        resetJoint(J.wristR)
        gunArmActive = false
    end
end

local function gunArmTick()
    if flight.active or emoteActive then return end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local gun = getHeldGun(char)
    if gun then applyGunArm(char, hum, gun) end
end
track(RunService.Stepped:Connect(gunArmTick))
track(RunService.Heartbeat:Connect(gunArmTick))

track(RunService.RenderStepped:Connect(function(dt)
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    if flight.active then applyFlightPose(char); return end
    if emoteActive then return end

    local gun = getHeldGun(char)
    if gun then
        lastMoveStateAnim = nil
        applyGunArm(char, hum, gun)
        return
    end

    local shoulder = getRightShoulder(char)
    if not shoulder then return end
    local moving = hum.MoveDirection.Magnitude > 0.1
    if moving ~= lastMoveStateAnim then
        lastMoveStateAnim = moving; idleClock = 0
        shoulder.Transform = moving and CFrame.Angles(math.rad(-90),0,0) or CFrame.new()
    end
    if not moving and M.EK.IDLE then
        idleClock = idleClock + dt
        local b = math.sin(idleClock*M.EK.IDLE_SPD)*M.EK.IDLE_AMP
        shoulder.Transform = CFrame.Angles(math.rad(b), 0, math.rad(b*0.25))
    end
end))

-- =====================================================================
-- ANTI-FLING + ЩИТ [8]
-- =====================================================================
getgenv().AntiFlingModelConfig = {
    id = "rbxassetid://84006104714125",
    size = 9,
    offX = 0, offY = 0, offZ = 0,
    rotX = 0, rotY = 0, rotZ = 0,
}

do
    local AF = {
        model = nil, showUntil = 0, manual = false,
        suspendUntil = 0, lastSafeCF = nil, lastPos = nil,
        abnormalAt = -10, lastNotify = -10,
        rollbacks = {}, blockUntil = 0, scanT = 0,
        wasFlying = false, parts = {},
    }
    local srcCache = nil

    local function getSrc()
        if srcCache ~= nil then return srcCache end
        local cfg = getgenv().AntiFlingModelConfig
        local ok, m = pcall(loadAssetModel, cfg.id)
        srcCache = (ok and m) or false
        return srcCache
    end

    local function afHide()
        if AF.model then pcall(function() AF.model:Destroy() end) end
        AF.model = nil
    end

    local function afShow()
        if AF.model and AF.model.Parent then return end
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local src = getSrc()
        if not src then return end
        local cfg = getgenv().AntiFlingModelConfig
        local model = src:Clone()
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
                or d:IsA("JointInstance") or d:IsA("WeldConstraint") then
                d:Destroy()
            end
        end
        local parts = {}
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") then table.insert(parts, d) end
        end
        if #parts == 0 then model:Destroy(); return end
        model.Name = "MonoAntiFling"
        model.Parent = workspace
        for _, pt in ipairs(parts) do
            pt.Anchored = true; pt.CanCollide = false; pt.CanTouch = false
            pt.CanQuery = false; pt.Massless = true
        end
        local primary, bestVol = parts[1], -1
        for _, pt in ipairs(parts) do
            local v = pt.Size.X * pt.Size.Y * pt.Size.Z
            if v > bestVol then bestVol = v; primary = pt end
        end
        pcall(function() model.PrimaryPart = nil end)
        local _, sz0 = model:GetBoundingBox()
        local maxD = math.max(sz0.X, sz0.Y, sz0.Z)
        if maxD > 0.01 then
            pcall(function() model:ScaleTo(model:GetScale() * ((cfg.size or 9) / maxD)) end)
        end
        local bbCF = model:GetBoundingBox()
        local off = CFrame.new(cfg.offX or 0, cfg.offY or 0, cfg.offZ or 0)
            * CFrame.Angles(math.rad(cfg.rotX or 0), math.rad(cfg.rotY or 0), math.rad(cfg.rotZ or 0))
        local target = hrp.CFrame * off
        model:PivotTo(target * bbCF:ToObjectSpace(model:GetPivot()))
        for _, pt in ipairs(parts) do
            if pt ~= primary then
                local w = Instance.new("Weld")
                w.Part0 = primary; w.Part1 = pt
                w.C0 = primary.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
                w.Parent = pt
            end
        end
        local hw = Instance.new("Weld")
        hw.Name = "MonoAFWeld"
        hw.Part0 = hrp; hw.Part1 = primary
        hw.C0 = hrp.CFrame:ToObjectSpace(primary.CFrame); hw.C1 = CFrame.new()
        hw.Parent = primary
        for _, pt in ipairs(parts) do pt.Anchored = false end
        AF.model = model
    end

    local function trigger()
        local now = os.clock()
        AF.showUntil = now + 5
        afShow()
        if now - AF.lastNotify > 4 then
            AF.lastNotify = now
            notify("Anti-Fling", "Атака отражена")
        end
    end

    local function limits()
        if AF.manual then return 50, 75, 15 end
        return 110, 110, 40
    end

    local function nearOther(range)
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= p and pl.Character then
                local r = pl.Character:FindFirstChild("HumanoidRootPart")
                if r and (r.Position - hrp.Position).Magnitude <= range then return true end
            end
        end
        return false
    end

    local function check()
        local char = p.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then
            AF.lastSafeCF = nil; AF.lastPos = nil; return
        end
        local now = os.clock()
        if flight.active then AF.wasFlying = true
        elseif AF.wasFlying then
            AF.wasFlying = false
            AF.suspendUntil = math.max(AF.suspendUntil, now + 1.5)
        end
        local exempt = flight.active or getgenv().ShatterActive or isTeleporting
            or now < AF.suspendUntil or now - lastTeleport < 1.0
            or hum.SeatPart ~= nil or hrp.Anchored
        if exempt then
            AF.lastSafeCF = hrp.CFrame; AF.lastPos = hrp.Position; return
        end

        local lv = hrp.AssemblyLinearVelocity
        local av = hrp.AssemblyAngularVelocity
        local hLim, uLim, aLim = limits()
        local horiz = Vector3.new(lv.X, 0, lv.Z).Magnitude
        local bad = horiz > hLim or lv.Y > uLim or av.Magnitude > aLim

        local jumped = false
        if AF.lastPos and (hrp.Position - AF.lastPos).Magnitude > 60
            and (bad or now - AF.abnormalAt < 0.6 or nearOther(30)) then
            jumped = true
        end

        if bad then
            AF.abnormalAt = now
            hrp.AssemblyLinearVelocity = Vector3.new(0, math.clamp(lv.Y, -80, 30), 0)
            hrp.AssemblyAngularVelocity = Vector3.zero
        end

        if jumped and AF.lastSafeCF and now >= AF.blockUntil then
            local fresh = {}
            for _, t in ipairs(AF.rollbacks) do
                if now - t < 2 then table.insert(fresh, t) end
            end
            table.insert(fresh, now)
            AF.rollbacks = fresh
            if #fresh >= 4 then
                AF.blockUntil = now + 3
            else
                hrp.CFrame = AF.lastSafeCF
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end

        if bad or jumped then
            trigger()
            AF.lastPos = hrp.Position
        else
            AF.lastSafeCF = hrp.CFrame
            AF.lastPos = hrp.Position
        end
    end

    local function disableCollisions()
        for pl, set in pairs(AF.parts) do
            for part in pairs(set) do
                if part.Parent then
                    if part.CanCollide then part.CanCollide = false end
                else
                    set[part] = nil
                end
            end
        end
    end

    local function hookPlayer(pl)
        if pl == p then return end
        local function onChar(ch)
            local set = {}
            AF.parts[pl] = set
            for _, d in ipairs(ch:GetDescendants()) do
                if d:IsA("BasePart") then set[d] = true end
            end
            track(ch.DescendantAdded:Connect(function(d)
                if d:IsA("BasePart") then set[d] = true end
            end))
        end
        if pl.Character then onChar(pl.Character) end
        track(pl.CharacterAdded:Connect(onChar))
    end
    for _, pl in ipairs(Players:GetPlayers()) do hookPlayer(pl) end
    track(Players.PlayerAdded:Connect(hookPlayer))
    track(Players.PlayerRemoving:Connect(function(pl) AF.parts[pl] = nil end))

    track(RunService.Stepped:Connect(function()
        disableCollisions()
        check()
    end))
    track(RunService.Heartbeat:Connect(function(dt)
        check()
        local now = os.clock()
        if AF.model and not AF.model.Parent then AF.model = nil end
        if AF.model and not AF.manual and now > AF.showUntil then afHide() end
        if AF.manual and not AF.model then afShow() end

        AF.scanT = AF.scanT + dt
        if AF.scanT >= 0.2 then
            AF.scanT = 0
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl ~= p and pl.Character then
                        local r = pl.Character:FindFirstChild("HumanoidRootPart")
                        if r and (r.Position - hrp.Position).Magnitude <= 15 then
                            if r.AssemblyAngularVelocity.Magnitude > 50
                                or r.AssemblyLinearVelocity.Magnitude > 140 then
                                tr-- =====================================================================
-- MONOCHROME + PORTAL GUN // COMBINED v21
--  - Портал ставится ТОЧНО в точку выстрела (убран wallYShift)
--  - Взрыв после [Q]: вспышка, огненный шар, дым, искры,
--    обломки дрона, пыль и камни (без ударной волны)
--  - ★ КИНО-БОМБА v21: [B] — выбрать точку, аниме-портал, кино-камера,
--    letterbox, speed-lines, обратный отсчёт, impact-frame,
--    новый взрыв (грибовидное облако, световой столб, кратер, камни)
--  - [B] — выбрать точку · Backspace — пропустить/отмена
--  - Фиолетовая бомба: БЕЗ свечения, с пиканьем 91476644853368,
--    серые камни после взрыва
-- =====================================================================

local M = {}
M.CLR, M.TM, M.SND, M.EK, M.FLY, M.DM, M.SC, M.LB, M.W = {}, {}, {}, {}, {}, {}, {}, {}, {}

do -- COLORS
    local RED = Color3.fromRGB(232,28,28)
    M.CLR.RED        = RED
    M.CLR.WHITE      = Color3.fromRGB(255,255,255)
    M.CLR.ICE        = Color3.fromRGB(190,225,255)
    M.CLR.BLOOD      = RED
    M.CLR.BLOOD_DARK = RED
    M.CLR.BLOOD_LT   = RED
    M.CLR.BLOOD_OLD  = RED
    M.CLR.GORE_A     = RED
    M.CLR.GORE_B     = RED
    M.CLR.GORE_C     = RED
    M.CLR.STREAK     = RED
    M.CLR.SPLAT      = RED
    M.CLR.NERVE_A    = Color3.fromRGB(30,85,210)
    M.CLR.NERVE_B    = Color3.fromRGB(55,115,230)
    M.CLR.MUSCLE_A   = Color3.fromRGB(125,55,45)
    M.CLR.MUSCLE_B   = Color3.fromRGB(92,40,36)
    M.CLR.BONE       = Color3.fromRGB(255,255,255)
    M.CLR.THREAD     = Color3.fromRGB(35,30,40)
    M.CLR.SHARD      = Color3.fromRGB(14,12,18)
    M.CLR.DUST       = Color3.fromRGB(200,195,185)
    M.CLR.GHOST      = Color3.fromRGB(170,200,255)
    M.CLR.MIST       = Color3.fromRGB(195,220,240)
end

do -- TIMING
    M.TM.CHAOS        = 0.42
    M.TM.TURN         = 0.10
    M.TM.STREAK       = 0.22
    M.TM.STREAK_JIT   = 0.08
    M.TM.GHOST_START  = 0.48
    M.TM.GHOST_TIME   = 0.40
    M.TM.TOTAL        = 0.86
    M.TM.SPLAT_LIFE   = 2.0
    M.TM.SPLAT_FADE   = 0.5
    M.TM.FLASH        = 0.3
    M.TM.FRAG_LIFE    = 2.4
    M.TM.PRINT_SND    = 8
    M.TM.BLOOD_POOL   = 3.5
end

do -- SOUNDS
    M.SND.REGEN        = "rbxassetid://84312631986360"
    M.SND.DISINTEGRATE = "rbxassetid://139916424589528"
    M.SND.DECAL        = "rbxassetid://80559445961612"
    M.SND.SPAWN        = "rbxassetid://74562584385247"
    M.SND.ENTER        = "rbxassetid://102568033872947"
    M.SND.SCANNER      = "rbxassetid://129289790297292"
    M.SND.EXPLOSION    = "rbxassetid://138533090376585"
    M.SND.BOMB_BEEP    = "rbxassetid://91476644853368"
end

do -- REGEN MODEL ASSETS
    M.RGN_IDS = {
        bone       = "rbxassetid://70473244410151",
        muscleRed  = "rbxassetid://120986606825859",
        muscleBlue = "rbxassetid://128534142433183",
        root       = "rbxassetid://140378954130619",
    }
end

do -- FLIGHT
    M.FLY.ID    = "rbxassetid://98316282912132"
    M.FLY.SPEED = 70
    M.FLY.FAST  = 140
    M.FLY.VERT  = 55
end

getgenv().RegenModelConfig = {
    bone       = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    muscleRed  = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    muscleBlue = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    root       = {offX=0, offY=0, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
    decal      = {offX=0, offY=2.2, offZ=0, rotX=0, rotY=0, rotZ=0, scale=1},
}

getgenv().FlyModelConfig = {
    offX=0.00, offY=-0.10, offZ=-0.70,
    rotX=0, rotY=0, rotZ=0,
    scale=0.90, gap=1.30,
    lean=18, armX=138, armZ=14, elbow=-32,
    legFwd=62, legSpread=9, kneeBend=78, grip=2.5,
}

do -- DIMENSIONS
    M.DM.RANGE        = 10000
    M.DM.PORTAL_GAP   = 0.03
    M.DM.PORTAL_SIZE  = 8.5
    M.DM.COOLDOWN     = 0.25
    M.DM.PORTAL_LIFE  = 15
    M.DM.EXIT_H       = 5
    M.DM.GARAGE_SCALE = 0.75
    M.DM.RETRO_SCALE  = 0.70
    M.DM.OMEGA_SCALE  = 0.5
    M.DM.GARAGE_C     = Vector3.new(0,32000,0)
    M.DM.RETRO_C      = Vector3.new(0,56000,0)
    M.DM.OMEGA_C      = Vector3.new(0,72000,0)
    M.DM.GARAGE_O_Y   = 5
    M.DM.OMEGA_O_Y    = 5
    M.DM.GARAGE_ID    = "rbxassetid://116913770111820"
    M.DM.RETRO_ID     = "rbxassetid://1583359288"
    M.DM.OMEGA_ID     = "rbxassetid://126041705531931"
end

do -- WALK / SCANNER
    M.W.CALM   = 10
    M.W.NORMAL = 16
    M.SC.LOOK_ANGLE   = 45
    M.SC.STICKY_ANGLE = 80
    M.SC.LOOK_DIST    = 60
    M.SC.STICKY_DIST  = 90
end

do -- EMOTE KEYFRAMES
    M.EK.SPEED      = 1.0
    M.EK.HEAD_TRACK = true
    M.EK.TORSO_LEAN = true
    M.EK.IDLE       = true
    M.EK.IDLE_AMP   = 0.8
    M.EK.IDLE_SPD   = 1.6
    M.EK.SHOULDER = {
        {0.000,0,0,0},{0.050,-9,3,4},{0.100,78,-9,-18},{0.166,150,-18,-37},
        {0.233,166,-21,-40},{0.300,156,-22,-38},{0.366,146,-21,-44},
        {0.433,122,9,-36},{0.500,96,26,-28},{0.566,75,39,-25},
        {0.633,60,22,-9},{0.700,22,6,-3},{0.750,-5,1,2},{0.800,0,0,0},
    }
    M.EK.ELBOW = {
        {0.000,0,0,0},{0.050,-12,0,0},{0.100,-22,0,0},{0.166,-52,0,0},
        {0.233,-60,0,0},{0.300,-56,0,0},{0.366,-48,0,0},{0.433,-34,0,0},
        {0.500,-20,0,0},{0.566,-10,0,0},{0.633,-4,0,0},{0.700,0,0,0},
    }
    M.EK.WRIST = {
        {0.000,0,0,0},{0.100,-6,0,12},{0.166,-12,0,22},{0.233,-14,0,24},
        {0.300,-11,0,19},{0.366,-6,0,11},{0.433,0,0,4},{0.500,5,0,-9},
        {0.566,9,0,-16},{0.633,4,0,-8},{0.700,0,0,0},
    }
    M.EK.NECK = {
        {0.000,0,0,0},{0.100,4,0,-6},{0.166,7,0,-10},{0.233,8,0,-11},
        {0.300,6,0,-8},{0.366,3,0,-3},{0.433,1,0,3},{0.500,0,0,6},
        {0.566,-1,0,5},{0.633,0,0,2},{0.700,0,0,0},
    }
    M.EK.TORSO = {
        {0.000,0,0,0},{0.100,-2.5,0,-4},{0.166,-3.5,0,-7},{0.233,-3.5,0,-8},
        {0.300,-2.5,0,-5},{0.366,-1,0,-2},{0.433,0,0,2},{0.500,1,0,3.5},
        {0.566,1,0,2.5},{0.633,0,0,1},{0.700,0,0,0},
    }
end

do -- LIMB TABLES
    M.LB.R6 = {
        RightArm={"Right Arm"}, LeftArm={"Left Arm"},
        RightLeg={"Right Leg"}, LeftLeg={"Left Leg"},
    }
    M.LB.R15 = {
        RightArm={"RightUpperArm","RightLowerArm","RightHand"},
        LeftArm ={"LeftUpperArm","LeftLowerArm","LeftHand"},
        RightLeg={"RightUpperLeg","RightLowerLeg","RightFoot"},
        LeftLeg ={"LeftUpperLeg","LeftLowerLeg","LeftFoot"},
    }
    M.LB.TORSO = { R6={"Torso"}, R15={"UpperTorso","LowerTorso"} }
    M.LB.REGEN_ORDER = {"Head","Torso","RightArm","LeftArm","RightLeg","LeftLeg"}
end

local function svc(n)
    local ok, s = pcall(function() return game:GetService(n) end)
    return ok and s or nil
end
local Players          = svc("Players")
local CoreGui          = svc("CoreGui")
local RunService       = svc("RunService")
local TweenService     = svc("TweenService")
local UserInputService = svc("UserInputService")
local Lighting         = svc("Lighting")
local SoundService     = svc("SoundService")
local StarterGui       = svc("StarterGui")
local InsertService    = svc("InsertService")

local LocalPlayer = Players and Players.LocalPlayer
if not LocalPlayer then
    local t0 = os.clock()
    repeat task.wait(0.1) LocalPlayer = Players.LocalPlayer until LocalPlayer or os.clock()-t0 > 15
end
if not LocalPlayer then warn("[MONO] LocalPlayer не найден"); return end

local Camera = workspace.CurrentCamera
if not Camera then
    local t0 = os.clock()
    repeat task.wait(0.1) Camera = workspace.CurrentCamera until Camera or os.clock()-t0 > 10
end

local p = LocalPlayer

pcall(function()
    if CoreGui then
        for _, n in ipairs({"MonoPortalGunGui","MonoMobileBombGui"}) do
            local o = CoreGui:FindFirstChild(n); if o then o:Destroy() end
        end
    end
end)
if workspace:FindFirstChild("MonoRegenFX") then workspace.MonoRegenFX:Destroy() end
if workspace:FindFirstChild("MonoFlyModel") then workspace.MonoFlyModel:Destroy() end
if workspace:FindFirstChild("MonoAntiFling") then workspace.MonoAntiFling:Destroy() end
pcall(function() RunService:UnbindFromRenderStep("MonoDeathCam") end)
pcall(function() RunService:UnbindFromRenderStep("MonoCine") end)
if getgenv and getgenv().hardStopFlight then pcall(getgenv().hardStopFlight); getgenv().hardStopFlight = nil end
if getgenv then getgenv().toggleFlight = nil end
if getgenv and getgenv().MonoConnections then
    for _, c in ipairs(getgenv().MonoConnections) do
        pcall(function() if c.Connected then c:Disconnect() end end)
    end
end
if getgenv then getgenv().MonoConnections = {} end
if getgenv and getgenv().MonoHoleParts then
    for part in pairs(getgenv().MonoHoleParts) do
        if part and part.Parent then pcall(function() part.CanCollide = true end) end
    end
end
if getgenv then getgenv().MonoHoleParts = {} end

local function track(c) if getgenv then table.insert(getgenv().MonoConnections, c) end; return c end
local function log(...) print("[MONO]", ...) end
log("=== COMBINED v21 LOADING ===")

local destroyPortalPart
local shoot

getgenv().PrimePrinterConfig = {
    AutoRegen=false, AutoShatter=false, ShatterHP=20,
    LimbLossRegen=true, LimbLossHP=15, LimbLossCooldown=1.5,
    RespawnAtDeathSpot=true, RespawnFromOneLimb=true,
    HideForceField=true, LockCameraOnDeath=false,
    SecondWind=false, SecondWindHP=25, SecondWindHeal=0.5, SecondWindCD=75,
    RegenSpeed=1.0, RegenRedFlash=false,
}
local config = getgenv().PrimePrinterConfig

local function isClothingDecal(d)
    if not d or not d:IsA("Decal") then return false end
    local par = d.Parent; if not par then return false end
    if par:IsA("Shirt") or par:IsA("Pants") or par:IsA("TShirt") or par:IsA("Clothing") then return true end
    local pn = string.lower(par.Name or "")
    if pn=="shirt" or pn=="pants" or pn=="tshirt" or pn=="clothing"
        or pn=="classic shirt" or pn=="classic pants" or pn=="classic tshirt" then return true end
    local dn = string.lower(d.Name or "")
    if dn=="shirt" or dn=="pants" or dn=="tshirt" then return true end
    return false
end
local function isAccessoryHandle(part)
    if not part or not part:IsA("BasePart") then return false end
    local par = part.Parent
    if not par then return false end
    return par:IsA("Accessory") or par:IsA("Hat")
end
local function isInsideAccessory(obj)
    if not obj then return false end
    local par = obj.Parent
    while par and par ~= workspace do
        if par:IsA("Accessory") or par:IsA("Hat") then return true end
        par = par.Parent
    end
    return false
end
local function isInsideTool(obj) return obj:FindFirstAncestorWhichIsA("Tool") ~= nil end

local walkMode, savedWalkSpeed = false, M.W.NORMAL
local function applyWalkMode()
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.WalkSpeed == 0 and walkMode then return end
    hum.WalkSpeed = walkMode and M.W.CALM or savedWalkSpeed
end
local function setWalkMode(state, silent)
    walkMode = state; applyWalkMode()
    if not silent then
        pcall(function() StarterGui:SetCore("SendNotification",
            {Title=walkMode and "Походка: СПОКОЙНАЯ" or "Походка: ОБЫЧНАЯ", Text="[H]", Duration=3}) end)
    end
end
local function toggleWalkMode() setWalkMode(not walkMode) end

local function hideForceFields(char)
    if not config.HideForceField then return end
    local function hide(ff) if ff and ff:IsA("ForceField") then pcall(function() ff.Visible=false end) end end
    for _, d in ipairs(char:GetDescendants()) do hide(d) end
    track(char.DescendantAdded:Connect(hide))
end

local function cameraShake(intensity, duration)
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    task.spawn(function()
        local t0 = os.clock()
        while os.clock()-t0 < duration do
            local d = 1 - (os.clock()-t0)/duration
            hum.CameraOffset = Vector3.new(
                (math.random()-0.5)*2*intensity*d,
                (math.random()-0.5)*2*intensity*d,
                (math.random()-0.5)*2*intensity*d*0.5)
            RunService.RenderStepped:Wait()
        end
        hum.CameraOffset = Vector3.new(0,0,0)
    end)
end

-- =====================================================================
-- GUNS
-- =====================================================================
local GUN_DEFS = {
    evil_morty = {
        id="evil_morty", name="Evil Morty Portal Gun",
        assetId="rbxassetid://113344864471588",
        muzzleOffset=CFrame.new(0,0,-2),
        portalTexture="rbxassetid://129332930839385",
        beamColor=Color3.fromRGB(190,255,205),
        recolor=true,
        defaultConfig={posX=0.00,posY=0.65,posZ=-0.25,rotX=180,rotY=180,rotZ=180,scale=1.25},
    },
    rick_portal = {
        id="rick_portal", name="Rick Portal Gun",
        assetId="rbxassetid://126868848475018",
        muzzleOffset=CFrame.new(0,0,-2),
        portalTexture="rbxassetid://111394501324479",
        portalModelId="rbxassetid://75803396857476",
        beamColor=Color3.fromRGB(190,255,205),
        recolor=false,
        defaultConfig={posX=0.00,posY=0.65,posZ=-0.25,rotX=180,rotY=180,rotZ=180,scale=1.25},
    },
}
local GUN_ORDER = { "evil_morty", "rick_portal" }
local GUN_PORTAL_STYLE = {
    portalSize=8.5, spinSpeed=0.65, disappearTime=0.30, imageFinalTrans=0,
    openSlitW=0.045, openSlitH=1.30, openWideW=1.50, openWideH=0.50,
    openSettleW=0.85, openSettleH=1.15, openT1=0.11, openT2=0.12, openT3=0.14,
}
local HEROES = {
    evil_morty_2 = {
        id="evil_morty_2", name="Evil Morty", accent=Color3.fromRGB(255,200,90),
        desc="[R] сканер · [H] ходьба · [6] распад\n[Q] полёт · [8] щит · [N] пушка\n[B] кино-бомба · [Backspace] отмена\nПорталы [Z C X E V]\nЛКМ с бомбой = бросок",
        abilities={walk=true, modes=true, scanner=true},
    },
}
local currentHero = HEROES.evil_morty_2
getgenv().currentHeroId = currentHero.id

local currentDestination = "Normal"
local spawnedGarage, spawnedRetro, spawnedOmega
local garageSpawnPoint, omegaSpawnPoint
local nextPortal, returnPosition = 1, nil
local Guns = {}
local activeGunId = "evil_morty"
local portal1, portal2
local lastTeleport, arrivedAt, isTeleporting = 0, nil, false
local screenGui, configFrame, codeBox
local configRows, gunSelectorButtons = {}, {}
local emoteActive, emoteToken, idleClock, lastMoveStateAnim = false, 0, 0, nil
local scannerActive, hasTarget, stickyTarget = false, false, nil
local gunShotT = -10
local flight = {active=false, vel=Vector3.zero, t0=0}
local EXT = {}

local function getActiveGun() return Guns[activeGunId] end

local sSnd = Instance.new("Sound"); sSnd.SoundId=M.SND.SPAWN; sSnd.Volume=1.5; sSnd.Parent=workspace
local tSnd = Instance.new("Sound"); tSnd.SoundId=M.SND.SPAWN; tSnd.Volume=1.5; tSnd.Parent=workspace
local enterSnd = Instance.new("Sound"); enterSnd.SoundId=M.SND.ENTER; enterSnd.Volume=1.5; enterSnd.Parent=workspace

local function notify(t, x)
    pcall(function() StarterGui:SetCore("SendNotification",{Title=t,Text=x,Duration=3}) end)
end
local function gunCFrame(cfg)
    return CFrame.new(cfg.posX,cfg.posY,cfg.posZ)
        * CFrame.Angles(math.rad(cfg.rotX),math.rad(cfg.rotY),math.rad(cfg.rotZ))
end

local function loadAssetModel(assetId)
    if not assetId then return nil end
    local clean = tostring(assetId):gsub("rbxassetid://", "")
    local ids = {clean, "rbxassetid://" .. clean}
    for _, id in ipairs(ids) do
        local ok, objs = pcall(function() return game:GetObjects(id) end)
        if ok and objs and objs[1] then
            local obj = objs[1]
            if obj:IsA("Tool") then
                local m = Instance.new("Model"); obj.Parent = m; return m
            elseif obj:IsA("Model") then
                return obj
            elseif obj:IsA("BasePart") then
                local m = Instance.new("Model"); obj.Parent = m; return m
            end
        end
    end
    if InsertService then
        local num = tonumber(clean:match("%d+"))
        if num then
            local ok, model = pcall(function() return InsertService:LoadAsset(num) end)
            if ok and model then
                for _, child in ipairs(model:GetChildren()) do
                    if child:IsA("Model") then return child end
                    if child:IsA("Tool") then
                        local m = Instance.new("Model"); child.Parent = m; return m
                    end
                    if child:IsA("BasePart") then
                        local m = Instance.new("Model"); child.Parent = m; return m
                    end
                end
                return model
            end
        end
    end
    warn("[MONO] Не удалось загрузить модель: " .. tostring(assetId))
    return nil
end

local function recolorGunModel(folder)
    if not folder then return end
    for _, part in ipairs(folder:GetDescendants()) do
        if part:IsA("BasePart") then
            local c = part.Color
            if c.R>0.5 and c.G>0.4 and c.B<0.45 and (c.R+c.G)>c.B*2 then
                part.Color = Color3.fromRGB(60,62,75)
                if part.Material==Enum.Material.Neon then part.Material=Enum.Material.Metal end
            end
        end
    end
end

local function buildGunInstance(def)
    local gc = def.config
    local gun = {def=def, config=gc, tool=nil, handle=nil, muzzle=nil, bodyFolder=nil, welds={}, muzzleWeld=nil}
    local t = Instance.new("Tool")
    t.Name=def.name; t.RequiresHandle=true; t.CanBeDropped=false
    local h = Instance.new("Part")
    h.Name="Handle"; h.Size=Vector3.new(0.2,0.2,0.2); h.Transparency=1
    h.CanCollide=false; h.CanTouch=false; h.CanQuery=false; h.Massless=true
    h.Parent=t
    local snd = Instance.new("Sound"); snd.Name="ShotSound"; snd.SoundId=M.SND.SPAWN; snd.Volume=1.2; snd.Parent=h
    t.PrimaryPart = h
    gun.tool=t; gun.handle=h
    local folder = Instance.new("Folder"); folder.Name="GunBody"; folder.Parent=t
    gun.bodyFolder = folder
    local src = loadAssetModel(def.assetId)
    if src then
        if not src:IsA("Model") then
            local w = Instance.new("Model"); src.Parent = w; src = w
        end
        local sp = src:GetPivot()
        for _, o in ipairs(src:GetDescendants()) do
            if o:IsA("Script") or o:IsA("LocalScript") or o:IsA("ModuleScript") then o:Destroy() end
        end
        for _, part in ipairs(src:GetDescendants()) do
            if part:IsA("BasePart") then
                local rel = sp:ToObjectSpace(part.CFrame)
                local bs = part.Size
                part.Anchored=false; part.CanCollide=false
                part.CanTouch=false; part.CanQuery=false; part.Massless=true
                part.Parent = folder
                local weld = Instance.new("Weld")
                weld.Part0=h; weld.Part1=part
                weld.C0 = gunCFrame(gc)*rel; weld.C1 = CFrame.new()
                weld.Parent=h
                table.insert(gun.welds, {weld=weld, baseCF=rel, part=part, baseSize=bs})
            end
        end
        src:Destroy()
    end
    if def.recolor then recolorGunModel(folder) end
    if #gun.welds == 0 then
        local function mkFb(name, size, color, material, relCF)
            local fb = Instance.new("Part")
            fb.Name=name; fb.Size=size
            fb.Color=color; fb.Material=material or Enum.Material.Metal
            fb.Anchored=false; fb.CanCollide=false
            fb.CanTouch=false; fb.CanQuery=false; fb.Massless=true
            fb.Parent=folder
            local weld = Instance.new("Weld")
            weld.Part0=h; weld.Part1=fb
            weld.C0 = gunCFrame(gc)*relCF; weld.C1=CFrame.new()
            weld.Parent=h
            table.insert(gun.welds, {weld=weld, baseCF=relCF, part=fb, baseSize=size})
        end
        mkFb("FbBody", Vector3.new(0.55,0.55,1.5), Color3.fromRGB(60,62,75), Enum.Material.Metal, CFrame.new(0,0,-0.4))
        mkFb("FbBarrel", Vector3.new(0.32,0.32,1.6), Color3.fromRGB(75,78,92), Enum.Material.Metal, CFrame.new(0,0,-1.7))
        mkFb("FbGrip", Vector3.new(0.28,0.7,0.35), Color3.fromRGB(40,42,52), Enum.Material.Metal, CFrame.new(0,-0.5,0.1)*CFrame.Angles(math.rad(15),0,0))
        mkFb("FbMuzzle", Vector3.new(0.42,0.42,0.2), Color3.fromRGB(140,255,180), Enum.Material.Neon, CFrame.new(0,0,-2.5))
    end
    local muzzle = Instance.new("Part")
    muzzle.Name="Muzzle"; muzzle.Size=Vector3.new(0.2,0.2,0.2)
    muzzle.Transparency=1; muzzle.CanCollide=false; muzzle.Massless=true
    muzzle.Parent=t
    gun.muzzle = muzzle
    local mw = Instance.new("Weld")
    mw.Part0=h; mw.Part1=muzzle
    mw.C0 = gunCFrame(gc)*(def.muzzleOffset or CFrame.new(0,0,-1))
    mw.C1 = CFrame.new(); mw.Parent=h
    gun.muzzleWeld = mw
    return gun
end

local function applyGunConfig(gun)
    gun = gun or getActiveGun()
    if not gun or not gun.welds then return end
    local gc = gun.config
    local s = gc.scale
    local gcf = gunCFrame(gc)
    for _, e in ipairs(gun.welds) do
        if e.weld and e.weld.Parent then
            local sc = CFrame.new(e.baseCF.Position*s)*(e.baseCF-e.baseCF.Position)
            e.weld.C0 = gcf*sc
            if e.part and e.part.Parent and e.baseSize then e.part.Size = e.baseSize*s end
        end
    end
    if gun.muzzleWeld and gun.muzzleWeld.Parent then
        local mo = gun.def.muzzleOffset or CFrame.new(0,0,-1)
        local sm = CFrame.new(mo.Position*s)*(mo-mo.Position)
        gun.muzzleWeld.C0 = gcf*sm
    end
end

local function updateCodeBox()
    if not codeBox then return end
    local gun = getActiveGun(); if not gun then return end
    local c = gun.config
    codeBox.Text = string.format("[%s]\nGUN_POS=Vector3.new(%.2f,%.2f,%.2f)\nGUN_ROT=CFrame.Angles(math.rad(%.0f),math.rad(%.0f),math.rad(%.0f))\nGUN_SCALE=%.2f",
        gun.def.name, c.posX,c.posY,c.posZ, c.rotX,c.rotY,c.rotZ, c.scale)
end
local function refreshAllConfigRows()
    local gun = getActiveGun(); if not gun then return end
    for _, e in ipairs(configRows) do
        if e.valLbl and e.valLbl.Parent then e.valLbl.Text = string.format("%.2f", gun.config[e.key]) end
    end
end
local function refreshGunSelectorStyles()
    for id, btn in pairs(gunSelectorButtons) do
        if btn and btn.Parent then
            local a = id==activeGunId
            btn.BackgroundColor3 = a and Color3.fromRGB(70,90,130) or Color3.fromRGB(30,30,44)
            local s = btn:FindFirstChild("Stroke")
            if s then s.Color = a and Color3.fromRGB(140,180,255) or Color3.fromRGB(75,75,105) end
        end
    end
end
local function setActiveGun(id)
    if not GUN_DEFS[id] then return end
    activeGunId = id
    refreshGunSelectorStyles(); refreshAllConfigRows(); updateCodeBox()
end

local function removeAllGunTools()
    local names = {}
    for _, def in pairs(GUN_DEFS) do names[def.name]=true end
    local bp = p:FindFirstChild("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") and names[v.Name] then v:Destroy() end
        end
    end
    if p.Character then
        for _, v in ipairs(p.Character:GetChildren()) do
            if v:IsA("Tool") and names[v.Name] then v:Destroy() end
        end
    end
end

local function giveGuns()
    if portal1 and destroyPortalPart then destroyPortalPart(portal1) end
    if portal2 and destroyPortalPart then destroyPortalPart(portal2) end
    portal1, portal2 = nil, nil
    arrivedAt = nil; isTeleporting = false; nextPortal = 1
    removeAllGunTools(); Guns = {}
    for _, id in ipairs(GUN_ORDER) do
        local def = GUN_DEFS[id]
        def.config = def.config or {}
        for k, v in pairs(def.defaultConfig) do
            if def.config[k]==nil then def.config[k]=v end
        end
        local ok, gun = pcall(buildGunInstance, def)
        if ok and gun then
            Guns[id] = gun
            if not def.noShoot then
                gun.tool.Activated:Connect(function() if shoot then shoot(gun) end end)
            end
            applyGunConfig(gun)
        else
            warn("[giveGuns] Не удалось собрать "..tostring(id))
        end
    end
    local bp = p:FindFirstChild("Backpack") or p:WaitForChild("Backpack", 10)
    if not bp then warn("[giveGuns] Backpack нет!"); return end
    for _, id in ipairs(GUN_ORDER) do
        if Guns[id] and Guns[id].tool then Guns[id].tool.Parent = bp end
    end
    local names = {}
    for _, id in ipairs(GUN_ORDER) do table.insert(names, GUN_DEFS[id].name) end
    notify("Оружие выдано", table.concat(names, " · "))
end

local function saveReturnPosition()
    if not returnPosition and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        returnPosition = p.Character.HumanoidRootPart.Position
    end
end
local function positionModel(model, targetPos)
    local ok = pcall(function() model:PivotTo(CFrame.new(targetPos)) end)
    if not ok then
        local cf = model:GetBoundingBox()
        local off = targetPos - cf.Position
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then part.CFrame = part.CFrame + off end
        end
    end
end
local function ignoreList()
    local list = {}
    if p.Character then table.insert(list, p.Character) end
    for _, gun in pairs(Guns) do if gun and gun.tool then table.insert(list, gun.tool) end end
    if portal1 and portal1.part then table.insert(list, portal1.part) end
    if portal2 and portal2.part then table.insert(list, portal2.part) end
    local fm = workspace:FindFirstChild("MonoFlyModel")
    if fm then table.insert(list, fm) end
    local afm = workspace:FindFirstChild("MonoAntiFling")
    if afm then table.insert(list, afm) end
    return list
end
local function findGround(pos, fromY)
    if fromY == nil then fromY = 400 end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = ignoreList()
    local o = pos + Vector3.new(0,fromY,0)
    local r = workspace:Raycast(o, Vector3.new(0,-2000,0), rp)
    return r and r.Position or pos
end
local function createBeam(a, b, color)
    local dist = (b-a).Magnitude
    if dist < 0.1 then return end
    local beam = Instance.new("Part")
    beam.Anchored=true; beam.CanCollide=false; beam.CanTouch=false; beam.CanQuery=false
    beam.Size=Vector3.new(0.2,0.2,dist)
    beam.Color=color or Color3.fromRGB(200,220,255)
    beam.Material=Enum.Material.Neon
    beam.CFrame=CFrame.lookAt(a,b)*CFrame.new(0,0,-dist/2)
    beam.Parent=workspace
    local tw = TweenService:Create(beam, TweenInfo.new(0.15), {Size=Vector3.new(0,0,dist), Transparency=1})
    tw:Play(); tw.Completed:Connect(function() beam:Destroy() end)
end

local function getFxFolder()
    local f = workspace:FindFirstChild("MonoRegenFX")
    if not f then f = Instance.new("Folder"); f.Name="MonoRegenFX"; f.Parent=workspace end
    return f
end
local function lookCF(from, to)
    local dir = to - from
    if dir.Magnitude < 1e-4 then return CFrame.new(from) end
    local up = (math.abs(dir.Unit.Y) > 0.98) and Vector3.new(1,0,0) or Vector3.new(0,1,0)
    return CFrame.lookAt(from, to, up)
end
local function randUnit()
    for _=1,20 do
        local v = Vector3.new(math.random()*2-1, math.random()*2-1, math.random()*2-1)
        local mg = v.Magnitude
        if mg>0.1 and mg<=1 then return v/mg end
    end
    return Vector3.new(0,1,0)
end
local function safeUnit(v, fb) if v.Magnitude > 0.05 then return v.Unit end; return fb end

-- =====================================================================
-- REGEN MODEL HELPERS
-- =====================================================================
local REGEN_MODEL_CACHE = {}
local function getRegenModelSrc(key)
    if REGEN_MODEL_CACHE[key] ~= nil then return REGEN_MODEL_CACHE[key] end
    local id = M.RGN_IDS[key]
    if not id then REGEN_MODEL_CACHE[key] = false; return false end
    local ok, mdl = pcall(loadAssetModel, id)
    if ok and mdl then
        REGEN_MODEL_CACHE[key] = mdl
        return mdl
    end
    REGEN_MODEL_CACHE[key] = false
    return false
end
local function getRegenModelCfg(key)
    local t = getgenv().RegenModelConfig
    if not t then return nil end
    return t[key]
end
local function applyRegenModelCfg(key, model)
    local cfg = getRegenModelCfg(key)
    if not cfg or not model then return end
    pcall(function() model:ScaleTo(cfg.scale or 1) end)
end
local function regenModelCF(key, baseCF)
    local cfg = getRegenModelCfg(key)
    if not cfg then return baseCF end
    local off = CFrame.new(cfg.offX or 0, cfg.offY or 0, cfg.offZ or 0)
        * CFrame.Angles(math.rad(cfg.rotX or 0), math.rad(cfg.rotY or 0), math.rad(cfg.rotZ or 0))
    return baseCF * off
end
local function buildRegenModel(key)
    local src = getRegenModelSrc(key)
    if not src then return nil end
    local clone = src:Clone()
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
            d:Destroy()
        elseif d:IsA("BasePart") then
            d.Anchored = true
            d.CanCollide = false
            d.CanTouch = false
            d.CanQuery = false
            d.CastShadow = false
        end
    end
    applyRegenModelCfg(key, clone)
    return clone
end
local function hideRegenModel(model)
    if not model then return end
    pcall(function() model:PivotTo(CFrame.new(0, -5000, 0)) end)
end

-- =====================================================================
-- EMOTE
-- =====================================================================
local function getRightShoulder(char)
    if not char then return nil end
    return char:FindFirstChild("Right Shoulder", true) or char:FindFirstChild("RightShoulder", true)
end
local function findJoint(char, ...)
    if not char then return nil end
    for _, n in ipairs({...}) do
        local j = char:FindFirstChild(n, true)
        if j and (j:IsA("Motor6D") or j:IsA("JointInstance")) then return j end
    end
end
local function collectEmoteJoints(char)
    if not char then return {} end
    return {
        shoulder = getRightShoulder(char),
        elbow    = findJoint(char, "RightElbow"),
        wrist    = findJoint(char, "RightWrist"),
        neck     = findJoint(char, "Neck"),
        torso    = findJoint(char, "Waist"),
    }
end
local function catmull(p0,p1,p2,p3,u)
    local u2,u3 = u*u, u*u*u
    return 0.5*((2*p1)+(-p0+p2)*u+(2*p0-5*p1+4*p2-p3)*u2+(-p0+3*p1-3*p2+p3)*u3)
end
local function sampleKeys(keys, t)
    local n = #keys
    if t <= keys[1][1] then return keys[1][2],keys[1][3],keys[1][4] end
    if t >= keys[n][1] then return keys[n][2],keys[n][3],keys[n][4] end
    for i=1,n-1 do
        local k1,k2 = keys[i],keys[i+1]
        if t>=k1[1] and t<=k2[1] then
            local k0=keys[math.max(i-1,1)]
            local k3=keys[math.min(i+2,n)]
            local u=(t-k1[1])/(k2[1]-k1[1])
            return catmull(k0[2],k1[2],k2[2],k3[2],u),
                   catmull(k0[3],k1[3],k2[3],k3[3],u),
                   catmull(k0[4],k1[4],k2[4],k3[4],u)
        end
    end
    return 0,0,0
end
local function applyJointRot(joint, cache, rx, ry, rz)
    if not joint or not joint.Parent then return end
    local c = cache[joint]
    if not c then
        local c0 = joint.C0
        local rc = c0 - c0.Position
        c = {rc=rc, rcInv=rc:Inverse()}; cache[joint] = c
    end
    local R = CFrame.Angles(math.rad(rx), math.rad(ry), math.rad(rz))
    joint.Transform = c.rcInv * R * c.rc
end
local function resetJoint(j) if j and j.Parent then j.Transform = CFrame.new() end end

local function playEmote()
    if emoteActive or flight.active then return end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local joints = collectEmoteJoints(char)
    if not joints.shoulder then return end
    emoteActive = true; emoteToken = emoteToken + 1
    local token = emoteToken
    local cache = {}
    local total = M.EK.SHOULDER[#M.EK.SHOULDER][1]
    local t0 = os.clock()
    local conns = {}
    local function finish()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        for _, j in pairs(joints) do resetJoint(j) end
        if token == emoteToken then emoteActive = false; lastMoveStateAnim = nil end
    end
    local function step()
        local t = (os.clock()-t0)*M.EK.SPEED
        if token ~= emoteToken or not joints.shoulder.Parent or hum.Health<=0 or t>=total then
            finish(); return
        end
        local sx,sy,sz = sampleKeys(M.EK.SHOULDER, t)
        applyJointRot(joints.shoulder, cache, sx,sy,sz)
        if joints.elbow then
            local ex,ey,ez = sampleKeys(M.EK.ELBOW, t)
            applyJointRot(joints.elbow, cache, ex,ey,ez)
        end
        if joints.wrist then
            local wx,wy,wz = sampleKeys(M.EK.WRIST, t)
            applyJointRot(joints.wrist, cache, wx,wy,wz)
        end
        if M.EK.HEAD_TRACK and joints.neck then
            local nx,ny,nz = sampleKeys(M.EK.NECK, t)
            applyJointRot(joints.neck, cache, nx,ny,nz)
        end
        if M.EK.TORSO_LEAN and joints.torso then
            local tx,ty,tz = sampleKeys(M.EK.TORSO, t)
            applyJointRot(joints.torso, cache, tx,ty,tz)
        end
    end
    table.insert(conns, RunService.Stepped:Connect(step))
    table.insert(conns, RunService.Heartbeat:Connect(step))
    table.insert(conns, RunService.RenderStepped:Connect(step))
    for _, c in ipairs(conns) do track(c) end
end

-- =====================================================================
-- СУСТАВЫ (R6 + R15)
-- =====================================================================
local rotCache = setmetatable({}, {__mode="k"})
local jointsCache = setmetatable({}, {__mode="k"})

local function smooth01(x) x = math.clamp(x,0,1); return x*x*(3-2*x) end

local function getBodyJoints(char)
    local c = jointsCache[char]
    if c and c.shoulderR and c.shoulderR.Parent then return c end
    c = {
        root      = findJoint(char, "RootJoint", "Root"),
        waist     = findJoint(char, "Waist"),
        neck      = findJoint(char, "Neck"),
        shoulderR = findJoint(char, "Right Shoulder", "RightShoulder"),
        shoulderL = findJoint(char, "Left Shoulder", "LeftShoulder"),
        elbowR    = findJoint(char, "RightElbow"),
        elbowL    = findJoint(char, "LeftElbow"),
        wristR    = findJoint(char, "RightWrist"),
        wristL    = findJoint(char, "LeftWrist"),
        hipR      = findJoint(char, "Right Hip", "RightHip"),
        hipL      = findJoint(char, "Left Hip", "LeftHip"),
        kneeR     = findJoint(char, "RightKnee"),
        kneeL     = findJoint(char, "LeftKnee"),
    }
    jointsCache[char] = c
    return c
end
local function rot(j, x, y, z)
    if j then applyJointRot(j, rotCache, x, y, z) end
end
local function getHeldGun(char)
    for _, gun in pairs(Guns) do
        if gun and gun.tool and gun.tool.Parent == char then return gun end
    end
    return nil
end
local function gunRaiseAmount()
    local dt = os.clock() - gunShotT
    if dt < 0 then return 0 end
    local UP, HOLD, DOWN = 0.12, 0.30, 0.35
    if dt < UP then return smooth01(dt/UP)
    elseif dt < UP+HOLD then return 1
    elseif dt < UP+HOLD+DOWN then return 1 - smooth01((dt-UP-HOLD)/DOWN)
    end
    return 0
end

-- =====================================================================
-- ПОЛЁТ: модель
-- =====================================================================
local flyModelSrc = nil
local function getFlyModelSrc()
    if flyModelSrc ~= nil then return flyModelSrc end
    local ok, m = pcall(loadAssetModel, M.FLY.ID)
    flyModelSrc = (ok and m) or false
    return flyModelSrc
end

local function buildFlyModel(hrp)
    local src = getFlyModelSrc()
    if not src then return nil end
    local cfg = getgenv().FlyModelConfig
    local model = src:Clone()
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
            or d:IsA("JointInstance") or d:IsA("WeldConstraint") then
            d:Destroy()
        end
    end
    local parts = {}
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then table.insert(parts, d) end
    end
    if #parts == 0 then model:Destroy(); return nil end
    model.Name = "MonoFlyModel"
    model.Parent = workspace
    for _, pt in ipairs(parts) do
        pt.Anchored = true; pt.CanCollide = false; pt.CanTouch = false; pt.CanQuery = false
        pt.Massless = true
    end
    pcall(function() model:ScaleTo(cfg.scale or 1) end)

    local primary, bestVol = parts[1], -1
    for _, pt in ipairs(parts) do
        local v = pt.Size.X * pt.Size.Y * pt.Size.Z
        if v > bestVol then bestVol = v; primary = pt end
    end
    pcall(function() model.PrimaryPart = primary end)

    local bbCF, bbSize = model:GetBoundingBox()
    local pivotToBB = model:GetPivot():ToObjectSpace(bbCF)

    local function computePivotInHrp()
        local c = getgenv().FlyModelConfig
        local depth = (math.abs(math.sin(math.rad(c.rotY or 0))) > 0.5) and bbSize.X or bbSize.Z
        local want = CFrame.new(c.offX or 0, c.offY or 0, (c.offZ or 0) - (depth/2 + (c.gap or 1.3)))
            * CFrame.Angles(math.rad(c.rotX or 0), math.rad(c.rotY or 0), math.rad(c.rotZ or 0))
        return want * pivotToBB:Inverse()
    end

    model:PivotTo(hrp.CFrame * computePivotInHrp())

    for _, pt in ipairs(parts) do
        if pt ~= primary then
            local w = Instance.new("Weld")
            w.Part0 = primary; w.Part1 = pt
            w.C0 = primary.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
            w.Parent = pt
        end
    end
    local hw = Instance.new("Weld")
    hw.Name = "MonoFlyWeld"
    hw.Part0 = hrp; hw.Part1 = primary
    hw.C0 = hrp.CFrame:ToObjectSpace(primary.CFrame); hw.C1 = CFrame.new()
    hw.Parent = primary
    for _, pt in ipairs(parts) do pt.Anchored = false end
    return model, {weld=hw, computePivotInHrp=computePivotInHrp}
end

-- =====================================================================
-- ★ ОБЩИЕ ЭФФЕКТЫ ВЗРЫВОВ (FXH)
-- =====================================================================
local FXH = {}
do
    local NSK = NumberSequenceKeypoint.new
    local GRAV = Vector3.new(0, -130, 0)
    local bodies = {}
    local stepConn = nil
    local ROCK_MATS = {
        Enum.Material.Slate, Enum.Material.Basalt, Enum.Material.Granite,
        Enum.Material.Concrete, Enum.Material.Rock,
    }

    local function rayParams()
        local ex = {getFxFolder()}
        if p.Character then table.insert(ex, p.Character) end
        for _, gun in pairs(Guns) do if gun and gun.tool then table.insert(ex, gun.tool) end end
        local fm = workspace:FindFirstChild("MonoFlyModel"); if fm then table.insert(ex, fm) end
        local af = workspace:FindFirstChild("MonoAntiFling"); if af then table.insert(ex, af) end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= p and pl.Character then table.insert(ex, pl.Character) end
        end
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = ex
        rp.IgnoreWater = true
        return rp
    end
    FXH.rayParams = rayParams

    local function anchorAt(pos, life)
        local a = Instance.new("Part")
        a.Anchored = true; a.CanCollide = false; a.CanTouch = false; a.CanQuery = false
        a.CastShadow = false; a.Transparency = 1; a.Size = Vector3.new(0.2,0.2,0.2)
        a.CFrame = CFrame.new(pos); a.Parent = getFxFolder()
        if life then task.delay(life, function() if a then a:Destroy() end end) end
        return a
    end
    FXH.anchorAt = anchorAt

    local function lifeFade(part, life)
        task.delay(life, function()
            if part and part.Parent then
                TweenService:Create(part, TweenInfo.new(1, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
                task.delay(1.05, function() if part then part:Destroy() end end)
            end
        end)
    end

    local function groundColor(hit)
        local c = Color3.fromRGB(125,122,118)
        local inst = hit and hit.Instance
        if inst and inst:IsA("BasePart") and not inst:IsA("Terrain") then
            c = c:Lerp(inst.Color, 0.55)
        end
        return c
    end

    local function step(dt)
        dt = math.min(dt, 0.05)
        if #bodies == 0 then
            if stepConn then stepConn:Disconnect(); stepConn = nil end
            return
        end
        local rp = rayParams()
        for i = #bodies, 1, -1 do
            local b = bodies[i]
            local part = b.part
            if not part or not part.Parent then
                table.remove(bodies, i)
            elseif not b.rest then
                b.vel = b.vel + GRAV*dt
                local sv = b.vel*dt
                local hit = nil
                if sv.Magnitude > 1e-4 then
                    hit = workspace:Raycast(b.pos, sv + sv.Unit*b.rad, rp)
                end
                if hit then
                    local n = hit.Normal
                    b.pos = hit.Position + n*(b.rad*0.9)
                    local vn = n*b.vel:Dot(n)
                    local vt = b.vel - vn
                    b.vel = vt*0.6 - vn*0.32
                    b.spin = b.spin*0.55
                    b.bounces = b.bounces + 1
                    if b.onImpact then
                        local f = b.onImpact; b.onImpact = nil
                        pcall(f, b, hit)
                    end
                    if b.vel.Magnitude < 8 or b.bounces >= 4 then
                        b.rest = true
                        local base = lookCF(b.pos, b.pos + n) * CFrame.Angles(-math.pi/2, 0, 0)
                        local restCF = base * CFrame.Angles(
                            (math.random()-0.5)*0.5, math.random()*6.283, (math.random()-0.5)*0.5)
                        part.CFrame = restCF + (-n*(b.rad*0.35))
                    else
                        b.rot = CFrame.Angles(b.spin.X*dt, b.spin.Y*dt, b.spin.Z*dt) * b.rot
                        part.CFrame = CFrame.new(b.pos) * b.rot
                    end
                else
                    b.pos = b.pos + sv
                    b.rot = CFrame.Angles(b.spin.X*dt, b.spin.Y*dt, b.spin.Z*dt) * b.rot
                    part.CFrame = CFrame.new(b.pos) * b.rot
                    if b.pos.Y < -500 then
                        table.remove(bodies, i); part:Destroy()
                    end
                end
            end
        end
    end

    function FXH.addBody(part, vel, spin, rad, life, onImpact)
        local cf = part.CFrame
        local b = {
            part = part, pos = cf.Position, rot = cf - cf.Position,
            vel = vel, spin = spin, rad = rad, bounces = 0, rest = false,
            onImpact = onImpact,
        }
        table.insert(bodies, b)
        if not stepConn then stepConn = RunService.Heartbeat:Connect(step) end
        lifeFade(part, life or 4)
    end

    function FXH.groundHit(pos, maxDist)
        local hit = workspace:Raycast(pos + Vector3.new(0,3,0),
            Vector3.new(0, -((maxDist or 20) + 3), 0), rayParams())
        if hit and hit.Normal.Y > 0.6 then return hit end
        return nil
    end

    function FXH.trail(part, dur, color, size)
        local e = Instance.new("ParticleEmitter")
        e.Rate = 40; e.Lifetime = NumberRange.new(0.5, 1.1)
        e.Speed = NumberRange.new(0.5, 3)
        e.SpreadAngle = Vector2.new(180, 180)
        e.Color = ColorSequence.new(color or Color3.fromRGB(80,76,72))
        e.Size = NumberSequence.new({NSK(0, size or 1), NSK(1, (size or 1)*3)})
        e.Transparency = NumberSequence.new({NSK(0, 0.5), NSK(1, 1)})
        e.LightInfluence = 1
        e.Parent = part
        task.delay(dur, function() if e and e.Parent then e.Enabled = false end end)
    end

    function FXH.shell(pos, color, material, startS, endS, dur, trStart, style)
        local s = Instance.new("Part")
        s.Shape = Enum.PartType.Ball; s.Anchored = true
        s.CanCollide = false; s.CanTouch = false; s.CanQuery = false; s.CastShadow = false
        s.Material = material or Enum.Material.Neon
        s.Color = color
        s.Transparency = trStart or 0
        s.Size = Vector3.new(startS, startS, startS)
        s.Position = pos
        s.Parent = getFxFolder()
        TweenService:Create(s, TweenInfo.new(dur, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = Vector3.new(endS, endS, endS), Transparency = 1}):Play()
        task.delay(dur + 0.1, function() if s then s:Destroy() end end)
        return s
    end

    function FXH.light(pos, color, brightness, range, dur)
        local a = anchorAt(pos, dur + 0.3)
        local l = Instance.new("PointLight")
        l.Color = color; l.Brightness = brightness; l.Range = range; l.Shadows = false
        l.Parent = a
        TweenService:Create(l, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Brightness = 0, Range = range*0.4}):Play()
    end

    function FXH.sound(pos, id, vol, maxDist)
        local a = anchorAt(pos, 10)
        local s = Instance.new("Sound")
        s.SoundId = id; s.Volume = vol or 3
        s.RollOffMaxDistance = maxDist or 600
        s.RollOffMode = Enum.RollOffMode.InverseTapered
        s.Parent = a
        s:Play()
    end

    function FXH.shake(pos, intensity, dur, maxDist)
        local cam = workspace.CurrentCamera
        local ref = cam and cam.CFrame.Position
        if not ref then
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            ref = hrp and hrp.Position
        end
        if not ref then return end
        local k = math.clamp(1 - (ref - pos).Magnitude/(maxDist or 200), 0, 1)
        if k > 0.02 then cameraShake(intensity*k, dur) end
    end

    function FXH.ring(center, color, maxR, dur, height, segs)
        segs = segs or 32
        local fx = getFxFolder()
        local parts = {}
        for i = 1, segs do
            local pt = Instance.new("Part")
            pt.Anchored = true; pt.CanCollide = false; pt.CanTouch = false; pt.CanQuery = false
            pt.CastShadow = false; pt.Material = Enum.Material.Neon; pt.Color = color
            pt.Transparency = 0.2; pt.Size = Vector3.new(1, height, 1)
            pt.Parent = fx
            parts[i] = pt
        end
        task.spawn(function()
            local t0 = os.clock()
            while true do
                local u = (os.clock() - t0)/dur
                if u >= 1 then break end
                local e = 1 - (1-u)^3
                local r = 2 + (maxR - 2)*e
                local segLen = (2*math.pi*r/segs)*1.2
                local th = math.max(height*(1 - u*0.6), 0.05)
                local thick = math.max(0.5, 2.4*(1-u))
                local tr = 0.2 + 0.8*(u^1.5)
                for i = 1, segs do
                    local a = (i/segs)*math.pi*2
                    local dir = Vector3.new(math.cos(a), 0, math.sin(a))
                    local pos = center + dir*r + Vector3.new(0, th*0.5, 0)
                    local pt = parts[i]
                    pt.Size = Vector3.new(segLen, th, thick)
                    pt.CFrame = CFrame.lookAt(pos, pos + dir)
                    pt.Transparency = tr
                end
                RunService.Heartbeat:Wait()
            end
            for _, pt in ipairs(parts) do pt:Destroy() end
        end)
    end

    function FXH.dust(hit, o)
        o = o or {}
        local power = o.power or 1
        local col = groundColor(hit):Lerp(Color3.fromRGB(190,180,165), 0.5)
        local a = anchorAt(hit.Position + Vector3.new(0, 0.5, 0), 5)
        local e = Instance.new("ParticleEmitter")
        e.Rate = 0
        e.Lifetime = NumberRange.new(1.3, 2.6)
        e.Speed = NumberRange.new(12*power, 36*power)
        e.SpreadAngle = Vector2.new(85, 85)
        e.Drag = 3
        e.Acceleration = Vector3.new(0, 2, 0)
        e.Color = ColorSequence.new(col)
        e.Size = NumberSequence.new({NSK(0, 2*power), NSK(1, 9*power)})
        e.Transparency = NumberSequence.new({NSK(0, 0.45), NSK(0.6, 0.72), NSK(1, 1)})
        e.Rotation = NumberRange.new(0, 360)
        e.RotSpeed = NumberRange.new(-40, 40)
        e.LightInfluence = 1
        e.Parent = a
        e:Emit(o.count or 40)
    end

    function FXH.spawnRocks(hit, o)
        o = o or {}
        local count = o.count or 22
        local power = o.power or 1
        local life = o.life or 4
        local sizeMul = o.sizeMul or 1
        local spread = o.spread or 1
        local gp = hit.Position
        local gcol = groundColor(hit)
        if o.greyer then
            local grey = (gcol.R + gcol.G + gcol.B) / 3
            gcol = Color3.new(grey, grey, grey):Lerp(Color3.fromRGB(160,158,155), 0.5)
        end
        local dustCol = Color3.fromRGB(95,90,84)
        local fx = getFxFolder()
        for _ = 1, count do
            local big = math.random() < 0.2
            local sz = (big and (1.3 + math.random()*1.5) or (0.35 + math.random()*0.85)) * sizeMul
            local part = Instance.new((math.random() < 0.3) and "WedgePart" or "Part")
            part.Name = "MonoRock"
            part.Anchored = true; part.CanCollide = false; part.CanTouch = false; part.CanQuery = false
            part.CastShadow = big
            part.Material = ROCK_MATS[math.random(1, #ROCK_MATS)]
            local shade = o.greyer and (1.00 + math.random()*0.35) or (0.72 + math.random()*0.5)
            part.Color = Color3.new(
                math.clamp(gcol.R*shade, 0, 1), math.clamp(gcol.G*shade, 0, 1), math.clamp(gcol.B*shade, 0, 1))
            part.Size = Vector3.new(sz, sz*(0.45 + math.random()*0.6), sz*(0.65 + math.random()*0.7))
            part.CFrame = CFrame.new(gp + Vector3.new(
                    (math.random()-0.5)*3*spread, 0.8 + math.random()*0.8, (math.random()-0.5)*3*spread))
                * CFrame.Angles(math.random()*6.283, math.random()*6.283, math.random()*6.283)
            part.Parent = fx
            local ang = math.random()*math.pi*2
            local h = (7 + math.random()*26) * power * (big and 0.7 or 1)
            local up = (26 + math.random()*38) * power * (big and 0.85 or 1)
            local vel = Vector3.new(math.cos(ang)*h, up, math.sin(ang)*h)
            local spin = Vector3.new((math.random()-0.5)*16, (math.random()-0.5)*16, (math.random()-0.5)*16)
            local rad = math.max(part.Size.X, part.Size.Y, part.Size.Z)*0.38
            FXH.addBody(part, vel, spin, rad, life + math.random()*0.6)
            if big then FXH.trail(part, 1.4, dustCol, sz*0.9) end
        end
    end

    function FXH.spawnPebbles(hit, radius, count, life, o)
        o = o or {}
        task.delay(0.1, function()
            local rp = rayParams()
            local gp = hit.Position
            local gcol = groundColor(hit)
            if o.greyer then
                local grey = (gcol.R + gcol.G + gcol.B) / 3
                gcol = Color3.new(grey, grey, grey):Lerp(Color3.fromRGB(155,153,150), 0.5)
            end
            local fx = getFxFolder()
            for _ = 1, count do
                local ang = math.random()*math.pi*2
                local r = radius*(0.2 + math.sqrt(math.random())*0.9)
                local from = gp + Vector3.new(math.cos(ang)*r, 4, math.sin(ang)*r)
                local h = workspace:Raycast(from, Vector3.new(0, -10, 0), rp)
                if h and h.Normal.Y > 0.6 then
                    local sz = 0.15 + math.random()*0.45
                    local pb = Instance.new("Part")
                    pb.Name = "MonoPebble"
                    pb.Anchored = true; pb.CanCollide = false; pb.CanTouch = false; pb.CanQuery = false
                    pb.CastShadow = false
                    pb.Material = ROCK_MATS[math.random(1, #ROCK_MATS)]
                    local shade = o.greyer and (1.00 + math.random()*0.35) or (0.7 + math.random()*0.5)
                    pb.Color = Color3.new(
                        math.clamp(gcol.R*shade, 0, 1), math.clamp(gcol.G*shade, 0, 1), math.clamp(gcol.B*shade, 0, 1))
                    pb.Size = Vector3.new(sz, sz*(0.5 + math.random()*0.5), sz*(0.7 + math.random()*0.6))
                    pb.CFrame = lookCF(h.Position, h.Position + h.Normal) * CFrame.Angles(-math.pi/2, 0, 0)
                        * CFrame.Angles((math.random()-0.5)*0.6, math.random()*6.283, (math.random()-0.5)*0.6)
                        + h.Normal*(sz*0.12)
                    pb.Parent = fx
                    lifeFade(pb, life + math.random()*0.8)
                end
            end
        end)
    end
end

-- =====================================================================
-- ★ ВЗРЫВ ДРОНА ПОСЛЕ [Q] (без ударных волн)
-- =====================================================================
local function flyExplosion(model)
    if not model or not model.Parent then return end
    local okPivot, cf = pcall(function() return model:GetPivot() end)
    if not okPivot or not cf then return end
    local pos = cf.Position
    local fx = getFxFolder()
    local NSK = NumberSequenceKeypoint.new
    local CSK = ColorSequenceKeypoint.new

    FXH.sound(pos, M.SND.EXPLOSION, 3.5, 800)
    FXH.light(pos, Color3.fromRGB(255,170,70), 18, 95, 0.7)

    FXH.shell(pos, Color3.fromRGB(255,252,230), Enum.Material.Neon, 3, 16, 0.16, 0)
    FXH.shell(pos, Color3.fromRGB(255,150,40), Enum.Material.Neon, 4, 27, 0.5, 0.1)
    task.delay(0.04, function()
        FXH.shell(pos + Vector3.new(0, 1.5, 0), Color3.fromRGB(255,75,18), Enum.Material.Neon, 2, 19, 0.55, 0.3)
    end)
    for i = 1, 6 do
        task.delay(0.03*i + math.random()*0.03, function()
            FXH.shell(pos + randUnit()*(3 + math.random()*5),
                (i % 2 == 0) and Color3.fromRGB(255,90,25) or Color3.fromRGB(255,195,90),
                Enum.Material.Neon, 1.5, 6 + math.random()*4, 0.4, 0.25)
        end)
    end

    local la = FXH.anchorAt(pos, 6)

    local sparks = Instance.new("ParticleEmitter")
    sparks.Rate = 0; sparks.Lifetime = NumberRange.new(0.6, 1.5)
    sparks.Speed = NumberRange.new(40, 110)
    sparks.SpreadAngle = Vector2.new(180, 180)
    sparks.Acceleration = Vector3.new(0, -60, 0)
    sparks.Drag = 0.5
    sparks.LightEmission = 1; sparks.LightInfluence = 0
    pcall(function() sparks.Orientation = Enum.ParticleOrientation.VelocityParallel end)
    sparks.Color = ColorSequence.new(Color3.fromRGB(255,235,150), Color3.fromRGB(255,70,15))
    sparks.Size = NumberSequence.new({NSK(0, 0.55), NSK(1, 0)})
    sparks.Transparency = NumberSequence.new({NSK(0, 0), NSK(1, 1)})
    sparks.Parent = la

    local fireP = Instance.new("ParticleEmitter")
    fireP.Rate = 0; fireP.Lifetime = NumberRange.new(0.3, 0.75)
    fireP.Speed = NumberRange.new(18, 52)
    fireP.SpreadAngle = Vector2.new(180, 180)
    fireP.Drag = 3
    fireP.LightEmission = 1; fireP.LightInfluence = 0
    fireP.Rotation = NumberRange.new(0, 360)
    fireP.Color = ColorSequence.new({
        CSK(0, Color3.fromRGB(255,245,200)),
        CSK(0.5, Color3.fromRGB(240,100,20)),
        CSK(1, Color3.fromRGB(70,25,10)),
    })
    fireP.Size = NumberSequence.new({NSK(0, 3), NSK(0.4, 6), NSK(1, 1)})
    fireP.Transparency = NumberSequence.new({NSK(0, 0.1), NSK(0.5, 0.45), NSK(1, 1)})
    fireP.Parent = la

    local smoke = Instance.new("ParticleEmitter")
    smoke.Rate = 0; smoke.Lifetime = NumberRange.new(2.5, 4.5)
    smoke.Speed = NumberRange.new(6, 22)
    smoke.SpreadAngle = Vector2.new(180, 180)
    smoke.Acceleration = Vector3.new(0, 5, 0)
    smoke.Drag = 1.5
    smoke.LightInfluence = 1
    smoke.Rotation = NumberRange.new(0, 360)
    smoke.RotSpeed = NumberRange.new(-30, 30)
    smoke.Color = ColorSequence.new(Color3.fromRGB(62,58,54), Color3.fromRGB(24,24,24))
    smoke.Size = NumberSequence.new({NSK(0, 5), NSK(1, 21)})
    smoke.Transparency = NumberSequence.new({NSK(0, 0.35), NSK(0.5, 0.65), NSK(1, 1)})
    smoke.Parent = la

    local embers = Instance.new("ParticleEmitter")
    embers.Rate = 0; embers.Lifetime = NumberRange.new(1.5, 3)
    embers.Speed = NumberRange.new(5, 22)
    embers.SpreadAngle = Vector2.new(180, 180)
    embers.Acceleration = Vector3.new(0, 8, 0)
    embers.Drag = 1
    embers.LightEmission = 1; embers.LightInfluence = 0
    embers.Color = ColorSequence.new(Color3.fromRGB(255,170,60), Color3.fromRGB(255,60,10))
    embers.Size = NumberSequence.new({NSK(0, 0.3), NSK(1, 0)})
    embers.Transparency = NumberSequence.new({NSK(0, 0), NSK(0.8, 0.3), NSK(1, 1)})
    embers.Parent = la

    pcall(function()
        sparks:Emit(95)
        fireP:Emit(55)
        smoke:Emit(34)
        embers:Emit(32)
    end)

    local count = 0
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") and count < 16 then
            count = count + 1
            local c = d:Clone()
            for _, ch in ipairs(c:GetChildren()) do
                if not (ch:IsA("DataModelMesh") or ch:IsA("Decal") or ch:IsA("SurfaceAppearance")) then
                    ch:Destroy()
                end
            end
            c.Anchored = true; c.CanCollide = false; c.CanTouch = false; c.CanQuery = false
            c.CastShadow = false; c.Massless = true
            c.CFrame = d.CFrame
            c.Parent = fx
            local dir = d.Position - pos
            if dir.Magnitude < 0.1 then dir = randUnit() end
            dir = (dir.Unit + Vector3.new(0, 0.6, 0) + randUnit()*0.4).Unit
            local vel = dir*(30 + math.random()*45)
            local spin = Vector3.new((math.random()-0.5)*20, (math.random()-0.5)*20, (math.random()-0.5)*20)
            local rad = math.clamp(d.Size.Magnitude*0.25, 0.3, 2.5)
            FXH.addBody(c, vel, spin, rad, 4.5)
            FXH.trail(c, 1.6, Color3.fromRGB(45,43,41), math.clamp(rad*1.3, 0.8, 2.5))
        end
    end

    local gh = FXH.groundHit(pos, 24)
    if gh then
        local h = pos.Y - gh.Position.Y
        local k = math.clamp(1 - h/28, 0.15, 1)
        FXH.dust(gh, {count = math.floor(45*k) + 8, power = 1})
        FXH.spawnRocks(gh, {count = math.floor(24*k) + 4, power = 1, life = 4})
        FXH.spawnPebbles(gh, 8, math.floor(20*k) + 4, 4)
    end

    FXH.shake(pos, 1.3, 0.8, 220)
    return pos
end

local function applyFlightPose(char)
    local J = getBodyJoints(char)
    local cfg = getgenv().FlyModelConfig
    local t = os.clock()
    local b = smooth01((t - flight.t0)/0.35)
    local sp = math.clamp(flight.vel.Magnitude / M.FLY.FAST, 0, 1)
    local lean = (cfg.lean + sp*12) * b
    local trem = math.sin(t*13) * (cfg.grip or 2.5) * (0.4 + sp)
    local sway = math.sin(t*2.2) * 1.2

    rot(J.root,  -lean, 0, 0)
    rot(J.waist, 6*b, 0, 0)
    rot(J.neck,  lean*0.9 + 6*b, 0, 0)

    rot(J.shoulderR, (cfg.armX + trem + sway)*b, 0, -cfg.armZ*b)
    rot(J.shoulderL, (cfg.armX - trem - sway)*b, 0,  cfg.armZ*b)
    rot(J.elbowR, (cfg.elbow - trem)*b, 0, 0)
    rot(J.elbowL, (cfg.elbow + trem)*b, 0, 0)
    rot(J.wristR, -22*b, 0, 0)
    rot(J.wristL, -22*b, 0, 0)

    rot(J.hipR, (cfg.legFwd + trem*0.7)*b, 0,  cfg.legSpread*b)
    rot(J.hipL, (cfg.legFwd - trem*0.7)*b, 0, -cfg.legSpread*b)
    rot(J.kneeR, -(cfg.kneeBend + trem)*b, 0, 0)
    rot(J.kneeL, -(cfg.kneeBend - trem)*b, 0, 0)
end

local function stopFlight(silent)
    if not flight.active and not flight.model then return end
    flight.active = false
    if flight.conn then pcall(function() flight.conn:Disconnect() end); flight.conn = nil end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    local explodePos = nil
    if not silent and flight.model and flight.model.Parent then
        local okE, posE = pcall(flyExplosion, flight.model)
        if okE then explodePos = posE end
    end

    for _, k in ipairs({"lv","ao","att","model"}) do
        local o = flight[k]
        if o then pcall(function() o:Destroy() end); flight[k] = nil end
    end
    flight.weld = nil; flight.computePivotInHrp = nil
    if char then
        local J = getBodyJoints(char)
        for _, j in pairs(J) do resetJoint(j) end
    end
    if hum and hum.Parent then
        hum.PlatformStand = false
        hum.AutoRotate = true
        if hum.Health > 0 then pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
    end
    if hrp and hrp.Parent then
        local lv = hrp.CFrame.LookVector
        local flat = Vector3.new(lv.X, 0, lv.Z)
        if flat.Magnitude < 0.01 then flat = Vector3.new(0,0,-1) end
        hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat.Unit)
        hrp.AssemblyAngularVelocity = Vector3.zero
        if explodePos then
            local away = hrp.Position - explodePos
            if away.Magnitude < 0.1 then away = -flat end
            hrp.AssemblyLinearVelocity = away.Unit*26 + Vector3.new(0, 16, 0)
        end
    end
    flight.vel = Vector3.zero
    lastMoveStateAnim = nil
    if not silent then notify("Полёт", "ВЫКЛ [Q] · БАБАХ!") end
end
getgenv().hardStopFlight = function() stopFlight(true) end

local function startFlight()
    if flight.active then return end
    if getgenv().ShatterActive then return end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return end
    if hum.SeatPart then hum.Sit = false end
    pcall(function() hum:UnequipTools() end)
    emoteToken = emoteToken + 1; emoteActive = false

    local model, meta = buildFlyModel(hrp)
    if not model then notify("Полёт", "Модель не загрузилась"); return end
    flight.model = model
    if meta then flight.weld = meta.weld; flight.computePivotInHrp = meta.computePivotInHrp end

    local att = Instance.new("Attachment"); att.Name = "MonoFlyAtt"; att.Parent = hrp
    local lv = Instance.new("LinearVelocity")
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Parent = hrp
    local ao = Instance.new("AlignOrientation")
    ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
    ao.Attachment0 = att
    ao.RigidityEnabled = false
    ao.MaxTorque = math.huge
    ao.MaxAngularVelocity = math.huge
    ao.Responsiveness = 50
    local lk0 = hrp.CFrame.LookVector
    local f0 = Vector3.new(lk0.X, 0, lk0.Z)
    if f0.Magnitude < 0.01 then f0 = Vector3.new(0,0,-1) end
    ao.CFrame = CFrame.lookAt(Vector3.zero, f0.Unit)
    ao.Parent = hrp
    flight.att, flight.lv, flight.ao = att, lv, ao

    hum.PlatformStand = true
    hum.AutoRotate = false
    flight.vel = Vector3.zero
    flight.t0 = os.clock()
    flight.active = true
    lastMoveStateAnim = nil
    notify("Полёт", "ВКЛ · WASD · Space/Ctrl · Shift · [Q] выкл (взрыв)")

    flight.conn = RunService.Heartbeat:Connect(function(dt)
        if not flight.active then return end
        local ch = p.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not ch or not h or not root or not root.Parent or h.Health <= 0
            or not flight.model or not flight.model.Parent or not flight.lv or not flight.lv.Parent then
            stopFlight(true); return
        end
        if flight.weld and flight.weld.Parent and flight.computePivotInHrp then
            flight.weld.C0 = flight.computePivotInHrp()
        end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local look = cam.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude < 0.01 then
            local rl = root.CFrame.LookVector
            flat = Vector3.new(rl.X, 0, rl.Z)
            if flat.Magnitude < 0.01 then flat = Vector3.new(0,0,-1) end
        end
        flat = flat.Unit
        local right = flat:Cross(Vector3.new(0,1,0))
        local f, s, v = 0, 0, 0
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then f = f + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then f = f - 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then s = s + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then s = s - 1 end
        if f == 0 and s == 0 then
            local md = h.MoveDirection
            if md.Magnitude > 0.1 then f = md:Dot(flat); s = md:Dot(right) end
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v = v + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then v = v - 1 end
        local dir = look*f + right*s + Vector3.new(0, v, 0)
        if dir.Magnitude > 1 then dir = dir.Unit end
        local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and M.FLY.FAST or M.FLY.SPEED
        local vertOnly = Vector3.new(0, v*M.FLY.VERT, 0)
        local target = Vector3.new(dir.X*speed, 0, dir.Z*speed) + Vector3.new(0, dir.Y*speed, 0)
        if f == 0 and s == 0 then target = vertOnly end
        flight.vel = flight.vel:Lerp(target, math.clamp(dt*6, 0, 1))
        flight.lv.VectorVelocity = flight.vel
        if flight.ao and flight.ao.Parent then
            flight.ao.CFrame = CFrame.lookAt(Vector3.zero, flat)
        end
    end)
    track(flight.conn)
end

local function toggleFlight()
    if flight.active then stopFlight(false) else startFlight() end
end
getgenv().toggleFlight = toggleFlight

-- =====================================================================
-- ★ КИНО-БОМБА v21 (без зума и без текста на экране)
-- =====================================================================
do
    local NSK = NumberSequenceKeypoint.new
    local CSK = ColorSequenceKeypoint.new

    local BOMB = {
        id = "rbxassetid://81798377551721",
        scale = 1.6,
        throwSpeed = 24,
        upBoost = 7,
        fuse = 3,
        dropFuse = 4.2,
        portalHeight = 34,
        rollDamping = 0.55,
        maxRollSpeed = 20,
        blastRadius = 38,
        shatterRadius = 30,
    }
    getgenv().BombConfig = BOMB
    if getgenv().BombCine == nil then getgenv().BombCine = true end

    local GREEN   = Color3.fromRGB(90, 255, 130)
    local GREEN_L = Color3.fromRGB(190, 255, 210)
    local GREEN_D = Color3.fromRGB(8, 60, 28)
    local PURPLE   = Color3.fromRGB(165, 50, 255)
    local PURPLE_L = Color3.fromRGB(215, 150, 255)
    local PURPLE_D = Color3.fromRGB(85, 15, 150)
    local WHITE    = Color3.fromRGB(250, 235, 255)
    local SMOKE_TEX = "rbxasset://textures/particles/smoke_main.dds"

    local busy = false

    local ease = {
        out = function(x) x = math.clamp(x, 0, 1); return 1 - (1 - x)^3 end,
        inOut = function(x)
            x = math.clamp(x, 0, 1)
            if x < 0.5 then return 4*x*x*x end
            return 1 - ((-2*x + 2)^3)/2
        end,
        back = function(x)
            x = math.clamp(x, 0, 1)
            local c1 = 1.70158; local c3 = c1 + 1
            return 1 + c3*(x-1)^3 + c1*(x-1)^2
        end,
    }

    -- КАМЕРА
    local CINE = {
        active = false, skip = false,
        cf = CFrame.new(), fov = 70,
        shakeAmp = 0, shakeT0 = 0, shakeDur = 0,
        punchAmt = 0, punchT0 = 0, punchDur = 0.4,
        saved = nil,
    }

    function CINE.shake(amp, dur)
        CINE.shakeAmp = amp; CINE.shakeT0 = os.clock(); CINE.shakeDur = dur
    end
    function CINE.punch(amt, dur)
        CINE.punchAmt = amt; CINE.punchT0 = os.clock(); CINE.punchDur = dur or 0.4
    end

    function CINE.begin()
        if CINE.active then return false end
        local cam = workspace.CurrentCamera
        if not cam then return false end
        CINE.saved = {type = cam.CameraType, cf = cam.CFrame, fov = cam.FieldOfView}
        CINE.cf = cam.CFrame; CINE.fov = cam.FieldOfView
        CINE.shakeDur = 0; CINE.punchAmt = 0
        CINE.skip = false
        CINE.active = true
        cam.CameraType = Enum.CameraType.Scriptable
        pcall(function() RunService:UnbindFromRenderStep("MonoCine") end)
        RunService:BindToRenderStep("MonoCine", Enum.RenderPriority.Camera.Value + 2, function()
            local c = workspace.CurrentCamera
            if not c or not CINE.active then return end
            c.CameraType = Enum.CameraType.Scriptable
            local sh = CFrame.new()
            local el = os.clock() - CINE.shakeT0
            if el < CINE.shakeDur then
                local k = ((1 - el/CINE.shakeDur)^2) * CINE.shakeAmp
                sh = CFrame.new((math.random()-0.5)*k*0.12, (math.random()-0.5)*k*0.12, 0)
                    * CFrame.Angles((math.random()-0.5)*k*0.006, (math.random()-0.5)*k*0.006, (math.random()-0.5)*k*0.01)
            end
            c.CFrame = CINE.cf * sh
            -- FOV зафиксирован: без зума
            c.FieldOfView = CINE.saved and CINE.saved.fov or 70
        end)
        return true
    end

    function CINE.finish()
        if not CINE.active then return end
        CINE.active = false
        pcall(function() RunService:UnbindFromRenderStep("MonoCine") end)
        local cam = workspace.CurrentCamera
        if cam then
            cam.CameraType = Enum.CameraType.Custom
            if CINE.saved then cam.FieldOfView = CINE.saved.fov end
            local ch = p.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end
    end

    function CINE.tween(toCF, toFov, dur, fn)
        fn = fn or ease.inOut
        local fromCF = CINE.cf
        local t0 = os.clock()
        while CINE.active do
            local d = CINE.skip and 0.2 or dur
            local u = (os.clock() - t0)/d
            if u >= 1 then break end
            local e = fn(u)
            CINE.cf = fromCF:Lerp(toCF, e)
            -- FOV игнорируется (без зума)
            RunService.RenderStepped:Wait()
        end
        if CINE.active then CINE.cf = toCF end
    end

    function CINE.run(dur, fn)
        local t0 = os.clock()
        local dt = 1/60
        while CINE.active and not CINE.skip do
            local u = (os.clock() - t0)/dur
            if u >= 1 then fn(1, dt); break end
            fn(u, dt)
            dt = RunService.RenderStepped:Wait()
        end
    end

    -- ОВЕРЛЕЙ (текст отключён)
    local function makeOverlay()
        local noop = function() end
        local stub = {bars = noop, lines = noop, text = noop, flash = noop, destroy = noop}
        local pg = p:FindFirstChild("PlayerGui")
        if not pg then return stub end
        local old = pg:FindFirstChild("MonoCineGui"); if old then old:Destroy() end
        local g = Instance.new("ScreenGui")
        g.Name = "MonoCineGui"; g.IgnoreGuiInset = true; g.ResetOnSpawn = false
        g.DisplayOrder = 900; g.Parent = pg

        local function bar(top)
            local f = Instance.new("Frame")
            f.BackgroundColor3 = Color3.new(0,0,0); f.BorderSizePixel = 0
            f.AnchorPoint = Vector2.new(0, top and 0 or 1)
            f.Position = UDim2.fromScale(0, top and 0 or 1)
            f.Size = UDim2.fromScale(1, 0); f.ZIndex = 10; f.Parent = g
            return f
        end
        local ov = {gui = g, top = bar(true), bot = bar(false)}

        function ov.bars(on, dur)
            local sz = UDim2.fromScale(1, on and 0.12 or 0)
            local ti = TweenInfo.new(dur or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(ov.top, ti, {Size = sz}):Play()
            TweenService:Create(ov.bot, ti, {Size = sz}):Play()
        end

        function ov.flash(color, alpha, dur)
            local f = Instance.new("Frame")
            f.Size = UDim2.fromScale(1,1); f.BorderSizePixel = 0
            f.BackgroundColor3 = color or Color3.new(1,1,1)
            f.BackgroundTransparency = 1 - (alpha or 0.8); f.ZIndex = 30; f.Parent = g
            TweenService:Create(f, TweenInfo.new(dur or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 1}):Play()
            task.delay((dur or 0.4) + 0.1, function() if f then f:Destroy() end end)
        end

        -- заглушка: никакого текста на экране
        function ov.text() end

        function ov.lines(dur, color)
            local N = 30
            local fr = {}
            for i = 1, N do
                local f = Instance.new("Frame")
                f.AnchorPoint = Vector2.new(0.5, 0.5); f.BorderSizePixel = 0
                f.BackgroundColor3 = color or Color3.new(1,1,1); f.ZIndex = 5; f.Parent = g
                fr[i] = {f = f, a = (i/N)*math.pi*2 + math.random()*0.1,
                    r0 = 0.28 + math.random()*0.14, len = 0.18 + math.random()*0.28}
            end
            task.spawn(function()
                local t0 = os.clock()
                while true do
                    local u = (os.clock() - t0)/dur
                    if u >= 1 or not g.Parent then break end
                    local vs = g.AbsoluteSize
                    local m = math.max(vs.X, vs.Y)
                    for _, l in ipairs(fr) do
                        local r = (l.r0 + u*0.35) * (0.85 + math.random()*0.3) * m
                        local len = l.len * m * (1 - u*0.5)
                        l.f.Position = UDim2.fromOffset(vs.X/2 + math.cos(l.a)*r, vs.Y/2 + math.sin(l.a)*r)
                        l.f.Size = UDim2.fromOffset(len, 2 + math.random()*3)
                        l.f.Rotation = math.deg(l.a)
                        l.f.BackgroundTransparency = 0.15 + u*0.85
                    end
                    RunService.RenderStepped:Wait()
                end
                for _, l in ipairs(fr) do if l.f then l.f:Destroy() end end
            end)
        end

        function ov.destroy() if g then g:Destroy() end end
        return ov
    end

    -- ПОСТ-ЭФФЕКТЫ
    local function impactFrame(k)
        pcall(function()
            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "MonoImpactCC"
            cc.Saturation = -1; cc.Contrast = 1.4*k; cc.Brightness = 0.18*k
            cc.Parent = Lighting
            task.delay(0.1, function()
                if not cc.Parent then return end
                TweenService:Create(cc, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Saturation = 0, Contrast = 0, Brightness = 0}):Play()
                task.delay(0.45, function() if cc then cc:Destroy() end end)
            end)
        end)
    end

    local function postFx(k)
        pcall(function()
            local bl = Instance.new("BloomEffect")
            bl.Intensity = 2.4*k; bl.Size = 42; bl.Threshold = 0.7; bl.Parent = Lighting
            TweenService:Create(bl, TweenInfo.new(2.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Intensity = 0}):Play()
            task.delay(2.6, function() if bl then bl:Destroy() end end)

            local sr = Instance.new("SunRaysEffect")
            sr.Intensity = 0.5*k; sr.Spread = 1; sr.Parent = Lighting
            TweenService:Create(sr, TweenInfo.new(2.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Intensity = 0}):Play()
            task.delay(2.2, function() if sr then sr:Destroy() end end)

            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "MonoBombCC"
            cc.TintColor = Color3.fromRGB(215, 160, 255)
            cc.Brightness = 0.35*k; cc.Contrast = 0.2*k; cc.Saturation = 0.2*k
            cc.Parent = Lighting
            TweenService:Create(cc, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Brightness = 0, Contrast = 0, Saturation = 0, TintColor = Color3.new(1,1,1)}):Play()
            task.delay(1.8, function() if cc then cc:Destroy() end end)

            local pg = p:FindFirstChild("PlayerGui")
            if pg and k > 0.2 then
                local g = Instance.new("ScreenGui")
                g.IgnoreGuiInset = true; g.ResetOnSpawn = false; g.DisplayOrder = 999; g.Parent = pg
                local f = Instance.new("Frame")
                f.Size = UDim2.fromScale(1,1); f.BorderSizePixel = 0
                f.BackgroundColor3 = Color3.fromRGB(240, 215, 255)
                f.BackgroundTransparency = 1 - 0.9*k; f.Parent = g
                task.delay(0.1, function()
                    TweenService:Create(f, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundTransparency = 1}):Play()
                end)
                task.delay(1.3, function() if g then g:Destroy() end end)
            end
        end)
    end

    -- ЧАСТИЦЫ
    local function mkEmitter(parent, o)
        local e = Instance.new("ParticleEmitter")
        e.Rate = 0
        e.Lifetime = NumberRange.new(o.life[1], o.life[2])
        e.Speed = NumberRange.new(o.speed[1], o.speed[2])
        e.SpreadAngle = o.spread or Vector2.new(180, 180)
        e.Drag = o.drag or 0
        e.Acceleration = o.acc or Vector3.zero
        e.LightEmission = o.emit or 0
        e.LightInfluence = o.inf or 0
        e.Rotation = NumberRange.new(0, 360)
        local rs = o.rot or 0
        e.RotSpeed = NumberRange.new(-rs, rs)
        if o.tex then e.Texture = o.tex end
        e.Color = o.color
        e.Size = o.size
        e.Transparency = o.trans
        if o.vp then pcall(function() e.Orientation = Enum.ParticleOrientation.VelocityParallel end) end
        e.Parent = parent
        return e
    end

    -- КАМНИ
    local ROCKS = {
        Enum.Material.Slate, Enum.Material.Basalt, Enum.Material.Granite,
        Enum.Material.Concrete, Enum.Material.Rock, Enum.Material.Cobblestone,
    }

    local function dustPuff(pos, size)
        local a = FXH.anchorAt(pos, 3)
        local e = mkEmitter(a, {
            life = {0.8, 1.6}, speed = {2, 8}, drag = 2, acc = Vector3.new(0, 1.5, 0),
            tex = SMOKE_TEX, inf = 1,
            color = ColorSequence.new(Color3.fromRGB(150, 145, 138)),
            size = NumberSequence.new({NSK(0, size), NSK(1, size*3.2)}),
            trans = NumberSequence.new({NSK(0, 0.55), NSK(1, 1)}),
            rot = 40,
        })
        e:Emit(5)
    end

    function FXH.spawnBoulders(hit, o)
        o = o or {}
        local count = o.count or 60
        local power = o.power or 1
        local life = o.life or 4
        local sizeMul = o.sizeMul or 1
        local spread = o.spread or 1
        local gp = hit.Position
        local gcol = Color3.fromRGB(125, 122, 118)
        local inst = hit.Instance
        if inst and inst:IsA("BasePart") then gcol = gcol:Lerp(inst.Color, 0.5) end
        if o.greyer then
            local gr = (gcol.R + gcol.G + gcol.B)/3
            gcol = Color3.new(gr, gr, gr):Lerp(Color3.fromRGB(165, 162, 158), 0.5)
        end
        local fx = getFxFolder()
        for _ = 1, count do
            local big = math.random() < 0.18
            local sz = (big and (1.6 + math.random()*2.2) or (0.5 + math.random()*1.1)) * sizeMul
            local kind = math.random(1, 4)
            local part
            if kind == 1 then part = Instance.new("WedgePart")
            elseif kind == 2 then part = Instance.new("CornerWedgePart")
            else part = Instance.new("Part") end
            part.Name = "MonoRock"
            part.Anchored = true; part.CanCollide = false; part.CanTouch = false; part.CanQuery = false
            part.CastShadow = big
            part.Material = ROCKS[math.random(1, #ROCKS)]
            local shade = o.greyer and (1.0 + math.random()*0.35) or (0.7 + math.random()*0.55)
            local rockCol = Color3.new(
                math.clamp(gcol.R*shade, 0, 1), math.clamp(gcol.G*shade, 0, 1), math.clamp(gcol.B*shade, 0, 1))
            part.Color = rockCol
            part.Size = Vector3.new(sz*(0.7 + math.random()*0.8), sz*(0.5 + math.random()*0.7), sz*(0.7 + math.random()*0.8))
            if kind == 4 then
                local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = part
            end
            part.CFrame = CFrame.new(gp + Vector3.new(
                    (math.random()-0.5)*4*spread, 0.8 + math.random()*1.0, (math.random()-0.5)*4*spread))
                * CFrame.Angles(math.random()*6.283, math.random()*6.283, math.random()*6.283)
            part.Parent = fx

            local hot = math.random() < 0.35
            if hot then
                part.Material = Enum.Material.Neon
                part.Color = (math.random() < 0.5) and PURPLE_L or Color3.fromRGB(255, 190, 120)
                TweenService:Create(part, TweenInfo.new(1.3, Enum.EasingStyle.Quad), {Color = rockCol}):Play()
                task.delay(1.3, function()
                    if part and part.Parent then part.Material = ROCKS[math.random(1, #ROCKS)] end
                end)
                FXH.trail(part, 1.3, Color3.fromRGB(70, 55, 85), math.clamp(sz*0.8, 0.5, 2))
            end

            local ang = math.random()*math.pi*2
            local h = (10 + math.random()*45) * power * (big and 0.6 or 1)
            local up = (30 + math.random()*55) * power * (big and 0.8 or 1)
            local vel = Vector3.new(math.cos(ang)*h, up, math.sin(ang)*h)
            local spin = Vector3.new((math.random()-0.5)*18, (math.random()-0.5)*18, (math.random()-0.5)*18)
            local rad = math.max(part.Size.X, part.Size.Y, part.Size.Z)*0.38
            local onImpact = nil
            if big then onImpact = function(_, h2) dustPuff(h2.Position, 2) end end
            FXH.addBody(part, vel, spin, rad, life + math.random()*0.8, onImpact)
            if big and not hot then FXH.trail(part, 1.2, Color3.fromRGB(95, 90, 84), sz*0.7) end
        end
    end

    -- ВЗРЫВ
    local bombSrcCache = nil
    local function getBombSrc()
        if bombSrcCache ~= nil then return bombSrcCache end
        local ok, m = pcall(loadAssetModel, BOMB.id)
        bombSrcCache = (ok and m) or false
        return bombSrcCache
    end
    local function buildBombVisual()
        local src = getBombSrc()
        if not src then return nil, nil end
        local model = src:Clone()
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
                or d:IsA("JointInstance") or d:IsA("WeldConstraint") then
                d:Destroy()
            end
        end
        local parts = {}
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") then table.insert(parts, d) end
        end
        if #parts == 0 then model:Destroy(); return nil, nil end
        for _, pt in ipairs(parts) do
            pt.Anchored = false; pt.CanCollide = false; pt.CanTouch = false
            pt.CanQuery = false; pt.Massless = true
        end
        pcall(function() model:ScaleTo(BOMB.scale) end)
        return model, parts
    end

    local function bombExplosion(pos)
        local fx = getFxFolder()
        local R = BOMB.blastRadius
        local cam = workspace.CurrentCamera
        local dist = cam and (cam.CFrame.Position - pos).Magnitude or 9999
        local k = CINE.active and 1 or math.clamp(1 - dist/(R*5), 0, 1)

        FXH.sound(pos, M.SND.EXPLOSION, 6, 2000)
        FXH.light(pos, WHITE, 60, 140, 0.3)
        FXH.light(pos + Vector3.new(0, 8, 0), PURPLE, 35, 190, 2.2)

        if k > 0.05 then impactFrame(k); postFx(k) end
        -- без CINE.punch: FOV не пульсирует
        if CINE.active then CINE.shake(18, 2.0)
        else FXH.shake(pos, 2.4, 1.2, 320) end

        FXH.shell(pos, WHITE, Enum.Material.Neon, 4, R*0.9, 0.25, 0)
        FXH.shell(pos, PURPLE, Enum.Material.Neon, 6, R*2.1, 0.8, 0.1)
        FXH.shell(pos, PURPLE_L, Enum.Material.Neon, 4, R*1.4, 0.55, 0.3)
        FXH.shell(pos, PURPLE, Enum.Material.ForceField, 8, R*2.7, 1.2, 0.35)
        task.delay(0.08, function() FXH.shell(pos, WHITE, Enum.Material.Neon, 6, R*1.1, 0.35, 0.2) end)

        local pillar = Instance.new("Part")
        pillar.Shape = Enum.PartType.Cylinder
        pillar.Anchored = true; pillar.CanCollide = false; pillar.CanTouch = false; pillar.CanQuery = false
        pillar.CastShadow = false; pillar.Material = Enum.Material.Neon; pillar.Color = PURPLE_L
        pillar.Transparency = 0.1
        pillar.Size = Vector3.new(R*5, 10, 10)
        pillar.CFrame = CFrame.new(pos + Vector3.new(0, R*2.5, 0)) * CFrame.Angles(0, 0, math.pi/2)
        pillar.Parent = fx
        TweenService:Create(pillar, TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = Vector3.new(R*5, 0.5, 0.5), Transparency = 1}):Play()
        task.delay(1.4, function() if pillar then pillar:Destroy() end end)

        for i = 1, 22 do
            local dir = randUnit()
            local ray = Instance.new("Part")
            ray.Anchored = true; ray.CanCollide = false; ray.CanTouch = false; ray.CanQuery = false
            ray.CastShadow = false; ray.Material = Enum.Material.Neon
            ray.Color = (i % 2 == 0) and PURPLE_L or WHITE
            ray.Size = Vector3.new(0.7, 0.7, 2)
            ray.CFrame = lookCF(pos, pos + dir)
            ray.Parent = fx
            local len = R*(1.6 + math.random()*1.4)
            local d = 0.5 + math.random()*0.35
            TweenService:Create(ray, TweenInfo.new(d, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = Vector3.new(0.2, 0.2, len*2), Transparency = 1}):Play()
            task.delay(d + 0.1, function() if ray then ray:Destroy() end end)
        end

        local gh = FXH.groundHit(pos, 28)
        local ringC = gh and (gh.Position + Vector3.new(0, 0.4, 0)) or pos
        FXH.ring(ringC, PURPLE_L, R*2.4, 1.0, 1.6, 52)
        task.delay(0.12, function() FXH.ring(ringC, PURPLE, R*1.8, 0.85, 1.1, 44) end)
        task.delay(0.30, function() FXH.ring(ringC, WHITE, R*1.3, 0.7, 0.7, 36) end)

        local la = FXH.anchorAt(pos, 9)

        local flashSprite = mkEmitter(la, {
            life = {0.18, 0.28}, speed = {0, 0}, emit = 1,
            color = ColorSequence.new(WHITE, PURPLE_L),
            size = NumberSequence.new({NSK(0, R*1.4), NSK(1, R*2.6)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(1, 1)}),
        })
        local sparks = mkEmitter(la, {
            life = {0.9, 2.2}, speed = {60, 190}, drag = 0.4, acc = Vector3.new(0, -50, 0), emit = 1, vp = true,
            color = ColorSequence.new(PURPLE_L, PURPLE_D),
            size = NumberSequence.new({NSK(0, 1.0), NSK(1, 0)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(1, 1)}),
        })
        local energy = mkEmitter(la, {
            life = {0.5, 1.2}, speed = {20, 85}, drag = 3, emit = 1, rot = 60,
            color = ColorSequence.new({CSK(0, WHITE), CSK(0.4, PURPLE), CSK(1, PURPLE_D)}),
            size = NumberSequence.new({NSK(0, 6), NSK(0.4, 15), NSK(1, 2)}),
            trans = NumberSequence.new({NSK(0, 0.1), NSK(0.6, 0.5), NSK(1, 1)}),
        })
        local smoke = mkEmitter(la, {
            life = {3, 5.5}, speed = {8, 38}, drag = 2, acc = Vector3.new(0, 6, 0), inf = 0.5, rot = 25,
            tex = SMOKE_TEX,
            color = ColorSequence.new(Color3.fromRGB(105, 60, 145), Color3.fromRGB(30, 18, 45)),
            size = NumberSequence.new({NSK(0, 10), NSK(1, 36)}),
            trans = NumberSequence.new({NSK(0, 0.3), NSK(0.5, 0.6), NSK(1, 1)}),
        })
        local embers = mkEmitter(la, {
            life = {3, 6}, speed = {6, 30}, drag = 1, acc = Vector3.new(0, 9, 0), emit = 1,
            color = ColorSequence.new(PURPLE_L, PURPLE),
            size = NumberSequence.new({NSK(0, 0.45), NSK(1, 0)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(0.8, 0.3), NSK(1, 1)}),
        })
        pcall(function()
            flashSprite:Emit(3)
            sparks:Emit(170)
            energy:Emit(85)
            smoke:Emit(70)
            embers:Emit(70)
        end)

        local stem = FXH.anchorAt(pos, 6)
        local stemE = mkEmitter(stem, {
            life = {1.8, 3}, speed = {2, 10}, spread = Vector2.new(35, 35), drag = 1.5, rot = 20,
            inf = 0.4, emit = 0.3, tex = SMOKE_TEX,
            color = ColorSequence.new(Color3.fromRGB(150, 70, 215), Color3.fromRGB(50, 22, 80)),
            size = NumberSequence.new({NSK(0, 9), NSK(1, 26)}),
            trans = NumberSequence.new({NSK(0, 0.2), NSK(0.6, 0.55), NSK(1, 1)}),
        })
        stemE.Rate = 170
        TweenService:Create(stem, TweenInfo.new(1.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            {Position = pos + Vector3.new(0, R*1.5, 0)}):Play()
        task.delay(1.7, function() if stemE then stemE.Enabled = false end end)

        task.delay(1.1, function()
            local topPos = pos + Vector3.new(0, R*1.35, 0)
            local cap = FXH.anchorAt(topPos, 7)
            local capE = mkEmitter(cap, {
                life = {2.5, 4}, speed = {22, 48}, drag = 2, acc = Vector3.new(0, -5, 0), rot = 20,
                inf = 0.4, emit = 0.3, tex = SMOKE_TEX,
                color = ColorSequence.new(Color3.fromRGB(160, 80, 225), Color3.fromRGB(45, 18, 75)),
                size = NumberSequence.new({NSK(0, 12), NSK(1, 40)}),
                trans = NumberSequence.new({NSK(0, 0.25), NSK(0.6, 0.6), NSK(1, 1)}),
            })
            pcall(function() capE:Emit(90) end)
            local disc = Instance.new("Part")
            disc.Shape = Enum.PartType.Ball; disc.Anchored = true
            disc.CanCollide = false; disc.CanTouch = false; disc.CanQuery = false; disc.CastShadow = false
            disc.Material = Enum.Material.Neon; disc.Color = PURPLE
            disc.Transparency = 0.45; disc.Size = Vector3.new(6, 3, 6)
            disc.Position = topPos; disc.Parent = fx
            TweenService:Create(disc, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = Vector3.new(R*1.7, R*0.45, R*1.7), Transparency = 1}):Play()
            task.delay(1.7, function() if disc then disc:Destroy() end end)
        end)

        if gh then
            local scorch = Instance.new("Part")
            scorch.Shape = Enum.PartType.Cylinder
            scorch.Anchored = true; scorch.CanCollide = false; scorch.CanTouch = false; scorch.CanQuery = false
            scorch.CastShadow = false; scorch.Material = Enum.Material.Slate
            scorch.Color = Color3.fromRGB(22, 14, 30); scorch.Transparency = 0.25
            scorch.Size = Vector3.new(0.12, 2, 2)
            scorch.CFrame = CFrame.new(gh.Position + gh.Normal*0.08) * CFrame.Angles(0, 0, math.pi/2)
            scorch.Parent = fx
            TweenService:Create(scorch, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = Vector3.new(0.12, R*1.1, R*1.1)}):Play()
            task.delay(4.2, function()
                if scorch and scorch.Parent then
                    TweenService:Create(scorch, TweenInfo.new(1), {Transparency = 1}):Play()
                    task.delay(1.1, function() if scorch then scorch:Destroy() end end)
                end
            end)

            FXH.dust(gh, {count = 120, power = 2.3})
            FXH.spawnBoulders(gh, {count = 62, power = 1.7, sizeMul = 1.4, life = 4, spread = 2, greyer = true})
            FXH.spawnPebbles(gh, 18, 50, 4, {greyer = true})
        end

        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and (hrp.Position - pos).Magnitude < BOMB.shatterRadius then
            if getgenv().shatterBody then
                task.spawn(function() pcall(getgenv().shatterBody) end)
            end
        end
    end

    -- БРОСОК / ПАДЕНИЕ
    local function spawnThrownBomb(startPos, velocity, opts)
        opts = opts or {}
        local model, parts = buildBombVisual()
        if not model then return nil end

        local _, bbSize = model:GetBoundingBox()
        local diameter = math.clamp(math.max(bbSize.X, bbSize.Y, bbSize.Z), 1.5, 8)
        local radius = diameter/2

        local ball = Instance.new("Part")
        ball.Name = "MonoBombPhysics"
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(diameter, diameter, diameter)
        ball.Transparency = 1
        ball.CanCollide = true; ball.CanTouch = false; ball.CanQuery = false
        ball.Anchored = true
        ball.CustomPhysicalProperties = PhysicalProperties.new(2.5, 0.9, 0, 100, 100)
        ball.CFrame = CFrame.new(startPos)
        ball.Parent = workspace

        for _, pt in ipairs(parts) do pt.Anchored = true end
        model.Parent = workspace
        local bbCF = model:GetBoundingBox()
        model:PivotTo(CFrame.new(startPos) * bbCF:ToObjectSpace(model:GetPivot()))
        for _, pt in ipairs(parts) do
            local w = Instance.new("Weld")
            w.Part0 = ball; w.Part1 = pt
            w.C0 = ball.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
            w.Parent = ball
        end
        for _, pt in ipairs(parts) do
            pt.Anchored = false; pt.CanCollide = false; pt.Massless = true
        end

        local beep = Instance.new("Sound")
        beep.Name = "MonoBombBeep"; beep.SoundId = M.SND.BOMB_BEEP
        beep.Volume = 2.5; beep.RollOffMaxDistance = 140
        beep.RollOffMode = Enum.RollOffMode.InverseTapered
        beep.Parent = ball

        ball.Anchored = false
        ball.AssemblyLinearVelocity = velocity
        local h0 = Vector3.new(velocity.X, 0, velocity.Z)
        ball.AssemblyAngularVelocity = Vector3.new(0, 1, 0):Cross(h0)/radius

        local fuse = opts.fuse or BOMB.fuse
        local handle = {
            pos = startPos, t = 0, fuse = fuse, grounded = false,
            exploded = false, explodePos = nil,
            dir = (h0.Magnitude > 1) and h0.Unit or nil,
        }

        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = {ball, model, getFxFolder()}
        rp.IgnoreWater = true

        local t0 = os.clock()
        local done = false
        local beepT = 0.5
        local hb
        hb = RunService.Heartbeat:Connect(function(dt)
            if done then return end
            if not ball.Parent then
                done = true; hb:Disconnect()
                if model then model:Destroy() end
                handle.exploded = true; handle.dead = true; handle.explodePos = handle.pos
                return
            end
            local t = os.clock() - t0
            handle.t = t
            handle.pos = ball.Position

            local v = ball.AssemblyLinearVelocity
            local ch = p.Character
            if ch then rp.FilterDescendantsInstances = {ball, model, getFxFolder(), ch} end
            local grounded = workspace:Raycast(ball.Position, Vector3.new(0, -(radius + 0.6), 0), rp) ~= nil
            handle.grounded = grounded
            if grounded then
                local h = Vector3.new(v.X, 0, v.Z)
                h = h*math.max(0, 1 - BOMB.rollDamping*dt)
                if h.Magnitude > BOMB.maxRollSpeed then h = h.Unit*BOMB.maxRollSpeed end
                ball.AssemblyLinearVelocity = Vector3.new(h.X, v.Y, h.Z)
                ball.AssemblyAngularVelocity = Vector3.new(0, 1, 0):Cross(h)/radius
            end

            beepT = beepT - dt
            if beepT <= 0 and t < fuse then
                pcall(function() beep.TimePosition = 0; beep:Play() end)
                local freq = math.clamp(t/fuse, 0, 1)
                beepT = math.max(0.1, 0.55 - 0.45*freq*freq)
            end

            if t >= fuse or ball.Position.Y < -500 then
                done = true; hb:Disconnect()
                local ep = ball.Position
                ball:Destroy()
                if model then model:Destroy() end
                handle.exploded = true
                handle.explodePos = ep
                pcall(bombExplosion, ep)
            end
        end)
        return handle
    end

    -- АНИМЕ-ПОРТАЛ
    local function animePortal(center, radius, groundY)
        local fx = getFxFolder()
        local P = {mode = "hidden", t0 = os.clock(), spin = 0, alive = true}
        local all = {}

        local function cyl(color, mat, tr)
            local c = Instance.new("Part")
            c.Shape = Enum.PartType.Cylinder
            c.Anchored = true; c.CanCollide = false; c.CanTouch = false; c.CanQuery = false; c.CastShadow = false
            c.Material = mat; c.Color = color; c.Transparency = tr
            c.Size = Vector3.new(0.1, 0.1, 0.1); c.CFrame = CFrame.new(center)
            c.Parent = fx
            table.insert(all, c)
            return c
        end

        local rim   = cyl(GREEN, Enum.Material.Neon, 0.05)
        local core  = cyl(GREEN_D, Enum.Material.SmoothPlastic, 0)
        local swirl = cyl(GREEN_L, Enum.Material.Neon, 0.5)
        local beamH = math.max(center.Y - (groundY or (center.Y - 30)), 4)
        local beam  = cyl(GREEN, Enum.Material.Neon, 0.88)

        local rings = {}
        for i = 1, 3 do
            local n = 18 + i*4
            local blocks = {}
            for j = 1, n do
                local b = Instance.new("Part")
                b.Anchored = true; b.CanCollide = false; b.CanTouch = false; b.CanQuery = false; b.CastShadow = false
                b.Material = Enum.Material.Neon
                b.Color = (j % 2 == 0) and GREEN or GREEN_L
                b.Size = Vector3.new(0.1, 0.1, 0.1)
                b.Parent = fx
                blocks[j] = b
                table.insert(all, b)
            end
            rings[i] = {blocks = blocks, n = n, r = radius*(1.12 + 0.16*i),
                dir = (i % 2 == 0) and 1 or -1, spd = 0.8 + 0.5*i}
        end

        local em = FXH.anchorAt(center, nil)
        table.insert(all, em)
        em.Size = Vector3.new(radius*2, 0.2, radius*2)
        local light = Instance.new("PointLight")
        light.Color = GREEN; light.Range = 55; light.Brightness = 0; light.Shadows = false
        light.Parent = em
        local spark = mkEmitter(em, {
            life = {0.6, 1.3}, speed = {14, 32}, spread = Vector2.new(22, 22), acc = Vector3.new(0, -18, 0), emit = 1,
            color = ColorSequence.new(WHITE, GREEN),
            size = NumberSequence.new({NSK(0, 0.7), NSK(1, 0)}),
            trans = NumberSequence.new({NSK(0, 0), NSK(1, 1)}),
        })
        spark.EmissionDirection = Enum.NormalId.Bottom
        pcall(function() spark.Shape = Enum.ParticleEmitterShape.Disc end)

        local base = CFrame.new(center) * CFrame.Angles(0, 0, math.pi/2)
        local function apply(s)
            s = math.max(s, 0.001)
            local d = radius*2*s
            rim.Size = Vector3.new(0.3, d*1.05, d*1.05); rim.CFrame = base
            core.Size = Vector3.new(0.2, d*0.9, d*0.9); core.CFrame = base * CFrame.new(-0.14, 0, 0)
            swirl.Size = Vector3.new(0.12, d*0.65, d*0.65); swirl.CFrame = base * CFrame.new(-0.26, 0, 0)
            beam.Size = Vector3.new(beamH, d*0.8, d*0.8)
            beam.CFrame = CFrame.new(center.X, center.Y - beamH/2, center.Z) * CFrame.Angles(0, 0, math.pi/2)
            for _, rg in ipairs(rings) do
                local r = rg.r*s
                local segLen = math.max((2*math.pi*r/rg.n)*0.6, 0.05)
                for j, b in ipairs(rg.blocks) do
                    local a = (j/rg.n)*math.pi*2 + P.spin*rg.dir*rg.spd
                    local pos = center + Vector3.new(math.cos(a)*r, math.sin(a*3 + P.spin*4)*0.35*s, math.sin(a)*r)
                    local tan = Vector3.new(-math.sin(a), 0, math.cos(a))
                    b.Size = Vector3.new(0.35*s + 0.01, 0.35*s + 0.01, segLen)
                    b.CFrame = CFrame.lookAt(pos, pos + tan)
                end
            end
        end

        function P.destroy()
            if not P.alive then return end
            P.alive = false
            if P.conn then P.conn:Disconnect() end
            for _, o in ipairs(all) do if o then o:Destroy() end end
        end
        function P.open()
            P.mode = "open"; P.t0 = os.clock()
            spark.Rate = 140
            TweenService:Create(light, TweenInfo.new(0.4), {Brightness = 5}):Play()
            FXH.sound(center, M.SND.SPAWN, 3, 500)
            FXH.ring(center, GREEN, radius*3, 0.55, 0.5, 40)
            pcall(function() spark:Emit(80) end)
        end
        function P.close()
            if P.mode == "close" or not P.alive then return end
            P.mode = "close"; P.t0 = os.clock()
            spark.Rate = 0
            TweenService:Create(light, TweenInfo.new(0.35), {Brightness = 0}):Play()
            FXH.sound(center, M.SND.ENTER, 2.5, 500)
            FXH.ring(center, GREEN_L, radius*2.2, 0.4, 0.4, 32)
        end

        apply(0)
        P.conn = RunService.RenderStepped:Connect(function(dt)
            if not P.alive then return end
            P.spin = P.spin + dt
            local el = os.clock() - P.t0
            local s = 0
            if P.mode == "open" then
                s = ease.back(el/0.45)
                if el >= 0.45 then P.mode = "idle" end
            elseif P.mode == "idle" then
                s = 1 + math.sin(P.spin*6)*0.02
            elseif P.mode == "close" then
                local u = el/0.4
                if u >= 1 then P.destroy(); return end
                s = 1 - ease.inOut(u)
            end
            apply(s)
        end)
        return P
    end

    -- ФАЗЫ КАМЕРЫ
    local function cineBombPhases(handle, ov, opts)
        opts = opts or {}
        local fl = CINE.cf.LookVector
        local flat = Vector3.new(fl.X, 0, fl.Z)
        local dir = opts.dir or handle.dir or ((flat.Magnitude > 0.01) and flat.Unit or Vector3.new(0, 0, -1))
        local rightV = dir:Cross(Vector3.new(0, 1, 0))
        local cur = CINE.cf

        local t0 = os.clock()
        while CINE.active and not CINE.skip and not handle.exploded do
            local dt = RunService.RenderStepped:Wait()
            local bp = handle.pos
            local desired = CFrame.lookAt(bp - dir*17 + rightV*6 + Vector3.new(0, 7, 0), bp)
            cur = cur:Lerp(desired, 1 - math.exp(-5*dt)); CINE.cf = cur
            -- без FOV-зума
            if opts.onTick then opts.onTick(bp) end
            local el = os.clock() - t0
            if (handle.grounded and el > 0.4) or el > 4 then break end
        end

        local ang = math.atan2(cur.Position.Z - handle.pos.Z, cur.Position.X - handle.pos.X)
        local lastShown = -1
        while CINE.active and not CINE.skip and not handle.exploded do
            local dt = RunService.RenderStepped:Wait()
            local rem = handle.fuse - handle.t
            local prog = math.clamp(handle.t/handle.fuse, 0, 1)
            ang = ang + dt*(0.7 + prog*1.4)
            local r = 16  -- радиус постоянный, без приближения
            local bp = handle.pos
            local desired = CFrame.lookAt(
                bp + Vector3.new(math.cos(ang)*r, 3.5 + 2*(1 - prog), math.sin(ang)*r),
                bp + Vector3.new(0, 1, 0))
            cur = cur:Lerp(desired, 1 - math.exp(-8*dt)); CINE.cf = cur
            -- без FOV-зума
            local n = math.ceil(rem)
            if n >= 1 and n <= 3 and n ~= lastShown then
                lastShown = n
                -- без текста: только shake
                CINE.shake(1.2 + (4 - n), 0.25)
            end
            if rem < 0.45 then CINE.shake(2.5, 0.1) end
        end

        if CINE.active then
            local ep = handle.explodePos or handle.pos
            -- без текста "БАБАХ!"
            if not CINE.skip then task.wait(0.12) end
            local startPos = CINE.cf.Position
            local baseAng = math.atan2(startPos.Z - ep.Z, startPos.X - ep.X)
            local c2 = CINE.cf
            CINE.run(4.6, function(u, dt)
                local e = ease.out(u)
                local r = 24 + 70*e
                local a = baseAng + u*0.9
                local h = 6 + 38*e
                local look = ep + Vector3.new(0, 4 + 46*e, 0)
                local desired = CFrame.lookAt(ep + Vector3.new(math.cos(a)*r, h, math.sin(a)*r), look)
                c2 = c2:Lerp(desired, 1 - math.exp(-4*dt)); CINE.cf = c2
                -- без FOV-зума
            end)
        end

        if CINE.active and CINE.saved then
            CINE.tween(CINE.saved.cf, CINE.saved.fov, 1.2, ease.inOut)
        end
    end

    local function endCinematic(ov)
        pcall(function() ov.bars(false, 0.4) end)
        task.wait(0.4)
        pcall(function() ov.destroy() end)
        CINE.finish()
    end

    local function runPortalSequence(target)
        if CINE.active or busy then return end
        busy = true
        local ov = makeOverlay()
        CINE.begin()
        local portal
        local ok, err = pcall(function()
            local H = BOMB.portalHeight
            local portalPos = target + Vector3.new(0, H, 0)
            local camPos = CINE.cf.Position
            local back = Vector3.new(camPos.X - target.X, 0, camPos.Z - target.Z)
            if back.Magnitude < 5 then back = Vector3.new(0, 0, 1) end
            back = back.Unit
            local right = back:Cross(Vector3.new(0, 1, 0))

            ov.bars(true, 0.4)
            ov.lines(0.7, Color3.new(1, 1, 1))
            local shot1 = CFrame.lookAt(
                target + back*58 + right*14 + Vector3.new(0, H*0.5, 0),
                target + Vector3.new(0, H*0.62, 0))
            CINE.tween(shot1, CINE.fov, 0.95, ease.inOut) -- FOV не меняется

            portal = animePortal(portalPos, 9, target.Y)
            portal.open()
            ov.flash(GREEN_L, 0.55, 0.35)
            CINE.shake(5, 0.5)
            -- долли-ин удалён: камера не приближается

            local handle = spawnThrownBomb(portalPos - Vector3.new(0, 4, 0), Vector3.new(0, -26, 0),
                {fuse = BOMB.dropFuse})
            if not handle then error("модель бомбы не загрузилась") end

            local closed = false
            cineBombPhases(handle, ov, {
                dir = -back,
                onTick = function(bp)
                    if not closed and bp.Y < portalPos.Y - 10 then
                        closed = true; portal.close()
                    end
                end,
            })
        end)
        if not ok then warn("[MONO] cine:", err) end
        if portal then portal.destroy() end
        endCinematic(ov)
        busy = false
    end

    local function runThrowCinematic(handle)
        if not handle or CINE.active or busy then return end
        busy = true
        local ov = makeOverlay()
        CINE.begin()
        local ok, err = pcall(function()
            ov.bars(true, 0.35)
            cineBombPhases(handle, ov, {})
        end)
        if not ok then warn("[MONO] cine:", err) end
        endCinematic(ov)
        busy = false
    end

    -- ВЫБОР ТОЧКИ
    local pick = {active = false}
    local stopPick
    stopPick = function()
        pick.active = false
        if pick.hb then pick.hb:Disconnect(); pick.hb = nil end
        if pick.click then pick.click:Disconnect(); pick.click = nil end
        if pick.marker then pick.marker:Destroy(); pick.marker = nil end
    end
    local function startPick()
        if pick.active then stopPick(); return end
        if CINE.active or busy then return end
        pick.active = true
        notify("Бомба", "Кликни по земле · Backspace — отмена")
        local marker = Instance.new("Part")
        marker.Shape = Enum.PartType.Cylinder
        marker.Anchored = true; marker.CanCollide = false; marker.CanTouch = false; marker.CanQuery = false
        marker.CastShadow = false; marker.Material = Enum.Material.Neon
        marker.Color = GREEN; marker.Transparency = 0.4
        marker.Size = Vector3.new(0.2, 8, 8)
        marker.Parent = getFxFolder()
        pick.marker = marker
        local lastHit = nil
        pick.hb = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            local mp = UserInputService:GetMouseLocation()
            local ray = cam:ViewportPointToRay(mp.X, mp.Y)
            local res = workspace:Raycast(ray.Origin, ray.Direction*2000, FXH.rayParams())
            if res and res.Normal.Y > 0.5 then
                lastHit = res
                marker.Transparency = 0.4
                marker.CFrame = CFrame.new(res.Position + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, math.pi/2)
                marker.Size = Vector3.new(0.2, 8 + math.sin(os.clock()*6)*0.8, 8 + math.sin(os.clock()*6)*0.8)
            else
                lastHit = nil
                marker.Transparency = 1
            end
        end)
        pick.click = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not lastHit then notify("Бомба", "Нужна ровная поверхность"); return end
            local target = lastHit.Position
            stopPick()
            task.spawn(runPortalSequence, target)
        end)
    end

    -- ИНСТРУМЕНТ
    local function giveBombTool()
        local toolName = "PurpleBomb"
        local bp = p:FindFirstChild("Backpack")
        if bp then
            for _, v in ipairs(bp:GetChildren()) do
                if v:IsA("Tool") and v.Name == toolName then v:Destroy() end
            end
        end
        if p.Character then
            for _, v in ipairs(p.Character:GetChildren()) do
                if v:IsA("Tool") and v.Name == toolName then v:Destroy() end
            end
        end

        local tool = Instance.new("Tool")
        tool.Name = toolName; tool.RequiresHandle = true; tool.CanBeDropped = false
        tool.ToolTip = "ЛКМ — бросить фиолетовую бомбу"
        local handle = Instance.new("Part")
        handle.Name = "Handle"; handle.Size = Vector3.new(0.6, 0.6, 0.6); handle.Transparency = 1
        handle.CanCollide = false; handle.CanTouch = false; handle.CanQuery = false
        handle.Parent = tool
        tool.PrimaryPart = handle

        local model, parts = buildBombVisual()
        if model then
            model.Parent = tool
            if parts and #parts > 0 then
                local primary = parts[1]
                model:PivotTo(handle.CFrame)
                for _, pt in ipairs(parts) do
                    pt.Anchored = false; pt.CanCollide = false; pt.CanTouch = false
                    pt.CanQuery = false; pt.Massless = true
                    if pt ~= primary then
                        local w = Instance.new("Weld")
                        w.Part0 = primary; w.Part1 = pt
                        w.C0 = primary.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
                        w.Parent = primary
                    end
                end
                local hw = Instance.new("Weld")
                hw.Part0 = handle; hw.Part1 = primary
                hw.C0 = handle.CFrame:ToObjectSpace(primary.CFrame); hw.C1 = CFrame.new()
                hw.Parent = handle
            end
        end

        local lastThrow = 0
        tool.Activated:Connect(function()
            if os.clock() - lastThrow < 0.8 then return end
            if CINE.active or busy then return end
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera
            if not hrp or not cam then return end
            lastThrow = os.clock()
            local look = cam.CFrame.LookVector
            local flat = Vector3.new(look.X, 0, look.Z)
            if flat.Magnitude < 0.05 then
                local rl = hrp.CFrame.LookVector
                flat = Vector3.new(rl.X, 0, rl.Z)
            end
            flat = flat.Unit
            local startPos = hrp.Position + flat*4.5 + Vector3.new(0, 1.2, 0)
            local vel = flat*BOMB.throwSpeed + Vector3.new(0, BOMB.upBoost + math.clamp(look.Y, -0.5, 0.8)*10, 0)
            local h = spawnThrownBomb(startPos, vel)
            if h and getgenv().BombCine then task.spawn(runThrowCinematic, h) end
        end)

        local backpack = p:FindFirstChild("Backpack")
        if backpack then tool.Parent = backpack end
    end

    -- УПРАВЛЕНИЕ / ЭКСПОРТ
    track(UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode == Enum.KeyCode.Backspace then
            if CINE.active then CINE.skip = true
            elseif pick.active then stopPick() end
        elseif input.KeyCode == Enum.KeyCode.B then
            startPick()
        end
    end))

    track(LocalPlayer.CharacterAdded:Connect(function()
        CINE.skip = true
        if pick.active then stopPick() end
    end))

    getgenv().giveBombTool = giveBombTool
    getgenv().spawnThrownBomb = spawnThrownBomb
    getgenv().startBombPick = startPick
    getgenv().toggleBombCine = function()
        getgenv().BombCine = not getgenv().BombCine
        notify("Кино-камера", getgenv().BombCine and "ВКЛ (бросок из рук)" or "ВЫКЛ (бросок из рук)")
    end
end

-- =====================================================================
-- РУКА С ПУШКОЙ
-- =====================================================================
local function stopToolAnims(hum)
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
        local nm = string.lower((tr.Animation and tr.Animation.Name) or tr.Name or "")
        if string.find(nm, "tool", 1, true) then
            pcall(function() tr:Stop(0) end)
        end
    end
end

local gunArmActive = false
local function applyGunArm(char, hum, gun)
    stopToolAnims(hum)
    local J = getBodyJoints(char)
    local raise = gun.def.noShoot and 0 or gunRaiseAmount()
    if raise > 0.001 then
        if J.shoulderR then
            local cam = workspace.CurrentCamera
            local pitch = cam and math.deg(math.asin(math.clamp(cam.CFrame.LookVector.Y, -1, 1))) or 0
            local ang = math.clamp(88 + pitch, 20, 170)
            applyJointRot(J.shoulderR, rotCache, ang*raise, 0, 0)
        end
        resetJoint(J.elbowR)
        resetJoint(J.wristR)
        gunArmActive = true
    elseif gunArmActive then
        resetJoint(J.shoulderR)
        resetJoint(J.elbowR)
        resetJoint(J.wristR)
        gunArmActive = false
    end
end

local function gunArmTick()
    if flight.active or emoteActive then return end
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local gun = getHeldGun(char)
    if gun then applyGunArm(char, hum, gun) end
end
track(RunService.Stepped:Connect(gunArmTick))
track(RunService.Heartbeat:Connect(gunArmTick))

track(RunService.RenderStepped:Connect(function(dt)
    local char = p.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    if flight.active then applyFlightPose(char); return end
    if emoteActive then return end

    local gun = getHeldGun(char)
    if gun then
        lastMoveStateAnim = nil
        applyGunArm(char, hum, gun)
        return
    end

    local shoulder = getRightShoulder(char)
    if not shoulder then return end
    local moving = hum.MoveDirection.Magnitude > 0.1
    if moving ~= lastMoveStateAnim then
        lastMoveStateAnim = moving; idleClock = 0
        shoulder.Transform = moving and CFrame.Angles(math.rad(-90),0,0) or CFrame.new()
    end
    if not moving and M.EK.IDLE then
        idleClock = idleClock + dt
        local b = math.sin(idleClock*M.EK.IDLE_SPD)*M.EK.IDLE_AMP
        shoulder.Transform = CFrame.Angles(math.rad(b), 0, math.rad(b*0.25))
    end
end))

-- =====================================================================
-- ANTI-FLING + ЩИТ [8]
-- =====================================================================
getgenv().AntiFlingModelConfig = {
    id = "rbxassetid://84006104714125",
    size = 9,
    offX = 0, offY = 0, offZ = 0,
    rotX = 0, rotY = 0, rotZ = 0,
}

do
    local AF = {
        model = nil, showUntil = 0, manual = false,
        suspendUntil = 0, lastSafeCF = nil, lastPos = nil,
        abnormalAt = -10, lastNotify = -10,
        rollbacks = {}, blockUntil = 0, scanT = 0,
        wasFlying = false, parts = {},
    }
    local srcCache = nil

    local function getSrc()
        if srcCache ~= nil then return srcCache end
        local cfg = getgenv().AntiFlingModelConfig
        local ok, m = pcall(loadAssetModel, cfg.id)
        srcCache = (ok and m) or false
        return srcCache
    end

    local function afHide()
        if AF.model then pcall(function() AF.model:Destroy() end) end
        AF.model = nil
    end

    local function afShow()
        if AF.model and AF.model.Parent then return end
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local src = getSrc()
        if not src then return end
        local cfg = getgenv().AntiFlingModelConfig
        local model = src:Clone()
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
                or d:IsA("JointInstance") or d:IsA("WeldConstraint") then
                d:Destroy()
            end
        end
        local parts = {}
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") then table.insert(parts, d) end
        end
        if #parts == 0 then model:Destroy(); return end
        model.Name = "MonoAntiFling"
        model.Parent = workspace
        for _, pt in ipairs(parts) do
            pt.Anchored = true; pt.CanCollide = false; pt.CanTouch = false
            pt.CanQuery = false; pt.Massless = true
        end
        local primary, bestVol = parts[1], -1
        for _, pt in ipairs(parts) do
            local v = pt.Size.X * pt.Size.Y * pt.Size.Z
            if v > bestVol then bestVol = v; primary = pt end
        end
        pcall(function() model.PrimaryPart = nil end)
        local _, sz0 = model:GetBoundingBox()
        local maxD = math.max(sz0.X, sz0.Y, sz0.Z)
        if maxD > 0.01 then
            pcall(function() model:ScaleTo(model:GetScale() * ((cfg.size or 9) / maxD)) end)
        end
        local bbCF = model:GetBoundingBox()
        local off = CFrame.new(cfg.offX or 0, cfg.offY or 0, cfg.offZ or 0)
            * CFrame.Angles(math.rad(cfg.rotX or 0), math.rad(cfg.rotY or 0), math.rad(cfg.rotZ or 0))
        local target = hrp.CFrame * off
        model:PivotTo(target * bbCF:ToObjectSpace(model:GetPivot()))
        for _, pt in ipairs(parts) do
            if pt ~= primary then
                local w = Instance.new("Weld")
                w.Part0 = primary; w.Part1 = pt
                w.C0 = primary.CFrame:ToObjectSpace(pt.CFrame); w.C1 = CFrame.new()
                w.Parent = pt
            end
        end
        local hw = Instance.new("Weld")
        hw.Name = "MonoAFWeld"
        hw.Part0 = hrp; hw.Part1 = primary
        hw.C0 = hrp.CFrame:ToObjectSpace(primary.CFrame); hw.C1 = CFrame.new()
        hw.Parent = primary
        for _, pt in ipairs(parts) do pt.Anchored = false end
        AF.model = model
    end

    local function trigger()
        local now = os.clock()
        AF.showUntil = now + 5
        afShow()
        if now - AF.lastNotify > 4 then
            AF.lastNotify = now
            notify("Anti-Fling", "Атака отражена")
        end
    end

    local function limits()
        if AF.manual then return 50, 75, 15 end
        return 110, 110, 40
    end

    local function nearOther(range)
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= p and pl.Character then
                local r = pl.Character:FindFirstChild("HumanoidRootPart")
                if r and (r.Position - hrp.Position).Magnitude <= range then return true end
            end
        end
        return false
    end

    local function check()
        local char = p.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then
            AF.lastSafeCF = nil; AF.lastPos = nil; return
        end
        local now = os.clock()
        if flight.active then AF.wasFlying = true
        elseif AF.wasFlying then
            AF.wasFlying = false
            AF.suspendUntil = math.max(AF.suspendUntil, now + 1.5)
        end
        local exempt = flight.active or getgenv().ShatterActive or isTeleporting
            or now < AF.suspendUntil or now - lastTeleport < 1.0
            or hum.SeatPart ~= nil or hrp.Anchored
        if exempt then
            AF.lastSafeCF = hrp.CFrame; AF.lastPos = hrp.Position; return
        end

        local lv = hrp.AssemblyLinearVelocity
        local av = hrp.AssemblyAngularVelocity
        local hLim, uLim, aLim = limits()
        local horiz = Vector3.new(lv.X, 0, lv.Z).Magnitude
        local bad = horiz > hLim or lv.Y > uLim or av.Magnitude > aLim

        local jumped = false
        if AF.lastPos and (hrp.Position - AF.lastPos).Magnitude > 60
            and (bad or now - AF.abnormalAt < 0.6 or nearOther(30)) then
            jumped = true
        end

        if bad then
            AF.abnormalAt = now
            hrp.AssemblyLinearVelocity = Vector3.new(0, math.clamp(lv.Y, -80, 30), 0)
            hrp.AssemblyAngularVelocity = Vector3.zero
        end

        if jumped and AF.lastSafeCF and now >= AF.blockUntil then
            local fresh = {}
            for _, t in ipairs(AF.rollbacks) do
                if now - t < 2 then table.insert(fresh, t) end
            end
            table.insert(fresh, now)
            AF.rollbacks = fresh
            if #fresh >= 4 then
                AF.blockUntil = now + 3
            else
                hrp.CFrame = AF.lastSafeCF
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end

        if bad or jumped then
            trigger()
            AF.lastPos = hrp.Position
        else
            AF.lastSafeCF = hrp.CFrame
            AF.lastPos = hrp.Position
        end
    end

    local function disableCollisions()
        for pl, set in pairs(AF.parts) do
            for part in pairs(set) do
                if part.Parent then
                    if part.CanCollide then part.CanCollide = false end
                else
                    set[part] = nil
                end
            end
        end
    end

    local function hookPlayer(pl)
        if pl == p then return end
        local function onChar(ch)
            local set = {}
            AF.parts[pl] = set
            for _, d in ipairs(ch:GetDescendants()) do
                if d:IsA("BasePart") then set[d] = true end
            end
            track(ch.DescendantAdded:Connect(function(d)
                if d:IsA("BasePart") then set[d] = true end
            end))
        end
        if pl.Character then onChar(pl.Character) end
        track(pl.CharacterAdded:Connect(onChar))
    end
    for _, pl in ipairs(Players:GetPlayers()) do hookPlayer(pl) end
    track(Players.PlayerAdded:Connect(hookPlayer))
    track(Players.PlayerRemoving:Connect(function(pl) AF.parts[pl] = nil end))

    track(RunService.Stepped:Connect(function()
        disableCollisions()
        check()
    end))
    track(RunService.Heartbeat:Connect(function(dt)
        check()
        local now = os.clock()
        if AF.model and not AF.model.Parent then AF.model = nil end
        if AF.model and not AF.manual and now > AF.showUntil then afHide() end
        if AF.manual and not AF.model then afShow() end

        AF.scanT = AF.scanT + dt
        if AF.scanT >= 0.2 then
            AF.scanT = 0
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl ~= p and pl.Character then
                        local r = pl.Character:FindFirstChild("HumanoidRootPart")
                        if r and (r.Position - hrp.Position).Magnitude <= 15 then
                            if r.AssemblyAngularVelocity.Magnitude > 50
                                or r.AssemblyLinearVelocity.Magnitude > 140 then
                                tr

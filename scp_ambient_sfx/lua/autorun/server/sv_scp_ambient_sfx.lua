--[[
   ____    
  / ___|  
 | |       
 \___ \    
   __) |   
 |____/   
  __   __ 
 |  \/  |
 | |\/| |
 | |  | |
 |_|  |_|
   ____
  / ___|
 | |  _ 
 | |_| |
  \____|   
  
  Mate Gaming SCP Ambience
]]
-- ============================================================================
-- [CONFIG] - YOU CAN EASILY MODIFY EVERYTHING HERE
-- ============================================================================

local CONFIG = {
    -- The cooldown in seconds after a sound has played before the next one can trigger
    CooldownTime = 60,

    -- The chance per second that a sound plays when cooldown is over (1 in X)
    -- e.g., 80 means a 1 in 80 chance every second. Higher number = rarer sounds.
    SoundChance = 80,

    -- Default volume if not changed via console command (0.0 to 1.0)
    DefaultVolume = 1.0,

    -- Default theme on server startup ("none", "halloween", etc.)
    DefaultTheme = "none",

    -- SOUND DATABASE
    -- The "none" theme ALWAYS plays. 
    -- Other themes will be MIXED into the "none" list when activated.
    -- to Deactivate a theme, set it to "none" via console command.
    Themes = {
        ["none"] = {
            "mategaming/scp_ambient/SCPambient1.wav", 
            "mategaming/scp_ambient/SCPambient2.wav", 
            "mategaming/scp_ambient/SCPambient3.wav", 
            "mategaming/scp_ambient/SCPambient4.wav", 
            "mategaming/scp_ambient/SCPambient5.wav", 
            "mategaming/scp_ambient/SCPambient6.wav", 
            "mategaming/scp_ambient/SCPambient7.wav", 
            "mategaming/scp_ambient/SCPambient8.wav", 
            "mategaming/scp_ambient/SCPambient9.wav", 
            "mategaming/scp_ambient/SCPambient10.wav", 
            "mategaming/scp_ambient/SCPambient11.wav", 
            "mategaming/scp_ambient/SCPambient12.wav", 
            "mategaming/scp_ambient/SCPambient13.wav", 
            "mategaming/scp_ambient/SCPambient14.wav", 
            "mategaming/scp_ambient/SCPambient15.wav", 
            "mategaming/scp_ambient/SCPambient16.wav", 
            "mategaming/scp_ambient/SCPambient17.wav", 
            "mategaming/scp_ambient/SCPambient18.wav", 
            "mategaming/scp_ambient/SCPambient19.wav", 
            "mategaming/scp_ambient/SCPambient20.wav", 
            "mategaming/scp_ambient/SCPambient21.wav", 
            "mategaming/scp_ambient/SCPambient22.wav", 
            "mategaming/scp_ambient/SCPambient23.wav", 
            "mategaming/scp_ambient/SCPambient24.wav", 
            "mategaming/scp_ambient/SCPambient25.wav", 
            "mategaming/scp_ambient/scpsl/forget_about_your_fears.wav",
            "mategaming/scp_ambient/scpsl/unexplained_behaviors.wav"
        },
        
        ["halloween"] = {
            "mategaming/scp_ambient/holiday/halloween/evillaught.wav",
            "mategaming/scp_ambient/holiday/halloween/scaryatmosphere.wav",
            "mategaming/scp_ambient/holiday/halloween/scaryhorn.wav"
        },

        ["bday"] = {
            "mategaming/scp_ambient/holiday/bday/partyhorn.wav",
        },

        -- EXAMPLE
        ["action"] = {
            -- "mategaming/scp_ambient/action1.wav",
        },
    }
}

-- ============================================================================
-- [LOGIC] - DO NOT TOUCH THIS PART UNLESS YOU KNOW WHAT YOU ARE DOING
-- ============================================================================

-- Helper function
local function GetAllowedThemesString()
    local allowed = {}
    for themeName, _ in pairs(CONFIG.Themes) do
        table.insert(allowed, themeName)
    end
    return table.concat(allowed, ", ")
end

-- Init
hook.Add("Initialize", "SCPAmbientInitializeGlobals", function()
    if GetGlobalFloat("scp_ambient_sfx_volume", -1) == -1 then
        SetGlobalFloat("scp_ambient_sfx_volume", CONFIG.DefaultVolume)
    end
    if GetGlobalString("scp_ambient_sfx_theme", "") == "" then
        SetGlobalString("scp_ambient_sfx_theme", CONFIG.DefaultTheme)
    end
end)

-- Command: Volume Control
concommand.Add( "scp_ambient_sfx_volume", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then 
        ply:PrintMessage(HUD_PRINTCONSOLE, "You do not have permission to use this command!")
        return 
    end

    if not args[1] then 
        local currentVol = GetGlobalFloat("scp_ambient_sfx_volume", CONFIG.DefaultVolume)
        ply:PrintMessage(HUD_PRINTCONSOLE, "Current Volume: " .. currentVol .. " (Usage: scp_ambient_sfx_volume <0.0 - 1.0>)")
        return 
    end
    
    local scpambiencevolume = tonumber(args[1])
    if not scpambiencevolume then return end

    scpambiencevolume = math.Clamp(scpambiencevolume, 0, 1)
    SetGlobalFloat("scp_ambient_sfx_volume", scpambiencevolume)
    
    print("SCP Ambience Volume has been set to " .. scpambiencevolume .. ".")
end )

-- Command
concommand.Add( "scp_ambient_sfx_theme", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then 
        ply:PrintMessage(HUD_PRINTCONSOLE, "You do not have permission to use this command!")
        return 
    end

    if not args[1] then 
        local currentTheme = GetGlobalString("scp_ambient_sfx_theme", CONFIG.DefaultTheme)
        ply:PrintMessage(HUD_PRINTCONSOLE, "Current Theme: '" .. currentTheme .. "' (Usage: scp_ambient_sfx_theme <theme_name>)")
        ply:PrintMessage(HUD_PRINTCONSOLE, "Available Themes: " .. GetAllowedThemesString())
        return 
    end

    local choice = string.lower(args[1])
    
    -- Dynamic check
    if CONFIG.Themes[choice] then
        SetGlobalString("scp_ambient_sfx_theme", choice)
        print("SCP Ambience Theme '" .. choice .. "' has been enabled and mixed with default sounds.")
    else
        ply:PrintMessage(HUD_PRINTCONSOLE, "Invalid theme! Available themes: " .. GetAllowedThemesString())
    end
end )

-- Core logic to play sounds
local cooldownActive = false
  
local function PlayRandomSound()
    local poolToChooseFrom = table.Copy(CONFIG.Themes["none"] or {})
    
    local currentTheme = GetGlobalString("scp_ambient_sfx_theme", CONFIG.DefaultTheme)
    
    if currentTheme != "none" and CONFIG.Themes[currentTheme] then
        for _, soundFile in ipairs(CONFIG.Themes[currentTheme]) do
            table.insert(poolToChooseFrom, soundFile)
        end
    end

    if #poolToChooseFrom == 0 then return end

    local soundFile = table.Random(poolToChooseFrom)
    local scpambiencevolume = GetGlobalFloat("scp_ambient_sfx_volume", CONFIG.DefaultVolume)
    
    for _, ply in ipairs(player.GetAll()) do
        ply:EmitSound(soundFile, 50, 100, scpambiencevolume, CHAN_AUTO)
    end
end
  
local function StartCooldown()
    cooldownActive = true
    timer.Simple(CONFIG.CooldownTime, function()
        cooldownActive = false
    end)
end
  
timer.Create("RandomAmbientSoundsTimer", 1, 0, function()
    if not cooldownActive then
        if math.random(1, CONFIG.SoundChance) == 1 then 
            PlayRandomSound()
            StartCooldown()
        end
    end
end)

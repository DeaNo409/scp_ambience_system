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

local soundFiles = {
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
    "mategaming/scp_ambient/holiday/halloween/evillaught.wav",
    "mategaming/scp_ambient/holiday/halloween/scaryatmosphere.wav",
    "mategaming/scp_ambient/holiday/halloween/scaryhorn.wav",
    "mategaming/scp_ambient/scpsl/forget_about_your_fears.wav",
    "mategaming/scp_ambient/scpsl/unexplained_behaviors.wav"
  }
  
  local cooldownTime = 60 
  
  local function PlayRandomSound()
    local soundFile = table.Random(soundFiles)
    for _, ply in ipairs(player.GetAll()) do
      ply:EmitSound(soundFile, 50, 100, 1, CHAN_AUTO)
    end
  end
  
  local function StartCooldown()
    cooldownActive = true
    timer.Simple(cooldownTime, function()
      cooldownActive = false
    end)
  end
  
  hook.Add("Think", "RandomAmbientSounds", function()
    if not cooldownActive then
      if math.random(1, 80) == 1 then -- Einstellen der Wahrscheinlichkeit für das Abspielen der Sounds (hier: 1 in 80)
        PlayRandomSound()
        StartCooldown()
      end
    end
  end)

  print("
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
   
   SCP Ambience Loaded!
 ")

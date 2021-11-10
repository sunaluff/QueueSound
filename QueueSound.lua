-------------------------------
-- Namespaces & Variables
-------------------------------
local _, core = ...
core.QueueSound = {}
local QueueSound = core.QueueSound;

local musicPlay
local ramonesSoundHandle
-------------------------------
-- QueueSound
-- in QueueSound we 1: Listen for events related to queue windows
-- 2: Check if the conditions are met to play the sound
-- 3: Play the actual sounds
-- To-do: Split checkers into seperate functions for clarity and cleanliness(Arenas don't need to run every single LFR statement vice versa)
-- Create sound for more than one BG type
-------------------------------

-- The following 2 check your arena and LFG q status
function QueueSound:arenaStatusChecker ()
    local queueStatus,_,_,_,_,battlefieldType  = GetBattlefieldStatus(1)
    return queueStatus, battlefieldType
end
function QueueSound:lfgStatusChecker ()
    local _,_,_,dungType,_,_,_,dungResp  = GetLFGProposal()
    return dungType, dungResp
end

--Plays the music/stops it depending on what boolean value you enter into the function
local function arenaPlayMusic(playSound,soundFile)
    local _
    if playSound == true then
        _, ramonesSoundHandle = PlaySoundFile(soundFile,"Master")
    end
    if playSound == false then
        if ramonesSoundHandle ~= nil then
            StopSound(ramonesSoundHandle)
        end
    end
end

-- queueStatus can return none, queued, confirm or active, none for no current q
-- ratedStatus can return BATTLEGROUND, ARENASKIRMISH or ARENA, nil for no current q
-- dungType can return 1 for normal dungeons, 2 for heroics, 3 for LFR, 4 for scenarios(old) and 5 for flex raids(old), nil for no current q
-- dungResp can return either true if a response(either accept or decline) has been given, false if no response has been given, nil for no current q
function arenaEventHandler (self, event, ...)
    local queueStatus, battlefieldType = core.QueueSound:arenaStatusChecker()
    local dungType, dungResp = core.QueueSound:lfgStatusChecker()
    local arenaToggleState, bgToggleState,skrmToggleState,LFDToggleState,LFRToggleState = core.Config.VarStates();
    local arenaSong,bgSong,skrmSong,LFDSong,LFRSong = core.Config.MuscStates();
    if musicPlay == nil then
    musicPlay = false
    end
    --- Dungeon/LFR Checker
    if dungResp == false and dungType > 0 and musicPlay == false then
        if (dungType == 1 or dungType == 2) and LFDToggleState == true then
            arenaPlayMusic(true,LFDSong)
            musicPlay = true
        end
        if dungType >= 3 and LFRToggleState == true then
            arenaPlayMusic(true,LFRSong)
            musicPlay = true
        end
    end
    if dungResp == true then
        arenaPlayMusic(false,arenaSong)
        musicPlay = false
    end
    -- PvP Checker
    if queueStatus == "confirm" then
        if battlefieldType == "ARENA" and arenaToggleState == true then
            arenaPlayMusic(true,arenaSong)
        end
        if battlefieldType == "BATTLEGROUND" and bgToggleState == true then
            arenaPlayMusic(true,bgSong)
        end
        if battlefieldType == "ARENASKIRMISH" and skrmToggleState == true then
            arenaPlayMusic(true,skrmSong)
        end
    end
    if queueStatus~= "confirm" and dungType == nil then
        arenaPlayMusic(false,arenaSong)
    end
end

function QueueSound:arenaSoundInit()
    local arenaSoundFrame = CreateFrame("Frame")
    arenaSoundFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
    arenaSoundFrame:SetScript("OnEvent", arenaEventHandler)
    local lfdSoundFrame = CreateFrame("Frame")
    lfdSoundFrame:RegisterEvent("LFG_PROPOSAL_UPDATE")
    lfdSoundFrame:SetScript("OnEvent",arenaEventHandler)
end
-------------------------------
-- Namespaces & Variables
-------------------------------
local _, core = ...
core.Config = {}
local Config = core.Config
local arenaSoundconfig
-------------------------------
-- Config
-- in config we 1: Create the actual configuration window
-- 2: Set our global bools depending on the toggles in the menu
-------------------------------
function Config:Toggle()
    local menu = arenaSoundconfig or Config:CreateMenu()
    menu:SetShown(not menu:IsShown())
end

function Config:VarStates(bgType)
    if bgType == "arena" then
        qsVariableArray["qsArenaState"] = not qsVariableArray["qsArenaState"]
    end
    if bgType == "bg" then
        qsVariableArray["qsBGState"] = not qsVariableArray["qsBGState"]
    end
    if bgType == "skrm" then
        qsVariableArray["qsSKRMState"] = not qsVariableArray["qsSKRMState"]
    end
    if bgType == "lfd" then
        qsVariableArray["qsLFDState"] = not qsVariableArray["qsLFDState"]
    end
    if bgType == "lfr" then
        qsVariableArray["qsLFRState"] = not qsVariableArray["qsLFRState"]
    end
    return qsVariableArray["qsArenaState"], qsVariableArray["qsBGState"], qsVariableArray["qsSKRMState"], qsVariableArray["qsLFDState"], qsVariableArray["qsLFRState"]
end

function Config:MuscStates()
    return qsVariableArray["qsArenaSong"],qsVariableArray["qsBGSong"],qsVariableArray["qsSKRMSong"],qsVariableArray["qsLFDSong"],qsVariableArray["qsLFRSong"];
end

function Config:CreateToggle(point, relativeFrame, relativePoint, text,toggleVar, bgType)
    local toggle = CreateFrame("CheckButton", nil, arenaSoundconfig, "UicheckButtonTemplate")
    toggle:SetPoint(point, relativeFrame,relativePoint)
    toggle.text:SetText(text)
    toggle:SetChecked(toggleVar)
    toggle:SetScript("OnClick",function() core.Config:VarStates(bgType) end)
    return toggle;
end

function Config:CreateMenu()
    -- creating the main frame + its location
    arenaSoundconfig = CreateFrame("Frame", "arenaSoundUIFrame", UIParent, "BasicFrameTemplateWithInset")
    arenaSoundconfig:SetSize(200, 200)
    arenaSoundconfig:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
    -- title
    arenaSoundconfig.title = arenaSoundconfig:CreateFontString(nil, "OVERLAY")
    arenaSoundconfig.title:SetFontObject("GameFontHighlight")
    arenaSoundconfig.title:SetPoint("CENTER", arenaSoundconfig.TitleBg, "CENTER")
    arenaSoundconfig.title:SetText("Queue Sound Options")
    -- mainFrame
    arenaSoundconfig.mainArea = CreateFrame("Frame",nil,arenaSoundconfig)
    arenaSoundconfig.mainArea:SetSize(180,160)
    arenaSoundconfig.mainArea:SetPoint("BOTTOM",arenaSoundconfig,"BOTTOM",0,10)
    -- arenaToggle
    arenaSoundconfig.arenaToggle = self:CreateToggle("TOPLEFT",arenaSoundconfig.mainArea,"TOPLEFT","Arena Queue Sound",qsVariableArray["qsArenaState"],"arena")
    -- bgToggle
    arenaSoundconfig.bgToggle = self:CreateToggle("TOPLEFT",arenaSoundconfig.arenaToggle,"BOTTOMLEFT","Battleground Queue Sound",qsVariableArray["qsBGState"],"bg")
    -- skrmToggle
    arenaSoundconfig.skrmToggle = self:CreateToggle("TOPLEFT",arenaSoundconfig.bgToggle,"BOTTOMLEFT","Skirmish Queue Sound",qsVariableArray["qsSKRMState"],"skrm")
    -- lfdToggle
    arenaSoundconfig.lfdToggle = self:CreateToggle("TOPLEFT",arenaSoundconfig.skrmToggle,"BOTTOMLEFT","Dungeon Queue Sound",qsVariableArray["qsLFDState"],"lfd")
    --lfrToggle
    arenaSoundconfig.lfrToggle = self:CreateToggle("TOPLEFT",arenaSoundconfig.lfdToggle,"BOTTOMLEFT","LFR Queue Sound",qsVariableArray["qsLFRState"],"lfr")

    arenaSoundconfig:Hide()
    return arenaSoundconfig
end
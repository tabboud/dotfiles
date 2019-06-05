local alert    = require("hs.alert")
local timer    = require("hs.timer")
local eventtap = require("hs.eventtap")

local events   = eventtap.event.types

local ctrltap   = {}

-- timeout for ctrol key
ctrltap.timeFrame = .25

-- what to do when the ctrl key has been tapped
ctrltap.action = function()
    eventtap.keyStroke({}, 'escape')
--    alert("esc")
end

local ctrlPressed = false

-- Synopsis:

-- what we're looking for is the ctrl key down event followed by
-- the key up within a short time frame with no other key or flag
-- change event before the specified time has passed

-- verify that *only* the ctrl key flag is being pressed
local onlyCtrl = function(ev)
    local result = ev:getFlags().ctrl
    for k,v in pairs(ev:getFlags()) do
        if k ~= "ctrl" and v then
            result = false
            break
        end
    end
    return result
end

-- verify that no modifier keys are being pressed
local noModifiers = function(ev)
    result = true
    for k,v in pairs(ev:getFlags()) do
        if v == true then
            result = false
            break
        end
    end
    return result
end

ctrltap.eventwatcher = eventtap.new({events.flagsChanged, events.keyDown}, function(ev)
    ev_type = ev:getType()

    if ev_type == events.flagsChanged then
        if onlyCtrl(ev) then
            ctrltap.countDownTimer = timer.doAfter(ctrltap.timeFrame, function()
                ctrltap.countDownTimer = nil
                ctrlPressed = false
            end)
            ctrlPressed = true
        elseif noModifiers(ev) then
            if ctrlPressed and ctrltap.action then
                ctrltap.action()
            end
        else
            ctrlPressed = false
        end
    elseif ev_type == events.keyDown then
        ctrlPressed = false
    end

    return false ;
end):start()


return ctrltap

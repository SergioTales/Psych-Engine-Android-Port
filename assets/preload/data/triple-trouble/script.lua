local rings = 0

local ringIndex = 0
local ringSpeed = 0
local initRingWidth = 0
local cur = 0
local flashRing = false

local ringFlashIndex = 0

local ringStarted = false

local t = 0
local s = 0

function goodNoteHit(id, data, type, sussy)
    if not sussy and data == 2 then
        rings = rings + 1
        flashRing = false
        playSound('ring')
    end
end

function noteMiss(id, data, type, sussy)
    if not sussy then
        if data == 2 then
            setProperty('songMisses', getProperty('songMisses') - 1)
        else
            if rings > 0 then
                playSound('byeRings')
                rings = rings - 1
                flashRing = true
                runTimer('ringStopFlash', 3)
                setProperty('songMisses', getProperty('songMisses') - 1)
            else
                flashRing = true
            end
        end
    end
end

function onCreate()
    makeLuaText('rings', 'Rings: '..rings, 0, 0, 0)
    setTextSize('rings', 32)
    setTextBorder('rings', 2, getColorFromHex('000000'))
    setTextColor('rings', getColorFromHex('FFFFFF'))
    setTextAlignment('rings', 'center')
    setTextFont('rings', 'vcr.ttf')
    setProperty('rings.x', 139)
    setProperty('rings.y', 90)
    setProperty('rings.alpha', 0)
    addLuaText('rings')

    makeLuaSprite('ring', 'ring', 0, 68)
    setGraphicSize('ring', 80)
    addLuaSprite('ring', true)
    setProperty('ring.alpha', 0)
    setObjectCamera('ring', 'hud')
    ringStarted = true
    initRingWidth = getProperty('ring.width')

    for num=0,1 do
        local a = num + 1
        makeLuaSprite('hudshit'..num, 'exep3/hudshit', -(300 * a), 70 * num)
        setObjectCamera('hudshit'..num, 'hud')
        addLuaSprite('hudshit'..num, false)
        scaleObject('hudshit'..num, 0.5, 0.5)

        runTimer('hudshit'..num, 1 * a)
    end

    runTimer('light rings', 2)

    makeAnimatedLuaSprite('static', 'exep3/Phase3Static', 0, 0)
    addAnimationByPrefix('static', 'flash', 'Phase3Static instance 1', 24, false)
    setObjectCamera('static', 'hud')
    setGraphicSize('static', getProperty('static.width') * 4)
    setProperty('static.alpha', 0.3)

    makeAnimatedLuaSprite('missStatic', 'exep3/hitStatic', 0, 0)
    addAnimationByPrefix('missStatic', 'missed', 'staticANIMATION', 24, false)
    setObjectCamera('missStatic', 'hud')
    setGraphicSize('missStatic', getProperty('missStatic.width') * 4)
    setProperty('missStatic.alpha', 0.7)

    addCharacterToList('knucklesExe', 'dad')
    addCharacterToList('xenophane', 'dad')
    addCharacterToList('xenophane-flip', 'dad')
    addCharacterToList('eggman', 'dad')
    addCharacterToList('flippedBf', 'boyfriend')
    addCharacterToList('bf-perspectiveLeft', 'boyfriend')
    addCharacterToList('bf-perspectiveRight', 'boyfriend')
end

function onCreatePost()
    triggerEvent('Opponent Notes Left Side', 0,0)

    setProperty('boyfriend.x', 466)
    setProperty('boyfriend.y', 373)
    setProperty('dad.x', -43.65)
    setProperty('dad.y', 274 + 54)
end

function onUpdate(elapsed)
    setTextString('rings', ''..rings)

    setPropertyFromGroup('opponentStrums', 2, 'alpha', 0)

    if rings < 0 then
        rings = 0
    end

    ringIndex = ringIndex + elapsed
    ringSpeed = getPropertyFromClass('Conductor', 'stepCrochet') / 100 * 8
    ringFlashIndex = ringFlashIndex + elapsed
    cur = math.sin(ringIndex * ringSpeed) * initRingWidth

    if not flashRing then
        if cur < 1 then
            setGraphicSize('ring', -math.sin(ringIndex * ringSpeed) * initRingWidth + 1, initRingWidth)
        else
            setGraphicSize('ring', math.sin(ringIndex * ringSpeed) * initRingWidth, initRingWidth)
        end
    end

    if not ringStarted and not flashRing then
        setProperty('ring.alpha', 1)
    end

    if flashRing then
        setGraphicSize('ring', initRingWidth, initRingWidth)
        setProperty('ring.alpha', math.sin(ringFlashIndex * 20) * 1)
    end

    setProperty('ring.x', 90 - getProperty('ring.width') / 2)

    -------------------------------------------------------------------

    if getProperty('static.animation.curAnim.finished') and getProperty('static.animation.curAnim.name') == 'flash' then
        setProperty('static.alpha', 0)
    else
        setProperty('static.alpha', 0.3)
    end

    if getProperty('missStatic.animation.curAnim.finished') and getProperty('missStatic.animation.curAnim.name') == 'missed' then
        setProperty('missStatic.alpha', 0)
    else
        setProperty('missStatic.alpha', 1)
    end
end

function onTimerCompleted(tag)
    if tag == 'ringStopFlash' then
        flashRing = false
    end

    if tag == 'hudshit0' or tag == 'hudshit1' then
        doTweenX(tag, tag, 0, 0.5, 'quadInOut')
    end

    if tag == 'light rings' then
        doTweenAlpha('ring', 'ring', 1, 0.6, 'quadInOut')
        doTweenAlpha('rings', 'rings', 1, 0.6, 'quadInOut')
    end
end

function onTweenCompleted(tag)
    if tag == 'ring' then
        ringStarted = false
    end
end

function onEvent(name,a,b)
    if name == 'Opponent Notes Left Side' then
        setPropertyFromGroup('opponentStrums', 0, 'x', defaultOpponentStrumX0 + 40)
        setPropertyFromGroup('opponentStrums', 1, 'x', defaultOpponentStrumX1 + 40)
        setPropertyFromGroup('opponentStrums', 2, 'x', defaultOpponentStrumX2 + 40)
        setPropertyFromGroup('opponentStrums', 3, 'x', defaultOpponentStrumX2 + 40)
        setPropertyFromGroup('opponentStrums', 4, 'x', defaultOpponentStrumX3 + 40)

        setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0)
        setPropertyFromGroup('playerStrums', 1, 'x', defaultPlayerStrumX1)
        setPropertyFromGroup('playerStrums', 2, 'x', defaultPlayerStrumX2)
        setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3)
        setPropertyFromGroup('playerStrums', 4, 'x', defaultPlayerStrumX4)
    end

    if name == 'Opponent Notes Right Side' then
        setPropertyFromGroup('playerStrums', 0, 'x', defaultOpponentStrumX0)
        setPropertyFromGroup('playerStrums', 1, 'x', defaultOpponentStrumX1)
        setPropertyFromGroup('playerStrums', 2, 'x', defaultOpponentStrumX2)
        setPropertyFromGroup('playerStrums', 3, 'x', defaultOpponentStrumX3)
        setPropertyFromGroup('playerStrums', 4, 'x', defaultOpponentStrumX4)

        setPropertyFromGroup('opponentStrums', 0, 'x', defaultPlayerStrumX0 + 40)
        setPropertyFromGroup('opponentStrums', 1, 'x', defaultPlayerStrumX1 + 40)
        setPropertyFromGroup('opponentStrums', 2, 'x', defaultPlayerStrumX2 + 40)
        setPropertyFromGroup('opponentStrums', 3, 'x', defaultPlayerStrumX2 + 40)
        setPropertyFromGroup('opponentStrums', 4, 'x', defaultPlayerStrumX3 + 40)
    end

    if name == 'Trigger Static' then
        t = t +1
        if t == 1 then
            addLuaSprite('static', true)
        end
        objectPlayAnimation('static', 'flash', true)
        setProperty('static.alpha', 0.3)
    end

    if name == 'Missed Static Note' then
        s = s +1
        if s == 1 then
            addLuaSprite('missStatic', true)
        end
        objectPlayAnimation('missStatic', 'missed', true)
    end
end

function onStepHit()
    if curStep == 1 then
        doTweenZoom('asf', 'camGame', 1.1, 2, 'cubeOut')
        setProperty('defaultCamZoom', 1.1)
        triggerEvent('Trigger Static', 0, 0)
    end

    if curStep == 1024 or curStep == 1088 or curStep == 1216 or curStep == 1280 or curStep == 2305 or curStep == 2810 or curStep == 3199 or curStep == 4096 then
        triggerEvent('Trigger Static', 0, 0)
    end

    if curStep == 1040 then --xenophane
        setProperty('plasticShit.visible', true)

        triggerEvent('Change Character', 'dad', 'xenophane')
        triggerEvent('Change Character', 'nashe', 'bf-perspectiveRight')

        setProperty('boyfriend.x', 502.45 + 300)
        setProperty('boyfriend.y', 370.45)
        setProperty('dad.x', 20 + 100)
        setProperty('dad.y', -94.75 + 100)

        doTweenZoom('adffg', 'camGame', 0.9, 2, 'cubeOut')
        setProperty('defaultCamZoom', 0.9)
    end

    if curStep == 1296 then --knuckk
        setProperty('plasticShit.visible', false)

        triggerEvent('Opponent Notes Right Side', 'among us is', 'not funny')
        
        doTweenZoom('asfyte', 'camGame', 1.1, 2, 'cubeOut')
        setProperty('defaultCamZoom', 1.1)

        triggerEvent('Change Character', 'dad', 'knucklesExe')
        triggerEvent('Change Character', 'nashe', 'flippedBf')

        setProperty('boyfriend.x', 466.1)
        setProperty('boyfriend.y', 685.6 - 300)
        setProperty('dad.x', 1300 + 100 - 206)
        setProperty('dad.y', 260 + 94)
    end

    if curStep == 2320 then --xenophane right
        doTweenZoom('adffgedfdfg', 'camGame', 0.9, 2, 'cubeOut')
        setProperty('defaultCamZoom', 0.9)

        setProperty('plasticShit.visible', true)

        triggerEvent('Change Character', 'dad', 'xenophane-flip')
        triggerEvent('Change Character', 'nashe', 'bf-perspectiveLeft')

        setProperty('boyfriend.x', 502.45 - 150)
        setProperty('boyfriend.y', 370.45)
        setProperty('dad.x', 1300 - 250)
        setProperty('dad.y', -94.75 + 100)

        doTweenZoom('asfyteasdsedfdrgg', 'camGame', 1, 2, 'cubeOut')
        setProperty('defaultCamZoom', 1)
    end

    if curStep == 2823 then --eggdick face event
        doTweenZoom('rrrrrr', 'camGame', 1, 2, 'cubeOut')
        setProperty('defaultCamZoom', 1)

        triggerEvent('Opponent Notes Left Side', 'a', 's')

        setProperty('plasticShit.visible', false)

        triggerEvent('Change Character', 'dad', 'eggman')
        triggerEvent('Change Character', 'nashe', 'bf')

        setProperty('boyfriend.x', 466.1 + 200)
        setProperty('boyfriend.y', 685.6 - 250)
        setProperty('dad.x', 20 - 200)
        setProperty('dad.y', 30 + 200)
    end

    if curStep == 2887 or curStep == 3015 or curStep == 4039 then   --eggman goes hahahaha
        triggerEvent('Play Animation', 'dad', 'nashe')
    end

    if curStep == 4111 then --xenophane come back
        setProperty('plasticShit.visible', true)

        triggerEvent('Change Character', 'dad', 'xenophane')
        triggerEvent('Change Character', 'nashe', 'bf-perspectiveLeft')

        setProperty('boyfriend.x', 502.45)
        setProperty('boyfriend.y', 370.45)
        setProperty('dad.x', 20 - 200)
        setProperty('dad.y', -94.75 + 100)
    end
end
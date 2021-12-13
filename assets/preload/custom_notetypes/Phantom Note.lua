function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Phantom Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'PHANTOM_assets');
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true);

			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
		end
	end
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Static Note' then
        playSound('hitStatic1')
		triggerEvent('Missed Static Note', 'amongUs', 'amongUs')
	end
end

# Create keyboard
keyboardSettings =
    id: 'qwerty-hancock'
    width: 1000
    height: 200
    octaves: 3
    startNote: 'C3'
    whiteNotesColour: 'white'
    blackNotesColour: '#2c3e50'
    hoverColour: '#9b59b6'

keyboard = qwertyHancock keyboardSettings

context = new webkitAudioContext()
nodes = {}

# Bind keys
keyboard.keyDown (note, frequency) ->
    oscillator = context.createOscillator()
    gainNode = context.createGainNode()

    oscillator.type = 1
    oscillator.frequency.value = frequency
    gainNode.gain.value = 0.3
    oscillator.connect gainNode
    if typeof oscillator.noteOn isnt 'undefined'
        oscillator.noteOn 0

    gainNode.connect context.destination
    nodes[note] = oscillator

keyboard.keyUp (note, frequency) ->
    if typeof nodes[note].noteOff isnt 'undefined'
        nodes[note].noteOff0

    nodes[note].disconnect()

# Create scales
scales = new Scales keyboardSettings.startNote, keyboardSettings.octaves

activeNote = null
intitialOctave = null
activeTimeout = null
playScale = (notes) ->
    if activeNote?
        keyboard.release activeNote
    if notes.length is 0
        return
    note = notes.shift()

    unless intitialOctave
        intitialOctave = if note.length is 3 then note[2] else note[1]
    currentOctave = if note.length is 3 then note[2] else note[1]

    if currentOctave is intitialOctave
        note = note.replace currentOctave, 'l'
    else
        note = note.replace currentOctave, 'u'

    keyboard.press note
    activeNote = note
    activeTimeout = setTimeout playScale, 500, notes

getSelected = (radioGroupName) ->
    form = document.forms.item()
    radioGroup = form.elements[radioGroupName]
    for button in radioGroup
        if button.checked
            return button.value
    return undefined

playButton = document.getElementById 'play-button'

playButton.onclick = (e) ->
    e.preventDefault()
    octave = '3'
    if activeTimeout
        clearTimeout activeTimeout

    tonic = getSelected('tonic') + octave
    scale = getSelected('scales')
    playScale scales.get scale, tonic

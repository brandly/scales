
window.audioContext = window.audioContext or window.webkitAudioContext

unless window.audioContext
    message = '<h3>Sorry, your browser doesn\'t support the Web Audio API. ' +
              'Try <a href="http://google.com/chrome">Chrome</a> instead!</h3>'
    qwerty = document.getElementById 'qwerty-hancock'
    qwerty.insertAdjacentHTML 'beforebegin', message

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

context = new window.audioContext()
nodes = {}

# http://docs.webplatform.org/wiki/apis/webaudio/OscillatorNode/type
oscillatorTypes =
    sine: 0
    square: 1
    sawtooth: 2
    triangle: 3

# http://docs.webplatform.org/wiki/apis/webaudio/BiquadFilterNode/type
filterTypes =
    lowpass: 0
    highpass: 1
    bandpass: 2
    lowshelf: 3
    highshelf: 4
    peaking: 5
    notch: 6
    allpass: 7

volume = 0.4 # out of 1
attack = 0.1 # in seconds
sustain = 0.8 # also seconds
playNote = (context, frequency) ->
    oscillator = context.createOscillator()
    gainNode = context.createGainNode()

    oscillator.type = oscillatorTypes.triangle
    oscillator.frequency.value = frequency
    oscillator.noteOn? 0

    now = context.currentTime
    gainNode.gain.cancelScheduledValues now

    gainNode.gain.value = 0
    gainNode.gain.setTargetAtTime 0, now, .001 # prevents popping
    gainNode.gain.linearRampToValueAtTime volume, now + attack
    gainNode.gain.linearRampToValueAtTime 0, now + sustain

    filter = context.createBiquadFilter()
    filter.type = filterTypes.lowpass
    filter.frequency.value = 900

    oscillator.connect filter
    filter.connect gainNode

    gainNode.connect context.destination
    return oscillator

# Bind keys
keyboard.keyDown (note, frequency) ->
    node = playNote context, frequency
    nodes[note] = node

# throws if not defined
keyboard.keyUp ->

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

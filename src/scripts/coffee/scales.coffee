

window.keyboard = keyboard = qwertyHancock
    id: 'qwerty-hancock'
    width: 600
    height: 150
    octaves: 3
    startNote: 'A3'
    whiteNotesColour: 'white'
    blackNotesColour: 'black'
    hoverColour: '#f3e939'

context = new webkitAudioContext()
nodes = {}

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

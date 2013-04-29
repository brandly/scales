

class Scales

    notesWithSharps: ['A', 'C', 'D', 'F', 'G']
    steps:
        major: [2, 2, 1, 2, 2, 2, 1]
        naturalMinor: [2, 1, 2, 2, 1, 2, 2]
        harmonicMinor: [2, 1, 2, 2, 1, 3, 1]
        melodicMinor: [2, 1, 2, 2, 2, 2, 1]

    constructor: (@startNote, @octaves) ->
        @baseNotes = ['A', 'B', 'C', 'D', 'E', 'F', 'G']
        @buildNotes()

    buildNotes: ->
        @notes = []
        starting =
            note: @startNote[0]
            octave: parseInt @startNote[1], 10

        @alignBaseNotes starting.note

        for octaveLoop in [0...@octaves]
            octave = starting.octave + octaveLoop
            for baseNote in @baseNotes
                @notes.push baseNote + octave
                if baseNote in @notesWithSharps
                    @notes.push baseNote + '#' + octave

    # Put starting note in the first slot
    alignBaseNotes: (startingNote) ->
        noteIndex = @baseNotes.indexOf startingNote
        beforeNote = @baseNotes.splice 0, noteIndex
        @baseNotes = @baseNotes.concat beforeNote

    # Main entry point
    get: (type, startingNote) ->
        index = @notes.indexOf startingNote
        steps = @steps[type]
        result = [startingNote]
        for step in steps
            index += step
            result.push @notes[index]
        result

    # Convenience
    getMajor: (startingNote) ->
        @get 'major', startingNote

    getNaturalMinor: (startingNote) ->
        @get 'naturalMinor', startingNote

    getHarmonicMinor: (startingNote) ->
        @get 'harmonicMinor', startingNote

    getMelodicMinor: (startingNote) ->
        @get 'melodicMinor', startingNote


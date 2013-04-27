(function() {
  var Scales, context, keyboard, keyboardSettings, nodes,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  keyboardSettings = {
    id: 'qwerty-hancock',
    width: 800,
    height: 150,
    octaves: 3,
    startNote: 'C3',
    whiteNotesColour: 'white',
    blackNotesColour: 'rgb(59, 99, 172)',
    hoverColour: 'rgb(255, 255, 0)'
  };

  window.keyboard = keyboard = qwertyHancock(keyboardSettings);

  context = new webkitAudioContext();

  nodes = {};

  keyboard.keyDown(function(note, frequency) {
    var gainNode, oscillator;

    oscillator = context.createOscillator();
    gainNode = context.createGainNode();
    oscillator.type = 1;
    oscillator.frequency.value = frequency;
    gainNode.gain.value = 0.3;
    oscillator.connect(gainNode);
    if (typeof oscillator.noteOn !== 'undefined') {
      oscillator.noteOn(0);
    }
    gainNode.connect(context.destination);
    return nodes[note] = oscillator;
  });

  keyboard.keyUp(function(note, frequency) {
    if (typeof nodes[note].noteOff !== 'undefined') {
      nodes[note].noteOff0;
    }
    return nodes[note].disconnect();
  });

  Scales = (function() {
    Scales.prototype.notesWithSharps = ['A', 'C', 'D', 'F', 'G'];

    Scales.prototype.steps = {
      major: [2, 2, 1, 2, 2, 2, 1],
      naturalMinor: [2, 1, 2, 2, 1, 2, 2],
      harmonicMinor: [2, 1, 2, 2, 1, 3, 1],
      melodicMinor: [2, 1, 2, 2, 2, 2, 1]
    };

    function Scales(startNote, octaves) {
      this.startNote = startNote;
      this.octaves = octaves;
      this.baseNotes = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
      this.buildNotes();
    }

    Scales.prototype.buildNotes = function() {
      var baseNote, octave, octaveLoop, starting, _i, _ref, _results;

      this.notes = [];
      starting = {
        note: this.startNote[0],
        octave: parseInt(this.startNote[1], 10)
      };
      this.alignBaseNotes(starting.note);
      _results = [];
      for (octaveLoop = _i = 0, _ref = this.octaves; 0 <= _ref ? _i < _ref : _i > _ref; octaveLoop = 0 <= _ref ? ++_i : --_i) {
        octave = starting.octave + octaveLoop;
        _results.push((function() {
          var _j, _len, _ref1, _results1;

          _ref1 = this.baseNotes;
          _results1 = [];
          for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
            baseNote = _ref1[_j];
            this.notes.push(baseNote + octave);
            if (__indexOf.call(this.notesWithSharps, baseNote) >= 0) {
              _results1.push(this.notes.push(baseNote + '#' + octave));
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    Scales.prototype.alignBaseNotes = function(startingNote) {
      var beforeNote, noteIndex;

      noteIndex = this.baseNotes.indexOf(startingNote);
      beforeNote = this.baseNotes.splice(0, noteIndex);
      return this.baseNotes = this.baseNotes.concat(beforeNote);
    };

    Scales.prototype.get = function(type, startingNote) {
      var index, result, step, steps, _i, _len;

      index = this.notes.indexOf(startingNote);
      steps = this.steps[type];
      result = [startingNote];
      for (_i = 0, _len = steps.length; _i < _len; _i++) {
        step = steps[_i];
        index += step;
        result.push(this.notes[index]);
      }
      return result;
    };

    Scales.prototype.getMajor = function(startingNote) {
      return this.get('major', startingNote);
    };

    Scales.prototype.getNaturalMinor = function(startingNote) {
      return this.get('naturalMinor', startingNote);
    };

    Scales.prototype.getHarmonicMinor = function(startingNote) {
      return this.get('harmonicMinor', startingNote);
    };

    Scales.prototype.getMelodicMinor = function(startingNote) {
      return this.get('melodicMinor', startingNote);
    };

    return Scales;

  })();

  window.scales = new Scales(keyboardSettings.startNote, keyboardSettings.octaves);

}).call(this);

module.exports = (grunt) ->

    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        watch:
            coffee:
                files: ['src/scripts/coffee/*.coffee']
                tasks: ['coffee', 'concat']
        coffee:
            app:
                options:
                    join: true
                src: ['src/scripts/coffee/*.coffee']
                dest: 'src/scripts/js/scales.js'
        concat:
            options:
                banner: '// <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %>\n\n'
            dist:
                src: [
                    'src/scripts/js/underscore.js'
                    'src/scripts/js/raphael-min.js'
                    'src/scripts/js/qwerty-hancock.js'
                    'src/scripts/js/scales.js'
                ]
                dest: 'scripts.js'

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'

    grunt.registerTask 'default', ['coffee', 'concat']

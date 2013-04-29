module.exports = (grunt) ->

    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        watch:
            coffee:
                files: ['src/scripts/coffee/*.coffee']
                tasks: ['coffee', 'concat']
            sass:
                files: ['src/styles/scss/*.scss']
                tasks: ['sass']
        coffee:
            app:
                options:
                    join: true
                src: [
                    'src/scripts/coffee/scales.coffee'
                    'src/scripts/coffee/app.coffee'
                ]
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
        sass:
            app:
                files:
                    'src/styles/css/main.css': 'src/styles/scss/main.scss'

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-sass'

    grunt.registerTask 'default', ['coffee', 'concat']

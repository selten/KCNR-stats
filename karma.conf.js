module.exports = function(config) {
    config.set({
        frameworks: ['mocha', 'riot'],
        plugins: [
            'karma-mocha',
            'karma-mocha-reporter',
            'karma-phantomjs-launcher',
            'karma-riot'
        ],
        files: [
            'node_modules/expect.js/index.js',
            'static/js/tags.js',
            'test/**/*.spec.js'
        ],

        riotPreprocessor: {
            base: 'riot --template pug ./tags ./static/js/tags.js',
        },

        preprocessors: {
            'tags/**/*.tag': ['riot']
        },
        browsers: ['PhantomJS'],
        reporters: ['mocha'],
        singleRun: true
    })
}
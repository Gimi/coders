'use strict';

var gulp = require('gulp');
var gutil = require('gulp-util');
var gconcat    = require('gulp-concat');
var sourcemaps = require('gulp-sourcemaps');

var browserify = require('browserify');
var babelify   = require("babelify");
var watchify   = require('watchify');

var buffer = require('vinyl-buffer');
var source = require('vinyl-source-stream');

var assign = require('lodash.assign');
var del    = require('del');
var minifyCss = require('gulp-minify-css');

// PATH information
var paths = {
  'js':     ['./web/static/js/app.js'],
  'css':    [
    './web/static/vendor/**/*.css', './deps/**/*.css', './web/static/css/**/*.css'
  ],
  'assets': ['./web/static/assets/**/*'],
  'dist':   './priv/static'
};

// add custom browserify options here
var browserifyOpts = {
  entries: paths.js,
  paths:   ['.'],
  debug:   false // no in-file source map
};

var opts = assign({}, watchify.args, browserifyOpts);
var b = watchify(
  browserify(opts).transform(babelify)
); 
b.on('update', compileJS);
b.on('log',    gutil.log);

function compileJS() {
  return b.bundle()
    // log errors if they happen
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(source('bundle.js'))
    // optional, remove if you don't need to buffer file contents
    .pipe(buffer())
    // optional, remove if you dont want sourcemaps
    .pipe(sourcemaps.init({loadMaps: true})) // loads map from browserify file
    // Add transformation tasks to the pipeline here.
    .pipe(sourcemaps.write('./')) // writes .map file
    .pipe(gulp.dest(paths.dist + '/js'));
}

// Compile Javascript files
gulp.task('js', compileJS);

// Minify CSS files
gulp.task('css', function() {
  return gulp.src(paths.css)
    .pipe(sourcemaps.init())
    .pipe(gconcat('app.css'))
    .pipe(minifyCss())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(paths.dist + '/css'));
});

// Copy all static assets
gulp.task('assets', function() {
  return gulp.src(paths.assets)
    .pipe(gulp.dest(paths.dist));
});

// Setup watchers
gulp.task('watch', function() {
  gulp.watch(paths.assets, ['assets']);
  gulp.watch(paths.css,    ['css']);
});

// Not all tasks need to use streams
// A gulpfile is just another node program and you can use any package available on npm
gulp.task('clean', function() {
  // You can use multiple globbing patterns as you would with `gulp.src`
  return del(paths.dist);
});

gulp.task('default', ['watch'], function() {
  gulp.start('js', 'css', 'assets');
});

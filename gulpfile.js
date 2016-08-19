var gulp = require("gulp");
var gutil = require('gulp-util');
var clean = require('gulp-clean');
var watch = require('gulp-watch');

var mocha = require('gulp-mocha');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var browserify = require('browserify');
var sourcemaps = require('gulp-sourcemaps');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');

require('coffee-script/register');

gulp.task('clean', function () {
  gulp.src('lib', {read: false})
    .pipe(clean());
});

gulp.task('coffee', function () {
  return gulp.src('./src/**/*.coffee')
    .pipe(coffee({ bare: true }).on('error', gutil.log))
    .pipe(gulp.dest('./lib/'));
});

gulp.task('build', ['coffee'], function() {
    return browserify('./lib/browser')
      .bundle()
      .pipe(source('youbase.min.js'))
      .pipe(buffer())
      .pipe(sourcemaps.init({loadMaps: true}))
        .pipe(uglify())
        .on('error', gutil.log)
      .pipe(sourcemaps.write('./'))
      .pipe(gulp.dest('dist'));
});

gulp.task('test', ['coffee'], function () {
  return gulp.src('./test/**/*.coffee', { read: false })
    .pipe(mocha({ reporter: 'spec' }))
    .on('error', gutil.log);
});

gulp.task('default', ['coffee']);

gulp.task('watch-coffee', function () {
  gulp.src('./src/**/*.coffee')
    .pipe(watch('./src/**/*.coffee'))
    .pipe(coffee({ bare: true }).on('error', gutil.log))
    .pipe(gulp.dest('./lib/'));
});

gulp.task('watch-test', function () {
  gulp.watch(['test/**', 'src/**'], ['test']);
});

gulp.task('watch', ['watch-test']);

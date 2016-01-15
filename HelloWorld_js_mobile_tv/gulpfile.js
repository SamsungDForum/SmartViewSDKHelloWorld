'use strict';

var gulp        = require('gulp'),
    express     = require('express'),
    path        = require('path');

gulp.task('server', function(){
    var app = express();
    app.set('port', process.env.PORT || 3000);
    app.use(express.static(path.join(__dirname, './dist')));
    app.listen(app.get('port'), function(){
        console.log('development server listening on port ' + app.get('port'));
    });
});

gulp.task('build', function(){
    return; // currently there are no build tasks
});


gulp.task('default', ['server']);

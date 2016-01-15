$(function(){

    "use strict";

    var ui = {
        phrase : $('blockquote'),
        author : $('sub')
    };

    window.msf.local(function(err, service){

        var channel = service.channel('com.samsung.multiscreen.helloworld');

        channel.connect({name: 'TV'}, function (err) {
            if(err) return console.error(err);
        });

        channel.on('say', function(msg, from){
            ui.phrase.text(msg);
            ui.author.text('~ ' + (from.attributes.name || 'Unknown'));
        });

        channel.on('clientConnect', function(client){
            ui.phrase.text('Hello '+client.attributes.name);
            ui.author.text('~ Your TV');
        });

        channel.on('clientDisconnect', function(client){
            ui.phrase.text('Goodbye '+client.attributes.name);
            ui.author.text('~ Your TV');
        });

        channel.on('connect', function(client){
            ui.phrase.text("Eureka! ... You're connected.");
            ui.author.text('~ Your TV');
        });

        channel.on('disconnect', function(client){
            ui.phrase.text('Disconnected');
            ui.author.text('~ Your TV');
        });

    });

});


$(function () {

    "use strict";

    window.msf.logger.level = 'silly';

    var username = navigator.userAgent.match(/(opera|chrome|safari|firefox|msie)/i)[0] + ' User';
    var app;

    var ui = {
        castButton          : $('#castButton'),
        castSettings        : $('#castSettings'),
        castWindowTitle     : $('#castSettings .title'),
        castWindowDeviceList: $('#castSettings .devices'),
        castButtonDisconnect: $('#castSettings button.disconnect'),
        castButtonRescan    : $('#castSettings button.search'),
        phrase              : $('#txtName'),
        sendButton          : $('#btnSend')
    };

    var setService = function(service){

        // Since the mobile web app and tv app are hosted from the same place
        // We will use a little javascript to determine the tv app url
        var tvAppUrl = window.location.href.replace('/mobile','/tv');

        app = service.application(tvAppUrl, 'com.samsung.multiscreen.helloworld');
        app.connectionTimeout = 5000;

        app.connect({name: username}, function (err) {
            if(err) return console.error(err);
        });

        app.on('connect', function(){
            $('body').removeClass().addClass('connected');
            ui.castWindowTitle.text(service.device.name);
            ui.sendButton.prop("disabled",false);
        });

        app.on('disconnect', function(){
            $('body').removeClass().addClass('disconnected');
            ui.castWindowTitle.text('Connect to a device');
            app.removeAllListeners();
            ui.sendButton.prop("disabled",true);
        });

    };

    var init = function(){

        var search = window.msf.search();

        search.on('found', function(services){

            ui.castWindowDeviceList.empty();

            if(services.length > 0){
                $(services).each(function(index, service){
                    $('<li>').text(service.device.name).data('service',service).appendTo(ui.castWindowDeviceList);
                });
                $('body').removeClass().addClass('disconnected');
                ui.castWindowTitle.text('Connect To A Device');
            }else{
                $('<li>').text('No devices found').appendTo(ui.castWindowDeviceList);
            }
        });

        search.start();

        ui.castButton.on('click', function(){
            ui.castSettings.fadeToggle(200, 'swing');
        });

        ui.castSettings.on('click', function(evt){
            evt.stopPropagation();
            ui.castSettings.fadeOut(200, 'swing');
        });

        ui.castWindowDeviceList.on('click','li', function(evt){
            evt.stopPropagation();
            var service = $(this).data('service');
            if(service){
                setService(service);
                ui.castSettings.hide();
            }
        });

        ui.castButtonDisconnect.on('click', function(){
            if(app) app.disconnect();
            ui.castSettings.fadeToggle(200, 'swing');
        });

        ui.castButtonRescan.on('click', function(evt){
            evt.stopPropagation();
            search.start();
        });

        ui.sendButton.on('click', function(){
            var msg = ui.phrase.val();
            if(!msg) msg = 'You say it best when you say nothing at all!';
            app.publish('say', msg);
        });

        ui.phrase.on('keyup', function(evt){
            if (evt.keyCode === 13) {
                ui.sendButton.trigger('click');
            }
        });

        ui.sendButton.prop("disabled",true);

    };

    init();


});
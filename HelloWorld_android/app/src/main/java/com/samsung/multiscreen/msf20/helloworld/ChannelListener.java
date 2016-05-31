package com.samsung.multiscreen.msf20.helloworld;

import com.samsung.multiscreen.Channel.OnClientConnectListener;
import com.samsung.multiscreen.Channel.OnClientDisconnectListener;
import com.samsung.multiscreen.Channel.OnConnectListener;
import com.samsung.multiscreen.Channel.OnDisconnectListener;
import com.samsung.multiscreen.Channel.OnErrorListener;
import com.samsung.multiscreen.Channel.OnReadyListener;
import com.samsung.multiscreen.Client;
import com.samsung.multiscreen.Error;

public abstract class ChannelListener implements OnConnectListener,
        OnDisconnectListener, OnClientConnectListener,
        OnClientDisconnectListener, OnErrorListener, OnReadyListener {

    @Override
    public void onError(Error error) {
    }

    @Override
    public void onClientDisconnect(Client client) {
    }

    @Override
    public void onClientConnect(Client client) {
    }

    @Override
    public void onDisconnect(Client client) {
    }

    @Override
    public void onConnect(Client client) {
    }

    @Override
    public void onReady() {
    }
}

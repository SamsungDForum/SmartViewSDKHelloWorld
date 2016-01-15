package com.samsung.multiscreen.msf20.helloworld;

import java.net.InetAddress;
import java.util.HashMap;
import java.util.Map;

import android.net.Uri;
import android.os.CountDownTimer;
import android.util.Log;

import com.samsung.multiscreen.Application;
import com.samsung.multiscreen.Client;
import com.samsung.multiscreen.Error;
import com.samsung.multiscreen.Result;
import com.samsung.multiscreen.Search;
import com.samsung.multiscreen.Search.OnServiceFoundListener;
import com.samsung.multiscreen.Search.OnServiceLostListener;
import com.samsung.multiscreen.Service;
import com.samsung.multiscreen.msf20.sdk.ServiceWrapper;
import com.samsung.multiscreen.util.NetUtil;
import com.samsung.multiscreen.util.RunUtil;

/**
 * @author plin
 *
 * Encapsulates connection, launch and channel initialization of the Hello 
 * World TV web application.
 * 
 */
public class HelloWorldWebApplicationHelper {
    public static final String TAG = HelloWorldWebApplicationHelper.class.getName();

    private static HelloWorldWebApplicationHelper instance;
    
    private App app;
    private static Search search;
    private ServiceWrapper service = null;
    private Application msApplication;
    private SearchListener searchListener;
    
    private ServiceListAdapter serviceListAdapter;

    public static synchronized HelloWorldWebApplicationHelper getInstance(App app) {
        if (instance != null) {
            return instance;
        }
        instance = new HelloWorldWebApplicationHelper(app);
        
        return instance;
    }
    
    private HelloWorldWebApplicationHelper(App app) {
        this.app = app;
        search = Service.search(app);
        search.setOnServiceFoundListener(foundListener);
        search.setOnServiceLostListener(lostListener);
        serviceListAdapter = new ServiceListAdapter(app, android.R.layout.select_dialog_singlechoice);
    }
    
    public ServiceWrapper getService() {
        return service;
    }

    public void setService(ServiceWrapper service) {
        this.service = service;
    }

    public Application getApplication() {
        return msApplication;
    }
    
    private OnServiceFoundListener foundListener = new OnServiceFoundListener() {
        
        @Override
        public void onFound(final Service service) {
            Log.d(TAG, "Search.onFound() " + service);

            RunUtil.runOnUI(new Runnable() {

                @Override
                public void run() {
                    ServiceWrapper wrapper = new ServiceWrapper(service);
                    if (!serviceListAdapter.contains(wrapper)) {
                        serviceListAdapter.add(wrapper);
                    } else {
                        serviceListAdapter.replace(wrapper);
                    }
                    
                    searchListener.onFound(service);
                }
            });
            
        }
    };
    
    private OnServiceLostListener lostListener = new OnServiceLostListener() {
        
        @Override
        public void onLost(final Service service) {
            Log.d(TAG, "Search.onLost() " + service);

            // Remove this service from the display list
            RunUtil.runOnUI(new Runnable() {

                @Override
                public void run() {
                    ServiceWrapper wrapper = new ServiceWrapper(service);
                    serviceListAdapter.remove(wrapper);
                    
                    searchListener.onLost(service);
                }
            });
        }
    };
    
    public boolean startDiscovery(SearchListener searchListener) {
        if (!search.isSearching()) {
            if (searchListener != null) {
                this.searchListener = searchListener;
                search.setOnStartListener(searchListener);
                search.setOnStopListener(searchListener);
            }
            search.start();

            startTimer(app.getResources().getInteger(R.integer.max_discovery_wait));
            
        }
        return false;
    }
    
    public void stopDiscovery() {
        if (search != null) {
            search.stop();
        }
    }
    
    public void connectAndLaunch(ServiceWrapper wrapper, 
            Result<Client> callback, ChannelListener channelListener) {
        Log.d(TAG, "launch() is called");
        this.service = wrapper;
        Service service = wrapper.getService();
        
        Uri uri = app.getConfig().getWebAppUri();
        String channelId = app.getConfig().getHelloWorldChannel();
        msApplication = service.createApplication(uri, channelId);
        msApplication.setConnectionTimeout(5000);
        
        if (channelListener != null) {
            msApplication.setOnConnectListener(channelListener);
            msApplication.setOnDisconnectListener(channelListener);
            msApplication.setOnClientConnectListener(channelListener);
            msApplication.setOnClientDisconnectListener(channelListener);
            msApplication.setOnReadyListener(channelListener);
            msApplication.setOnErrorListener(channelListener);
        }
        // Debug
//        msApplication.setDebug(app.getConfig().isDebug());

        InetAddress inetAddr = NetUtil.getDeviceIpAddress(app);

        Map<String, String> attrs = null;
        if (inetAddr != null) {
            attrs = new HashMap<String, String>();
            attrs.put("name", inetAddr.getHostName());
        }
        msApplication.connect(attrs, callback);
    }

    public boolean isRunning() {
        return ((search != null) && search.isSearching());
    }

    public void resetChannel() {
        if (msApplication != null) {
            resetChannel(new Result<Client>() {
                
                @Override
                public void onSuccess(Client client) {
                    Log.d(TAG, "Channel.disconnect() success: " + client.toString());
                }

                @Override
                public void onError(Error error) {
                    Log.d(TAG, "Channel.disconnect() error: " + error.toString());
                }
            });
        }
    }
    
    public void resetChannel(Result<Client> callback) {
        if (msApplication != null) {
            service = null;
            msApplication.removeAllListeners();
            if (msApplication.isConnected()) {
                msApplication.disconnect(callback);
            }
            msApplication = null;
        }
    }
    
    public void cleanup() {
        if (search != null) {
            search.stop();
            clearSearchListeners();
        }
        resetChannel();
    }
    
    private void clearSearchListeners() {
        if (search != null) {
            search.setOnStartListener(null);
            search.setOnStopListener(null);
        }
    }
    
    private void startTimer(long millis) {
        new CountDownTimer(millis, 250) {

            @Override
            public void onTick(long millisUntilFinished) {
            }

            @Override
            public void onFinish() {
                Log.d(TAG, "Timer finished. Call completeScan()");
                cancel();
                stopDiscovery();
            }
        }.start();
    }

    public ServiceListAdapter getServiceListAdapter() {
        return serviceListAdapter;
    }
}

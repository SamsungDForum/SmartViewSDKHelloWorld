package com.samsung.multiscreen.msf20.helloworld;

import android.content.Context;
import android.content.res.Resources;
import android.net.Uri;

/**
 * @author plin
 *
 * Some convenience methods for getting resource config values.
 * 
 */
public class Config {

    private static Config instance = null;
    private Resources res = null;

    public static Config newInstance(Context context) {
        if (instance == null) {
            return new Config(context);
        }
        return instance;
    }

    private Config(Context context) {
        this.res = (context != null)?context.getResources():null;
    }

    public boolean isDebug() {
        return res.getBoolean(R.bool.debug);
    }
    
    public boolean getBoolean(int resId) {
        return res.getBoolean(resId);
    }
    
    public String getString(int resId) {
        return res.getString(resId);
    }

    public Uri getWebAppUri() {
        Uri uri = null;
        try {
            if (res != null) {
                boolean debug = isDebug();
                String url = getString(R.string.dev_url);
                if (!debug) {
                    url = getString(R.string.prod_url);
                }
                uri = Uri.parse(url);
            }
        } catch (Exception e) {
        }
        return uri;
    }

    public String getHelloWorldChannel() {
        String channelId = getString(R.string.channel);
        return channelId;
    }
}

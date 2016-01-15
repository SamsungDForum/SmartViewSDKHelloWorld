package com.samsung.multiscreen.msf20.helloworld;

import java.util.HashMap;
import java.util.Map;

import android.graphics.drawable.StateListDrawable;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;

/**
 * @author plin
 *
 * Manages the actionbar connect icon image view.
 * 
 */
public class ActionBarConnectIcon {

    public static final int LIGHT_THEME = 0;
    public static final int DARK_THEME = 1;
    
    private enum State {
        DISABLED_STATE(0),
        ENABLED_STATE(1),
        CONNECTING_STATE(2),
        CONNECTED_STATE(3);
        
        private final int state;
        State(int state) {
            this.state = state;
        }
        public int getValue() {
            return this.state;
        }

        private static final Map<Integer, State> intToTypeMap = new HashMap<Integer, State>();
        static {
            for (State type:State.values()) {
                intToTypeMap.put(type.getValue(), type);
            }
        }

        public static State fromInt(int i) {
            State type = intToTypeMap.get(i);
            return type;
        }
    };

    private static int[][] states = {
            new int[]{},
            new int[]{android.R.attr.state_enabled},
            new int[]{android.R.attr.state_enabled,android.R.attr.state_checkable},
            new int[]{android.R.attr.state_enabled,android.R.attr.state_checked}
    };
    
    private static final int[] themes = {
        R.drawable.mr_ic_media_route_mono_light,
        R.drawable.mr_ic_media_route_mono_dark
    };
    private View view;
    private ImageView imageView;
    private int theme = themes[0];
    private State state = State.DISABLED_STATE;
    private StateListDrawable slDrawable;
    
    public ActionBarConnectIcon(View view, int theme, 
            OnClickListener onClickListener) {
        this.view = view;
        if (view != null) {
            this.view.setOnClickListener(onClickListener);
            this.imageView = (ImageView)view.findViewById(R.id.connect_icon);
        }
        if ((theme == LIGHT_THEME) || 
                (theme == DARK_THEME)) {
            this.theme = themes[theme];
            this.slDrawable = (StateListDrawable)App.getInstance().getResources().getDrawable(this.theme);
        }
        
        setDisabled();
        
        if (this.imageView != null) {
            this.imageView.setVisibility(View.VISIBLE);
        }
    }
    
    public void setDisabled() {
        state = State.DISABLED_STATE;
        setState(states[state.getValue()]);
        makeClickable(state);
    }
    
    public void setEnabled() {
        state = State.ENABLED_STATE;
        setState(states[state.getValue()]);
        makeClickable(state);
    }
    
    public void setConnecting() {
        state = State.CONNECTING_STATE;
        setState(states[state.getValue()]);
        makeClickable(state);
    }
    
    public void setConnected() {
        state = State.CONNECTED_STATE;
        setState(states[state.getValue()]);
        makeClickable(state);
    }
    
    private void setState(int[] state) {
        if (imageView != null) { 
            slDrawable.setState(state);
            imageView.setImageDrawable(slDrawable.getCurrent());
        }
    }
    
    public void nextState() {
        state = State.fromInt((state.getValue() + 1)%states.length);
        setState(states[state.getValue()]);
    }
    
    private void makeClickable(State state) {
        switch (state) {
        case DISABLED_STATE:
            view.setClickable(false);
            view.setEnabled(false);
            break;
        case ENABLED_STATE:
            view.setClickable(true);
            view.setEnabled(true);
            break;
        case CONNECTING_STATE:
            view.setClickable(false);
            view.setEnabled(false);
            break;
        case CONNECTED_STATE:
            view.setClickable(true);
            view.setEnabled(true);
            break;
        default:
            break;
        }
    }

}

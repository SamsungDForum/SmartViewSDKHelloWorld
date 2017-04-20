package com.samsung.multiscreen.msf20.helloworld;

import java.util.Comparator;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.samsung.multiscreen.Service;
import com.samsung.multiscreen.msf20.sdk.ServiceWrapper;

/**
 * @author plin
 *
 * Adapter for displaying the services.
 * 
 */
public class ServiceListAdapter extends ArrayAdapter<ServiceWrapper> {

    private int layoutResourceId;
    private LayoutInflater mInflater;

    public ServiceListAdapter(Context context, int resource) {
        super(context, resource);
        this.layoutResourceId = resource;
        this.mInflater = LayoutInflater.from(context);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        ViewHolder viewHolder;
        
        if (convertView == null) {
            convertView = mInflater.inflate(layoutResourceId, parent, false);
            convertView.setBackgroundColor(App.getInstance().getApplicationContext().getResources().getColor(android.R.color.background_light));
            viewHolder = new ViewHolder();
            viewHolder.textView = (TextView)convertView.findViewById(android.R.id.text1);
            viewHolder.textView.setTextColor(Color.BLACK);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder)convertView.getTag();
        }

        ServiceWrapper wrapper = getItem(position);
        if (wrapper != null) {
            Service service = wrapper.getService();
            String device = "This device";
            if (service != null) {
                device = service.getName();
            }
            viewHolder.textView.setText(device);
        }

        return convertView;
    }

    public boolean contains(ServiceWrapper service) {
        return (getPosition(service) >= 0);
    }

    public void replace(ServiceWrapper service) {
        int position = getPosition(service);
        if (position >= 0) {
            remove(service);
            insert(service, position);
        }
    }
    
    public void alphaSort() {
        sort(alphaComparator);
    }
    
    private Comparator<ServiceWrapper> alphaComparator = new Comparator<ServiceWrapper>() {

        @Override
        public int compare(ServiceWrapper wrapper1, ServiceWrapper wrapper2) {
            Service s1 = wrapper1.getService(); 
            Service s2 = wrapper2.getService(); 
            return s1.getName().compareTo(s2.getName());
        }
    };
    
    private class ViewHolder {
        TextView textView;
    }
}

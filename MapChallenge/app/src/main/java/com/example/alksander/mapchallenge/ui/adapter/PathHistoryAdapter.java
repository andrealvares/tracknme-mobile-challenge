package com.example.alksander.mapchallenge.ui.adapter;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.alksander.mapchallenge.R;
import com.example.alksander.mapchallenge.models.FetchLocationsResponse;
import com.example.alksander.mapchallenge.models.Locations;

import java.util.ArrayList;
import java.util.Locale;

import butterknife.ButterKnife;
import butterknife.InjectView;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

/**
 * Created by iago on 08/07/2016.
 */
public class PathHistoryAdapter extends RecyclerView
        .Adapter<RecyclerView.ViewHolder> {

    public static final String TAG = PathHistoryAdapter.class.getSimpleName();

    private final Activity activity;
    private ArrayList<Locations> locations = new ArrayList<>();

    public PathHistoryAdapter(Activity a, FetchLocationsResponse fetchLocationsResponse) {
        activity = a;

        locations.addAll(fetchLocationsResponse.getLocationsList());

    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        //inflate your layout and pass it to view holder
        View v = LayoutInflater.from(activity).inflate(R.layout
                .item_location, parent, false);
        return new pathHistoryItemHolder(v);
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder h, final int position) {

        final pathHistoryItemHolder holder = (pathHistoryItemHolder) h;
        holder.locationDateTime.setText("Date: " + getDisplayDateTime(getDateTimeFromString(locations.get(position).getDateTime())));
        holder.locationAddress.setText(locations.get(position).getAddress());

    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public int getItemCount() {
        return locations.size();

    }

    public static class pathHistoryItemHolder extends RecyclerView.ViewHolder {

        @InjectView(R.id.location_dateTime)
        TextView locationDateTime;

        @InjectView(R.id.location_address)
        TextView locationAddress;

        public pathHistoryItemHolder(View view) {
            super(view);
            ButterKnife.inject(this, view);
        }
    }

    public static String getDisplayTime(DateTime time) {
        return time.toString("HH:mm:ss", Locale.US);
    }

    public static String getDisplayDateTime(DateTime time) {

        String timeString = time.toString("dd MMM yyyy", Locale.US);

        timeString = timeString + " " + getDisplayTime(time);

        return timeString;
    }

    public static DateTime getDateTimeFromString(String dateString) {

        DateTimeFormatter formatter = DateTimeFormat.forPattern
                ("yyyy-MM-dd'T'HH:mm:ss");
        return new DateTime(formatter.parseDateTime(dateString));
    }
}


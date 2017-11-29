package com.example.alksander.mapchallenge.ui.activities;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.LinearLayout;

import com.example.alksander.mapchallenge.R;
import com.example.alksander.mapchallenge.ui.adapter.PathHistoryAdapter;
import com.example.alksander.mapchallenge.models.FetchLocationsResponse;

import io.realm.Realm;
import io.realm.RealmQuery;

/**
 * Created by Iago Aleksander on 27/11/17.
 */

public class ListActivity extends FragmentActivity{

    LinearLayout backToMapButton;
    RecyclerView pathHistoryListView;
    PathHistoryAdapter pathHistoryAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list);

        backToMapButton = findViewById(R.id.back_to_map_button);
        pathHistoryListView = findViewById(R.id.path_history_list_view);

        final LinearLayoutManager llm = new LinearLayoutManager(this);
        pathHistoryListView.setHasFixedSize(true);
        llm.setOrientation(LinearLayoutManager.VERTICAL);
        pathHistoryListView.setLayoutManager(llm);

        // Get a Realm instance for this thread
        Realm realm = Realm.getDefaultInstance();

        // Build the query looking at all users:
        RealmQuery<FetchLocationsResponse> query = realm.where(FetchLocationsResponse.class);
        FetchLocationsResponse fetchLocationsResponse = query.findFirst();

        if (fetchLocationsResponse != null) {

            pathHistoryAdapter = new PathHistoryAdapter(this, fetchLocationsResponse);
            pathHistoryListView.setAdapter(pathHistoryAdapter);

        }

        backToMapButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
    }
}

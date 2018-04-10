package com.example.alksander.mapchallenge.backend;

import android.util.Log;

import com.example.alksander.mapchallenge.models.AddLocationResponse;
import com.example.alksander.mapchallenge.models.FetchLocationsResponse;
import com.example.alksander.mapchallenge.models.Locations;
import com.example.alksander.mapchallenge.ui.activities.MapsActivity;
import com.squareup.okhttp.OkHttpClient;

import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;


public class BackendManager {

    public static final String TAG = BackendManager.class.getSimpleName();
    public BackendAPI backendClient;
    public OkHttpClient okHttpClient1;

    public BackendManager() {

        backendClient = (BackendAPI) AdapterClientFactory.getAPIClient();
        okHttpClient1 = AdapterClientFactory.getOkHttpClient();
    }

    public void fetchPopularLocation(final MapsActivity activity) {
        backendClient.fetchLocations(
                new Callback<FetchLocationsResponse>() {
                    @Override
                    public void success(FetchLocationsResponse locations, Response response) {
                        activity.onSuccessFetchLocations(locations.getLocationsList());
                    }

                    @Override
                    public void failure(RetrofitError error) {
//                        activity.onFailure();
                        Log.d(TAG, "failure: ");
                    }
                }
        );
    }

    public void addLocation(final MapsActivity activity, final Locations location) {
        backendClient.addLocation(
                location,
                new Callback<AddLocationResponse>() {
                    @Override
                    public void success(AddLocationResponse locations, Response response) {
                        activity.onSuccessAddLocation(locations.getStatus());
                    }

                    @Override
                    public void failure(RetrofitError error) {
//                        activity.onFailure();
                        Log.d(TAG, "failure: ");
                    }
                }
        );
    }
}


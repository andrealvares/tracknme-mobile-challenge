package com.example.alksander.mapchallenge.ui.activities;

import android.content.Context;
import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.example.alksander.mapchallenge.R;
import com.example.alksander.mapchallenge.backend.BackendManager;
import com.example.alksander.mapchallenge.models.FetchLocationsResponse;
import com.example.alksander.mapchallenge.models.Locations;
import com.example.alksander.mapchallenge.utils.LatLngInterpolator;
import com.example.alksander.mapchallenge.utils.MarkerAnimation;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import io.realm.Realm;
import io.realm.RealmQuery;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback {

    BackendManager backendManager = new BackendManager();

    public GoogleMap mMap;
    Marker globalMarker;

    LinearLayout seeHistoryButton;
    Realm realm;

    ArrayList<Locations> offlineLocations = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);

        seeHistoryButton = findViewById(R.id.see_history_button);

        seeHistoryButton.setOnClickListener(new View.OnClickListener()

        {
            @Override
            public void onClick(View view) {

                Intent intent = new Intent(MapsActivity.this, ListActivity.class);
                startActivity(intent);

            }
        });

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        // Initialize Realm (just once per application)
        Realm.init(this);
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;

        backendManager.fetchPopularLocation(this);
    }

    public void onSuccessFetchLocations(List<Locations> locationsList) {

        LatLng temp = new LatLng(locationsList.get(0).getLatitude(), locationsList.get(0).getLongitude());
        mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(temp, 16));

        ArrayList<LatLng> locationList = new ArrayList<>();

        for (Locations location : locationsList) {

            LatLng newLocation = new LatLng(location.getLatitude(), location.getLongitude());
            locationList.add(newLocation);
        }

        updateMarkerPosition(locationList);

        // Get a Realm instance for this thread
        realm = Realm.getDefaultInstance();

        // Build the query looking at all users:
        RealmQuery<FetchLocationsResponse> query = realm.where(FetchLocationsResponse.class);
        FetchLocationsResponse fetchLocationsResponse = query.findFirst();

        if (fetchLocationsResponse == null) {

            new addToDatabaseTask().execute(locationsList);

        }

    }

    public void onSuccessAddLocation(String response) {

        Toast.makeText(MapsActivity.this,
                response,
                Toast.LENGTH_SHORT).show();

    }



    private void updateMarkerPosition(ArrayList<LatLng> locationList) {

        if (globalMarker == null) { // First time adding marker to map
            globalMarker = mMap.addMarker(new MarkerOptions().position(locationList.get(0)));
            MarkerAnimation.animateMarker(this, globalMarker, locationList, new LatLngInterpolator.Linear(), 0, true);
        } else {
            MarkerAnimation.animateMarker(this, globalMarker, locationList, new LatLngInterpolator.Linear(), 0, true);
        }
    }

    private class addToDatabaseTask extends AsyncTask<List<Locations>, Void, Void> {
        protected Void doInBackground(List<Locations>... locationsList) {

            // Get a Realm instance for this thread
            Realm realm = Realm.getDefaultInstance();

            try {
                realm.beginTransaction();
                FetchLocationsResponse locationList = realm.createObject(FetchLocationsResponse.class); // Create managed objects directly

                for (Locations location : locationsList[0]) {
                    Geocoder geocoder = new Geocoder(getApplicationContext(), Locale.getDefault());

                    try {
                        List<Address> listAddresses = geocoder.getFromLocation(location.getLatitude(), location.getLongitude(), 1);
                        if (null != listAddresses && listAddresses.size() > 0) {
                            location.setAddress(listAddresses.get(0).getAddressLine(0));
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }

                    // Persist your data in a transaction
                    Locations managedLocation = realm.copyToRealm(location); // Persist unmanaged objects
                    locationList.getLocationsList().add(managedLocation);
                }

                realm.commitTransaction();
            } finally {
                realm.close();
            }

            return null;
        }
    }

    public void addMapClick() {

        Toast.makeText(MapsActivity.this,
                "You can now click to set the next direction of the marker",
                Toast.LENGTH_SHORT).show();

        mMap.setOnMapClickListener(new GoogleMap.OnMapClickListener() {
            public void onMapClick(LatLng point) {
                Toast.makeText(MapsActivity.this,
                        "Latitude: " + point.latitude + ", " + "Longitude: " + point.longitude,
                        Toast.LENGTH_SHORT).show();

                LatLng temp = new LatLng(point.latitude, point.longitude);

                ArrayList<LatLng> locationList = new ArrayList<>();
                locationList.add(globalMarker.getPosition());
                locationList.add(temp);
                MarkerAnimation.animateMarker(MapsActivity.this, globalMarker, locationList, new LatLngInterpolator.Linear(), 0, false);

                Locations location = new Locations();
                location.setLatitude(point.latitude);
                location.setLongitude(point.longitude);

                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault());
                String myDate = format.format(new Date());
                location.setDateTime(myDate);

                if (isConnectedToNet(MapsActivity.this)) {
                    if (offlineLocations.isEmpty()) {
                        backendManager.addLocation(MapsActivity.this, location);
                        getAddressAndAddtoDatabase(location);
                    } else {
                        offlineLocations.add(location);
                        getOfflineAddressAndAddtoDatabase();

                    }
                } else {
                    offlineLocations.add(location);
                }
            }
        });
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        realm.close();
    }

    public static boolean isConnectedToNet(Context _context) {
        ConnectivityManager connectivityManager = (ConnectivityManager) _context.getSystemService
                (Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        return activeNetworkInfo != null && activeNetworkInfo.isConnectedOrConnecting();
    }

    public void getAddressAndAddtoDatabase(Locations location) {

        boolean locationFetched = false;

        Geocoder geocoder = new Geocoder(getApplicationContext(), Locale.getDefault());

        try {
            List<Address> listAddresses = geocoder.getFromLocation(location.getLatitude(), location.getLongitude(), 1);
            if (null != listAddresses && listAddresses.size() > 0) {
                location.setAddress(listAddresses.get(0).getAddressLine(0));
                locationFetched = true;
            }


        } catch (IOException e) {
            e.printStackTrace();
        }

        if (locationFetched) {
            // Get a Realm instance for this thread
            realm = Realm.getDefaultInstance();

            // Build the query looking at all users:
            RealmQuery<FetchLocationsResponse> query = realm.where(FetchLocationsResponse.class);
            FetchLocationsResponse fetchLocationsResponse = query.findFirst();

            if (fetchLocationsResponse != null) {

                realm.beginTransaction();

                // Persist your data in a transaction
                Locations managedLocation = realm.copyToRealm(location); // Persist unmanaged objects
                fetchLocationsResponse.getLocationsList().add(0, managedLocation);
                realm.commitTransaction();

            }
        }

    }

    public void getOfflineAddressAndAddtoDatabase() {

        boolean locationFetched = false;

        Iterator<Locations> i = offlineLocations.iterator();

        while (i.hasNext() && isConnectedToNet(MapsActivity.this)) {
            Locations location = i.next();
            backendManager.addLocation(MapsActivity.this, location);

            Geocoder geocoder = new Geocoder(getApplicationContext(), Locale.getDefault());

            try {
                List<Address> listAddresses = geocoder.getFromLocation(location.getLatitude(), location.getLongitude(), 1);
                if (null != listAddresses && listAddresses.size() > 0) {
                    location.setAddress(listAddresses.get(0).getAddressLine(0));
                    locationFetched = true;
                }


            } catch (IOException e) {
                e.printStackTrace();
                break;
            }

            if (locationFetched) {
                // Get a Realm instance for this thread
                realm = Realm.getDefaultInstance();

                // Build the query looking at all users:
                RealmQuery<FetchLocationsResponse> query = realm.where(FetchLocationsResponse.class);
                FetchLocationsResponse fetchLocationsResponse = query.findFirst();

                if (fetchLocationsResponse != null) {

                    realm.beginTransaction();

                    // Persist your data in a transaction
                    Locations managedLocation = realm.copyToRealm(location); // Persist unmanaged objects
                    fetchLocationsResponse.getLocationsList().add(0, managedLocation);
                    realm.commitTransaction();

                    i.remove();

                }
            }
        }

    }
}

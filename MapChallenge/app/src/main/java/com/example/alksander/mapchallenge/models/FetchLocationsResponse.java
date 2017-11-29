package com.example.alksander.mapchallenge.models;

import com.example.alksander.mapchallenge.models.Locations;

import io.realm.RealmList;
import io.realm.RealmObject;

public class FetchLocationsResponse extends RealmObject{

    private RealmList<Locations> locationsList;

    public RealmList<Locations> getLocationsList() {
        return locationsList;
    }

    public void setLocationsList(RealmList<Locations> locationsList) {
        this.locationsList = locationsList;
    }
}
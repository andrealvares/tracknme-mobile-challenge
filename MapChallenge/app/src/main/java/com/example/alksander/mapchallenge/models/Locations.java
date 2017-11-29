package com.example.alksander.mapchallenge.models;

import io.realm.RealmObject;

/**
 * Created by Iago Aleksander on 27/11/17.
 */

public class Locations extends RealmObject {

    private String dateTime;
    private double latitude;
    private double longitude;
    private String address;

    public String getDateTime() {
        return dateTime;
    }

    public void setDateTime(String dateTime) {
        this.dateTime = dateTime;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
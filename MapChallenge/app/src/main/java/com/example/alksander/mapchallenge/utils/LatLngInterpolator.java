/* Copyright 2013 Google Inc.
   Licensed under Apache 2.0: http://www.apache.org/licenses/LICENSE-2.0.html */

package com.example.alksander.mapchallenge.utils;

import com.google.android.gms.maps.model.LatLng;

public interface LatLngInterpolator {
    public LatLng interpolate(float fraction, LatLng a, LatLng b);

    public class Linear implements LatLngInterpolator {
        @Override
        public LatLng interpolate(float fraction, LatLng a, LatLng b) {
            double lat = (b.latitude - a.latitude) * fraction + a.latitude;
            double lng = (b.longitude - a.longitude) * fraction + a.longitude;
            return new LatLng(lat, lng);
        }
    }
}
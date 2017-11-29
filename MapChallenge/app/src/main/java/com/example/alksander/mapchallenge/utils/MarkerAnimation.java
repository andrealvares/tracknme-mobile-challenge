/* Copyright 2013 Google Inc.
   Licensed under Apache 2.0: http://www.apache.org/licenses/LICENSE-2.0.html */

package com.example.alksander.mapchallenge.utils;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.animation.TypeEvaluator;
import android.util.Property;

import com.example.alksander.mapchallenge.ui.activities.MapsActivity;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;

import java.util.ArrayList;

public class MarkerAnimation {

    public static void animateMarker(final MapsActivity activity, final Marker marker, final ArrayList<LatLng> locationList, final LatLngInterpolator latLngInterpolator, final int position, final boolean showMessage) {
        TypeEvaluator<LatLng> typeEvaluator = new TypeEvaluator<LatLng>() {
            @Override
            public LatLng evaluate(float fraction, LatLng startValue, LatLng endValue) {
                return latLngInterpolator.interpolate(fraction, startValue, endValue);
            }
        };
        final LatLng finalPosition = locationList.get(position+1);

        Property<Marker, LatLng> property = Property.of(Marker.class, LatLng.class, "position");
        ObjectAnimator animator = ObjectAnimator.ofObject(marker, property, typeEvaluator, finalPosition);
        animator.setDuration(3000);
        animator.addListener(new AnimatorListenerAdapter()
        {
            @Override
            public void onAnimationEnd(Animator animation)
            {
                if (position < locationList.size()-2) {
                    activity.mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(finalPosition, 19));
                    animateMarker(activity, marker, locationList, new LatLngInterpolator.Linear(), position + 1, showMessage);
                }
                else if (position == locationList.size()-2 && showMessage) {
                    activity.addMapClick();
                }
            }
        });
        animator.start();
    }
}
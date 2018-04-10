/*
 * Copyright 2014-2015 VistaJet Luftfahrtunternehmen GmbH and VistaJet Limited (www.vistajet.com).  All rights reserved.
 *
 * Please refer to the end user license agreement (EULA), the app developer agreement and license
 * information associated with this source code for terms and
 * conditions that govern your use of this software.
 *
 */

package com.example.alksander.mapchallenge.backend;


import com.example.alksander.mapchallenge.models.AddLocationResponse;
import com.example.alksander.mapchallenge.models.FetchLocationsResponse;
import com.example.alksander.mapchallenge.models.Locations;

import retrofit.Callback;
import retrofit.http.Body;
import retrofit.http.GET;
import retrofit.http.Headers;
import retrofit.http.POST;
import retrofit.http.Path;


public interface BackendAPI {



    /**
     * Webservice that get a session token for a user.
     */
    @GET("/locations")
    @Headers({
            "Accept: application/json",
            "Content-Type: application/json"
    })
    void fetchLocations(
            Callback<FetchLocationsResponse> callback
    );

    /**
     * Webservice that resets a user password.
     */
    @POST("/locations")
    @Headers({
            "Accept: application/json",
            "Content-Type: application/json"
    })
    void addLocation(
            @Body Locations location,
            Callback<AddLocationResponse> callback
    );

}




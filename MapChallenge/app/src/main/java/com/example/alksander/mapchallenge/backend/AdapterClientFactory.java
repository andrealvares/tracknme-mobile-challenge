package com.example.alksander.mapchallenge.backend;

import com.squareup.okhttp.OkHttpClient;

import java.util.concurrent.TimeUnit;

import retrofit.RestAdapter;
import retrofit.client.OkClient;

public class AdapterClientFactory {

    public static final long CONNECT_TIMEOUT = 60L; //
    public static final long WRITE_TIMEOUT = 60L; //
    public static final long READ_TIMEOUT = 60L; //

    public static OkHttpClient getOkHttpClient() {
        OkHttpClient okHttpClient = new OkHttpClient();
        okHttpClient.setConnectTimeout(CONNECT_TIMEOUT, TimeUnit.SECONDS);
        okHttpClient.setWriteTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS);
        okHttpClient.setReadTimeout(READ_TIMEOUT, TimeUnit.SECONDS);
        return okHttpClient;
    }

    public static Object getAPIClient() {

        RestAdapter.Builder builderJson = new RestAdapter.Builder();

        return builderJson.setEndpoint("http://private-65e372-zanardo.apiary-mock.com")
                .setClient(new OkClient(getOkHttpClient())).build().create(BackendAPI.class);
    }

}

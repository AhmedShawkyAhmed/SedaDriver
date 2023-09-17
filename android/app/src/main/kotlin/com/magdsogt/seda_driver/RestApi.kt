package com.magdsoft.seda_driver

import com.google.gson.JsonObject
import retrofit2.Call
import retrofit2.http.*

interface RestApi {
    @Headers(
        value = [
            "Accept: application/json",
            "appKey: 520",
            "Accept-Language:  en"
        ]
    )
    @POST("toggleOnline")
    fun toggleOnline(
        @Header("Authorization") auth: String,
        @Query("is_online") isOnline: Int
    ): Call<JsonObject>
}
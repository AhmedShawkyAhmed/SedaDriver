package com.magdsoft.seda_driver

import android.util.Log
import com.google.gson.JsonObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class RestApiService {
    fun toggleOnline(myToken: String) {
        val retrofit = ServiceBuilder.buildService(RestApi::class.java)
        retrofit.toggleOnline(
            auth = "Bearer $myToken",
            isOnline = 0
        ).enqueue(
            object : Callback<JsonObject> {
                override fun onFailure(call: Call<JsonObject>, t: Throwable) {
                    Log.e("onFailure", "Error message: ${t.message}")
                }
                override fun onResponse( call: Call<JsonObject>, response: Response<JsonObject>) {
                    Log.i("onResponse", "code: ${call.request().headers()}")
                    Log.i("onResponse", "code: ${response.code()}")
                    Log.i("onResponse", "body: ${response.body()}")
                }
            }
        )
    }
}
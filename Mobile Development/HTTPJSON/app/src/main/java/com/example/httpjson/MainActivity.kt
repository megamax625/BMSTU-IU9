package com.example.httpjson

import android.os.Build
import android.os.Bundle
import android.os.StrictMode
import android.os.StrictMode.ThreadPolicy
import android.widget.ListView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import org.json.JSONArray
import java.net.HttpURLConnection
import java.net.URL


class MainActivity : AppCompatActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // разрешить внешние соединения
        if (Build.VERSION.SDK_INT > 9) {
            val policy = ThreadPolicy.Builder().permitAll().build()
            StrictMode.setThreadPolicy(policy)
        }

        val url = "https://mysafeinfo.com/api/data?list=musicstyles&format=json"
        val connection = URL(url).openConnection() as HttpURLConnection
        val responseCode = connection.responseCode

        try {
            val data = connection.inputStream.bufferedReader().use { it.readText() }
            // ... do something with "data"
            // val toast = Toast.makeText(applicationContext, data, Toast.LENGTH_LONG)
            // toast.show()
            handleJson(data)

        } finally {
            connection.disconnect()
        }

    }




    private fun handleJson(jsonString: String?) {

        val jsonArray = JSONArray(jsonString)

        val list = ArrayList<MusicType>()
        var x = 0

        while (x < jsonArray.length()) {

            val jsonObject = jsonArray.getJSONObject(x)
            list.add(
                MusicType(
                    jsonObject.getString("MusicType") ,
                    jsonObject.getString("Url") ,
                    jsonObject.getString("Genre") ,
                    jsonObject.getInt("ID"),
            ))

            x++
        }

        val adapter = ListAdapte(this, list)
        val list2: ListView = findViewById(R.id.musictype_list);
        list2.setAdapter(adapter);


    }
}



package tech.mastersam.flutter_env_example

import android.os.Bundle
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Access BuildConfig values
        val appName = BuildConfig.APP_NAME

        // Print the values
        Log.d("EnvVariables", "APP_NAME: $appName")

        // Display a toast message
        Toast.makeText(this, "APP_NAME: $appName", Toast.LENGTH_LONG).show()
    }
}

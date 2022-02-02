package com.tourism.app.tourism_app

import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import com.google.firebase.ml.naturallanguage.FirebaseNaturalLanguage
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "flutter.native/helper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            if (call.method == "getLanguageCode") {

                val text : String = call.arguments()

                val languageIdentifier = FirebaseNaturalLanguage.getInstance().languageIdentification
                languageIdentifier.identifyLanguage(text)
                    .addOnSuccessListener { languageCode ->
                        if (languageCode !== "und") {
                            Log.e("AA_S", "Language: $languageCode")
                            result.success(languageCode);
                        } else {
                            Log.e("AA_S", "Can't identify language.")
                            result.success("Can't identify language.");
                        }
                    }
                    .addOnFailureListener {
                        Log.e("AA_S", "Exception")
                        result.success("Exception");
                    }
            }

        }
    }

}

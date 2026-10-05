package com.htrecipes.family_recipe_app

import android.os.Handler
import android.os.Looper
import com.tiktok.TikTokBusinessSdk
import com.tiktok.appevents.base.TTBaseEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // TikTok App Events bridge — Dart side is lib/services/tiktok_events.dart.
        // Nothing here runs unless Dart calls `init`, which it only does when a
        // TIKTOK_APP_SECRET_ANDROID dart-define was supplied at build time.
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "app.legacytable/tiktok_events",
        ).setMethodCallHandler { call, result -> handleTikTok(call, result) }
    }

    private fun handleTikTok(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                val accessToken = call.argument<String>("accessToken")
                val appId = call.argument<String>("appId")
                val ttAppId = call.argument<String>("ttAppId")
                if (accessToken.isNullOrEmpty() || appId.isNullOrEmpty() || ttAppId.isNullOrEmpty()) {
                    result.error("bad_config", "Missing TikTok config", null)
                    return
                }
                // initializeSdk() is a silent no-op the second time (e.g. after a
                // Flutter hot restart), so answer here or Dart would wait forever.
                if (TikTokBusinessSdk.isInitialized()) {
                    result.success(null)
                    return
                }
                val config = TikTokBusinessSdk.TTConfig(applicationContext, accessToken)
                    .setAppId(appId)
                    .setTTAppId(ttAppId)
                if (call.argument<Boolean>("debug") == true) {
                    config.openDebugMode()
                    config.setLogLevel(TikTokBusinessSdk.LogLevel.DEBUG)
                }
                val main = Handler(Looper.getMainLooper())
                TikTokBusinessSdk.initializeSdk(
                    config,
                    object : TikTokBusinessSdk.TTInitCallback {
                        override fun success() {
                            main.post { result.success(null) }
                        }

                        override fun fail(code: Int, msg: String?) {
                            main.post { result.error("init_failed", msg ?: "code $code", null) }
                        }
                    },
                )
            }

            "track" -> {
                val name = call.argument<String>("event")
                if (name.isNullOrEmpty()) {
                    result.error("bad_event", "Missing event name", null)
                    return
                }
                val builder = TTBaseEvent.newBuilder(name)
                call.argument<Map<String, Any?>>("properties")?.forEach { (key, value) ->
                    if (value != null) builder.addProperty(key, value)
                }
                TikTokBusinessSdk.trackTTEvent(builder.build())
                result.success(null)
            }

            "identify" -> {
                TikTokBusinessSdk.identify(call.argument<String>("externalId"), null, null, null)
                result.success(null)
            }

            "logout" -> {
                TikTokBusinessSdk.logout()
                result.success(null)
            }

            // The tracking prompt is iOS-only.
            "requestTrackingAuthorization" -> result.success(null)

            else -> result.notImplemented()
        }
    }
}

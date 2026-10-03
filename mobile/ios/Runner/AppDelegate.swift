import AppTrackingTransparency
import Flutter
import TikTokBusinessSDK
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // TikTok App Events bridge — Dart side is lib/services/tiktok_events.dart.
    let tiktokChannel = FlutterMethodChannel(
      name: "app.legacytable/tiktok_events",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    tiktokChannel.setMethodCallHandler { call, result in
      TikTokEventsBridge.handle(call, result: result)
    }
  }
}

/// Native half of the TikTok App Events integration (TikTokBusinessSDK pod).
/// Nothing here runs unless Dart calls `init`, which it only does when a
/// TIKTOK_APP_SECRET_IOS dart-define was supplied at build time.
enum TikTokEventsBridge {
  static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]

    switch call.method {
    case "init":
      guard
        let accessToken = args["accessToken"] as? String, !accessToken.isEmpty,
        let appId = args["appId"] as? String,
        let ttAppId = args["ttAppId"] as? String,
        let config = TikTokConfig(accessToken: accessToken, appId: appId, tiktokAppId: ttAppId)
      else {
        result(FlutterError(code: "bad_config", message: "Missing TikTok config", details: nil))
        return
      }
      if args["debug"] as? Bool == true {
        config.setLogLevel(TikTokLogLevelDebug)
      }
      // Until the user has answered the tracking prompt, hold the first
      // upload briefly so the install event can carry their choice.
      if #available(iOS 14, *),
        ATTrackingManager.trackingAuthorizationStatus == .notDetermined
      {
        config.setDelayForATTUserAuthorizationInSeconds(20)
      }
      TikTokBusiness.initializeSdk(config) { success, error in
        DispatchQueue.main.async {
          if success {
            result(nil)
          } else {
            result(
              FlutterError(
                code: "init_failed",
                message: error?.localizedDescription ?? "TikTok SDK init failed",
                details: nil))
          }
        }
      }

    case "requestTrackingAuthorization":
      TikTokBusiness.requestTrackingAuthorization { status in
        DispatchQueue.main.async { result(Int(status)) }
      }

    case "track":
      guard let name = args["event"] as? String, !name.isEmpty else {
        result(FlutterError(code: "bad_event", message: "Missing event name", details: nil))
        return
      }
      let event = TikTokBaseEvent(eventName: name)
      for (key, value) in args["properties"] as? [String: Any] ?? [:] {
        event.addProperty(withKey: key, value: value)
      }
      TikTokBusiness.trackTTEvent(event)
      result(nil)

    case "identify":
      TikTokBusiness.identify(
        withExternalID: args["externalId"] as? String,
        externalUserName: nil,
        phoneNumber: nil,
        email: nil)
      result(nil)

    case "logout":
      TikTokBusiness.logout()
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

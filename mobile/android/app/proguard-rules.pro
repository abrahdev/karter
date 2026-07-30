# Flutter engine and embedding
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.StatelessWidget { *; }
-keep class io.flutter.StatefulWidget { *; }

# Flutter JNI
-keep class io.flutter.FlutterInjector { *; }
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.embedding.engine.dart.DartExecutor { *; }

# Google Sign-In
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.tasks.** { *; }

# Google APIs (Drive v3)
-keep class com.google.api.services.drive.** { *; }
-keep class com.google.api.client.** { *; }
-keep class com.google.api.client.json.** { *; }
-keep class com.google.api.client.http.** { *; }

# Google API model classes (used via reflection)
-keepclassmembers class * extends com.google.api.client.json.GenericJson {
    *;
}
-keep class * extends com.google.api.client.json.GenericJson { *; }

# In-App Purchase (BillingClient)
-keep class com.android.billingclient.** { *; }
-keep class com.android.vending.billing.** { *; }

# Drift / SQLite
-keep class * extends androidx.room.** { *; }
-keep class * extends com.google.gson.TypeAdapter { *; }
-keep class * implements com.google.gson.TypeAdapterFactory { *; }
-keep class * implements com.google.gson.JsonSerializer { *; }
-keep class * implements com.google.gson.JsonDeserializer { *; }

# flutter_secure_storage
-keep class com.it_nomad.flutter_secure_storage.** { *; }
-keep class net.sqlcipher.** { *; }

# flutter_local_notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# workmanager
-keep class be.tramckrijte.workmanager.** { *; }

# share_plus
-keep class io.flutter.plugins.share.** { *; }

# image_picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# file_picker
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# path_provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# url_launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# package_info_plus
-keep class io.flutter.plugins.packageinfo.** { *; }

# sensors_plus
-keep class dev.fluttercommunity.plus.sensors.** { *; }

# Keep all native method and JNI classes
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum classes (used in serialization)
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Play Core (referenced by Flutter's deferred components — optional feature)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

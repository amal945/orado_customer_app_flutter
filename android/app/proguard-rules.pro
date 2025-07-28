# Keep all Razorpay SDK classes
-keep class com.razorpay.** { *; }

# Keep @Keep annotations (generic match to cover bad Razorpay usage)
-keep @interface **.Keep
-keepclasseswithmembers class * {
    @**.Keep *;
}
-keepclassmembers class * {
    @**.Keep *;
}

# Google Pay classes used internally by Razorpay
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }

# Keep annotations and reflection metadata
-keepattributes *Annotation*, InnerClasses, Signature

# General Android support rules
-keep class android.support.** { *; }
-keep class androidx.** { *; }
-dontwarn androidx.**

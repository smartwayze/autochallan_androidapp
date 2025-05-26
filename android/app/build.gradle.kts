plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id ("com.google.gms.google-services")
}

android {
    namespace = "com.example.challanapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.challanappp"
        minSdk = 26  // Use a direct value instead of flutter.minSdkVersion
        targetSdk = 33  // Adjust as needed
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            // Use your own signing config if needed, for now signing with debug keys
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."  // Adjust this if necessary based on your Flutter project setup
}
dependencies{
    implementation ("com.google.firebase:firebase-analytics")
}

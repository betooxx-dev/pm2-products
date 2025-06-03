plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.product_list_app"

    compileSdk = project.findProperty("flutter.compileSdkVersion")
                     ?.toString()
                     ?.toIntOrNull()
                     ?: 35  // <--- Esto asegura que el valor es Int, no Int?

    ndkVersion = "27.0.12077973"
    // --- FIN DE CAMBIOS IMPORTANTES ---

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.product_list_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
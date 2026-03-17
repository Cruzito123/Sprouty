plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")

    // ✔️ Aquí sí se aplica Google Services (sin versión)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.sprouty_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.sprouty_app"
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

dependencies {

    // ✔️ Google Sign-In
    implementation("com.google.android.gms:play-services-auth:20.7.0")

    // ✔️ Firebase BOM
    implementation(platform("com.google.firebase:firebase-bom:34.6.0"))

    // ✔️ Firebase Auth
    implementation("com.google.firebase:firebase-auth")

    // ✔️ Desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}

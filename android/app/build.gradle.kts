apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'com.google.gms.google-services' // Apply this plugin here

android {
    namespace = "com.example.taskmanager" // Pastikan ini sesuai dengan nama package aplikasi Anda
    compileSdkVersion flutter.compileSdkVersion
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.taskmanager" // Sesuaikan dengan aplikasi Anda
        minSdkVersion flutter.minSdkVersion
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutter.versionCode
        versionName flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:30.0.1') // Sesuaikan dengan versi terbaru
    implementation 'com.google.firebase:firebase-messaging' // Untuk FCM
    // Pastikan semua dependencies lainnya juga ditambahkan jika perlu
}

flutter {
    source "../.."
}

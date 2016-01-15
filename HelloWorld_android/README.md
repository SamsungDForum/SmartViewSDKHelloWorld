# Hello World - Example Application using the MultiScreen SDK Android API

This application is an example application using the MultiScreen SDK.

# Build Instructions

## Required Dependencies

The following are required dependencies for building the android-hello-world app. The target Android SDK can be changed, but the specific Android SDK should be downloaded instead.

- Android SDK (Default target SDK: 19)
- appcompat-v7
- mediarouter-v7

More information on downloading and adding Android support libraries can be found at the [Android Developer Support Library Setup](https://developer.android.com/tools/support-library/setup.html)

## Eclipse

 Before cloning or downloading the project, the required dependencies should be available. The appcompat-v7 and mediarouter-v7 can be installed via the Android SDK Manager and subsequently imported as "Existing Android Code". After import, be sure to mark the projects as Android Libraries.
 
- Clone the Hello World app and import it into Eclipse as "Existing Android Code".
- Go to the Hello World project properties and add library project references to appcompat-v7 and mediarouter-v7 under the Android tab.

The Hello World app is now ready to build and run.

## Android Studio

- Clone or download the Hello World app.
- Import the project and select the cloned location. This will create and configure default Gradle scripts.
- Go to "Module Settings" and the Dependencies tab. Add Library dependencies for com.android.support:appcompat-v7:19.1.0 and com.android.support:mediarouter-v7:19.1.0.

The Hello World app is now ready to build and run.

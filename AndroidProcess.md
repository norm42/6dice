# Android Process 

This assumes you have installed Android studio, Love2d and have a working Love2d application.      

Vscode is a recommended development environment with the love2d extension, but not essential to run your app on Android.  Love2d.org has the info on installing love2d.  The love2d extension to vscode made by pixelbytes works well.  I also found that the GitLens  extension also works well with git/github.

##### Lu/Love2d part

1. Create a zip file of the contents of the app directory.
2. Rename/name this zip file game.love

##### Android Studio

Create a virtual device emulator.  I used Pixel3, API 30 which is Android 11 x86.  These first have to be installed via the SDK manager.  This one, API30, worked. 

Create a signed key file.  build->Generate signed bundle...  Select APK.  select path.  Good to have the path in the same location as the apktools - just easer on the command line.  Enter in info that is asked for.  Note "key store path" also wants the file name.  same passwd for both key and file.  Generate only one key in the file.

##### Apktool and apksigner

1. Download the apktool from this site and follow directions listed.  The instructions say to use `targetSdkVersion` to 29 in the yml fiel.   I had to use 30.  
   android:icon="@drawable/love" in the manifest file.  Change love to the name of the icon you want to use for your app.  Note there are several versions of the png file required at different pixel dimensions in `res/drawable-{mdpi,{x,{x,{x,}}}hdpi}` (mdpi, hdpi, xhdpi, xxhdpi, and xxxhdpi). 

​		https://love2d.org/wiki/Game_Distribution/APKTool

2. You will need to setup the PATH as appropriate in windows for apktool (if .\apktool ... does not work).  Run:

​		apktool b -o your_app_name.apk love_decoded

3. Find the path to apksigner in the Android distribution.  Likely under C:\users\name\AppData\Local\Android\Sdk\build-tools\xx.xx.x where xx.xx.x is the version number of the virtual emulator you created (30.x.x) and add to PATH.  Run:

​		apksigner sign --verbose --ks mykey0.jks your_app_name.apk

4. This assumes the jks file is in the same folder.  Otherwise add the path.  apksigner will ask for a password that you used to create the jks file, so have it handy.  It does not echo the password when you enter, so you run blind here.  No issue if you are incorrect, just try again.
5. Run the emulator.  Drag/drop the apk file to the screen.   Then go to the app screen (slide up), you should see your icon that you can click on to run.
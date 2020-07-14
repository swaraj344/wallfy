package com.swaraj344.wallfy;


import android.app.WallpaperManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import java.io.IOException;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.swaraj344.wallfy/wallpaper";

    private Bitmap bitmap;
    private boolean isResized = false;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(this::onMethodCall);
    }
    private int setWallpaperFromFile(int location){
        int result = -1;
        if(isResized){
            WallpaperManager wm = null;
            wm = WallpaperManager.getInstance(getApplicationContext());
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                try {
                    result = wm.setBitmap(bitmap, null, false, location);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }else {
            Log.i("isResized", "setWallpaperFromFile: File not resized");
        }

        return result;
    }

    private int resizeImage(String filePath){
        int result = -1;
        Bitmap bitmap2 = BitmapFactory.decodeFile(filePath);
        WindowManager windowManager = (WindowManager) getApplicationContext().getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics metrics = new DisplayMetrics();
        windowManager.getDefaultDisplay().getMetrics(metrics);
        int height = metrics.heightPixels;
        int width = metrics.widthPixels;
         bitmap = Bitmap.createScaledBitmap(bitmap2,width,height,true);

        isResized = true;
        result = 1;
    return result;
    }

    private void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "resizeImage":
                result.success(resizeImage(call.argument("filePath")));
                break;
            case "setWallpaperFromFile":
                result.success(setWallpaperFromFile(call.argument("location")));
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}

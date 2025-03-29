package com.lono.scan;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.common.HybridBinarizer;

import java.lang.ref.WeakReference;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import androidx.annotation.NonNull;  // <-- Add this import statement

import static android.content.Context.VIBRATOR_SERVICE;

/** ScanPlugin */
public class ScanPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    private Activity activity;
    private FlutterPluginBinding flutterPluginBinding;
    private Result _result;
    private QrCodeAsyncTask task;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
        // Set up MethodChannel
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "lono/scan");
        channel.setMethodCallHandler(this);
    }

    private void configChannel(ActivityPluginBinding binding) {
        activity = binding.getActivity();
        flutterPluginBinding.getPlatformViewRegistry()
                .registerViewFactory("lono/scan_view", new ScanViewFactory(
                        flutterPluginBinding.getBinaryMessenger(),
                        flutterPluginBinding.getApplicationContext(),
                        activity,
                        binding
                ));
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        configChannel(binding);
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        configChannel(binding);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.flutterPluginBinding = null;
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        _result = result;
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("parse")) {
            String path = (String) call.arguments;
            task = new QrCodeAsyncTask(this, path);
            task.execute(path);
        } else {
            result.notImplemented();
        }
    }

    /**
     * AsyncTask Static inner class to prevent memory leaks
     */
    static class QrCodeAsyncTask extends AsyncTask<String, Integer, String> {
        private final WeakReference<ScanPlugin> mWeakReference;
        private final String path;

        public QrCodeAsyncTask(ScanPlugin plugin, String path) {
            mWeakReference = new WeakReference<>(plugin);
            this.path = path;
        }

        @Override
        protected String doInBackground(String... strings) {
            // QR code decoding logic here
            return QRCodeDecoder.decodeQRCode(mWeakReference.get().flutterPluginBinding.getApplicationContext(), path);
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);
            // Call the Flutter result with the decoded QR code data
            ScanPlugin plugin = mWeakReference.get();
            if (plugin != null) {
                plugin._result.success(result);

                // Handle QR code vibration feedback
                if (result != null) {
                    Vibrator vibrator = (Vibrator) plugin.flutterPluginBinding.getApplicationContext().getSystemService(VIBRATOR_SERVICE);
                    if (vibrator != null) {
                        if (Build.VERSION.SDK_INT >= 26) {
                            vibrator.vibrate(VibrationEffect.createOneShot(50, VibrationEffect.DEFAULT_AMPLITUDE));
                        } else {
                            vibrator.vibrate(50);
                        }
                    }
                }

                // Clean up
                plugin.task.cancel(true);
                plugin.task = null;
            }
        }
    }
}

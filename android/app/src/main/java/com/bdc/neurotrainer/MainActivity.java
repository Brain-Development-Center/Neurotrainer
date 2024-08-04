package com.bdc.neurotrainer;

import io.flutter.embedding.android.FlutterActivity;

import com.neurosky.connection.*;
import com.neurosky.connection.DataType.MindDataType;

import android.bluetooth.BluetoothAdapter;
import android.os.Bundle;
import android.widget.Toast;
import androidx.annotation.NonNull;
import android.os.Message;
import android.util.Log;

import android.os.Handler;
import java.util.logging.LogRecord;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String TAG = MainActivity.class.getSimpleName();
    private static final String CHANNEL = "com.bdc.neurotrainer/data";

    private TgStreamReader tgStreamReader;

    private BluetoothAdapter mBluetoothAdapter;

    int nums[] = new int[9];

    public String connectBluetooth() {
        String connect = "Bluetooth adapter is not working";
        try {
            mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            if (mBluetoothAdapter == null || !mBluetoothAdapter.isEnabled()) {
                connect = "Please enable your Bluetooth and re-run this program !";
            }
            connect = "Bluetooth adapter is working";
        } catch (Exception e) {
            connect = "Error";
        }
        tgStreamReader = new TgStreamReader(mBluetoothAdapter, callback);
        tgStreamReader.startLog();
        return connect;
    }

    public void listen() {
        if (tgStreamReader != null && tgStreamReader.isBTConnected()) {
            tgStreamReader.stop();
            tgStreamReader.close();
        }
        tgStreamReader.connect();
        Log.i(TAG, "Connected");
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("connectBluetooth")) {
                result.success(connectBluetooth());
                listen();
            } else if (call.method.equals("getNum")) {
                result.success(nums);
            }
        });
    }


    private TgStreamHandler callback = new TgStreamHandler() {

        @Override
        public void onStatesChanged(int connectionStates) {
            switch (connectionStates) {
                case ConnectionStates.STATE_CONNECTING:
                    break;
                case ConnectionStates.STATE_CONNECTED:
                    tgStreamReader.start();
                    break;
                case ConnectionStates.STATE_WORKING:
                    break;
                case ConnectionStates.STATE_GET_DATA_TIME_OUT:
                    break;
                case ConnectionStates.STATE_STOPPED:
                    break;
                case ConnectionStates.STATE_DISCONNECTED:
                    break;
                case ConnectionStates.STATE_ERROR:
                    break;
                case ConnectionStates.STATE_FAILED:
                    break;
            }
            Message msg = LinkDetectedHandler.obtainMessage();
            msg.what = MSG_UPDATE_STATE;
            msg.arg1 = connectionStates;
            LinkDetectedHandler.sendMessage(msg);
        }

        @Override
        public void onRecordFail(int flag) {
        }

        @Override
        public void onChecksumFail(byte[] payload, int length, int checksum) {

        }

        @Override
        public void onDataReceived(int datatype, int data, Object obj) {
            Message msg = LinkDetectedHandler.obtainMessage();
            msg.what = datatype;
            msg.arg1 = data;
            msg.obj = obj;
            LinkDetectedHandler.sendMessage(msg);
        }
    };


    private static final int MSG_UPDATE_BAD_PACKET = 1001;
    private static final int MSG_UPDATE_STATE = 1002;
    private Handler LinkDetectedHandler = new Handler() {

        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case MindDataType.CODE_RAW:
                    break;
                case MindDataType.CODE_MEDITATION:
                    break;
                case MindDataType.CODE_ATTENTION:
                    break;
                case MindDataType.CODE_EEGPOWER:
                    EEGPower power = (EEGPower)msg.obj;
                    if (power.isValidate()) {
                        nums[0] = power.delta;
                        nums[1] = power.theta;
                        nums[2] = power.lowAlpha;
                        nums[3] = power.highAlpha;
                        nums[4] = power.lowBeta;
                        nums[5] = power.highBeta;
                        nums[6] = power.lowGamma;
                        nums[7] = power.middleGamma;
                    }
                case MindDataType.CODE_POOR_SIGNAL:
                    break;
                case MSG_UPDATE_BAD_PACKET:
                    break;
            }
            super.handleMessage(msg);
        }
    };
}

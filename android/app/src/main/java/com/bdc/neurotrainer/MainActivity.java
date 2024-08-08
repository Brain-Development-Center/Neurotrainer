package com.bdc.neurotrainer;

import io.flutter.embedding.android.FlutterActivity;

import com.neurosky.connection.*;
import com.neurosky.connection.DataType.MindDataType;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothClass;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.os.Bundle;
import android.widget.Toast;
import androidx.annotation.NonNull;
import android.os.Message;
import android.util.Log;
import android.content.IntentFilter;
import android.content.Intent;
import android.content.Context;
import android.content.BroadcastReceiver;

import java.util.EnumMap;
import java.util.UUID;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.Map;
import java.lang.String;

import android.os.Handler;
import java.util.logging.LogRecord;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import com.neurosky.connection.DataType.MindDataType.FilterType;

import com.neurosky.connection.TgStreamReader.ParserType;


public class MainActivity extends FlutterActivity {

    private static final String TAG = MainActivity.class.getSimpleName();
    private static final String CHANNEL = "com.bdc.neurotrainer/data";

    private TgStreamReader tgStreamReader;

    private BluetoothAdapter mBluetoothAdapter;

    double nums[] = new double[10];

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

    public int connectDevice(BluetoothDevice device) {
        try {
            final UUID SPP_SERVICE_UUID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");
            BluetoothSocket socket = device.createRfcommSocketToServiceRecord(SPP_SERVICE_UUID);
            socket.connect();
            return 1;
        } catch (Exception e) {
            return -1;
        }
    }

    Map<String, String> devices = new HashMap<>();
    Map<String, BluetoothDevice> ds = new HashMap<String,BluetoothDevice>();

    public Map<String, String> getDevices() {
        return devices;
    }

    public void startScan() {
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        mBluetoothAdapter.startDiscovery();
        IntentFilter filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
        registerReceiver(receiver, filter);
    }

    public void stopScan() {
        mBluetoothAdapter.cancelDiscovery();
        unregisterReceiver(receiver);
    }

    public final BroadcastReceiver receiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (BluetoothDevice.ACTION_FOUND.equals(action)) {
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                String deviceName = device.getName();
                String deviceHardwareAddress = device.getAddress();
                if (!devices.containsKey(deviceHardwareAddress) && deviceName != null) {
                    devices.put(deviceHardwareAddress, deviceName);
                    ds.put(deviceName, device);
                }
            }
        }
    };

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("connectBluetooth")) {
                result.success(connectBluetooth());
                listen();
            } else if (call.method.equals("getNum")) {
                result.success(nums);
            } else if (call.method.equals("getDevices")) {
                result.success(getDevices());
            } else if (call.method.equals("scan")) {
                startScan();
            } else if (call.method.equals("stopScan")) {
                stopScan();
            } else if (call.method.equals("connectDevice")) {
                Object deviceName = call.arguments;
                String name = deviceName.toString().replace("[", "").replace("]", "");
                result.success(connectDevice(ds.get(name)));
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
//                    nums[9] = msg.arg1;
                    break;
                case MindDataType.CODE_ATTENTION:
//                    nums[8] = msg.arg1;
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

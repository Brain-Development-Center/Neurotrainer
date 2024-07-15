package com.bdc.neurotrainer;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import com.clj.fastble.BleManager;
import com.clj.fastble.callback.BleNotifyCallback;
import com.clj.fastble.callback.BleScanAndConnectCallback;
import com.clj.fastble.data.BleDevice;
import com.clj.fastble.exception.BleException;
import com.clj.fastble.scan.BleScanRuleConfig;
import com.macrotellect.gs5001.EEGParse;
import com.macrotellect.gs5001.callBack.OnDataCallBack;
import com.macrotellect.gs5001.callBack.OnSignCallBack;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "brainlink/data";
}

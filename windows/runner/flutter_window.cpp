#include "flutter_window.h"
#include <optional>
#include "flutter/generated_plugin_registrant.h"
#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>
#include <memory>
#include <thread>

#include "thinkgear.h"

using namespace std;

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

string connected = "No connected";
int connectionId = 0;

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  connectionId = TG_GetNewConnectionId();

  if (connectionId < 0) {
      connected = "No connected";
  }

  for (int i = 0; i < 20; i++) {
      string comPortName = "\\\\.\\COM" + to_string(i);
      cout << "Hello\n";
      int err_code = TG_Connect(connectionId, comPortName.c_str(), TG_BAUD_57600, TG_STREAM_PACKETS);
      if (err_code >= 0) {
          time_t startTime = time(NULL);
          bool find = false;
          while (difftime(time(NULL), startTime) < 3) {
              int packetsRead = TG_ReadPackets( connectionId, 1 );
              if (packetsRead == 1) {
                  find = true;
                  break;
              }
          }
          if (find) {
              connected = "Connected";
              break;
          }
      }
  }

  RECT frame = GetClientArea();

  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);

  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());

  flutter::MethodChannel<> channel(
            flutter_controller_->engine()->messenger(), "com.bdc.neurotrainer/data",
            &flutter::StandardMethodCodec::GetInstance());
  channel.SetMethodCallHandler(
            [](const flutter::MethodCall<>& call,
               std::unique_ptr<flutter::MethodResult<>> result) {
                if (call.method_name() == "connectBluetooth") {
                    result->Success(connected);
                } else if (call.method_name() == "getNum") {
                    vector<int> arr(8, 0);
                    if (connected == "Connected") {
                        while (true) {
                            int packetsRead = TG_ReadPackets( connectionId, 1 );
                            if (packetsRead == 1 ) {
                                arr[0] = (int) TG_GetValue(connectionId, TG_DATA_DELTA);
                                arr[1] = (int) TG_GetValue(connectionId, TG_DATA_THETA);
                                arr[2] = (int) TG_GetValue(connectionId, TG_DATA_ALPHA1);
                                arr[3] = (int) TG_GetValue(connectionId, TG_DATA_ALPHA2);
                                arr[4] = (int) TG_GetValue(connectionId, TG_DATA_BETA1);
                                arr[5] = (int) TG_GetValue(connectionId, TG_DATA_BETA2);
                                arr[6] = (int) TG_GetValue(connectionId, TG_DATA_GAMMA1);
                                arr[7] = (int) TG_GetValue(connectionId, TG_DATA_GAMMA2);
                                break;
                            }
                        }
                    }
                    result->Success(arr);
                }
            });


  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
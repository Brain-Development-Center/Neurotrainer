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

#include "thinkgear.h"

std::string connectBluetooth() {
    int connectionId = TG_GetNewConnectionId();
//    std::string error = "Error";
//    if (connectionId < 0) {
//        return std::string(error);
//    }
//    std::string comPortName = "\\\\.\\COM4";
//    errCode = TG_Connect(connectionId, comPortName, TG_BAUD_57600, TG_STREAM_PACKETS);
//    if (errCode < 0) {
//        return std::string(error);
//    }
//    std::string no_error = "Connected";
//    return no_error;
    return std::to_string(connectionId);
}

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
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
                    result->Success(connectBluetooth());
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

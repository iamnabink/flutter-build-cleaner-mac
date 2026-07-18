import Cocoa
import FlutterMacOS
import macos_window_utils

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let windowFrame = self.frame
    let macOSWindowUtilsViewController = MacOSWindowUtilsViewController()
    self.contentViewController = macOSWindowUtilsViewController
    self.setFrame(windowFrame, display: true)

    /* Initialize the macos_window_utils plugin */
    MainFlutterWindowManipulator.start(mainFlutterWindow: self)

    RegisterGeneratedPlugins(registry: macOSWindowUtilsViewController.flutterViewController)

    registerStorageChannel(controller: macOSWindowUtilsViewController.flutterViewController)

    super.awakeFromNib()
  }

  /// Exposes Finder-accurate storage numbers to Dart.
  ///
  /// `volumeAvailableCapacityForImportantUsage` includes purgeable space
  /// (snapshots, evictable caches) — matching what Finder/System Settings
  /// report, unlike `df` which only counts truly-free blocks.
  private func registerStorageChannel(controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: "com.broomie/storage",
      binaryMessenger: controller.engine.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "getStorageInfo" else {
        result(FlutterMethodNotImplemented)
        return
      }
      let url = URL(fileURLWithPath: "/")
      do {
        let values = try url.resourceValues(forKeys: [
          .volumeTotalCapacityKey,
          .volumeAvailableCapacityForImportantUsageKey,
        ])
        result([
          "total": Int64(values.volumeTotalCapacity ?? 0),
          "available": values.volumeAvailableCapacityForImportantUsage ?? 0,
        ])
      } catch {
        result(FlutterError(
          code: "storage_unavailable",
          message: error.localizedDescription,
          details: nil
        ))
      }
    }
  }
}

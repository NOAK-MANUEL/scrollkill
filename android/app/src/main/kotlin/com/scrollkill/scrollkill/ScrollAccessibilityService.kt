package com.scrollkill.scrollkill

import android.accessibilityservice.AccessibilityService
import android.annotation.TargetApi
import android.os.Build
import android.view.accessibility.AccessibilityEvent
import io.flutter.plugin.common.EventChannel

@TargetApi(Build.VERSION_CODES.DONUT)
class ScrollAccessibilityService : AccessibilityService() {

    companion object {
        var eventSink: EventChannel.EventSink? = null
        private var scrollCount = 0
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType == AccessibilityEvent.TYPE_VIEW_SCROLLED) {
            val packageName = event.packageName?.toString() ?: return

            scrollCount++

            // Send data to Flutter
            eventSink?.success(mapOf(
                "packageName" to packageName,
                "scrollCount" to scrollCount,
                "timestamp" to System.currentTimeMillis()
            ))
        }
    }

    override fun onInterrupt() {}

    override fun onDestroy() {
        super.onDestroy()
        eventSink = null
    }
}
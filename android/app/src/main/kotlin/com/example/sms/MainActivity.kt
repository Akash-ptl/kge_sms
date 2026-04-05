package com.example.sms

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.telephony.SmsManager
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private val TAG = MainActivity::class.java.simpleName
        const val SMS_SENT_ACTION = "com.example.sms.SMS_SENT"
    }

    private val methodChannelName = "com.example.sms"
    private var methodChannel: MethodChannel? = null
    private var result: MethodChannel.Result? = null
    private var smsSentReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)
        methodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSMS" -> {
                    Log.d(TAG, "sendSMS: Starting process")
                    val num: String? = call.argument("mobileNumber")
                    val msg: String? = call.argument("message")
                    val subscriptionId: String? = call.argument("subscriptionId")
                    this.result = result
                    sendSMS(num, msg, subscriptionId)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun sendSMS(
        phoneNo: String?,
        msg: String?,
        subscriptionId: String?
    ) {
        try {
            val subId = subscriptionId?.toIntOrNull() ?: 0
            val smsManager = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                this.getSystemService(SmsManager::class.java).createForSubscriptionId(subId)
            } else {
                @Suppress("DEPRECATION")
                SmsManager.getSmsManagerForSubscriptionId(subId)
            }
            
            val sentIntent = Intent(SMS_SENT_ACTION).apply {
                @Suppress("DEPRECATION")
                `package` = packageName
            }
            val sentPI = PendingIntent.getBroadcast(this, 0, sentIntent, PendingIntent.FLAG_IMMUTABLE)
            smsManager.sendTextMessage(phoneNo, null, msg, sentPI, null)
        } catch (ex: Exception) {
            Log.e(TAG, "Error sending SMS", ex)
            result?.error("Err", "Sms Not Sent: ${ex.message}", null)
            result = null
        }
    }

    override fun onResume() {
        super.onResume()
        smsSentReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action == SMS_SENT_ACTION) {
                    if (resultCode == RESULT_OK) {
                        result?.success("SMS Sent")
                    } else {
                        result?.error("Err", "Sms Not Sent. Result code: $resultCode", null)
                    }
                    result = null
                }
            }
        }
        val filter = IntentFilter(SMS_SENT_ACTION)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(smsSentReceiver, filter, RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(smsSentReceiver, filter)
        }
    }

    override fun onPause() {
        super.onPause()
        smsSentReceiver?.let {
            unregisterReceiver(it)
            smsSentReceiver = null
        }
    }
}
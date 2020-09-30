package com.cisco.or.utils

import android.content.Context
import android.preference.PreferenceManager.getDefaultSharedPreferencesName
import android.util.Log
import com.cisco.or.sdk.OpenRoaming
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.iid.FirebaseInstanceId
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class FirebaseMessagingService : FirebaseMessagingService() {

    var TAG: String = "FirebaseMessagingService"
    lateinit var appToken: String
    lateinit var sharedPrefs: String

    override fun onNewToken(token: String) {
        super.onNewToken(token)

        Log.d(TAG, "The token refreshed: $token")
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        Log.d(TAG, "Received message from: $remoteMessage.from")

        if (remoteMessage.data.isNotEmpty()) {
            val data = remoteMessage.data
            val profileToken = data.get("body")
            Log.d(TAG, "Message data payload: $data")
        }

        if (remoteMessage.notification != null && !remoteMessage.notification!!.body.isNullOrEmpty()) {
            OpenRoaming.handleNotification(remoteMessage.notification!!.body!!){disregardNotification: Boolean, message: String? ->
                if(!disregardNotification){
                    PushNotification.messages.add(message!!)
                }
            }
            Log.d(TAG, "Message Notification Body: " + remoteMessage.notification!!.body)
        }
    }

    fun registerPush(context: Context) {
        var sharedPrefs = getDefaultSharedPreferencesName(context)
        var pushToken = context.getSharedPreferences(sharedPrefs, Context.MODE_PRIVATE).getString(Constant.PUSH_TOKEN, null)

        if (pushToken == null) {

            FirebaseInstanceId.getInstance().instanceId.addOnCompleteListener(
                OnCompleteListener { task ->
                    if (!task.isSuccessful) {
                        Log.d(TAG, "Firebase instance failed: ", task.exception)
                    }

                    val appToken = task.result?.token

                    Log.d(TAG, "Token received: $appToken")
                    context.getSharedPreferences(sharedPrefs, Context.MODE_PRIVATE).edit().putString(Constant.PUSH_TOKEN, appToken).apply()
                })
        }
    }
}
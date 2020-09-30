package com.cisco.or.fragments

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.fragment.app.Fragment
import com.cisco.or.R
import com.cisco.or.utils.PushNotification

class LastPushNotificationFragment : Fragment() {

    companion object {
        private val TAG: String = LastPushNotificationFragment::class.java.name
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val notificationsList = loadNotificationMessagesList()

        val viewMain = inflater.inflate(R.layout.last_push_notification, container, false)
        try {
            fillPush(notificationsList, inflater, container, viewMain)
        } catch (e: Exception) {
            Log.e(TAG, Log.getStackTraceString(e))
        }

        viewMain.findViewById<Button>(R.id.backToAccount).setOnClickListener {
            fragmentManager?.popBackStack()
        }

        return viewMain
    }

    private fun fillPush(notificationsList: ArrayList<String>, inflater: LayoutInflater, container: ViewGroup?, viewMain: View){
        if(notificationsList.size > 0) {
            notificationsList.forEach { message ->
                val dataView = inflater.inflate(R.layout.push_data, container, false)
                dataView.findViewById<TextView>(R.id.pushBody).text = message
                viewMain.findViewById<LinearLayout>(R.id.pushLayout).addView(dataView)
            }
        } else {
            val dataView = inflater.inflate(R.layout.push_empty, container, false)
            viewMain.findViewById<LinearLayout>(R.id.pushLayout).addView(dataView)
        }
    }

    private fun loadNotificationMessagesList(): ArrayList<String> {
        val notificationsList: ArrayList<String> = ArrayList()
        for(i in PushNotification.messages.indices) {
            if(i >= 1) {
                notificationsList.add(PushNotification.messages[i])
            }
        }
        return notificationsList
    }
}
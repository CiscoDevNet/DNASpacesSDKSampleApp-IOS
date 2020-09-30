package com.cisco.or.fragments

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.ProgressBar
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.cisco.or.R
import com.cisco.or.sdk.OpenRoaming
import com.cisco.or.sdk.models.UsageStatistics
import com.cisco.or.utils.formattedDate
import com.cisco.or.utils.millisecondsToTime
import java.text.SimpleDateFormat

class UsageFragment : Fragment() {

    var TAG = "UsageFragment"
    var progressBar : ProgressBar? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val viewMain = inflater.inflate(R.layout.fragment_usage, container, false)
        progressBar = viewMain.findViewById(R.id.progressBar)
        try{
            OpenRoaming.getUsageStatistics { usageStatisticsData ->
                    loadFragment(usageStatisticsData, inflater, container, viewMain)
                }
            progressBar!!.visibility = View.GONE
        } catch (e: Exception) {
            Log.e(TAG, Log.getStackTraceString(e))
        }
        return viewMain
    }

    private fun fillData(usage: UsageStatistics, inflater: LayoutInflater, container: ViewGroup?, viewMain: View){
        if (usage.usageStatistics.size > 0) {
            usage!!.usageStatistics!!.forEach { stats ->
                var dataView = inflater.inflate(R.layout.usage_data, container, false)
                dataView.findViewById<TextView>(R.id.ssid)
                    .setText("@${stats.ssidDevice}")
                dataView.findViewById<TextView>(R.id.deviceused)
                    .setText(stats.deviceUsed)
                dataView.findViewById<TextView>(R.id.duration)
                    .setText(millisecondsToTime(stats.durationTime))

                var date =
                    SimpleDateFormat("yyyy-MM-dd").parse(stats.dateTime)
                dataView.findViewById<TextView>(R.id.date)
                    .setText(formattedDate(date))
                viewMain.findViewById<LinearLayout>(R.id.usageLayout).addView(dataView)
            }
        } else {
            var dataView = inflater.inflate(R.layout.usage_empty, container, false)
            viewMain.findViewById<LinearLayout>(R.id.usageLayout).addView(dataView)
        }
    }

    private fun loadFragment(usageStatistics: UsageStatistics,inflater: LayoutInflater, container: ViewGroup?, viewMain : View) {
        activity?.runOnUiThread {
            fillData(usageStatistics,inflater, container, viewMain)
        }
    }

}
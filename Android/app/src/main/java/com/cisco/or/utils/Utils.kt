package com.cisco.or.utils

import android.widget.Button
import androidx.appcompat.app.AlertDialog
import java.text.SimpleDateFormat
import java.util.*
import android.content.Context
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import com.cisco.or.R

val activity = AppCompatActivity()

fun millisecondsToTime(milliseconds: Int) : String {
    var minutes = milliseconds / 1000 / 60
    var seconds = milliseconds / 1000 % 60

    if (minutes >= 60) {
        val hour: Int = minutes / 60
        minutes %= 60
        return hour.toString() + " hr " + (if (minutes < 10) "0$minutes" else minutes) + " min" + (if (seconds < 10) "0$seconds" else seconds) + " ss"
    }
    return minutes.toString() + " min" + (if (seconds < 10) "0$seconds" else seconds) + " ss"
}

fun formattedDate(date: Date?): String? {
    val cal = Calendar.getInstance()
    cal.time = date
    val day = cal[Calendar.DATE]
    return when (day % 10) {
        1 -> SimpleDateFormat("d'st' MMM yyyy").format(date)
        2 -> SimpleDateFormat("d'nd' MMM yyyy").format(date)
        3 -> SimpleDateFormat("d'rd' MMM yyyy").format(date)
        else -> SimpleDateFormat("d'th' MMM yyyy").format(date)
    }
}

fun buttonOnClick(button: Button, context: Context) {

    button.setOnClickListener {
        AlertDialog.Builder(context)
            .setMessage(android.R.string.ok)
            .setNeutralButton(context.getText(android.R.string.ok)) { _, _ ->
                activity.finish()
            }
            .setCancelable(false)
            .show()
    }
}
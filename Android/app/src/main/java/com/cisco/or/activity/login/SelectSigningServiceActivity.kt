package com.cisco.or.activity.login

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.cisco.or.R
import com.cisco.or.activity.HomeActivity
import com.cisco.or.sdk.OpenRoaming
import com.cisco.or.sdk.enums.SigningServiceName
import com.cisco.or.sdk.enums.SigningState
import com.cisco.or.sdk.exceptions.Hotspot2NotSupportedException
import com.cisco.or.utils.Constant
import com.cisco.or.utils.FirebaseMessagingService
import kotlinx.android.synthetic.main.activity_select_signing_service.*

class SelectSigningServiceActivity : AppCompatActivity() {

    companion object {
        private val TAG = SelectSigningServiceActivity::class.java.name
    }

    private lateinit var serviceName:String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_select_signing_service)
        this.supportActionBar?.hide()

        val firebaseMessagingService = FirebaseMessagingService()
        firebaseMessagingService.registerPush(this)

        try {
            OpenRoaming.registerSdk(this, Constant.ApplicationId, Constant.dnaSpacesKey) { signingState ->
                if (signingState == SigningState.SIGNED) {
                    val intent = Intent(this, HomeActivity::class.java)
                    startActivity(intent)
                    finish()
                    Log.d(TAG, "OpenRoaming is initialized. signingState == SigningState.SIGNED")
                }
                else{
                    Log.d(TAG, "OpenRoaming is initialized. signingState == SigningState.UNSIGNED")
                }
            }
        }
        catch (e: Hotspot2NotSupportedException){
            AlertDialog.Builder(this)
                .setMessage(e.message)
                .setNeutralButton(getText(android.R.string.ok)){ _,_->
                    finish()
                }
                .setCancelable(false)
                .show()
            Log.e(TAG, e.message)
        }

        buttonGoogleSignIn.setOnClickListener {
            login(SigningServiceName.GOOGLE.value)
        }
        buttonAppleSignIn.setOnClickListener {
            login(SigningServiceName.APPLE.value)
        }
        buttonOAuthAuthentication.setOnClickListener {
            val intent = Intent(this, ServerAuthCodeAuthenticationActivity::class.java)
            startActivity(intent)
        }
        buttonLoyaltyProgram.setOnClickListener {
            val intent = Intent(this, UserIdAuthenticationActivity::class.java)
            startActivity(intent)
        }
    }

    private fun login(serviceName: String){
        this.serviceName = serviceName
        val intent = Intent(baseContext, SigningActivity::class.java)
        intent.putExtra("service", serviceName)
        startActivity(intent)
    }
}

package com.cisco.or.activity

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import androidx.appcompat.app.AppCompatActivity
import com.cisco.or.R
import com.cisco.or.activity.login.SelectSigningServiceActivity

class SplashPageActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.splash_page)
        supportActionBar?.hide()

        /*
        Sample application contains implementation example of
        Login, SignIn, and SignUp.
        To use the chosen one, you must import the correct package of each version
        in all files that use Activities(AfterSigningActivity, AgreementActivity, SelectSigningServiceActivity, SigningActivity)
        */

        Handler().postDelayed({
            val intent = Intent(this, SelectSigningServiceActivity::class.java)
            startActivity(intent)
            finish()
        }, 1000)
    }
}

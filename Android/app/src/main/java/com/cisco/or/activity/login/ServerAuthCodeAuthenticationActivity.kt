package com.cisco.or.activity.login

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.cisco.or.R
import com.cisco.or.activity.HomeActivity
import com.cisco.or.sdk.OpenRoaming
import com.cisco.or.sdk.enums.SigningServiceName
import com.cisco.or.utils.Constant
import com.google.android.gms.auth.api.signin.*
import com.google.android.gms.common.Scopes
import com.google.android.gms.common.SignInButton
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.Scope
import com.google.android.gms.tasks.Task


class ServerAuthCodeAuthenticationActivity : AppCompatActivity() {

    private lateinit var mGoogleSignInClient : GoogleSignInClient
    private var RC_SIGN_IN = 0

    companion object {
        private val TAG = ServerAuthCodeAuthenticationActivity::class.java.name

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.oauth_authentication)
        this.supportActionBar?.hide()

        val signinGoogle: SignInButton = findViewById(R.id.sign_in_button)
        signinGoogle.setSize(SignInButton.SIZE_STANDARD);
        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestScopes(Scope(Scopes.OPEN_ID))
            .requestServerAuthCode(Constant.SERVER_CLIENT_ID, true)
            .requestEmail()
            .build()
        mGoogleSignInClient = GoogleSignIn.getClient(this, gso)
        signinGoogle.setOnClickListener {
            signin()
        }
    }

    private fun signin(){
        val signInIntent: Intent = mGoogleSignInClient.getSignInIntent()
        startActivityForResult(signInIntent, RC_SIGN_IN)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RC_SIGN_IN) {
            val task = GoogleSignIn.getSignedInAccountFromIntent(data)
            handleSignInResult(task)
        }
    }

    private fun handleSignInResult(completedTask: Task<GoogleSignInAccount>) {
        try {
            val account = completedTask.getResult(ApiException::class.java)

            if(account!=null){
                associateUser(SigningServiceName.GOOGLE, account.serverAuthCode!!)
            }
        } catch (e: ApiException) {
            Log.w(TAG, "signInResult:failed code=" + e.statusCode)
        }
    }

    private fun associateUser(signingServiceName: SigningServiceName, serverAuthCode: String) {
        OpenRoaming.associateUser(serverAuthCode, signingServiceName.value, signingHandler = {
            try {
                OpenRoaming.installProfile {
                    runOnUiThread {
                        val intent = Intent(this, HomeActivity::class.java)
                        startActivity(intent)
                    }
                }
            } catch(e: Exception) {
                Log.e(TAG, Log.getStackTraceString(e))
            }
        })
    }
}
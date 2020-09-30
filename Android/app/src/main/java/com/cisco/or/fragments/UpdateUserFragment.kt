package com.cisco.or.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProviders
import com.cisco.or.R
import com.cisco.or.sdk.OpenRoaming
import com.cisco.or.sdk.models.User
import com.cisco.or.sdk.models.UserDetail
import com.cisco.or.utils.ProfileObservable
import java.util.*

class UpdateUserFragment(val userDetail: UserDetail) : Fragment() {

    companion object {
        private val TAG: String = UpdateUserFragment::class.java.name
    }

    private lateinit var viewModel: ProfileObservable

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        viewModel = activity?.run {
            ViewModelProviders.of(this).get(ProfileObservable::class.java)
        } ?: throw Exception("Invalid Activity")

        val updateUserView = inflater.inflate(R.layout.update_user, container, false)

        updateUserView.findViewById<EditText>(R.id.editTextEmail).setText(userDetail.email)
        updateUserView.findViewById<EditText>(R.id.editTextPhone).setText(userDetail.phone)
        updateUserView.findViewById<EditText>(R.id.editTextAge).setText(userDetail.age.toString())
        updateUserView.findViewById<EditText>(R.id.editTextZipCode).setText(userDetail.zipCode)

        updateUserView.findViewById<Button>(R.id.updateButton).setOnClickListener {

            val email = updateUserView.findViewById<EditText>(R.id.editTextEmail).text
            val phone = updateUserView.findViewById<EditText>(R.id.editTextPhone).text
            val age = updateUserView.findViewById<EditText>(R.id.editTextAge).text
            val zipCode = updateUserView.findViewById<EditText>(R.id.editTextZipCode).text

            val userDetailEdited = UserDetail(userDetail.name, phone.toString(), email.toString() , age.toString().toInt(), zipCode.toString())

            updateUser(userDetailEdited)
        }

        updateUserView.findViewById<Button>(R.id.cancelButton).setOnClickListener {
            fragmentManager?.popBackStack()
        }

        return updateUserView
    }

    private fun updateUser(userDetail: UserDetail) {
        OpenRoaming.updateUserDetails(userDetail){
            fragmentManager?.popBackStack()
        }
    }
}
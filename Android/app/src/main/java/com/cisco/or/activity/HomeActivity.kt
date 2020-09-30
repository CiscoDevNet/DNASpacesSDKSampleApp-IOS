package com.cisco.or.activity


import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.cisco.or.R
import com.cisco.or.fragments.IdentitiesFragment
import com.cisco.or.fragments.UsageFragment
import com.google.android.material.bottomnavigation.BottomNavigationView

class HomeActivity : AppCompatActivity() {

    private val TAG = HomeActivity::class.java.name
    private var activeFragment : Fragment? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)
        this.supportActionBar?.hide()

        val usageFragment = UsageFragment()
        val identitiesFragment = IdentitiesFragment()

        activeFragment = identitiesFragment

        supportFragmentManager.beginTransaction().add(R.id.container, usageFragment, "3").show(usageFragment).commit()
        supportFragmentManager.beginTransaction().add(R.id.container, identitiesFragment, "2").hide(identitiesFragment).commit()

        val bottomNavigationView = findViewById<BottomNavigationView>(R.id.bottom_navigation)
        bottomNavigationView.itemIconTintList = null
        bottomNavigationView.selectedItemId = R.id.usage
        bottomNavigationView.setOnNavigationItemSelectedListener { menuItem ->
            when (menuItem.itemId) {
                R.id.usage -> {
                    supportFragmentManager.beginTransaction().hide(activeFragment!!).show(usageFragment).commit()
                    activeFragment = usageFragment
                    return@setOnNavigationItemSelectedListener true
                }
                R.id.privacy -> {
                    supportFragmentManager.beginTransaction().hide(activeFragment!!).show(identitiesFragment).commit()
                    activeFragment = identitiesFragment
                    return@setOnNavigationItemSelectedListener true
                }
            }
            false
        }
    }
}

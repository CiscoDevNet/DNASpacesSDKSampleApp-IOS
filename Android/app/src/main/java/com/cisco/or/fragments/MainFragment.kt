package com.cisco.or.fragments

import android.view.View


import android.widget.*
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient


var progressBar:ProgressBar? = null



object WebViewController : WebViewClient() {
    override fun shouldOverrideUrlLoading(view: WebView, request: WebResourceRequest): Boolean {
        progressBar!!.visibility = View.VISIBLE
        return true
    }

    override fun onPageFinished(view: WebView, url: String) {
        super.onPageFinished(view, url)
        progressBar!!.visibility = View.GONE
    }
}


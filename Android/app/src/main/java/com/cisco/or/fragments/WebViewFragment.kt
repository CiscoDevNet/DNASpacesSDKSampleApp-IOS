package com.cisco.or.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.ProgressBar
import androidx.fragment.app.Fragment
import com.cisco.or.R

class WebViewFragment(private val url:String) : Fragment() {
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val view = inflater.inflate(R.layout.fragment_webview, container, false)
        val webView =  view.findViewById<WebView>(R.id.webView)
        val progressBar = view.findViewById<ProgressBar>(R.id.progressBar)
        webView.webViewClient = CustomWebViewClient(progressBar)
        webView.loadUrl(url)
        return view
    }

    class CustomWebViewClient(val progressBar: ProgressBar) : WebViewClient() {
        override fun shouldOverrideUrlLoading(view: WebView, request: WebResourceRequest): Boolean {
            progressBar.visibility = View.VISIBLE
            return true
        }

        override fun onPageFinished(view: WebView, url: String) {
            super.onPageFinished(view, url)
            progressBar.visibility = View.GONE
        }
    }
}
package com.davidtaranto.finanzas_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Color
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Widget Criptomonedas — cicla entre los assets favoritos del usuario
 * (persistidos como lista JSON en `crypto_list`). Los botones prev/next
 * avanzan el índice sin abrir la app.
 */
class CryptoWidgetProvider : HomeWidgetProvider() {

    companion object {
        const val ACTION_NEXT = "com.davidtaranto.finanzas_app.CRYPTO_NEXT"
        const val ACTION_PREV = "com.davidtaranto.finanzas_app.CRYPTO_PREV"
        private const val PREFS_NAME = "CryptoWidgetPrefs"
        private const val KEY_INDEX = "crypto_index"
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            renderWidget(context, appWidgetManager, widgetId, widgetData)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_NEXT || intent.action == ACTION_PREV) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val widgetData = context.getSharedPreferences(
                "HomeWidgetPreferences",
                Context.MODE_PRIVATE
            )
            val count = (widgetData.getString("crypto_count", "1") ?: "1").toIntOrNull() ?: 1
            val current = prefs.getInt(KEY_INDEX, 0)
            val delta = if (intent.action == ACTION_NEXT) 1 else -1
            val next = ((current + delta) % count + count) % count
            prefs.edit().putInt(KEY_INDEX, next).apply()

            val mgr = AppWidgetManager.getInstance(context)
            val ids = mgr.getAppWidgetIds(ComponentName(context, CryptoWidgetProvider::class.java))
            ids.forEach { id -> renderWidget(context, mgr, id, widgetData) }
        }
    }

    private fun renderWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int,
        widgetData: SharedPreferences
    ) {
        val views = RemoteViews(context.packageName, R.layout.crypto_widget)
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val index = prefs.getInt(KEY_INDEX, 0)

        // Pull the specific slot — Flutter stores up to 5 slots
        val symbol = widgetData.getString("crypto_symbol_$index", null)
            ?: widgetData.getString("crypto_symbol", "BTC") ?: "BTC"
        val name = widgetData.getString("crypto_name_$index", null)
            ?: widgetData.getString("crypto_name", "Bitcoin") ?: "Bitcoin"
        val price = widgetData.getString("crypto_price_$index", null)
            ?: widgetData.getString("crypto_price", "US\$0") ?: "US\$0"
        val change = widgetData.getString("crypto_change_$index", null)
            ?: widgetData.getString("crypto_change", "+0.00%") ?: "+0.00%"
        val positive = (widgetData.getString("crypto_change_positive_$index", null)
            ?: widgetData.getString("crypto_change_positive", "1")) == "1"

        views.setTextViewText(R.id.crypto_symbol, symbol)
        views.setTextViewText(R.id.crypto_name, name)
        views.setTextViewText(R.id.crypto_price, price)
        views.setTextViewText(R.id.crypto_change, change)

        val badgeRes = if (positive) R.drawable.widget_badge_positive
                       else R.drawable.widget_badge_negative
        views.setInt(R.id.crypto_change, "setBackgroundResource", badgeRes)
        views.setTextColor(R.id.crypto_change,
            if (positive) Color.parseColor("#5ECFB1") else Color.parseColor("#FF6B6B"))

        // Prev / Next buttons
        views.setOnClickPendingIntent(R.id.crypto_btn_prev, navIntent(context, ACTION_PREV, 1))
        views.setOnClickPendingIntent(R.id.crypto_btn_next, navIntent(context, ACTION_NEXT, 2))

        // Body tap → open app
        val pending = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            Uri.parse("sencillo://crypto")
        )
        views.setOnClickPendingIntent(R.id.widget_root, pending)

        appWidgetManager.updateAppWidget(widgetId, views)
    }

    private fun navIntent(context: Context, action: String, code: Int): PendingIntent {
        val intent = Intent(context, CryptoWidgetProvider::class.java).apply {
            this.action = action
        }
        return PendingIntent.getBroadcast(
            context,
            code,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}

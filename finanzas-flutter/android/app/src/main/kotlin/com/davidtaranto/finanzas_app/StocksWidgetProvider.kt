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
 * Widget Acciones — cicla entre los assets seleccionados.
 */
class StocksWidgetProvider : HomeWidgetProvider() {

    companion object {
        const val ACTION_NEXT = "com.davidtaranto.finanzas_app.STOCK_NEXT"
        const val ACTION_PREV = "com.davidtaranto.finanzas_app.STOCK_PREV"
        private const val PREFS_NAME = "StockWidgetPrefs"
        private const val KEY_INDEX = "stock_index"
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
            val count = (widgetData.getString("stock_count", "1") ?: "1").toIntOrNull() ?: 1
            val current = prefs.getInt(KEY_INDEX, 0)
            val delta = if (intent.action == ACTION_NEXT) 1 else -1
            val next = ((current + delta) % count + count) % count
            prefs.edit().putInt(KEY_INDEX, next).apply()

            val mgr = AppWidgetManager.getInstance(context)
            val ids = mgr.getAppWidgetIds(ComponentName(context, StocksWidgetProvider::class.java))
            ids.forEach { id -> renderWidget(context, mgr, id, widgetData) }
        }
    }

    private fun renderWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int,
        widgetData: SharedPreferences
    ) {
        val views = RemoteViews(context.packageName, R.layout.stocks_widget)
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val index = prefs.getInt(KEY_INDEX, 0)

        val symbol = widgetData.getString("stock_symbol_$index", null)
            ?: widgetData.getString("stock_symbol", "AAPL") ?: "AAPL"
        val name = widgetData.getString("stock_name_$index", null)
            ?: widgetData.getString("stock_name", "Apple") ?: "Apple"
        val price = widgetData.getString("stock_price_$index", null)
            ?: widgetData.getString("stock_price", "US\$0") ?: "US\$0"
        val change = widgetData.getString("stock_change_$index", null)
            ?: widgetData.getString("stock_change", "+0.00%") ?: "+0.00%"
        val positive = (widgetData.getString("stock_change_positive_$index", null)
            ?: widgetData.getString("stock_change_positive", "1")) == "1"

        views.setTextViewText(R.id.stock_symbol, symbol)
        views.setTextViewText(R.id.stock_name, name)
        views.setTextViewText(R.id.stock_price, price)
        views.setTextViewText(R.id.stock_change, change)

        val badgeRes = if (positive) R.drawable.widget_badge_positive
                       else R.drawable.widget_badge_negative
        views.setInt(R.id.stock_change, "setBackgroundResource", badgeRes)
        views.setTextColor(R.id.stock_change,
            if (positive) Color.parseColor("#5ECFB1") else Color.parseColor("#FF6B6B"))

        views.setOnClickPendingIntent(R.id.stock_btn_prev, navIntent(context, ACTION_PREV, 1))
        views.setOnClickPendingIntent(R.id.stock_btn_next, navIntent(context, ACTION_NEXT, 2))

        val pending = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            Uri.parse("sencillo://acciones")
        )
        views.setOnClickPendingIntent(R.id.widget_root, pending)

        appWidgetManager.updateAppWidget(widgetId, views)
    }

    private fun navIntent(context: Context, action: String, code: Int): PendingIntent {
        val intent = Intent(context, StocksWidgetProvider::class.java).apply {
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

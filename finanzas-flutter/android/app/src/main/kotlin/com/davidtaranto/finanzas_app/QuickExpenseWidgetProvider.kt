package com.davidtaranto.finanzas_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * 1x1 square widget: single button to quickly add an expense (voice or text).
 */
class QuickExpenseWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.quick_expense_widget)

            // Entire widget is a button → opens app to voice/manual expense
            val quickPending = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("sencillo://quick-expense")
            )
            views.setOnClickPendingIntent(R.id.widget_btn_quick, quickPending)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

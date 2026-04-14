package com.davidtaranto.finanzas_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.SizeF
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Widget Gastos — réplica del módulo "Gastos" del Home, adaptive.
 *
 * Android 12+ (API 31+): utiliza RemoteViews(Map<SizeF, RemoteViews>) para
 * servir un layout reducido cuando el usuario lo achica (por ej. 2x1) y el
 * layout completo con chips Hoy/Semana/Mes cuando queda grande (4x2).
 *
 * Android <12: usa `onAppWidgetOptionsChanged` para detectar el tamaño y
 * elegir el layout apropiado. Se actualiza automáticamente al resize.
 */
class ExpenseInfoWidgetProvider : HomeWidgetProvider() {

    companion object {
        const val ACTION_SET_PERIOD = "com.davidtaranto.finanzas_app.ACTION_SET_PERIOD"
        const val EXTRA_PERIOD = "period"
        private const val PREFS_NAME = "ExpenseInfoWidgetPrefs"
        private const val KEY_PERIOD = "expense_period"
        const val PERIOD_TODAY = "today"
        const val PERIOD_WEEK = "week"
        const val PERIOD_MONTH = "month"

        // Breakpoint: below this height (dp) we serve the compact layout.
        private const val COMPACT_HEIGHT_DP = 110f
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

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        val widgetData = context.getSharedPreferences(
            "HomeWidgetPreferences",
            Context.MODE_PRIVATE
        )
        renderWidget(context, appWidgetManager, appWidgetId, widgetData)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_SET_PERIOD) {
            val period = intent.getStringExtra(EXTRA_PERIOD) ?: PERIOD_MONTH
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit().putString(KEY_PERIOD, period).apply()

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, ExpenseInfoWidgetProvider::class.java)
            val ids = appWidgetManager.getAppWidgetIds(thisWidget)
            val widgetData = context.getSharedPreferences(
                "HomeWidgetPreferences",
                Context.MODE_PRIVATE
            )
            ids.forEach { id -> renderWidget(context, appWidgetManager, id, widgetData) }
        }
    }

    private fun renderWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int,
        widgetData: SharedPreferences
    ) {
        // Android 12+: serve a size-aware RemoteViews map so the launcher picks
        // the correct layout automatically when the user resizes.
        val finalViews = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val compact = buildViews(context, widgetData, compact = true)
            val full = buildViews(context, widgetData, compact = false)
            RemoteViews(
                mapOf(
                    SizeF(110f, 60f) to compact,
                    SizeF(180f, 110f) to full
                )
            )
        } else {
            // Older devices — pick by current width/height options
            val options = appWidgetManager.getAppWidgetOptions(widgetId)
            val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 200)
            val compact = minHeight < COMPACT_HEIGHT_DP
            buildViews(context, widgetData, compact = compact)
        }

        appWidgetManager.updateAppWidget(widgetId, finalViews)
    }

    private fun buildViews(
        context: Context,
        widgetData: SharedPreferences,
        compact: Boolean
    ): RemoteViews {
        val layoutRes = if (compact) R.layout.expense_info_widget_small
                        else R.layout.expense_info_widget
        val views = RemoteViews(context.packageName, layoutRes)

        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val period = prefs.getString(KEY_PERIOD, PERIOD_MONTH) ?: PERIOD_MONTH

        val today = widgetData.getString("expense_today", "\$0") ?: "\$0"
        val week = widgetData.getString("expense_week", "\$0") ?: "\$0"
        val month = widgetData.getString("expense_month", "\$0") ?: "\$0"
        val todayCount = widgetData.getString("expense_today_count", "0 gastos hoy") ?: "0 gastos hoy"
        val weekCount = widgetData.getString("expense_week_count", "0 gastos esta semana") ?: "0 gastos esta semana"
        val monthCount = widgetData.getString("expense_month_count", "0 gastos este mes") ?: "0 gastos este mes"

        val (amount, subtitle) = when (period) {
            PERIOD_TODAY -> today to todayCount
            PERIOD_WEEK -> week to weekCount
            else -> month to monthCount
        }

        views.setTextViewText(R.id.widget_balance, amount)
        views.setTextViewText(R.id.widget_subtitle, subtitle)

        if (!compact) {
            // Full layout only — chips exist and are wired.
            views.setInt(
                R.id.chip_today, "setBackgroundResource",
                if (period == PERIOD_TODAY) R.drawable.widget_chip_active else R.drawable.widget_chip_inactive
            )
            views.setInt(
                R.id.chip_week, "setBackgroundResource",
                if (period == PERIOD_WEEK) R.drawable.widget_chip_active else R.drawable.widget_chip_inactive
            )
            views.setInt(
                R.id.chip_month, "setBackgroundResource",
                if (period == PERIOD_MONTH) R.drawable.widget_chip_active else R.drawable.widget_chip_inactive
            )

            views.setOnClickPendingIntent(R.id.chip_today, chipPendingIntent(context, PERIOD_TODAY, 1))
            views.setOnClickPendingIntent(R.id.chip_week, chipPendingIntent(context, PERIOD_WEEK, 2))
            views.setOnClickPendingIntent(R.id.chip_month, chipPendingIntent(context, PERIOD_MONTH, 3))
        }

        val addPending = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            Uri.parse("sencillo://quick-expense")
        )
        views.setOnClickPendingIntent(R.id.widget_btn_add, addPending)

        val bodyPending = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            Uri.parse("sencillo://gastos")
        )
        views.setOnClickPendingIntent(R.id.widget_root, bodyPending)

        return views
    }

    private fun chipPendingIntent(context: Context, period: String, requestCode: Int): PendingIntent {
        val intent = Intent(context, ExpenseInfoWidgetProvider::class.java).apply {
            action = ACTION_SET_PERIOD
            putExtra(EXTRA_PERIOD, period)
        }
        return PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}

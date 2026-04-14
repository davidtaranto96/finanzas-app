package com.davidtaranto.finanzas_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Widget Cotizaciones — réplica del módulo de Cotizaciones del Home.
 * Muestra Blue destacado arriba + Oficial y Tarjeta en fila abajo.
 * Tap en cualquier parte abre la pantalla Home (que tiene el módulo completo).
 */
class DollarRateWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.dollar_rate_widget)

            val label = widgetData.getString("dollar_label", "Dólar Blue") ?: "Dólar Blue"
            val venta = widgetData.getString("dollar_venta", "\$0") ?: "\$0"
            val compra = widgetData.getString("dollar_compra", "compra \$0") ?: "compra \$0"
            val oficial = widgetData.getString("dollar_oficial", "\$0") ?: "\$0"
            val tarjeta = widgetData.getString("dollar_tarjeta", "\$0") ?: "\$0"

            views.setTextViewText(R.id.dollar_label, label)
            views.setTextViewText(R.id.dollar_venta, venta)
            views.setTextViewText(R.id.dollar_compra, compra)
            views.setTextViewText(R.id.dollar_oficial_value, oficial)
            views.setTextViewText(R.id.dollar_tarjeta_value, tarjeta)

            // Whole widget tap → home (where the full rates card lives)
            val pending = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("sencillo://cotizaciones")
            )
            views.setOnClickPendingIntent(R.id.widget_root, pending)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

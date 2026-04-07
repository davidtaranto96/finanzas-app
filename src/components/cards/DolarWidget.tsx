import React from 'react';
import { View, StyleSheet, Pressable, ActivityIndicator } from 'react-native';
import { Text, Surface } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { useDolarStore } from '@/src/stores/dolarStore';
import { colors, spacing, radius, typography } from '@/src/lib/theme';

function formatRate(n: number | undefined): string {
  if (!n) return '-';
  return `$${n.toLocaleString('es-AR', { maximumFractionDigits: 0 })}`;
}

function timeAgo(date: Date | null): string {
  if (!date) return '';
  const diff = Math.floor((Date.now() - date.getTime()) / 1000);
  if (diff < 60) return 'ahora';
  if (diff < 3600) return `hace ${Math.floor(diff / 60)} min`;
  if (diff < 86400) return `hace ${Math.floor(diff / 3600)}h`;
  return `hace ${Math.floor(diff / 86400)}d`;
}

type RateColumnProps = {
  label: string;
  compra?: number;
  venta?: number;
  color: string;
};

function RateColumn({ label, compra, venta, color }: RateColumnProps) {
  return (
    <View style={styles.rateCol}>
      <Text style={[styles.rateLabel, { color }]}>{label}</Text>
      <Text style={styles.rateVenta}>{formatRate(venta)}</Text>
      <Text style={styles.rateCompra}>C: {formatRate(compra)}</Text>
    </View>
  );
}

export function DolarWidget() {
  const { rates, lastUpdated, isLoading, error, fetch } = useDolarStore();

  const blue = rates.find((r) => r.casa === 'blue');
  const oficial = rates.find((r) => r.casa === 'oficial');
  const mep = rates.find((r) => r.casa === 'bolsa');

  return (
    <Surface style={styles.card} elevation={2}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.headerLeft}>
          <MaterialCommunityIcons name="currency-usd" size={16} color={colors.brand.primary} />
          <Text style={styles.title}>Dólar</Text>
          {lastUpdated && <Text style={styles.timestamp}>{timeAgo(lastUpdated)}</Text>}
        </View>
        <Pressable
          onPress={fetch}
          disabled={isLoading}
          style={({ pressed }) => [styles.refreshBtn, pressed && { opacity: 0.6 }]}
        >
          {isLoading ? (
            <ActivityIndicator size={14} color={colors.brand.primary} />
          ) : (
            <MaterialCommunityIcons name="refresh" size={16} color={colors.text.muted} />
          )}
        </Pressable>
      </View>

      {/* Body */}
      {error && rates.length === 0 ? (
        <Pressable onPress={fetch} style={styles.errorRow}>
          <MaterialCommunityIcons name="alert-circle-outline" size={14} color={colors.warning} />
          <Text style={styles.errorText}>No disponible · Tocar para reintentar</Text>
        </Pressable>
      ) : (
        <View style={styles.ratesRow}>
          <RateColumn label="Blue" compra={blue?.compra} venta={blue?.venta} color="#60A5FA" />
          <View style={styles.rateDivider} />
          <RateColumn label="Oficial" compra={oficial?.compra} venta={oficial?.venta} color="#34D399" />
          <View style={styles.rateDivider} />
          <RateColumn label="MEP" compra={mep?.compra} venta={mep?.venta} color="#A78BFA" />
        </View>
      )}
    </Surface>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: radius.lg,
    backgroundColor: colors.bg.card,
    padding: spacing.md,
    gap: spacing.sm,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  headerLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
  },
  title: {
    fontSize: typography.size.sm,
    fontWeight: typography.weight.semibold,
    color: colors.text.primary,
  },
  timestamp: {
    fontSize: typography.size.xs,
    color: colors.text.muted,
    marginLeft: spacing.xs,
  },
  refreshBtn: {
    width: 28,
    height: 28,
    borderRadius: radius.full,
    backgroundColor: colors.bg.elevated,
    justifyContent: 'center',
    alignItems: 'center',
  },
  ratesRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    justifyContent: 'space-between',
  },
  rateCol: {
    flex: 1,
    alignItems: 'center',
    gap: 2,
  },
  rateLabel: {
    fontSize: 10,
    fontWeight: typography.weight.bold,
    letterSpacing: 0.5,
    textTransform: 'uppercase',
  },
  rateVenta: {
    fontSize: typography.size.base,
    fontWeight: typography.weight.bold,
    color: colors.text.primary,
  },
  rateCompra: {
    fontSize: 10,
    color: colors.text.muted,
  },
  rateDivider: {
    width: 1,
    height: 36,
    backgroundColor: colors.border.subtle,
    alignSelf: 'center',
  },
  errorRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
    paddingVertical: spacing.xs,
  },
  errorText: {
    fontSize: typography.size.xs,
    color: colors.text.muted,
  },
});

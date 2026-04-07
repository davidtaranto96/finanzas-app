import React from 'react';
import { View, ScrollView, StyleSheet, Pressable, Linking } from 'react-native';
import { Text, Surface, Divider } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { colors, spacing, radius, typography } from '@/src/lib/theme';

type ChangeType = 'new' | 'improved' | 'fixed';
type Change = { type: ChangeType; text: string };
type Version = { version: string; date: string; highlight?: boolean; changes: Change[] };

const CHANGELOG: Version[] = [
  {
    version: '1.2.0',
    date: 'Abril 2026',
    highlight: true,
    changes: [
      { type: 'new', text: 'Cotización del dólar en tiempo real con auto-actualización' },
      { type: 'new', text: 'Pantalla de Novedades con historial de versiones y roadmap' },
      { type: 'new', text: 'Pantalla de Configuración con tutorial y links del proyecto' },
      { type: 'new', text: 'Sección "Apoyá el proyecto" con Cafecito y Mercado Pago' },
      { type: 'improved', text: 'Botón flotante (FAB) compartido entre todas las pantallas' },
      { type: 'improved', text: 'Transiciones animadas entre ventanas' },
      { type: 'improved', text: 'Pantalla "Más" rediseñada con resumen de balance y menú organizado' },
    ],
  },
  {
    version: '1.1.0',
    date: 'Marzo 2026',
    changes: [
      { type: 'new', text: 'Compras inteligentes con análisis anti-impulso (esperá 7 días)' },
      { type: 'new', text: 'Gastos fijos y recurrentes con recordatorios de vencimiento' },
      { type: 'new', text: 'Objetivos de ahorro con progreso visual y fecha límite' },
      { type: 'new', text: 'Ingreso inteligente de movimientos con sugerencias de IA' },
      { type: 'improved', text: 'Presupuesto con distribución del sueldo por categorías' },
    ],
  },
  {
    version: '1.0.0',
    date: 'Febrero 2026',
    changes: [
      { type: 'new', text: 'Lanzamiento inicial de la app' },
      { type: 'new', text: 'Gestión de cuentas y saldos' },
      { type: 'new', text: 'Movimientos: gastos, ingresos, transferencias y ahorros' },
      { type: 'new', text: 'Presupuesto mensual con categorías' },
      { type: 'new', text: 'Personas y seguimiento de deudas' },
    ],
  },
];

const COMING_SOON = [
  { icon: 'credit-card-multiple', text: 'Tarjetas de crédito', detail: 'Cierres, vencimientos y resúmenes automáticos' },
  { icon: 'chart-bar', text: 'Reportes y gráficos', detail: 'Análisis visual por período, categoría y cuenta' },
  { icon: 'archive-arrow-down', text: 'Cierre de mes', detail: 'Resumen automático con balance y proyección' },
  { icon: 'account-group', text: 'Gastos compartidos', detail: 'Dividí cuentas con amigos al estilo Splitwise' },
  { icon: 'bell-ring', text: 'Notificaciones', detail: 'Alertas de gastos fijos y metas de ahorro' },
  { icon: 'file-export', text: 'Exportar datos', detail: 'Descargá tus movimientos en Excel o PDF' },
];

const TYPE_CONFIG = {
  new: { icon: 'star-four-points', color: colors.brand.primary },
  improved: { icon: 'arrow-up-circle', color: colors.income },
  fixed: { icon: 'wrench', color: colors.saving },
};

function VersionBlock({ version, date, highlight, changes }: Version) {
  return (
    <Surface style={[styles.versionCard, highlight && styles.versionCardHL]} elevation={highlight ? 2 : 1}>
      {highlight && (
        <View style={styles.hlBadge}>
          <Text style={styles.hlBadgeText}>VERSIÓN ACTUAL</Text>
        </View>
      )}
      <View style={styles.versionHeader}>
        <View>
          <Text style={[styles.versionNum, highlight && { color: colors.brand.primary }]}>v{version}</Text>
          <Text style={styles.versionDate}>{date}</Text>
        </View>
        <View style={styles.countBadge}>
          <Text style={styles.countText}>{changes.length} cambios</Text>
        </View>
      </View>
      <View style={styles.changesList}>
        {changes.map((c, i) => {
          const cfg = TYPE_CONFIG[c.type];
          return (
            <View key={i} style={styles.changeRow}>
              <MaterialCommunityIcons name={cfg.icon as any} size={13} color={cfg.color} style={{ marginTop: 3 }} />
              <Text style={styles.changeText}>{c.text}</Text>
            </View>
          );
        })}
      </View>
    </Surface>
  );
}

export default function NovedadesScreen() {
  return (
    <View style={styles.root}>
      <View style={styles.header}>
        <Pressable onPress={() => router.back()} style={styles.backBtn}>
          <MaterialCommunityIcons name="arrow-left" size={24} color={colors.text.primary} />
        </Pressable>
        <View>
          <Text style={styles.title}>Novedades</Text>
          <Text style={styles.subtitle}>Historial de versiones y próximas funciones</Text>
        </View>
      </View>

      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>

        {/* Leyenda */}
        <View style={styles.legend}>
          {Object.entries(TYPE_CONFIG).map(([k, v]) => (
            <View key={k} style={styles.legendItem}>
              <MaterialCommunityIcons name={v.icon as any} size={12} color={v.color} />
              <Text style={styles.legendText}>{k === 'new' ? 'Nuevo' : k === 'improved' ? 'Mejorado' : 'Arreglado'}</Text>
            </View>
          ))}
        </View>

        {/* Versiones */}
        {CHANGELOG.map(v => <VersionBlock key={v.version} {...v} />)}

        {/* Próximamente */}
        <View style={styles.sectionHeader}>
          <MaterialCommunityIcons name="rocket-launch" size={15} color={colors.brand.primary} />
          <Text style={styles.sectionTitle}>Próximamente</Text>
        </View>
        <Surface style={styles.soonCard} elevation={1}>
          {COMING_SOON.map((item, i) => (
            <React.Fragment key={i}>
              <View style={styles.soonItem}>
                <View style={styles.soonIcon}>
                  <MaterialCommunityIcons name={item.icon as any} size={18} color={colors.brand.light} />
                </View>
                <View style={{ flex: 1, gap: 2 }}>
                  <Text style={styles.soonTitle}>{item.text}</Text>
                  <Text style={styles.soonDetail}>{item.detail}</Text>
                </View>
              </View>
              {i < COMING_SOON.length - 1 && <Divider style={styles.divider} />}
            </React.Fragment>
          ))}
        </Surface>

        {/* Autor */}
        <View style={styles.sectionHeader}>
          <MaterialCommunityIcons name="account-heart" size={15} color={colors.expense} />
          <Text style={styles.sectionTitle}>El creador</Text>
        </View>
        <Surface style={styles.authorCard} elevation={1}>
          <View style={styles.authorHeader}>
            <View style={styles.authorAvatar}>
              <Text style={styles.authorInitials}>DT</Text>
            </View>
            <View>
              <Text style={styles.authorName}>David Taranto</Text>
              <Text style={styles.authorRole}>Desarrollador de SENCILLO</Text>
            </View>
          </View>
          <Text style={styles.authorBio}>
            Desarrollé SENCILLO para llevar el control de mis finanzas de forma simple, sin complicaciones. Espero que te sea tan útil como a mí.
          </Text>
          <View style={styles.authorLinks}>
            {[
              { icon: 'github', label: 'GitHub', url: 'https://github.com/davidtaranto', color: colors.text.secondary },
              { icon: 'coffee', label: 'Cafecito', url: 'https://cafecito.app/david-t', color: '#f5a623' },
              { icon: 'alpha-m-circle', label: 'MP', url: 'https://link.mercadopago.com.ar/david.taranto', color: '#009ee3' },
            ].map((link, i) => (
              <React.Fragment key={link.label}>
                {i > 0 && <View style={styles.dot} />}
                <Pressable
                  style={({ pressed }) => [styles.authorLink, pressed && { opacity: 0.6 }]}
                  onPress={() => Linking.openURL(link.url).catch(() => {})}
                >
                  <MaterialCommunityIcons name={link.icon as any} size={15} color={link.color} />
                  <Text style={styles.authorLinkText}>{link.label}</Text>
                </Pressable>
              </React.Fragment>
            ))}
          </View>
        </Surface>

        <Text style={styles.footer}>SENCILLO · v1.2.0 · Hecho con 💜 en Argentina</Text>
        <View style={{ height: 40 }} />
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: colors.bg.primary },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
    paddingTop: 56,
    paddingHorizontal: spacing.base,
    paddingBottom: spacing.md,
  },
  backBtn: { padding: spacing.xs, marginLeft: -spacing.xs },
  title: { fontSize: typography.size['2xl'], fontWeight: typography.weight.bold, color: colors.text.primary },
  subtitle: { fontSize: typography.size.sm, color: colors.text.secondary, marginTop: 2 },
  content: { paddingHorizontal: spacing.base, gap: spacing.md, paddingBottom: spacing.base },
  legend: { flexDirection: 'row', gap: spacing.base, paddingHorizontal: spacing.xs },
  legendItem: { flexDirection: 'row', alignItems: 'center', gap: 4 },
  legendText: { fontSize: typography.size.xs, color: colors.text.muted },
  versionCard: { borderRadius: radius.xl, padding: spacing.base, backgroundColor: colors.bg.card, gap: spacing.md },
  versionCardHL: { borderWidth: 1, borderColor: colors.brand.primary + '44' },
  hlBadge: {
    alignSelf: 'flex-start',
    backgroundColor: colors.brand.primary,
    paddingHorizontal: spacing.sm, paddingVertical: 3,
    borderRadius: radius.full,
  },
  hlBadgeText: { fontSize: 10, fontWeight: typography.weight.bold, color: '#FFF', letterSpacing: 0.5 },
  versionHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start' },
  versionNum: { fontSize: typography.size.lg, fontWeight: typography.weight.bold, color: colors.text.primary },
  versionDate: { fontSize: typography.size.xs, color: colors.text.muted },
  countBadge: { backgroundColor: colors.bg.elevated, paddingHorizontal: spacing.sm, paddingVertical: 3, borderRadius: radius.full },
  countText: { fontSize: 10, color: colors.text.muted },
  changesList: { gap: spacing.sm },
  changeRow: { flexDirection: 'row', gap: spacing.sm, alignItems: 'flex-start' },
  changeText: { flex: 1, fontSize: typography.size.sm, color: colors.text.primary, lineHeight: 20 },
  sectionHeader: { flexDirection: 'row', alignItems: 'center', gap: spacing.xs, marginTop: spacing.xs },
  sectionTitle: { fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: colors.text.primary },
  soonCard: { borderRadius: radius.xl, padding: spacing.md, backgroundColor: colors.bg.card },
  soonItem: { flexDirection: 'row', alignItems: 'flex-start', gap: spacing.md, paddingVertical: spacing.sm, paddingHorizontal: spacing.xs },
  soonIcon: { width: 36, height: 36, borderRadius: radius.md, backgroundColor: colors.brand.primary + '18', justifyContent: 'center', alignItems: 'center' },
  soonTitle: { fontSize: typography.size.sm, fontWeight: typography.weight.medium, color: colors.text.primary },
  soonDetail: { fontSize: typography.size.xs, color: colors.text.muted, lineHeight: 16 },
  divider: { marginHorizontal: spacing.xs, backgroundColor: colors.border.subtle },
  authorCard: { borderRadius: radius.xl, padding: spacing.base, backgroundColor: colors.bg.card, gap: spacing.md },
  authorHeader: { flexDirection: 'row', alignItems: 'center', gap: spacing.md },
  authorAvatar: { width: 48, height: 48, borderRadius: radius.full, backgroundColor: colors.brand.primary + '33', justifyContent: 'center', alignItems: 'center' },
  authorInitials: { fontSize: typography.size.base, fontWeight: typography.weight.bold, color: colors.brand.primary },
  authorName: { fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: colors.text.primary },
  authorRole: { fontSize: typography.size.xs, color: colors.text.muted },
  authorBio: { fontSize: typography.size.sm, color: colors.text.secondary, lineHeight: 20 },
  authorLinks: { flexDirection: 'row', alignItems: 'center', gap: spacing.md },
  authorLink: { flexDirection: 'row', alignItems: 'center', gap: 4 },
  authorLinkText: { fontSize: typography.size.sm, color: colors.text.secondary },
  dot: { width: 3, height: 3, borderRadius: 2, backgroundColor: colors.text.muted },
  footer: { textAlign: 'center', fontSize: typography.size.xs, color: colors.text.muted, marginTop: spacing.sm },
});

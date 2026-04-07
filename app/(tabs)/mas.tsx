import React, { useEffect } from 'react';
import { View, ScrollView, StyleSheet, Pressable, Linking, Alert } from 'react-native';
import { Text, Surface, Divider } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useNoFab } from '@/src/hooks/useFab';
import { useAccountStore } from '@/src/stores/accountStore';
import { colors, spacing, radius, typography } from '@/src/lib/theme';
import { formatCurrency } from '@/src/lib/utils';

// ─── Tipos ───────────────────────────────────────────────────────────────────

type MenuItemData = {
  icon: string;
  iconColor: string;
  title: string;
  description: string;
  route?: string;
  onPress?: () => void;
  badge?: 'NUEVO' | 'PRONTO';
  external?: boolean;
};

// ─── Secciones del menú ──────────────────────────────────────────────────────

const MENU_SECTIONS: { title: string; items: MenuItemData[] }[] = [
  {
    title: 'Finanzas',
    items: [
      {
        icon: 'account-group',
        iconColor: colors.saving,
        title: 'Personas y deudas',
        description: 'Lo que te deben y debés',
        route: '/personas/index',
      },
      {
        icon: 'qrcode',
        iconColor: colors.brand.light,
        title: 'Amigos',
        description: 'QR, solicitudes y gastos compartidos',
        route: '/friends/index',
        badge: 'NUEVO',
      },
      {
        icon: 'cart-heart',
        iconColor: colors.investment,
        title: 'Compras inteligentes',
        description: 'Lista de deseos anti-impulso',
        route: '/compras/index',
      },
      {
        icon: 'calendar-repeat',
        iconColor: colors.warning,
        title: 'Gastos fijos',
        description: 'Recurrentes y vencimientos',
        route: '/gastos-fijos/index',
      },
    ],
  },
  {
    title: 'Análisis',
    items: [
      {
        icon: 'chart-bar',
        iconColor: colors.brand.primary,
        title: 'Reportes',
        description: 'Gráficos de tus finanzas',
        route: '/personas/index',
        badge: 'PRONTO',
      },
      {
        icon: 'credit-card-multiple',
        iconColor: colors.expense,
        title: 'Tarjetas de crédito',
        description: 'Cierres y resúmenes',
        route: '/personas/index',
        badge: 'PRONTO',
      },
      {
        icon: 'archive-arrow-down',
        iconColor: colors.transfer,
        title: 'Cierre de mes',
        description: 'Resumen mensual',
        route: '/personas/index',
        badge: 'PRONTO',
      },
    ],
  },
  {
    title: 'App',
    items: [
      {
        icon: 'play-circle-outline',
        iconColor: colors.brand.light,
        title: 'Ver tutorial',
        description: 'Recorrido de todas las funciones',
        onPress: () => router.push({ pathname: '/onboarding', params: { demo: 'true' } }),
      },
      {
        icon: 'rocket-launch',
        iconColor: colors.brand.primary,
        title: 'Novedades',
        description: 'Qué hay de nuevo',
        route: '/novedades',
        badge: 'NUEVO',
      },
      {
        icon: 'cog',
        iconColor: colors.text.muted,
        title: 'Configuración',
        description: 'Links y opciones',
        route: '/profile',
      },
    ],
  },
];

// ─── Componentes ─────────────────────────────────────────────────────────────

function BalanceSummary() {
  const { totalBalance, accounts } = useAccountStore();

  return (
    <Surface style={styles.balanceCard} elevation={2}>
      <View style={styles.balanceTop}>
        <View style={styles.balanceLeft}>
          <Text style={styles.balanceLabel}>Dinero disponible</Text>
          <Text style={styles.balanceAmount}>{formatCurrency(totalBalance)}</Text>
          {accounts.length > 0 && (
            <Text style={styles.balanceSub}>
              {accounts.length} {accounts.length === 1 ? 'cuenta' : 'cuentas'} ·{' '}
              {accounts.map(a => a.name).join(', ')}
            </Text>
          )}
        </View>
        <View style={styles.balanceIcon}>
          <MaterialCommunityIcons name="wallet" size={20} color={colors.brand.primary} />
        </View>
      </View>
    </Surface>
  );
}

function MenuItemRow({ item }: { item: MenuItemData }) {
  const handlePress = () => {
    if (item.onPress) return item.onPress();
    if (item.route) router.push(item.route as any);
  };

  return (
    <Pressable
      onPress={handlePress}
      style={({ pressed }) => [styles.menuItem, pressed && styles.menuItemPressed]}
      android_ripple={{ color: colors.brand.muted }}
    >
      <View style={[styles.menuIcon, { backgroundColor: item.iconColor + '22' }]}>
        <MaterialCommunityIcons name={item.icon as any} size={18} color={item.iconColor} />
      </View>
      <View style={styles.menuText}>
        <View style={styles.menuTitleRow}>
          <Text style={styles.menuTitle}>{item.title}</Text>
          {item.badge && (
            <View style={[styles.badge, item.badge === 'PRONTO' && styles.badgeSoon]}>
              <Text style={styles.badgeText}>{item.badge}</Text>
            </View>
          )}
        </View>
        <Text style={styles.menuDesc} numberOfLines={1}>{item.description}</Text>
      </View>
      <MaterialCommunityIcons
        name={item.external ? 'open-in-new' : 'chevron-right'}
        size={16}
        color={colors.text.muted}
      />
    </Pressable>
  );
}

function SupportSection() {
  const open = (url: string, fallback: string) => {
    Linking.openURL(url).catch(() => Alert.alert('Link', fallback));
  };

  return (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>Apoyá el proyecto</Text>
      <Surface style={styles.sectionCard} elevation={1}>
        <View style={styles.supportHeader}>
          <MaterialCommunityIcons name="heart" size={13} color={colors.expense} />
          <Text style={styles.supportText}>
            Si SENCILLO te ayuda, podés invitarme un café ☕
          </Text>
        </View>
        <Divider style={styles.divider} />
        {[
          { icon: 'alpha-m-circle', color: '#009ee3', title: 'Mercado Pago', desc: 'Alias: david.taranto', url: 'https://link.mercadopago.com.ar/david.taranto', fallback: 'Alias MP: david.taranto' },
          { icon: 'coffee', color: '#f5a623', title: 'Cafecito', desc: 'cafecito.app/david-t', url: 'https://cafecito.app/david-t', fallback: 'cafecito.app/david-t' },
          { icon: 'github', color: colors.text.secondary, title: 'GitHub', desc: 'Mirá mis proyectos', url: 'https://github.com/davidtaranto', fallback: 'github.com/davidtaranto' },
        ].map((link, i, arr) => (
          <React.Fragment key={link.title}>
            <Pressable
              style={({ pressed }) => [styles.menuItem, pressed && styles.menuItemPressed]}
              onPress={() => open(link.url, link.fallback)}
            >
              <View style={[styles.menuIcon, { backgroundColor: link.color + '22' }]}>
                <MaterialCommunityIcons name={link.icon as any} size={18} color={link.color} />
              </View>
              <View style={styles.menuText}>
                <Text style={styles.menuTitle}>{link.title}</Text>
                <Text style={styles.menuDesc}>{link.desc}</Text>
              </View>
              <MaterialCommunityIcons name="open-in-new" size={14} color={colors.text.muted} />
            </Pressable>
            {i < arr.length - 1 && <Divider style={styles.divider} />}
          </React.Fragment>
        ))}
      </Surface>
    </View>
  );
}

// ─── Pantalla principal ───────────────────────────────────────────────────────

export default function MasScreen() {
  useNoFab();
  const { load } = useAccountStore();

  useEffect(() => {
    load();
  }, []);

  return (
    <ScrollView
      style={styles.root}
      contentContainerStyle={styles.content}
      showsVerticalScrollIndicator={false}
    >
      <View style={styles.header}>
        <Text style={styles.title}>Más</Text>
      </View>

      {/* Balance rápido */}
      <BalanceSummary />

      {/* Secciones del menú */}
      {MENU_SECTIONS.map((section) => (
        <View key={section.title} style={styles.section}>
          <Text style={styles.sectionTitle}>{section.title}</Text>
          <Surface style={styles.sectionCard} elevation={1}>
            {section.items.map((item, idx) => (
              <React.Fragment key={item.title}>
                <MenuItemRow item={item} />
                {idx < section.items.length - 1 && (
                  <Divider style={styles.divider} />
                )}
              </React.Fragment>
            ))}
          </Surface>
        </View>
      ))}

      {/* Apoyo */}
      <SupportSection />

      {/* Versión */}
      <Text style={styles.version}>SENCILLO · v1.2.0</Text>
      <Text style={styles.versionSub}>Hecho con 💜 en Argentina</Text>

      <View style={{ height: 80 }} />
    </ScrollView>
  );
}

// ─── Estilos ─────────────────────────────────────────────────────────────────

const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: colors.bg.primary,
  },
  content: {
    paddingTop: 56,
    paddingHorizontal: spacing.base,
    gap: spacing.sm,
  },
  header: {
    marginBottom: spacing.xs,
  },
  title: {
    fontSize: typography.size['2xl'],
    fontWeight: typography.weight.bold,
    color: colors.text.primary,
  },

  // Balance card — más compacto
  balanceCard: {
    borderRadius: radius.lg,
    backgroundColor: colors.bg.card,
    padding: spacing.md,
    borderWidth: 1,
    borderColor: colors.brand.primary + '22',
  },
  balanceTop: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    justifyContent: 'space-between',
  },
  balanceLeft: { gap: 2 },
  balanceIcon: {
    width: 36,
    height: 36,
    borderRadius: radius.md,
    backgroundColor: colors.brand.muted,
    justifyContent: 'center',
    alignItems: 'center',
  },
  balanceLabel: {
    fontSize: 10,
    color: colors.text.muted,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  balanceAmount: {
    fontSize: typography.size.xl,
    fontWeight: typography.weight.bold,
    color: colors.text.primary,
  },
  balanceSub: {
    fontSize: 10,
    color: colors.text.muted,
  },

  // Sections
  section: { gap: spacing.xs },
  sectionTitle: {
    fontSize: 10,
    fontWeight: typography.weight.semibold,
    color: colors.text.muted,
    textTransform: 'uppercase',
    letterSpacing: 0.8,
    paddingHorizontal: spacing.xs,
  },
  sectionCard: {
    borderRadius: radius.lg,
    backgroundColor: colors.bg.card,
    overflow: 'hidden',
  },

  // Menu items — más compactos
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    paddingVertical: spacing.sm,
    paddingHorizontal: spacing.md,
  },
  menuItemPressed: { backgroundColor: colors.brand.muted },
  menuIcon: {
    width: 36, height: 36, borderRadius: radius.sm,
    justifyContent: 'center', alignItems: 'center',
  },
  menuText: { flex: 1, gap: 1 },
  menuTitleRow: { flexDirection: 'row', alignItems: 'center', gap: spacing.xs },
  menuTitle: {
    fontSize: typography.size.sm,
    fontWeight: typography.weight.medium,
    color: colors.text.primary,
  },
  menuDesc: { fontSize: 11, color: colors.text.muted },
  badge: {
    backgroundColor: colors.brand.primary,
    paddingHorizontal: 5, paddingVertical: 1,
    borderRadius: radius.full,
  },
  badgeSoon: { backgroundColor: colors.text.muted },
  badgeText: {
    fontSize: 8, fontWeight: typography.weight.bold,
    color: '#FFFFFF', letterSpacing: 0.3,
  },
  divider: { marginHorizontal: spacing.md, backgroundColor: colors.border.subtle },

  // Support
  supportHeader: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: spacing.xs,
    paddingHorizontal: spacing.md,
    paddingTop: spacing.sm,
    paddingBottom: spacing.xs,
  },
  supportText: {
    flex: 1,
    fontSize: 11,
    color: colors.text.secondary,
    lineHeight: 16,
  },

  // Version
  version: {
    textAlign: 'center',
    fontSize: 10,
    color: colors.text.muted,
    marginTop: spacing.xs,
  },
  versionSub: {
    textAlign: 'center',
    fontSize: 10,
    color: colors.text.muted,
    marginTop: 1,
  },
});

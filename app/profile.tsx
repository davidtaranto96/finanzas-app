import React, { useEffect, useState } from 'react';
import { View, ScrollView, StyleSheet, Pressable, Linking, Alert } from 'react-native';
import { Text, Surface, Divider, ActivityIndicator } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useAuthStore } from '@/src/stores/authStore';
import { uploadBackup, getLastBackupDate } from '@/src/services/backupService';
import { colors, spacing, radius, typography } from '@/src/lib/theme';

type SettingRow = {
  icon: string;
  iconColor: string;
  title: string;
  subtitle: string;
  onPress: () => void;
  chevron?: boolean;
};

function SettingItem({ icon, iconColor, title, subtitle, onPress, chevron = true }: SettingRow) {
  return (
    <Pressable
      onPress={onPress}
      style={({ pressed }) => [styles.row, pressed && styles.rowPressed]}
      android_ripple={{ color: colors.brand.muted }}
    >
      <View style={[styles.rowIcon, { backgroundColor: iconColor + '22' }]}>
        <MaterialCommunityIcons name={icon as any} size={18} color={iconColor} />
      </View>
      <View style={styles.rowText}>
        <Text style={styles.rowTitle}>{title}</Text>
        <Text style={styles.rowSub}>{subtitle}</Text>
      </View>
      {chevron && <MaterialCommunityIcons name="chevron-right" size={18} color={colors.text.muted} />}
    </Pressable>
  );
}

export default function ProfileScreen() {
  const { user, profile, isAuthenticated, signOut } = useAuthStore();
  const [lastBackup, setLastBackup] = useState<string | null>(null);
  const [backingUp, setBackingUp] = useState(false);

  useEffect(() => {
    if (user) {
      getLastBackupDate(user.uid).then((date) => {
        if (date) {
          setLastBackup(date.toLocaleDateString('es-AR', { day: 'numeric', month: 'short', year: 'numeric' }));
        }
      }).catch(() => {});
    }
  }, [user]);

  const handleBackup = async () => {
    if (!user) return;
    setBackingUp(true);
    try {
      await uploadBackup(user.uid);
      const now = new Date().toLocaleDateString('es-AR', { day: 'numeric', month: 'short', year: 'numeric' });
      setLastBackup(now);
      Alert.alert('Backup completo', 'Tu base de datos se guardó en la nube');
    } catch (e: any) {
      Alert.alert('Error', e.message || 'No se pudo hacer el backup');
    } finally {
      setBackingUp(false);
    }
  };

  const handleSignOut = () => {
    Alert.alert('Cerrar sesión', '¿Estás seguro?', [
      { text: 'Cancelar', style: 'cancel' },
      { text: 'Cerrar sesión', style: 'destructive', onPress: () => signOut() },
    ]);
  };

  return (
    <View style={styles.root}>
      <View style={styles.header}>
        <Pressable onPress={() => router.back()} style={styles.backBtn}>
          <MaterialCommunityIcons name="arrow-left" size={24} color={colors.text.primary} />
        </Pressable>
        <Text style={styles.title}>Configuración</Text>
        <View style={{ width: 40 }} />
      </View>

      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
        {/* App info */}
        <Surface style={styles.appCard} elevation={2}>
          <View style={styles.appIcon}>
            <MaterialCommunityIcons name="wallet" size={28} color="#FFFFFF" />
          </View>
          <View>
            <Text style={styles.appName}>SENCILLO</Text>
            <Text style={styles.appVersion}>Versión 1.2.0</Text>
          </View>
        </Surface>

        {/* User info */}
        {isAuthenticated && profile && (
          <Surface style={styles.userCard} elevation={1}>
            <View style={styles.userAvatar}>
              <Text style={styles.userInitial}>
                {profile.displayName?.charAt(0).toUpperCase() || '?'}
              </Text>
            </View>
            <View style={{ flex: 1 }}>
              <Text style={styles.userName}>{profile.displayName}</Text>
              <Text style={styles.userEmail}>{user?.email}</Text>
            </View>
            <Pressable onPress={handleSignOut} style={styles.signOutBtn}>
              <MaterialCommunityIcons name="logout" size={18} color={colors.expense} />
            </Pressable>
          </Surface>
        )}

        {/* Ayuda */}
        <View style={styles.section}>
          <Text style={styles.sectionLabel}>Ayuda</Text>
          <Surface style={styles.card} elevation={1}>
            <SettingItem
              icon="play-circle-outline"
              iconColor={colors.brand.primary}
              title="Ver tutorial de la app"
              subtitle="Recorrido completo de todas las funciones"
              onPress={() => router.push('/onboarding')}
            />
            <Divider style={styles.divider} />
            <SettingItem
              icon="rocket-launch"
              iconColor={colors.income}
              title="Novedades"
              subtitle="Historial de versiones y roadmap"
              onPress={() => router.push('/novedades')}
            />
          </Surface>
        </View>

        {/* Backup */}
        {isAuthenticated && (
          <View style={styles.section}>
            <Text style={styles.sectionLabel}>Datos</Text>
            <Surface style={styles.card} elevation={1}>
              <SettingItem
                icon="cloud-upload"
                iconColor={colors.saving}
                title="Hacer backup ahora"
                subtitle={lastBackup ? `Último: ${lastBackup}` : 'Nunca se hizo backup'}
                onPress={handleBackup}
                chevron={false}
              />
              {backingUp && (
                <View style={styles.backupProgress}>
                  <ActivityIndicator size="small" color={colors.brand.primary} />
                  <Text style={styles.backupText}>Subiendo...</Text>
                </View>
              )}
            </Surface>
          </View>
        )}

        {/* Links */}
        <View style={styles.section}>
          <Text style={styles.sectionLabel}>El proyecto</Text>
          <Surface style={styles.card} elevation={1}>
            <SettingItem
              icon="github"
              iconColor={colors.text.secondary}
              title="GitHub"
              subtitle="Mirá el código fuente y otros proyectos"
              onPress={() => Linking.openURL('https://github.com/davidtaranto').catch(() => {})}
            />
            <Divider style={styles.divider} />
            <SettingItem
              icon="coffee"
              iconColor="#f5a623"
              title="Cafecito"
              subtitle="cafecito.app/david-t"
              onPress={() => Linking.openURL('https://cafecito.app/david-t').catch(() => {})}
            />
            <Divider style={styles.divider} />
            <SettingItem
              icon="alpha-m-circle"
              iconColor="#009ee3"
              title="Mercado Pago"
              subtitle="Alias: david.taranto"
              onPress={() => {
                Linking.openURL('https://link.mercadopago.com.ar/david.taranto').catch(() =>
                  Alert.alert('Alias de Mercado Pago', 'david.taranto')
                );
              }}
            />
          </Surface>
        </View>

        {/* Sign out (if not shown in user card) */}
        {!isAuthenticated && (
          <Pressable
            onPress={() => router.push('/(auth)/login')}
            style={({ pressed }) => [styles.loginBtn, pressed && { opacity: 0.85 }]}
          >
            <MaterialCommunityIcons name="google" size={18} color="#FFF" />
            <Text style={styles.loginBtnText}>Iniciar sesión con Google</Text>
          </Pressable>
        )}

        <Text style={styles.footer}>SENCILLO · v1.2.0 · Hecho con 💜 en Argentina</Text>
        <View style={{ height: 40 }} />
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: colors.bg.primary },
  header: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
    paddingTop: 56, paddingHorizontal: spacing.base, paddingBottom: spacing.md,
  },
  backBtn: { width: 40, height: 40, justifyContent: 'center', alignItems: 'center' },
  title: { fontSize: typography.size.lg, fontWeight: typography.weight.bold, color: colors.text.primary },
  content: { padding: spacing.base, gap: spacing.md },
  appCard: {
    borderRadius: radius.lg, backgroundColor: colors.bg.card,
    padding: spacing.md, flexDirection: 'row', alignItems: 'center', gap: spacing.md,
    borderWidth: 1, borderColor: colors.brand.primary + '33',
  },
  appIcon: {
    width: 48, height: 48, borderRadius: radius.md,
    backgroundColor: colors.brand.primary, justifyContent: 'center', alignItems: 'center',
  },
  appName: { fontSize: typography.size.lg, fontWeight: typography.weight.bold, color: colors.text.primary, letterSpacing: 2 },
  appVersion: { fontSize: typography.size.xs, color: colors.text.muted, marginTop: 2 },
  userCard: {
    borderRadius: radius.lg, backgroundColor: colors.bg.card,
    padding: spacing.md, flexDirection: 'row', alignItems: 'center', gap: spacing.md,
  },
  userAvatar: {
    width: 44, height: 44, borderRadius: 22,
    backgroundColor: colors.brand.primary + '33', justifyContent: 'center', alignItems: 'center',
  },
  userInitial: { fontSize: typography.size.lg, fontWeight: typography.weight.bold, color: colors.brand.primary },
  userName: { fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.text.primary },
  userEmail: { fontSize: typography.size.xs, color: colors.text.muted },
  signOutBtn: {
    width: 36, height: 36, borderRadius: radius.full,
    backgroundColor: colors.expense + '18', justifyContent: 'center', alignItems: 'center',
  },
  section: { gap: spacing.sm },
  sectionLabel: {
    fontSize: 10, fontWeight: typography.weight.semibold, color: colors.text.muted,
    textTransform: 'uppercase', letterSpacing: 0.8, paddingHorizontal: spacing.xs,
  },
  card: { borderRadius: radius.lg, backgroundColor: colors.bg.card, overflow: 'hidden' },
  row: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.sm, padding: spacing.md,
  },
  rowPressed: { backgroundColor: colors.brand.muted },
  rowIcon: { width: 36, height: 36, borderRadius: radius.sm, justifyContent: 'center', alignItems: 'center' },
  rowText: { flex: 1, gap: 1 },
  rowTitle: { fontSize: typography.size.sm, fontWeight: typography.weight.medium, color: colors.text.primary },
  rowSub: { fontSize: 11, color: colors.text.muted },
  divider: { marginHorizontal: spacing.md, backgroundColor: colors.border.subtle },
  backupProgress: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.sm,
    paddingHorizontal: spacing.md, paddingBottom: spacing.md,
  },
  backupText: { fontSize: typography.size.xs, color: colors.text.muted },
  loginBtn: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: spacing.sm,
    backgroundColor: colors.brand.primary,
    paddingVertical: spacing.md, borderRadius: radius.lg,
  },
  loginBtnText: { fontSize: typography.size.sm, fontWeight: typography.weight.bold, color: '#FFF' },
  footer: {
    textAlign: 'center', fontSize: 10, color: colors.text.muted, marginTop: spacing.md,
  },
});

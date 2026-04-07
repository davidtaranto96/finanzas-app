import React, { useEffect } from 'react';
import { View, ScrollView, StyleSheet, Pressable, Alert } from 'react-native';
import { Text, Surface, Divider } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useAuthStore } from '@/src/stores/authStore';
import { useFriendStore } from '@/src/stores/friendStore';
import { colors, spacing, radius, typography } from '@/src/lib/theme';

export default function FriendsScreen() {
  const { user, profile } = useAuthStore();
  const { friends, pendingRequests, listen, accept, reject } = useFriendStore();

  useEffect(() => {
    if (!user) return;
    const unsub = listen(user.uid);
    return unsub;
  }, [user?.uid]);

  const handleAccept = async (reqId: string) => {
    if (!user || !profile) return;
    await accept(reqId, user.uid, profile.displayName, profile.photoUrl);
  };

  const handleReject = (reqId: string) => {
    Alert.alert('Rechazar solicitud', '¿Estás seguro?', [
      { text: 'Cancelar', style: 'cancel' },
      { text: 'Rechazar', style: 'destructive', onPress: () => reject(reqId) },
    ]);
  };

  if (!user) {
    return (
      <View style={styles.root}>
        <View style={styles.header}>
          <Pressable onPress={() => router.back()} style={styles.backBtn}>
            <MaterialCommunityIcons name="arrow-left" size={24} color={colors.text.primary} />
          </Pressable>
          <Text style={styles.title}>Amigos</Text>
        </View>
        <View style={styles.emptyState}>
          <MaterialCommunityIcons name="account-off" size={48} color={colors.text.muted} />
          <Text style={styles.emptyTitle}>Necesitás iniciar sesión</Text>
          <Text style={styles.emptyText}>Iniciá sesión con Google para vincular amigos</Text>
          <Pressable onPress={() => router.push('/(auth)/login')} style={styles.loginBtn}>
            <Text style={styles.loginBtnText}>Iniciar sesión</Text>
          </Pressable>
        </View>
      </View>
    );
  }

  return (
    <View style={styles.root}>
      <View style={styles.header}>
        <Pressable onPress={() => router.back()} style={styles.backBtn}>
          <MaterialCommunityIcons name="arrow-left" size={24} color={colors.text.primary} />
        </Pressable>
        <View style={{ flex: 1 }}>
          <Text style={styles.title}>Amigos</Text>
          <Text style={styles.subtitle}>
            {friends.length} {friends.length === 1 ? 'amigo' : 'amigos'}
            {pendingRequests.length > 0 && ` · ${pendingRequests.length} pendientes`}
          </Text>
        </View>
      </View>

      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
        {/* Action buttons */}
        <View style={styles.actionsRow}>
          <Pressable
            style={({ pressed }) => [styles.actionBtn, pressed && { opacity: 0.8 }]}
            onPress={() => router.push('/friends/my-qr')}
          >
            <MaterialCommunityIcons name="qrcode" size={24} color={colors.brand.primary} />
            <Text style={styles.actionText}>Mi QR</Text>
          </Pressable>
          <Pressable
            style={({ pressed }) => [styles.actionBtn, pressed && { opacity: 0.8 }]}
            onPress={() => router.push('/friends/scan')}
          >
            <MaterialCommunityIcons name="qrcode-scan" size={24} color={colors.income} />
            <Text style={styles.actionText}>Escanear</Text>
          </Pressable>
        </View>

        {/* Pending Requests */}
        {pendingRequests.length > 0 && (
          <View style={styles.section}>
            <Text style={styles.sectionTitle}>Solicitudes pendientes</Text>
            <Surface style={styles.card} elevation={1}>
              {pendingRequests.map((req, i) => (
                <React.Fragment key={req.id}>
                  <View style={styles.requestRow}>
                    <View style={styles.requestAvatar}>
                      <Text style={styles.requestInitial}>
                        {req.fromName?.charAt(0).toUpperCase() || '?'}
                      </Text>
                    </View>
                    <View style={styles.requestInfo}>
                      <Text style={styles.requestName}>{req.fromName}</Text>
                      <Text style={styles.requestSub}>Quiere ser tu amigo</Text>
                    </View>
                    <Pressable onPress={() => handleAccept(req.id)} style={styles.acceptBtn}>
                      <MaterialCommunityIcons name="check" size={18} color="#FFF" />
                    </Pressable>
                    <Pressable onPress={() => handleReject(req.id)} style={styles.rejectBtn}>
                      <MaterialCommunityIcons name="close" size={18} color={colors.text.muted} />
                    </Pressable>
                  </View>
                  {i < pendingRequests.length - 1 && <Divider style={styles.divider} />}
                </React.Fragment>
              ))}
            </Surface>
          </View>
        )}

        {/* Friends list */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Mis amigos</Text>
          {friends.length === 0 ? (
            <Surface style={styles.emptyCard} elevation={1}>
              <MaterialCommunityIcons name="account-group-outline" size={40} color={colors.text.muted} />
              <Text style={styles.emptyCardTitle}>Sin amigos todavía</Text>
              <Text style={styles.emptyCardText}>Escaneá el QR de un amigo para vincularte</Text>
            </Surface>
          ) : (
            <Surface style={styles.card} elevation={1}>
              {friends.map((f, i) => {
                const friendUid = f.users.find((u) => u !== user.uid) || '';
                const friendName = f.names?.[friendUid] || 'Amigo';
                return (
                  <React.Fragment key={f.id}>
                    <View style={styles.friendRow}>
                      <View style={[styles.friendAvatar, { backgroundColor: colors.brand.primary + '22' }]}>
                        <Text style={styles.friendInitial}>
                          {friendName.charAt(0).toUpperCase()}
                        </Text>
                      </View>
                      <View style={{ flex: 1 }}>
                        <Text style={styles.friendName}>{friendName}</Text>
                      </View>
                      <MaterialCommunityIcons name="check-circle" size={16} color={colors.income} />
                    </View>
                    {i < friends.length - 1 && <Divider style={styles.divider} />}
                  </React.Fragment>
                );
              })}
            </Surface>
          )}
        </View>

        <View style={{ height: 80 }} />
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: colors.bg.primary },
  header: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.md,
    paddingTop: 56, paddingHorizontal: spacing.base, paddingBottom: spacing.md,
  },
  backBtn: { padding: spacing.xs },
  title: { fontSize: typography.size['2xl'], fontWeight: typography.weight.bold, color: colors.text.primary },
  subtitle: { fontSize: typography.size.xs, color: colors.text.muted, marginTop: 2 },
  content: { paddingHorizontal: spacing.base, gap: spacing.md },
  actionsRow: { flexDirection: 'row', gap: spacing.md },
  actionBtn: {
    flex: 1, backgroundColor: colors.bg.card, borderRadius: radius.lg,
    padding: spacing.base, alignItems: 'center', gap: spacing.sm,
  },
  actionText: { fontSize: typography.size.sm, color: colors.text.primary, fontWeight: typography.weight.medium },
  section: { gap: spacing.sm },
  sectionTitle: {
    fontSize: 10, fontWeight: typography.weight.semibold, color: colors.text.muted,
    textTransform: 'uppercase', letterSpacing: 0.8, paddingHorizontal: spacing.xs,
  },
  card: { borderRadius: radius.lg, backgroundColor: colors.bg.card, overflow: 'hidden' },
  requestRow: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.sm, padding: spacing.md,
  },
  requestAvatar: {
    width: 40, height: 40, borderRadius: radius.full,
    backgroundColor: colors.warning + '22', justifyContent: 'center', alignItems: 'center',
  },
  requestInitial: { fontSize: typography.size.base, fontWeight: typography.weight.bold, color: colors.warning },
  requestInfo: { flex: 1, gap: 2 },
  requestName: { fontSize: typography.size.sm, fontWeight: typography.weight.semibold, color: colors.text.primary },
  requestSub: { fontSize: 11, color: colors.text.muted },
  acceptBtn: {
    width: 32, height: 32, borderRadius: radius.full,
    backgroundColor: colors.income, justifyContent: 'center', alignItems: 'center',
  },
  rejectBtn: {
    width: 32, height: 32, borderRadius: radius.full,
    backgroundColor: colors.bg.elevated, justifyContent: 'center', alignItems: 'center',
  },
  friendRow: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.md, padding: spacing.md,
  },
  friendAvatar: {
    width: 40, height: 40, borderRadius: radius.full, justifyContent: 'center', alignItems: 'center',
  },
  friendInitial: { fontSize: typography.size.base, fontWeight: typography.weight.bold, color: colors.brand.primary },
  friendName: { fontSize: typography.size.sm, fontWeight: typography.weight.medium, color: colors.text.primary },
  divider: { marginHorizontal: spacing.md, backgroundColor: colors.border.subtle },
  emptyState: {
    flex: 1, alignItems: 'center', justifyContent: 'center', gap: spacing.md, padding: spacing['2xl'],
  },
  emptyTitle: { fontSize: typography.size.lg, fontWeight: typography.weight.semibold, color: colors.text.secondary },
  emptyText: { fontSize: typography.size.sm, color: colors.text.muted, textAlign: 'center' },
  loginBtn: {
    backgroundColor: colors.brand.primary, paddingVertical: spacing.sm,
    paddingHorizontal: spacing.xl, borderRadius: radius.lg, marginTop: spacing.sm,
  },
  loginBtnText: { color: '#FFF', fontWeight: typography.weight.bold, fontSize: typography.size.sm },
  emptyCard: {
    borderRadius: radius.lg, backgroundColor: colors.bg.card,
    padding: spacing['2xl'], alignItems: 'center', gap: spacing.sm,
  },
  emptyCardTitle: { fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: colors.text.secondary },
  emptyCardText: { fontSize: typography.size.xs, color: colors.text.muted, textAlign: 'center' },
});

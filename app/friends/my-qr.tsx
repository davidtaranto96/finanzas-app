import React from 'react';
import { View, StyleSheet, Pressable, Share } from 'react-native';
import { Text, Surface } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import QRCode from 'react-native-qrcode-svg';
import { useAuthStore } from '@/src/stores/authStore';
import { colors, spacing, radius, typography } from '@/src/lib/theme';

export default function MyQRScreen() {
  const { user, profile } = useAuthStore();

  const qrData = user ? `${user.uid}|${profile?.appCode || ''}` : '';

  const handleShare = async () => {
    if (!profile?.appCode) return;
    await Share.share({
      message: `Agregame en SENCILLO con mi código: ${profile.appCode}`,
    });
  };

  return (
    <View style={styles.root}>
      <View style={styles.header}>
        <Pressable onPress={() => router.back()} style={styles.backBtn}>
          <MaterialCommunityIcons name="arrow-left" size={24} color={colors.text.primary} />
        </Pressable>
        <Text style={styles.title}>Mi QR</Text>
      </View>

      <View style={styles.center}>
        <Surface style={styles.qrCard} elevation={3}>
          {/* User info */}
          <View style={styles.userInfo}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>
                {profile?.displayName?.charAt(0).toUpperCase() || '?'}
              </Text>
            </View>
            <Text style={styles.userName}>{profile?.displayName || 'Usuario'}</Text>
            <Text style={styles.userEmail}>{user?.email || ''}</Text>
          </View>

          {/* QR Code */}
          {qrData ? (
            <View style={styles.qrContainer}>
              <QRCode
                value={qrData}
                size={200}
                color={colors.text.primary}
                backgroundColor={colors.bg.card}
              />
            </View>
          ) : (
            <View style={styles.qrPlaceholder}>
              <MaterialCommunityIcons name="qrcode" size={80} color={colors.text.muted} />
              <Text style={styles.qrPlaceholderText}>Iniciá sesión para generar tu QR</Text>
            </View>
          )}

          {/* App code */}
          {profile?.appCode && (
            <View style={styles.codeBlock}>
              <Text style={styles.codeLabel}>Tu código de amigo</Text>
              <Text style={styles.codeValue}>{profile.appCode}</Text>
            </View>
          )}
        </Surface>

        {/* Share button */}
        {profile?.appCode && (
          <Pressable
            onPress={handleShare}
            style={({ pressed }) => [styles.shareBtn, pressed && { opacity: 0.85 }]}
          >
            <MaterialCommunityIcons name="share-variant" size={18} color="#FFF" />
            <Text style={styles.shareBtnText}>Compartir código</Text>
          </Pressable>
        )}

        <Text style={styles.hint}>
          Tu amigo puede escanear este QR o usar tu código para agregarte
        </Text>
      </View>
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
  title: { fontSize: typography.size.lg, fontWeight: typography.weight.bold, color: colors.text.primary },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: spacing['2xl'], gap: spacing.xl },
  qrCard: {
    borderRadius: radius.xl, backgroundColor: colors.bg.card,
    padding: spacing['2xl'], alignItems: 'center', gap: spacing.xl, width: '100%',
  },
  userInfo: { alignItems: 'center', gap: spacing.xs },
  avatar: {
    width: 56, height: 56, borderRadius: 28,
    backgroundColor: colors.brand.primary + '33', justifyContent: 'center', alignItems: 'center',
  },
  avatarText: { fontSize: typography.size.xl, fontWeight: typography.weight.bold, color: colors.brand.primary },
  userName: { fontSize: typography.size.lg, fontWeight: typography.weight.bold, color: colors.text.primary },
  userEmail: { fontSize: typography.size.xs, color: colors.text.muted },
  qrContainer: { padding: spacing.md, backgroundColor: colors.bg.card, borderRadius: radius.lg },
  qrPlaceholder: { alignItems: 'center', gap: spacing.sm, padding: spacing.xl },
  qrPlaceholderText: { fontSize: typography.size.sm, color: colors.text.muted, textAlign: 'center' },
  codeBlock: { alignItems: 'center', gap: spacing.xs },
  codeLabel: { fontSize: typography.size.xs, color: colors.text.muted },
  codeValue: {
    fontSize: typography.size['2xl'], fontWeight: typography.weight.bold,
    color: colors.brand.primary, letterSpacing: 6,
  },
  shareBtn: {
    flexDirection: 'row', alignItems: 'center', gap: spacing.sm,
    backgroundColor: colors.brand.primary,
    paddingVertical: spacing.md, paddingHorizontal: spacing.xl,
    borderRadius: radius.xl,
  },
  shareBtnText: { fontSize: typography.size.sm, fontWeight: typography.weight.bold, color: '#FFF' },
  hint: { fontSize: typography.size.xs, color: colors.text.muted, textAlign: 'center', lineHeight: 18 },
});

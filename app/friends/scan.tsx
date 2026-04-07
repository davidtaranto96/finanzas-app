import React, { useState } from 'react';
import { View, StyleSheet, Pressable, Alert, TextInput } from 'react-native';
import { Text, Surface } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useAuthStore } from '@/src/stores/authStore';
import { useFriendStore } from '@/src/stores/friendStore';
import { colors, spacing, radius, typography } from '@/src/lib/theme';

export default function ScanScreen() {
  const { user, profile } = useAuthStore();
  const { sendRequest, findByCode } = useFriendStore();
  const [code, setCode] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSearchByCode = async () => {
    if (!code.trim() || code.trim().length < 6) {
      Alert.alert('Código inválido', 'El código debe tener 6 caracteres');
      return;
    }
    if (!user || !profile) {
      Alert.alert('Error', 'Necesitás iniciar sesión');
      return;
    }

    setLoading(true);
    try {
      const found = await findByCode(code.trim().toUpperCase());
      if (!found) {
        Alert.alert('No encontrado', 'No se encontró ningún usuario con ese código');
        return;
      }
      if (found.uid === user.uid) {
        Alert.alert('Ups', 'Ese es tu propio código');
        return;
      }

      Alert.alert(
        'Usuario encontrado',
        `¿Querés enviar solicitud de amistad a ${found.displayName}?`,
        [
          { text: 'Cancelar', style: 'cancel' },
          {
            text: 'Enviar',
            onPress: async () => {
              try {
                await sendRequest(user.uid, found.uid, profile.displayName, profile.photoUrl);
                Alert.alert('Solicitud enviada', `Se envió la solicitud a ${found.displayName}`);
                router.back();
              } catch (e: any) {
                Alert.alert('Error', e.message);
              }
            },
          },
        ],
      );
    } catch (e: any) {
      Alert.alert('Error', e.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={styles.root}>
      <View style={styles.header}>
        <Pressable onPress={() => router.back()} style={styles.backBtn}>
          <MaterialCommunityIcons name="arrow-left" size={24} color={colors.text.primary} />
        </Pressable>
        <Text style={styles.title}>Agregar amigo</Text>
      </View>

      <View style={styles.content}>
        {/* Manual code input */}
        <Surface style={styles.card} elevation={2}>
          <View style={styles.cardHeader}>
            <MaterialCommunityIcons name="keyboard" size={20} color={colors.brand.primary} />
            <Text style={styles.cardTitle}>Ingresar código</Text>
          </View>
          <Text style={styles.cardDesc}>
            Pedile a tu amigo su código de 6 letras (lo puede ver en "Mi QR")
          </Text>
          <TextInput
            style={styles.codeInput}
            value={code}
            onChangeText={(t) => setCode(t.toUpperCase())}
            placeholder="EJ: ABC123"
            placeholderTextColor={colors.text.muted}
            maxLength={6}
            autoCapitalize="characters"
            autoCorrect={false}
          />
          <Pressable
            onPress={handleSearchByCode}
            disabled={loading || code.length < 6}
            style={({ pressed }) => [
              styles.searchBtn,
              (loading || code.length < 6) && styles.searchBtnDisabled,
              pressed && { opacity: 0.85 },
            ]}
          >
            <MaterialCommunityIcons name="account-search" size={18} color="#FFF" />
            <Text style={styles.searchBtnText}>
              {loading ? 'Buscando...' : 'Buscar amigo'}
            </Text>
          </Pressable>
        </Surface>

        {/* QR Scanner placeholder */}
        <Surface style={styles.card} elevation={2}>
          <View style={styles.cardHeader}>
            <MaterialCommunityIcons name="qrcode-scan" size={20} color={colors.income} />
            <Text style={styles.cardTitle}>Escanear QR</Text>
          </View>
          <View style={styles.qrPlaceholder}>
            <MaterialCommunityIcons name="camera" size={48} color={colors.text.muted} />
            <Text style={styles.qrPlaceholderText}>
              El escáner QR estará disponible próximamente. Por ahora, usá el código de 6 letras.
            </Text>
          </View>
        </Surface>
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
  content: { flex: 1, padding: spacing.base, gap: spacing.md },
  card: {
    borderRadius: radius.xl, backgroundColor: colors.bg.card,
    padding: spacing.base, gap: spacing.md,
  },
  cardHeader: { flexDirection: 'row', alignItems: 'center', gap: spacing.sm },
  cardTitle: { fontSize: typography.size.base, fontWeight: typography.weight.semibold, color: colors.text.primary },
  cardDesc: { fontSize: typography.size.xs, color: colors.text.muted, lineHeight: 18 },
  codeInput: {
    backgroundColor: colors.bg.input,
    borderRadius: radius.lg,
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.base,
    fontSize: typography.size.xl,
    fontWeight: typography.weight.bold,
    color: colors.text.primary,
    textAlign: 'center',
    letterSpacing: 8,
  },
  searchBtn: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: spacing.sm,
    backgroundColor: colors.brand.primary,
    paddingVertical: spacing.md, borderRadius: radius.lg,
  },
  searchBtnDisabled: { opacity: 0.5 },
  searchBtnText: { fontSize: typography.size.sm, fontWeight: typography.weight.bold, color: '#FFF' },
  qrPlaceholder: {
    alignItems: 'center', gap: spacing.md, padding: spacing.xl,
  },
  qrPlaceholderText: { fontSize: typography.size.xs, color: colors.text.muted, textAlign: 'center', lineHeight: 18 },
});

import React, { useRef, useEffect } from 'react';
import { View, StyleSheet, Pressable, Animated, Dimensions, Alert } from 'react-native';
import { Text } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { colors, spacing, radius, typography } from '@/src/lib/theme';

const { width } = Dimensions.get('window');

const FEATURES = [
  { icon: 'wallet', color: '#6C63FF', text: 'Control total de tus finanzas' },
  { icon: 'chart-donut', color: '#60A5FA', text: 'Presupuesto inteligente 50/30/20' },
  { icon: 'flag-checkered', color: '#FBBF24', text: 'Objetivos de ahorro con progreso' },
  { icon: 'account-group', color: '#A78BFA', text: 'Gastos compartidos con amigos' },
];

export default function LoginScreen() {
  const logoScale = useRef(new Animated.Value(0)).current;
  const titleOpacity = useRef(new Animated.Value(0)).current;
  const featuresOpacity = useRef(new Animated.Value(0)).current;
  const buttonSlide = useRef(new Animated.Value(50)).current;
  const buttonOpacity = useRef(new Animated.Value(0)).current;
  const glowAnim = useRef(new Animated.Value(0.3)).current;

  useEffect(() => {
    Animated.sequence([
      Animated.spring(logoScale, { toValue: 1, friction: 5, tension: 80, useNativeDriver: true }),
      Animated.timing(titleOpacity, { toValue: 1, duration: 400, useNativeDriver: true }),
      Animated.timing(featuresOpacity, { toValue: 1, duration: 400, useNativeDriver: true }),
      Animated.parallel([
        Animated.timing(buttonSlide, { toValue: 0, duration: 300, useNativeDriver: true }),
        Animated.timing(buttonOpacity, { toValue: 1, duration: 300, useNativeDriver: true }),
      ]),
    ]).start();

    // Glow loop
    Animated.loop(
      Animated.sequence([
        Animated.timing(glowAnim, { toValue: 0.7, duration: 1500, useNativeDriver: true }),
        Animated.timing(glowAnim, { toValue: 0.3, duration: 1500, useNativeDriver: true }),
      ])
    ).start();
  }, []);

  const handleGoogleSignIn = () => {
    // TODO: Integrar con expo-auth-session o @react-native-google-signin
    // Por ahora, permitimos acceso sin login
    Alert.alert(
      'Google Sign-In',
      'La autenticación con Google se configurará próximamente. ¿Querés continuar sin cuenta?',
      [
        { text: 'Cancelar', style: 'cancel' },
        { text: 'Continuar', onPress: () => router.replace('/(tabs)') },
      ]
    );
  };

  const handleSkip = () => {
    router.replace('/(tabs)');
  };

  return (
    <View style={styles.root}>
      {/* Background decorative circles */}
      <View style={[styles.bgCircle, styles.bgCircle1]} />
      <View style={[styles.bgCircle, styles.bgCircle2]} />

      {/* Logo */}
      <Animated.View style={[styles.logoContainer, { transform: [{ scale: logoScale }] }]}>
        <Animated.View style={[styles.glowRing, { opacity: glowAnim }]} />
        <View style={styles.logoInner}>
          <MaterialCommunityIcons name="wallet" size={48} color="#FFF" />
        </View>
      </Animated.View>

      {/* Title */}
      <Animated.View style={[styles.titleBlock, { opacity: titleOpacity }]}>
        <Text style={styles.appName}>SENCILLO</Text>
        <Text style={styles.appTagline}>Tus finanzas, sin complicaciones</Text>
      </Animated.View>

      {/* Features */}
      <Animated.View style={[styles.featuresCard, { opacity: featuresOpacity }]}>
        {FEATURES.map((f, i) => (
          <View key={i} style={styles.featureRow}>
            <View style={[styles.featureIcon, { backgroundColor: f.color + '22' }]}>
              <MaterialCommunityIcons name={f.icon as any} size={18} color={f.color} />
            </View>
            <Text style={styles.featureText}>{f.text}</Text>
          </View>
        ))}
      </Animated.View>

      {/* Buttons */}
      <Animated.View style={[styles.buttonContainer, { transform: [{ translateY: buttonSlide }], opacity: buttonOpacity }]}>
        <Pressable
          onPress={handleGoogleSignIn}
          style={({ pressed }) => [styles.googleBtn, pressed && { opacity: 0.85 }]}
        >
          <MaterialCommunityIcons name="google" size={20} color="#FFF" />
          <Text style={styles.googleBtnText}>Continuar con Google</Text>
        </Pressable>

        <Pressable onPress={handleSkip} style={({ pressed }) => [pressed && { opacity: 0.6 }]}>
          <Text style={styles.skipText}>Usar sin cuenta</Text>
        </Pressable>
      </Animated.View>

      <Text style={styles.footer}>Hecho con 💜 en Argentina</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: colors.bg.primary,
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing['2xl'],
  },
  bgCircle: {
    position: 'absolute',
    borderRadius: 999,
    backgroundColor: colors.brand.primary + '08',
  },
  bgCircle1: {
    width: 300, height: 300,
    top: -50, right: -80,
  },
  bgCircle2: {
    width: 200, height: 200,
    bottom: 100, left: -60,
  },
  logoContainer: {
    width: 120, height: 120,
    justifyContent: 'center', alignItems: 'center',
    marginBottom: spacing.xl,
  },
  glowRing: {
    position: 'absolute',
    width: 120, height: 120,
    borderRadius: 60,
    borderWidth: 2,
    borderColor: colors.brand.primary,
  },
  logoInner: {
    width: 88, height: 88,
    borderRadius: 44,
    backgroundColor: colors.brand.primary,
    justifyContent: 'center', alignItems: 'center',
  },
  titleBlock: {
    alignItems: 'center',
    gap: spacing.xs,
    marginBottom: spacing['2xl'],
  },
  appName: {
    fontSize: typography.size['3xl'],
    fontWeight: typography.weight.bold,
    color: colors.text.primary,
    letterSpacing: 4,
  },
  appTagline: {
    fontSize: typography.size.sm,
    color: colors.text.secondary,
  },
  featuresCard: {
    width: '100%',
    backgroundColor: colors.bg.card,
    borderRadius: radius.xl,
    padding: spacing.base,
    gap: spacing.md,
    marginBottom: spacing['2xl'],
  },
  featureRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  featureIcon: {
    width: 36, height: 36,
    borderRadius: radius.md,
    justifyContent: 'center', alignItems: 'center',
  },
  featureText: {
    flex: 1,
    fontSize: typography.size.sm,
    color: colors.text.primary,
  },
  buttonContainer: {
    width: '100%',
    alignItems: 'center',
    gap: spacing.base,
  },
  googleBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: spacing.sm,
    width: '100%',
    backgroundColor: colors.brand.primary,
    paddingVertical: spacing.md,
    borderRadius: radius.xl,
    shadowColor: colors.brand.primary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 10,
    elevation: 6,
  },
  googleBtnText: {
    fontSize: typography.size.base,
    fontWeight: typography.weight.bold,
    color: '#FFF',
  },
  skipText: {
    fontSize: typography.size.sm,
    color: colors.text.muted,
  },
  footer: {
    position: 'absolute',
    bottom: 40,
    fontSize: typography.size.xs,
    color: colors.text.muted,
  },
});

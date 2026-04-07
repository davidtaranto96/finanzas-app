import React, { useRef, useState, useEffect } from 'react';
import { View, FlatList, StyleSheet, Pressable, Dimensions } from 'react-native';
import { Text } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { router, useLocalSearchParams } from 'expo-router';
import { colors, spacing, radius, typography } from '@/src/lib/theme';
import { seedDemoData, clearDemoData, isDemoDataLoaded } from '@/src/services/demoDataService';
import { useAccountStore } from '@/src/stores/accountStore';
import { useTransactionStore } from '@/src/stores/transactionStore';
import { useGoalStore } from '@/src/stores/goalStore';

const { width } = Dimensions.get('window');

type Slide = {
  key: string;
  icon: string;
  iconColor: string;
  bgColor: string;
  title: string;
  subtitle: string;
  description: string;
};

const SLIDES: Slide[] = [
  {
    key: 'welcome',
    icon: 'wallet',
    iconColor: '#6C63FF',
    bgColor: '#6C63FF15',
    title: 'Bienvenido a SENCILLO',
    subtitle: 'Tus finanzas, sin complicaciones',
    description: 'Llevá el control de tu plata de forma simple, inteligente y sin estrés. Diseñado para Argentina.',
  },
  {
    key: 'money',
    icon: 'bank-outline',
    iconColor: '#34D399',
    bgColor: '#34D39915',
    title: 'Controlá tu plata',
    subtitle: 'Todo en un solo lugar',
    description: 'Registrá gastos, ingresos, ahorros y transferencias. Visualizá tus cuentas y cuánto gastás por categoría.',
  },
  {
    key: 'budget',
    icon: 'chart-donut',
    iconColor: '#60A5FA',
    bgColor: '#60A5FA15',
    title: 'Presupuesto inteligente',
    subtitle: 'El método 50/30/20',
    description: 'Distribuí tu sueldo en necesidades, deseos y ahorro. Recibí alertas cuando te estás pasando del límite.',
  },
  {
    key: 'goals',
    icon: 'flag-checkered',
    iconColor: '#FBBF24',
    bgColor: '#FBBF2415',
    title: 'Ahorrá con propósito',
    subtitle: 'Objetivos con fecha límite',
    description: 'Creá metas de ahorro para lo que más querés: el viaje, el auto, la compu. Mirá tu progreso en tiempo real.',
  },
  {
    key: 'shopping',
    icon: 'cart-heart',
    iconColor: '#F472B6',
    bgColor: '#F472B615',
    title: 'Compras inteligentes',
    subtitle: 'Anti-impulso incorporado',
    description: 'Antes de comprar, agregalo a tu lista. Después de 7 días, decidís si realmente lo necesitás.',
  },
  {
    key: 'people',
    icon: 'account-group',
    iconColor: '#A78BFA',
    bgColor: '#A78BFA15',
    title: 'Personas y deudas',
    subtitle: 'Nunca más olvidés quién te debe',
    description: 'Registrá préstamos y deudas con amigos o familia. Marcá como pagado y mantenés el balance claro.',
  },
  {
    key: 'start',
    icon: 'rocket-launch',
    iconColor: colors.brand.primary,
    bgColor: colors.brand.primary + '15',
    title: '¡Todo listo!',
    subtitle: 'Empezá ahora',
    description: 'La app funciona completamente sin conexión. Todos tus datos se guardan en tu dispositivo de forma segura.',
  },
];

function SlideItem({ slide, isLast, isDemo, onCloseClean, onCloseKeep }: {
  slide: Slide;
  isLast: boolean;
  isDemo: boolean;
  onCloseClean: () => void;
  onCloseKeep: () => void;
}) {
  return (
    <View style={[styles.slide, { width }]}>
      <View style={[styles.iconWrap, { backgroundColor: slide.bgColor }]}>
        <MaterialCommunityIcons name={slide.icon as any} size={80} color={slide.iconColor} />
      </View>
      <View style={styles.textBlock}>
        <Text style={styles.slideTitle}>{slide.title}</Text>
        <Text style={[styles.slideSubtitle, { color: slide.iconColor }]}>{slide.subtitle}</Text>
        <Text style={styles.slideDesc}>{slide.description}</Text>
      </View>
      {isLast && (
        <View style={styles.ctaContainer}>
          {isDemo ? (
            <>
              <Pressable
                onPress={onCloseClean}
                style={({ pressed }) => [styles.ctaBtn, pressed && { opacity: 0.85 }]}
              >
                <MaterialCommunityIcons name="broom" size={18} color="#FFF" />
                <Text style={styles.ctaText}>Empezar con datos vacíos</Text>
              </Pressable>
              <Pressable
                onPress={onCloseKeep}
                style={({ pressed }) => [styles.ctaBtnSecondary, pressed && { opacity: 0.85 }]}
              >
                <MaterialCommunityIcons name="database-check" size={18} color={colors.brand.primary} />
                <Text style={styles.ctaTextSecondary}>Conservar datos de ejemplo</Text>
              </Pressable>
            </>
          ) : (
            <Pressable
              onPress={onCloseKeep}
              style={({ pressed }) => [styles.ctaBtn, pressed && { opacity: 0.85 }]}
            >
              <MaterialCommunityIcons name="check" size={20} color="#FFF" />
              <Text style={styles.ctaText}>¡Empezar!</Text>
            </Pressable>
          )}
        </View>
      )}
    </View>
  );
}

export default function OnboardingScreen() {
  const { demo } = useLocalSearchParams<{ demo?: string }>();
  const isDemo = demo === 'true';

  const [currentIndex, setCurrentIndex] = useState(0);
  const [demoLoaded, setDemoLoaded] = useState(false);
  const flatListRef = useRef<FlatList>(null);
  const isLast = currentIndex === SLIDES.length - 1;

  const reloadStores = () => {
    useAccountStore.getState().load();
    useTransactionStore.getState().load();
    useGoalStore.getState().load();
  };

  useEffect(() => {
    if (isDemo && !isDemoDataLoaded()) {
      seedDemoData();
      reloadStores();
      setDemoLoaded(true);
    } else if (isDemo) {
      setDemoLoaded(true);
    }
  }, []);

  const handleCloseClean = () => {
    clearDemoData();
    reloadStores();
    router.back();
  };

  const handleCloseKeep = () => {
    router.back();
  };

  const handleNext = () => {
    if (currentIndex < SLIDES.length - 1) {
      flatListRef.current?.scrollToIndex({ index: currentIndex + 1, animated: true });
    }
  };

  return (
    <View style={styles.root}>
      {/* Demo badge */}
      {isDemo && demoLoaded && (
        <View style={styles.demoBadge}>
          <MaterialCommunityIcons name="test-tube" size={12} color="#FFF" />
          <Text style={styles.demoBadgeText}>MODO DEMO</Text>
        </View>
      )}

      {/* Cerrar */}
      <Pressable style={styles.closeBtn} onPress={handleCloseClean}>
        <MaterialCommunityIcons name="close" size={22} color={colors.text.muted} />
      </Pressable>

      {/* Slides */}
      <FlatList
        ref={flatListRef}
        data={SLIDES}
        keyExtractor={(s) => s.key}
        horizontal
        pagingEnabled
        showsHorizontalScrollIndicator={false}
        onMomentumScrollEnd={(e) => {
          const idx = Math.round(e.nativeEvent.contentOffset.x / width);
          setCurrentIndex(idx);
        }}
        renderItem={({ item, index }) => (
          <SlideItem
            slide={item}
            isLast={index === SLIDES.length - 1}
            isDemo={isDemo}
            onCloseClean={handleCloseClean}
            onCloseKeep={handleCloseKeep}
          />
        )}
      />

      {/* Dots */}
      <View style={styles.dotsRow}>
        {SLIDES.map((_, i) => (
          <Pressable
            key={i}
            onPress={() => flatListRef.current?.scrollToIndex({ index: i, animated: true })}
          >
            <View style={[styles.dot, i === currentIndex && styles.dotActive]} />
          </Pressable>
        ))}
      </View>

      {/* Siguiente */}
      {!isLast && (
        <Pressable style={styles.nextBtn} onPress={handleNext}>
          <MaterialCommunityIcons name="arrow-right" size={24} color="#FFF" />
        </Pressable>
      )}

      {/* Contador */}
      <Text style={styles.counter}>{currentIndex + 1} / {SLIDES.length}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: colors.bg.primary },
  closeBtn: {
    position: 'absolute',
    top: 56,
    right: spacing.base,
    width: 36, height: 36,
    borderRadius: radius.full,
    backgroundColor: colors.bg.elevated,
    justifyContent: 'center', alignItems: 'center',
    zIndex: 10,
  },
  demoBadge: {
    position: 'absolute',
    top: 60,
    left: spacing.base,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    backgroundColor: colors.brand.primary,
    paddingHorizontal: spacing.sm,
    paddingVertical: 4,
    borderRadius: radius.full,
    zIndex: 10,
  },
  demoBadgeText: {
    fontSize: 9,
    fontWeight: typography.weight.bold,
    color: '#FFF',
    letterSpacing: 0.5,
  },
  slide: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: spacing['2xl'],
    paddingTop: 80,
    paddingBottom: 180,
    gap: spacing['2xl'],
  },
  iconWrap: {
    width: 160, height: 160, borderRadius: radius.full,
    justifyContent: 'center', alignItems: 'center',
  },
  textBlock: { alignItems: 'center', gap: spacing.md },
  slideTitle: {
    fontSize: typography.size['2xl'],
    fontWeight: typography.weight.bold,
    color: colors.text.primary,
    textAlign: 'center',
  },
  slideSubtitle: {
    fontSize: typography.size.base,
    fontWeight: typography.weight.semibold,
    textAlign: 'center',
  },
  slideDesc: {
    fontSize: typography.size.sm,
    color: colors.text.secondary,
    textAlign: 'center',
    lineHeight: 22,
  },
  ctaContainer: {
    gap: spacing.md,
    alignItems: 'center',
    width: '100%',
  },
  ctaBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    backgroundColor: colors.brand.primary,
    paddingVertical: spacing.md,
    paddingHorizontal: spacing['2xl'],
    borderRadius: radius.xl,
    shadowColor: colors.brand.primary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 10,
    elevation: 6,
  },
  ctaText: {
    fontSize: typography.size.base,
    fontWeight: typography.weight.bold,
    color: '#FFF',
  },
  ctaBtnSecondary: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    paddingVertical: spacing.md,
    paddingHorizontal: spacing['2xl'],
    borderRadius: radius.xl,
    borderWidth: 1,
    borderColor: colors.brand.primary + '55',
  },
  ctaTextSecondary: {
    fontSize: typography.size.sm,
    fontWeight: typography.weight.semibold,
    color: colors.brand.primary,
  },
  dotsRow: {
    position: 'absolute',
    bottom: 110,
    alignSelf: 'center',
    flexDirection: 'row',
    gap: 8,
  },
  dot: {
    width: 8, height: 8, borderRadius: 4,
    backgroundColor: colors.border.default,
  },
  dotActive: {
    width: 24,
    backgroundColor: colors.brand.primary,
  },
  nextBtn: {
    position: 'absolute',
    bottom: 96,
    right: spacing['2xl'],
    width: 52, height: 52,
    borderRadius: radius.full,
    backgroundColor: colors.brand.primary,
    justifyContent: 'center', alignItems: 'center',
  },
  counter: {
    position: 'absolute',
    bottom: 107,
    left: spacing['2xl'],
    fontSize: typography.size.xs,
    color: colors.text.muted,
  },
});

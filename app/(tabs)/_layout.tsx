import { useEffect, useRef } from 'react';
import { Tabs } from 'expo-router';
import { View, StyleSheet, Animated } from 'react-native';
import { Text, FAB, Portal } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { colors, spacing, typography } from '@/src/lib/theme';
import { useFabStore } from '@/src/stores/fabStore';

type TabIconProps = {
  name: string;
  label: string;
  focused: boolean;
  size?: number;
};

function TabIcon({ name, label, focused, size = 22 }: TabIconProps) {
  return (
    <View style={styles.tabItem}>
      <MaterialCommunityIcons
        name={name as any}
        size={size}
        color={focused ? colors.brand.primary : colors.text.muted}
      />
      <Text style={[styles.tabLabel, focused && styles.tabLabelFocused]}>
        {label}
      </Text>
    </View>
  );
}

function SharedFAB() {
  const { isActive, icon, onPress, actions, groupOpen, setGroupOpen, configVersion } =
    useFabStore();

  const scaleAnim = useRef(new Animated.Value(isActive ? 1 : 0)).current;
  const prevVersion = useRef(configVersion);

  useEffect(() => {
    // Si es el mismo configVersion, no animar
    if (prevVersion.current === configVersion) return;
    prevVersion.current = configVersion;

    if (isActive) {
      // Scale down → up (morph)
      Animated.sequence([
        Animated.timing(scaleAnim, {
          toValue: 0.3,
          duration: 100,
          useNativeDriver: true,
        }),
        Animated.spring(scaleAnim, {
          toValue: 1,
          friction: 6,
          tension: 200,
          useNativeDriver: true,
        }),
      ]).start();
    } else {
      // Esconder con animación
      Animated.timing(scaleAnim, {
        toValue: 0,
        duration: 150,
        useNativeDriver: true,
      }).start();
    }
  }, [configVersion, isActive]);

  // Siempre renderizar — la animación controla visibilidad
  const animatedStyle = {
    transform: [{ scale: scaleAnim }],
    opacity: scaleAnim,
  };

  if (actions && actions.length > 0) {
    return (
      <Animated.View style={[styles.fabWrapper, animatedStyle]}>
        <FAB.Group
          open={groupOpen}
          visible={true}
          icon={groupOpen ? 'close' : (icon ?? 'plus')}
          color="#FFFFFF"
          fabStyle={styles.fab}
          actions={actions.map((a) => ({
            icon: a.icon,
            label: a.label,
            onPress: a.onPress,
            style: a.style ?? { backgroundColor: colors.bg.elevated },
            labelStyle: { backgroundColor: colors.bg.card, color: colors.text.primary },
          }))}
          onStateChange={({ open }) => setGroupOpen(open)}
          style={styles.fabGroup}
        />
      </Animated.View>
    );
  }

  return (
    <Animated.View style={[styles.fabSimpleWrapper, animatedStyle]}>
      <FAB
        icon={icon ?? 'plus'}
        style={styles.fabSimple}
        color="#FFFFFF"
        onPress={onPress}
      />
    </Animated.View>
  );
}

export default function TabLayout() {
  return (
    <>
      <Tabs
        screenOptions={{
          headerShown: false,
          tabBarStyle: styles.tabBar,
          tabBarShowLabel: false,
        }}
      >
        <Tabs.Screen
          name="index"
          options={{
            tabBarIcon: ({ focused }) => (
              <TabIcon name="home-variant" label="Inicio" focused={focused} />
            ),
          }}
        />
        <Tabs.Screen
          name="movimientos"
          options={{
            tabBarIcon: ({ focused }) => (
              <TabIcon name="swap-horizontal" label="Movimientos" focused={focused} />
            ),
          }}
        />
        <Tabs.Screen
          name="presupuesto"
          options={{
            tabBarIcon: ({ focused }) => (
              <TabIcon name="chart-donut" label="Presupuesto" focused={focused} />
            ),
          }}
        />
        <Tabs.Screen
          name="objetivos"
          options={{
            tabBarIcon: ({ focused }) => (
              <TabIcon name="flag-checkered" label="Objetivos" focused={focused} />
            ),
          }}
        />
        <Tabs.Screen
          name="mas"
          options={{
            tabBarIcon: ({ focused }) => (
              <TabIcon name="menu" label="Más" focused={focused} />
            ),
          }}
        />
      </Tabs>

      {/* FAB compartido — siempre montado, animación controla visibilidad */}
      <Portal>
        <SharedFAB />
      </Portal>
    </>
  );
}

const styles = StyleSheet.create({
  tabBar: {
    backgroundColor: colors.bg.secondary,
    borderTopColor: colors.border.default,
    borderTopWidth: 1,
    height: 72,
    paddingBottom: 8,
    paddingTop: 8,
  },
  tabItem: {
    alignItems: 'center',
    gap: 3,
  },
  tabLabel: {
    fontSize: 10,
    color: colors.text.muted,
    fontWeight: typography.weight.medium,
  },
  tabLabelFocused: {
    color: colors.brand.primary,
  },
  fab: {
    backgroundColor: colors.brand.primary,
  },
  fabGroup: {
    paddingBottom: 80,
  },
  fabWrapper: {
    position: 'absolute',
    left: 0,
    right: 0,
    bottom: 0,
    top: 0,
  },
  fabSimpleWrapper: {
    position: 'absolute',
    right: spacing.base,
    bottom: 96,
  },
  fabSimple: {
    backgroundColor: colors.brand.primary,
  },
});

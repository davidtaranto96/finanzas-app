#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const androidDir = path.join(__dirname, '..', 'android');

// 1. Recrear local.properties si falta (se borra con prebuild --clean)
const localProps = path.join(androidDir, 'local.properties');
if (!fs.existsSync(localProps)) {
  fs.writeFileSync(localProps, 'sdk.dir=C\\:\\\\Users\\\\david\\\\AppData\\\\Local\\\\Android\\\\Sdk\n');
  console.log('✓ Creado android/local.properties');
} else {
  console.log('✓ android/local.properties OK');
}

// 2. Inyectar java.home en gradle.properties si no está
const gradleProps = path.join(androidDir, 'gradle.properties');
if (fs.existsSync(gradleProps)) {
  let content = fs.readFileSync(gradleProps, 'utf8');
  if (!content.includes('org.gradle.java.home')) {
    content += '\norg.gradle.java.home=C\\:\\\\Program Files\\\\Android\\\\Android Studio\\\\jbr\n';
    fs.writeFileSync(gradleProps, content);
    console.log('✓ Java home añadido a gradle.properties');
  } else {
    console.log('✓ gradle.properties OK');
  }
}

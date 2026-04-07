import {
  signInWithCredential,
  GoogleAuthProvider,
  signOut as firebaseSignOut,
  onAuthStateChanged,
  User,
} from 'firebase/auth';
import { doc, setDoc, getDoc, serverTimestamp } from 'firebase/firestore';
import { auth, db } from '@/src/lib/firebase';

/**
 * Genera un código de amigo único de 6 caracteres
 */
function generateAppCode(): string {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // sin 0/O/1/I para evitar confusión
  let code = '';
  for (let i = 0; i < 6; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return code;
}

/**
 * Completa el sign-in con un Google ID token (obtenido de expo-auth-session o Google Sign-In)
 */
export async function signInWithGoogleToken(idToken: string): Promise<User> {
  const credential = GoogleAuthProvider.credential(idToken);
  const result = await signInWithCredential(auth, credential);
  const user = result.user;

  // Crear/actualizar perfil en Firestore
  const userRef = doc(db, 'users', user.uid);
  const userDoc = await getDoc(userRef);

  if (!userDoc.exists()) {
    // Primer login — crear perfil
    await setDoc(userRef, {
      displayName: user.displayName || 'Usuario',
      email: user.email,
      photoUrl: user.photoURL,
      appCode: generateAppCode(),
      createdAt: serverTimestamp(),
    });
  } else {
    // Login subsiguiente — actualizar info
    await setDoc(userRef, {
      displayName: user.displayName || userDoc.data().displayName,
      email: user.email,
      photoUrl: user.photoURL,
    }, { merge: true });
  }

  return user;
}

export async function signOut(): Promise<void> {
  await firebaseSignOut(auth);
}

export function getCurrentUser(): User | null {
  return auth.currentUser;
}

export function onAuthChange(callback: (user: User | null) => void): () => void {
  return onAuthStateChanged(auth, callback);
}

/**
 * Obtiene el perfil del usuario de Firestore
 */
export async function getUserProfile(uid: string) {
  const userDoc = await getDoc(doc(db, 'users', uid));
  return userDoc.exists() ? userDoc.data() : null;
}

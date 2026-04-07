import {
  collection, doc, addDoc, updateDoc, deleteDoc, getDocs, getDoc,
  query, where, onSnapshot, serverTimestamp, Unsubscribe,
} from 'firebase/firestore';
import { db } from '@/src/lib/firebase';

export type FriendRequest = {
  id: string;
  from: string;
  to: string;
  fromName: string;
  fromPhoto?: string;
  status: 'pending' | 'accepted' | 'rejected';
  createdAt: any;
};

export type Friendship = {
  id: string;
  users: string[];
  names: Record<string, string>;
  photos: Record<string, string>;
  createdAt: any;
};

/**
 * Busca un usuario por su appCode (el código de 6 letras)
 */
export async function findUserByAppCode(appCode: string) {
  const q = query(collection(db, 'users'), where('appCode', '==', appCode.toUpperCase()));
  const snap = await getDocs(q);
  if (snap.empty) return null;
  const doc = snap.docs[0];
  return { uid: doc.id, ...doc.data() };
}

/**
 * Busca un usuario por UID
 */
export async function findUserByUid(uid: string) {
  const ref = doc(db, 'users', uid);
  const snap = await getDoc(ref);
  if (!snap.exists()) return null;
  return { uid: snap.id, ...snap.data() };
}

/**
 * Envía solicitud de amistad
 */
export async function sendFriendRequest(
  fromUid: string,
  toUid: string,
  fromName: string,
  fromPhoto?: string,
): Promise<string> {
  // Verificar que no exista ya una solicitud o amistad
  const existingReq = query(
    collection(db, 'friendRequests'),
    where('from', '==', fromUid),
    where('to', '==', toUid),
    where('status', '==', 'pending'),
  );
  const snap = await getDocs(existingReq);
  if (!snap.empty) throw new Error('Ya enviaste una solicitud a este usuario');

  const docRef = await addDoc(collection(db, 'friendRequests'), {
    from: fromUid,
    to: toUid,
    fromName,
    fromPhoto: fromPhoto || null,
    status: 'pending',
    createdAt: serverTimestamp(),
  });
  return docRef.id;
}

/**
 * Acepta solicitud y crea friendship
 */
export async function acceptFriendRequest(
  requestId: string,
  myUid: string,
  myName: string,
  myPhoto?: string,
): Promise<void> {
  const reqRef = doc(db, 'friendRequests', requestId);
  const reqSnap = await getDoc(reqRef);
  if (!reqSnap.exists()) throw new Error('Solicitud no encontrada');

  const reqData = reqSnap.data() as FriendRequest;

  // Crear friendship
  await addDoc(collection(db, 'friendships'), {
    users: [reqData.from, myUid],
    names: {
      [reqData.from]: reqData.fromName,
      [myUid]: myName,
    },
    photos: {
      [reqData.from]: reqData.fromPhoto || '',
      [myUid]: myPhoto || '',
    },
    createdAt: serverTimestamp(),
  });

  // Actualizar solicitud
  await updateDoc(reqRef, { status: 'accepted' });
}

/**
 * Rechaza solicitud
 */
export async function rejectFriendRequest(requestId: string): Promise<void> {
  await updateDoc(doc(db, 'friendRequests', requestId), { status: 'rejected' });
}

/**
 * Escucha solicitudes pendientes para mí
 */
export function listenToFriendRequests(
  myUid: string,
  callback: (requests: FriendRequest[]) => void,
): Unsubscribe {
  const q = query(
    collection(db, 'friendRequests'),
    where('to', '==', myUid),
    where('status', '==', 'pending'),
  );
  return onSnapshot(q, (snap) => {
    const requests = snap.docs.map((d) => ({ id: d.id, ...d.data() } as FriendRequest));
    callback(requests);
  });
}

/**
 * Escucha mis amistades
 */
export function listenToFriendships(
  myUid: string,
  callback: (friendships: Friendship[]) => void,
): Unsubscribe {
  const q = query(
    collection(db, 'friendships'),
    where('users', 'array-contains', myUid),
  );
  return onSnapshot(q, (snap) => {
    const friendships = snap.docs.map((d) => ({ id: d.id, ...d.data() } as Friendship));
    callback(friendships);
  });
}

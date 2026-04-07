import { create } from 'zustand';
import {
  FriendRequest, Friendship,
  listenToFriendRequests, listenToFriendships,
  acceptFriendRequest, rejectFriendRequest,
  sendFriendRequest, findUserByAppCode,
} from '@/src/services/friendService';

type FriendState = {
  friends: Friendship[];
  pendingRequests: FriendRequest[];
  isLoading: boolean;
  error: string | null;
  /** Inicia listeners de Firestore. Retorna función para desuscribirse */
  listen: (myUid: string) => () => void;
  accept: (requestId: string, myUid: string, myName: string, myPhoto?: string) => Promise<void>;
  reject: (requestId: string) => Promise<void>;
  sendRequest: (fromUid: string, toUid: string, fromName: string, fromPhoto?: string) => Promise<void>;
  findByCode: (code: string) => Promise<any>;
};

export const useFriendStore = create<FriendState>((set) => ({
  friends: [],
  pendingRequests: [],
  isLoading: false,
  error: null,

  listen: (myUid: string) => {
    set({ isLoading: true });
    const unsub1 = listenToFriendRequests(myUid, (requests) => {
      set({ pendingRequests: requests, isLoading: false });
    });
    const unsub2 = listenToFriendships(myUid, (friendships) => {
      set({ friends: friendships, isLoading: false });
    });
    return () => { unsub1(); unsub2(); };
  },

  accept: async (requestId, myUid, myName, myPhoto) => {
    try {
      await acceptFriendRequest(requestId, myUid, myName, myPhoto);
    } catch (e: any) {
      set({ error: e.message });
    }
  },

  reject: async (requestId) => {
    try {
      await rejectFriendRequest(requestId);
    } catch (e: any) {
      set({ error: e.message });
    }
  },

  sendRequest: async (fromUid, toUid, fromName, fromPhoto) => {
    set({ error: null });
    try {
      await sendFriendRequest(fromUid, toUid, fromName, fromPhoto);
    } catch (e: any) {
      set({ error: e.message });
      throw e;
    }
  },

  findByCode: async (code: string) => {
    return findUserByAppCode(code);
  },
}));

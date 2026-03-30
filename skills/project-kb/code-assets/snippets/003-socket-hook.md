---
id: "snippet-003"
language: "typescript"
category: "network"
tags: ["react", "websocket", "socket.io", "real-time"]
author: "ChessVerse"
description: "Socket.io 的 React Hook 封装，支持自动重连、心跳检测和类型安全的事件处理"
complexity: "high"
---

# Socket.io React Hook

## 代码内容

```typescript
'use client';

import { useEffect, useRef, useCallback, useState } from 'react';
import { io, Socket } from 'socket.io-client';

interface UseSocketOptions {
  playerId?: string;
  gameId?: string;
  enableHeartbeat?: boolean;
  heartbeatInterval?: number;
  onConnect?: () => void;
  onDisconnect?: () => void;
  onMoveMade?: (data: any) => void;
  onGameStateChange?: (data: any) => void;
  onChatMessage?: (data: any) => void;
}

export function useSocket(options: UseSocketOptions) {
  const socketRef = useRef<Socket | null>(null);
  const [isConnected, setIsConnected] = useState(false);
  const [connectionQuality, setConnectionQuality] = useState<'good' | 'fair' | 'poor'>('good');
  const optionsRef = useRef(options);
  const heartbeatTimerRef = useRef<NodeJS.Timeout | null>(null);
  const lastPongRef = useRef<number>(Date.now());

  useEffect(() => {
    optionsRef.current = options;
  });

  useEffect(() => {
    const socket = io({
      path: '/api/socket',
      autoConnect: true,
    });

    socketRef.current = socket;

    socket.on('connect', () => {
      console.log('[Socket] Connected:', socket.id);
      setIsConnected(true);
      setConnectionQuality('good');
      lastPongRef.current = Date.now();
      optionsRef.current.onConnect?.();

      if (optionsRef.current.playerId) {
        socket.emit('player:join', { playerId: optionsRef.current.playerId });
      }
      if (optionsRef.current.gameId) {
        socket.emit('game:join', { gameId: optionsRef.current.gameId });
      }
    });

    socket.on('disconnect', () => {
      console.log('[Socket] Disconnected');
      setIsConnected(false);
      if (heartbeatTimerRef.current) {
        clearInterval(heartbeatTimerRef.current);
        heartbeatTimerRef.current = null;
      }
      optionsRef.current.onDisconnect?.();
    });

    socket.on('player:heartbeat:ack', () => {
      lastPongRef.current = Date.now();
      const latency = Date.now() - lastPongRef.current;
      if (latency < 500) setConnectionQuality('good');
      else if (latency < 1500) setConnectionQuality('fair');
      else setConnectionQuality('poor');
    });

    socket.on('game:move', (data) => {
      optionsRef.current.onMoveMade?.(data);
    });

    socket.on('game:state', (data) => {
      optionsRef.current.onGameStateChange?.(data);
    });

    socket.on('game:chat', (data) => {
      optionsRef.current.onChatMessage?.(data);
    });

    if (options.enableHeartbeat && options.playerId) {
      const interval = options.heartbeatInterval || 10000;
      heartbeatTimerRef.current = setInterval(() => {
        socket.emit('player:heartbeat', { 
          playerId: options.playerId, 
          timestamp: Date.now() 
        });
      }, interval);
    }

    return () => {
      if (options.gameId) {
        socket.emit('game:leave', { gameId: options.gameId });
      }
      if (heartbeatTimerRef.current) {
        clearInterval(heartbeatTimerRef.current);
      }
      socket.disconnect();
    };
  }, [options.playerId, options.gameId, options.enableHeartbeat]);

  const emitMove = useCallback((data: any) => {
    if (socketRef.current && isConnected) {
      socketRef.current.emit('game:move', data);
    }
  }, [isConnected]);

  const emitChat = useCallback((data: { gameId: string; message: string }) => {
    if (socketRef.current && isConnected) {
      socketRef.current.emit('game:chat', {
        ...data,
        playerId: options.playerId,
      });
    }
  }, [isConnected, options.playerId]);

  const joinGame = useCallback((gameId: string) => {
    if (socketRef.current && isConnected) {
      socketRef.current.emit('game:join', { gameId });
    }
  }, [isConnected]);

  return {
    socket: socketRef.current,
    isConnected,
    connectionQuality,
    emitMove,
    emitChat,
    joinGame,
  };
}
```

## 使用示例

```tsx
import { useSocket } from '@/hooks/use-socket';

function GameRoom({ gameId, playerId }: { gameId: string; playerId: string }) {
  const { isConnected, connectionQuality, emitMove, emitChat } = useSocket({
    playerId,
    gameId,
    enableHeartbeat: true,
    heartbeatInterval: 10000,
    onConnect: () => console.log('Connected!'),
    onDisconnect: () => console.log('Disconnected!'),
    onMoveMade: (data) => console.log('Move:', data),
    onChatMessage: (data) => console.log('Chat:', data),
  });

  const handleMove = () => {
    emitMove({ from: 'e2', to: 'e4' });
  };

  return (
    <div>
      <span>Status: {isConnected ? 'Connected' : 'Disconnected'}</span>
      <span>Quality: {connectionQuality}</span>
      <button onClick={handleMove}>Make Move</button>
    </div>
  );
}
```

## 特性

- 自动连接管理
- 心跳检测与连接质量评估
- 类型安全的事件回调
- 自动清理与重连
- 支持多房间加入

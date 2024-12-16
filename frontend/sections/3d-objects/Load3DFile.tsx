'use client';

import { useRef, useState, useEffect, Suspense } from 'react';
import { Mesh } from 'three';
import { Canvas, useFrame, useLoader } from '@react-three/fiber';
import { OrbitControls, Html } from '@react-three/drei';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { a, useSpring } from '@react-spring/three';

function Load3DFile({ fileUrl, scales, positions, onLoadComplete }) {
  const mesh = useRef();
  const gltf = useLoader(GLTFLoader, fileUrl);

  useEffect(() => {
    if (gltf) {
      console.log('Détails de l\'objet 3D chargé:', gltf);
      onLoadComplete();
    }
  }, [gltf, onLoadComplete]);

  useFrame(() => {
    if (mesh.current) {
      mesh.current.rotation.y += 0.01;
    }
  });

  return (
    <mesh ref={mesh} scale={scales} position={positions}>
      <primitive object={gltf.scene} />
    </mesh>
  );
}

export default function ThreeDObjectView({ fileUrl, scales, positions }) {
  const [isLoading, setIsLoading] = useState(true);

  const { scale, opacity } = useSpring({
    scale: isLoading ? 0.5 : 1,
    opacity: isLoading ? 0 : 1,
  });

  return (
    <div className="w-full h-full">
      <Canvas camera={{ position: [0, 0, 2], fov: 40 }}>
        <OrbitControls minDistance={1} maxDistance={5} />
        <ambientLight intensity={0.5} />
        <directionalLight position={[0, 10, 5]} intensity={1.5} />
        <pointLight position={[-5, 5, 5]} intensity={1} />
        <pointLight position={[5, -5, 5]} intensity={1} />
        <pointLight position={[5, 5, -5]} intensity={1} />
        {isLoading && (
          <Html center>
            <div className="text-white">Chargement...</div>
          </Html>
        )}
        <Suspense fallback={null}>
          <a.group scale={scale.to((s) => [s, s, s])} opacity={opacity}>
            <Load3DFile
              fileUrl={fileUrl}
              scales={scales}
              positions={positions}
              onLoadComplete={() => setIsLoading(false)}
            />
          </a.group>
        </Suspense>
      </Canvas>
    </div>
  );
}
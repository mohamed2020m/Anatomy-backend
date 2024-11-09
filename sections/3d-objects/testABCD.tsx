'use client';
import { useRef, useState, useEffect, Suspense } from 'react';
import { Mesh } from 'three';
import { Canvas, useFrame, useLoader } from '@react-three/fiber';
import { OrbitControls, Html } from '@react-three/drei';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { a, useSpring } from '@react-spring/three';
import { fetchObjectById } from '@/services/3d-object';
import { ThreeDObject } from "@/constants/data"

const objectFiles = [
  {
    path: '/3d-allen-m-brain.glb',
    scales: [3.5, 3.5, 3.5],
    positions: [0, -2.8, 0],
  },
  // Vous pouvez ajouter d'autres objets ici
];

function Load3DFile({ fileUrl, scales, positions, onLoadComplete }) {
  const mesh = useRef<Mesh>(null);
  const gltf = useLoader(GLTFLoader, fileUrl);

  useEffect(() => {
    if (gltf) {
      console.log('Détails de l’objet 3D chargé:', gltf);
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

export default function ThreeDObjectView({ threeDObjectId }: { threeDObjectId: number }) {
  const [objectDetails, setObjectDetails] = useState<ThreeDObject | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  // Vérifiez si l'ID est passé correctement
  console.log('ID de l\'objet reçu en props:', threeDObjectId);

  const currentFile = objectFiles.find((file) => file.id === threeDObjectId) || objectFiles[0];
  console.log('Objet courant trouvé:', currentFile); // Vérifier l'objet correspondant

  const { scale, opacity } = useSpring({
    scale: isLoading ? 0.5 : 1,
    opacity: isLoading ? 0 : 1,
  });

  // Utiliser useEffect pour fetcher les détails de l'objet via l'ID
  useEffect(() => {
    const fetchDetails = async () => {
      if (!threeDObjectId) {
        console.error('ID de l\'objet invalide:', threeDObjectId);
        return;
      }

      try {
        const data = await fetchObjectById(threeDObjectId);
        console.log('Objet récupéré:', data); // Affiche l'objet dans la console pour débogage
        setObjectDetails(data); // Met à jour l'état avec les détails de l'objet
        setIsLoading(false);
      } catch (error) {
        console.error('Erreur lors de la récupération de l\'objet:', error);
      }
    };

    fetchDetails();
  }, [threeDObjectId]); // Rafraîchir l'appel quand l'ID de l'objet change

  return (
    <div className="flex h-screen flex-col items-center justify-center">
      {objectDetails && (
        <div className="text-center">
          <h1 className="my-4 text-2xl font-bold">{objectDetails.name}</h1>
          <p className="mb-4">{objectDetails.description}</p>
          {objectDetails.image && (
            <img src={objectDetails.image} alt={objectDetails.name} className="mb-4 w-64 h-64 object-cover" />
          )}
        </div>
      )}
      <Canvas camera={{ position: [0, 0, 2], fov: 40 }} className="h-2xl w-2xl">
        <OrbitControls minDistance={1} maxDistance={5} />
        <ambientLight intensity={0.5} />
        <directionalLight position={[0, 10, 5]} intensity={1.5} />
        <pointLight position={[-5, 5, 5]} intensity={1} />
        <pointLight position={[5, -5, 5]} intensity={1} />
        <pointLight position={[5, 5, -5]} intensity={1} />
        {isLoading && (
          <Html center>
            <div className="text-white">Loading...</div>
          </Html>
        )}
        <Suspense fallback={null}>
          <a.group scale={scale.to((s) => [s, s, s])} opacity={opacity}>
            <Load3DFile
              fileUrl={currentFile.path}
              scales={currentFile.scales}
              positions={currentFile.positions}
              onLoadComplete={() => setIsLoading(false)}
            />
          </a.group>
        </Suspense>
      </Canvas>
    </div>
  );
}
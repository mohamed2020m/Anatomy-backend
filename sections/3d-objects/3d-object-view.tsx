'use client';
import { useRef, useState, useEffect, Suspense } from 'react';
import { Mesh } from 'three';
import { Canvas, useFrame, useLoader } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { a, useSpring } from '@react-spring/three';
import { Html } from '@react-three/drei';

const objectFiles = [
  {
    id: 1, // Ajout d'un ID pour identifier chaque objet
    path: '/3d-allen-m-brain.glb',
    scales: [3.5, 3.5, 3.5],
    positions: [0, -2.8, 0]
  }
  // Vous pouvez ajouter d'autres objets ici
];

function Load3DFile({ fileUrl, scales, positions, onLoadComplete }) {
  const mesh = useRef<Mesh>(null!);
  const gltf = useLoader(GLTFLoader, fileUrl, (loader) => {
    loader.load(fileUrl, onLoadComplete);
  });

  useFrame(() => {
    if (mesh.current) {
      mesh.current.rotation.y += 0.01; // Rotation lente
    }
  });

  return (
    <mesh ref={mesh} scale={scales} position={positions}>
      <primitive object={gltf.scene} />
    </mesh>
  );
}

export default function Mesh3D() {
  const [currentFileIndex, setCurrentFileIndex] = useState(0);
  const [isLoading, setIsLoading] = useState(true);
  const [objectDetails, setObjectDetails] = useState(null);

  useEffect(() => {
    const fetchObjectDetails = async (id) => {
      try {
        const response = await fetch(`http://localhost:8080/api/v1/threeDObjects/${id}`); // Ajustez l'URL selon votre API
        const data = await response.json();
        setObjectDetails(data);
      } catch (error) {
        console.error('Erreur lors de la récupération des détails de l\'objet:', error);
      }
    };

    fetchObjectDetails(objectFiles[currentFileIndex].id); // Appel de la fonction avec l'ID de l'objet

    const interval = setInterval(() => {
      setCurrentFileIndex((prevIndex) => (prevIndex + 1) % objectFiles.length);
      fetchObjectDetails(objectFiles[(currentFileIndex + 1) % objectFiles.length].id); // Récupérer les détails du prochain objet
    }, 5000);
    
    return () => clearInterval(interval);
  }, [currentFileIndex]);

  const currentFile = objectFiles[currentFileIndex];

  const { opacity, scale } = useSpring({
    from: { opacity: 0, scale: 0.8 },
    to: { opacity: 1, scale: 1 },
    config: { mass: 1, tension: 280, friction: 60 },
    reset: true
  });

  return (
    <div className="flex h-screen flex-col items-center justify-center">
      {objectDetails && (
        <div className="text-center">
          <h1 className="my-4 text-2xl font-bold">{objectDetails.name}</h1>
          <p className="mb-4">{objectDetails.description}</p>
          {objectDetails.image && <img src={objectDetails.image} alt={objectDetails.name} className="mb-4 w-64 h-64 object-cover" />}
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

'use client';
import { useRef, useState, useEffect, Suspense } from 'react';
import { Mesh } from 'three';
import { Canvas, useFrame, useLoader } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { a, useSpring } from '@react-spring/three';
import { Html } from '@react-three/drei';

// List of objects with file paths and names
const objectFiles: {
  path: string;
  name: string;
  scales: [number, number, number];
  positions: [number, number, number];
}[] = [
  {
    path: './3d-vh-m-heart.glb',
    name: 'Male Heart',
    scales: [4, 4, 4],
    positions: [-0.05, -1.8, 0]
  },
  {
    path: './3d-vh-m-lung.glb',
    name: 'Lung',
    scales: [2, 2, 2],
    positions: [0, -0.9, 0]
  },
  {
    path: './3d-vh-f-blood-vasculature.glb',
    name: 'Female Blood Vasculature',
    scales: [2, 2, 2],
    positions: [0, -0.5, 0]
  },
  {
    path: './3d-allen-m-brain.glb',
    name: 'Male Brain',
    scales: [3.5, 3.5, 3.5],
    positions: [0, -2.8, 0]
  }
];

function Load3DFile({
  fileUrl,
  scales,
  positions,
  onLoadComplete
}: {
  fileUrl: string;
  scales: [number, number, number];
  positions: [number, number, number];
  onLoadComplete: () => void;
}) {
  const mesh = useRef<Mesh>(null!);
  const gltf = useLoader(GLTFLoader, fileUrl, (loader) => {
    loader.load(fileUrl, onLoadComplete); // Call onLoadComplete when the model is loaded
  });

  useFrame(() => {
    if (mesh.current) {
      mesh.current.rotation.y += 0.01; // Slow rotation
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
  const [isLoading, setIsLoading] = useState(true); // Track loading state

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentFileIndex((prevIndex) => (prevIndex + 1) % objectFiles.length);
    }, 5000);

    return () => clearInterval(interval);
  }, []);

  const currentFile = objectFiles[currentFileIndex];

  // Spring for smooth transition when switching files
  const { opacity, scale } = useSpring({
    from: { opacity: 0, scale: 0.8 },
    to: { opacity: 1, scale: 1 },
    config: { mass: 1, tension: 280, friction: 60 },
    reset: true
  });

  return (
    <div className="flex h-screen flex-col items-center justify-center">
      {/* Display the name of the current file */}
      <h1 className="my-4 rounded-lg bg-gradient-to-r from-purple-400 via-pink-500 to-red-500 p-2 text-sm italic text-white shadow-lg">
        {currentFile.name}
      </h1>

      <Canvas camera={{ position: [0, 0, 2], fov: 40 }} className="h-2xl w-2xl">
        <OrbitControls minDistance={1} maxDistance={5} />
        <ambientLight intensity={0.5} />
        <directionalLight position={[0, 10, 5]} intensity={1.5} />
        <pointLight position={[-5, 5, 5]} intensity={1} />
        <pointLight position={[5, -5, 5]} intensity={1} />
        <pointLight position={[5, 5, -5]} intensity={1} />

        {/* Show skeleton loader only when the model is loading */}
        {isLoading && (
          <Html center>
            <div className="text-white">Loading...</div>
          </Html>
        )}

        {/* Use Suspense to handle loading state of the 3D model */}
        <Suspense fallback={null}>
          <a.group scale={scale.to((s) => [s, s, s])} opacity={opacity}>
            <Load3DFile
              fileUrl={currentFile.path}
              scales={currentFile.scales}
              positions={currentFile.positions}
              onLoadComplete={() => setIsLoading(false)} // Set loading to false when model loads
            />
          </a.group>
        </Suspense>
      </Canvas>
    </div>
  );
}

// import { useRef, useState, useEffect, Suspense } from "react";
// import { Mesh } from "three";
// import { Canvas, useFrame, useLoader } from "@react-three/fiber";
// import { OrbitControls } from "@react-three/drei";
// import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
// import { a, useSpring } from "@react-spring/three";
// import { Html, useProgress } from "@react-three/drei";

// // List of objects with file paths and names
// const objectFiles = [
//   { path: "./3d-vh-m-heart.glb", name: "Male Heart", scales: [4, 4, 4], positions: [-0.05, -1.8, 0] },
//   { path: "./3d-vh-m-lung.glb", name: "Lung", scales: [2, 2, 2], positions: [0, -0.9, 0] },
//   { path: "./3d-vh-f-blood-vasculature.glb", name: "Female Blood Vasculature", scales: [2, 2, 2], positions: [0, -0.5, 0]  },
//   { path: "./3d-allen-m-brain.glb", name: "Male Brain", scales: [3.5, 3.5, 3.5], positions: [0, -2.8, 0]},
// ];

// // Loading component to show loading progress
// function Loader() {
//   const { progress } = useProgress();
//   return (
//     <Html center>
//       <div className="text-white">
//         Loading... {Math.floor(progress)}%
//       </div>
//     </Html>
//   );
// }

// function Load3DFile({ fileUrl, scales, positions }: { fileUrl: string, scales: [number, number, number], positions: [number, number, number] }) {
//   const mesh = useRef<Mesh>(null!);
//   const gltf = useLoader(GLTFLoader, fileUrl);

//   useFrame(() => {
//     if (mesh.current) {
//       mesh.current.rotation.y += 0.01; // Slow rotation
//     }
//   });

//   return (
//     <mesh ref={mesh} scale={scales} position={positions}>
//       <primitive object={gltf.scene} />
//     </mesh>
//   );
// }

// export default function Mesh3D() {
//   const [currentFileIndex, setCurrentFileIndex] = useState(0);

//   useEffect(() => {
//     const interval = setInterval(() => {
//       setCurrentFileIndex((prevIndex) => (prevIndex + 1) % objectFiles.length);
//     }, 5000);

//     return () => clearInterval(interval);
//   }, []);

//   const currentFile = objectFiles[currentFileIndex];

//   // Spring for smooth transition when switching files
//   const { opacity, scale } = useSpring({
//     from: { opacity: 0, scale: 0.8 },
//     to: { opacity: 1, scale: 1 },
//     config: { mass: 1, tension: 280, friction: 60 },
//     reset: true,
//   });

//   return (
//     <div className="flex flex-col justify-center items-center h-screen">
//       {/* Display the name of the current file */}
//       <h1 className="text-sm italic text-white my-4 bg-gradient-to-r from-purple-400 via-pink-500 to-red-500 p-2 rounded-lg shadow-lg">
//         {currentFile.name}
//       </h1>

//       <Canvas camera={{ position: [0, 0, 2], fov: 40 }} className="h-2xl w-2xl">
//         <OrbitControls minDistance={1} maxDistance={5} />
//         <ambientLight intensity={0.5} />
//         <directionalLight position={[0, 10, 5]} intensity={1.5} />
//         <pointLight position={[-5, 5, 5]} intensity={1} />
//         <pointLight position={[5, -5, 5]} intensity={1} />
//         <pointLight position={[5, 5, -5]} intensity={1} />

//         {/* Loader component to show while the model is loading */}
//         <Suspense fallback={<Loader />}>
//           {/* Use a tag from react-spring to animate opacity and scale */}
//           <a.group scale={scale.to((s) => [s, s, s])} opacity={opacity}>
//             <Load3DFile
//               fileUrl={currentFile.path}
//               scales={currentFile.scales}
//               positions={currentFile.positions}
//             />
//           </a.group>
//         </Suspense>
//       </Canvas>
//     </div>
//   );
// }

// "use client";

// import { useRef, useState, useEffect } from "react";
// import { Mesh } from "three";
// import { Canvas, useFrame, useLoader } from "@react-three/fiber";
// import { OrbitControls } from "@react-three/drei";
// import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
// import { a, useSpring } from "@react-spring/three";

// // List of objects with file paths and names
// const objectFiles: { path: string, name: string, scales: [number, number, number], positions: [number, number, number] }[] = [
//   { path: "./3d-vh-m-heart.glb", name: "Male Heart", scales: [4, 4, 4], positions: [-0.05, -1.8, 0] },
//   { path: "./3d-vh-m-lung.glb", name: "Lung", scales: [2, 2, 2], positions: [0, -0.9, 0] },
//   { path: "./3d-vh-f-blood-vasculature.glb", name: "Female Blood Vasculature", scales: [2, 2, 2], positions: [0, -0.5, 0]  },
//   { path: "./3d-allen-m-brain.glb", name: "Male Brain", scales: [3.5, 3.5, 3.5], positions: [0, -2.8, 0]},
// ];

// function Load3DFile({ fileUrl, scales, positions }: { fileUrl: string, scales: [number, number, number], positions: [number, number, number] }) {
//   const mesh = useRef<Mesh>(null!);
//   const gltf = useLoader(GLTFLoader, fileUrl);

//   useFrame(() => {
//     if (mesh.current) {
//       mesh.current.rotation.y += 0.01; // Slow rotation
//     }
//   });

//   return (
//     <mesh ref={mesh} scale={scales} position={positions}>
//       <primitive object={gltf.scene} />
//     </mesh>
//   );
// }

// export default function Mesh3D() {
//   const [currentFileIndex, setCurrentFileIndex] = useState(0);

//   useEffect(() => {
//     const interval = setInterval(() => {
//       setCurrentFileIndex((prevIndex) => (prevIndex + 1) % objectFiles.length);
//     }, 5000);

//     return () => clearInterval(interval);
//   }, []);

//   const currentFile = objectFiles[currentFileIndex];

//   // Spring for smooth transition when switching files
//   const { opacity, scale } = useSpring({
//     from: { opacity: 0, scale: 0.8 },
//     to: { opacity: 1, scale: 1 },
//     config: { mass: 1, tension: 280, friction: 60 },
//     reset: true,
//   });

//   return (
//     <div className="flex flex-col justify-center items-center h-screen">
//       {/* Display the name of the current file */}
//       <h1 className="text-sm italic text-white my-4 bg-gradient-to-r from-purple-400 via-pink-500 to-red-500 p-2 rounded-lg shadow-lg">
//         {currentFile.name}
//       </h1>

//       <Canvas camera={{ position: [0, 0, 2], fov: 40 }} className="h-2xl w-2xl">
//         <OrbitControls minDistance={1} maxDistance={5} />
//         <ambientLight intensity={0.5} />
//         <directionalLight position={[0, 10, 5]} intensity={1.5} />
//         <pointLight position={[-5, 5, 5]} intensity={1} />
//         <pointLight position={[5, -5, 5]} intensity={1} />
//         <pointLight position={[5, 5, -5]} intensity={1} />

//         {/* Use a tag from react-spring to animate opacity and scale */}
//         <a.group scale={scale.to((s) => [s, s, s])} opacity={opacity}>
//           <Load3DFile
//             fileUrl={currentFile.path}
//             scales={currentFile.scales}
//             positions={currentFile.positions}
//           />
//         </a.group>
//       </Canvas>
//     </div>
//   );
// }

// export default function Mesh3D() {
//   const [currentFileIndex, setCurrentFileIndex] = useState(0);

//   useEffect(() => {
//     const interval = setInterval(() => {
//       // Cycle through the object files
//       setCurrentFileIndex((prevIndex) => (prevIndex + 1) % objectFiles.length);
//     }, 5000); // Change file every 5 seconds

//     // Clean up interval when the component unmounts
//     return () => clearInterval(interval);
//   }, []);

//   const currentFile = objectFiles[currentFileIndex];

//   return (
//     <div className="flex flex-col justify-center items-center h-screen">
//       {/* Display the name of the current file */}
//       <h1 className="text-sm italic text-white my-4">{currentFile.name}</h1>

//       <Canvas camera={{ position: [0, 0, 2], fov: 40 }} className="h-2xl w-2xl">
//         <OrbitControls minDistance={1} maxDistance={5} />
//         <ambientLight intensity={0.5} />
//         <directionalLight position={[0, 10, 5]} intensity={1.5} />
//         <pointLight position={[-5, 5, 5]} intensity={1} />
//         <pointLight position={[5, -5, 5]} intensity={1} />
//         <pointLight position={[5, 5, -5]} intensity={1} />

//         {/* Load the current 3D object file */}
//         <Load3DFile fileUrl={currentFile.path} scales={currentFile.scales} positions={currentFile.positions}/>
//       </Canvas>
//     </div>
//   );
// }

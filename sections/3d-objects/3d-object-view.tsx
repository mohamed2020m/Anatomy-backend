'use client';
import { useRef, useState, useEffect, Suspense } from 'react';
import { useSession } from 'next-auth/react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Mesh } from 'three';
import { Canvas, useLoader, useFrame } from '@react-three/fiber';
import { OrbitControls, Html, PerspectiveCamera } from '@react-three/drei';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { X, Maximize2, RotateCcw, ZoomIn, ZoomOut } from 'lucide-react';

export default function ThreeDObjectView({ threeDObjectId }: { threeDObjectId: number }) {
  const { data: session, status } = useSession();
  const [objectDetails, setObjectDetails] = useState<any>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [glbUrl, setGlbUrl] = useState<string | null>(null);
  const [isPopupOpen, setIsPopupOpen] = useState(false);
  const [isFullscreen, setIsFullscreen] = useState(false);

  function Load3DFile({ fileUrl, scales, positions, onLoadComplete }: any) {
    const mesh = useRef<Mesh>(null);
    const gltf = useLoader(GLTFLoader, fileUrl);

    useEffect(() => {
      if (gltf) {
        console.log('Détails de l\'objet 3D chargé:', gltf);
        onLoadComplete();
        
        // Centrer l'objet
        if (mesh.current) {
          mesh.current.position.set(0, 0, 0);
        }
      }
    }, [gltf, onLoadComplete]);

    useFrame(() => {
      if (mesh.current) {
        mesh.current.rotation.y += 0.01;
      }
    });

    return (
      <mesh ref={mesh} scale={scales}>
        <primitive object={gltf.scene} position={[0, 0, 0]} />
      </mesh>
    );
  }

  useEffect(() => {
    const fetchDetails = async () => {
      if (status === 'loading') return;

      const token = session?.user?.access_token;
      if (!token) {
        setError('Authentication token not found');
        setIsLoading(false);
        return;
      }

      try {
        const response = await fetch(`http://localhost:8080/api/v1/threeDObjects/${threeDObjectId}`, {
          method: 'GET',
          headers: {
            'Authorization': `Bearer ${token}`,
          },
        });

        if (!response.ok) throw new Error('Failed to fetch object details');

        const data = await response.json();
        setObjectDetails(data);
        setGlbUrl(`http://localhost:8080/api/v1/files/download/objects-f6a51487-47be-4f40-ba06-defff18ee45b.glb`);
        setIsLoading(false);
      } catch (error) {
        setError(error.message || 'An error occurred');
        setIsLoading(false);
      }
    };

    fetchDetails();
  }, [threeDObjectId, session, status]);

  const toggleFullscreen = () => {
    setIsFullscreen(!isFullscreen);
  };

  if (isLoading) return <div className="flex items-center justify-center h-64">
    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
  </div>;

  if (error) return <div className="p-4 bg-red-50 text-red-600 rounded-lg">{error}</div>;

  return (
    <>
      <Card className="mx-auto w-full max-w-4xl shadow-lg">
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="text-2xl font-bold">Objet 3D Détails</CardTitle>
          <Button 
            onClick={() => setIsPopupOpen(true)}
            className="bg-primary hover:bg-primary/90"
          >
            Voir en 3D
          </Button>
        </CardHeader>
        <CardContent>
          <div className="space-y-6">
            {objectDetails ? (
              <div className="grid md:grid-cols-2 gap-6">
                <div className="space-y-4">
                  <h3 className="text-xl font-semibold">{objectDetails.name}</h3>
                  <p className="text-gray-600">{objectDetails.description}</p>
                  <div className="space-y-2">
                    <div className="font-medium">Catégorie</div>
                    <div className="text-gray-600">{objectDetails.professor.category.name}</div>
                  </div>
                </div>
                <div className="flex justify-center items-start">
                  <img
                    src={`http://localhost:8080/api/v1/files/download/${objectDetails.image}`}
                    alt="3D Object"
                    className="w-full max-w-xs rounded-lg shadow-md hover:shadow-xl transition-shadow"
                  />
                </div>
              </div>
            ) : (
              <p>Aucun détail disponible.</p>
            )}
            <div className="flex gap-4 mt-6">
              <Button 
                variant="outline" 
                onClick={() => window.history.back()}
                className="hover:bg-gray-100"
              >
                Retour
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Modal 3D amélioré */}
      {isPopupOpen && (
        <div className="fixed inset-0 z-50 overflow-hidden">
          <div className="absolute inset-0 bg-gray-900/95">
            <div className={`relative mx-auto transition-all duration-300 ${
              isFullscreen ? 'h-screen w-screen' : 'h-[90vh] w-[90vw] mt-[5vh]'
            }`}>
              <div className="bg-gray-800 rounded-lg h-full overflow-hidden shadow-2xl">
                {/* En-tête du modal */}
                <div className="flex items-center justify-between p-4 border-b border-gray-700">
                  <h2 className="text-xl font-semibold text-white">Visualisation 3D - {objectDetails?.name}</h2>
                  <div className="flex gap-2">
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={toggleFullscreen}
                      className="hover:bg-gray-700 text-gray-300"
                    >
                      <Maximize2 className="h-5 w-5" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={() => setIsPopupOpen(false)}
                      className="hover:bg-gray-700 text-gray-300"
                    >
                      <X className="h-5 w-5" />
                    </Button>
                  </div>
                </div>

                {/* Contenu 3D */}
                <div className="relative h-[calc(100%-4rem)] bg-gray-900">
                  <Canvas>
                    <PerspectiveCamera makeDefault position={[0, 0, 5]} fov={50} />
                    <OrbitControls 
                      minDistance={2} 
                      maxDistance={10}
                      enableDamping
                      dampingFactor={0.05}
                      target={[0, 0, 0]}
                    />
                    <ambientLight intensity={0.5} />
                    <directionalLight position={[0, 10, 5]} intensity={1.5} />
                    <pointLight position={[-5, 5, 5]} intensity={1} />
                    <pointLight position={[5, -5, 5]} intensity={1} />
                    <pointLight position={[5, 5, -5]} intensity={1} />
                    
                    {isLoading && (
                      <Html center>
                        <div className="bg-gray-800 text-white px-4 py-2 rounded-lg">
                          Chargement...
                        </div>
                      </Html>
                    )}
                    
                    {glbUrl && (
                      <Suspense fallback={null}>
                        <Load3DFile
                          fileUrl={glbUrl}
                          scales={[2, 2, 2]}
                          onLoadComplete={() => setIsLoading(false)}
                        />
                      </Suspense>
                    )}
                  </Canvas>

                  {/* Contrôles flottants */}
                  <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2 bg-gray-800 rounded-full shadow-lg p-2 flex gap-2">
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="text-gray-300 hover:bg-gray-700 hover:text-white"
                      title="Réinitialiser la rotation"
                    >
                      <RotateCcw className="h-5 w-5" />
                    </Button>
                    <div className="w-px bg-gray-700" />
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="text-gray-300 hover:bg-gray-700 hover:text-white"
                      title="Zoom avant"
                    >
                      <ZoomIn className="h-5 w-5" />
                    </Button>
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="text-gray-300 hover:bg-gray-700 hover:text-white"
                      title="Zoom arrière"
                    >
                      <ZoomOut className="h-5 w-5" />
                    </Button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
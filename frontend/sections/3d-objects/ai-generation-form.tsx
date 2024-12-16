'use client';

import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Label } from '@/components/ui/label';
import { Alert, AlertTitle, AlertDescription } from '@/components/ui/alert';
import { CirclePlus, Eye, FileDown } from 'lucide-react';
import { useSession } from 'next-auth/react';
import { useForm } from 'react-hook-form';
import { toast } from '@/components/ui/use-toast';

import {
  uploadFile,
  createThreeDObject,
  pollModelStatus,
  storeImageTemporarily,
  storeModelTemporarily,
  fetchTempImage,
  fetchTempGlb,
  uploadFilesSpring,
  testPost
} from './ai-generation';
import { BlurPageLoader } from './blur-page-loader';

import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle
} from '@/components/ui/dialog';
import ThreeDObjectView from './Load3DFile';

const MESHY_API_TOKEN = 'msy_ll3cT4DEdm9QxtfoinlxmDNd9xCFIRKzcawf';
const MESHY_API_URL = 'https://api.meshy.ai/v1';

const AiGenerationForm = () => {
  const { data: session } = useSession();
  const userId = session?.user?.id;

  const [loading, setLoading] = useState(false);
  const [modelUrl, setModelUrl] = useState('');
  const [error, setError] = useState('');
  const [showViewer, setShowViewer] = useState(false);
  const [formData, setFormData] = useState({
    imageUrl: '',
    description: '',
    name: ''
  });

  const [imageTempUrl, setImageTempUrl] = useState('');
  const [modelTempUrl, setModelTempUrl] = useState('');
  /*
  const [imagePath, setImagePath] = useState('');
  const [objectPath, setObjectPath] = useState('');
  */

  

  const handleUploadModel = async () => {
    try {
      const access_token = session?.user?.access_token;
      if (!access_token) {
        throw new Error('Non autorisé');
      }

      console.log('Access Token:', access_token);
      console.log('Modèle Image Path:', imageTempUrl);
      console.log('Modèle Model Path:', modelTempUrl);

      // Vérification des URLs avant de les manipuler
      if (!imageTempUrl || !modelTempUrl) {
        throw new Error("URLs de modèle ou d'image manquantes");
      }

      const ModelName = modelTempUrl.split('/').pop();
      const ImageName = imageTempUrl.split('/').pop();

      console.log('Model Name:', ModelName);
      console.log('Image Name:', ImageName);

      if (ImageName && ModelName) {
        // Utilisation de Promise.all pour récupérer les fichiers simultanément
        const [modelFile, imageFile] = await Promise.all([
          fetchTempGlb(ModelName),
          fetchTempImage(ImageName)
        ]);

        // Gestion des erreurs possibles lors de l'upload
        if (!modelFile || !imageFile) {
          throw new Error('Échec du téléchargement des fichiers');
        }

        // Upload des fichiers avec les bons paramètres
        const [imagePath, objectPath] = await Promise.all([
          uploadFilesSpring(imageFile, access_token, 'image'),
          uploadFilesSpring(modelFile, access_token, 'objects')
        ]);

        console.log("ImagePath",imagePath);
        console.log("ImagePath",objectPath);

        const threeDObjectData = {
          name: formData.name,
          description: formData.description,
          image: imagePath.replace('/', '-'),
          object: objectPath.replace('/', '-'),
          professor: {
            id: userId
          }
        };

        createThreeDObject(threeDObjectData, access_token)
          .then((response) => {
            console.log('3D object created successfully:', response);
          })
          .catch((error) => {
            console.error('Error creating 3D object:', error);
          });
      } else {
        console.error('ImageName ou ModelName est indéfini.');
      }
    } catch (error) {
      console.error("Erreur lors de l'upload du modèle :", error);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value
    }));
    setError('');
  };

  const validateForm = () => {
    if (!formData.imageUrl) {
      setError("L'URL de l'image est requise");
      return false;
    }
    try {
      new URL(formData.imageUrl);
    } catch {
      setError("L'URL de l'image n'est pas valide");
      return false;
    }
    if (!formData.description) {
      setError('La description est requise');
      return false;
    }
    if (!formData.name) {
      setError('Le nom est requis');
      return false;
    }
    return true;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) return;

    try {
      setLoading(true);
      setError('');
      setModelUrl('');
      setModelTempUrl('');

      const tempImageUrl = await storeImageTemporarily(formData.imageUrl);

      console.log('Temporary Image URL:', tempImageUrl);
      setImageTempUrl(tempImageUrl);
      console.log('Image Temporaire apres set:', imageTempUrl);

      const response = await fetch(`${MESHY_API_URL}/image-to-3d`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${MESHY_API_TOKEN}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          image_url: formData.imageUrl,
          enable_pbr: true,
          surface_mode: 'hard'
        })
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData?.message || 'Échec de la requête initiale');
      }

      const data = await response.json();
      if (!data.result) {
        throw new Error('ID de résultat manquant dans la réponse');
      }

      const url = await pollModelStatus(data.result);
      setModelUrl(url);

      const modelUrl = await storeModelTemporarily(url);
      setModelTempUrl(modelUrl);
      console.log('Model Temporaire apres set:', modelTempUrl);
    } catch (error) {
      console.error('Erreur:', error);
      setError(error.message || 'Une erreur est survenue');
    } finally {
      setLoading(false);
    }
  };

  const handleViewModel = async () => {
    console.log('Current File Path:', modelTempUrl);
    try {
      setShowViewer(true);
    } catch (error) {
      console.error('Erreur dans handleViewModel:', error);
      setError(error.message);
    }
  };


  return (
    <>
      {loading ? (
        <BlurPageLoader />
      ) : (
        <>
          <Card className="mx-auto w-full max-w-2xl">
            <CardHeader>
              <CardTitle className="text-left text-2xl font-bold">
                Générateur de Modèle 3D
              </CardTitle>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleSubmit} className="space-y-6">
                {error && (
                  <Alert variant="destructive">
                    <AlertTitle>Erreur</AlertTitle>
                    <AlertDescription>{error}</AlertDescription>
                  </Alert>
                )}

                <div className="space-y-2">
                  <Label htmlFor="imageUrl">URL de l'image</Label>
                  <Input
                    id="imageUrl"
                    name="imageUrl"
                    type="url"
                    placeholder="https://exemple.com/image.jpg"
                    value={formData.imageUrl}
                    onChange={handleInputChange}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="description">Description</Label>
                  <Textarea
                    id="description"
                    name="description"
                    placeholder="Décrivez l'objet 3D souhaité"
                    className="resize-none"
                    value={formData.description}
                    onChange={handleInputChange}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="name">Nom</Label>
                  <Input
                    id="name"
                    name="name"
                    placeholder="Nom du modèle"
                    value={formData.name}
                    onChange={handleInputChange}
                  />
                </div>

                <div className="flex gap-4">
                {!modelUrl && (
                  <Button type="submit" className="flex-1" disabled={loading}>
                    {loading ? 'Génération...' : 'Générer'}
                  </Button>)
                  }

                  {modelUrl && (
                    <>
                      <Button
                        type="button"
                        className="flex-1"
                        onClick={handleUploadModel}
                      >
                        <CirclePlus className="h-4 w-4" /> {''}
                      </Button>
                      <Button
                        type="button"
                        variant="secondary"
                        className="flex-1"
                        onClick={() => window.open(modelUrl, '_blank')}
                      >
                        <FileDown className="h-4 w-4" />{' '}
                      </Button>

                      <Button
                        type="button"
                        variant="secondary"
                        className="flex-1"
                        onClick={handleViewModel}
                      >
                        <Eye className="h-4 w-4" />{' '}
                      </Button>
                    </>
                  )}
                </div>
              </form>
            </CardContent>
          </Card>

          <Dialog open={showViewer} onOpenChange={setShowViewer}>
            <DialogContent className="h-[80vh] max-w-4xl">
              <DialogHeader>
                <DialogTitle>Visualisation 3D</DialogTitle>
              </DialogHeader>
              <div className="relative h-full w-full">
                <ThreeDObjectView
                  fileUrl={`${modelTempUrl}`}
                  scales={[1, 1, 1]}
                  positions={[0, 0, 0]}
                />
              </div>
            </DialogContent>
          </Dialog>
        </>
      )}
    </>
  );
};

export default AiGenerationForm;

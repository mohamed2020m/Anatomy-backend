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
  storeFileTemporarily,
  fetchTempImage,
  fetchTempGlb
} from './ai-generation';
import { BlurPageLoader } from './blur-page-loader';

import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle
} from '@/components/ui/dialog';
import ThreeDObjectView from './Load3DFile';

const MESHY_API_TOKEN = 'msy_oKkPyfAgt72h3PXdhyueB2RUSDIy3MVGwK3O';
const MESHY_API_URL = 'https://api.meshy.ai/v1';

const AiGenerationForm = () => {
  const [loading, setLoading] = useState(false);
  const [modelUrl, setModelUrl] = useState('');
  const [tempFileUrl, setTempFileUrl] = useState('');
  const [error, setError] = useState('');
  const [showViewer, setShowViewer] = useState(false);
  const [formData, setFormData] = useState({
    imageUrl: '',
    description: '',
    name: ''
  });
  const { data: session } = useSession();
  const userId = session?.user?.id; // Récupération de l'ID de l'utilisateur

  const handleUploadModel = async () => {
    try {
      const access_token = session?.user?.access_token;
      if (!access_token) {
        throw new Error('Non autorisé');
      }

      // Récupérer les fichiers temporaires
      const image = await fetchTempImage('image_1732176947173.png');
      const glb = await fetchTempGlb('model_1732177099951.glb');

      // Effectuer les uploads simultanés avec `Promise.all`
      const [imagePath, objectPath] = await Promise.all([
        uploadFile(image, access_token, 'image'),
        uploadFile(glb, access_token, 'objects')
      ]);

      // Préparer les données pour la création de l'objet 3D
      const threeDObjectData = {
        name: formData.name,
        description: formData.description,
        image: imagePath.replace('/', '-'),
        object: objectPath.replace('/', '-'),
        professor: { id: userId }
      };

      // Créer l'objet 3D sur le backend
      const res = await createThreeDObject(threeDObjectData, access_token);

      toast({
        title: 'Succès',
        description: res.message,
        variant: 'success'
      });
    } catch (error) {
      toast({
        title: 'Erreur',
        description:
          (error as Error)?.message || "Échec de la création de l'objet 3D.",
        variant: 'destructive'
      });
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
      setTempFileUrl('');

      const tempImageUrl = await storeImageTemporarily(formData.imageUrl);
      console.log('Temporary Image URL:', tempImageUrl);

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

      const fileUrl = await storeFileTemporarily(url);
      setTempFileUrl(fileUrl);
    } catch (error) {
      console.error('Erreur:', error);
      setError(error.message || 'Une erreur est survenue');
    } finally {
      setLoading(false);
    }
  };

  const handleViewModel = async () => {
    console.log('Current File Path:', tempFileUrl);
    try {
      setShowViewer(true);
    } catch (error) {
      console.error('Erreur dans handleViewModel:', error);
      setError(error.message);
    }
  };

  //Create

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
                  <Button type="submit" className="flex-1" disabled={loading}>
                    {loading ? 'Génération...' : 'Générer'}
                  </Button>

                  {modelUrl && (
                    <>
                      <Button
                        type="button"
                        className="flex-1"
                        onClick={handleUploadModel}
                      >
                        <CirclePlus className="h-4 w-4" /> {'Soumettre'}
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
                  fileUrl={`${tempFileUrl}`}
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

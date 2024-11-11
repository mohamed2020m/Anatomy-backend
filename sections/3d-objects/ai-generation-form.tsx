'use client';

import React, { useEffect, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { useForm } from 'react-hook-form';
import { useToast } from '@/components/ui/use-toast';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';

const formSchema = z.object({
  imageUrl: z.string().url({ message: "Une URL d'image valide est requise" }),
  description: z.string().min(1, "La description est requise"),
  name: z.string().min(1, "Le nom est requis")
});


const MESHY_API_TOKEN = `${process.env.NEXT_PUBLIC_MESHY_API_TOKEN}`;

const MESHY_API_URL = "https://api.meshy.ai/v1";

const AiGenerationForm = () => {
  const [loading, setLoading] = useState(false);
  const [modelUrl, setModelUrl] = useState("");
  const { toast } = useToast();

  const form = useForm({
    resolver: zodResolver(formSchema),
    defaultValues: {
      imageUrl: "",
      description: "",
      name: ""
    }
  });

  const pollModelStatus = async (resultId) => {
    try {
      const maxAttempts = 40;
      const pollInterval = 7000; // 7 seconds instead of 700000, as 700000ms is too long for polling.

      for (let attempt = 0; attempt < maxAttempts; attempt++) {
        const response = await fetch(`${MESHY_API_URL}/image-to-3d/${resultId}`, {
          headers: {
            'Authorization': `Bearer ${MESHY_API_TOKEN}`,
            'Accept': 'application/json'
          }
        });

        if (!response.ok) {
          throw new Error(`Erreur HTTP: ${response.status}`);
        }

        const data = await response.json();
        console.log('Reponse GET:', data.status);

        if (data.status.toLowerCase() === 'succeeded') {
          return data.model_url;
        } else if (data.status.toLowerCase() === 'failed') {
          throw new Error('La génération du modèle 3D a échoué');
        }

        // Attendre avant la prochaine tentative
        await new Promise(resolve => setTimeout(resolve, pollInterval));
      }

      throw new Error('Délai d\'attente dépassé');
    } catch (error) {
      console.error('Erreur lors de la vérification du statut:', error);
      throw error;
    }
  };

  const fetchModelUrl = async (resultId) => {
    try {
      const modelUrl = await pollModelStatus(resultId);
      console.log(modelUrl);
      setModelUrl(modelUrl);
    } catch (error) {
      console.error("Error fetching model URL:", error);
    }
  };

  const generate3DModel = async (values) => {
    if (!MESHY_API_TOKEN) {
      toast({
        title: 'Erreur de configuration',
        description: 'Token API manquant',
        variant: 'destructive',
      });
      return;
    }

    try {
      setLoading(true);
      setModelUrl("");

      const response = await fetch(`${MESHY_API_URL}/image-to-3d`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${MESHY_API_TOKEN}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          image_url: values.imageUrl,
          enable_pbr: true,
          surface_mode: "hard"
        })
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => null);
        throw new Error(errorData?.message || 'Échec de la requête initiale');
      }

      const data = await response.json();

      if (!data.result) {
        throw new Error('ID de résultat manquant dans la réponse');
      }

      console.log(data.result);

      await fetchModelUrl(data.result);
      
      toast({
        title: 'Succès',
        description: 'Modèle 3D généré avec succès!',
      });
    } catch (error) {
      console.error('Erreur de génération:', error);
      toast({
        title: 'Erreur',
        description: error.message || 'Échec de la génération du modèle 3D',
        variant: 'destructive',
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card className="mx-auto w-full max-w-2xl">
      <CardHeader>
        <CardTitle className="text-left text-2xl font-bold">
          Générateur de Modèle 3D
        </CardTitle>
      </CardHeader>
      <CardContent>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(generate3DModel)} className="space-y-6">
            <FormField
              control={form.control}
              name="imageUrl"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>URL de l'image</FormLabel>
                  <FormControl>
                    <Input
                      placeholder="https://exemple.com/image.jpg"
                      {...field}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            
            <FormField
              control={form.control}
              name="description"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Description</FormLabel>
                  <FormControl>
                    <Textarea
                      placeholder="Décrivez l'objet 3D souhaité"
                      className="resize-none"
                      {...field}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            
            <FormField
              control={form.control}
              name="name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Nom</FormLabel>
                  <FormControl>
                    <Input
                      placeholder="Nom du modèle"
                      {...field}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <div className="flex space-x-4">
              <Button
                type="submit"
                disabled={loading}
                className="flex-1"
              >
                {loading ? 'Génération en cours...' : 'Générer'}
              </Button>
              
              {modelUrl && (
                <Button
                  type="button"
                  variant="secondary"
                  className="flex-1"
                  onClick={() => window.open(modelUrl, '_blank')}
                >
                  Voir le modèle
                </Button>
              )}
            </div>
          </form>
        </Form>
      </CardContent>
    </Card>
  );
};

export default AiGenerationForm;

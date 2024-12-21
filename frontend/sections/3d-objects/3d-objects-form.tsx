'use client';

import * as React from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import { useState } from 'react';
import ReactMarkdown from 'react-markdown';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue
} from '@/components/ui/select';
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { FileUploader } from '@/components/file-uploader';
import { toast } from '@/components/ui/use-toast';
import { useSession } from 'next-auth/react';
import { EyeIcon, Edit2Icon } from 'lucide-react';
import { descriptionModels } from '@/constants/data';

const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`;

const MAX_FILE_SIZE = 500000000000;
const ACCEPTED_IMAGE_TYPES = [
  'image/jpeg',
  'image/jpg',
  'image/png',
  'image/webp'
];

const ACCEPTED_3D_TYPES = [
  'model/gltf-binary',
  'model/gltf+json',
  '.glb',
  '.gltf'
];

const formSchema = z.object({
  name: z.string().min(2, {
    message: 'Le nom doit contenir au moins 2 caractères.'
  }),
  description: z
    .string({
      required_error: "Veuillez ajouter une description pour l'objet 3D."
    })
    .max(15000, {
      message: 'La description ne doit pas dépasser 15000 caractères.'
    }),
  image: z
    .any()
    .refine((files) => files?.length == 1, "L'image est requise.")
    .refine(
      (files) => files?.[0]?.size <= MAX_FILE_SIZE,
      `La taille maximum du fichier est 5MB.`
    )
    .refine(
      (files) => ACCEPTED_IMAGE_TYPES.includes(files?.[0]?.type),
      'Formats acceptés: .jpg, .jpeg, .png et .webp'
    ),
  object: z
    .any()
    .refine((files) => files?.length == 1, 'Le fichier 3D est requis.')
    .refine(
      (files) => files?.[0]?.size <= MAX_FILE_SIZE,
      `La taille maximum du fichier est 5MB.`
    )
    .refine((files) => {
      const fileType = files?.[0]?.type;
      const fileName = files?.[0]?.name;
      return ACCEPTED_3D_TYPES.some(
        (type) => fileType === type || fileName.toLowerCase().endsWith(type)
      );
    }, 'Formats acceptés: .glb, .gltf')
});

const ThreeDObjectsForm = () => {
  const { data: session } = useSession();
  const userId = session?.user?.id; // Récupération de l'ID de l'utilisateur
  const [isPreviewMode, setIsPreviewMode] = useState(false);
  const [selectedModel, setSelectedModel] = useState<string>('llama3-8b-8192'); 

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: '',
      description: '',
      image: null,
      object: null,
      professor: null
    }
  });

  const [generatedDescription, setGeneratedDescription] = useState('');

  const uploadFile = async (
    file: File,
    token: string,
    type: 'image' | 'objects'
  ) => {
    try {
      const formData = new FormData();
      formData.append('file', file);

      const response = await fetch(`${API_URL}/files/upload`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`
        },
        body: formData
      });

      if (!response.ok) {
        throw new Error(`Échec de l'upload du fichier ${type}`);
      }

      const data = await response.json();
      return data.path;
    } catch (error) {
      console.error(`Erreur lors de l'upload du fichier ${type}:`, error);
      throw error;
    }
  };

  const createThreeDObject = async (
    data: {
      id: number;
      name: string;
      description: string;
      image: string;
      object: string;
      professor: any;
    },
    token: string
  ) => {
    try {
      const response = await fetch(`${API_URL}/threeDObjects`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      });

      if (!response.ok) {
        throw new Error("Échec de la création de l'objet 3D");
      }

      return await response.json();
    } catch (error) {
      console.error("Erreur lors de la création de l'objet 3D:", error);
      throw error;
    }
  };

  const onSubmit = async (values: z.infer<typeof formSchema>) => {
    try {
      const access_token = session?.user?.access_token;
      if (!access_token) {
        throw new Error('Non autorisé');
      }

      const [imagePath, objectPath] = await Promise.all([
        uploadFile(values.image[0], access_token, 'image'),
        uploadFile(values.object[0], access_token, 'objects')
      ]);

      const threeDObjectData = {
        id: 10,
        name: values.name,
        description: values.description,
        image: imagePath.replace('/', '-'),
        object: objectPath.replace('/', '-'),
        professor: {
          id: userId
        }
      };

      const res = await createThreeDObject(threeDObjectData, access_token);

      toast({
        title: 'Succès',
        description: res.message,
        variant: 'success'
      });

      form.reset();
      setGeneratedDescription('');
    } catch (error) {
      toast({
        title: 'Erreur',
        description:
          (error as Error)?.message || "Échec de la création de l'objet 3D.",
        variant: 'destructive'
      });
    }
  };

  const handleGenerateDescription = async () => {
    if (!form.getValues('image') || form.getValues('image').length === 0) {
      toast({
        title: 'Erreur',
        description: 'Veuillez télécharger une image',
        variant: 'destructive'
      });
      return;
    }

    const formData = new FormData();
    const imageFile = form.getValues('image')[0];
    formData.append('obj', imageFile);

    console.log(formData);

    try {
      const response = await fetch(`${process.env.MODEL_API}/object_3d-to-text`, {
        method: 'POST',
        headers: {},
        body: formData
      });

      if (!response.ok) {
        toast({
          title: 'Erreur',
          description: 'Une erreur est survenue',
          variant: 'destructive'
        });
      }

      const data = await response.json();
      console.log('Reponse de l api:', data);
      setGeneratedDescription(data.description);
      console.log('Genereted Desc:', generatedDescription);
      form.setValue('description', generatedDescription);
      console.log('debug:', form.getFieldState);
    } catch (error) {
      console.error('Erreur lors de la génération de la description', error);
      toast({
        title: 'Erreur',
        description: 'Une erreur est survenue',
        variant: 'destructive'
      });
    }
  };

  return (
    <Card className="mx-auto w-full">
      <CardHeader>
        <CardTitle className="text-left text-2xl font-bold">
          3D Object Information
        </CardTitle>
      </CardHeader>
      <CardContent>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
            <FormField
              control={form.control}
              name="name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Name</FormLabel>
                  <FormControl>
                    <Input
                      placeholder="Give your object a name ..."
                      {...field}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="image"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Image</FormLabel>
                  <FormControl>
                    <FileUploader
                      value={field.value}
                      onValueChange={field.onChange}
                      maxFiles={1}
                      maxSize={MAX_FILE_SIZE}
                      accept={ACCEPTED_IMAGE_TYPES.join(',')}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="object"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>3D Model(.glb, .gltf)</FormLabel>
                  <FormControl>
                    <FileUploader
                      value={field.value}
                      onValueChange={field.onChange}
                      maxFiles={1}
                      maxSize={MAX_FILE_SIZE}
                      accept=".glb,.gltf"
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <div className="w-full max-w-4xl space-y-4">
              <div className="flex flex-col gap-2">
                <label className="text-sm font-medium">
                Choose the model to generate a description
                </label>
                <Select
                  value={selectedModel}
                  onValueChange={(value) => setSelectedModel(value)}
                >
                  <SelectTrigger className="w-[240px]">
                    <SelectValue>
                      {selectedModel || 'Select a model'}
                    </SelectValue>
                  </SelectTrigger>
                  <SelectContent>
                    {descriptionModels.map((model) => (
                      <SelectItem key={model.value} value={model.value}>
                        {model.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div><br/>
              <FormField
                control={form.control}
                name="description"
                render={({ field }) => (
                  <FormItem>
                    <div className="mb-2 flex items-center justify-between">
                      <FormLabel className="text-sm font-medium">
                        3D Model Description
                      </FormLabel>
                      <div className="flex gap-2">
                        <Button
                          type="button"
                          variant="outline"
                          onClick={() => setIsPreviewMode(!isPreviewMode)}
                          className="flex items-center gap-2"
                        >
                          {isPreviewMode ? (
                            <>
                              <Edit2Icon className="h-4 w-4" />
                              Edit Mode
                            </>
                          ) : (
                            <>
                              <EyeIcon className="h-4 w-4" />
                              Preview
                            </>
                          )}
                        </Button>
                        <Button
                          type="button"
                          onClick={handleGenerateDescription}
                          className="flex items-center gap-2"
                        >
                          <EyeIcon className="h-4 w-4" />
                          Generate
                        </Button>
                      </div>
                    </div>
                    <FormControl>
                      <div className="min-h-[500px] rounded-md border">
                        {isPreviewMode ? (
                          <div className="prose min-h-[500px] max-w-none overflow-y-auto p-4">
                            <ReactMarkdown>
                              {field.value || generatedDescription || ''}
                            </ReactMarkdown>
                          </div>
                        ) : (
                          <Textarea
                            placeholder="Enter the detailed description of the 3D object ..."
                            className="min-h-[500px] border-0 p-4 text-base"
                            {...field}
                            value={field.value || generatedDescription}
                          />
                        )}
                      </div>
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
            <Button type="submit">Submit</Button>
          </form>
        </Form>
      </CardContent>
    </Card>
  );
};

export default ThreeDObjectsForm;

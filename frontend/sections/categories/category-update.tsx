'use client';

import * as React from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { FileUploader } from '@/components/file-uploader';
import { toast } from '@/components/ui/use-toast';
import { useSession } from 'next-auth/react';
import { useEffect, useState } from 'react';
import Image from 'next/image';
import { useRouter } from 'next/navigation';

// const APP_URL = 'http://localhost:8080/api/v1';
const APP_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`

const MAX_FILE_SIZE = 5000000;
const ACCEPTED_IMAGE_TYPES = ['image/jpeg', 'image/jpg', 'image/png'];

// const formSchema = z.object({
//   name: z.string().min(2, {
//     message: 'Name must be at least 2 characters.',
//   }),
//   description: z.string({
//     required_error: 'Please select category description.',
//   }),
//   image: z
//     .any()
//     .refine((files) => files?.length === 1, 'Image is required.')
//     .refine((files) => files?.[0]?.size <= MAX_FILE_SIZE, `Max file size is 5MB.`)
//     .refine((files) => ACCEPTED_IMAGE_TYPES.includes(files?.[0]?.type), '.jpg, .jpeg, .png and .webp files are accepted.'),
// });

const formSchema = z.object({
  name: z.string().min(2, {
    message: 'Name must be at least 2 characters.',
  }).optional(),
  description: z.string().max(255, {
    message: 'Description must not be more than 255 characters.'
  }).optional(),
  image: z
    .any()
    .refine((files) => !files || files.length <= 1, 'You can upload a maximum of 1 image.') // Allow no image or one image
    .refine((files) => !files || (files[0]?.size <= MAX_FILE_SIZE), `Max file size is 5MB.`)
    .refine((files) => !files || (ACCEPTED_IMAGE_TYPES.includes(files?.[0]?.type)), '.jpg, .jpeg, .png and .webp files are accepted.')
    .optional(),

  // image: z
  //   .any()
  //   .refine((files) => files?.length <= 1, 'You can upload a maximum of 1 image.') // Allow no image
  //   .refine((files) => files?.[0]?.size <= MAX_FILE_SIZE, `Max file size is 5MB.`)
  //   .refine((files) => ACCEPTED_IMAGE_TYPES.includes(files?.[0]?.type), '.jpg, .jpeg, .png and .webp files are accepted.')
  //   .optional(), 
});


export default function CategoryUpdate({ categoryId }: { categoryId: number }) {
  const { data: session } = useSession();
  const [isLoading, setIsLoading] = useState(true);
  const [initialData, setInitialData] = useState<{name: string; description: string; image: string } | null>(null);
  const [newImageSelected, setNewImageSelected] = useState(false); // State to track if a new image is selected
  const router = useRouter();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: '',
      description: '',
      image: null,
    },
  });

  // Fetch category data by id and populate form
  useEffect(() => {
    const fetchCategory = async () => {
      console.log("categoryId: ", categoryId);
      const token = session?.user?.access_token;
      if (!token) {
        throw new Error('Unauthorized');
      }
      try {
        const response = await fetch(`${APP_URL}/categories/${categoryId}`, {
          method: 'GET',
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch category data.');
        }

        const category = await response.json();
        setInitialData({
          name: category.name,
          description: category.description,
          image: category.image, // Image name (filename stored in DB)
        });
        form.reset({
          name: category.name,
          description: category.description,
          image: null,
        });
      } catch (error) {
        toast({
          title: 'Error',
          description: (error as Error)?.message || 'Failed to fetch category.',
          variant: 'destructive',
        });
      } finally {
        setIsLoading(false);
      }
    };

    fetchCategory();
  }, [categoryId, session, form]);

  async function uploadImage(file: File, token: string) {
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(`${APP_URL}/files/upload`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
      },
      body: formData,
    });

    if (!response.ok) {
      throw new Error('Image upload failed');
    }

    const data = await response.json();
    return data.path; 
  }

  async function updateCategory(data: {id: number, name: string; description: string; image: string }, token: string) {
    const response = await fetch(`${APP_URL}/categories/${data.id}`, {
      method: 'PUT',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      throw new Error('Failed to update category');
    }

    return await response.json();
  }

  // Function to delete the old image
  async function deleteOldImage(oldImagePath: string, access_token: string) {
    const deleteUrl = `${APP_URL}/files/delete/${oldImagePath}`;
    const response = await fetch(deleteUrl, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${access_token}`,
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error('Failed to delete the old image');
    }
  }

  async function onSubmit(values: z.infer<typeof formSchema>) {
    try {
      const access_token = session?.user?.access_token;
      if (!access_token) {
        throw new Error('Unauthorized');
      }

      let imagePath = initialData?.image || '';

      // Check if a new image is provided and if it is different from the old one
      if (values.image?.[0] && values.image[0].name !== initialData?.image) {
        // Call the delete API for the old image
        if (initialData?.image) {
          await deleteOldImage(initialData.image, access_token);
        }
        // Upload the new image
        imagePath = await uploadImage(values.image[0], access_token);
        
        console.log("imagePath: ", imagePath);
      }

      const categoryData = {
        id: categoryId,
        name: values.name,
        description: values.description,
        image: imagePath.replace("/", "-")
      };

      console.log(categoryData);

      const res = await updateCategory(categoryData, access_token);
      
      toast({
        title: 'Success',
        description: res.message,
        variant: 'success',
      });

      // router.refresh()
      // router.push('/dashboard/categories');
    } catch (error) {
      console.error("Error: ", error);
      toast({
        title: 'Error',
        description: (error as Error)?.message || 'Failed to update category.',
        variant: 'destructive',
      });
    }
  }

  // Handle image selection
  const handleImageChange = (files: File[]) => {
    if (files.length > 0) {
      setNewImageSelected(true);
    } else {
      setNewImageSelected(false);
    }
    form.setValue('image', files);
  };

  if (isLoading) {
    return <p>Loading...</p>; // Add a loader if needed
  }

  return (
    <Card className="mx-auto w-full">
      <CardHeader>
        <CardTitle className="text-left text-2xl font-bold">Update Category</CardTitle>
      </CardHeader>
      <CardContent>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
            {/* <div className="grid grid-cols-1 gap-6 md:grid-cols-2"> */}
            <div className={`grid ${!newImageSelected && 'grid-cols-1 gap-6 md:grid-cols-2'}`}>
              {initialData?.image && !newImageSelected && ( // Show current image only if no new image is selected
                <div>
                  <FormLabel className="">Current Image</FormLabel>
                  <div className="mb-4 flex items-center justify-center h-full">
                    <div>
                      <Image
                        src={`${APP_URL}/files/download/${initialData.image}`}
                        alt={`${initialData.image}`}
                        className="w-32 h-32 object-cover"
                        width={250}
                        height={250}
                      />
                    </div>
                  </div>
                </div>
              )}
              <FormField
                control={form.control}
                name="image"
                render={({ field }) => (
                  <FormItem className="w-full">
                    <FormLabel>Image</FormLabel>
                    <FormControl>
                      <FileUploader
                        value={field.value}
                        onValueChange={handleImageChange}
                        maxFiles={1}
                        maxSize={5 * 1024 * 1024}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
            <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
              <FormField
                control={form.control}
                name="name"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Name</FormLabel>
                    <FormControl>
                      <Input placeholder="Enter category name" {...field} />
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
                      <Textarea placeholder="Enter category description" className="resize-none" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
            <Button type="submit">Update Category</Button>
          </form>
        </Form>
      </CardContent>
    </Card>
  );
}

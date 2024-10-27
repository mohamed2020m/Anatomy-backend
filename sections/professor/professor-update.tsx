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

//const APP_URL = `${process.env.BACKEND_API}/api/v1`
const APP_URL = 'http://localhost:8080/api/v1';



// Define schema based
const formSchema = z.object({
  firstName: z.string().min(2, { message: 'First name must be at least 2 characters.' }),
  lastName: z.string().min(2, { message: 'Last name must be at least 2 characters.' }),
  email: z.string().email({ message: 'Please enter a valid email address.' }),
  password: z.string().min(6, { message: 'Password must be at least 6 characters.' }),
});


export default function ProfessorUpdate({ professorId }: { professorId: number }) {
  const { data: session } = useSession();
  const [isLoading, setIsLoading] = useState(true);
  const [initialData, setInitialData] = useState<{ firstName: string; lastName: string; email: string; password: string } | null>(null);
  const router = useRouter();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      firstName: '',
      lastName: '',
      email: '',
      password: ''
    }
  });

  // Fetch professor data by id and populate form
  useEffect(() => {
    const fetchProfessor = async () => {
      const token = session?.user?.access_token;
      if (!token) {
        throw new Error('Unauthorized');
      }
      try {
        const response = await fetch(`${APP_URL}/professors/${professorId}`, {
          method: 'GET',
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch professor data.');
        }

        const professor = await response.json();
        setInitialData({
          firstName: professor.firstName,
          lastName: professor.lastName,
          email: professor.email,
          password: professor.password,
        });
        form.reset({
          firstName: professor.firstName,
          lastName: professor.lastName,
          email: professor.email,
          password: professor.password,
        });
      } catch (error) {
        toast({
          title: 'Error',
          description: (error as Error)?.message || 'Failed to fetch professor.',
          variant: 'destructive',
        });
      } finally {
        setIsLoading(false);
      }
    };

    fetchProfessor();
  }, [professorId, session, form]);



  async function updateProfessor(data: { firstName: string; lastName: string; email: string; password: string }, token: string) {
    const response = await fetch(`${APP_URL}/professors`, {
      method: 'PUT',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      throw new Error('Failed to update professor');
    }

    return await response.json();
  }


  async function onSubmit(values: z.infer<typeof formSchema>) {
    try {
      const access_token = session?.user?.access_token;
      if (!access_token) {
        throw new Error('Unauthorized');
      }

      // Prepare professor data
      const professorData = {
        firstName: values.firstName,
        lastName: values.lastName,
        email: values.email,
        password: values.password
      };

      console.log(professorData);

      const res = await updateProfessor(professorData, access_token);
      
      toast({
        title: 'Success',
        description: res.message,
        variant: 'success',
      });


    } catch (error) {
      toast({
        title: 'Error',
        description: (error as Error)?.message || 'Failed to update professor.',
        variant: 'destructive',
      });
    }
  }


  if (isLoading) {
    return <p>Loading...</p>; // Add a loader if needed
  }

  return (
    <Card className="mx-auto w-full">
      <CardHeader>
        <CardTitle className="text-left text-2xl font-bold">Update Information</CardTitle>
      </CardHeader>
      <CardContent>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
            <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
              <FormField
                control={form.control}
                name="firstName"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>First Name</FormLabel>
                    <FormControl>
                      <Input placeholder="Enter first name" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="lastName"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Last Name</FormLabel>
                    <FormControl>
                      <Input placeholder="Enter last name" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="email"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Email</FormLabel>
                    <FormControl>
                      <Input placeholder="Enter email" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="password"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Password</FormLabel>
                    <FormControl>
                      <Input type="password" placeholder="Enter password" {...field} />
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
}

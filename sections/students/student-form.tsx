'use client';

import * as React from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/tabs';
import { toast } from '@/components/ui/use-toast';
import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { FileUploader } from '@/components/file-uploader';

const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`;

// Schema for student
const formSchema = z.object({
  firstName: z.string().min(2, { message: 'First name must be at least 2 characters.' }),
  lastName: z.string().min(2, { message: 'Last name must be at least 2 characters.' }),
  email: z.string().email({ message: 'Please enter a valid email address.' }),
  password: z.string().min(6, { message: 'Password must be at least 6 characters.' }),
});

// Schema for file upload
const uploadSchema = z.object({
  excelFile: z
    .any()
    .refine((file) => file && file.length > 0, { message: "File is required" })
    ,
});


export default function StudentForm() {
  const session = useSession();
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

  const uploadForm = useForm<z.infer<typeof uploadSchema>>({
    resolver: zodResolver(uploadSchema),
    defaultValues: {
      excelFile: null,
    },
  });

  async function createStudent(data: { firstName: string; lastName: string; email: string; password: string }, token: string) {
    const response = await fetch(`${API_URL}/auth/signup`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    });

    if (!response.ok) {
      throw new Error('Failed to create student');
    }

    return await response.json();
  }

  async function onSubmit(values: z.infer<typeof formSchema>) {
    try {
      const access_token = session.data?.user?.access_token;
      if (!access_token) {
        throw new Error('Unauthorized');
      }

      const studentData = {
        firstName: values.firstName,
        lastName: values.lastName,
        email: values.email,
        password: values.password,
        role: 'STUD'
      };

      const res = await createStudent(studentData, access_token);

      toast({
        title: 'Success',
        description: res.message || 'Student created successfully',
        variant: 'success',
      });

      form.reset();
      router.back(); // Redirect after add
    } catch (error) {
      toast({
        title: 'Error',
        description: (error as Error)?.message || 'Failed to create student.',
        variant: 'destructive',
      });
    }
  }

  async function onUploadSubmit(data: z.infer<typeof uploadSchema>) {
    try {
      const formData = new FormData();
      formData.append('file', data.excelFile[0]);

      // console.log("Image Name: ", data.excelFile[0]);
  
      const response = await fetch(`${API_URL}/students/upload-excel`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${session.data?.user?.access_token}`,
        },
        body: formData,
      });
  
      if (!response.ok) {
        throw new Error('Failed to upload file');
      }
  
      const resData = await response.json();
      toast({
        title: 'Success',
        description: resData.message || 'File uploaded successfully',
        variant: 'success',
      });
      uploadForm.reset();
      router.back(); 
    } catch (error) {
      toast({
        title: 'Error',
        description: (error as Error)?.message || 'Failed to upload file.',
        variant: 'destructive',
      });
    }
  }
  

  return (
    <Card className="mx-auto w-full">
      <CardHeader>
        <CardTitle className="text-left text-2xl font-bold">Student Information</CardTitle>
      </CardHeader>
      <CardContent>
        <Tabs defaultValue="add" className="w-full">
          <TabsList>
            <TabsTrigger value="add">Form</TabsTrigger>
            <TabsTrigger value="upload">Upload</TabsTrigger>
          </TabsList>

          <TabsContent value="add">
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
          </TabsContent>

          <TabsContent value="upload">
            <Form {...uploadForm}>
              <form onSubmit={uploadForm.handleSubmit(onUploadSubmit)} className="space-y-8">
                <FormField
                  control={uploadForm.control}
                  name="excelFile"
                  render={({ field }) => (
                    <FormItem className="w-full space-y-4">
                      <FormLabel>Upload Excel File</FormLabel>
                      <FormControl>                        
                      <FileUploader
                        value={field.value}
                        onValueChange={field.onChange}
                        accept={{ 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': ['.xlsx'] }}
                        maxFiles={1}
                      />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <Button type="submit">Upload</Button>
              </form>
            </Form>
          </TabsContent>


        </Tabs>
      </CardContent>
    </Card>
  );
}

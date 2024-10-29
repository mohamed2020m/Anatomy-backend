'use client';

import * as React from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { toast } from '@/components/ui/use-toast';
import { useSession } from 'next-auth/react';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';

const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`

const formSchema = z.object({
  firstName: z.string().min(2, { message: 'First name must be at least 2 characters.' }),
  lastName: z.string().min(2, { message: 'Last name must be at least 2 characters.' }),
  email: z.string().email({ message: 'Please enter a valid email address.' }),
  password: z.string().min(6, { message: 'Password must be at least 6 characters.' }),
});

export default function StudentUpdate({ studentId }: { studentId: number }) {
  const { data: session } = useSession();
  const [isLoading, setIsLoading] = useState(true);
  const [categories, setCategories] = useState<{ id: number; name: string }[]>([]);
  const router = useRouter();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      firstName: '',
      lastName: '',
      email: '',
      password: '',
    }
  });


  useEffect(() => {
    const fetchStudent = async () => {
      const token = session?.user?.access_token;
      if (!token) {
        throw new Error('Unauthorized');
      }
      try {
        const response = await fetch(`${API_URL}/students/${studentId}`, {
          method: 'GET',
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch student data.');
        }

        const student = await response.json();
        form.reset({
          firstName: student.firstName,
          lastName: student.lastName,
          email: student.email,
          password: student.password,
        });
      } catch (error) {
        toast({
          title: 'Error',
          description: (error as Error)?.message || 'Failed to fetch student.',
          variant: 'destructive',
        });
      } finally {
        setIsLoading(false);
      }
    };

    fetchStudent();
  }, [studentId, session, form]);

  async function updateStudent(data: { firstName: string; lastName: string; email: string; password: string }, token: string) {
    const response = await fetch(`${API_URL}/students/${studentId}`, {
      method: 'PUT',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      throw new Error('Failed to update student');
    }

    return await response.json();
  }

  async function onSubmit(values: z.infer<typeof formSchema>) {
    try {
      const access_token = session?.user?.access_token;
      if (!access_token) {
        throw new Error('Unauthorized');
      }

      const studentData = {
        firstName: values.firstName,
        lastName: values.lastName,
        email: values.email,
        password: values.password,
      };

      const res = await updateStudent(studentData, access_token);
      
      toast({
        title: 'Success',
        description: res.message || 'Student updated successfully',
        variant: 'success',
      });

      //router.push('dashboard/student'); // Redirect after update
    } catch (error) {
      toast({
        title: 'Error',
        description: (error as Error)?.message || 'Failed to update student.',
        variant: 'destructive',
      });
    }
  }

  if (isLoading) {
    return <p>Loading...</p>;
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

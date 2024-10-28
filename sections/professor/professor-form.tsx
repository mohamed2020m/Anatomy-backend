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
import { useRouter } from 'next/navigation';


const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`;


// Define schema based
const formSchema = z.object({
  firstName: z.string().min(2, { message: 'First name must be at least 2 characters.' }),
  lastName: z.string().min(2, { message: 'Last name must be at least 2 characters.' }),
  email: z.string().email({ message: 'Please enter a valid email address.' }),
  password: z.string().min(6, { message: 'Password must be at least 6 characters.' }),
  categoryId: z.number().int().nonnegative({ message: 'Please select a category.' }),
});

export default function ProfessorForm() {
  const session = useSession();
  const [categories, setCategories] = React.useState<{ id: number; name: string }[]>([]);
  const router = useRouter();

React.useEffect(() => {
  async function fetchCategories() {
    try {
      const response = await fetch(`${API_URL}/categories/main`, {
        headers: {
          'Authorization': `Bearer ${session.data?.user.access_token}`,
          'Content-Type': 'application/json'
        },
      });
      const data = await response.json();
      setCategories(data);
    } catch (error) {
      toast({
        title: 'Error',
        description: 'Failed to fetch categories.',
        variant: 'destructive',
      });
    }
  }

  fetchCategories();
}, []);

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      firstName: '',
      lastName: '',
      email: '',
      password: ''
    }
  });

  async function createProfessor(data: { firstName: string; lastName: string; email: string; password: string; category: { id: number } }, token: string) {
    const response = await fetch(`${API_URL}/professors`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    });

    //const responseData = await response.json();
    //console.log("Response data:", responseData);

    if (!response.ok) {
      throw new Error('Failed to create professor');
    }

    return await response.json();
  }

  async function onSubmit(values: z.infer<typeof formSchema>) {
  try {
    const access_token = session.data?.user?.access_token;
    if (!access_token) {
      throw new Error('Unauthorized');
    }

    // Prepare professor data with category
    const professorData = {
      firstName: values.firstName,
      lastName: values.lastName,
      email: values.email,
      password: values.password,
      category: {
        id: values.categoryId,
      },
    };

    const res = await createProfessor(professorData, access_token);

    toast({
      title: 'Success',
      description: res.message || 'Professor created successfully',
      variant: 'success',
    });

    form.reset();
    router.push(''); // Redirect after add
  } catch (error) {
    toast({
      title: 'Error',
      description: (error as Error)?.message || 'Failed to create professor.',
      variant: 'destructive',
    });
  }
}

  return (
    <Card className="mx-auto w-full">
      <CardHeader>
        <CardTitle className="text-left text-2xl font-bold">Professor Information</CardTitle>
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
              <FormField
                control={form.control}
                name="categoryId"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Category</FormLabel>
                    <FormControl>
                      <select
                        {...field}
                        className="form-select"
                        onChange={(e) => field.onChange(parseInt(e.target.value))}
                      >
                        <option value="">Select a category</option>
                        {categories.map((category) => (
                          <option key={category.id} value={category.id}>
                            {category.name}
                          </option>
                        ))}
                      </select>
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

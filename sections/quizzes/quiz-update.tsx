'use client';

import * as React from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
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
import { toast } from '@/components/ui/use-toast';
import { useSession } from 'next-auth/react';
import { useEffect, useState } from 'react';
import { Select, SelectTrigger, SelectContent, SelectItem, SelectValue } from '@/components/ui/select';
import { useRouter } from 'next/navigation';

const APP_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`;

const formSchema = z.object({
  title: z.string().min(2, {
    message: 'Title must be at least 2 characters.'
  }),
  description: z
    .string()
    .max(255, {
      message: 'Description must not be more than 255 characters.'
    }),
  categoryId: z.string().nonempty('Please select a category.')
});

export default function QuizUpdate({ quizId }: { quizId: number }) {
  const { data: session } = useSession();
  const router = useRouter();
  const [categories, setCategories] = useState<{ id: number; name: string }[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      title: '',
      description: '',
      categoryId: ''
    }
  });

  useEffect(() => {
    const fetchQuiz = async () => {
      const token = session?.user?.access_token;
      if (!token) {
        toast({
          title: 'Error',
          description: 'Unauthorized.',
          variant: 'destructive'
        });
        return;
      }

      try {
        const response = await fetch(`${APP_URL}/quizzes/${quizId}`, {
          headers: {
            Authorization: `Bearer ${token}`
          }
        });

        if (!response.ok) {
          throw new Error('Failed to fetch quiz data.');
        }

        const quiz = await response.json();
        form.reset({
          title: quiz.title,
          description: quiz.description,
          categoryId: quiz.subCategory?.id.toString() || ''
        });
      } catch (error) {
        toast({
          title: 'Error',
          description: (error as Error).message || 'Failed to fetch quiz.',
          variant: 'destructive'
        });
      } finally {
        setIsLoading(false);
      }
    };

    const fetchCategories = async () => {
      const token = session?.user?.access_token;
      if (!token) return;

      try {
        const response = await fetch(`${APP_URL}/professors/${session?.user.id}/sub-categories`, {
          headers: {
            Authorization: `Bearer ${token}`
          }
        });

        const data = await response.json();
        setCategories(data);
      } catch (error) {
        toast({
          title: 'Error',
          description: 'Failed to fetch categories.',
          variant: 'destructive'
        });
      }
    };

    fetchQuiz();
    fetchCategories();
  }, [session, quizId, form]);

  const onSubmit = async (values: z.infer<typeof formSchema>) => {
    const token = session?.user?.access_token;
    if (!token) {
      toast({
        title: 'Error',
        description: 'Unauthorized.',
        variant: 'destructive'
      });
      return;
    }

    try {
      const response = await fetch(`${APP_URL}/quizzes/${quizId}`, {
        method: 'PATCH',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          title: values.title,
          description: values.description,
          subCategory: { id: Number(values.categoryId) }
        })
      });

      if (!response.ok) {
        throw new Error('Failed to update quiz.');
      }

      const result = await response.json();

      toast({
        title: 'Success',
        description: 'Quiz updated successfully.',
        variant: 'success'
      });

      router.push('/prof/quiz');
    } catch (error) {
      toast({
        title: 'Error',
        description: (error as Error).message || 'Failed to update quiz.',
        variant: 'destructive'
      });
    }
  };

  if (isLoading) {
    return <p>Loading...</p>;
  }

  return (
    <Card className="mx-auto w-full">
      <CardHeader>
        <CardTitle className="text-left text-2xl font-bold">Update Quiz</CardTitle>
      </CardHeader>
      <CardContent>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
            <FormField
              control={form.control}
              name="title"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Title</FormLabel>
                  <FormControl>
                    <Input placeholder="Enter the quiz title" {...field} />
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
                      placeholder="Enter the quiz description"
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
              name="categoryId"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Category</FormLabel>
                  <FormControl>
                    <Select
                      onValueChange={field.onChange}
                      value={field.value}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Select category" />
                      </SelectTrigger>
                      <SelectContent>
                        {categories.map((category) => (
                          <SelectItem key={category.id} value={category.id.toString()}>
                            {category.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <Button type="submit">Update Quiz</Button>
          </form>
        </Form>
      </CardContent>
    </Card>
  );
}

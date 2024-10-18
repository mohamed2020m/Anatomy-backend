'use client';
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
import { zodResolver } from '@hookform/resolvers/zod';
import { signIn } from 'next-auth/react';
// import { signIn } from "@/auth"
import { useSearchParams } from 'next/navigation';
import { useState, useTransition } from 'react';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import GoogleSignInButton from './google-auth-button';

import { Icons } from '@/components/icons';

const formSchema = z.object({
  email: z.string().email({ message: 'Enter a valid email address' }),
  password: z
    .string()
    .min(6, { message: 'Password must be at least 6 characters long' })
});

type UserFormValue = z.infer<typeof formSchema>;

export default function UserAuthForm() {
  const searchParams = useSearchParams();
  const callbackUrl = searchParams.get('callbackUrl');
  const [loading, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);

  const defaultValues = {
    // email: 'demo@gmail.com',
    // password: 'password123'
  };

  const form = useForm<UserFormValue>({
    resolver: zodResolver(formSchema),
    defaultValues
  });

  const onSubmit = async (data: UserFormValue) => {
    // startTransition(() => {
    //   signIn('credentials', {
    //     email: data.email,
    //     password: data.password,
    //     callbackUrl: callbackUrl ?? '/dashboard'
    //   });
    // });

    // startTransition(async () => {
    //   const result = await signIn('credentials', {
    //     email: data.email,
    //     password: data.password,
    //     callbackUrl: callbackUrl ?? '/dashboard',
    //     redirect: false, // Don't redirect automatically
    //   });

    //   if (result?.error) {
    //     // Set error message from response or a default one
    //     setError('Invalid email or password. Please try again.');
    //   }
    // });

    startTransition(async () => {
      const result = await signIn('credentials', {
        email: data.email,
        password: data.password,
        callbackUrl: callbackUrl ?? '/dashboard',
        redirect: false
      });

      if (result?.error) {
        setError('Invalid email or password. Please try again.');
      } else {
        window.location.href = result?.url || '/dashboard';
      }
    });
  };

  return (
    <>
      <Form {...form}>
        <form
          onSubmit={form.handleSubmit(onSubmit)}
          className="w-full space-y-2"
        >
          <FormField
            control={form.control}
            name="email"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Email</FormLabel>
                <FormControl>
                  <Input
                    type="email"
                    placeholder="Enter your email"
                    disabled={loading}
                    {...field}
                  />
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
                  <Input
                    type="password"
                    placeholder="Enter your password"
                    disabled={loading}
                    {...field}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />

          {error && (
            <div
              className="mb-5 flex items-center text-sm text-red-600"
              style={{ 'margin-bottom': '20px' }}
            >
              <Icons.shieldX className="mr-2" />
              <p>{error}</p>
            </div>
          )}
          <Button disabled={loading} className="ml-auto w-full" type="submit">
            Sign in
            <Icons.login className="ml-2" />
          </Button>
        </form>
      </Form>
      <div className="relative">
        <div className="absolute inset-0 flex items-center">
          <span className="w-full border-t" />
        </div>
        <div className="relative flex justify-center text-xs uppercase">
          <span className="bg-background px-2 text-muted-foreground">
            Or continue with
          </span>
        </div>
      </div>
      <GoogleSignInButton />
    </>
  );
}

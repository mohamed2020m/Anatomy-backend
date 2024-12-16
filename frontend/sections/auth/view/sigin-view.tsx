import { Metadata } from 'next';
import Link from 'next/link';
import UserAuthForm from '../user-auth-form';
import { buttonVariants } from '@/components/ui/button';
import { cn } from '@/lib/utils';
import Mesh3D from '@/components/Mesh3D';
import Image from 'next/image';

export const metadata: Metadata = {
  title: 'Authentication',
  description: 'Authentication forms built using the components.'
};

export default function SignInViewPage() {
  return (
    <div className="relative h-screen flex-col items-center justify-center md:grid lg:max-w-none lg:grid-cols-2 lg:px-0">
      <Link
        href="/examples/authentication"
        className={cn(
          buttonVariants({ variant: 'ghost' }),
          'absolute right-4 top-4 hidden md:right-8 md:top-8'
        )}
      >
        Login
      </Link>
      <div className="relative hidden h-full flex-col bg-gray-900 bg-muted p-10 text-white lg:flex dark:border-r">
        {/* bg-zinc-900  */}
        <div className="absolute inset-0 bg-gray-900" />
        <div className="relative z-20 flex items-center text-lg font-medium">
          <Image
            src="/logo.png"
            alt="AnatoLearn Logo"
            width={24}
            height={24}
            className="mr-2 h-6 w-6"
          />
          AnatoLearn
        </div>
        <div className="relative z-20 mt-auto">
          <Mesh3D />
        </div>
      </div>
      <div className="flex h-full items-center overflow-y-auto p-4 lg:p-8">
        <div className="mx-auto flex w-full flex-col justify-center space-y-6 sm:w-[350px]">
          <div className="flex justify-center">
            <Image
              src="/logo.png"
              alt="AnatoLearn Logo"
              width={50}
              height={50}
              className="mr-2"
            />
          </div>
          <div className="mb-3 flex flex-col space-y-2 text-center">
            <h1 className="text-2xl font-semibold tracking-tight">
              Sign in to your account
            </h1>
            <p className="text-sm text-muted-foreground">
              Enter your email below to Sign in to your account.
            </p>
          </div>
          <UserAuthForm />
          <p className="px-8 text-center text-sm text-muted-foreground">
            By clicking continue, you agree to our{' '}
            <Link
              href="/terms"
              className="underline underline-offset-4 hover:text-primary"
            >
              Terms of Service
            </Link>{' '}
            and{' '}
            <Link
              href="/privacy"
              className="underline underline-offset-4 hover:text-primary"
            >
              Privacy Policy
            </Link>
            .
          </p>
        </div>
      </div>
    </div>
  );
}

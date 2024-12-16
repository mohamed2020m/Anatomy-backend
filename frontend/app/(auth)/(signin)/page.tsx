import { SignInViewPage } from '@/sections/auth/view';
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Med3dExplorer | Sign In',
  description: 'Sign In page for authentication.',
  icons: 'logo.png'
};

export default function Page() {
  return <SignInViewPage />;
}

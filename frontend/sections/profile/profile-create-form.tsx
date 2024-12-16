'use client';

import { useEffect, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { useToast } from '@/components/ui/use-toast';
import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { Heading } from '@/components/ui/heading';

const initialUserData = {
  id: '1',
  firstName: 'firstName',
  lastName: 'lastName',
  email: 'email@example.com',
  createdAt: '01-07-2002',
  category: { name: 'category' }
};

const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`;

export default function UserProfile() {
  const { data: session } = useSession();
  const router = useRouter();
  const [userData, setUserData] = useState(initialUserData);
  const { toast } = useToast();
  const [isPending, setIsPending] = useState(false);
  const [role, setRole] = useState('');

  const handleInputChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { name, value } = e.target;
    setUserData((prev) => ({ ...prev, [name]: value }));
  };

  useEffect(() => {
    const fetchMyInfo = async () => {
      if (!session?.user?.access_token) {
        toast({
          title: 'Error',
          description: 'Unauthorized.',
          variant: 'destructive'
        });
        return;
      }
      const token = session?.user?.access_token;

      try {
        const response = await fetch(`${API_URL}/me`, {
          method: 'GET',
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });

        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const data = await response.json();
        setUserData(data);
        setRole(session?.user?.role || ''); // Set role after fetching user data
      } catch (error) {
        toast({
          title: 'Error',
          description: (error as Error).message || 'Failed to fetch MyInfo.',
          variant: 'destructive'
        });
      }
    };

    if (session?.user?.access_token) {
      fetchMyInfo();
    }
  }, [session, toast]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const token = session?.user?.access_token;

    if (!token) {
      toast({
        title: 'Error',
        description: 'Unauthorized.',
        variant: 'destructive'
      });
      return;
    }

    setIsPending(true);

    try {
      // Update the role before making the request
      const updatedRole =
        role === 'ROLE_PROF' ? 'professors' : 'administrators';
      setRole(updatedRole); // Ensure role is updated

      const response = await fetch(`${API_URL}/${updatedRole}/${userData.id}`, {
        method: 'PUT',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          firstName: userData.firstName,
          lastName: userData.lastName
        })
      });

      if (!response.ok) {
        throw new Error('Failed to update profile.');
      }

      const result = await response.json();
      setUserData(result);

      toast({
        title: 'Success',
        description: 'Profile updated successfully.',
        variant: 'success'
      });
    } catch (error) {
      toast({
        title: 'Error',
        description: (error as Error).message || 'Failed to update profile.',
        variant: 'destructive'
      });
    } finally {
      setIsPending(false);
    }
  };

  return (
    <div className="mx-auto max-w-2xl space-y-8 rounded-lg bg-background p-6 shadow-lg">
      <Heading
        title="Update Your Profile"
        description="Please update your profile information to keep it up-to-date."
      />
      <form onSubmit={handleSubmit} className="space-y-6">
        {/* First Name and Last Name */}
        <div className="flex gap-4">
          <div className="flex-1">
            <Label htmlFor="firstName" className="text-lg font-medium">
              First Name
            </Label>
            <Input
              id="firstName"
              name="firstName"
              value={userData.firstName}
              onChange={handleInputChange}
              placeholder="Enter your first name"
            />
          </div>

          <div className="flex-1">
            <Label htmlFor="lastName" className="text-lg font-medium">
              Last Name
            </Label>
            <Input
              id="lastName"
              name="lastName"
              value={userData.lastName}
              onChange={handleInputChange}
              placeholder="Enter your last name"
            />
          </div>
        </div>

        {/* Email */}
        <div className="flex flex-col gap-2">
          <Label htmlFor="email" className="text-lg font-medium">
            Email
          </Label>
          <Input
            id="email"
            name="email"
            type="email"
            value={userData.email}
            onChange={handleInputChange}
            disabled
            placeholder="Email (read-only)"
          />
        </div>

        {/* Creation Date */}
        <div className="flex flex-col gap-2">
          <Label htmlFor="createdAt" className="text-lg font-medium">
            Creation Date
          </Label>
          <Input
            id="createdAt"
            name="createdAt"
            type="text"
            value={formatDate(userData.createdAt)}
            onChange={handleInputChange}
            disabled
            placeholder="Creation Date (read-only)"
          />
        </div>

        {/* Category */}
        {role == 'ROLE_PROF' ? (
          <div className="flex flex-col gap-2">
            <Label htmlFor="category" className="text-lg font-medium">
              Category
            </Label>
            <Input
              id="category"
              name="category"
              type="text"
              value={userData.category?.name || ''}
              onChange={handleInputChange}
              disabled
              placeholder="Category (read-only)"
            />
          </div>
        ) : (
          <></>
        )}

        {/* Submit Button */}
        <div className="flex justify-center">
          <SubmitButton isPending={isPending} />
        </div>
      </form>
    </div>
  );
}

function SubmitButton({ isPending }: { isPending: boolean }) {
  return (
    <Button type="submit" disabled={isPending} className="w-full max-w-xs">
      {isPending ? 'Updating...' : 'Update Profile'}
    </Button>
  );
}

function formatDate(dateInput) {
  const date = new Date(dateInput);
  const options = {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: true
  };

  return date.toLocaleString('en-US', options);
}

'use client';
import { AlertModal } from '@/components/modal/alert-modal';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu';
import { Edit, MoreHorizontal, Trash } from 'lucide-react';
import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { useSession } from 'next-auth/react';
import { toast } from '@/components/ui/use-toast';

const APP_URL = 'http://localhost:8080/api/v1/threeDObjects';

interface CellActionProps {
  data: { id: string; image: string };
}

export const CellAction: React.FC<CellActionProps> = ({ data }) => {
  const session = useSession();
  const [loading, setLoading] = useState(false);
  const [open, setOpen] = useState(false);
  const router = useRouter();

  const onConfirm = async () => {
    setLoading(true);
    try {
      const access_token = session.data?.user?.access_token;

      if (!access_token) {
        throw new Error('Unauthorized');
      }

      const deleteUrl = `${APP_URL}/${data.id}`;
      console.log("DELETE URL:", deleteUrl);  // Log URL for debugging

      const response = await fetch(deleteUrl, {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${access_token}`,
        },
      });

      if (!response.ok) {
        throw new Error('Failed to delete the 3D object');
      }

      // Show success toast
      toast({
        title: 'Success',
        description: '3D object deleted successfully!',
        variant: 'success',
      });

      setOpen(false);
      router.refresh();

    } catch (error) {
      console.error("Error:", error);

      // Show error toast
      toast({
        title: 'Error',
        description: (error as Error)?.message || 'Failed to delete the 3D object.',
        variant: 'destructive',
      });

    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <AlertModal
        isOpen={open}
        onClose={() => setOpen(false)}
        onConfirm={onConfirm}
        loading={loading}
      />
      <DropdownMenu modal={false}>
        <DropdownMenuTrigger asChild>
          <Button variant="ghost" className="h-8 w-8 p-0">
            <span className="sr-only">Open menu</span>
            <MoreHorizontal className="h-4 w-4" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end">
          <DropdownMenuLabel>Actions</DropdownMenuLabel>

          <DropdownMenuItem
            onClick={() => router.push(`/prof/threedobjects/show/${data.id}`)}
          >
            <Edit className="mr-2 h-4 w-4" /> View
          </DropdownMenuItem>

          <DropdownMenuItem
            onClick={() => router.push(`/prof/threedobjects/update/${data.id}`)}
          >
            <Edit className="mr-2 h-4 w-4" /> Update
          </DropdownMenuItem>
          <DropdownMenuItem onClick={() => setOpen(true)}>
            <Trash className="mr-2 h-4 w-4" /> Delete
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </>
  );
};

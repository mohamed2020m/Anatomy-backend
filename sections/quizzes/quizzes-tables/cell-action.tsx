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
import { Quiz } from '@/constants/data';
import { CircleHelp, Edit, Eye, MoreHorizontal, Trash } from 'lucide-react';
import { useParams, useRouter } from 'next/navigation';
import { useState } from 'react';
import { useSession } from 'next-auth/react';
import { toast } from '@/components/ui/use-toast';

const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`;

interface CellActionProps {
  data: Quiz;
}

export const CellAction: React.FC<CellActionProps> = ({ data }) => {
  const session = useSession();
  const [loading, setLoading] = useState(false);
  const [open, setOpen] = useState(false);
  const router = useRouter();

  

  const onConfirm = async () => {
    try {
      const access_token = session.data?.user?.access_token;

      if (!access_token) {
        throw new Error('Unauthorized');
      }

      

      const response = await fetch(`${API_URL}/quizzes/${data.id}`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${access_token}`
        }
      });

      if (!response.ok) {
        throw new Error('Failed to delete quiz');
      }

      // Show success toast
      toast({
        title: 'Success',
        description: `Quiz deleted successfully!`,
        variant: 'success',
      });

      setOpen(false);
      router.refresh();
      return true;

    } catch (error) {
      console.error("Error: ", error);

      // Show error toast
      toast({
        title: 'Error',
        description: (error as Error)?.message || 'Failed to delete quiz.',
        variant: 'destructive',
      });
      return false;
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
            onClick={() => router.push(`/prof/quiz/update/${data.id}`)}
          >
            <Edit className="mr-2 h-4 w-4" /> Update
          </DropdownMenuItem>

          <DropdownMenuItem
            onClick={() => router.push(`/prof/quiz/showQuestion/${data.id}`)}
          >
            <CircleHelp className="mr-2 h-4 w-4" /> Questions
          </DropdownMenuItem>

          <DropdownMenuItem onClick={() => setOpen(true)}>
            <Trash className="mr-2 h-4 w-4" /> Delete
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </>
  );
};

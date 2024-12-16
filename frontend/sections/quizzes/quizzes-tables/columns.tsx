'use client';
import { Checkbox } from '@/components/ui/checkbox';
import { Quiz } from '@/constants/data';
import { ColumnDef } from '@tanstack/react-table';
import { CellAction } from './cell-action';
import Image from 'next/image';

export const columns: ColumnDef<Quiz>[] = [
  {
    id: 'select',
    header: ({ table }) => (
      <Checkbox
        checked={table.getIsAllPageRowsSelected()}
        onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
        aria-label="Select all"
      />
    ),
    cell: ({ row }) => (
      <Checkbox
        checked={row.getIsSelected()}
        onCheckedChange={(value) => row.toggleSelected(!!value)}
        aria-label="Select row"
      />
    ),
    enableSorting: false,
    enableHiding: false
  },
  
  {
    accessorKey: 'title',
    header: 'TITLE'
  },
  {
    accessorKey: 'description',
    header: 'DESCRIPTION'
  },{
    accessorKey: 'subCategory.name',
    header: 'SUBCATEGORY'
  },
  {
    accessorKey: 'createdAt',
    header: 'CREATED AT'
  },
  {
    id: 'actions',
    cell: ({ row }) => <CellAction data={row.original} />
  }
];
 
'use client';

import { searchParams } from '@/lib/searchparams';
import { useQueryState } from 'nuqs';
import { useCallback, useMemo, useState, useEffect } from 'react';
import { useSession } from 'next-auth/react';
import { toast } from '@/components/ui/use-toast';

export function useStudentsTableFilters() {
  const { data: session } = useSession();
  const [searchQuery, setSearchQuery] = useQueryState(
    'q',
    searchParams.q
      .withOptions({ shallow: false, throttleMs: 1000 })
      .withDefault('')
  );

  const [categories, setCategories] = useState<{ id: number; name: string }[]>([]);

  const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`;

  useEffect(() => {
    const fetchCategories = async () => {
      if (!session) return;
      try {
        const response = await fetch(`${API_URL}/categories/main`, {
          headers: {
            'Authorization': `Bearer ${session.user.access_token}`,
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
    };
    fetchCategories();
  }, []);

  const [categoryFilter, setCategoryFilter] = useQueryState(
    'category',
    searchParams.category.withOptions({ shallow: false }).withDefault('')
  );

  const [page, setPage] = useQueryState(
    'page',
    searchParams.page.withDefault(1)
  );

  const resetFilters = useCallback(() => {
    setSearchQuery(null);
    setCategoryFilter(null);
    setPage(1);
  }, [setSearchQuery, setCategoryFilter, setPage]);

  const isAnyFilterActive = useMemo(() => {
    return !!searchQuery || !!categoryFilter;
  }, [searchQuery, categoryFilter]);

  return {
    searchQuery,
    setSearchQuery,
    categoryFilter,
    setCategoryFilter,
    page,
    setPage,
    resetFilters,
    isAnyFilterActive,
    categories // Return categories
  };
}

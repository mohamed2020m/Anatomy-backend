import { Breadcrumbs } from '@/components/breadcrumbs';
import PageContainer from '@/components/layout/page-container';
import CategoriesTable from '../3d-objects-tables';
import { buttonVariants } from '@/components/ui/button';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import { ThreeDObject } from '@/constants/data';
import { fakeCategories } from '@/constants/mock-api';
import { searchParamsCache } from '@/lib/searchparams';
import { cn } from '@/lib/utils';
import { Plus } from 'lucide-react';
import Link from 'next/link';
import { categoriesService } from '@/services/3d-object';

const breadcrumbItems = [
  { title: 'Dashboard', link: '/prof/dashboard' },
  { title: '3D Objects', link: '/prof/threedobjects' }
];



type TCategoriesListingPage = {};

export default async function CategoriesListingPage({}: TCategoriesListingPage) {
  
  // Showcasing the use of search params cache in nested RSCs
  const page = searchParamsCache.get('page');
  const search = searchParamsCache.get('q');
  const gender = searchParamsCache.get('gender');
  const pageLimit = searchParamsCache.get('limit');

  const filters = {
    page,
    limit: pageLimit,
    ...(search && { search }),
    ...(gender && { genders: gender })
  };

  // const cs = await categoriesService.getCategories(filters);
  // console.log("categories: ", cs);

  // get data from the service
  await categoriesService.initialize();
  const data = await categoriesService.getCategories(filters);
  const totalCategories = data.total_categories;
  const categories: ThreeDObject[] = data.categories;
  console.log("categories: ", categories);
  
  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Breadcrumbs items={breadcrumbItems} />

        <div className="flex items-start justify-between">
          <Heading
            title={`Categories (${totalCategories})`}
            description="Manage categoriess"
          />

          <Link
            href={'/dashboard/categories/new'}
            className={cn(buttonVariants({ variant: 'default' }))}
          >
            <Plus className="mr-2 h-4 w-4" /> Add New
          </Link>
        </div>
        <Separator />
        <CategoriesTable data={categories} totalData={totalCategories} />
      </div>
    </PageContainer>
  );
}

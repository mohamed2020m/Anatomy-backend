import { Breadcrumbs } from '@/components/breadcrumbs';
import { ScrollArea } from '@/components/ui/scroll-area';
import CategoriesForm from '../categories-form';
import CategoryUpdate from '../category-update';
import PageContainer from '@/components/layout/page-container';

const breadcrumbItems = [
  { title: 'Dashboard', link: '/dashboard' },
  { title: 'Categories', link: '/dashboard/categories' },
  { title: 'Create', link: '/dashboard/categories/create' }
];

interface CategoriesViewPageProps {
  categoryId?: number;
}

export default function CategoriesViewPage({ categoryId }: CategoriesViewPageProps) {
  return (
    <>
      <div className="flex-1 space-y-4 px-8">
        <Breadcrumbs items={breadcrumbItems} />
      </div>
      <PageContainer scrollable>
        <div className="flex-1 space-y-4 p-8">
          {categoryId ?
            <CategoryUpdate categoryId={categoryId} />
            :
            <CategoriesForm />
          }
        </div>
      </PageContainer>
    </>
    // <ScrollArea className="h-full">
    // </ScrollArea>
  );
}

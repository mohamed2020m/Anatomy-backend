import { Breadcrumbs } from '@/components/breadcrumbs';
import { ScrollArea } from '@/components/ui/scroll-area';
import CategoriesForm from '../3d-objects-form';
import CategoryUpdate from '../3d-objects-update';
import PageContainer from '@/components/layout/page-container';



const breadcrumbItems = [
  { title: 'Dashboard', link: '/prof' },
  { title: '3D Objects', link: '/prof/threedobjects' },
  { title: 'Create', link: '/prof/threedobjects/create' }
];


interface CategoriesViewPageProps {
  categoryId?: number;
}

export default async function CategoriesViewPage({ categoryId }: CategoriesViewPageProps) {

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

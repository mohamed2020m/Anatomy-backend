import { Breadcrumbs } from '@/components/breadcrumbs';
import { ScrollArea } from '@/components/ui/scroll-area';
import ThreeDObjectsForm from '../3d-objects-form';
import ThreeDObjectView from '../3d-object-view';
import PageContainer from '@/components/layout/page-container';
import { getSession } from 'next-auth/react';

const breadcrumbItems = [
  { title: 'Dashboard', link: '/prof' },
  { title: '3D Objects', link: '/prof/threedobjects' },
  { title: 'View 3D Object', link: '/prof/threedobjects/show' },
  { title: 'Create', link: '/prof/threedobjects/create' }
];

interface ThreeDObjectsViewPageProps {
  objectId?: number;
}

export default function ThreeDObjectsViewPage({
  objectId
}: ThreeDObjectsViewPageProps) {
  return (
    <>
      <div className="flex-1 space-y-4 px-8">
        <Breadcrumbs items={breadcrumbItems} />
      </div>
      <PageContainer scrollable>
        <div className="flex-1 space-y-4 p-8">
          {objectId==null ? (
            <ThreeDObjectsForm />
          ) : (
            <ThreeDObjectView objectId={objectId} />
          )}
        </div>
      </PageContainer>
    </>
  );
}

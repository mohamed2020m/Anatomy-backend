import { Breadcrumbs } from '@/components/breadcrumbs';
import { ScrollArea } from '@/components/ui/scroll-area';
import AdminForm from '../admin-form';
import AdminUpdate from '../admin-update';
import PageContainer from '@/components/layout/page-container';

const breadcrumbItems = [
  { title: 'Dashboard', link: '/admin' },
  { title: 'admin', link: '/admin/administrators' },
  { title: 'Create', link: '/admin/administrators/create' }
];

interface adminViewPageProps {
  adminId?: number;
}

export default function professorViewPage({ adminId }: adminViewPageProps) {
  return (
    <>
      <div className="flex-1 space-y-4 px-8">
        <Breadcrumbs items={breadcrumbItems} />
      </div>
      <PageContainer scrollable>
        <div className="flex-1 space-y-4 p-8">
          {adminId ?
            <AdminUpdate professorId={adminId} />
            :
            <AdminForm />
          }
        </div>
      </PageContainer>
    </>
    // <ScrollArea className="h-full">
    // </ScrollArea>
  );
}

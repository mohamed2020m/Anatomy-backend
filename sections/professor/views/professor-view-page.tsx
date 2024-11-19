import { Breadcrumbs } from '@/components/breadcrumbs';
import { ScrollArea } from '@/components/ui/scroll-area';
import ProfessorForm from '../professor-form';
import ProfessorUpdate from '../professor-update';
import PageContainer from '@/components/layout/page-container';

const breadcrumbItems = [
  { title: 'Dashboard', link: '/admin' },
<<<<<<< HEAD
  { title: 'Professors', link: '/admin/professor' },
  { title: 'Create', link: '/admin/professor/create' }
=======
  { title: 'Professors', link: '/admin/professors' },
  { title: 'Create', link: '/admin/professors/create' }
>>>>>>> 0ab838df3b6f8d3ee1034473e929d0be1503456e
];

interface professorViewPageProps {
  professorId?: number;
}

export default function professorViewPage({ professorId }: professorViewPageProps) {
  return (
    <>
      <div className="flex-1 space-y-4 px-8">
        <Breadcrumbs items={breadcrumbItems} />
      </div>
      <PageContainer scrollable>
        <div className="flex-1 space-y-4 p-8">
          {professorId ?
            <ProfessorUpdate professorId={professorId} />
            :
            <ProfessorForm />
          }
        </div>
      </PageContainer>
    </>
    // <ScrollArea className="h-full">
    // </ScrollArea>
  );
}

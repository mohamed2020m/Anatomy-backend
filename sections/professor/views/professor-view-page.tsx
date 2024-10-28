import { Breadcrumbs } from '@/components/breadcrumbs';
import { ScrollArea } from '@/components/ui/scroll-area';
import ProfessorForm from '../professor-form';
import ProfessorUpdate from '../professor-update';
import PageContainer from '@/components/layout/page-container';

const breadcrumbItems = [
  { title: 'Dashboard', link: '/dashboard' },
  { title: 'Professor', link: '/dashboard/professor' },
  { title: 'Create', link: '/dashboard/professor/create' }
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

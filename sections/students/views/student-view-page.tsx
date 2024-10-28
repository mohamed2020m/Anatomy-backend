import { Breadcrumbs } from '@/components/breadcrumbs';
import { ScrollArea } from '@/components/ui/scroll-area';
import StudentForm from '../student-form';
import StudentUpdate from '../student-update';
import PageContainer from '@/components/layout/page-container';

const breadcrumbItems = [
  { title: 'Dashboard', link: '/admin' },
  { title: 'Student', link: '/admin/students' },
  { title: 'Create', link: '/admin/students/create' }
];

interface studentViewPageProps {
  studentId?: number;
}

export default function professorViewPage({ studentId }: studentViewPageProps) {
  return (
    <>
      <div className="flex-1 space-y-4 px-8">
        <Breadcrumbs items={breadcrumbItems} />
      </div>
      <PageContainer scrollable>
        <div className="flex-1 space-y-4 p-8">
          {studentId ?
            <StudentUpdate studentId={studentId} />
            :
            <StudentForm />
          }
        </div>
      </PageContainer>
    </>
    // <ScrollArea className="h-full">
    // </ScrollArea>
  );
}

import { Breadcrumbs } from '@/components/breadcrumbs';
import PageContainer from '@/components/layout/page-container';
import ProfessorsTable from '../student-tables';
import { buttonVariants } from '@/components/ui/button';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import { Student } from '@/constants/data';
import { searchParamsCache } from '@/lib/searchparams';
import { cn } from '@/lib/utils';
import { Plus } from 'lucide-react';
import Link from 'next/link';
import { studentService } from '@/services/student';


const breadcrumbItems = [
  { title: 'Dashboard', link: '/admin' },
  { title: 'Students', link: '/admin/students' }
];

type TProfessorsListingPage = {};

export default async function ProfessorsListingPage({}: TProfessorsListingPage) {
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

  
  // get data from the service
  await studentService.initialize();
  const data = await studentService.getStudents(filters);
  const totalStudents = data.total_students;
  const students: Student[] = data.students;
  console.log("Students: ", students);
  
  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Breadcrumbs items={breadcrumbItems} />

        <div className="flex items-start justify-between">
          <Heading
            title={`Students (${totalStudents})`}
            description="Manage students"
          />

          <Link
            href={'/admin/students/new'}
            className={cn(buttonVariants({ variant: 'default' }))}
          >
            <Plus className="mr-2 h-4 w-4" /> Add New
          </Link>
        </div>
        <Separator />
        <ProfessorsTable data={students} totalData={totalStudents} />
      </div>
    </PageContainer>
  );
}

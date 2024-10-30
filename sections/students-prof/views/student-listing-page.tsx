import { Breadcrumbs } from '@/components/breadcrumbs';
import PageContainer from '@/components/layout/page-container';
import ProfessorsTable from '../student-tables';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import { Student } from '@/constants/data';
import { searchParamsCache } from '@/lib/searchparams';
import { studentService } from '@/services/student';

const breadcrumbItems = [
  { title: 'Dashboard', link: '/prof' },
  { title: 'Students', link: '/prof/students' }
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

  // // Create a new student
  // const newStudent = {
  //   email: 'creation@example.com',
  //   firstName: 'Creation',
  //   lastName: 'Test',
  //   password: 'abderrahmane'
  // };

  // // Call the createStudent method
  // const createdStudent = await studentService.createStudent(newStudent);

  // console.log('Created student:', createdStudent);
  
  // console.log("Students: ", students);
  
  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Breadcrumbs items={breadcrumbItems} />

        <div className="flex items-start justify-between">
          <Heading
            title={`Students (${totalStudents})`}
            description="Manage students"
          />

        </div>
        <Separator />
        <ProfessorsTable data={students} totalData={totalStudents} />
      </div>
    </PageContainer>
  );
}

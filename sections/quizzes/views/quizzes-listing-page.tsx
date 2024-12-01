import { Breadcrumbs } from '@/components/breadcrumbs';
import PageContainer from '@/components/layout/page-container';
import QuizzesTable from '../quizzes-tables';
import { buttonVariants } from '@/components/ui/button';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import {Quiz } from '@/constants/data';
import { searchParamsCache } from '@/lib/searchparams';
import { cn } from '@/lib/utils';
import { Plus } from 'lucide-react';
import Link from 'next/link';
import { quizzesService } from '@/services/quiz';
import getServerSession from 'next-auth';
import authConfig from '../../../auth.config'
import { Session } from '../../../types/next-auth'

// const breadcrumbItems = [
//   { title: 'Dashboard', link: '/dashboard' },
//   { title: 'Quizzes', link: '/dashboard/quizzes' }
// ];

// Get the session token
const getUserRole= async () => {
  const session = await getServerSession(authConfig);
  const auth : Session = await session.auth();
  
  return auth.user.role;
}


type TQuizzesListingPage = {};

export default async function QuizzesListingPage({}: TQuizzesListingPage) {
  const userRole = await getUserRole()

  const path = userRole === 'ROLE_ADMIN' ? '/admin' : '/prof';

  const breadcrumbItems = [
    { title: 'Dashboard', link: `${path}/dashboard` },
    { title: 'Quizzes', link: `${path}/quizzes` }
  ];

  
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

  // const cs = await quizzesService.getQuizzes(filters);
  // console.log("quizzes: ", cs);

  // get data from the service
  await quizzesService.initialize();
  const data = await quizzesService.getQuizzes(filters);
  const totalQuizzes = data.total_quizzes;
  const quizzes: Quiz[] = data.quizzes;
  console.log("quizzes: ", quizzes);
  
  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Breadcrumbs items={breadcrumbItems} />

        <div className="flex items-start justify-between">
          <Heading
            title={`Quizzes (${totalQuizzes})`}
            description="Manage quizzes"
          />

          <Link
            href={'/prof/quiz/new'}
            className={cn(buttonVariants({ variant: 'default' }))}
          >
            <Plus className="mr-2 h-4 w-4" /> Add New
          </Link>
        </div>
        <Separator />
        <QuizzesTable data={quizzes} totalData={totalQuizzes} />
      </div>
    </PageContainer>
  );
}

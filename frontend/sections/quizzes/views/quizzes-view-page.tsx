import { Breadcrumbs } from '@/components/breadcrumbs';
import { ScrollArea } from '@/components/ui/scroll-area';
import QuizzesForm from '../quizzes-form';
import CategoryUpdate from '../quiz-update';
import PageContainer from '@/components/layout/page-container';
import getServerSession from 'next-auth';
import authConfig from '../../../auth.config'
import { Session } from '../../../types/next-auth'
import QuizUpdate from '../quiz-update';


// Get the session token
const getUserRole= async () => {
  const session = await getServerSession(authConfig);
  const auth : Session = await session.auth();
  
  return auth.user.role;
}

interface QuizzesViewPageProps {
  quizId?: number;
}

export default async function QuizzesViewPage({ quizId }: QuizzesViewPageProps) {
  const userRole = await getUserRole()

  const path = userRole === 'ROLE_ADMIN' ? '/admin' : '/prof';

  const breadcrumbItems = [
    { title: 'Dashboard', link: `${path}/dashboard` },
    { title: 'Quizzes', link: `${path}/quizzes` },
    { title: 'Create', link:  `${path}/quizzes/create`}
  ];

  return (
    <>
      <div className="flex-1 space-y-4 px-8">
        <Breadcrumbs items={breadcrumbItems} />
      </div>
      <PageContainer scrollable>
        <div className="flex-1 space-y-4 p-8">
          {quizId ?
            <QuizUpdate quizId={quizId} />
            :
            <QuizzesForm />
          }
        </div>
      </PageContainer>
    </>

  );
}

import { Breadcrumbs } from '@/components/breadcrumbs';
import QuizzesForm from '../quizzes-form';
import CategoryUpdate from '../quiz-update';
import PageContainer from '@/components/layout/page-container';
import getServerSession from 'next-auth';
import authConfig from '../../../auth.config'
import { Session } from '../../../types/next-auth'
import QuizUpdate from '../quiz-update';
import QuestionShow from '../question-listing-page';


// Get the session token
const getUserRole= async () => {
  const session = await getServerSession(authConfig);
  const auth : Session = await session.auth();
  
  return auth.user.role;
}

interface QuestionsViewPageProps {
  quizId?: number;
}

export default async function QuestionsViewPage({ quizId }: QuestionsViewPageProps) {
  const userRole = await getUserRole()

  const path = userRole === 'ROLE_ADMIN' ? '/admin' : '/prof';

  const breadcrumbItems = [
    { title: 'Dashboard', link: `${path}/dashboard` },
    { title: 'Quizzes', link: `${path}/quiz` },
    { title: 'Questions', link:  `${path}/quizzes/create`}
  ];

  return (
    <>
      <div className="flex-1 space-y-4 px-8">
        <Breadcrumbs items={breadcrumbItems} />
      </div>
      <PageContainer scrollable>
        <div className="flex-1 space-y-4 p-8">
          {quizId ?
            <QuestionShow quizId={quizId} />
            :
            <QuizzesForm />
          }
        </div>
      </PageContainer>
    </>

  );
}

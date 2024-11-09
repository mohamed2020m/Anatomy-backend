import { Breadcrumbs } from '@/components/breadcrumbs';
import { ScrollArea } from '@/components/ui/scroll-area';
import CategoriesForm from '../categories-form';
import CategoryUpdate from '../category-update';
import PageContainer from '@/components/layout/page-container';
import getServerSession from 'next-auth';
import authConfig from '../../../auth.config'
import { Session } from '../../../types/next-auth'


// Get the session token
const getUserRole= async () => {
  const session = await getServerSession(authConfig);
  const auth : Session = await session.auth();
  
  return auth.user.role;
}

interface CategoriesViewPageProps {
  categoryId?: number;
}

export default async function CategoriesViewPage({ categoryId }: CategoriesViewPageProps) {
  const userRole = await getUserRole()

  const path = userRole === 'ROLE_ADMIN' ? '/admin' : '/prof';

  const breadcrumbItems = [
    { title: 'Dashboard', link: `${path}/dashboard` },
    { title: 'Categories', link: `${path}/categories` },
    { title: 'Create', link:  `${path}/categories/create`}
  ];

  return (
    <>
      <div className="flex-1 space-y-4 px-8">
        <Breadcrumbs items={breadcrumbItems} />
      </div>
      <PageContainer scrollable>
        <div className="flex-1 space-y-4 p-8">
          {categoryId ?
            <CategoryUpdate categoryId={categoryId} />
            :
            <CategoriesForm />
          }
        </div>
      </PageContainer>
    </>
    // <ScrollArea className="h-full">
    // </ScrollArea>
  );
}

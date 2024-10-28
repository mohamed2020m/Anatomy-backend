import { Breadcrumbs } from '@/components/breadcrumbs';
import PageContainer from '@/components/layout/page-container';
import ProfessorsTable from '../admin-tables';
import { buttonVariants } from '@/components/ui/button';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import { Admin } from '@/constants/data';
import { searchParamsCache } from '@/lib/searchparams';
import { cn } from '@/lib/utils';
import { Plus } from 'lucide-react';
import Link from 'next/link';
import { adminsService } from '@/services/admin';


const breadcrumbItems = [
  { title: 'Dashboard', link: '/admin' },
  { title: 'Administrators', link: '/admin/administrators' }
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
  await adminsService.initialize();
  const data = await adminsService.getAdmins(filters);
  const totalProfessors = data.total_admins;
  const admins: Admin[] = data.admins;
  console.log("admins: ", admins);
  
  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Breadcrumbs items={breadcrumbItems} />

        <div className="flex items-start justify-between">
          <Heading
            title={`Administrators (${totalProfessors})`}
            description="Manage admins"
          />

          <Link
            href={'/admin/administrators/new'}
            className={cn(buttonVariants({ variant: 'default' }))}
          >
            <Plus className="mr-2 h-4 w-4" /> Add New
          </Link>
        </div>
        <Separator />
        <ProfessorsTable data={admins} totalData={totalProfessors} />
      </div>
    </PageContainer>
  );
}

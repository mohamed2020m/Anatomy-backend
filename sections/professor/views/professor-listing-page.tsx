import { Breadcrumbs } from '@/components/breadcrumbs';
import PageContainer from '@/components/layout/page-container';
import ProfessorsTable from '../professor-tables';
import { buttonVariants } from '@/components/ui/button';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import { Professor } from '@/constants/data';
import { searchParamsCache } from '@/lib/searchparams';
import { cn } from '@/lib/utils';
import { Plus } from 'lucide-react';
import Link from 'next/link';
import { professorsService } from '@/services/professor';


const breadcrumbItems = [
  { title: 'Dashboard', link: '/admin' },
  { title: 'Professor', link: '/admin/professor' }
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
  await professorsService.initialize();
  const data = await professorsService.getProfessors(filters);
  const totalProfessors = data.total_professors;
  const professors: Professor[] = data.professors;
  console.log("professors: ", professors);
  
  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Breadcrumbs items={breadcrumbItems} />

        <div className="flex items-start justify-between">
          <Heading
            title={`Professors (${totalProfessors})`}
            description="Manage professorss"
          />

          <Link
            href={'/admin/professor/new'}
            className={cn(buttonVariants({ variant: 'default' }))}
          >
            <Plus className="mr-2 h-4 w-4" /> Add New
          </Link>
        </div>
        <Separator />
        <ProfessorsTable data={professors} totalData={totalProfessors} />
      </div>
    </PageContainer>
  );
}

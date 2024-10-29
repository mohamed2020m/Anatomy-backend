import { StudentsListingPage } from '@/sections/students-prof/views';

export const metadata = {
    title: 'Update Category | AnatoLearn',
    icons: '/logo.png'
};

export default function Page({ params} : {params: { studentId: number }}) {
    return <StudentsListingPage studentId={params.studentId}/>;
}

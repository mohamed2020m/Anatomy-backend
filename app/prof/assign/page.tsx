import StudentCategoryAssignment from '@/sections/student-assigne/index';


export const metadata = {
    title: 'Med3D Explorer | Student assignments',
    icons: '/logo.png'
};

export default async function Page() {
    
    return <StudentCategoryAssignment />;
}

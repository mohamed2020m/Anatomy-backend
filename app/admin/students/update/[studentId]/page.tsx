import { StudentViewPage } from '@/sections/students/views';

export const metadata = {
    title: 'Update Student | Med3D Explorer',
    icons: '/logo.png'
};

export default function Page({ params} : {params: { studentId: number }}) {
    return <StudentViewPage studentId={params.studentId}/>;
}

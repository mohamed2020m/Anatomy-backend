import { ProfessorViewPage } from '@/sections/professor/views';

export const metadata = {
    title: 'Update Professor | Med3D Explorer',
    icons: '/logo.png'
};

export default function Page({ params} : {params: { professorId: number }}) {
    return <ProfessorViewPage professorId={params.professorId}/>;
}

import { QuizzesViewPage } from '@/sections/quizzes/views';

export const metadata = {
    title: 'Update Quiz | TerraViva',
    icons: '/logo.png'
};

export default function Page({ params} : {params: { quizId: number }}) {
    return <QuizzesViewPage quizId={params.quizId}/>;
}

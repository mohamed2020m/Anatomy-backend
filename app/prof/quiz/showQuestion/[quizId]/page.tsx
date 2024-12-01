import { QuestionsViewPage} from '@/sections/quizzes/views';

export const metadata = {
    title: 'Display the quiz questions | TerraViva',
    icons: '/logo.png'
};

export default function Page({ params} : {params: { quizId: number }}) {
    return <QuestionsViewPage quizId={params.quizId}/>;
}

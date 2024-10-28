import { CategoriesViewPage } from '@/sections/categories/views';

export const metadata = {
    title: 'Update Category | AnatoLearn',
    icons: '/logo.png'
};

export default function Page({ params} : {params: { categoryId: number }}) {
    return <CategoriesViewPage categoryId={params.categoryId}/>;
}

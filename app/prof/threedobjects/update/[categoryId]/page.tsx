import { ThreeDObjectsViewPage } from '@/sections/3d-objects/views';

export const metadata = {
    title: 'Update Category | AnatoLearn',
    icons: '/logo.png'
};

export default function Page({ params} : {params: { objectId: number }}) {
    return <ThreeDObjectsViewPage objectId={params.objectId}/>;
}

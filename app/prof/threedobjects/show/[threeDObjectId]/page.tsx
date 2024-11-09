import { ThreeDObjectsViewPage } from '@/sections/3d-objects/views';

export const metadata = {
    title: 'View 3D-Object | AnatoLearn',
    icons: '/logo.png'
};

export default function Page({ params }: { params: {threeDObjectId: number } }) {
    return <ThreeDObjectsViewPage threeDObjectId={params.threeDObjectId} />;
}


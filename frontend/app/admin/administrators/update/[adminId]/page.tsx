import { AdminViewPage } from '@/sections/admins/views';

export const metadata = {
    title: 'Update Administrator | Med3D Explorer',
    icons: '/logo.png'
};

export default function Page({ params} : {params: { adminId: number }}) {
    return <AdminViewPage adminId={params.adminId}/>;
}

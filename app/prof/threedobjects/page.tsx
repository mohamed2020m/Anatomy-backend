import { searchParamsCache } from '@/lib/searchparams';
import { ThreeDObjectsListingPage } from '@/sections/3d-objects/views';
import { SearchParams } from 'nuqs/parsers';
import React from 'react';

type pageProps = {
    searchParams: SearchParams;
};

export const metadata = {
    title: 'AnatoLearn | 3D Objects',
    icons: '/logo.png'
};

export default async function Page({ searchParams }: pageProps) {
    // Allow nested RSCs to access the search params (in a type-safe way)
    searchParamsCache.parse(searchParams);
    return <ThreeDObjectsListingPage />;
}

import { searchParamsCache } from '@/lib/searchparams';
import { StudentsListingPage } from '@/sections/students-prof/views';
import { SearchParams } from 'nuqs/parsers';
import React from 'react';

type pageProps = {
    searchParams: SearchParams;
};

export const metadata = {
    title: 'Med3D Explorer | Students',
    icons: '/logo.png'
};

export default async function Page({ searchParams }: pageProps) {
    // Allow nested RSCs to access the search params (in a type-safe way)
    searchParamsCache.parse(searchParams);
    return <StudentsListingPage />;
}

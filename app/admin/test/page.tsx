import { searchParamsCache } from '@/lib/searchparams';
import { SearchParams } from 'nuqs/parsers';
import React from 'react';

import Test from '@/sections/test/test';


type pageProps = {
    searchParams: SearchParams;
};

export const metadata = {
    title: 'Test',
    icons: 'logo.png'
};

export default async function Page({ searchParams }: pageProps) {
    // Allow nested RSCs to access the search params (in a type-safe way)
    searchParamsCache.parse(searchParams);

    return <Test />
}

'use client';

import { DataTable } from '@/components/ui/table/data-table';
import { DataTableFilterBox } from '@/components/ui/table/data-table-filter-box';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { Category } from '@/constants/data';
import { columns } from '../3d-objects-tables/columns';
import {
  GENDER_OPTIONS,
  useCategoriesTableFilters
} from './use-categories-table-filters';

export default function CategoriesTable({
  data,
  totalData
}: {
  data: Category[];
  totalData: number;
}) {
  const {
    genderFilter,
    setGenderFilter,
    isAnyFilterActive,
    resetFilters,
    searchQuery,
    setPage,
    setSearchQuery
  } = useCategoriesTableFilters();

  return (
    <div className="space-y-4 ">
      <div className="flex flex-wrap items-center gap-4">
        <DataTableSearch
          searchKey="name"
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          setPage={setPage}
        />
        {/* <DataTableFilterBox
          filterKey="gender"
          title="Gender"
          options={GENDER_OPTIONS}
          setFilterValue={setGenderFilter}
          filterValue={genderFilter}
        />
        <DataTableResetFilter
          isFilterActive={isAnyFilterActive}
          onReset={resetFilters}
        /> */}
      </div>
      <DataTable columns={columns} data={data} totalItems={totalData} />
    </div>
  );
}
